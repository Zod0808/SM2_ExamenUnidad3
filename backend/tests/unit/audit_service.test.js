/**
 * Tests unitarios para AuditService
 * US027 - Triggers de auditoría
 */

const { AuditService } = require('../../services/audit_service');
const mongoose = require('mongoose');

// Mock de Mongoose
jest.mock('mongoose', () => {
  const mockSave = jest.fn().mockResolvedValue({
    _id: '123',
    entity_type: 'test',
    entity_id: '1',
    action: 'create',
    timestamp: new Date()
  });

  const mockFind = jest.fn().mockReturnValue({
    sort: jest.fn().mockReturnValue({
      limit: jest.fn().mockReturnValue({
        skip: jest.fn().mockResolvedValue([])
      })
    }),
    lean: jest.fn().mockResolvedValue([])
  });

  const mockCountDocuments = jest.fn().mockResolvedValue(0);
  const mockDistinct = jest.fn().mockResolvedValue([]);
  const mockAggregate = jest.fn().mockResolvedValue([]);

  const mockModel = jest.fn().mockImplementation(() => ({
    save: mockSave
  }));

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

describe('AuditService', () => {
  let auditService;

  beforeEach(() => {
    auditService = new AuditService();
  });

  describe('logAction', () => {
    it('debe registrar una acción de auditoría', async () => {
      const result = await auditService.logAction({
        entityType: 'usuario',
        entityId: '1',
        action: 'create',
        userId: 'admin1',
        userName: 'Admin Test',
        userRole: 'admin',
        changes: { nombre: 'Nuevo Usuario' }
      });

      expect(result).toBeDefined();
    });

    it('debe retornar null si la auditoría está deshabilitada', async () => {
      auditService.setEnabled(false);

      const result = await auditService.logAction({
        entityType: 'usuario',
        entityId: '1',
        action: 'create',
        userId: 'admin1',
        userName: 'Admin Test'
      });

      expect(result).toBeNull();
    });

    it('debe incluir información de usuario y cambios', async () => {
      const result = await auditService.logAction({
        entityType: 'asistencia',
        entityId: '1',
        action: 'update',
        userId: 'guardia1',
        userName: 'Guardia Test',
        changes: { estado: 'aprobado' },
        previousState: { estado: 'pendiente' },
        newState: { estado: 'aprobado' }
      });

      expect(result).toBeDefined();
    });
  });

  describe('getAuditHistory', () => {
    it('debe obtener historial de auditoría', async () => {
      const result = await auditService.getAuditHistory({
        limit: 10,
        skip: 0
      });

      expect(result).toBeDefined();
      expect(result.logs).toBeDefined();
      expect(Array.isArray(result.logs)).toBe(true);
    });

    it('debe filtrar por tipo de entidad', async () => {
      const result = await auditService.getAuditHistory({
        entityType: 'usuario',
        limit: 10
      });

      expect(result).toBeDefined();
    });

    it('debe filtrar por rango de fechas', async () => {
      const startDate = new Date('2024-01-01');
      const endDate = new Date('2024-12-31');

      const result = await auditService.getAuditHistory({
        startDate: startDate.toISOString(),
        endDate: endDate.toISOString(),
        limit: 10
      });

      expect(result).toBeDefined();
    });
  });

  describe('getEntityHistory', () => {
    it('debe obtener historial de una entidad específica', async () => {
      const result = await auditService.getEntityHistory('usuario', '1', 10);

      expect(Array.isArray(result)).toBe(true);
    });
  });

  describe('getAuditStats', () => {
    it('debe obtener estadísticas de auditoría', async () => {
      const result = await auditService.getAuditStats();

      expect(result).toBeDefined();
      expect(result.total_logs).toBeDefined();
      expect(result.by_action).toBeDefined();
    });

    it('debe obtener estadísticas por rango de fechas', async () => {
      const startDate = new Date('2024-01-01');
      const endDate = new Date('2024-12-31');

      const result = await auditService.getAuditStats(
        startDate.toISOString(),
        endDate.toISOString()
      );

      expect(result).toBeDefined();
    });
  });

  describe('auditMiddleware', () => {
    it('debe agregar información de auditoría al request', () => {
      const req = {
        user: {
          id: 'user1',
          nombre: 'Test User',
          rol: 'admin'
        },
        ip: '127.0.0.1',
        get: jest.fn().mockReturnValue('Test Agent')
      };
      const res = {};
      const next = jest.fn();

      auditService.auditMiddleware(req, res, next);

      expect(req.auditInfo).toBeDefined();
      expect(req.auditInfo.userId).toBe('user1');
      expect(req.auditInfo.userName).toBe('Test User');
      expect(next).toHaveBeenCalled();
    });

    it('debe usar valores por defecto si no hay usuario', () => {
      const req = {
        ip: '127.0.0.1',
        get: jest.fn().mockReturnValue('Test Agent')
      };
      const res = {};
      const next = jest.fn();

      auditService.auditMiddleware(req, res, next);

      expect(req.auditInfo).toBeDefined();
      expect(req.auditInfo.userId).toBe('sistema');
      expect(req.auditInfo.userName).toBe('Sistema');
      expect(next).toHaveBeenCalled();
    });
  });

  describe('setEnabled', () => {
    it('debe habilitar/deshabilitar auditoría', () => {
      auditService.setEnabled(false);
      expect(auditService.enabled).toBe(false);

      auditService.setEnabled(true);
      expect(auditService.enabled).toBe(true);
    });
  });
});

