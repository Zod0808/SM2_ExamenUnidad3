/**
 * Servicio de Sincronización de Estudiantes
 * US012 - Sincronización datos estudiantes
 * 
 * Sincroniza datos de estudiantes desde BD externa o API
 * Implementa detección de cambios (CDC) para sincronización incremental
 */

class StudentSyncService {
  constructor(AlumnoModel, academicDbAdapter = null) {
    this.Alumno = AlumnoModel;
    this.academicDbAdapter = academicDbAdapter;
    this.lastSyncTimestamp = null;
  }

  /**
   * Sincroniza todos los estudiantes (sincronización completa)
   */
  async syncAllStudents() {
    try {
      console.log('📚 Iniciando sincronización completa de estudiantes...');

      let students = [];
      
      // Si hay adapter de BD externa, usarlo
      if (this.academicDbAdapter) {
        students = await this.academicDbAdapter.getAllStudents();
      } else {
        // Si no, usar API (endpoint que obtiene estudiantes de BD externa)
        // Por ahora, obtener de MongoDB local
        students = await this.Alumno.find({});
        console.log('⚠️ Usando datos locales - adapter de BD externa no configurado');
      }

      let syncedCount = 0;
      let updatedCount = 0;
      let createdCount = 0;

      for (const studentData of students) {
        try {
          const existing = await this.Alumno.findOne({ 
            codigoUniversitario: studentData.codigoUniversitario 
          });

          if (existing) {
            // Manejo de conflictos: comparar timestamps
            const conflictResolution = this._resolveConflict(existing, studentData);
            
            if (conflictResolution.shouldUpdate) {
              // Actualizar existente
              await this.Alumno.updateOne(
                { codigoUniversitario: studentData.codigoUniversitario },
                { 
                  ...conflictResolution.data,
                  syncedAt: new Date(),
                  lastUpdated: new Date()
                }
              );
              updatedCount++;
            } else {
              // No actualizar (datos locales más recientes)
              console.log(`⚠️ Conflicto resuelto: manteniendo datos locales para ${studentData.codigoUniversitario}`);
            }
          } else {
            // Crear nuevo
            await this.Alumno.create({
              ...studentData,
              syncedAt: new Date(),
              lastUpdated: new Date()
            });
            createdCount++;
          }
          syncedCount++;
        } catch (err) {
          console.error(`❌ Error sincronizando estudiante ${studentData.codigoUniversitario}:`, err.message);
        }
      }

      this.lastSyncTimestamp = new Date();

      console.log(`✅ Sincronización completa: ${syncedCount} total, ${createdCount} nuevos, ${updatedCount} actualizados`);

      return {
        success: true,
        syncedCount,
        createdCount,
        updatedCount,
        timestamp: this.lastSyncTimestamp
      };
    } catch (err) {
      console.error('❌ Error en sincronización completa:', err);
      throw err;
    }
  }

  /**
   * Sincroniza solo estudiantes modificados (sincronización incremental con CDC)
   */
  async syncChangedStudents() {
    try {
      console.log('📚 Iniciando sincronización incremental de estudiantes...');

      if (!this.lastSyncTimestamp) {
        // Si no hay timestamp previo, hacer sincronización completa
        console.log('⚠️ No hay timestamp previo, realizando sincronización completa');
        return await this.syncAllStudents();
      }

      let changedStudents = [];
      
      // Si hay adapter de BD externa, obtener solo cambios
      if (this.academicDbAdapter) {
        changedStudents = await this.academicDbAdapter.getChangedStudents(this.lastSyncTimestamp);
      } else {
        // Si no hay adapter, obtener todos los estudiantes modificados desde última sync
        // Por ahora, obtener todos (en producción esto vendría de BD externa)
        changedStudents = await this.Alumno.find({
          $or: [
            { syncedAt: { $exists: false } },
            { syncedAt: { $lt: this.lastSyncTimestamp } },
            { updatedAt: { $gte: this.lastSyncTimestamp } }
          ]
        }).limit(1000); // Limitar a 1000 para evitar sobrecarga
        
        console.log('⚠️ Usando datos locales - adapter de BD externa no configurado');
      }

      let syncedCount = 0;
      let updatedCount = 0;
      let createdCount = 0;

      for (const studentData of changedStudents) {
        try {
          const existing = await this.Alumno.findOne({ 
            codigoUniversitario: studentData.codigoUniversitario 
          });

          if (existing) {
            // Manejo de conflictos: comparar timestamps
            const conflictResolution = this._resolveConflict(existing, studentData);
            
            if (conflictResolution.shouldUpdate) {
              // Actualizar existente
              await this.Alumno.updateOne(
                { codigoUniversitario: studentData.codigoUniversitario },
                { 
                  ...conflictResolution.data,
                  syncedAt: new Date(),
                  lastUpdated: new Date()
                }
              );
              updatedCount++;
            } else {
              // No actualizar (datos locales más recientes)
              console.log(`⚠️ Conflicto resuelto: manteniendo datos locales para ${studentData.codigoUniversitario}`);
            }
          } else {
            // Crear nuevo
            await this.Alumno.create({
              ...studentData,
              syncedAt: new Date(),
              lastUpdated: new Date()
            });
            createdCount++;
          }
          syncedCount++;
        } catch (err) {
          console.error(`❌ Error sincronizando estudiante ${studentData.codigoUniversitario}:`, err.message);
        }
      }

      this.lastSyncTimestamp = new Date();

      console.log(`✅ Sincronización incremental: ${syncedCount} total, ${createdCount} nuevos, ${updatedCount} actualizados`);

      return {
        success: true,
        syncedCount,
        createdCount,
        updatedCount,
        timestamp: this.lastSyncTimestamp
      };
    } catch (err) {
      console.error('❌ Error en sincronización incremental:', err);
      throw err;
    }
  }

  /**
   * Obtiene el último timestamp de sincronización
   */
  getLastSyncTimestamp() {
    return this.lastSyncTimestamp;
  }

  /**
   * Establece el último timestamp de sincronización
   */
  setLastSyncTimestamp(timestamp) {
    this.lastSyncTimestamp = timestamp;
  }

  /**
   * Resuelve conflictos entre datos locales y remotos
   * Estrategia: Si datos remotos son más recientes, actualizar. Si no, mantener locales.
   */
  _resolveConflict(existing, incoming) {
    // Obtener timestamps de última actualización
    const existingTimestamp = existing.lastUpdated || existing.updatedAt || existing.syncedAt || new Date(0);
    const incomingTimestamp = incoming.lastUpdated || incoming.updatedAt || incoming.syncedAt || new Date();
    
    // Si datos remotos son más recientes, actualizar
    if (incomingTimestamp > existingTimestamp) {
      return {
        shouldUpdate: true,
        data: incoming,
        reason: 'remote_newer'
      };
    }
    
    // Si datos locales son más recientes, mantener
    if (existingTimestamp > incomingTimestamp) {
      return {
        shouldUpdate: false,
        data: existing,
        reason: 'local_newer'
      };
    }
    
    // Si son iguales, actualizar con datos remotos (por defecto)
    return {
      shouldUpdate: true,
      data: incoming,
      reason: 'equal_timestamps'
    };
  }

  /**
   * Obtiene estadísticas de sincronización
   */
  async getSyncStatistics() {
    try {
      const total = await this.Alumno.countDocuments({});
      const synced = await this.Alumno.countDocuments({ syncedAt: { $exists: true } });
      const notSynced = total - synced;
      const lastSynced = await this.Alumno.findOne({ syncedAt: { $exists: true } })
        .sort({ syncedAt: -1 })
        .select('syncedAt');

      return {
        total,
        synced,
        notSynced,
        lastSyncTimestamp: this.lastSyncTimestamp || lastSynced?.syncedAt || null,
        syncPercentage: total > 0 ? ((synced / total) * 100).toFixed(2) : 0
      };
    } catch (err) {
      console.error('Error obteniendo estadísticas:', err);
      return {
        total: 0,
        synced: 0,
        notSynced: 0,
        lastSyncTimestamp: null,
        syncPercentage: 0
      };
    }
  }
}

module.exports = StudentSyncService;

