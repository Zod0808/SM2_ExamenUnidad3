# 📚 Documentación Completa de API REST

**Sistema de Control de Acceso - MovilesII**  
**Versión:** 2.0.0  
**Última actualización:** 18 de Noviembre 2025

---

## 📋 Tabla de Contenidos

1. [Introducción](#introducción)
2. [Autenticación](#autenticación)
3. [Rate Limiting](#rate-limiting)
4. [Base URL](#base-url)
5. [Endpoints](#endpoints)
   - [Autenticación](#autenticación-1)
   - [Usuarios](#usuarios)
   - [Puntos de Control](#puntos-de-control)
   - [Asignaciones](#asignaciones)
   - [Estudiantes y Alumnos](#estudiantes-y-alumnos)
   - [Control de Accesos](#control-de-accesos)
   - [Presencia](#presencia)
   - [Sesiones de Guardias](#sesiones-de-guardias)
   - [Sincronización](#sincronización)
   - [Backup y Restauración](#backup-y-restauración)
   - [Auditoría](#auditoría)
   - [Auditoría Avanzada](#auditoría-avanzada)
   - [Reportes](#reportes)
   - [Machine Learning](#machine-learning)
   - [Dashboard y WebSocket](#dashboard-y-websocket)
   - [Configuración](#configuración)
6. [Códigos de Estado HTTP](#códigos-de-estado-http)
7. [Manejo de Errores](#manejo-de-errores)
8. [Ejemplos de Uso](#ejemplos-de-uso)

---

## Introducción

Esta API REST proporciona acceso completo a todas las funcionalidades del Sistema de Control de Acceso. La API utiliza JSON para el intercambio de datos y sigue los principios RESTful.

**Características:**
- ✅ 62+ endpoints REST
- ✅ Rate limiting para protección
- ✅ Logging centralizado
- ✅ Autenticación por sesión
- ✅ WebSockets para tiempo real
- ✅ Documentación completa

---

## Autenticación

El sistema utiliza autenticación basada en sesiones. Para acceder a los endpoints protegidos, primero debes autenticarte mediante el endpoint `/login`.

### POST /login

Autentica un usuario y devuelve sus datos.

**Rate Limiting:** 5 intentos por IP en 15 minutos

**Request:**
```json
{
  "email": "guardia@universidad.edu",
  "password": "contraseña123"
}
```

**Respuesta Exitosa (200):**
```json
{
  "id": "uuid-del-usuario",
  "nombre": "Juan",
  "apellido": "Pérez",
  "email": "guardia@universidad.edu",
  "dni": "12345678",
  "rango": "guardia",
  "puerta_acargo": "Puerta Principal",
  "estado": "activo"
}
```

**Errores:**
- `401` - Credenciales incorrectas
- `403` - Cuenta desactivada
- `429` - Demasiados intentos (rate limit)

---

## Rate Limiting

Todos los endpoints están protegidos con rate limiting:

- **General:** 100 requests/IP en 15 minutos
- **Login:** 5 intentos/IP en 15 minutos
- **Escritura:** 30 operaciones/IP por minuto
- **Auditoría:** 20 requests/IP en 5 minutos

**Headers de respuesta:**
```
RateLimit-Limit: 100
RateLimit-Remaining: 95
RateLimit-Reset: 1637251200
```

**Error 429:**
```json
{
  "error": "Demasiadas solicitudes desde esta IP",
  "retryAfter": "15 minutos",
  "limit": 100
}
```

---

## Base URL

**Desarrollo:**
```
http://localhost:3000
```

**Producción:**
```
https://movilesii.onrender.com
```

---

## Endpoints

### Autenticación

#### POST /login
Autentica un usuario.

**Rate Limiting:** Login limiter (5 intentos/15min)

**Ver sección [Autenticación](#autenticación) para detalles.**

---

### Usuarios

#### GET /usuarios
Obtiene lista de usuarios (sin contraseñas).

**Rate Limiting:** General limiter

**Respuesta:**
```json
[
  {
    "id": "uuid",
    "nombre": "Juan",
    "apellido": "Pérez",
    "email": "user@example.com",
    "rango": "admin",
    "estado": "activo"
  }
]
```

#### POST /usuarios
Crea un nuevo usuario.

**Rate Limiting:** Write limiter

**Request:**
```json
{
  "nombre": "Juan",
  "apellido": "Pérez",
  "dni": "12345678",
  "email": "user@example.com",
  "password": "contraseña123",
  "rango": "guardia",
  "puerta_acargo": "Puerta Principal"
}
```

#### PUT /usuarios/:id
Actualiza un usuario.

**Rate Limiting:** Write limiter

#### PUT /usuarios/:id/password
Cambia la contraseña de un usuario.

**Rate Limiting:** Write limiter

---

### Puntos de Control

#### GET /puntos-control
Lista todos los puntos de control.

#### POST /puntos-control
Crea un punto de control.

**Rate Limiting:** Write limiter

**Request:**
```json
{
  "nombre": "Puerta Principal",
  "ubicacion": "Entrada principal",
  "descripcion": "Punto de control principal"
}
```

#### PUT /puntos-control/:id
Actualiza un punto de control.

**Rate Limiting:** Write limiter

#### DELETE /puntos-control/:id
Elimina un punto de control.

**Rate Limiting:** Write limiter

---

### Asignaciones

#### GET /asignaciones
Lista todas las asignaciones.

#### POST /asignaciones
Crea asignaciones múltiples.

**Rate Limiting:** Write limiter

**Request:**
```json
{
  "asignaciones": [
    {
      "guardia_id": "uuid",
      "punto_id": "uuid",
      "fecha_inicio": "2025-01-01T00:00:00Z",
      "fecha_fin": "2025-12-31T23:59:59Z"
    }
  ]
}
```

#### PUT /asignaciones/:id/finalizar
Finaliza una asignación.

**Rate Limiting:** Write limiter

---

### Estudiantes y Alumnos

#### GET /alumnos
Lista todos los alumnos.

#### GET /alumnos/:codigo
Obtiene un alumno por código universitario.

#### GET /facultades
Lista todas las facultades.

#### GET /escuelas
Lista escuelas, opcionalmente filtradas por facultad.

**Query params:**
- `siglas_facultad` (opcional)

---

### Control de Accesos

#### GET /asistencias
Lista todas las asistencias.

**Query params:**
- `fecha_inicio` (opcional)
- `fecha_fin` (opcional)
- `codigo_universitario` (opcional)
- `tipo` (opcional)

#### POST /asistencias
Registra una asistencia.

**Rate Limiting:** Write limiter

#### POST /asistencias/completa
Registra asistencia completa con todos los datos.

**Rate Limiting:** Write limiter

**Request:**
```json
{
  "codigo_universitario": "20201234",
  "tipo": "entrada",
  "puerta": "Puerta Principal",
  "guardia_id": "uuid",
  "guardia_nombre": "Juan Pérez",
  "autorizacion_manual": false
}
```

#### POST /asistencias/validar-movimiento
Valida movimiento de entrada/salida.

**Rate Limiting:** Write limiter

#### POST /decisiones-manuales
Registra una decisión manual de acceso.

**Rate Limiting:** Write limiter

**Request:**
```json
{
  "estudiante_id": "uuid",
  "estudiante_dni": "12345678",
  "autorizado": true,
  "razon": "Estudiante autorizado",
  "punto_control": "Puerta Principal",
  "tipo_acceso": "entrada"
}
```

---

### Presencia

#### GET /presencia
Lista registros de presencia.

#### GET /presencia/dentro
Lista estudiantes actualmente en el campus.

#### POST /presencia/actualizar
Actualiza estado de presencia.

**Rate Limiting:** Write limiter

---

### Sesiones de Guardias

#### POST /sesiones/iniciar
Inicia una sesión de guardia.

**Rate Limiting:** Write limiter

**Request:**
```json
{
  "guardia_id": "uuid",
  "punto_control": "Puerta Principal",
  "device_info": {
    "platform": "Android",
    "device_id": "device123",
    "app_version": "1.0.0"
  }
}
```

#### POST /sesiones/heartbeat
Actualiza actividad de sesión.

**Rate Limiting:** Write limiter

#### POST /sesiones/finalizar
Finaliza una sesión.

**Rate Limiting:** Write limiter

#### POST /sesiones/forzar-finalizacion
Fuerza finalización de sesión (admin).

**Rate Limiting:** Write limiter

---

### Sincronización

#### GET /sync/students/statistics
Obtiene estadísticas de sincronización de estudiantes.

#### GET /sync/students/history
Obtiene historial de sincronizaciones.

#### POST /sync/students/manual
Ejecuta sincronización manual.

**Rate Limiting:** Write limiter

#### GET /sync/students/config
Obtiene configuración de sincronización.

#### PUT /sync/students/config
Actualiza configuración de sincronización.

**Rate Limiting:** Write limiter

---

### Backup y Restauración

#### POST /backup/create
Crea un backup manual.

**Rate Limiting:** Write limiter

#### GET /backup/list
Lista todos los backups disponibles.

#### POST /backup/restore/:backupId
Restaura un backup.

**Rate Limiting:** Write limiter

#### GET /backup/retention
Obtiene políticas de retención.

#### PUT /backup/retention
Actualiza políticas de retención.

**Rate Limiting:** Write limiter

---

### Auditoría

#### GET /api/audit/history
Obtiene historial de auditoría.

**Query params:**
- `entityType` (opcional)
- `entityId` (opcional)
- `userId` (opcional)
- `action` (opcional)
- `startDate` (opcional)
- `endDate` (opcional)
- `limit` (default: 100)
- `skip` (default: 0)

**Rate Limiting:** Audit limiter

#### GET /api/audit/entity/:entityType/:entityId
Obtiene historial de una entidad específica.

**Rate Limiting:** Audit limiter

#### GET /api/audit/stats
Obtiene estadísticas de auditoría.

**Query params:**
- `startDate` (opcional)
- `endDate` (opcional)

---

### Auditoría Avanzada

#### GET /api/audit/search
Búsqueda avanzada de logs de auditoría.

**Rate Limiting:** Audit limiter

**Query params:**
- `query` - Búsqueda de texto libre
- `entityType`, `entityId`, `userId`, `userName`
- `action`, `userRole`, `ipAddress`
- `startDate`, `endDate`
- `limit`, `skip`, `sortBy`, `sortOrder`

**Ejemplo:**
```
GET /api/audit/search?query=admin&action=delete&startDate=2025-01-01&limit=50
```

#### GET /api/audit/dashboard
Dashboard de auditoría con estadísticas.

**Rate Limiting:** Audit limiter

**Query params:**
- `startDate` (opcional)
- `endDate` (opcional)

**Respuesta:**
```json
{
  "success": true,
  "dashboard": {
    "summary": {
      "totalLogs": 1500,
      "uniqueUsers": 25,
      "recentActivity24h": 120
    },
    "byAction": [...],
    "byEntityType": [...],
    "topUsers": [...],
    "byHour": [...]
  }
}
```

#### GET /api/audit/suspicious
Detecta actividad sospechosa.

**Rate Limiting:** Audit limiter

**Query params:**
- `startDate` (opcional)
- `endDate` (opcional)

#### GET /api/audit/traceability/:entityType/:entityId
Obtiene trazabilidad completa de una entidad.

**Rate Limiting:** Audit limiter

#### GET /api/audit/export
Exporta reportes de auditoría.

**Rate Limiting:** Audit limiter

**Query params:**
- `format` - json, csv, pdf
- ... (mismos filtros que search)

#### PUT /api/audit/alert-thresholds
Configura umbrales de alertas.

**Rate Limiting:** Write limiter

**Request:**
```json
{
  "suspiciousActivity": 15,
  "failedAttempts": 5,
  "bulkOperations": 25
}
```

---

### Reportes

#### GET /reportes/asistencias
Reporte de asistencias por rango de fechas.

**Query params:**
- `fecha_inicio` (requerido)
- `fecha_fin` (requerido)
- `carrera` (opcional)
- `facultad` (opcional)

#### GET /reportes/guardias/resumen
Resumen de actividad de guardias.

#### GET /reportes/guardias/ranking
Ranking de guardias por actividad.

#### GET /reportes/guardias/actividad-semanal
Actividad semanal de guardias.

#### GET /reportes/guardias/puertas
Reporte por puertas.

#### GET /reportes/guardias/facultades
Reporte por facultades.

#### GET /reportes/guardias/export/pdf
Exporta reporte de guardias a PDF.

---

### Machine Learning

#### GET /api/ml/flow-prediction
Predicción de flujo de estudiantes.

**Query params:**
- `date` (opcional)
- `hour` (opcional)

#### GET /api/ml/peak-hours
Análisis de horarios pico.

#### GET /api/ml/clustering
Clustering de patrones de acceso.

#### GET /api/ml/timeseries
Análisis de series temporales.

#### POST /ml/bus-schedule/implement
Registra sugerencia de horario implementada.

**Rate Limiting:** Write limiter

#### GET /ml/bus-schedule/comparison
Compara horarios sugeridos vs reales.

#### GET /ml/bus-schedule/adoption-metrics
Métricas de adopción de horarios.

#### GET /api/historical/comparison
Comparación histórica con ROI.

**Query params:**
- `startDate` (opcional)
- `endDate` (opcional)

---

### Dashboard y WebSocket

#### GET /dashboard
Dashboard web administrativo.

#### WebSocket Events

**Conexión:**
```javascript
const socket = io('http://localhost:3000');

// Unirse al dashboard
socket.emit('join-dashboard');

// Unirse a métricas
socket.emit('join-metrics');
```

**Eventos recibidos:**
- `metrics-update` - Actualización de métricas
- `new-access` - Nuevo acceso registrado
- `hourly-data` - Datos por hora

---

### Configuración

#### GET /session/config
Obtiene configuración de sesión.

#### PUT /session/config
Actualiza configuración de sesión.

**Rate Limiting:** Write limiter

**Request:**
```json
{
  "timeoutMinutes": 30,
  "warningMinutes": 5,
  "updatedBy": "admin123"
}
```

---

## Códigos de Estado HTTP

| Código | Significado | Uso |
|--------|-------------|-----|
| `200` | OK | Solicitud exitosa |
| `201` | Created | Recurso creado |
| `400` | Bad Request | Datos inválidos |
| `401` | Unauthorized | No autenticado |
| `403` | Forbidden | No autorizado |
| `404` | Not Found | Recurso no encontrado |
| `409` | Conflict | Conflicto (ej: duplicado) |
| `429` | Too Many Requests | Rate limit excedido |
| `500` | Internal Server Error | Error del servidor |

---

## Manejo de Errores

### Formato de Error

```json
{
  "error": "Descripción del error",
  "details": "Detalles adicionales (opcional)"
}
```

### Ejemplos

**Error 400:**
```json
{
  "error": "Faltan campos requeridos"
}
```

**Error 401:**
```json
{
  "error": "Credenciales incorrectas"
}
```

**Error 403:**
```json
{
  "error": "Cuenta desactivada",
  "message": "Su cuenta ha sido desactivada. Contacte al administrador."
}
```

**Error 429:**
```json
{
  "error": "Demasiadas solicitudes desde esta IP",
  "retryAfter": "15 minutos",
  "limit": 100
}
```

**Error 500:**
```json
{
  "error": "Error al procesar solicitud",
  "details": "Mensaje de error detallado"
}
```

---

## Ejemplos de Uso

### Flujo Completo: Login y Registrar Asistencia

```javascript
// 1. Login
const loginResponse = await fetch('http://localhost:3000/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    email: 'guardia@universidad.edu',
    password: 'contraseña123'
  })
});
const user = await loginResponse.json();

// 2. Registrar asistencia
const asistenciaResponse = await fetch('http://localhost:3000/asistencias/completa', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    codigo_universitario: '20201234',
    tipo: 'entrada',
    puerta: 'Puerta Principal',
    guardia_id: user.id,
    guardia_nombre: `${user.nombre} ${user.apellido}`,
    autorizacion_manual: false
  })
});
const asistencia = await asistenciaResponse.json();
```

### Búsqueda Avanzada de Auditoría

```javascript
const searchResponse = await fetch(
  'http://localhost:3000/api/audit/search?query=admin&action=delete&startDate=2025-01-01&limit=50',
  {
    headers: {
      'Content-Type': 'application/json'
    }
  }
);
const results = await searchResponse.json();
```

### Exportar Reporte de Auditoría

```javascript
const exportResponse = await fetch(
  'http://localhost:3000/api/audit/export?format=csv&action=delete&startDate=2025-01-01'
);
const csvContent = await exportResponse.text();
// Descargar o procesar CSV
```

---

## 📝 Notas Importantes

1. **Rate Limiting:** Todos los endpoints están protegidos. Ver [Rate Limiting](#rate-limiting).

2. **Logging:** Todas las operaciones se registran automáticamente.

3. **Autenticación:** Algunos endpoints requieren autenticación previa.

4. **WebSockets:** Para actualizaciones en tiempo real, usar Socket.IO.

5. **Versión:** Esta documentación corresponde a la versión 2.0.0 de la API.

---

**Última actualización:** 18 de Noviembre 2025

