# 🎓 Sistema de Control de Acceso Universitario

Sistema completo de control de acceso a instalaciones universitarias con aplicación móvil Flutter y backend Node.js/Express, integrando tecnologías NFC, funcionalidad offline, Machine Learning, dashboard web en tiempo real y funcionalidades avanzadas de administración, seguridad y auditoría.

[![Estado del Proyecto](https://img.shields.io/badge/Estado-100%25%20Completado-success)](./docs/esenciales/INFORME_AVANCE_USER_STORIES.md)
[![User Stories](https://img.shields.io/badge/User%20Stories-68%2F68-success)](./docs/esenciales/user_stories.md)
[![Tests](https://img.shields.io/badge/Tests-160%2B-passing)](./backend/tests/README.md)
[![Cobertura](https://img.shields.io/badge/Cobertura-70%25%2B-success)](./docs/esenciales/COVERAGE_REPORTS.md)

---

## 📊 Estado del Proyecto

**Estado:** ✅ **100% COMPLETADO**

| Métrica | Valor | Estado |
|---------|-------|--------|
| **User Stories Originales** | 60/60 (100%) | ✅ Completo |
| **Nuevas User Stories** | 5/8 (62.5%) | 🟡 En progreso |
| **Tests Unitarios** | 160+ tests | ✅ Completo |
| **Cobertura de Tests** | 70%+ | ✅ Completo |
| **Endpoints API** | 62+ endpoints | ✅ Completo |
| **Servicios Backend** | 21 servicios | ✅ Completo |

**Última Actualización:** 18 de Noviembre 2025

---

## 🚀 Inicio Rápido

### Requisitos Previos
- **Flutter SDK** >= 3.7.2
- **Node.js** >= 18.0.0
- **MongoDB** (local o Atlas)
- **Git**

### Instalación

```bash
# 1. Clonar repositorio
git clone https://github.com/Sistema-de-control-de-acceso/MovilesII.git
cd MovilesII

# 2. Backend
cd backend
npm install
cp .env.example .env  # Configurar variables de entorno
npm start

# 3. Frontend (en otra terminal)
cd ..
flutter pub get
flutter run
```

### Variables de Entorno (Backend)

```env
MONGODB_URI=mongodb://localhost:27017/ASISTENCIA
PORT=3000
JWT_SECRET=tu_secret_jwt_aqui
NODE_ENV=development
```

**Ver [DEPLOYMENT.md](./docs/esenciales/DEPLOYMENT.md) para configuración completa.**

---

## ✨ Características Principales

### 🔐 Autenticación y Seguridad
- Autenticación multi-rol (Admin, Guardias, Sistema)
- Sesión configurable con timeout y advertencias
- Sistema de auditoría avanzada con trazabilidad completa
- Logs detallados de todas las operaciones críticas

### 📱 Control NFC
- Detección automática de pulseras NFC
- Validación en tiempo real contra base de datos
- Autorización manual por guardia
- Múltiples detecciones simultáneas con cola

### 🔄 Funcionalidad Offline
- Almacenamiento local con Hive/SQLite
- Sincronización bidireccional automática
- Resolución automática de conflictos
- Indicador de estado de conexión

### 🤖 Machine Learning
- Predicción de flujo de estudiantes
- Análisis de horarios pico
- Optimización de horarios de transporte
- Alertas de congestión
- Monitoreo de drift de modelos

### 📊 Dashboard y Reportes
- Dashboard web en tiempo real con WebSockets
- Reportes avanzados y comparativos
- Exportación a PDF y Excel
- Análisis de ROI y métricas de eficiencia
- Reportes de actividad de guardias

### 🧪 Testing y Calidad
- 160+ tests unitarios (Backend y Flutter)
- Cobertura mínima del 70%
- CI/CD automatizado con GitHub Actions
- Reportes de cobertura automáticos

### 🔒 Auditoría Avanzada
- Búsqueda avanzada de logs
- Dashboard de auditoría con estadísticas
- Detección de actividad sospechosa
- Trazabilidad completa de entidades
- Exportación de reportes (JSON, CSV, PDF)

---

## 🏗️ Arquitectura

```
┌─────────────────┐
│  Flutter App    │  ← Aplicación móvil (Android/iOS)
│  (Frontend)     │     - NFC, Offline, UI
└────────┬────────┘
         │ HTTP/WebSocket
         ▼
┌─────────────────┐
│  Node.js/Express│  ← Backend API
│  (Backend)      │     - REST API, WebSockets
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│     MongoDB     │  ← Base de datos
│   (Database)    │     - Datos, Logs, Auditoría
└─────────────────┘
```

**Ver [ARCHITECTURE.md](./docs/esenciales/ARCHITECTURE.md) para detalles completos.**

---

## 📁 Estructura del Proyecto

```
MovilesII/
├── lib/                          # Aplicación Flutter
│   ├── models/                   # 11 modelos de datos
│   ├── services/                 # 17 servicios
│   ├── viewmodels/               # 8 ViewModels (MVVM)
│   ├── views/                    # 28+ vistas
│   └── widgets/                  # 8 widgets reutilizables
│
├── backend/                      # Backend Node.js
│   ├── services/                 # 21 servicios
│   ├── models/                   # Modelos Mongoose
│   ├── ml/                       # Machine Learning
│   ├── tests/                    # 120+ tests backend
│   └── index.js                  # Servidor principal
│
├── test/                         # Tests Flutter
│   ├── viewmodels/               # 36+ tests
│   └── widgets/                  # 4+ tests
│
├── docs/                         # Documentación
│   ├── user_stories.md           # 60 US originales
│   ├── NUEVAS_USER_STORIES...    # 8 nuevas US
│   ├── API.md                    # Documentación API
│   └── ...                       # Más documentación
│
└── .github/workflows/            # CI/CD
    ├── ci.yml                    # Pipeline principal
    └── test-only.yml             # Tests optimizados
```

---

## 🛠️ Tecnologías

### Frontend
- **Flutter** 3.7.2 - Framework multiplataforma
- **Provider** - Gestión de estado
- **Hive/SQLite** - Almacenamiento offline
- **flutter_nfc_kit** - Integración NFC
- **socket_io_client** - WebSockets tiempo real
- **fl_chart** - Gráficos y visualizaciones

### Backend
- **Node.js** 18+ - Runtime JavaScript
- **Express.js** - Framework web
- **MongoDB/Mongoose** - Base de datos NoSQL
- **Socket.IO** - WebSockets tiempo real
- **Jest** - Framework de testing
- **node-cron** - Tareas programadas

### DevOps
- **GitHub Actions** - CI/CD
- **Jest** - Testing backend
- **Flutter Test** - Testing frontend
- **Codecov** - Cobertura de código

---

## 🧪 Testing

### Backend
```bash
cd backend
npm test                    # Todos los tests con cobertura
npm run test:unit           # Solo tests unitarios
npm run test:integration    # Solo tests de integración
npm run coverage:report     # Generar reporte Markdown
```

### Frontend
```bash
flutter test                # Todos los tests
flutter test --coverage     # Con cobertura
```

**Cobertura:** 70%+ mínimo | **Tests:** 160+ tests  
**Ver [COVERAGE_REPORTS.md](./docs/esenciales/COVERAGE_REPORTS.md) para más detalles.**

---

## 📚 Documentación

### 📖 Documentación Esencial

- **[User Stories](./docs/esenciales/user_stories.md)** - 60 User Stories originales completadas
- **[Nuevas User Stories](./docs/esenciales/NUEVAS_USER_STORIES_PROPUESTAS.md)** - 8 nuevas US (5 completadas)
- **[API Documentation](./docs/esenciales/API.md)** - Documentación completa de endpoints
- **[Architecture](./docs/esenciales/ARCHITECTURE.md)** - Arquitectura del sistema
- **[Deployment](./docs/esenciales/DEPLOYMENT.md)** - Guía de despliegue

### 🔧 Documentación Técnica

- **[CI/CD Testing](./docs/esenciales/CI_CD_TESTING.md)** - Configuración de CI/CD
- **[Coverage Reports](./docs/esenciales/COVERAGE_REPORTS.md)** - Reportes de cobertura
- **[Auditoría Avanzada](./docs/esenciales/AUDITORIA_AVANZADA.md)** - Sistema de auditoría
- **[Backend Tests](./backend/tests/README.md)** - Guía de testing backend
- **[Machine Learning](./backend/ml/README_COMPLETO_ML.md)** - Sistema ML

### 📊 Reportes y Análisis

- **[Informe de Avance](./docs/esenciales/INFORME_AVANCE_USER_STORIES.md)** - Estado detallado de todas las US
- **[Resumen de Completación](./docs/completacion/RESUMEN_COMPLETACION_USER_STORIES.md)** - Resumen consolidado de US completadas
- **[Índice de Documentación](./docs/esenciales/INDICE_DOCUMENTACION.md)** - Guía de todos los documentos

**Ver [Índice de Documentación](./docs/esenciales/INDICE_DOCUMENTACION.md) para lista completa.**

---

## 🎯 User Stories Completadas

### User Stories Originales: 60/60 (100%) ✅

**Sprint 1:** Autenticación y Fundación (10 US)  
**Sprint 2:** Core y NFC (19 US)  
**Sprint 3:** Funcionalidades Avanzadas (9 US)  
**Sprint 4:** Machine Learning (10 US)  
**Sprint 5:** Dashboard y Reportes (12 US)

### Nuevas User Stories: 5/8 (62.5%) 🟡

- ✅ **US061:** Pruebas unitarias backend
- ✅ **US062:** Pruebas unitarias frontend mobile
- ✅ **US063:** Integración de tests en CI/CD
- ✅ **US064:** Cobertura de código y reportes
- ✅ **US067:** Auditoría y trazabilidad avanzada
- 🟡 **US065:** Optimizar tamaño APK (pendiente)
- 🟡 **US066:** Optimización workflows (pendiente)
- 🟡 **US068:** Beta testing (pendiente)

**Ver [user_stories.md](./docs/esenciales/user_stories.md) y [NUEVAS_USER_STORIES_PROPUESTAS.md](./docs/esenciales/NUEVAS_USER_STORIES_PROPUESTAS.md) para detalles.**

---

## 🔐 Seguridad

- ✅ Autenticación JWT con refresh tokens
- ✅ Hash de contraseñas con bcrypt
- ✅ Middleware de autenticación en rutas protegidas
- ✅ Sistema de auditoría avanzada
- ✅ Logs detallados de operaciones críticas
- ✅ Detección de actividad sospechosa
- ✅ Trazabilidad completa de cambios
- ✅ Backup automático de datos

---

## 🚀 CI/CD

El proyecto incluye pipelines automatizados de CI/CD:

- ✅ Tests automáticos en cada push y PR
- ✅ Verificación de cobertura mínima (70%)
- ✅ Reportes de cobertura automáticos
- ✅ Build verification
- ✅ Code formatting checks

**Ver [CI_CD_TESTING.md](./docs/esenciales/CI_CD_TESTING.md) para más detalles.**

---

## 📈 Estadísticas del Proyecto

| Componente | Cantidad | Estado |
|------------|----------|--------|
| **User Stories** | 65/68 | ✅ 95.6% |
| **Tests Unitarios** | 160+ | ✅ Completo |
| **Cobertura** | 70%+ | ✅ Completo |
| **Servicios Backend** | 21 | ✅ Completo |
| **Endpoints API** | 62+ | ✅ Completo |
| **ViewModels** | 8 | ✅ Completo |
| **Vistas Flutter** | 28+ | ✅ Completo |
| **Widgets** | 8 | ✅ Completo |

---

## 🎉 Funcionalidades Destacadas

### ✨ Implementaciones Recientes

1. **Sistema de Testing Completo**
   - 120+ tests backend (Jest)
   - 40+ tests frontend (Flutter Test)
   - Cobertura del 70%+
   - CI/CD automatizado

2. **Auditoría Avanzada**
   - Búsqueda avanzada de logs
   - Dashboard de estadísticas
   - Detección de actividad sospechosa
   - Exportación de reportes

3. **Reportes de Cobertura**
   - Generación automática
   - Múltiples formatos (HTML, Markdown, JSON, CSV)
   - Alertas de umbrales
   - Integración en CI/CD

4. **Sesión Configurable**
   - Timeout configurable
   - Advertencias antes de expiración
   - Auto-logout
   - Sincronización con backend

5. **Exportación Avanzada**
   - PDF con gráficos profesionales
   - Excel nativo (.xlsx) con múltiples hojas
   - Reportes completos consolidados

---

## 📞 Soporte y Contribución

### Equipo de Desarrollo
- @Zod0808
- @Angelhc123
- @KrCrimson
- @LunaJuarezJuan

### Recursos
- **Issues:** [GitHub Issues](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues)
- **Documentación:** Ver carpeta `docs/`
- **API:** Ver [API.md](./docs/API.md)

---

## 📄 Licencia

Este proyecto es propiedad de la Universidad.

---

## 🔗 Enlaces Rápidos

- 📖 [Documentación Completa](./docs/esenciales/INDICE_DOCUMENTACION.md)
- 🧪 [Guía de Testing](./backend/tests/README.md)
- 🚀 [Guía de Despliegue](./docs/esenciales/DEPLOYMENT.md)
- 📊 [Estado de User Stories](./docs/esenciales/INFORME_AVANCE_USER_STORIES.md)
- 🔒 [Sistema de Auditoría](./docs/esenciales/AUDITORIA_AVANZADA.md)

---

**Última Actualización:** 18 de Noviembre 2025  
**Versión:** 2.1.0  
**Estado:** ✅ 100% Completado (60/60 US originales) + 5/8 nuevas US  
**Mejoras Implementadas:** ✅ Rate Limiting, Logging Centralizado, Optimización MongoDB, Documentación API
