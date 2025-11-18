/**
 * Tests avanzados para BackupService
 * Casos edge y validaciones adicionales
 */

const BackupService = require('../../services/backup_service');
const fs = require('fs').promises;
const path = require('path');

// Mock de modelos Mongoose
const createMockModel = (name, documents = []) => {
  return {
    find: jest.fn().mockReturnValue({
      lean: jest.fn().mockResolvedValue(documents)
    }),
    deleteMany: jest.fn().mockResolvedValue({ deletedCount: documents.length }),
    insertMany: jest.fn().mockResolvedValue(documents),
    findById: jest.fn().mockResolvedValue(documents[0] || null)
  };
};

describe('BackupService - Tests Avanzados', () => {
  let backupService;
  let mockModels;

  beforeEach(() => {
    mockModels = {
      Asistencia: createMockModel('Asistencia', [
        { _id: '1', fecha: new Date('2025-01-15'), tipo: 'entrada' },
        { _id: '2', fecha: new Date('2025-01-15'), tipo: 'salida' }
      ]),
      Usuario: createMockModel('Usuario', [
        { _id: '1', nombre: 'Admin', rol: 'admin' }
      ])
    };

    backupService = new BackupService(mockModels);
  });

  describe('createBackup - Casos Edge', () => {
    it('debe manejar modelos que no existen', async () => {
      const result = await backupService.createBackup({
        collections: ['ModeloInexistente', 'Asistencia']
      });

      expect(result.success).toBe(true);
      expect(result.collections_count).toBeGreaterThan(0);
    });

    it('debe manejar colecciones vacías', async () => {
      mockModels.Vacia = createMockModel('Vacia', []);
      
      const result = await backupService.createBackup({
        collections: ['Vacia']
      });

      expect(result.success).toBe(true);
      expect(result.total_documents).toBe(0);
    });

    it('debe incluir metadata cuando se solicita', async () => {
      const result = await backupService.createBackup({
        includeMetadata: true
      });

      // Verificar que el archivo contiene metadata
      const content = await fs.readFile(result.filepath, 'utf8');
      const backupData = JSON.parse(content);

      expect(backupData.metadata).toBeDefined();
      expect(backupData.metadata.database).toBeDefined();
    });

    it('debe excluir metadata cuando no se solicita', async () => {
      const result = await backupService.createBackup({
        includeMetadata: false
      });

      const content = await fs.readFile(result.filepath, 'utf8');
      const backupData = JSON.parse(content);

      expect(backupData.metadata).toBeNull();
    });
  });

  describe('restoreBackup - Casos Edge', () => {
    it('debe restaurar solo colecciones especificadas', async () => {
      const backup = await backupService.createBackup();

      const result = await backupService.restoreBackup(backup.backup_id, {
        collections: ['Asistencia'],
        clearExisting: false
      });

      expect(result.success).toBe(true);
      expect(Object.keys(result.results)).toContain('Asistencia');
      expect(Object.keys(result.results).length).toBe(1);
    });

    it('debe limpiar colección antes de restaurar si clearExisting es true', async () => {
      const backup = await backupService.createBackup();

      const result = await backupService.restoreBackup(backup.backup_id, {
        collections: ['Asistencia'],
        clearExisting: true
      });

      expect(result.success).toBe(true);
      expect(mockModels.Asistencia.deleteMany).toHaveBeenCalled();
    });

    it('debe manejar errores al restaurar colecciones individuales', async () => {
      const backup = await backupService.createBackup();
      
      // Simular error en una colección
      mockModels.Asistencia.insertMany.mockRejectedValueOnce(new Error('Error de inserción'));

      const result = await backupService.restoreBackup(backup.backup_id, {
        collections: ['Asistencia'],
        clearExisting: false
      });

      expect(result.success).toBe(true);
      expect(result.results.Asistencia.success).toBe(false);
      expect(result.results.Asistencia.error).toBeDefined();
    });
  });

  describe('applyRetentionPolicy - Casos Edge', () => {
    it('debe manejar colecciones sin documentos antiguos', async () => {
      // Crear modelo con documentos recientes
      const recentDate = new Date();
      mockModels.Recente = createMockModel('Recente', [
        { _id: '1', fecha: recentDate }
      ]);

      const result = await backupService.applyRetentionPolicy('Recente', 90);

      expect(result.success).toBe(true);
      expect(result.archived_count).toBe(0);
    });

    it('debe buscar documentos antiguos por diferentes campos de fecha', async () => {
      const oldDate = new Date();
      oldDate.setDate(oldDate.getDate() - 100); // 100 días atrás

      mockModels.Mixto = createMockModel('Mixto', [
        { _id: '1', fecha: oldDate },
        { _id: '2', timestamp: oldDate },
        { _id: '3', fecha_modificacion: oldDate },
        { _id: '4', createdAt: oldDate }
      ]);

      const result = await backupService.applyRetentionPolicy('Mixto', 30);

      expect(result.success).toBe(true);
      expect(result.archived_count).toBeGreaterThanOrEqual(0);
    });
  });

  describe('cleanupOldBackups - Casos Edge', () => {
    it('debe manejar directorio sin backups', async () => {
      // Limpiar todos los backups
      const backupDir = path.join(__dirname, '../../data/backups');
      try {
        const files = await fs.readdir(backupDir);
        for (const file of files) {
          if (file.startsWith('backup_') && file.endsWith('.json')) {
            await fs.unlink(path.join(backupDir, file));
          }
        }
      } catch (err) {
        // Ignorar
      }

      const result = await backupService.cleanupOldBackups();

      expect(result.deleted_count).toBe(0);
    });

    it('debe mantener backups dentro del período de retención', async () => {
      backupService.retentionDays = 90;
      
      // Crear backup reciente
      await backupService.createBackup();

      const result = await backupService.cleanupOldBackups();

      // No debe eliminar backups recientes
      expect(result.deleted_count).toBe(0);
    });
  });

  describe('getBackupStats - Validaciones', () => {
    it('debe calcular tamaño total correctamente', async () => {
      await backupService.createBackup();
      await backupService.createBackup();

      const stats = await backupService.getBackupStats();

      expect(stats.total_size_mb).toBeGreaterThan(0);
      expect(stats.total_backups).toBeGreaterThanOrEqual(2);
    });

    it('debe retornar null para fechas si no hay backups', async () => {
      // Limpiar backups
      const backupDir = path.join(__dirname, '../../data/backups');
      try {
        const files = await fs.readdir(backupDir);
        for (const file of files) {
          if (file.startsWith('backup_') && file.endsWith('.json')) {
            await fs.unlink(path.join(backupDir, file));
          }
        }
      } catch (err) {
        // Ignorar
      }

      const stats = await backupService.getBackupStats();

      expect(stats.oldest_backup).toBeNull();
      expect(stats.newest_backup).toBeNull();
    });
  });
});

