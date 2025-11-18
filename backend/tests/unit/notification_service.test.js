/**
 * Tests unitarios para NotificationService
 * US007 - Activar/desactivar guardias
 */

const NotificationService = require('../../services/notification_service');

describe('NotificationService', () => {
  let notificationService;
  let originalEnv;

  beforeEach(() => {
    originalEnv = process.env.EMAIL_SERVICE_ENABLED;
    notificationService = new NotificationService();
  });

  afterEach(() => {
    process.env.EMAIL_SERVICE_ENABLED = originalEnv;
    jest.clearAllMocks();
  });

  describe('sendUserStatusNotification', () => {
    const mockUser = {
      nombre: 'Juan',
      apellido: 'Pérez',
      email: 'juan.perez@example.com'
    };

    it('debe enviar notificación de activación correctamente', async () => {
      const result = await notificationService.sendUserStatusNotification(
        mockUser,
        'activo',
        'admin123'
      );

      expect(result.success).toBe(true);
      expect(result.sent).toBe(false); // Email service no está habilitado por defecto
    });

    it('debe enviar notificación de desactivación correctamente', async () => {
      const result = await notificationService.sendUserStatusNotification(
        mockUser,
        'inactivo',
        'admin123'
      );

      expect(result.success).toBe(true);
    });

    it('debe usar servicio de email si está configurado y habilitado', async () => {
      process.env.EMAIL_SERVICE_ENABLED = 'true';
      const mockEmailService = {
        send: jest.fn().mockResolvedValue({ success: true })
      };
      notificationService.emailService = mockEmailService;
      notificationService.enabled = true;

      await notificationService.sendUserStatusNotification(
        mockUser,
        'activo',
        'admin123'
      );

      expect(mockEmailService.send).toHaveBeenCalled();
      expect(mockEmailService.send).toHaveBeenCalledWith(
        expect.objectContaining({
          to: mockUser.email,
          subject: expect.stringContaining('activada'),
          text: expect.any(String),
          html: expect.any(String)
        })
      );
    });

    it('debe manejar errores al enviar notificación', async () => {
      const mockEmailService = {
        send: jest.fn().mockRejectedValue(new Error('Email service error'))
      };
      notificationService.emailService = mockEmailService;
      notificationService.enabled = true;
      process.env.EMAIL_SERVICE_ENABLED = 'true';

      const result = await notificationService.sendUserStatusNotification(
        mockUser,
        'activo',
        'admin123'
      );

      expect(result.success).toBe(false);
      expect(result.error).toBeDefined();
    });
  });

  describe('_generateEmailHTML', () => {
    it('debe generar HTML correcto para activación', () => {
      const user = {
        nombre: 'Juan',
        apellido: 'Pérez'
      };

      const html = notificationService._generateEmailHTML(
        user,
        'activo',
        'Tu cuenta ha sido activada'
      );

      expect(html).toContain('Cuenta Activada');
      expect(html).toContain('Juan');
      expect(html).toContain('Pérez');
      expect(html).toContain('#4CAF50'); // Color verde para activación
    });

    it('debe generar HTML correcto para desactivación', () => {
      const user = {
        nombre: 'María',
        apellido: 'García'
      };

      const html = notificationService._generateEmailHTML(
        user,
        'inactivo',
        'Tu cuenta ha sido desactivada'
      );

      expect(html).toContain('Cuenta Desactivada');
      expect(html).toContain('María');
      expect(html).toContain('García');
      expect(html).toContain('#FF9800'); // Color naranja para desactivación
      expect(html).toContain('contacta al administrador');
    });
  });

  describe('sendPushNotification', () => {
    it('debe registrar intento de notificación push (futuro)', async () => {
      const consoleSpy = jest.spyOn(console, 'log').mockImplementation();

      await notificationService.sendPushNotification(
        { nombre: 'Juan' },
        'Título',
        'Mensaje'
      );

      expect(consoleSpy).toHaveBeenCalledWith(
        expect.stringContaining('Push notification (futuro)')
      );

      consoleSpy.mockRestore();
    });
  });
});

