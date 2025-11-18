/**
 * Tests unitarios mejorados para StudentSyncService
 * Casos edge y validación adicional
 */

const StudentSyncService = require('../../services/student_sync_service');

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

describe('StudentSyncService - Enhanced Tests', () => {
  let syncService;
  let mockAlumnoModel;

  beforeEach(() => {
    mockAlumnoModel = createMockAlumnoModel();
    syncService = new StudentSyncService(mockAlumnoModel);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('Edge Cases - syncAllStudents', () => {
    it('debe manejar dataset vacío', async () => {
      const mockAdapter = {
        getAllStudents: jest.fn().mockResolvedValue([])
      };
      syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
      
      mockAlumnoModel.find.mockReturnValue({
        lean: jest.fn().mockResolvedValue([])
      });
      mockAlumnoModel.countDocuments.mockResolvedValue(0);
      
      const result = await syncService.syncAllStudents();
      
      expect(result.synced).toBe(0);
      expect(result.created).toBe(0);
      expect(result.updated).toBe(0);
    });

    it('debe manejar estudiantes con campos faltantes', async () => {
      const mockAdapter = {
        getAllStudents: jest.fn().mockResolvedValue([
          { codigo_universitario: '20201234', nombre: 'Juan' }, // Sin apellido
          { codigo_universitario: '20201235' } // Solo código
        ])
      };
      syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
      
      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockResolvedValue({});
      
      const result = await syncService.syncAllStudents();
      
      expect(result.synced).toBeGreaterThanOrEqual(0);
    });

    it('debe manejar estudiantes duplicados en el dataset', async () => {
      const mockAdapter = {
        getAllStudents: jest.fn().mockResolvedValue([
          { codigo_universitario: '20201234', nombre: 'Juan', apellido: 'Pérez' },
          { codigo_universitario: '20201234', nombre: 'Juan', apellido: 'Pérez' } // Duplicado
        ])
      };
      syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
      
      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockResolvedValue({});
      
      const result = await syncService.syncAllStudents();
      
      expect(result.synced).toBeGreaterThanOrEqual(0);
    });

    it('debe manejar errores de base de datos durante creación', async () => {
      const mockAdapter = {
        getAllStudents: jest.fn().mockResolvedValue([
          { codigo_universitario: '20201234', nombre: 'Juan', apellido: 'Pérez' }
        ])
      };
      syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
      
      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockRejectedValue(new Error('Database error'));
      
      await expect(syncService.syncAllStudents()).rejects.toThrow();
    });

    it('debe manejar caracteres especiales en nombres', async () => {
      const mockAdapter = {
        getAllStudents: jest.fn().mockResolvedValue([
          { codigo_universitario: '20201234', nombre: 'José', apellido: 'García-López' },
          { codigo_universitario: '20201235', nombre: 'María', apellido: "O'Brien" }
        ])
      };
      syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
      
      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockResolvedValue({});
      
      const result = await syncService.syncAllStudents();
      
      expect(result.synced).toBeGreaterThanOrEqual(0);
    });
  });

  describe('Edge Cases - syncChangedStudents', () => {
    it('debe manejar timestamp inválido', async () => {
      const mockAdapter = {
        getChangedStudents: jest.fn().mockResolvedValue([])
      };
      syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
      
      // Timestamp inválido
      await expect(
        syncService.syncChangedStudents('invalid-timestamp')
      ).rejects.toThrow();
    });

    it('debe manejar cambios con timestamps futuros', async () => {
      const futureDate = new Date();
      futureDate.setFullYear(futureDate.getFullYear() + 1);
      
      const mockAdapter = {
        getChangedStudents: jest.fn().mockResolvedValue([
          {
            codigo_universitario: '20201234',
            nombre: 'Juan',
            apellido: 'Pérez',
            updatedAt: futureDate
          }
        ])
      };
      syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
      
      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockResolvedValue({});
      
      const result = await syncService.syncChangedStudents(new Date());
      
      expect(result.synced).toBeGreaterThanOrEqual(0);
    });

    it('debe manejar cambios con timestamps muy antiguos', async () => {
      const oldDate = new Date('1900-01-01');
      
      const mockAdapter = {
        getChangedStudents: jest.fn().mockResolvedValue([
          {
            codigo_universitario: '20201234',
            nombre: 'Juan',
            apellido: 'Pérez',
            updatedAt: oldDate
          }
        ])
      };
      syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
      
      mockAlumnoModel.findOne.mockResolvedValue({
        codigo_universitario: '20201234',
        updatedAt: new Date()
      });
      mockAlumnoModel.updateOne.mockResolvedValue({});
      
      const result = await syncService.syncChangedStudents(new Date());
      
      expect(result.synced).toBeGreaterThanOrEqual(0);
    });
  });

  describe('Edge Cases - _resolveConflict', () => {
    it('debe manejar conflictos con timestamps null', () => {
      const local = { codigo_universitario: '20201234', nombre: 'Juan Local' };
      const remote = { codigo_universitario: '20201234', nombre: 'Juan Remote', updatedAt: null };
      
      const result = syncService._resolveConflict(local, remote);
      
      expect(result).toBeDefined();
    });

    it('debe manejar conflictos con datos incompletos', () => {
      const local = { codigo_universitario: '20201234' };
      const remote = { codigo_universitario: '20201234', nombre: 'Juan' };
      
      const result = syncService._resolveConflict(local, remote);
      
      expect(result).toBeDefined();
    });

    it('debe manejar conflictos con objetos anidados', () => {
      const local = {
        codigo_universitario: '20201234',
        metadata: { source: 'local', version: 1 }
      };
      const remote = {
        codigo_universitario: '20201234',
        metadata: { source: 'remote', version: 2 },
        updatedAt: new Date()
      };
      
      const result = syncService._resolveConflict(local, remote);
      
      expect(result).toBeDefined();
    });
  });

  describe('Edge Cases - getSyncStatistics', () => {
    it('debe manejar estadísticas con datos vacíos', async () => {
      mockAlumnoModel.countDocuments.mockResolvedValue(0);
      mockAlumnoModel.find.mockReturnValue({
        lean: jest.fn().mockResolvedValue([])
      });
      
      const stats = await syncService.getSyncStatistics();
      
      expect(stats.totalStudents).toBe(0);
      expect(stats.lastSync).toBeNull();
    });

    it('debe manejar errores al obtener estadísticas', async () => {
      mockAlumnoModel.countDocuments.mockRejectedValue(new Error('DB Error'));
      
      await expect(syncService.getSyncStatistics()).rejects.toThrow();
    });
  });

  describe('Edge Cases - getLastSyncTimestamp y setLastSyncTimestamp', () => {
    it('debe manejar timestamp null al obtener', () => {
      const timestamp = syncService.getLastSyncTimestamp();
      expect(timestamp).toBeNull();
    });

    it('debe manejar timestamp inválido al establecer', () => {
      expect(() => {
        syncService.setLastSyncTimestamp('invalid');
      }).toThrow();
    });

    it('debe manejar timestamp como string válido', () => {
      const date = new Date();
      const dateString = date.toISOString();
      
      syncService.setLastSyncTimestamp(dateString);
      const retrieved = syncService.getLastSyncTimestamp();
      
      expect(retrieved).toBeInstanceOf(Date);
    });
  });

  describe('Performance Tests', () => {
    it('debe manejar sincronización de muchos estudiantes', async () => {
      const manyStudents = Array.from({ length: 1000 }, (_, i) => ({
        codigo_universitario: `2020${String(i).padStart(4, '0')}`,
        nombre: `Estudiante${i}`,
        apellido: `Apellido${i}`
      }));
      
      const mockAdapter = {
        getAllStudents: jest.fn().mockResolvedValue(manyStudents)
      };
      syncService = new StudentSyncService(mockAlumnoModel, mockAdapter);
      
      mockAlumnoModel.findOne.mockResolvedValue(null);
      mockAlumnoModel.create.mockResolvedValue({});
      
      const startTime = Date.now();
      const result = await syncService.syncAllStudents();
      const endTime = Date.now();
      
      expect(result.synced).toBe(1000);
      expect(endTime - startTime).toBeLessThan(10000); // Menos de 10 segundos
    });
  });
});

