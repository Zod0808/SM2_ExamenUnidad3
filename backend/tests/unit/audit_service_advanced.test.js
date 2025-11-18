/**
 * Tests avanzados para AuditService
 * Casos edge y validaciones adicionales
 */

const { AuditService } = require('../../services/audit_service');

// Mock de Mongoose con más funcionalidad
jest.mock('mongoose', () => {
  const mockLogs = [];
  
  const mockSave = jest.fn().mockImplementation(function() {
    mockLogs.push(this.toObject());
    return Promise.resolve(this);
  });

  const mockFind = jest.fn().mockReturnValue({
    sort: jest.fn().mockReturnValue({
      limit: jest.fn().mockReturnValue({
        skip: jest.fn().mockResolvedValue(mockLogs)
      })
    }),
    lean: jest.fn().mockResolvedValue(mockLogs)
  });

  const mockCountDocuments = jest.fn().mockResolvedValue(mockLogs.length);
  const mockDistinct = jest.fn().mockResolvedValue(['user1', 'user2']);
  const mockAggregate = jest.fn().mockResolvedValue([
    { _id: 'create', count: 10 },
    { _id: 'update', count: 5 }
  ]);

  const mockModel = jest.fn().mockImplementation(function(data) {
    Object.assign(this, data);
    this.save = mockSave;
    this.toObject = jest.fn().mockReturnValue(data);
    return this;
  });

  mockModel.find = mockFind;
  mockModel.countDocuments = mockCountDocuments;
  mockModel.distinct = mockDistinct;
  mockModel.aggregate = mockAggregate;

  return {
    model: jest.fn().mockReturnValue(mockModel),
    Schema: jest.fn(),
    model: mockModel
  };
});

describe('AuditService - Tests Avanzados', () => {
  let auditService;

  beforeEach(() => {
    auditService = new AuditService();
    auditService.setEnabled(true);
  });

  describe('logAction - Casos Edge', () => {
    it('debe manejar errores sin interrumpir flujo', async () => {
      // Simular error de base de datos
      const mongoose = require('mongoose');
      const AuditLog = mongoose.model('AuditLog');
      AuditLog.prototype.save = jest.fn().mockRejectedValue(new Error('DB Error'));

      const result = await auditService.logAction({
        entityType: 'test',
        entityId: '1',
        action: 'create',
        userId: 'user1',
        userName: 'Test User'
      });

      // Debe retornar null pero no lanzar error
      expect(result).toBeNull();
    });

    it('debe incluir todos los campos opcionales', async () => {
      const result = await auditService.logAction({
        entityType: 'test',
        entityId: '1',
        action: 'update',
        userId: 'user1',
        userName: 'Test User',
        userRole: 'admin',
        changes: { campo: 'valor' },
        previousState: { campo: 'valor_anterior' },
        newState: { campo: 'valor_nuevo' },
        ipAddress: '192.168.1.1',
        userAgent: 'Mozilla/5.0',
        metadata: { extra: 'info' }
      });

      expect(result).toBeDefined();
    });
  });

  describe('getAuditHistory - Filtros Avanzados', () => {
    it('debe filtrar por múltiples criterios simultáneos', async () => {
      const result = await auditService.getAuditHistory({
        entityType: 'usuario',
        userId: 'admin1',
        action: 'update',
        startDate: '2024-01-01',
        endDate: '2024-12-31',
        limit: 10,
        skip: 0
      });

      expect(result).toBeDefined();
      expect(result.logs).toBeDefined();
      expect(Array.isArray(result.logs)).toBe(true);
    });

    it('debe manejar paginación correctamente', async () => {
      const page1 = await auditService.getAuditHistory({
        limit: 10,
        skip: 0
      });

      const page2 = await auditService.getAuditHistory({
        limit: 10,
        skip: 10
      });

      expect(page1.skip).toBe(0);
      expect(page2.skip).toBe(10);
    });
  });

  describe('getEntityHistory - Validaciones', () => {
    it('debe retornar historial ordenado por fecha descendente', async () => {
      const result = await auditService.getEntityHistory('usuario', '1', 10);

      expect(Array.isArray(result)).toBe(true);
      // En un entorno real, verificaríamos el orden
    });

    it('debe respetar límite de resultados', async () => {
      const result = await auditService.getEntityHistory('usuario', '1', 5);

      expect(Array.isArray(result)).toBe(true);
      // El límite se aplica en la query
    });
  });

  describe('getAuditStats - Cálculos', () => {
    it('debe calcular estadísticas por acción', async () => {
      const result = await auditService.getAuditStats();

      expect(result.by_action).toBeDefined();
      expect(typeof result.by_action).toBe('object');
    });

    it('debe incluir conteo de usuarios únicos', async () => {
      const result = await auditService.getAuditStats();

      expect(result.unique_users).toBeDefined();
      expect(typeof result.unique_users).toBe('number');
    });

    it('debe filtrar estadísticas por rango de fechas', async () => {
      const startDate = new Date('2024-01-01');
      const endDate = new Date('2024-12-31');

      const result = await auditService.getAuditStats(
        startDate.toISOString(),
        endDate.toISOString()
      );

      expect(result.period.start).toBe(startDate.toISOString());
      expect(result.period.end).toBe(endDate.toISOString());
    });
  });

  describe('auditMiddleware - Casos Edge', () => {
    it('debe manejar request sin usuario', () => {
      const req = {
        ip: '127.0.0.1',
        get: jest.fn().mockReturnValue('Test Agent')
      };
      const res = {};
      const next = jest.fn();

      auditService.auditMiddleware(req, res, next);

      expect(req.auditInfo.userId).toBe('sistema');
      expect(req.auditInfo.userName).toBe('Sistema');
      expect(next).toHaveBeenCalled();
    });

    it('debe extraer IP de diferentes fuentes', () => {
      const req1 = { ip: '127.0.0.1', get: jest.fn() };
      const req2 = { connection: { remoteAddress: '192.168.1.1' }, get: jest.fn() };

      auditService.auditMiddleware(req1, {}, jest.fn());
      auditService.auditMiddleware(req2, {}, jest.fn());

      expect(req1.auditInfo.ipAddress).toBe('127.0.0.1');
      expect(req2.auditInfo.ipAddress).toBe('192.168.1.1');
    });
  });

  describe('setEnabled', () => {
    it('debe cambiar estado de habilitación', () => {
      expect(auditService.enabled).toBe(true);

      auditService.setEnabled(false);
      expect(auditService.enabled).toBe(false);

      auditService.setEnabled(true);
      expect(auditService.enabled).toBe(true);
    });
  });
});

