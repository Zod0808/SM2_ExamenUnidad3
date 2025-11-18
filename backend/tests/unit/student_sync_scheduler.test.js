/**
 * Tests unitarios para StudentSyncScheduler
 * US012 - Sincronización datos estudiantes
 */

const StudentSyncScheduler = require('../../services/student_sync_scheduler');
const cron = require('node-cron');

// Mock del servicio de sincronización
const createMockSyncService = () => {
  return {
    syncAllStudents: jest.fn().mockResolvedValue({
      success: true,
      syncedCount: 10,
      createdCount: 5,
      updatedCount: 5,
      timestamp: new Date()
    }),
    syncChangedStudents: jest.fn().mockResolvedValue({
      success: true,
      syncedCount: 3,
      createdCount: 1,
      updatedCount: 2,
      timestamp: new Date()
    })
  };
};

describe('StudentSyncScheduler', () => {
  let scheduler;
  let mockSyncService;

  beforeEach(() => {
    mockSyncService = createMockSyncService();
    scheduler = new StudentSyncScheduler(mockSyncService);
  });

  afterEach(() => {
    if (scheduler.isRunning) {
      scheduler.stop();
    }
    jest.clearAllMocks();
  });

  describe('start', () => {
    it('debe iniciar el scheduler correctamente', () => {
      scheduler.start();

      expect(scheduler.isRunning).toBe(true);
      expect(scheduler.scheduledJobs.length).toBeGreaterThan(0);
    });

    it('no debe iniciar si ya está corriendo', () => {
      scheduler.start();
      const initialJobsCount = scheduler.scheduledJobs.length;
      
      scheduler.start(); // Intentar iniciar de nuevo

      expect(scheduler.scheduledJobs.length).toBe(initialJobsCount);
    });
  });

  describe('stop', () => {
    it('debe detener el scheduler correctamente', () => {
      scheduler.start();
      expect(scheduler.isRunning).toBe(true);

      scheduler.stop();

      expect(scheduler.isRunning).toBe(false);
      expect(scheduler.scheduledJobs.length).toBe(0);
    });
  });

  describe('performFullSync', () => {
    it('debe realizar sincronización completa correctamente', async () => {
      const result = await scheduler.performFullSync();

      expect(result.success).toBe(true);
      expect(result.recordsSynced).toBe(10);
      expect(mockSyncService.syncAllStudents).toHaveBeenCalled();
      expect(scheduler.syncHistory.length).toBe(1);
    });

    it('debe registrar error en historial si falla', async () => {
      mockSyncService.syncAllStudents.mockRejectedValue(new Error('Sync failed'));

      const result = await scheduler.performFullSync();

      expect(result.success).toBe(false);
      expect(result.error).toBeDefined();
      expect(scheduler.syncHistory.length).toBe(1);
      expect(scheduler.syncHistory[0].success).toBe(false);
    });

    it('debe manejar caso cuando servicio no está disponible', async () => {
      scheduler._syncService = null;

      const result = await scheduler.performFullSync();

      expect(result.success).toBe(false);
      expect(result.error).toContain('no disponible');
    });
  });

  describe('performIncrementalSync', () => {
    it('debe realizar sincronización incremental correctamente', async () => {
      const result = await scheduler.performIncrementalSync();

      expect(result.success).toBe(true);
      expect(result.recordsSynced).toBe(3);
      expect(mockSyncService.syncChangedStudents).toHaveBeenCalled();
      expect(scheduler.syncHistory.length).toBe(1);
    });

    it('debe registrar error en historial si falla', async () => {
      mockSyncService.syncChangedStudents.mockRejectedValue(new Error('Sync failed'));

      const result = await scheduler.performIncrementalSync();

      expect(result.success).toBe(false);
      expect(result.error).toBeDefined();
      expect(scheduler.syncHistory[0].success).toBe(false);
    });
  });

  describe('getSyncHistory', () => {
    it('debe retornar historial de sincronizaciones', async () => {
      await scheduler.performFullSync();
      await scheduler.performIncrementalSync();

      const history = scheduler.getSyncHistory();

      expect(history.length).toBe(2);
      expect(history[0].type).toBe('full');
      expect(history[1].type).toBe('incremental');
    });

    it('debe limitar historial a últimos 100 registros', async () => {
      // Simular más de 100 sincronizaciones
      for (let i = 0; i < 105; i++) {
        await scheduler.performFullSync();
      }

      const history = scheduler.getSyncHistory();

      expect(history.length).toBeLessThanOrEqual(100);
    });
  });

  describe('getStatistics', () => {
    it('debe calcular estadísticas correctamente', async () => {
      await scheduler.performFullSync();
      await scheduler.performFullSync();
      await scheduler.performIncrementalSync();

      const stats = scheduler.getStatistics();

      expect(stats.totalSyncs).toBe(3);
      expect(stats.successfulSyncs).toBe(3);
      expect(stats.failedSyncs).toBe(0);
      expect(stats.totalRecordsSynced).toBeGreaterThan(0);
    });

    it('debe calcular estadísticas con fallos', async () => {
      mockSyncService.syncAllStudents
        .mockResolvedValueOnce({ success: true, syncedCount: 10 })
        .mockRejectedValueOnce(new Error('Failed'));

      await scheduler.performFullSync();
      await scheduler.performFullSync();

      const stats = scheduler.getStatistics();

      expect(stats.totalSyncs).toBe(2);
      expect(stats.successfulSyncs).toBe(1);
      expect(stats.failedSyncs).toBe(1);
    });
  });

  describe('configureSchedule', () => {
    it('debe configurar schedule personalizado', () => {
      scheduler.start();
      const initialJobsCount = scheduler.scheduledJobs.length;

      scheduler.configureSchedule({
        fullSync: '0 3 * * *', // 3 AM en lugar de 2 AM
        incrementalSync: '0 */4 * * *' // Cada 4 horas en lugar de 6
      });

      // El scheduler debe tener los nuevos jobs
      expect(scheduler.scheduledJobs.length).toBeGreaterThanOrEqual(initialJobsCount);
    });
  });
});

