/**
 * Tests unitarios para StudentSyncService
 * US012 - Sincronización datos estudiantes
 */

const StudentSyncService = require('../../services/student_sync_service');

// Mock de modelo Mongoose
const createMockAlumnoModel = () => {
  const students = [];
  
  return {
    find: jest.fn().mockReturnValue({
      lean: jest.fn().mockResolvedValue(students),
      limit: jest.fn().mockReturnThis(),
      sort: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis()
    }),
    findOne: jest.fn(),
    create: jest.fn(),
    updateOne: jest.fn(),
    countDocuments: jest.fn()
  };
};

// Mock de adapter de BD externa
const createMockAdapter = (students = []) => {
  return {
    getAllStudents: jest.fn().mockResolvedValue(students),
    getChangedStudents: jest.fn().mockResolvedValue(students)
  };
};

describe('StudentSyncService', () => {
  let syncService;
  let mockAlumnoModel;
  let mockAdapter;

  beforeEach(() => {
    mockAlumnoModel = createMockAlumnoModel();
    mockAdapter = null;
    syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('syncAllStudents', () => {
    it('debe sincronizar todos los estudiantes correctamente', async () => {
      const students = [
        {
          codigoUniversitario: '20240001',
          nombre: 'Juan',
          apellido: 'Pérez',
          dni: '12345678'
        },
        {
          codigoUniversitario: '20240002',
          nombre: 'María',
          apellido: 'García',
          dni: '87654321'
        }
      ];

      mockAlumnoModel.find().lean.mockResolvedValue(students);
      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockResolvedValue(students[0]);

      const result = await syncService.syncAllStudents();

      expect(result.success).toBe(true);
      expect(result.syncedCount).toBe(2);
      expect(result.createdCount).toBe(2);
      expect(result.updatedCount).toBe(0);
      expect(result.timestamp).toBeInstanceOf(Date);
    });

    it('debe actualizar estudiantes existentes cuando hay cambios', async () => {
      const existingStudent = {
        codigoUniversitario: '20240001',
        nombre: 'Juan',
        apellido: 'Pérez',
        lastUpdated: new Date('2024-01-01')
      };

      const newStudentData = {
        codigoUniversitario: '20240001',
        nombre: 'Juan Carlos',
        apellido: 'Pérez',
        lastUpdated: new Date('2024-01-15')
      };

      mockAlumnoModel.find().lean.mockResolvedValue([newStudentData]);
      mockAlumnoModel.findOne.mockResolvedValue(existingStudent);
      mockAlumnoModel.updateOne.mockResolvedValue({ modifiedCount: 1 });

      const result = await syncService.syncAllStudents();

      expect(result.success).toBe(true);
      expect(result.updatedCount).toBe(1);
      expect(mockAlumnoModel.updateOne).toHaveBeenCalled();
    });

    it('debe usar adapter de BD externa si está configurado', async () => {
      const adapter = createMockAdapter([
        { codigoUniversitario: '20240001', nombre: 'Juan' }
      ]);
      syncService = new StudentSyncService(mockAlumnoModel, adapter);
      
      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockResolvedValue({});

      await syncService.syncAllStudents();

      expect(adapter.getAllStudents).toHaveBeenCalled();
    });

    it('debe manejar errores durante la sincronización', async () => {
      mockAlumnoModel.find().lean.mockRejectedValue(new Error('DB Error'));

      await expect(syncService.syncAllStudents()).rejects.toThrow('DB Error');
    });
  });

  describe('syncChangedStudents', () => {
    it('debe realizar sincronización completa si no hay timestamp previo', async () => {
      syncService.lastSyncTimestamp = null;
      const syncAllSpy = jest.spyOn(syncService, 'syncAllStudents').mockResolvedValue({
        success: true,
        syncedCount: 5,
        createdCount: 3,
        updatedCount: 2,
        timestamp: new Date()
      });

      const result = await syncService.syncChangedStudents();

      expect(syncAllSpy).toHaveBeenCalled();
      expect(result.success).toBe(true);
    });

    it('debe sincronizar solo estudiantes modificados', async () => {
      const lastSync = new Date('2024-01-01');
      syncService.setLastSyncTimestamp(lastSync);

      const changedStudents = [
        {
          codigoUniversitario: '20240001',
          nombre: 'Juan',
          updatedAt: new Date('2024-01-15')
        }
      ];

      mockAlumnoModel.find.mockReturnValue({
        lean: jest.fn().mockResolvedValue(changedStudents),
        limit: jest.fn().mockReturnThis()
      });
      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockResolvedValue(changedStudents[0]);

      const result = await syncService.syncChangedStudents();

      expect(result.success).toBe(true);
      expect(result.syncedCount).toBe(1);
    });

    it('debe usar adapter para obtener cambios si está configurado', async () => {
      const adapter = createMockAdapter([
        { codigoUniversitario: '20240001', nombre: 'Juan' }
      ]);
      syncService = new StudentSyncService(mockAlumnoModel, adapter);
      syncService.setLastSyncTimestamp(new Date('2024-01-01'));

      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockResolvedValue({});

      await syncService.syncChangedStudents();

      expect(adapter.getChangedStudents).toHaveBeenCalled();
    });
  });

  describe('getLastSyncTimestamp y setLastSyncTimestamp', () => {
    it('debe obtener y establecer timestamp correctamente', () => {
      const timestamp = new Date('2024-01-15');
      
      expect(syncService.getLastSyncTimestamp()).toBeNull();
      
      syncService.setLastSyncTimestamp(timestamp);
      
      expect(syncService.getLastSyncTimestamp()).toEqual(timestamp);
    });
  });

  describe('_resolveConflict', () => {
    it('debe actualizar si datos remotos son más recientes', () => {
      const existing = {
        codigoUniversitario: '20240001',
        nombre: 'Juan',
        lastUpdated: new Date('2024-01-01')
      };

      const incoming = {
        codigoUniversitario: '20240001',
        nombre: 'Juan Carlos',
        lastUpdated: new Date('2024-01-15')
      };

      const resolution = syncService._resolveConflict(existing, incoming);

      expect(resolution.shouldUpdate).toBe(true);
      expect(resolution.reason).toBe('remote_newer');
    });

    it('debe mantener datos locales si son más recientes', () => {
      const existing = {
        codigoUniversitario: '20240001',
        nombre: 'Juan Carlos',
        lastUpdated: new Date('2024-01-15')
      };

      const incoming = {
        codigoUniversitario: '20240001',
        nombre: 'Juan',
        lastUpdated: new Date('2024-01-01')
      };

      const resolution = syncService._resolveConflict(existing, incoming);

      expect(resolution.shouldUpdate).toBe(false);
      expect(resolution.reason).toBe('local_newer');
    });

    it('debe actualizar si timestamps son iguales', () => {
      const timestamp = new Date('2024-01-01');
      const existing = {
        codigoUniversitario: '20240001',
        nombre: 'Juan',
        lastUpdated: timestamp
      };

      const incoming = {
        codigoUniversitario: '20240001',
        nombre: 'Juan Carlos',
        lastUpdated: timestamp
      };

      const resolution = syncService._resolveConflict(existing, incoming);

      expect(resolution.shouldUpdate).toBe(true);
      expect(resolution.reason).toBe('equal_timestamps');
    });
  });

  describe('getSyncStatistics', () => {
    it('debe calcular estadísticas correctamente', async () => {
      mockAlumnoModel.countDocuments
        .mockResolvedValueOnce(100) // total
        .mockResolvedValueOnce(85); // synced

      mockAlumnoModel.findOne.mockReturnValue({
        sort: jest.fn().mockReturnThis(),
        select: jest.fn().mockResolvedValue({
          syncedAt: new Date('2024-01-15')
        })
      });

      const stats = await syncService.getSyncStatistics();

      expect(stats.total).toBe(100);
      expect(stats.synced).toBe(85);
      expect(stats.notSynced).toBe(15);
      expect(parseFloat(stats.syncPercentage)).toBeCloseTo(85.0);
    });

    it('debe manejar caso cuando no hay estudiantes', async () => {
      mockAlumnoModel.countDocuments.mockResolvedValue(0);
      mockAlumnoModel.findOne.mockReturnValue({
        sort: jest.fn().mockReturnThis(),
        select: jest.fn().mockResolvedValue(null)
      });

      const stats = await syncService.getSyncStatistics();

      expect(stats.total).toBe(0);
      expect(stats.synced).toBe(0);
      expect(stats.syncPercentage).toBe('0');
    });

    it('debe manejar errores en estadísticas', async () => {
      mockAlumnoModel.countDocuments.mockRejectedValue(new Error('DB Error'));

      const stats = await syncService.getSyncStatistics();

      expect(stats.total).toBe(0);
      expect(stats.synced).toBe(0);
    });
  });
});

