/**
 * Configuración de Rate Limiting
 * Protección contra abuso y ataques DDoS
 */

const rateLimit = require('express-rate-limit');

/**
 * Rate limiter general para toda la API
 */
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // máximo 100 requests por IP en 15 minutos
  message: {
    error: 'Demasiadas solicitudes desde esta IP, por favor intenta de nuevo más tarde.',
    retryAfter: '15 minutos'
  },
  standardHeaders: true, // Retorna info de rate limit en headers `RateLimit-*`
  legacyHeaders: false, // Desactiva headers `X-RateLimit-*`
  handler: (req, res) => {
    res.status(429).json({
      error: 'Demasiadas solicitudes desde esta IP, por favor intenta de nuevo más tarde.',
      retryAfter: '15 minutos',
      limit: 100,
      windowMs: '15 minutos'
    });
  }
});

/**
 * Rate limiter estricto para login (prevenir brute force)
 */
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5, // máximo 5 intentos de login por IP
  message: {
    error: 'Demasiados intentos de login. Por favor intenta de nuevo en 15 minutos.',
    retryAfter: '15 minutos'
  },
  skipSuccessfulRequests: true, // No contar requests exitosos
  handler: (req, res) => {
    res.status(429).json({
      error: 'Demasiados intentos de login. Por favor intenta de nuevo en 15 minutos.',
      retryAfter: '15 minutos',
      limit: 5,
      windowMs: '15 minutos'
    });
  }
});

/**
 * Rate limiter para endpoints de escritura (POST, PUT, DELETE)
 */
const writeLimiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minuto
  max: 30, // máximo 30 requests de escritura por IP por minuto
  message: {
    error: 'Demasiadas operaciones de escritura. Por favor espera un momento.',
    retryAfter: '1 minuto'
  },
  handler: (req, res) => {
    res.status(429).json({
      error: 'Demasiadas operaciones de escritura. Por favor espera un momento.',
      retryAfter: '1 minuto',
      limit: 30,
      windowMs: '1 minuto'
    });
  }
});

/**
 * Rate limiter para endpoints de lectura pesada (reportes, búsquedas)
 */
const readLimiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minuto
  max: 60, // máximo 60 requests de lectura por IP por minuto
  message: {
    error: 'Demasiadas solicitudes de lectura. Por favor espera un momento.',
    retryAfter: '1 minuto'
  },
  handler: (req, res) => {
    res.status(429).json({
      error: 'Demasiadas solicitudes de lectura. Por favor espera un momento.',
      retryAfter: '1 minuto',
      limit: 60,
      windowMs: '1 minuto'
    });
  }
});

/**
 * Rate limiter para endpoints de auditoría y reportes
 */
const auditLimiter = rateLimit({
  windowMs: 5 * 60 * 1000, // 5 minutos
  max: 20, // máximo 20 requests de auditoría por IP en 5 minutos
  message: {
    error: 'Demasiadas solicitudes de auditoría. Por favor espera un momento.',
    retryAfter: '5 minutos'
  },
  handler: (req, res) => {
    res.status(429).json({
      error: 'Demasiadas solicitudes de auditoría. Por favor espera un momento.',
      retryAfter: '5 minutos',
      limit: 20,
      windowMs: '5 minutos'
    });
  }
});

module.exports = {
  generalLimiter,
  loginLimiter,
  writeLimiter,
  readLimiter,
  auditLimiter
};

