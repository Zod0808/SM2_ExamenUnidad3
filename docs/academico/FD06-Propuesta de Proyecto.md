**![C:\\Users\\EPIS\\Documents\\upt.png][image1]**

**UNIVERSIDAD PRIVADA DE TACNA**

**FACULTAD DE INGENIERÍA**

**Escuela Profesional de Ingeniería de Sistemas**

 **Proyecto *"*Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas"**

Curso: Soluciones Móviles II

Docente: Dr. Oscar Juan Jimenez Flores

Integrantes:

**Chávez Linares, César Fabián 			2019063854**  
**Hernandez Cruz, Angel Gadiel			2021070017**  
**Arce Bracamonte, Sebastian Rodrigo		2019062986**  
**Luna Juárez, Juan Brendon			2020068762**

**Tacna – Perú**  
**2025**

| CONTROL DE VERSIONES |  |  |  |  |  |
| :---: | :---: | :---: | :---: | :---: | ----- |
| Versión | Hecha por | Revisada por | Aprobada por | Fecha | Motivo |
| 1.0 | CCL | OJF | OJF | 24/10/2025 | Versión Original |

# **Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas**

# **Documento de Propuesta de Proyecto**

# **Versión 1.0**

# **ÍNDICE GENERAL**

1. [Introducción](#introducción)
2. [Resumen Ejecutivo](#resumen-ejecutivo)
3. [Documentación Técnica](#documentación-técnica)
4. [Documentos de Configuración](#documentos-de-configuración)
5. [Documentos de Machine Learning](#documentos-de-machine-learning)
6. [Documentos de Testing](#documentos-de-testing)
7. [Otros Documentos](#otros-documentos)
8. [Estructura del Proyecto](#estructura-del-proyecto)
9. [Guía de Uso de la Documentación](#guía-de-uso-de-la-documentación)
10. [Conclusiones](#conclusiones)

---

# **1. Introducción**

Este documento presenta la propuesta completa del proyecto "Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas", incluyendo toda la documentación técnica, de configuración, testing y funcionalidades específicas desarrolladas durante el ciclo de vida del proyecto.

El propósito de este documento es servir como índice y guía de acceso a toda la documentación técnica disponible, facilitando la comprensión, implementación, mantenimiento y extensión del sistema.

**Audiencia:**
- Desarrolladores del equipo
- Nuevos contribuidores al proyecto
- Administradores de sistemas
- Stakeholders técnicos
- Equipos de mantenimiento y soporte

---

# **2. Resumen Ejecutivo**

## **2.1 Estado del Proyecto**

**Estado:** ✅ **100% COMPLETADO** (60/60 User Stories)

| Métrica | Valor |
|---------|-------|
| **User Stories Completadas** | 60/60 (100%) |
| **Sprints Completados** | 5/5 (100%) |
| **Servicios Backend** | 17 servicios |
| **Endpoints API** | 56+ endpoints |
| **Vistas Flutter** | 28+ vistas |
| **Tests Unitarios** | 79+ tests |
| **Cobertura de Tests** | 60%+ mínimo |

## **2.2 Stack Tecnológico**

**Frontend Móvil:**
- Flutter 3.7.2+ con Dart 3.x
- Provider para gestión de estado
- SQLite/Hive para almacenamiento local
- flutter_nfc_kit para NFC/BLE

**Backend:**
- Node.js 18.x LTS con Express.js
- MongoDB Atlas (NoSQL)
- Socket.IO para tiempo real
- bcrypt para seguridad

**Machine Learning:**
- Python 3.9+ con scikit-learn
- Pandas y NumPy para análisis
- TensorFlow/Keras para deep learning
- statsmodels para series temporales

## **2.3 Funcionalidades Principales**

- ✅ Autenticación multi-rol (Admin, Guardias)
- ✅ Control NFC/BLE completo con pulseras
- ✅ Modo Offline con sincronización bidireccional
- ✅ Machine Learning para predicción de flujo
- ✅ Dashboard Web en tiempo real con WebSockets
- ✅ Backup automático y políticas de retención
- ✅ Sistema de auditoría completo
- ✅ Tests automatizados (79+ tests unitarios)

---

# **3. Documentación Técnica**

Esta sección contiene la documentación técnica principal del proyecto, incluyendo guías de instalación, configuración, arquitectura y desarrollo.

## **3.1 README.md del Proyecto**

**Ubicación:** [`README.md`](../README.md)

**Descripción:** Documento principal del proyecto con instrucciones completas de instalación, configuración y uso del sistema.

**Contenido:**
- Descripción del proyecto y características principales
- Estado del proyecto (100% completado)
- Estructura del proyecto
- Funcionalidades implementadas (10 módulos principales)
- Tecnologías utilizadas
- Instrucciones de instalación paso a paso
- Guía de testing
- Documentación de uso
- Estadísticas del proyecto
- User Stories completadas

**Uso Recomendado:**
- Primera lectura para nuevos desarrolladores
- Referencia rápida de funcionalidades
- Guía de instalación inicial

---

## **3.2 Documentación de API REST**

**Ubicación:** [`docs/API.md`](API.md)

**Descripción:** Documentación completa de la API REST con todos los endpoints, autenticación, ejemplos de uso y códigos de estado HTTP.

**Contenido:**
- Introducción y base URL
- Sistema de autenticación
- Endpoints organizados por módulos:
  - Autenticación y Usuarios
  - Puntos de Control
  - Asignaciones
  - Estudiantes y Alumnos
  - Control de Accesos
  - Presencia
  - Sesiones de Guardias
  - Sincronización
  - Backup y Auditoría
  - Reportes
  - Machine Learning
  - Dashboard
- Códigos de estado HTTP
- Manejo de errores
- Ejemplos de uso prácticos
- Rate limiting

**Endpoints Documentados:** 56+ endpoints

**Uso Recomendado:**
- Desarrollo de integraciones
- Consulta de endpoints específicos
- Ejemplos de implementación
- Referencia para testing de API

---

## **3.3 Guía de Desarrollo para Contribuidores**

**Ubicación:** [`CONTRIBUTING.md`](../CONTRIBUTING.md)

**Descripción:** Guía completa para desarrolladores que desean contribuir al proyecto, incluyendo estándares de código, proceso de desarrollo y mejores prácticas.

**Contenido:**
- Código de conducta
- Cómo contribuir (bugs, mejoras, código)
- Configuración del entorno de desarrollo
- Estándares de código (Flutter/Dart y Node.js/JavaScript)
- Proceso de desarrollo (ramas, commits, testing)
- Testing (Flutter y Backend)
- Pull Requests (template y proceso)
- Estructura del proyecto
- Recursos adicionales

**Uso Recomendado:**
- Nuevos contribuidores al proyecto
- Estándares de desarrollo del equipo
- Proceso de code review
- Guía de buenas prácticas

---

## **3.4 Documentación de Arquitectura Técnica**

**Ubicación:** [`docs/ARCHITECTURE.md`](ARCHITECTURE.md)

**Descripción:** Documentación detallada de la arquitectura técnica del sistema utilizando el modelo de vistas 4+1.

**Contenido:**
- Introducción y arquitectura general
- Vista Lógica (capas, módulos principales)
- Vista de Procesos (flujos de trabajo)
- Vista de Despliegue (arquitectura cloud)
- Vista de Implementación (estructura de código)
- Vista de Datos (modelo de datos, índices)
- Patrones de diseño implementados
- Atributos de calidad (disponibilidad, seguridad, rendimiento)
- Tecnologías y frameworks
- Consideraciones de seguridad
- Monitoreo y observabilidad
- Escalabilidad futura

**Módulos Documentados:**
1. Autenticación y Seguridad
2. Control de Acceso NFC
3. Gestión de Estudiantes
4. Sincronización Offline
5. Machine Learning
6. Reportes y Analytics
7. Backup y Auditoría

**Uso Recomendado:**
- Comprensión de la arquitectura del sistema
- Toma de decisiones técnicas
- Planificación de nuevas funcionalidades
- Onboarding de nuevos desarrolladores

---

# **4. Documentos de Configuración**

Esta sección contiene los archivos y scripts necesarios para configurar y desplegar el sistema en diferentes ambientes.

## **4.1 Archivos de Configuración de Ambientes**

### **4.1.1 Variables de Entorno - Ejemplo**

**Ubicación:** [`backend/env.example.txt`](../backend/env.example.txt)

**Descripción:** Archivo de ejemplo con todas las variables de entorno necesarias para configurar el backend.

**Variables Incluidas:**
- Configuración de base de datos (MongoDB Atlas)
- Configuración del servidor (puerto, entorno)
- Autenticación y seguridad (JWT, BCrypt)
- CORS y Rate Limiting
- Backup y retención de datos
- Machine Learning
- Logging
- WebSocket
- Sincronización offline
- Sesiones de guardias

**Uso:**
```bash
# Copiar archivo de ejemplo
cp backend/env.example.txt backend/.env

# Editar con tus credenciales
nano backend/.env
```

**Ambientes:**
- **Desarrollo:** `NODE_ENV=development`
- **Staging:** `NODE_ENV=staging`
- **Producción:** `NODE_ENV=production`

---

## **4.2 Scripts de Despliegue y Migración**

### **4.2.1 Script de Migración de Base de Datos**

**Ubicación:** [`backend/scripts/migrate.js`](../backend/scripts/migrate.js)

**Descripción:** Script para migrar y actualizar la estructura de la base de datos, crear índices y validar esquemas.

**Funcionalidades:**
- Crear índices estratégicos
- Validar estructura de colecciones
- Aplicar políticas de retención
- Verificar estado de la base de datos

**Uso:**
```bash
# Ejecutar migraciones
node backend/scripts/migrate.js up

# Ver estado de la BD
node backend/scripts/migrate.js status

# Aplicar políticas de retención
node backend/scripts/migrate.js retention
```

**Comandos Disponibles:**
- `up` - Ejecutar migraciones (crear índices, validar estructura)
- `status` - Ver estado de la base de datos
- `retention` - Aplicar políticas de retención de datos

---

### **4.2.2 Script de Backup Manual**

**Ubicación:** [`backend/scripts/backup.js`](../backend/scripts/backup.js)

**Descripción:** Script para crear backups manuales de la base de datos MongoDB.

**Funcionalidades:**
- Crear backup completo usando mongodump
- Crear backup manual (exportar a JSON)
- Limpiar backups antiguos automáticamente
- Gestionar políticas de retención de backups

**Uso:**
```bash
# Crear backup manual
node backend/scripts/backup.js
```

**Características:**
- Backup con mongodump (preferido) o método manual
- Limpieza automática de backups antiguos
- Validación de integridad
- Estadísticas de backups

---

## **4.3 Configuración de CI/CD**

### **4.3.1 GitHub Actions - Pipeline CI**

**Ubicación:** [`.github/workflows/ci.yml`](../.github/workflows/ci.yml)

**Descripción:** Pipeline de integración continua configurado con GitHub Actions.

**Jobs Incluidos:**
1. **Backend Tests** - Ejecuta tests del backend con MongoDB
2. **Flutter Tests** - Ejecuta tests de Flutter con análisis de código
3. **Code Format Check** - Verifica formato de código
4. **Build Check** - Verifica que el proyecto compile correctamente

**Características:**
- Ejecución automática en push y pull requests
- Tests con cobertura
- Análisis de código
- Verificación de builds
- Integración con Codecov

**Triggers:**
- Push a ramas `main` y `develop`
- Pull requests a `main` y `develop`

**Uso:**
El pipeline se ejecuta automáticamente. Para ejecutar localmente:
```bash
# Instalar dependencias
npm install
flutter pub get

# Ejecutar tests
npm test
flutter test
```

---

# **5. Documentos de Machine Learning**

Esta sección contiene toda la documentación relacionada con el módulo de Machine Learning del sistema.

## **5.1 README Completo de Machine Learning**

**Ubicación:** [`backend/ml/README_COMPLETO_ML.md`](../backend/ml/README_COMPLETO_ML.md)

**Descripción:** Documentación completa del sistema de Machine Learning, incluyendo todas las User Stories implementadas, algoritmos, endpoints y ejemplos de uso.

**Contenido:**
- Resumen general de las 10 User Stories de ML
- Descripción detallada de cada funcionalidad:
  - US036: Recopilar datos ML (ETL)
  - US037: Analizar patrones de flujo
  - US038: Predecir horarios pico
  - US039: Sugerir horarios de buses
  - US040: Alertas de congestión
  - US041: Análisis de clustering
  - US042: Series temporales (ARIMA)
  - US043: Monitoreo de drift
  - US044: Reentrenamiento automático
  - US045: Dashboard ML
- Endpoints de API para ML
- Ejemplos de uso
- Métricas y evaluación

**Uso Recomendado:**
- Referencia completa del módulo ML
- Implementación de nuevas funcionalidades ML
- Entendimiento de algoritmos utilizados

---

## **5.2 Proceso de ETL (Extracción, Transformación y Carga)**

**Ubicación:** [`backend/ml/README_ETL.md`](../backend/ml/README_ETL.md)

**Descripción:** Documentación detallada del proceso de extracción, transformación y carga de datos para Machine Learning.

**Contenido:**
- Pipeline ETL completo
- Recolección de datos históricos
- Limpieza y validación de datos
- Transformación de datos
- Estructura del dataset ML
- Validación de calidad de datos
- Endpoints relacionados

**Uso Recomendado:**
- Entender el proceso de preparación de datos
- Configurar pipelines ETL personalizados
- Validar calidad de datos

---

## **5.3 Algoritmos de Regresión Lineal**

**Ubicación:** [`backend/ml/README_LINEAR_REGRESSION.md`](../backend/ml/README_LINEAR_REGRESSION.md)

**Descripción:** Documentación específica de los algoritmos de regresión lineal implementados para predicción de flujo estudiantil.

**Contenido:**
- Modelos de regresión lineal
- Features utilizadas
- Entrenamiento de modelos
- Validación cruzada
- Optimización de hiperparámetros
- Métricas de evaluación
- Predicciones y uso

**Uso Recomendado:**
- Implementar nuevos modelos de regresión
- Optimizar modelos existentes
- Entender las predicciones generadas

---

## **5.4 Predicción de Horarios Pico**

**Ubicación:** [`backend/ml/README_PEAK_HOURS_PREDICTION.md`](../backend/ml/README_PEAK_HOURS_PREDICTION.md)

**Descripción:** Documentación del sistema de predicción de horarios pico de entrada y salida de estudiantes.

**Contenido:**
- Modelo predictivo de horarios pico
- Predicción 24 horas adelante
- Precisión >80% validada
- Modelos separados para entrada y salida
- Endpoints de predicción
- Métricas y evaluación
- Ejemplos de uso

**Uso Recomendado:**
- Utilizar predicciones en planificación
- Integrar con sistema de transporte
- Optimizar recursos según predicciones

---

## **5.5 Dashboard de Monitoreo ML**

**Ubicación:** [`backend/ml/README_MONITORING_DASHBOARD.md`](../backend/ml/README_MONITORING_DASHBOARD.md)

**Descripción:** Documentación del dashboard de monitoreo de modelos de Machine Learning.

**Contenido:**
- Monitoreo de drift de modelos
- Métricas de rendimiento
- Alertas automáticas
- Reentrenamiento automático
- Visualizaciones de métricas
- Endpoints de monitoreo

**Uso Recomendado:**
- Monitorear salud de modelos ML
- Detectar degradación de rendimiento
- Configurar alertas automáticas

---

# **6. Documentos de Testing**

Esta sección contiene toda la documentación relacionada con las pruebas y validación del sistema.

## **6.1 Pruebas de Respaldo y Auditoría**

**Ubicación:** [`backend/README_BACKUP_AUDIT_TESTS.md`](../backend/README_BACKUP_AUDIT_TESTS.md)

**Descripción:** Documentación detallada del sistema de backup automático, auditoría y los tests relacionados.

**Contenido:**
- Sistema de backup automático
- Políticas de retención
- Sistema de auditoría completo
- Tests del BackupService (15+ tests)
- Tests del AuditService (15+ tests)
- Ejemplos de uso
- Configuración

**Uso Recomendado:**
- Configurar backups automáticos
- Entender el sistema de auditoría
- Revisar tests de backup y auditoría

---

## **6.2 Resumen de Pruebas Realizadas**

**Ubicación:** [`backend/tests/RESUMEN_TESTS.md`](../backend/tests/RESUMEN_TESTS.md)

**Descripción:** Resumen ejecutivo de todos los tests implementados en el sistema.

**Contenido:**
- Estadísticas generales (79+ tests)
- Tests por módulo:
  - Backup Service (15+ tests)
  - Audit Service (15+ tests)
  - Historical Data Service (8+ tests)
  - API Service Validation (6+ tests)
  - Data Validation (12+ tests)
  - ML Services (8+ tests)
  - Utils (10+ tests)
  - Integration Tests (1+ test)
- Cobertura por servicio
- Casos de prueba críticos
- Métricas de calidad
- Pruebas manuales realizadas
- Áreas de mejora

**Cobertura Total:** 60%+  
**Tests Pasando:** 100%

**Uso Recomendado:**
- Vista general del estado de testing
- Identificar áreas con baja cobertura
- Planificar nuevos tests

---

## **6.3 Plan de Pruebas y Casos de Prueba**

**Ubicación:** [`backend/tests/PLAN_PRUEBAS.md`](../backend/tests/PLAN_PRUEBAS.md)

**Descripción:** Plan completo de pruebas con casos de prueba detallados para cada módulo del sistema.

**Contenido:**
- Estrategia de pruebas (3 niveles)
- Casos de prueba por módulo:
  - Autenticación (CP-001 a CP-003)
  - Control de Accesos (CP-004 a CP-007)
  - Gestión de Estudiantes (CP-008 a CP-010)
  - Sincronización Offline (CP-011 a CP-013)
  - Backup y Auditoría (CP-014 a CP-016)
  - Machine Learning (CP-017 a CP-019)
- Criterios de aceptación
- Entorno de pruebas
- Ejecución de pruebas
- Reportes y métricas

**Total de Casos de Prueba:** 19+ casos documentados

**Uso Recomendado:**
- Ejecutar pruebas sistemáticas
- Validar funcionalidades
- Documentar nuevos casos de prueba

---

# **7. Otros Documentos**

Esta sección contiene documentación adicional sobre funcionalidades específicas y guías de despliegue.

## **7.1 Documentación Completa de API REST**

**Ubicación:** [`docs/API.md`](API.md)

**Descripción:** Documentación exhaustiva de la API REST con todos los endpoints, autenticación, ejemplos y mejores prácticas.

**Nota:** Este documento ya fue descrito en la sección 3.2. Se referencia aquí para completitud.

---

## **7.2 Documentación de Arquitectura del Sistema**

**Ubicación:** [`docs/ARCHITECTURE.md`](ARCHITECTURE.md)

**Descripción:** Documentación técnica detallada de la arquitectura del sistema utilizando el modelo de vistas 4+1.

**Nota:** Este documento ya fue descrito en la sección 3.4. Se referencia aquí para completitud.

---

## **7.3 Guía de Despliegue en Producción**

**Ubicación:** [`docs/DEPLOYMENT.md`](DEPLOYMENT.md)

**Descripción:** Guía completa para desplegar el sistema en ambientes de producción.

**Contenido:**
- Requisitos previos
- Despliegue del backend (Render.com, VPS)
- Despliegue de aplicación móvil (Android, iOS)
- Variables de entorno
- Verificación post-despliegue
- Consideraciones de seguridad
- Monitoreo y mantenimiento

**Uso Recomendado:**
- Desplegar sistema en producción
- Configurar ambientes de staging
- Troubleshooting de despliegue

---

## **7.4 Funcionalidad Offline y Sincronización**

**Ubicación:** [`lib/README_OFFLINE.md`](../lib/README_OFFLINE.md)

**Descripción:** Documentación completa del sistema offline y sincronización bidireccional.

**Contenido:**
- Arquitectura offline
- Servicios principales:
  - ConnectivityService
  - LocalDatabaseService
  - OfflineSyncService
  - HybridApiService
- Widgets de UI
- Funcionalidades offline
- Configuración
- Flujo de datos
- Consideraciones técnicas
- Monitoreo y debugging
- Limitaciones

**Uso Recomendado:**
- Implementar funcionalidades offline
- Entender sincronización
- Debugging de problemas offline
- Optimizar rendimiento offline

---

## **7.5 Gestión de Estado de Estudiantes**

**Ubicación:** [`lib/README_STUDENT_STATUS.md`](../lib/README_STUDENT_STATUS.md)

**Descripción:** Documentación del sistema de consulta y gestión del estado completo de estudiantes.

**Contenido:**
- Arquitectura del módulo
- Modelo de datos (StudentStatusModel)
- Servicios y ViewModels
- Vistas (StudentStatusView, StudentStatusDetailView)
- Funcionalidades implementadas:
  - Consulta básica
  - Búsqueda avanzada
  - Estado de presencia
  - Historial de asistencias
  - Estadísticas y análisis
  - Alertas y recomendaciones
- Integración en la aplicación
- Flujo de uso
- Características técnicas
- Consideraciones de seguridad

**Uso Recomendado:**
- Consultar estado de estudiantes
- Implementar nuevas funcionalidades de consulta
- Entender el sistema de alertas

---

# **8. Estructura del Proyecto**

## **8.1 Organización de Documentación**

```
docs/
├── FD01-EPIS-Informe de Factibilidad de Proyecto.md
├── FD02-EPIS-Informe Vision de Proyecto.md
├── FD03-Informe de SRS.md
├── FD04-Informe de SAD.md
├── FD05-EPIS-Informe ProyectoFinal.docx.md
├── FD06-Propuesta de Proyecto.md (este documento)
├── API.md
├── ARCHITECTURE.md
└── DEPLOYMENT.md

backend/
├── README.md
├── README_BACKUP_AUDIT_TESTS.md
├── env.example.txt
├── scripts/
│   ├── migrate.js
│   └── backup.js
├── ml/
│   ├── README_COMPLETO_ML.md
│   ├── README_ETL.md
│   ├── README_LINEAR_REGRESSION.md
│   ├── README_PEAK_HOURS_PREDICTION.md
│   └── README_MONITORING_DASHBOARD.md
└── tests/
    ├── README.md
    ├── RESUMEN_TESTS.md
    └── PLAN_PRUEBAS.md

lib/
├── README_OFFLINE.md
└── README_STUDENT_STATUS.md

.github/
└── workflows/
    └── ci.yml

CONTRIBUTING.md
README.md
```

## **8.2 Mapa de Documentación por Audiencia**

### **Para Desarrolladores Nuevos:**
1. `README.md` - Visión general del proyecto
2. `CONTRIBUTING.md` - Guía de contribución
3. `docs/ARCHITECTURE.md` - Arquitectura técnica
4. `docs/API.md` - Referencia de API

### **Para Administradores de Sistemas:**
1. `docs/DEPLOYMENT.md` - Guía de despliegue
2. `backend/env.example.txt` - Configuración
3. `backend/scripts/backup.js` - Scripts de backup
4. `backend/scripts/migrate.js` - Migraciones

### **Para Especialistas en ML:**
1. `backend/ml/README_COMPLETO_ML.md` - Documentación completa ML
2. `backend/ml/README_ETL.md` - Proceso ETL
3. `backend/ml/README_LINEAR_REGRESSION.md` - Regresión lineal
4. `backend/ml/README_PEAK_HOURS_PREDICTION.md` - Predicción horarios pico
5. `backend/ml/README_MONITORING_DASHBOARD.md` - Monitoreo ML

### **Para QA y Testing:**
1. `backend/tests/PLAN_PRUEBAS.md` - Plan de pruebas
2. `backend/tests/RESUMEN_TESTS.md` - Resumen de tests
3. `backend/tests/README.md` - Guía de testing
4. `backend/README_BACKUP_AUDIT_TESTS.md` - Tests de backup/auditoría

### **Para Stakeholders:**
1. `docs/FD01-EPIS-Informe de Factibilidad de Proyecto.md` - Factibilidad
2. `docs/FD02-EPIS-Informe Vision de Proyecto.md` - Visión
3. `docs/FD05-EPIS-Informe ProyectoFinal.docx.md` - Informe final

---

# **9. Guía de Uso de la Documentación**

## **9.1 Flujo de Lectura Recomendado**

### **Fase 1: Comprensión General (Día 1)**
1. Leer `README.md` completo
2. Revisar `docs/FD05-EPIS-Informe ProyectoFinal.docx.md` para contexto
3. Explorar estructura del proyecto

### **Fase 2: Configuración del Entorno (Día 2)**
1. Seguir `CONTRIBUTING.md` - Sección "Configuración del Entorno"
2. Configurar variables de entorno usando `backend/env.example.txt`
3. Ejecutar scripts de migración y verificar instalación

### **Fase 3: Comprensión Técnica (Día 3-5)**
1. Estudiar `docs/ARCHITECTURE.md` completo
2. Revisar `docs/API.md` para entender endpoints
3. Explorar código fuente siguiendo la arquitectura

### **Fase 4: Desarrollo (Ongoing)**
1. Consultar `docs/API.md` para desarrollo de integraciones
2. Usar `CONTRIBUTING.md` como referencia de estándares
3. Revisar documentación específica según necesidad

## **9.2 Búsqueda Rápida de Información**

### **¿Cómo instalar el proyecto?**
→ `README.md` - Sección "Instalación"

### **¿Cómo contribuir código?**
→ `CONTRIBUTING.md` - Sección completa

### **¿Cómo funciona la API?**
→ `docs/API.md` - Documentación completa

### **¿Cuál es la arquitectura del sistema?**
→ `docs/ARCHITECTURE.md` - Vista completa

### **¿Cómo desplegar en producción?**
→ `docs/DEPLOYMENT.md` - Guía paso a paso

### **¿Cómo funciona el módulo ML?**
→ `backend/ml/README_COMPLETO_ML.md` - Documentación ML

### **¿Cómo funciona el modo offline?**
→ `lib/README_OFFLINE.md` - Documentación offline

### **¿Cómo ejecutar tests?**
→ `backend/tests/README.md` - Guía de testing

### **¿Cómo configurar variables de entorno?**
→ `backend/env.example.txt` - Ejemplo completo

### **¿Cómo crear backups?**
→ `backend/scripts/backup.js` - Script de backup

---

## **9.3 Mantenimiento de la Documentación**

### **Cuándo Actualizar:**

- **Al agregar nuevas funcionalidades:** Actualizar `README.md` y `docs/API.md`
- **Al cambiar arquitectura:** Actualizar `docs/ARCHITECTURE.md`
- **Al agregar endpoints:** Actualizar `docs/API.md`
- **Al cambiar configuración:** Actualizar `backend/env.example.txt`
- **Al agregar tests:** Actualizar `backend/tests/RESUMEN_TESTS.md`
- **Al cambiar proceso de despliegue:** Actualizar `docs/DEPLOYMENT.md`

### **Responsabilidades:**

- **Desarrolladores:** Mantener documentación actualizada con código
- **Tech Lead:** Revisar documentación en code reviews
- **Documentación:** Actualizar en cada release mayor

---

# **10. Conclusiones**

El proyecto "Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas" cuenta con una documentación técnica completa y exhaustiva que cubre todos los aspectos del sistema:

## **10.1 Documentación Disponible**

✅ **Documentación Técnica Principal:**
- README.md con instrucciones completas
- Documentación completa de API REST (56+ endpoints)
- Guía de desarrollo para contribuidores
- Arquitectura técnica detallada

✅ **Documentos de Configuración:**
- Archivos de configuración de ambientes
- Scripts de despliegue y migración
- Configuración de CI/CD

✅ **Documentos de Machine Learning:**
- Documentación completa del módulo ML
- Proceso ETL documentado
- Algoritmos de regresión lineal
- Predicción de horarios pico
- Dashboard de monitoreo ML

✅ **Documentos de Testing:**
- Pruebas de respaldo y auditoría
- Resumen de pruebas realizadas (79+ tests)
- Plan de pruebas y casos de prueba

✅ **Otros Documentos:**
- Guía de despliegue en producción
- Funcionalidad offline y sincronización
- Gestión de estado de estudiantes

## **10.2 Calidad de la Documentación**

- **Completitud:** ✅ 100% - Todos los módulos documentados
- **Actualización:** ✅ Actualizada con el código actual
- **Claridad:** ✅ Ejemplos y guías paso a paso
- **Organización:** ✅ Estructura lógica y fácil navegación
- **Accesibilidad:** ✅ Múltiples puntos de entrada según audiencia

## **10.3 Beneficios de la Documentación**

1. **Onboarding Rápido:** Nuevos desarrolladores pueden comenzar rápidamente
2. **Mantenibilidad:** Código y arquitectura bien documentados facilitan mantenimiento
3. **Extensibilidad:** Documentación clara permite agregar funcionalidades fácilmente
4. **Colaboración:** Estándares claros facilitan trabajo en equipo
5. **Calidad:** Tests documentados aseguran calidad del código

## **10.4 Próximos Pasos**

1. **Mantener Actualizada:** Actualizar documentación con cada cambio significativo
2. **Mejorar Continuamente:** Agregar ejemplos y casos de uso adicionales
3. **Automatizar:** Generar documentación automática cuando sea posible
4. **Feedback:** Recopilar feedback de usuarios de la documentación
5. **Traducción:** Considerar traducción a otros idiomas si es necesario

---

# **Anexos**

## **Anexo A: Índice Completo de Documentos**

### **Documentos de Proyecto (FD01-FD06)**
- FD01: Informe de Factibilidad
- FD02: Documento de Visión
- FD03: Especificación de Requerimientos de Software (SRS)
- FD04: Arquitectura de Software (SAD)
- FD05: Informe Final del Proyecto
- FD06: Propuesta de Proyecto (este documento)

### **Documentación Técnica**
- README.md - Documento principal
- docs/API.md - API REST
- docs/ARCHITECTURE.md - Arquitectura técnica
- docs/DEPLOYMENT.md - Despliegue
- CONTRIBUTING.md - Guía de contribución

### **Configuración**
- backend/env.example.txt - Variables de entorno
- backend/scripts/migrate.js - Migraciones
- backend/scripts/backup.js - Backups
- .github/workflows/ci.yml - CI/CD

### **Machine Learning**
- backend/ml/README_COMPLETO_ML.md
- backend/ml/README_ETL.md
- backend/ml/README_LINEAR_REGRESSION.md
- backend/ml/README_PEAK_HOURS_PREDICTION.md
- backend/ml/README_MONITORING_DASHBOARD.md

### **Testing**
- backend/tests/README.md
- backend/tests/RESUMEN_TESTS.md
- backend/tests/PLAN_PRUEBAS.md
- backend/README_BACKUP_AUDIT_TESTS.md

### **Funcionalidades Específicas**
- lib/README_OFFLINE.md
- lib/README_STUDENT_STATUS.md
- lib/README_MATRICULATION_VERIFICATION.md

---

## **Anexo B: Enlaces Rápidos**

### **Documentación Principal**
- [README.md](../README.md)
- [API.md](API.md)
- [ARCHITECTURE.md](ARCHITECTURE.md)
- [DEPLOYMENT.md](DEPLOYMENT.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)

### **Configuración**
- [Variables de Entorno](../backend/env.example.txt)
- [Script de Migración](../backend/scripts/migrate.js)
- [Script de Backup](../backend/scripts/backup.js)
- [CI/CD Pipeline](../.github/workflows/ci.yml)

### **Machine Learning**
- [ML Completo](../backend/ml/README_COMPLETO_ML.md)
- [ETL](../backend/ml/README_ETL.md)
- [Regresión Lineal](../backend/ml/README_LINEAR_REGRESSION.md)
- [Predicción Horarios Pico](../backend/ml/README_PEAK_HOURS_PREDICTION.md)
- [Monitoreo ML](../backend/ml/README_MONITORING_DASHBOARD.md)

### **Testing**
- [Resumen Tests](../backend/tests/RESUMEN_TESTS.md)
- [Plan de Pruebas](../backend/tests/PLAN_PRUEBAS.md)
- [Backup y Auditoría](../backend/README_BACKUP_AUDIT_TESTS.md)

---

**Última Actualización:** Enero 2025  
**Versión:** 1.0.0  
**Estado:** ✅ Documentación Completa

[image1]: <data:image/png;base64,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>

