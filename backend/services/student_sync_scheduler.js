/**
 * Servicio de Scheduler para Sincronización de Estudiantes
 * US012 - Sincronización datos estudiantes
 * 
 * Programa sincronización automática de datos de estudiantes desde BD externa
 */

const cron = require('node-cron');

class StudentSyncScheduler {
  constructor(studentSyncService) {
    this._syncService = studentSyncService;
    this.isRunning = false;
    this.scheduledJobs = [];
    this.syncHistory = [];
  }

  /**
   * Inicia el scheduler con configuración por defecto
   */
  start() {
    if (this.isRunning) {
      console.log('⚠️ Scheduler ya está en ejecución');
      return;
    }

    // Sincronización diaria completa a las 2:00 AM
    const dailySync = cron.schedule('0 2 * * *', async () => {
      console.log('🔄 Iniciando sincronización diaria de estudiantes...');
      await this.performFullSync();
    }, {
      scheduled: true,
      timezone: "America/Lima"
    });

    // Sincronización incremental cada 6 horas
    const incrementalSync = cron.schedule('0 */6 * * *', async () => {
      console.log('🔄 Iniciando sincronización incremental de estudiantes...');
      await this.performIncrementalSync();
    }, {
      scheduled: true,
      timezone: "America/Lima"
    });

    this.scheduledJobs.push(dailySync, incrementalSync);
    this.isRunning = true;

    console.log('✅ Scheduler de sincronización iniciado');
    console.log('   - Sincronización completa: Diaria a las 2:00 AM');
    console.log('   - Sincronización incremental: Cada 6 horas');
  }

  /**
   * Detiene el scheduler
   */
  stop() {
    this.scheduledJobs.forEach(job => job.stop());
    this.scheduledJobs = [];
    this.isRunning = false;
    console.log('⏹️ Scheduler de sincronización detenido');
  }

  /**
   * Realiza sincronización completa de estudiantes
   */
  async performFullSync() {
    const startTime = new Date();
    let success = false;
    let error = null;
    let recordsSynced = 0;

    try {
      console.log('📚 Iniciando sincronización completa...');
      
      if (!this._syncService) {
        throw new Error('Servicio de sincronización no disponible');
      }

      const result = await this._syncService.syncAllStudents();
      recordsSynced = result.syncedCount || 0;
      success = true;

      console.log(`✅ Sincronización completa exitosa: ${recordsSynced} registros`);
    } catch (err) {
      error = err.message;
      console.error('❌ Error en sincronización completa:', err);
    } finally {
      const endTime = new Date();
      const duration = endTime - startTime;

      this.syncHistory.push({
        type: 'full',
        startTime,
        endTime,
        duration,
        success,
        error,
        recordsSynced
      });

      // Mantener solo últimos 100 registros
      if (this.syncHistory.length > 100) {
        this.syncHistory.shift();
      }
    }
  }

  /**
   * Realiza sincronización incremental (solo cambios)
   */
  async performIncrementalSync() {
    const startTime = new Date();
    let success = false;
    let error = null;
    let recordsSynced = 0;

    try {
      console.log('📚 Iniciando sincronización incremental...');
      
      if (!this._syncService) {
        throw new Error('Servicio de sincronización no disponible');
      }

      const result = await this._syncService.syncChangedStudents();
      recordsSynced = result.syncedCount || 0;
      success = true;

      console.log(`✅ Sincronización incremental exitosa: ${recordsSynced} registros`);
    } catch (err) {
      error = err.message;
      console.error('❌ Error en sincronización incremental:', err);
    } finally {
      const endTime = new Date();
      const duration = endTime - startTime;

      this.syncHistory.push({
        type: 'incremental',
        startTime,
        endTime,
        duration,
        success,
        error,
        recordsSynced
      });

      // Mantener solo últimos 100 registros
      if (this.syncHistory.length > 100) {
        this.syncHistory.shift();
      }
    }
  }

  /**
   * Obtiene el historial de sincronizaciones
   */
  getSyncHistory(limit = 50) {
    return this.syncHistory.slice(-limit);
  }

  /**
   * Obtiene estadísticas del scheduler
   */
  getStatistics() {
    const total = this.syncHistory.length;
    const successful = this.syncHistory.filter(h => h.success).length;
    const failed = total - successful;
    const totalRecords = this.syncHistory.reduce((sum, h) => sum + (h.recordsSynced || 0), 0);
    const avgDuration = total > 0 
      ? this.syncHistory.reduce((sum, h) => sum + h.duration, 0) / total 
      : 0;

    return {
      isRunning: this.isRunning,
      totalSyncs: total,
      successful,
      failed,
      successRate: total > 0 ? (successful / total * 100).toFixed(2) : 0,
      totalRecordsSynced: totalRecords,
      averageDuration: Math.round(avgDuration),
      lastSync: this.syncHistory.length > 0 ? this.syncHistory[this.syncHistory.length - 1] : null
    };
  }

  /**
   * Configura schedule personalizado
   */
  configureSchedule(config) {
    this.stop();

    const { 
      fullSyncSchedule = '0 2 * * *',  // Diario a las 2 AM por defecto
      incrementalSyncSchedule = '0 */6 * * *',  // Cada 6 horas por defecto
      enabled = true
    } = config;

    if (!enabled) {
      console.log('⏸️ Scheduler deshabilitado');
      return;
    }

    // Sincronización completa
    const dailySync = cron.schedule(fullSyncSchedule, async () => {
      await this.performFullSync();
    }, {
      scheduled: true,
      timezone: "America/Lima"
    });

    // Sincronización incremental
    const incrementalSync = cron.schedule(incrementalSyncSchedule, async () => {
      await this.performIncrementalSync();
    }, {
      scheduled: true,
      timezone: "America/Lima"
    });

    this.scheduledJobs.push(dailySync, incrementalSync);
    this.isRunning = true;

    console.log('✅ Scheduler configurado:');
    console.log(`   - Sincronización completa: ${fullSyncSchedule}`);
    console.log(`   - Sincronización incremental: ${incrementalSyncSchedule}`);
  }
}

module.exports = StudentSyncScheduler;

