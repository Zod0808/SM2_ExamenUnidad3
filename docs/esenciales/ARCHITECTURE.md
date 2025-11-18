# Documentación de Arquitectura Técnica

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Arquitectura General](#arquitectura-general)
3. [Vista Lógica](#vista-lógica)
4. [Vista de Procesos](#vista-de-procesos)
5. [Vista de Despliegue](#vista-de-despliegue)
6. [Vista de Implementación](#vista-de-implementación)
7. [Vista de Datos](#vista-de-datos)
8. [Patrones de Diseño](#patrones-de-diseño)
9. [Atributos de Calidad](#atributos-de-calidad)
10. [Tecnologías y Frameworks](#tecnologías-y-frameworks)

---

## Introducción

Este documento describe la arquitectura técnica del Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas. La arquitectura sigue el modelo de vistas 4+1 de Philippe Kruchten y está diseñada para ser escalable, mantenible y robusta.

**Versión:** 1.0.0  
**Última Actualización:** Enero 2025

---

## Arquitectura General

### Visión de Alto Nivel

El sistema está compuesto por tres componentes principales:

1. **Aplicación Móvil Flutter** - Interfaz para guardias de seguridad
2. **API REST Node.js** - Backend central con lógica de negocio
3. **Dashboard Web** - Interfaz administrativa en tiempo real

```
┌─────────────────┐         ┌──────────────┐         ┌─────────────┐
│  App Flutter    │◄───────►│  API REST    │◄───────►│  MongoDB    │
│  (Guardias)     │  HTTP   │  Node.js     │         │  Atlas      │
└─────────────────┘         └──────────────┘         └─────────────┘
                                      │
                                      │ WebSocket
                                      ▼
                             ┌──────────────┐
                             │  Dashboard   │
                             │     Web      │
                             └──────────────┘
```

### Principios Arquitectónicos

- **Separación de Responsabilidades**: Cada componente tiene una responsabilidad única y bien definida
- **Modularidad**: Sistema dividido en módulos independientes y reutilizables
- **Escalabilidad**: Arquitectura diseñada para crecer horizontalmente
- **Resiliencia**: Tolerancia a fallos con funcionalidad offline
- **Seguridad**: Múltiples capas de seguridad y cumplimiento normativo

---

## Vista Lógica

### Arquitectura en Capas

El sistema sigue una arquitectura en capas con separación clara de responsabilidades:

```
┌─────────────────────────────────────────┐
│         Capa de Presentación            │
│  (Flutter Views, Dashboard Web)         │
└─────────────────────────────────────────┘
                    │
┌─────────────────────────────────────────┐
│         Capa de Aplicación             │
│  (ViewModels, Controllers, Services)    │
└─────────────────────────────────────────┘
                    │
┌─────────────────────────────────────────┐
│         Capa de Dominio                 │
│  (Models, Business Logic, Rules)        │
└─────────────────────────────────────────┘
                    │
┌─────────────────────────────────────────┐
│         Capa de Infraestructura        │
│  (API Client, Database, BLE, Storage)  │
└─────────────────────────────────────────┘
```

### Módulos Principales

#### 1. Módulo de Autenticación y Seguridad

**Responsabilidades:**
- Autenticación de usuarios (guardias y administradores)
- Gestión de sesiones
- Control de acceso basado en roles (RBAC)
- Encriptación y hash de contraseñas

**Componentes:**
- `AuthService` - Servicio de autenticación
- `AuthViewModel` - Lógica de presentación de autenticación
- `AuthMiddleware` - Middleware de validación de tokens
- `PasswordService` - Hash y validación de contraseñas

#### 2. Módulo de Control de Acceso NFC

**Responsabilidades:**
- Detección de pulseras NFC/BLE
- Lectura de identificadores únicos
- Validación de permisos de acceso
- Registro de accesos (entrada/salida)

**Componentes:**
- `NFCService` - Servicio de detección NFC/BLE
- `NFCViewModel` - Lógica de presentación NFC
- `AccessControlService` - Validación y registro de accesos
- `PresenceService` - Gestión de presencia en campus

#### 3. Módulo de Gestión de Estudiantes

**Responsabilidades:**
- Consulta de datos de estudiantes
- Verificación de estado de matrícula
- Sincronización con BD institucional
- Gestión de visitantes externos

**Componentes:**
- `StudentService` - Consulta de estudiantes
- `MatriculationService` - Verificación de matrícula
- `ExternalVisitorService` - Gestión de visitantes
- `StudentViewModel` - Lógica de presentación

#### 4. Módulo de Sincronización Offline

**Responsabilidades:**
- Almacenamiento local de datos
- Cola de operaciones offline
- Sincronización bidireccional
- Resolución de conflictos

**Componentes:**
- `OfflineSyncService` - Servicio de sincronización
- `LocalDatabaseService` - Base de datos local (SQLite)
- `SyncQueue` - Cola de operaciones pendientes
- `ConflictResolver` - Resolución de conflictos

#### 5. Módulo de Machine Learning

**Responsabilidades:**
- Recolección y preparación de datos
- Entrenamiento de modelos
- Predicciones de flujo estudiantil
- Análisis de patrones

**Componentes:**
- `MLDataCollector` - Recolección de datos
- `MLTrainer` - Entrenamiento de modelos
- `MLPredictor` - Predicciones
- `MLMetricsService` - Métricas y evaluación

#### 6. Módulo de Reportes y Analytics

**Responsabilidades:**
- Generación de reportes
- Visualización de datos
- Análisis comparativos
- Exportación de datos

**Componentes:**
- `ReportsService` - Generación de reportes
- `AnalyticsService` - Análisis de datos
- `ExportService` - Exportación (PDF, Excel, CSV)
- `DashboardService` - Métricas en tiempo real

#### 7. Módulo de Backup y Auditoría

**Responsabilidades:**
- Backup automático de datos
- Políticas de retención
- Sistema de auditoría completo
- Restauración de backups

**Componentes:**
- `BackupService` - Creación y gestión de backups
- `AuditService` - Registro de auditoría
- `RetentionService` - Políticas de retención
- `RestoreService` - Restauración de datos

---

## Vista de Procesos

### Flujo de Autenticación

```
Usuario → Login Request → AuthService → Validar Credenciales
    ↓
Verificar Password (BCrypt) → Generar Sesión → Retornar Datos Usuario
```

### Flujo de Control de Acceso

```
1. Guardia inicia sesión
2. Selecciona punto de control
3. Escanea pulsera NFC/BLE
4. Sistema lee ID único
5. Valida estudiante en BD
6. Verifica estado de matrícula
7. Determina tipo de acceso (entrada/salida)
8. Registra acceso con timestamp
9. Actualiza presencia en campus
10. Notifica cambios vía WebSocket
```

### Flujo de Sincronización Offline

```
App Offline → Operación Local → Guardar en SQLite → Agregar a Queue
    ↓
App Online → Detectar Conexión → Procesar Queue → Sincronizar con Servidor
    ↓
Detectar Conflictos → Resolver Conflictos → Actualizar Local
```

### Flujo de Machine Learning

```
1. Recolectar datos históricos
2. Limpiar y transformar datos (ETL)
3. Dividir en train/test
4. Entrenar modelos (regresión, clustering, ARIMA)
5. Validar modelos (cross-validation)
6. Desplegar modelos
7. Realizar predicciones
8. Monitorear drift
9. Reentrenar periódicamente
```

---

## Vista de Despliegue

### Arquitectura Cloud

```
┌─────────────────────────────────────────────────┐
│              Internet / CDN                     │
└─────────────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
┌───────▼────────┐    ┌────────▼────────┐
│  Load Balancer │    │  API Gateway     │
└───────┬────────┘    └────────┬─────────┘
        │                      │
┌───────▼──────────────────────▼────────┐
│      API Servers (Node.js)            │
│  ┌──────────┐  ┌──────────┐          │
│  │ Server 1 │  │ Server 2 │  ...     │
│  └──────────┘  └──────────┘          │
└───────┬──────────────────────┬────────┘
        │                      │
┌───────▼──────────┐  ┌────────▼──────────┐
│  MongoDB Atlas   │  │   Redis Cache     │
│  (Replica Set)   │  │   (Sessions)      │
└──────────────────┘  └───────────────────┘
```

### Componentes de Despliegue

**Aplicación Móvil:**
- Distribuida vía Google Play Store (Android)
- Distribuida vía App Store (iOS)
- Actualizaciones automáticas mediante versionado

**API REST:**
- Desplegada en servidores cloud (Render, Heroku, AWS)
- Balanceador de carga para alta disponibilidad
- Escalado horizontal automático

**Base de Datos:**
- MongoDB Atlas con replica set (3 nodos)
- Backup automático diario
- Alta disponibilidad con failover automático

**Dashboard Web:**
- Servido como archivos estáticos desde la API
- CDN para assets estáticos
- WebSocket para actualizaciones en tiempo real

---

## Vista de Implementación

### Estructura de Directorios

```
MovilesII/
├── lib/                          # Aplicación Flutter
│   ├── main.dart
│   ├── config/                   # Configuraciones
│   ├── models/                   # Modelos de datos
│   ├── services/                 # Servicios de negocio
│   ├── viewmodels/              # ViewModels (MVVM)
│   ├── views/                   # Vistas/Pantallas
│   └── widgets/                 # Widgets reutilizables
│
├── backend/                      # Backend Node.js
│   ├── index.js                 # Servidor principal
│   ├── models/                  # Modelos Mongoose
│   ├── services/                # Servicios backend
│   ├── ml/                      # Machine Learning
│   ├── tests/                   # Tests
│   └── public/                  # Archivos estáticos
│
└── docs/                        # Documentación
```

### Componentes Clave

#### Frontend (Flutter)

**Patrón:** MVVM (Model-View-ViewModel)

- **Models**: Representan los datos del dominio
- **Views**: Interfaz de usuario (pantallas)
- **ViewModels**: Lógica de presentación y estado
- **Services**: Lógica de negocio y comunicación con API

**Ejemplo de Estructura:**
```dart
lib/
├── models/
│   ├── alumno_model.dart
│   ├── asistencia_model.dart
│   └── usuario_model.dart
├── services/
│   ├── api_service.dart
│   ├── nfc_service.dart
│   └── offline_sync_service.dart
├── viewmodels/
│   ├── auth_viewmodel.dart
│   └── admin_viewmodel.dart
└── views/
    ├── login_view.dart
    └── dashboard_view.dart
```

#### Backend (Node.js)

**Patrón:** MVC (Model-View-Controller)

- **Models**: Esquemas Mongoose y validaciones
- **Controllers**: Lógica de endpoints (en index.js)
- **Services**: Lógica de negocio reutilizable
- **Middleware**: Autenticación, validación, logging

**Ejemplo de Estructura:**
```javascript
backend/
├── models/
│   ├── User.js
│   ├── Asistencia.js
│   └── Alumno.js
├── services/
│   ├── backup_service.js
│   ├── audit_service.js
│   └── historical_data_service.js
└── index.js (Controllers/Routes)
```

---

## Vista de Datos

### Modelo de Datos Principal

#### Colección: usuarios

```javascript
{
  _id: String (UUID),
  nombre: String,
  apellido: String,
  dni: String (unique),
  email: String (unique),
  password: String (hashed),
  rango: Enum ['admin', 'guardia'],
  estado: Enum ['activo', 'inactivo'],
  puerta_acargo: String,
  telefono: String,
  fecha_creacion: Date,
  fecha_actualizacion: Date
}
```

#### Colección: alumnos

```javascript
{
  _id: String (UUID),
  nombre: String,
  apellido: String,
  dni: String,
  codigo_universitario: String (unique, indexed),
  escuela_profesional: String,
  facultad: String,
  siglas_escuela: String,
  siglas_facultad: String,
  estado: Boolean
}
```

#### Colección: asistencias

```javascript
{
  _id: String (UUID),
  nombre: String,
  apellido: String,
  dni: String,
  codigo_universitario: String,
  siglas_facultad: String,
  siglas_escuela: String,
  tipo: Enum ['entrada', 'salida'],
  fecha_hora: Date (indexed),
  entrada_tipo: Enum ['nfc', 'manual'],
  puerta: String,
  guardia_id: String,
  guardia_nombre: String,
  autorizacion_manual: Boolean,
  razon_decision: String,
  timestamp_decision: Date,
  coordenadas: String,
  descripcion_ubicacion: String
}
```

#### Colección: presencia

```javascript
{
  _id: String (UUID),
  estudiante_id: String,
  estudiante_dni: String (indexed),
  estudiante_nombre: String,
  facultad: String,
  escuela: String,
  hora_entrada: Date,
  hora_salida: Date,
  punto_entrada: String,
  punto_salida: String,
  esta_dentro: Boolean (indexed),
  guardia_entrada: String,
  guardia_salida: String,
  tiempo_en_campus: Number
}
```

### Índices Estratégicos

```javascript
// Colección: asistencias
db.asistencias.createIndex({ dni: 1, fecha_hora: -1 });
db.asistencias.createIndex({ fecha_hora: -1 });
db.asistencias.createIndex({ codigo_universitario: 1 });

// Colección: presencia
db.presencia.createIndex({ estudiante_dni: 1, esta_dentro: 1 });
db.presencia.createIndex({ esta_dentro: 1, hora_entrada: 1 });

// Colección: alumnos
db.alumnos.createIndex({ codigo_universitario: 1 }, { unique: true });
db.alumnos.createIndex({ dni: 1 });
```

### Relaciones

El sistema utiliza un modelo NoSQL sin relaciones explícitas. Las relaciones se manejan mediante referencias por ID:

- `asistencias.guardia_id` → `usuarios._id`
- `asistencias.codigo_universitario` → `alumnos.codigo_universitario`
- `presencia.estudiante_dni` → `alumnos.dni`

---

## Patrones de Diseño

### Patrones Implementados

#### 1. Repository Pattern

Abstrae el acceso a datos, permitiendo cambiar la implementación sin afectar la lógica de negocio.

```dart
abstract class StudentRepository {
  Future<Alumno?> getStudentByCode(String code);
  Future<List<Alumno>> getAllStudents();
}
```

#### 2. Service Layer Pattern

Encapsula la lógica de negocio en servicios reutilizables.

```dart
class AccessControlService {
  Future<AccessResult> registerAccess(AccessData data);
  Future<bool> validateAccess(String studentCode);
}
```

#### 3. Observer Pattern

Para actualizaciones en tiempo real mediante WebSockets.

```javascript
io.on('connection', (socket) => {
  socket.on('subscribe', (channel) => {
    socket.join(channel);
  });
});
```

#### 4. Strategy Pattern

Para algoritmos de ML intercambiables.

```javascript
class MLStrategy {
  train(data) {}
  predict(features) {}
}

class LinearRegressionStrategy extends MLStrategy {}
class ClusteringStrategy extends MLStrategy {}
```

#### 5. Factory Pattern

Para creación de modelos y servicios.

```dart
class ModelFactory {
  static Alumno createAlumno(Map<String, dynamic> data) {
    return Alumno.fromJson(data);
  }
}
```

---

## Atributos de Calidad

### Disponibilidad

**Objetivo:** 99.5% uptime durante horario académico

**Estrategias:**
- Replica set de MongoDB (3 nodos)
- Funcionalidad offline en app móvil
- Health checks automáticos
- Failover automático

### Seguridad

**Objetivo:** Cumplimiento Ley N° 29733 y GDPR

**Estrategias:**
- Encriptación TLS 1.3 en tránsito
- Hash BCrypt para contraseñas
- Auditoría completa de operaciones
- Control de acceso basado en roles

### Rendimiento

**Objetivo:** < 2 segundos para operaciones críticas

**Estrategias:**
- Caché Redis para datos frecuentes
- Índices optimizados en MongoDB
- Procesamiento asíncrono para ML
- Compresión Gzip en respuestas

### Escalabilidad

**Objetivo:** Soporte para 1000 usuarios concurrentes

**Estrategias:**
- Arquitectura horizontal escalable
- Load balancing
- Connection pooling
- Procesamiento distribuido

### Mantenibilidad

**Objetivo:** Código modular y documentado

**Estrategias:**
- Separación de responsabilidades
- Principios SOLID
- Documentación completa
- Tests automatizados

---

## Tecnologías y Frameworks

### Frontend Móvil

- **Flutter 3.7.2+** - Framework multiplataforma
- **Provider** - Gestión de estado
- **Hive/SQLite** - Base de datos local
- **flutter_nfc_kit** - Integración NFC/BLE
- **http** - Cliente HTTP
- **socket_io_client** - WebSockets

### Backend

- **Node.js 18.x LTS** - Runtime JavaScript
- **Express.js** - Framework web
- **MongoDB/Mongoose** - Base de datos NoSQL
- **Socket.IO** - WebSockets
- **bcrypt** - Hash de contraseñas
- **JWT** (futuro) - Autenticación con tokens

### Machine Learning

- **Python 3.9+** - Lenguaje de ML
- **scikit-learn** - Modelos de ML
- **pandas** - Manipulación de datos
- **numpy** - Cálculos numéricos
- **statsmodels** - Series temporales (ARIMA)

### Infraestructura

- **MongoDB Atlas** - Base de datos cloud
- **Redis** (futuro) - Caché y sesiones
- **Docker** (futuro) - Contenedores
- **GitHub Actions** (futuro) - CI/CD

---

## Consideraciones de Seguridad

### Autenticación y Autorización

- Contraseñas hasheadas con BCrypt (factor 12)
- Sesiones con timeout configurable
- Control de acceso basado en roles (RBAC)
- Validación de permisos en cada endpoint

### Protección de Datos

- Encriptación TLS 1.3 para datos en tránsito
- Encriptación AES-256 para datos sensibles (futuro)
- Políticas de retención de datos
- Cumplimiento Ley N° 29733 y GDPR

### Prevención de Ataques

- Validación y sanitización de inputs
- Protección contra SQL Injection (Mongoose)
- Protección contra XSS (CSP headers)
- Rate limiting (futuro)

---

## Monitoreo y Observabilidad

### Métricas Clave

- Tiempo de respuesta de API
- Tasa de errores
- Uso de recursos (CPU, memoria)
- Conexiones activas
- Throughput de accesos

### Logging

- Logs de todas las operaciones críticas
- Auditoría completa de cambios
- Errores con stack traces
- Métricas de performance

### Alertas

- Disponibilidad del sistema
- Errores críticos
- Performance degradada
- Espacio en disco

---

## Escalabilidad Futura

### Mejoras Planificadas

1. **Implementación de JWT** - Autenticación stateless
2. **Redis Cache** - Caché distribuido
3. **Microservicios** - Separación de servicios ML
4. **Kubernetes** - Orquestación de contenedores
5. **CDN** - Distribución de contenido estático
6. **Message Queue** - Procesamiento asíncrono robusto

---

## Conclusión

La arquitectura del sistema está diseñada para ser:

- **Escalable**: Puede crecer horizontalmente
- **Mantenible**: Código modular y bien documentado
- **Segura**: Múltiples capas de seguridad
- **Resiliente**: Funcionalidad offline y tolerancia a fallos
- **Performante**: Optimizado para tiempos de respuesta rápidos

Esta arquitectura proporciona una base sólida para el crecimiento futuro del sistema y la incorporación de nuevas funcionalidades.

---

**Última Actualización:** Enero 2025  
**Versión:** 1.0.0
