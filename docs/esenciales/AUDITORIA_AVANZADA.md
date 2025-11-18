# 🔒 Sistema de Auditoría y Trazabilidad Avanzada

**Sistema de Control de Acceso - MovilesII**  
**Fecha:** 18 de Noviembre 2025  
**US067:** Auditoría y trazabilidad avanzada

---

## 📋 Resumen

Este documento describe el sistema avanzado de auditoría y trazabilidad implementado para cumplir con requisitos de seguridad y compliance.

---

## 🎯 Funcionalidades Implementadas

### 1. Búsqueda Avanzada ✅

**Endpoint:** `GET /api/audit/search`

**Características:**
- ✅ Búsqueda de texto libre en múltiples campos
- ✅ Filtros múltiples combinados
- ✅ Búsqueda por rango de fechas
- ✅ Búsqueda en cambios y metadata
- ✅ Ordenamiento personalizable
- ✅ Paginación

**Parámetros:**
```javascript
{
  query: "texto libre",           // Búsqueda en nombre, tipo, ID, IP
  entityType: "usuario",          // Tipo de entidad
  entityId: "123",                // ID de entidad
  userId: "user123",              // ID de usuario
  userName: "Juan",               // Nombre de usuario (regex)
  action: "update",               // Acción (create, update, delete, etc.)
  userRole: "admin",              // Rol de usuario
  ipAddress: "192.168.1.1",      // Dirección IP
  startDate: "2024-01-01",       // Fecha inicio
  endDate: "2024-12-31",         // Fecha fin
  limit: 100,                     // Límite de resultados
  skip: 0,                        // Paginación
  sortBy: "timestamp",            // Campo de ordenamiento
  sortOrder: -1                   // 1 ascendente, -1 descendente
}
```

**Ejemplo:**
```bash
GET /api/audit/search?query=admin&action=delete&startDate=2024-01-01&limit=50
```

### 2. Dashboard de Auditoría ✅

**Endpoint:** `GET /api/audit/dashboard`

**Características:**
- ✅ Resumen general de actividad
- ✅ Estadísticas por acción
- ✅ Estadísticas por tipo de entidad
- ✅ Top 10 usuarios más activos
- ✅ Actividad por hora del día
- ✅ Actividad reciente (últimas 24 horas)

**Respuesta:**
```json
{
  "success": true,
  "dashboard": {
    "summary": {
      "totalLogs": 1500,
      "uniqueUsers": 25,
      "uniqueEntities": 8,
      "recentActivity24h": 120,
      "period": { "start": null, "end": null }
    },
    "byAction": [
      { "action": "update", "count": 800, "percentage": "53.33" },
      { "action": "create", "count": 500, "percentage": "33.33" }
    ],
    "byEntityType": [...],
    "topUsers": [...],
    "byHour": [...]
  }
}
```

### 3. Detección de Actividad Sospechosa ✅

**Endpoint:** `GET /api/audit/suspicious`

**Patrones Detectados:**
- ✅ Múltiples eliminaciones en corto tiempo
- ✅ Actividad desde múltiples IPs (mismo usuario)
- ✅ Operaciones masivas en una hora

**Umbrales Configurables:**
- `suspiciousActivity`: 10 acciones
- `failedAttempts`: 5 intentos
- `bulkOperations`: 20 operaciones/hora

**Respuesta:**
```json
{
  "success": true,
  "total": 3,
  "alerts": [
    {
      "type": "multiple_deletes",
      "severity": "high",
      "userId": "user123",
      "userName": "Juan Pérez",
      "count": 15,
      "description": "15 operaciones de eliminación detectadas"
    }
  ],
  "generatedAt": "2024-11-18T10:00:00.000Z"
}
```

### 4. Trazabilidad Completa ✅

**Endpoint:** `GET /api/audit/traceability/:entityType/:entityId`

**Características:**
- ✅ Línea de tiempo completa de cambios
- ✅ Historial cronológico
- ✅ Resumen de cambios
- ✅ Información de quién hizo cada cambio

**Ejemplo:**
```bash
GET /api/audit/traceability/usuario/12345
```

**Respuesta:**
```json
{
  "success": true,
  "entityType": "usuario",
  "entityId": "12345",
  "timeline": [
    {
      "timestamp": "2024-01-01T10:00:00Z",
      "action": "create",
      "user": { "id": "admin1", "name": "Admin", "role": "admin" },
      "changes": {},
      "isFirst": true
    },
    {
      "timestamp": "2024-01-15T14:30:00Z",
      "action": "update",
      "user": { "id": "admin2", "name": "Otro Admin", "role": "admin" },
      "changes": { "nombre": { "from": "Juan", "to": "Juan Carlos" } }
    }
  ],
  "summary": {
    "totalChanges": 5,
    "created": {...},
    "lastModified": {...},
    "modifiedBy": ["admin1", "admin2"],
    "actions": ["create", "update"]
  }
}
```

### 5. Exportación de Reportes ✅

**Endpoint:** `GET /api/audit/export`

**Formatos Soportados:**
- ✅ JSON
- ✅ CSV
- ✅ PDF (estructura básica, requiere librería adicional)

**Parámetros:**
```javascript
{
  format: "json|csv|pdf",
  // ... mismos filtros que búsqueda avanzada
}
```

**Ejemplo:**
```bash
# Exportar a CSV
GET /api/audit/export?format=csv&startDate=2024-01-01&action=delete

# Exportar a JSON
GET /api/audit/export?format=json&entityType=usuario
```

### 6. Configuración de Umbrales ✅

**Endpoint:** `PUT /api/audit/alert-thresholds`

**Umbrales Configurables:**
```json
{
  "suspiciousActivity": 10,
  "failedAttempts": 5,
  "bulkOperations": 20
}
```

---

## 📊 Estructura de Datos de Auditoría

### Schema de AuditLog

```javascript
{
  entity_type: String,        // Tipo de entidad (usuario, asistencia, etc.)
  entity_id: String,           // ID de la entidad
  action: String,              // create, update, delete, activate, deactivate
  user_id: String,             // ID del usuario que realizó la acción
  user_name: String,           // Nombre del usuario
  user_role: String,           // admin, guardia, sistema
  changes: Object,             // Cambios realizados
  previous_state: Object,      // Estado anterior
  new_state: Object,           // Estado nuevo
  ip_address: String,          // IP desde donde se realizó
  user_agent: String,          // User agent del navegador
  timestamp: Date,             // Fecha y hora
  metadata: Object             // Metadatos adicionales
}
```

---

## 🔍 Casos de Uso

### 1. Investigar Cambios en un Usuario

```bash
# Obtener trazabilidad completa
GET /api/audit/traceability/usuario/12345

# Buscar todos los cambios de un usuario específico
GET /api/audit/search?entityType=usuario&entityId=12345
```

### 2. Detectar Actividad Sospechosa

```bash
# Detectar actividad sospechosa en último mes
GET /api/audit/suspicious?startDate=2024-10-01&endDate=2024-11-18
```

### 3. Generar Reporte de Compliance

```bash
# Exportar todos los logs de eliminación
GET /api/audit/export?format=csv&action=delete&startDate=2024-01-01
```

### 4. Analizar Actividad por Usuario

```bash
# Ver actividad de un usuario específico
GET /api/audit/search?userId=user123&startDate=2024-01-01

# Ver dashboard con filtro de fecha
GET /api/audit/dashboard?startDate=2024-01-01&endDate=2024-12-31
```

---

## 🚨 Alertas y Notificaciones

### Tipos de Alertas

1. **Múltiples Eliminaciones:**
   - Detecta cuando un usuario realiza muchas eliminaciones
   - Severidad: Alta
   - Umbral: 10 eliminaciones (configurable)

2. **Actividad desde Múltiples IPs:**
   - Detecta cuando un usuario accede desde muchas IPs diferentes
   - Severidad: Media
   - Umbral: 3+ IPs diferentes

3. **Operaciones Masivas:**
   - Detecta muchas operaciones en corto tiempo
   - Severidad: Media
   - Umbral: 20 operaciones/hora

### Configurar Alertas

```bash
PUT /api/audit/alert-thresholds
Content-Type: application/json

{
  "suspiciousActivity": 15,
  "bulkOperations": 25
}
```

---

## 📈 Dashboard y Estadísticas

### Métricas Disponibles

1. **Resumen General:**
   - Total de logs
   - Usuarios únicos
   - Tipos de entidades
   - Actividad reciente (24h)

2. **Por Acción:**
   - Conteo y porcentaje de cada acción
   - Ordenado por frecuencia

3. **Por Tipo de Entidad:**
   - Conteo por tipo de entidad
   - Porcentajes

4. **Top Usuarios:**
   - 10 usuarios más activos
   - Conteo de acciones por usuario

5. **Por Hora:**
   - Distribución de actividad por hora del día
   - Útil para identificar patrones

---

## 🔐 Seguridad y Compliance

### Requisitos Cumplidos

- ✅ **Logs detallados:** Todas las operaciones críticas registradas
- ✅ **Trazabilidad completa:** Historial completo de cambios
- ✅ **Exportación:** Reportes exportables para auditorías externas
- ✅ **Búsqueda avanzada:** Filtros y búsqueda potente
- ✅ **Detección de anomalías:** Alertas automáticas

### Mejores Prácticas

1. **Retención de Logs:**
   - Configurar políticas de retención según necesidades
   - Considerar almacenamiento externo para logs antiguos

2. **Acceso a Logs:**
   - Solo administradores deben tener acceso
   - Implementar autenticación y autorización

3. **Integridad:**
   - Los logs no deben ser modificables
   - Considerar firma digital para logs críticos

4. **Privacidad:**
   - Anonimizar datos sensibles si es necesario
   - Cumplir con regulaciones (GDPR, etc.)

---

## 🔧 Configuración

### Habilitar/Deshabilitar Auditoría

```javascript
const { AuditService } = require('./services/audit_service');
const auditService = new AuditService();

// Deshabilitar temporalmente
auditService.setEnabled(false);

// Habilitar
auditService.setEnabled(true);
```

### Configurar Umbrales

```javascript
const AdvancedAuditService = require('./services/advanced_audit_service');
const advancedAuditService = new AdvancedAuditService();

advancedAuditService.setAlertThresholds({
  suspiciousActivity: 15,
  failedAttempts: 5,
  bulkOperations: 25
});
```

---

## 📝 Ejemplos de Uso

### Frontend (Flutter)

```dart
// Búsqueda avanzada
final response = await http.get(
  Uri.parse('$baseUrl/api/audit/search?query=admin&action=delete'),
);

// Dashboard
final dashboard = await http.get(
  Uri.parse('$baseUrl/api/audit/dashboard?startDate=2024-01-01'),
);

// Exportar reporte
final report = await http.get(
  Uri.parse('$baseUrl/api/audit/export?format=csv&action=delete'),
);
```

### Backend (Node.js)

```javascript
const AdvancedAuditService = require('./services/advanced_audit_service');
const advancedAuditService = new AdvancedAuditService();

// Búsqueda avanzada
const results = await advancedAuditService.advancedSearch({
  query: 'admin',
  action: 'delete',
  startDate: '2024-01-01',
  limit: 100
});

// Dashboard
const dashboard = await advancedAuditService.getAuditDashboard(
  '2024-01-01',
  '2024-12-31'
);

// Detectar actividad sospechosa
const suspicious = await advancedAuditService.detectSuspiciousActivity();
```

---

## 🎯 Próximos Pasos

1. **Integración Frontend:**
   - Crear vista de dashboard de auditoría
   - Implementar búsqueda avanzada en UI
   - Agregar exportación de reportes

2. **Notificaciones:**
   - Integrar alertas con sistema de notificaciones
   - Enviar emails cuando se detecte actividad sospechosa

3. **Mejoras:**
   - Agregar más patrones de detección
   - Implementar machine learning para detección de anomalías
   - Agregar visualizaciones gráficas

---

**Última actualización:** 18 de Noviembre 2025  
**Mantenido por:** Equipo de Desarrollo - MovilesII

