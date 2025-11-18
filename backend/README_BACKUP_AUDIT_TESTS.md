# 🔧 Sistema de Backup, Auditoría y Testing

## 📋 Resumen

Este documento describe las funcionalidades implementadas para completar las 3 áreas faltantes del proyecto:

1. **Backup Automático y Políticas de Retención** (US027, US030)
2. **Triggers de Auditoría** (US027)
3. **Testing Automatizado** (Todas las US)

---

## 1. 📦 Sistema de Backup Automático

### Servicio: `services/backup_service.js`

**Funcionalidades:**
- ✅ Backup automático programado (configurable)
- ✅ Backup manual bajo demanda
- ✅ Restauración de backups
- ✅ Políticas de retención de backups (eliminación automática de backups antiguos)
- ✅ Políticas de retención de datos (archivado de documentos antiguos)
- ✅ Estadísticas de backups

### Endpoints:

#### `POST /api/backup/create`
Crear backup manual de todas las colecciones.

**Body (opcional):**
```json
{
  "collections": ["Asistencia", "Usuario"],
  "includeMetadata": true
}
```

#### `GET /api/backup/list`
Listar todos los backups disponibles.

#### `POST /api/backup/restore/:backupId`
Restaurar desde un backup específico.

**Body (opcional):**
```json
{
  "collections": ["Asistencia"],
  "clearExisting": false
}
```

#### `GET /api/backup/stats`
Obtener estadísticas de backups (cantidad, tamaño total, etc.).

#### `POST /api/backup/configure`
Configurar backup automático.

**Body:**
```json
{
  "enabled": true,
  "intervalHours": 6,
  "retentionDays": 90
}
```

#### `POST /api/retention/apply/:collectionName`
Aplicar política de retención a una colección específica.

**Body:**
```json
{
  "retentionDays": 90
}
```

### Configuración Automática

El backup automático se configura al iniciar el servidor:
- **Intervalo:** Cada 6 horas
- **Retención:** 90 días
- **Ubicación:** `data/backups/`

---

## 2. 🔍 Sistema de Auditoría

### Servicio: `services/audit_service.js`

**Funcionalidades:**
- ✅ Registro automático de todas las acciones (create, update, delete)
- ✅ Middleware de Express para capturar información de usuario
- ✅ Historial completo de cambios
- ✅ Estadísticas de auditoría
- ✅ Búsqueda y filtrado de logs

### Modelo de Datos

El servicio crea automáticamente la colección `auditlogs` con:
- `entity_type`: Tipo de entidad (usuario, asistencia, etc.)
- `entity_id`: ID de la entidad modificada
- `action`: Acción realizada (create, update, delete, activate, deactivate)
- `user_id`: ID del usuario que realizó la acción
- `user_name`: Nombre del usuario
- `user_role`: Rol del usuario (admin, guardia, sistema)
- `changes`: Cambios realizados (campos modificados)
- `previous_state`: Estado anterior (para updates)
- `new_state`: Nuevo estado (para creates/updates)
- `ip_address`: IP del usuario
- `user_agent`: User agent del navegador
- `timestamp`: Fecha y hora de la acción

### Endpoints:

#### `GET /api/audit/history`
Obtener historial de auditoría con filtros.

**Query Params:**
- `entityType`: Filtrar por tipo de entidad
- `entityId`: Filtrar por ID de entidad
- `userId`: Filtrar por usuario
- `action`: Filtrar por acción (create, update, delete)
- `startDate`: Fecha inicio (ISO format)
- `endDate`: Fecha fin (ISO format)
- `limit`: Límite de resultados (default: 100)
- `skip`: Offset (default: 0)

#### `GET /api/audit/entity/:entityType/:entityId`
Obtener historial de una entidad específica.

**Query Params:**
- `limit`: Límite de resultados (default: 50)

#### `GET /api/audit/stats`
Obtener estadísticas de auditoría.

**Query Params:**
- `startDate`: Fecha inicio (ISO format)
- `endDate`: Fecha fin (ISO format)

#### `POST /api/audit/log`
Registrar acción de auditoría manualmente (si es necesario).

### Middleware

El middleware de auditoría se aplica automáticamente a todas las rutas y captura:
- Información del usuario desde `req.user`
- IP address desde `req.ip`
- User agent desde headers

---

## 3. 🧪 Sistema de Testing

### Framework: Jest

**Configuración:** `jest.config.js`

### Estructura de Tests:

```
tests/
├── unit/
│   ├── backup_service.test.js
│   └── audit_service.test.js
└── integration/
    └── api.test.js
```

### Scripts NPM:

- `npm test` - Ejecutar todos los tests con coverage
- `npm run test:watch` - Ejecutar tests en modo watch
- `npm run test:unit` - Ejecutar solo tests unitarios
- `npm run test:integration` - Ejecutar solo tests de integración

### Tests Unitarios Implementados:

#### `backup_service.test.js`
- ✅ Crear backup exitosamente
- ✅ Incluir todas las colecciones por defecto
- ✅ Respaldar solo colecciones especificadas
- ✅ Crear archivo de backup
- ✅ Listar backups disponibles
- ✅ Limpiar backups antiguos
- ✅ Configurar backup automático
- ✅ Obtener estadísticas

#### `audit_service.test.js`
- ✅ Registrar acción de auditoría
- ✅ Retornar null si auditoría deshabilitada
- ✅ Incluir información de usuario y cambios
- ✅ Obtener historial de auditoría
- ✅ Filtrar por tipo de entidad
- ✅ Filtrar por rango de fechas
- ✅ Obtener historial de entidad específica
- ✅ Obtener estadísticas de auditoría
- ✅ Middleware agrega información al request

### Tests de Integración:

Los tests de integración están preparados pero requieren:
- Base de datos de prueba (MongoDB Memory Server)
- Servidor Express de prueba configurado
- Setup y teardown de datos de prueba

---

## 📝 Instalación

### Dependencias

```bash
npm install
```

Esto instalará:
- `jest` - Framework de testing
- `supertest` - Para tests de API

### Ejecutar Tests

```bash
# Todos los tests
npm test

# Solo tests unitarios
npm run test:unit

# Modo watch
npm run test:watch
```

---

## ✅ Criterios de Aceptación Completados

### US027 - Guardar fecha, hora, datos
- ✅ Persistencia completa de datos
- ✅ Integridad referencial (validaciones en código)
- ✅ Backup automático implementado
- ✅ Triggers de auditoría implementados

### US030 - Historial completo
- ✅ Almacenamiento permanente
- ✅ Índices optimizados (en modelo de auditoría)
- ✅ Políticas retención implementadas
- ✅ Archivado histórico implementado

### Testing
- ✅ Tests unitarios para servicios críticos
- ✅ Framework de testing configurado
- ✅ Estructura de tests preparada
- ⚠️ Tests de integración (requieren configuración adicional)

---

## 🚀 Próximos Pasos

1. **Configurar base de datos de prueba** para tests de integración
2. **Agregar más tests unitarios** para otros servicios
3. **Configurar CI/CD** para ejecutar tests automáticamente
4. **Agregar tests de rendimiento** para backup y auditoría
5. **Documentar casos de uso** específicos

---

*Documentación creada: Noviembre 2025*

