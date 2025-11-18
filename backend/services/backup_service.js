/**
 * Servicio de Backup Automático y Retención de Datos
 * US027, US030 - Backup automático y políticas de retención
 */

const mongoose = require('mongoose');
const fs = require('fs').promises;
const path = require('path');
const { v4: uuidv4 } = require('uuid');

class BackupService {
  constructor(models) {
    this.models = models; // { Asistencia, Usuario, Alumno, etc. }
    this.backupDir = path.join(__dirname, '../data/backups');
    this.retentionDays = 90; // Retener backups por 90 días por defecto
    this.autoBackupEnabled = true;
    this.backupIntervalHours = 6; // Backup cada 6 horas
    this.backupTimer = null;
    this.ensureBackupDirectory();
  }

  /**
   * Asegurar que el directorio de backups existe
   */
  async ensureBackupDirectory() {
    try {
      await fs.mkdir(this.backupDir, { recursive: true });
      console.log('✅ Directorio de backups creado/verificado');
    } catch (err) {
      console.error('❌ Error creando directorio de backups:', err);
    }
  }

  /**
   * Crear backup completo de todas las colecciones
   */
  async createBackup(options = {}) {
    try {
      const { 
        includeMetadata = true,
        compress = false,
        collections = null // null = todas las colecciones
      } = options;

      const backupId = uuidv4();
      const timestamp = new Date();
      const backupData = {
        backup_id: backupId,
        timestamp: timestamp.toISOString(),
        version: '1.0',
        metadata: includeMetadata ? {
          database: mongoose.connection.name,
          host: mongoose.connection.host,
          collections_backed_up: []
        } : null,
        collections: {}
      };

      // Lista de colecciones a respaldar
      const collectionsToBackup = collections || Object.keys(this.models);

      // Respaldar cada colección
      for (const collectionName of collectionsToBackup) {
        const Model = this.models[collectionName];
        if (!Model) {
          console.warn(`⚠️ Modelo ${collectionName} no encontrado, omitiendo...`);
          continue;
        }

        try {
          const documents = await Model.find({}).lean();
          backupData.collections[collectionName] = documents;
          
          if (includeMetadata) {
            backupData.metadata.collections_backed_up.push({
              name: collectionName,
              count: documents.length
            });
          }

          console.log(`✅ Respaldada colección ${collectionName}: ${documents.length} documentos`);
        } catch (err) {
          console.error(`❌ Error respaldando ${collectionName}:`, err);
          backupData.collections[collectionName] = {
            error: err.message,
            count: 0
          };
        }
      }

      // Guardar backup en archivo
      const filename = `backup_${timestamp.toISOString().replace(/:/g, '-')}_${backupId}.json`;
      const filepath = path.join(this.backupDir, filename);
      
      await fs.writeFile(filepath, JSON.stringify(backupData, null, 2), 'utf8');

      // Calcular tamaño del archivo
      const stats = await fs.stat(filepath);
      const fileSizeMB = (stats.size / (1024 * 1024)).toFixed(2);

      console.log(`✅ Backup creado: ${filename} (${fileSizeMB} MB)`);

      // Limpiar backups antiguos
      await this.cleanupOldBackups();

      return {
        success: true,
        backup_id: backupId,
        filename: filename,
        filepath: filepath,
        size_mb: parseFloat(fileSizeMB),
        collections_count: Object.keys(backupData.collections).length,
        total_documents: Object.values(backupData.collections).reduce((sum, docs) => {
          return sum + (Array.isArray(docs) ? docs.length : 0);
        }, 0),
        timestamp: timestamp
      };
    } catch (err) {
      console.error('❌ Error creando backup:', err);
      throw err;
    }
  }

  /**
   * Limpiar backups antiguos según política de retención
   */
  async cleanupOldBackups() {
    try {
      const files = await fs.readdir(this.backupDir);
      const backupFiles = files.filter(f => f.startsWith('backup_') && f.endsWith('.json'));
      
      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - this.retentionDays);

      let deletedCount = 0;
      let totalSizeFreed = 0;

      for (const file of backupFiles) {
        try {
          const filepath = path.join(this.backupDir, file);
          const stats = await fs.stat(filepath);
          const fileDate = stats.mtime;

          if (fileDate < cutoffDate) {
            await fs.unlink(filepath);
            deletedCount++;
            totalSizeFreed += stats.size;
            console.log(`🗑️ Backup antiguo eliminado: ${file}`);
          }
        } catch (err) {
          console.error(`❌ Error eliminando backup ${file}:`, err);
        }
      }

      if (deletedCount > 0) {
        const sizeFreedMB = (totalSizeFreed / (1024 * 1024)).toFixed(2);
        console.log(`✅ Limpieza completada: ${deletedCount} backups eliminados, ${sizeFreedMB} MB liberados`);
      }

      return {
        deleted_count: deletedCount,
        size_freed_mb: parseFloat((totalSizeFreed / (1024 * 1024)).toFixed(2))
      };
    } catch (err) {
      console.error('❌ Error limpiando backups antiguos:', err);
      throw err;
    }
  }

  /**
   * Listar backups disponibles
   */
  async listBackups() {
    try {
      const files = await fs.readdir(this.backupDir);
      const backupFiles = files.filter(f => f.startsWith('backup_') && f.endsWith('.json'));
      
      const backups = [];

      for (const file of backupFiles) {
        try {
          const filepath = path.join(this.backupDir, file);
          const stats = await fs.stat(filepath);
          const content = await fs.readFile(filepath, 'utf8');
          const backupData = JSON.parse(content);

          backups.push({
            filename: file,
            filepath: filepath,
            backup_id: backupData.backup_id,
            timestamp: backupData.timestamp,
            size_mb: parseFloat((stats.size / (1024 * 1024)).toFixed(2)),
            collections_count: Object.keys(backupData.collections || {}).length,
            total_documents: Object.values(backupData.collections || {}).reduce((sum, docs) => {
              return sum + (Array.isArray(docs) ? docs.length : 0);
            }, 0)
          });
        } catch (err) {
          console.error(`❌ Error procesando backup ${file}:`, err);
        }
      }

      // Ordenar por timestamp (más reciente primero)
      backups.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

      return backups;
    } catch (err) {
      console.error('❌ Error listando backups:', err);
      throw err;
    }
  }

  /**
   * Restaurar desde un backup
   */
  async restoreBackup(backupId, options = {}) {
    try {
      const { 
        collections = null, // null = todas las colecciones
        clearExisting = false // Si true, elimina documentos existentes antes de restaurar
      } = options;

      // Buscar archivo de backup
      const backups = await this.listBackups();
      const backup = backups.find(b => b.backup_id === backupId || b.filename.includes(backupId));

      if (!backup) {
        throw new Error(`Backup no encontrado: ${backupId}`);
      }

      // Leer backup
      const content = await fs.readFile(backup.filepath, 'utf8');
      const backupData = JSON.parse(content);

      const collectionsToRestore = collections || Object.keys(backupData.collections);
      const restoreResults = {};

      // Restaurar cada colección
      for (const collectionName of collectionsToRestore) {
        const Model = this.models[collectionName];
        if (!Model) {
          console.warn(`⚠️ Modelo ${collectionName} no encontrado, omitiendo...`);
          continue;
        }

        const documents = backupData.collections[collectionName];
        if (!Array.isArray(documents)) {
          console.warn(`⚠️ Colección ${collectionName} no tiene documentos válidos, omitiendo...`);
          continue;
        }

        try {
          // Limpiar colección si se solicita
          if (clearExisting) {
            await Model.deleteMany({});
            console.log(`🗑️ Colección ${collectionName} limpiada`);
          }

          // Insertar documentos
          if (documents.length > 0) {
            await Model.insertMany(documents, { ordered: false });
            console.log(`✅ Restaurada colección ${collectionName}: ${documents.length} documentos`);
          }

          restoreResults[collectionName] = {
            success: true,
            restored_count: documents.length
          };
        } catch (err) {
          console.error(`❌ Error restaurando ${collectionName}:`, err);
          restoreResults[collectionName] = {
            success: false,
            error: err.message,
            restored_count: 0
          };
        }
      }

      return {
        success: true,
        backup_id: backupId,
        timestamp: new Date().toISOString(),
        results: restoreResults
      };
    } catch (err) {
      console.error('❌ Error restaurando backup:', err);
      throw err;
    }
  }

  /**
   * Configurar backup automático
   */
  configureAutoBackup({ enabled = true, intervalHours = 6, retentionDays = 90 }) {
    this.autoBackupEnabled = enabled;
    this.backupIntervalHours = intervalHours;
    this.retentionDays = retentionDays;

    // Cancelar timer existente
    if (this.backupTimer) {
      clearInterval(this.backupTimer);
      this.backupTimer = null;
    }

    // Programar backup automático si está habilitado
    if (enabled) {
      const intervalMs = intervalHours * 60 * 60 * 1000;
      
      // Crear backup inmediato
      this.createBackup().catch(err => {
        console.error('❌ Error en backup automático inicial:', err);
      });

      // Programar backups periódicos
      this.backupTimer = setInterval(() => {
        this.createBackup().catch(err => {
          console.error('❌ Error en backup automático:', err);
        });
      }, intervalMs);

      console.log(`✅ Backup automático configurado: cada ${intervalHours} horas, retención: ${retentionDays} días`);
    } else {
      console.log('📋 Backup automático deshabilitado');
    }
  }

  /**
   * Obtener estadísticas de backups
   */
  async getBackupStats() {
    try {
      const backups = await this.listBackups();
      const totalSize = backups.reduce((sum, b) => sum + (b.size_mb * 1024 * 1024), 0);
      const totalSizeMB = (totalSize / (1024 * 1024)).toFixed(2);

      return {
        total_backups: backups.length,
        total_size_mb: parseFloat(totalSizeMB),
        oldest_backup: backups.length > 0 ? backups[backups.length - 1].timestamp : null,
        newest_backup: backups.length > 0 ? backups[0].timestamp : null,
        auto_backup_enabled: this.autoBackupEnabled,
        backup_interval_hours: this.backupIntervalHours,
        retention_days: this.retentionDays
      };
    } catch (err) {
      console.error('❌ Error obteniendo estadísticas de backup:', err);
      throw err;
    }
  }

  /**
   * Aplicar política de retención de datos (archivar documentos antiguos)
   */
  async applyRetentionPolicy(collectionName, retentionDays) {
    try {
      const Model = this.models[collectionName];
      if (!Model) {
        throw new Error(`Modelo ${collectionName} no encontrado`);
      }

      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - retentionDays);

      // Buscar documentos antiguos (asumiendo que tienen campo 'fecha' o 'timestamp')
      const oldDocuments = await Model.find({
        $or: [
          { fecha: { $lt: cutoffDate } },
          { timestamp: { $lt: cutoffDate } },
          { fecha_modificacion: { $lt: cutoffDate } },
          { createdAt: { $lt: cutoffDate } }
        ]
      }).lean();

      if (oldDocuments.length === 0) {
        return {
          success: true,
          archived_count: 0,
          message: 'No hay documentos antiguos para archivar'
        };
      }

      // Guardar en archivo de archivo
      const archiveDir = path.join(__dirname, '../data/archived');
      await fs.mkdir(archiveDir, { recursive: true });

      const archiveFilename = `archive_${collectionName}_${new Date().toISOString().replace(/:/g, '-')}.json`;
      const archiveFilepath = path.join(archiveDir, archiveFilename);

      await fs.writeFile(archiveFilepath, JSON.stringify(oldDocuments, null, 2), 'utf8');

      // Eliminar documentos antiguos de la colección
      const deleteResult = await Model.deleteMany({
        $or: [
          { fecha: { $lt: cutoffDate } },
          { timestamp: { $lt: cutoffDate } },
          { fecha_modificacion: { $lt: cutoffDate } },
          { createdAt: { $lt: cutoffDate } }
        ]
      });

      console.log(`✅ Archivados ${deleteResult.deletedCount} documentos de ${collectionName}`);

      return {
        success: true,
        archived_count: deleteResult.deletedCount,
        archive_file: archiveFilename,
        cutoff_date: cutoffDate.toISOString()
      };
    } catch (err) {
      console.error(`❌ Error aplicando política de retención para ${collectionName}:`, err);
      throw err;
    }
  }
}

module.exports = BackupService;

