# 🧪 Tests Unitarios - Sistema de Control de Acceso

Este directorio contiene los tests unitarios y de integración para el backend del sistema.

## 📁 Estructura

```
tests/
├── setup.js                          # Configuración global de tests
├── unit/
│   ├── backup_service.test.js        # Tests del servicio de backup
│   ├── backup_service_advanced.test.js # Tests avanzados de backup
│   ├── audit_service.test.js         # Tests del servicio de auditoría
│   ├── audit_service_advanced.test.js # Tests avanzados de auditoría
│   ├── historical_data_service.test.js # Tests del servicio de datos históricos
│   ├── api_service.test.js           # Tests de validación de API
│   ├── data_validation.test.js      # Tests de validación de datos
│   ├── ml_services.test.js          # Tests de servicios ML
│   ├── utils.test.js                # Tests de funciones utilitarias
│   ├── student_sync_service.test.js  # Tests de sincronización de estudiantes ⭐ *NUEVO*
│   ├── student_sync_scheduler.test.js # Tests del scheduler de sincronización ⭐ *NUEVO*
│   ├── notification_service.test.js  # Tests del servicio de notificaciones ⭐ *NUEVO*
│   └── bus_schedule_tracking_service.test.js # Tests de tracking de buses ⭐ *NUEVO*
└── integration/
    └── api.test.js                   # Tests de integración de API
```

## 🚀 Ejecutar Tests

### Todos los tests
```bash
npm test
```

### Solo tests unitarios
```bash
npm run test:unit
```

### Solo tests de integración
```bash
npm run test:integration
```

### Modo watch (desarrollo)
```bash
npm run test:watch
```

### Con coverage
```bash
npm test -- --coverage
```

## 📊 Cobertura de Tests

Los tests cubren:

### ✅ Servicios Implementados
- **BackupService**: Backup automático, restauración, políticas de retención
- **AuditService**: Registro de auditoría, historial, estadísticas
- **HistoricalDataService**: Procesamiento de CSV, agregación de métricas
- **StudentSyncService**: Sincronización completa e incremental de estudiantes (US012) ⭐ *NUEVO*
- **StudentSyncScheduler**: Programación automática de sincronizaciones (US012) ⭐ *NUEVO*
- **NotificationService**: Notificaciones de cambio de estado (US007) ⭐ *NUEVO*
- **BusScheduleTrackingService**: Tracking de sugerencias implementadas (US054) ⭐ *NUEVO*

### ✅ Validaciones
- Estructura de datos
- Formatos de fecha y hora
- Validación de campos requeridos
- Validación de tipos de datos

### ✅ Funcionalidades ML
- Estructura de datos de entrenamiento
- Métricas de modelo
- Validación de predicciones

## 📝 Criterios de Aceptación Cubiertos

### US027 - Guardar fecha, hora, datos
- ✅ Tests de backup automático
- ✅ Tests de auditoría de cambios
- ✅ Tests de validación de datos

### US030 - Historial completo
- ✅ Tests de políticas de retención
- ✅ Tests de archivado histórico
- ✅ Tests de historial de auditoría

### Testing
- ✅ Tests unitarios para servicios críticos
- ✅ Tests de validación de datos
- ✅ Estructura de tests de integración

## 🔧 Configuración

### Jest Configuration (`jest.config.js`)
- **Environment**: Node.js
- **Timeout**: 10 segundos
- **Coverage Threshold**: 60% mínimo
- **Test Match**: `**/tests/**/*.test.js`

### Setup Global (`tests/setup.js`)
- Configuración de entorno de prueba
- Variables de entorno para tests
- Limpieza de mocks después de cada test

## 📈 Métricas de Cobertura

Ejecutar `npm test` genera un reporte de cobertura en:
- `coverage/lcov-report/index.html` (HTML)
- `coverage/coverage-summary.json` (JSON)

## ⚠️ Notas

1. **Tests de Integración**: Requieren configuración adicional:
   - Base de datos de prueba (MongoDB Memory Server recomendado)
   - Servidor Express de prueba
   - Setup y teardown de datos

2. **Mocks**: Los tests utilizan mocks para:
   - Modelos de Mongoose
   - Operaciones de sistema de archivos
   - Módulos externos (csv-parser, etc.)

3. **Limpieza**: Los tests limpian automáticamente archivos de prueba después de ejecutarse.

## 🎯 Próximos Pasos

1. Agregar tests de integración completos con MongoDB Memory Server
2. Agregar tests de rendimiento
3. Agregar tests de seguridad
4. Aumentar cobertura a >80%

---

*Documentación de tests - Enero 2025*

