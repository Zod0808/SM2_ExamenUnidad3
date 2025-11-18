/**
 * Servicio de Notificaciones (US007)
 * Envía notificaciones cuando se activa/desactiva un usuario
 */

class NotificationService {
  constructor() {
    this.enabled = process.env.EMAIL_SERVICE_ENABLED === 'true';
    this.emailService = null; // Se puede configurar con nodemailer u otro servicio
  }

  /**
   * Enviar notificación de cambio de estado de usuario
   * @param {Object} user - Usuario afectado
   * @param {string} newStatus - Nuevo estado ('activo' o 'inactivo')
   * @param {string} updatedBy - ID del admin que realizó el cambio
   */
  async sendUserStatusNotification(user, newStatus, updatedBy = null) {
    try {
      const isActivated = newStatus === 'activo';
      const subject = isActivated 
        ? '✅ Tu cuenta ha sido activada' 
        : '⚠️ Tu cuenta ha sido desactivada';
      
      const message = isActivated
        ? `Hola ${user.nombre},\n\nTu cuenta ha sido activada. Ya puedes iniciar sesión en el sistema.`
        : `Hola ${user.nombre},\n\nTu cuenta ha sido desactivada. No podrás iniciar sesión hasta que un administrador reactive tu cuenta.\n\nSi crees que esto es un error, contacta al administrador del sistema.`;

      // Log de notificación
      console.log(`📧 Notificación enviada a ${user.email}: ${subject}`);
      console.log(`   Mensaje: ${message}`);

      // Si hay servicio de email configurado, enviar email
      if (this.enabled && this.emailService) {
        await this.emailService.send({
          to: user.email,
          subject: subject,
          text: message,
          html: this._generateEmailHTML(user, newStatus, message)
        });
      }

      // También se puede enviar notificación push si está configurado
      // await this.sendPushNotification(user, subject, message);

      return { success: true, sent: this.enabled };
    } catch (error) {
      console.error('Error enviando notificación:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Generar HTML para email
   */
  _generateEmailHTML(user, status, message) {
    const isActivated = status === 'activo';
    const bgColor = isActivated ? '#4CAF50' : '#FF9800';
    const icon = isActivated ? '✅' : '⚠️';

    return `
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background-color: ${bgColor}; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
          .content { background-color: #f9f9f9; padding: 20px; border-radius: 0 0 8px 8px; }
          .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>${icon} ${isActivated ? 'Cuenta Activada' : 'Cuenta Desactivada'}</h1>
          </div>
          <div class="content">
            <p>Hola <strong>${user.nombre} ${user.apellido}</strong>,</p>
            <p>${message}</p>
            ${!isActivated ? '<p><strong>Si crees que esto es un error, contacta al administrador del sistema.</strong></p>' : ''}
          </div>
          <div class="footer">
            <p>Sistema de Control de Acceso - Universidad</p>
            <p>Este es un mensaje automático, por favor no respondas a este email.</p>
          </div>
        </div>
      </body>
      </html>
    `;
  }

  /**
   * Enviar notificación push (futuro)
   */
  async sendPushNotification(user, title, message) {
    // TODO: Implementar cuando se configure Firebase Cloud Messaging
    console.log(`📱 Push notification (futuro): ${title} - ${message}`);
  }
}

module.exports = NotificationService;

