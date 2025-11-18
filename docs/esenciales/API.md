# Documentación de API REST

> ⚠️ **Nota:** Esta es la documentación básica. Para documentación completa y actualizada, ver [API_COMPLETA.md](./API_COMPLETA.md)

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Autenticación](#autenticación)
3. [Base URL](#base-url)
4. [Endpoints](#endpoints)
   - [Autenticación y Usuarios](#autenticación-y-usuarios)
   - [Puntos de Control](#puntos-de-control)
   - [Asignaciones](#asignaciones)
   - [Estudiantes y Alumnos](#estudiantes-y-alumnos)
   - [Control de Accesos](#control-de-accesos)
   - [Presencia](#presencia)
   - [Sesiones de Guardias](#sesiones-de-guardias)
   - [Sincronización](#sincronización)
   - [Backup y Auditoría](#backup-y-auditoría)
   - [Reportes](#reportes)
   - [Machine Learning](#machine-learning)
   - [Dashboard](#dashboard)
5. [Códigos de Estado HTTP](#códigos-de-estado-http)
6. [Manejo de Errores](#manejo-de-errores)
7. [Ejemplos de Uso](#ejemplos-de-uso)

---

## Introducción

Esta API REST proporciona acceso completo a todas las funcionalidades del Sistema de Control de Acceso con Pulseras Inteligentes. La API utiliza JSON para el intercambio de datos y sigue los principios RESTful.

**Versión de la API:** 1.0.0  
**Formato de Datos:** JSON  
**Codificación de Caracteres:** UTF-8

---

## Autenticación

El sistema utiliza autenticación basada en sesiones. Para acceder a los endpoints protegidos, primero debes autenticarte mediante el endpoint `/login`.

### Login

```http
POST /login
Content-Type: application/json

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

**Respuesta de Error (401):**
```json
{
  "error": "Credenciales incorrectas"
}
```

### Nota sobre Autenticación

Actualmente, la API no requiere tokens JWT en los headers para la mayoría de endpoints. Sin embargo, se recomienda implementar autenticación basada en tokens para producción. Los endpoints que requieren autenticación validan la sesión del usuario.

---

## Base URL

**Desarrollo:**
```
http://localhost:3000
```

**Producción:**
```
https://tu-backend.onrender.com
```

---

## Endpoints

### Autenticación y Usuarios

#### POST /login
Autentica un usuario y devuelve sus datos.

**Request Body:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response:** Datos del usuario (sin contraseña)

---

#### GET /usuarios
Obtiene la lista de todos los usuarios.

**Response:**
```json
[
  {
    "_id": "uuid",
    "nombre": "Juan",
    "apellido": "Pérez",
    "dni": "12345678",
    "email": "juan@universidad.edu",
    "rango": "guardia",
    "estado": "activo",
    "puerta_acargo": "Puerta Principal",
    "telefono": "987654321",
    "fecha_creacion": "2025-01-01T00:00:00.000Z",
    "fecha_actualizacion": "2025-01-01T00:00:00.000Z"
  }
]
```

---

#### POST /usuarios
Crea un nuevo usuario (guardia o administrador).

**Request Body:**
```json
{
  "nombre": "Juan",
  "apellido": "Pérez",
  "dni": "12345678",
  "email": "juan@universidad.edu",
  "password": "contraseña123",
  "rango": "guardia",
  "puerta_acargo": "Puerta Principal",
  "telefono": "987654321"
}
```

**Campos Requeridos:** `nombre`, `apellido`, `dni`, `email`, `password`

**Response (201):** Usuario creado (sin contraseña)

---

#### GET /usuarios/:id
Obtiene un usuario específico por ID.

**Response:** Objeto usuario

---

#### PUT /usuarios/:id
Actualiza un usuario existente.

**Request Body:** Campos a actualizar (excepto password)

**Response:** Usuario actualizado

---

#### PUT /usuarios/:id/password
Cambia la contraseña de un usuario.

**Request Body:**
```json
{
  "password": "nueva_contraseña"
}
```

**Response:**
```json
{
  "message": "Contraseña actualizada exitosamente"
}
```

---

### Puntos de Control

#### GET /puntos-control
Obtiene todos los puntos de control.

**Response:**
```json
[
  {
    "_id": "uuid",
    "nombre": "Puerta Principal",
    "ubicacion": "Entrada Principal",
    "descripcion": "Punto de control principal"
  }
]
```

---

#### POST /puntos-control
Crea un nuevo punto de control.

**Request Body:**
```json
{
  "nombre": "Puerta Principal",
  "ubicacion": "Entrada Principal",
  "descripcion": "Punto de control principal"
}
```

**Campos Requeridos:** `nombre`

**Response (201):** Punto de control creado

---

#### PUT /puntos-control/:id
Actualiza un punto de control.

**Request Body:** Campos a actualizar

**Response:** Punto de control actualizado

---

#### DELETE /puntos-control/:id
Elimina un punto de control.

**Response:**
```json
{
  "message": "Punto de control eliminado"
}
```

---

#### GET /puntos-control/:id/asignaciones
Obtiene las asignaciones activas de un punto de control.

**Response:** Array de asignaciones

---

### Asignaciones

#### GET /asignaciones
Obtiene todas las asignaciones.

**Response:** Array de asignaciones

---

#### POST /asignaciones
Crea múltiples asignaciones de guardias a puntos de control.

**Request Body:**
```json
{
  "asignaciones": [
    {
      "guardia_id": "uuid-guardia",
      "punto_id": "uuid-punto",
      "fecha_inicio": "2025-01-01T00:00:00.000Z",
      "fecha_fin": "2025-12-31T23:59:59.999Z"
    }
  ]
}
```

**Campos Requeridos:** `guardia_id`, `punto_id`, `fecha_inicio`

**Response (201):** Array de asignaciones creadas

**Error (409):** Conflicto si el guardia ya está asignado

---

#### PUT /asignaciones/:id/finalizar
Finaliza una asignación activa.

**Response:** Asignación finalizada

---

### Estudiantes y Alumnos

#### GET /alumnos
Obtiene todos los alumnos.

**Query Parameters:**
- `siglas_facultad` (opcional): Filtrar por facultad
- `siglas_escuela` (opcional): Filtrar por escuela

**Response:** Array de alumnos

---

#### GET /alumnos/:codigo
Busca un alumno por código universitario.

**Response:**
```json
{
  "_id": "uuid",
  "nombre": "María",
  "apellido": "García",
  "dni": "87654321",
  "codigo_universitario": "202012345",
  "escuela_profesional": "Ingeniería de Sistemas",
  "facultad": "Ingeniería",
  "siglas_escuela": "IS",
  "siglas_facultad": "FI",
  "estado": true
}
```

**Error (404):** Alumno no encontrado  
**Error (403):** Alumno no matriculado o inactivo

---

#### GET /externos
Obtiene todos los visitantes externos.

**Response:** Array de externos

---

#### GET /externos/:dni
Busca un visitante externo por DNI.

**Response:** Objeto externo

---

#### GET /facultades
Obtiene todas las facultades.

**Response:**
```json
[
  {
    "_id": "FI",
    "siglas": "FI",
    "nombre": "Facultad de Ingeniería"
  }
]
```

---

#### GET /escuelas
Obtiene todas las escuelas.

**Query Parameters:**
- `siglas_facultad` (opcional): Filtrar por facultad

**Response:** Array de escuelas

---

### Control de Accesos

#### GET /asistencias
Obtiene todas las asistencias.

**Query Parameters:**
- `fecha_inicio` (opcional): Fecha inicio (ISO 8601)
- `fecha_fin` (opcional): Fecha fin (ISO 8601)
- `dni` (opcional): Filtrar por DNI

**Response:** Array de asistencias

---

#### POST /asistencias
Registra una nueva asistencia.

**Request Body:**
```json
{
  "nombre": "María",
  "apellido": "García",
  "dni": "87654321",
  "codigo_universitario": "202012345",
  "siglas_facultad": "FI",
  "siglas_escuela": "IS",
  "tipo": "entrada",
  "fecha_hora": "2025-01-15T08:00:00.000Z",
  "entrada_tipo": "nfc",
  "puerta": "Puerta Principal",
  "guardia_id": "uuid-guardia",
  "guardia_nombre": "Juan Pérez",
  "autorizacion_manual": false,
  "coordenadas": "-18.0146,-70.2485",
  "descripcion_ubicacion": "Entrada Principal"
}
```

**Response (201):** Asistencia creada

---

#### POST /asistencias/completa
Registra una asistencia completa con validación de movimiento.

**Request Body:**
```json
{
  "dni": "87654321",
  "codigo_universitario": "202012345",
  "tipo": "entrada",
  "guardia_id": "uuid-guardia",
  "guardia_nombre": "Juan Pérez",
  "punto_control": "Puerta Principal",
  "coordenadas": "-18.0146,-70.2485",
  "autorizacion_manual": false,
  "razon_decision": null
}
```

**Response:** Asistencia registrada con validación

---

#### GET /asistencias/ultimo-acceso/:dni
Obtiene el último acceso de un estudiante.

**Response:**
```json
{
  "dni": "87654321",
  "ultimo_acceso": {
    "fecha_hora": "2025-01-15T08:00:00.000Z",
    "tipo": "entrada",
    "puerta": "Puerta Principal"
  }
}
```

---

#### GET /asistencias/historial/:dni
Obtiene el historial completo de accesos de un estudiante.

**Query Parameters:**
- `fecha_inicio` (opcional)
- `fecha_fin` (opcional)

**Response:** Array de asistencias

---

#### POST /asistencias/validar-movimiento
Valida si un movimiento (entrada/salida) es válido.

**Request Body:**
```json
{
  "dni": "87654321",
  "tipo": "entrada"
}
```

**Response:**
```json
{
  "valido": true,
  "mensaje": "Movimiento válido",
  "ultimo_tipo": "salida"
}
```

---

#### GET /asistencias/estudiantes-en-campus
Obtiene la lista de estudiantes actualmente en el campus.

**Response:**
```json
[
  {
    "dni": "87654321",
    "nombre": "María García",
    "hora_entrada": "2025-01-15T08:00:00.000Z",
    "punto_entrada": "Puerta Principal"
  }
]
```

---

#### GET /asistencias/esta-en-campus/:dni
Verifica si un estudiante está actualmente en el campus.

**Response:**
```json
{
  "esta_en_campus": true,
  "hora_entrada": "2025-01-15T08:00:00.000Z",
  "punto_entrada": "Puerta Principal"
}
```

---

#### POST /decisiones-manuales
Registra una decisión manual de autorización.

**Request Body:**
```json
{
  "estudiante_id": "uuid-estudiante",
  "estudiante_dni": "87654321",
  "estudiante_nombre": "María García",
  "guardia_id": "uuid-guardia",
  "guardia_nombre": "Juan Pérez",
  "autorizado": true,
  "razon": "Estudiante autorizado manualmente",
  "punto_control": "Puerta Principal",
  "tipo_acceso": "entrada",
  "datos_estudiante": {}
}
```

**Response (201):** Decisión manual registrada

---

#### GET /decisiones-manuales
Obtiene todas las decisiones manuales.

**Query Parameters:**
- `guardiaId` (opcional): Filtrar por guardia

**Response:** Array de decisiones manuales

---

#### GET /decisiones-manuales/guardia/:guardiaId
Obtiene las decisiones manuales de un guardia específico.

**Response:** Array de decisiones manuales

---

### Presencia

#### GET /presencia
Obtiene el estado de presencia actual.

**Response:** Array de presencias activas

---

#### POST /presencia/actualizar
Actualiza el estado de presencia de un estudiante.

**Request Body:**
```json
{
  "estudiante_dni": "87654321",
  "tipo": "entrada",
  "punto_control": "Puerta Principal",
  "guardia_id": "uuid-guardia"
}
```

**Response:** Presencia actualizada

---

#### GET /presencia/historial
Obtiene el historial de presencia.

**Query Parameters:**
- `dni` (opcional): Filtrar por DNI
- `fecha_inicio` (opcional)
- `fecha_fin` (opcional)

**Response:** Array de historial de presencia

---

#### GET /presencia/largo-tiempo
Obtiene estudiantes que llevan más de 8 horas en el campus.

**Response:** Array de presencias de largo tiempo

---

### Sesiones de Guardias

#### POST /sesiones/iniciar
Inicia una sesión de guardia en un punto de control.

**Request Body:**
```json
{
  "guardia_id": "uuid-guardia",
  "guardia_nombre": "Juan Pérez",
  "punto_control": "Puerta Principal",
  "device_info": {
    "platform": "Android",
    "device_id": "device-uuid",
    "app_version": "1.0.0"
  }
}
```

**Response (201):** Sesión iniciada

**Error (409):** Otro guardia está activo en este punto de control

---

#### POST /sesiones/heartbeat
Envía un heartbeat para mantener la sesión activa.

**Request Body:**
```json
{
  "session_token": "token-de-sesion",
  "guardia_id": "uuid-guardia"
}
```

**Response:** Sesión actualizada

---

#### POST /sesiones/finalizar
Finaliza una sesión de guardia.

**Request Body:**
```json
{
  "session_token": "token-de-sesion",
  "guardia_id": "uuid-guardia"
}
```

**Response:** Sesión finalizada

---

#### GET /sesiones/activas
Obtiene todas las sesiones activas.

**Response:** Array de sesiones activas

---

#### POST /sesiones/forzar-finalizacion
Fuerza la finalización de una sesión (solo admin).

**Request Body:**
```json
{
  "session_token": "token-de-sesion"
}
```

**Response:** Sesión finalizada forzadamente

---

### Sincronización

#### GET /sync/changes/:timestamp
Obtiene cambios desde un timestamp específico (para sincronización offline).

**Response:**
```json
{
  "changes": [
    {
      "type": "create",
      "entity": "asistencia",
      "data": {}
    }
  ],
  "timestamp": "2025-01-15T08:00:00.000Z"
}
```

---

#### POST /sync/upload
Sube cambios desde el cliente (sincronización offline).

**Request Body:**
```json
{
  "changes": [
    {
      "type": "create",
      "entity": "asistencia",
      "data": {},
      "client_timestamp": "2025-01-15T08:00:00.000Z"
    }
  ]
}
```

**Response:** Resultado de sincronización con conflictos resueltos

---

### Backup y Auditoría

#### POST /api/backup/create
Crea un backup manual de la base de datos.

**Response:**
```json
{
  "backup_id": "uuid-backup",
  "timestamp": "2025-01-15T08:00:00.000Z",
  "status": "completed"
}
```

---

#### GET /api/backup/list
Obtiene la lista de backups disponibles.

**Response:** Array de backups

---

#### POST /api/backup/restore/:backupId
Restaura un backup específico.

**Response:**
```json
{
  "message": "Backup restaurado exitosamente",
  "backup_id": "uuid-backup"
}
```

---

#### GET /api/backup/stats
Obtiene estadísticas de backups.

**Response:**
```json
{
  "total_backups": 10,
  "total_size": 1024000,
  "last_backup": "2025-01-15T08:00:00.000Z"
}
```

---

#### POST /api/backup/configure
Configura políticas de backup.

**Request Body:**
```json
{
  "enabled": true,
  "schedule": "daily",
  "retention_days": 30
}
```

**Response:** Configuración guardada

---

#### POST /api/retention/apply/:collectionName
Aplica políticas de retención a una colección.

**Request Body:**
```json
{
  "retention_days": 365
}
```

**Response:** Política aplicada

---

#### GET /api/audit/history
Obtiene el historial de auditoría.

**Query Parameters:**
- `entity_type` (opcional): Tipo de entidad
- `entity_id` (opcional): ID de entidad
- `action` (opcional): Acción (create, update, delete)
- `fecha_inicio` (opcional)
- `fecha_fin` (opcional)

**Response:** Array de registros de auditoría

---

#### GET /api/audit/entity/:entityType/:entityId
Obtiene el historial de auditoría de una entidad específica.

**Response:** Array de registros de auditoría

---

#### GET /api/audit/stats
Obtiene estadísticas de auditoría.

**Response:**
```json
{
  "total_records": 1000,
  "by_action": {
    "create": 500,
    "update": 300,
    "delete": 200
  },
  "by_entity": {
    "asistencia": 800,
    "usuario": 200
  }
}
```

---

#### POST /api/audit/log
Registra manualmente un evento de auditoría.

**Request Body:**
```json
{
  "entity_type": "asistencia",
  "entity_id": "uuid",
  "action": "create",
  "user_id": "uuid-usuario",
  "changes": {},
  "metadata": {}
}
```

**Response:** Evento registrado

---

### Reportes

#### GET /reportes/asistencias
Genera reporte de asistencias.

**Query Parameters:**
- `fecha_inicio` (requerido)
- `fecha_fin` (requerido)
- `siglas_facultad` (opcional)
- `siglas_escuela` (opcional)

**Response:**
```json
{
  "total_asistencias": 1000,
  "por_tipo": {
    "entrada": 500,
    "salida": 500
  },
  "por_facultad": {},
  "detalles": []
}
```

---

#### GET /reportes/guardias
Genera reporte de actividad de guardias.

**Query Parameters:**
- `fecha_inicio` (requerido)
- `fecha_fin` (requerido)
- `guardia_id` (opcional)

**Response:** Reporte de guardias

---

#### GET /reportes/estudiantes-activos
Obtiene reporte de estudiantes activos.

**Query Parameters:**
- `fecha` (opcional): Fecha específica
- `siglas_facultad` (opcional)
- `siglas_escuela` (opcional)

**Response:** Reporte de estudiantes activos

---

### Machine Learning

#### GET /ml/dataset/validate
Valida la estructura del dataset ML.

**Response:** Resultado de validación

---

#### POST /ml/dataset/collect
Recolecta datos para el dataset ML.

**Request Body:**
```json
{
  "start_date": "2025-01-01",
  "end_date": "2025-01-31"
}
```

**Response:** Dataset recolectado

---

#### GET /ml/dataset/statistics
Obtiene estadísticas del dataset.

**Response:** Estadísticas del dataset

---

#### POST /ml/pipeline/train
Entrena el pipeline completo de ML.

**Request Body:**
```json
{
  "models": ["regression", "clustering", "time_series"]
}
```

**Response:** Resultado del entrenamiento

---

#### GET /ml/models
Obtiene información de los modelos ML.

**Response:** Array de modelos

---

#### POST /ml/models/predict
Realiza una predicción con los modelos ML.

**Request Body:**
```json
{
  "model_type": "flow_prediction",
  "features": {
    "hour": 8,
    "day_of_week": 1,
    "month": 1
  }
}
```

**Response:** Predicción

---

#### GET /ml/reports/peak-hours
Obtiene reporte de horarios pico.

**Query Parameters:**
- `fecha` (opcional)

**Response:** Reporte de horarios pico

---

#### GET /ml/reports/comparison
Obtiene comparación antes/después.

**Query Parameters:**
- `fecha_inicio` (requerido)
- `fecha_fin` (requerido)

**Response:** Comparación

---

#### GET /ml/dashboard/summary
Obtiene resumen para dashboard ML.

**Response:** Resumen del dashboard

---

### Dashboard

#### GET /dashboard/metrics
Obtiene métricas en tiempo real para el dashboard.

**Response:**
```json
{
  "estudiantes_en_campus": 150,
  "accesos_hoy": 500,
  "entradas_hoy": 250,
  "salidas_hoy": 250,
  "guardias_activos": 5
}
```

---

#### GET /dashboard/recent-access
Obtiene accesos recientes para el dashboard.

**Query Parameters:**
- `limit` (opcional): Límite de resultados (default: 10)

**Response:** Array de accesos recientes

---

#### GET /health
Verifica el estado de salud del servidor.

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2025-01-15T08:00:00.000Z",
  "database": "connected",
  "version": "1.0.0"
}
```

---

## Códigos de Estado HTTP

| Código | Descripción |
|--------|-------------|
| 200 | OK - Solicitud exitosa |
| 201 | Created - Recurso creado exitosamente |
| 400 | Bad Request - Solicitud inválida |
| 401 | Unauthorized - No autenticado |
| 403 | Forbidden - No autorizado |
| 404 | Not Found - Recurso no encontrado |
| 409 | Conflict - Conflicto (ej: asignación duplicada) |
| 500 | Internal Server Error - Error del servidor |

---

## Manejo de Errores

Todos los errores siguen el siguiente formato:

```json
{
  "error": "Mensaje de error descriptivo"
}
```

**Ejemplos:**

```json
{
  "error": "Credenciales incorrectas"
}
```

```json
{
  "error": "Alumno no encontrado"
}
```

```json
{
  "error": "Conflicto: Guardia ya asignado a este punto"
}
```

---

## Ejemplos de Uso

### Ejemplo 1: Autenticación y Registro de Acceso

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

// 2. Buscar estudiante
const estudianteResponse = await fetch(`http://localhost:3000/alumnos/202012345`);
const estudiante = await estudianteResponse.json();

// 3. Registrar acceso
const accesoResponse = await fetch('http://localhost:3000/asistencias/completa', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    dni: estudiante.dni,
    codigo_universitario: estudiante.codigo_universitario,
    tipo: 'entrada',
    guardia_id: user.id,
    guardia_nombre: `${user.nombre} ${user.apellido}`,
    punto_control: 'Puerta Principal',
    coordenadas: '-18.0146,-70.2485',
    autorizacion_manual: false
  })
});
const acceso = await accesoResponse.json();
```

### Ejemplo 2: Obtener Estudiantes en Campus

```javascript
const response = await fetch('http://localhost:3000/asistencias/estudiantes-en-campus');
const estudiantesEnCampus = await response.json();

console.log(`Estudiantes en campus: ${estudiantesEnCampus.length}`);
```

### Ejemplo 3: Sincronización Offline

```javascript
// Obtener cambios desde el servidor
const timestamp = new Date('2025-01-15T00:00:00.000Z').toISOString();
const changesResponse = await fetch(`http://localhost:3000/sync/changes/${timestamp}`);
const { changes } = await changesResponse.json();

// Subir cambios locales
const uploadResponse = await fetch('http://localhost:3000/sync/upload', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    changes: localChanges
  })
});
const syncResult = await uploadResponse.json();
```

### Ejemplo 4: Crear Backup

```javascript
const backupResponse = await fetch('http://localhost:3000/api/backup/create', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' }
});
const backup = await backupResponse.json();
console.log(`Backup creado: ${backup.backup_id}`);
```

---

## Rate Limiting

Actualmente no hay límites de tasa implementados, pero se recomienda implementarlos en producción para prevenir abuso.

**Recomendación:** 100 requests por minuto por IP

---

## Versión de la API

La versión actual de la API es **1.0.0**. Los cambios importantes se documentarán en el changelog.

---

## Soporte

Para soporte técnico o reportar problemas, contactar al equipo de desarrollo.

**Última Actualización:** Enero 2025
