# 📝 Logging Centralizado

**Sistema de Control de Acceso - MovilesII**  
**Fecha de implementación:** 18 de Noviembre 2025

---

## 📋 Resumen

Sistema de logging centralizado usando Winston con rotación diaria de archivos, niveles de log estructurados y separación por tipo de log.

---

## 🎯 Características

- ✅ Logs estructurados en formato JSON
- ✅ Rotación diaria de archivos
- ✅ Separación por tipo (aplicación, errores, auditoría)
- ✅ Retención configurable
- ✅ Logging automático de requests HTTP
- ✅ Logging de errores con stack traces
- ✅ Logging de operaciones de base de datos
- ✅ Logging de WebSocket events

---

## 📁 Estructura de Logs

```
backend/logs/
├── application-2025-11-18.log    # Todos los logs
├── error-2025-11-18.log           # Solo errores
├── audit-2025-11-18.log           # Logs de auditoría
├── exceptions.log                 # Excepciones no capturadas
└── rejections.log                 # Promesas rechazadas
```

---

## 🔧 Niveles de Log

### Niveles Disponibles

1. **error** - Errores que requieren atención
2. **warn** - Advertencias
3. **info** - Información general
4. **debug** - Información detallada (solo desarrollo)

### Configuración

```env
LOG_LEVEL=info  # error, warn, info, debug
NODE_ENV=production  # development, production
```

---

## 📊 Uso del Logger

### Importar el Logger

```javascript
const { logger } = require('./services/logger_service');
```

### Ejemplos de Uso

#### Log de Información

```javascript
logger.info('Usuario autenticado', {
  userId: '123',
  email: 'user@example.com',
  ip: req.ip
});
```

#### Log de Error

```javascript
try {
  // código
} catch (error) {
  logger.error('Error procesando solicitud', error, {
    userId: req.user?.id,
    endpoint: req.path
  });
}
```

#### Log de Advertencia

```javascript
logger.warn('Intento de acceso no autorizado', {
  userId: req.user?.id,
  endpoint: req.path,
  ip: req.ip
});
```

#### Log de Debug

```javascript
logger.debug('Query ejecutada', {
  collection: 'usuarios',
  query: { email: 'test@test.com' },
  executionTime: '45ms'
});
```

#### Log de Auditoría

```javascript
logger.audit('user_created', userId, {
  targetUserId: newUser.id,
  changes: { email: newUser.email }
});
```

#### Log de Base de Datos

```javascript
logger.logDatabase('find', 'usuarios', {
  query: { email: 'test@test.com' },
  resultCount: 1,
  executionTime: '12ms'
});
```

#### Log de Sincronización

```javascript
logger.logSync('student_sync', 'success', {
  syncedCount: 150,
  duration: '2.5s',
  type: 'incremental'
});
```

#### Log de WebSocket

```javascript
logger.logWebSocket('connection', {
  socketId: socket.id,
  userId: socket.userId
});
```

---

## 🔄 Rotación de Archivos

### Configuración Actual

- **Tamaño máximo:** 20MB por archivo
- **Retención aplicación:** 14 días
- **Retención errores:** 30 días
- **Retención auditoría:** 90 días

### Personalizar Retención

Editar `backend/services/logger_service.js`:

```javascript
const allLogsTransport = new DailyRotateFile({
  filename: path.join(logsDir, 'application-%DATE%.log'),
  datePattern: 'YYYY-MM-DD',
  maxSize: '20m',
  maxFiles: '14d',  // Cambiar aquí
  // ...
});
```

---

## 📈 Logging Automático

### Requests HTTP

Todos los requests HTTP se loguean automáticamente con:
- Método HTTP
- URL
- IP del cliente
- User-Agent
- User ID (si autenticado)
- Status code
- Tiempo de respuesta

### Errores HTTP

Los errores se loguean automáticamente con:
- Stack trace completo
- Información del request
- User ID (si disponible)

---

## 🔍 Formato de Logs

### Formato JSON (Archivos)

```json
{
  "timestamp": "2025-11-18 10:30:45",
  "level": "info",
  "message": "Usuario autenticado",
  "service": "moviles2-backend",
  "userId": "123",
  "email": "user@example.com",
  "ip": "192.168.1.1"
}
```

### Formato Consola (Desarrollo)

```
2025-11-18 10:30:45 [info]: Usuario autenticado {"userId":"123","email":"user@example.com"}
```

---

## 🚀 Mejoras Futuras

1. **Integración con servicios externos:**
   - Sentry para errores
   - ELK Stack para análisis
   - CloudWatch / Datadog

2. **Filtrado avanzado:**
   - Filtros por nivel
   - Filtros por servicio
   - Filtros por usuario

3. **Métricas:**
   - Contador de logs por nivel
   - Alertas automáticas
   - Dashboard de logs

4. **Compresión:**
   - Comprimir logs antiguos
   - Almacenamiento en S3/Cloud Storage

---

## 📝 Mejores Prácticas

1. **Usar niveles apropiados:**
   - `error` solo para errores reales
   - `warn` para situaciones inusuales
   - `info` para eventos importantes
   - `debug` para información detallada

2. **Incluir contexto:**
   - Siempre incluir userId cuando sea relevante
   - Agregar información del request
   - Incluir timestamps cuando sea necesario

3. **No loguear datos sensibles:**
   - Nunca loguear contraseñas
   - Evitar loguear tokens completos
   - Ser cuidadoso con datos personales

4. **Estructurar metadata:**
   - Usar objetos para metadata
   - Mantener consistencia en nombres de campos
   - Agregar información útil

---

## 🔧 Troubleshooting

### Logs no se están generando

1. Verificar que el directorio `logs/` existe
2. Verificar permisos de escritura
3. Revisar `LOG_LEVEL` en variables de entorno

### Logs muy grandes

1. Ajustar `maxSize` en configuración
2. Reducir `maxFiles` para retención más corta
3. Aumentar nivel de log (menos verbose)

### Performance

1. En producción, usar `LOG_LEVEL=info` o `warn`
2. Desactivar console transport en producción
3. Considerar usar transporte asíncrono

---

**Última actualización:** 18 de Noviembre 2025

