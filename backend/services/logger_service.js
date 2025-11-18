/**
 * Servicio de Logging Centralizado
 * Sistema unificado de logs con niveles y formato estructurado
 */

const winston = require('winston');
const DailyRotateFile = require('winston-daily-rotate-file');
const path = require('path');
const fs = require('fs');

// Crear directorio de logs si no existe
const logsDir = path.join(__dirname, '../logs');
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

// Formato personalizado para logs
const logFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.errors({ stack: true }),
  winston.format.splat(),
  winston.format.json()
);

// Formato para consola (más legible)
const consoleFormat = winston.format.combine(
  winston.format.colorize(),
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.printf(({ timestamp, level, message, ...meta }) => {
    let msg = `${timestamp} [${level}]: ${message}`;
    if (Object.keys(meta).length > 0) {
      msg += ` ${JSON.stringify(meta)}`;
    }
    return msg;
  })
);

// Transporte para archivo de todos los logs
const allLogsTransport = new DailyRotateFile({
  filename: path.join(logsDir, 'application-%DATE%.log'),
  datePattern: 'YYYY-MM-DD',
  maxSize: '20m',
  maxFiles: '14d', // Retener 14 días
  format: logFormat,
  level: 'info'
});

// Transporte para errores
const errorLogsTransport = new DailyRotateFile({
  filename: path.join(logsDir, 'error-%DATE%.log'),
  datePattern: 'YYYY-MM-DD',
  maxSize: '20m',
  maxFiles: '30d', // Retener 30 días
  format: logFormat,
  level: 'error'
});

// Transporte para auditoría
const auditLogsTransport = new DailyRotateFile({
  filename: path.join(logsDir, 'audit-%DATE%.log'),
  datePattern: 'YYYY-MM-DD',
  maxSize: '20m',
  maxFiles: '90d', // Retener 90 días
  format: logFormat,
  level: 'info'
});

// Crear logger principal
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: logFormat,
  defaultMeta: { service: 'moviles2-backend' },
  transports: [
    allLogsTransport,
    errorLogsTransport
  ],
  exceptionHandlers: [
    new winston.transports.File({ 
      filename: path.join(logsDir, 'exceptions.log'),
      format: logFormat
    })
  ],
  rejectionHandlers: [
    new winston.transports.File({ 
      filename: path.join(logsDir, 'rejections.log'),
      format: logFormat
    })
  ]
});

// En desarrollo, también mostrar en consola
if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: consoleFormat,
    level: 'debug'
  }));
}

// Logger específico para auditoría
const auditLogger = winston.createLogger({
  level: 'info',
  format: logFormat,
  defaultMeta: { service: 'audit' },
  transports: [
    auditLogsTransport
  ]
});

/**
 * Clase LoggerService - Wrapper para funcionalidades adicionales
 */
class LoggerService {
  constructor() {
    this.logger = logger;
    this.auditLogger = auditLogger;
  }

  /**
   * Log de información general
   */
  info(message, meta = {}) {
    this.logger.info(message, meta);
  }

  /**
   * Log de advertencia
   */
  warn(message, meta = {}) {
    this.logger.warn(message, meta);
  }

  /**
   * Log de error
   */
  error(message, error = null, meta = {}) {
    const errorMeta = {
      ...meta,
      ...(error && {
        error: {
          message: error.message,
          stack: error.stack,
          name: error.name
        }
      })
    };
    this.logger.error(message, errorMeta);
  }

  /**
   * Log de debug (solo en desarrollo)
   */
  debug(message, meta = {}) {
    this.logger.debug(message, meta);
  }

  /**
   * Log de auditoría
   */
  audit(action, userId, details = {}) {
    this.auditLogger.info('Audit Log', {
      action,
      userId,
      timestamp: new Date().toISOString(),
      ...details
    });
  }

  /**
   * Log de request HTTP
   */
  logRequest(req, res, responseTime) {
    const logData = {
      method: req.method,
      url: req.originalUrl,
      ip: req.ip || req.connection.remoteAddress,
      userAgent: req.get('user-agent'),
      userId: req.user?.id || req.user?._id || 'anonymous',
      statusCode: res.statusCode,
      responseTime: `${responseTime}ms`
    };

    if (res.statusCode >= 400) {
      this.logger.warn('HTTP Request', logData);
    } else {
      this.logger.info('HTTP Request', logData);
    }
  }

  /**
   * Log de error HTTP
   */
  logError(req, err) {
    this.error('HTTP Error', err, {
      method: req.method,
      url: req.originalUrl,
      ip: req.ip || req.connection.remoteAddress,
      userId: req.user?.id || req.user?._id || 'anonymous'
    });
  }

  /**
   * Log de operación de base de datos
   */
  logDatabase(operation, collection, details = {}) {
    this.logger.debug('Database Operation', {
      operation,
      collection,
      ...details
    });
  }

  /**
   * Log de sincronización
   */
  logSync(type, status, details = {}) {
    this.logger.info('Sync Operation', {
      type,
      status,
      timestamp: new Date().toISOString(),
      ...details
    });
  }

  /**
   * Log de WebSocket
   */
  logWebSocket(event, details = {}) {
    this.logger.debug('WebSocket Event', {
      event,
      timestamp: new Date().toISOString(),
      ...details
    });
  }
}

// Exportar instancia singleton
const loggerService = new LoggerService();

// Exportar también el logger de winston directamente para casos especiales
module.exports = {
  logger: loggerService,
  winstonLogger: logger,
  auditLogger: auditLogger
};

