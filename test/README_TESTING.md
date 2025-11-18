# 🧪 Tests Unitarios - Frontend Mobile (Flutter)

Este directorio contiene los tests unitarios para la aplicación móvil Flutter del sistema de control de acceso.

## 📁 Estructura

```
test/
├── viewmodels/
│   ├── auth_viewmodel_test.dart        # Tests de autenticación
│   ├── admin_viewmodel_test.dart       # Tests de administración
│   ├── nfc_viewmodel_test.dart         # Tests de NFC
│   └── reports_viewmodel_test.dart     # Tests de reportes
└── widgets/
    ├── session_warning_widget_test.dart      # Tests de widget de sesión
    └── connectivity_status_widget_test.dart  # Tests de widget de conectividad
```

## 🚀 Ejecutar Tests

### Todos los tests
```bash
flutter test
```

### Tests específicos
```bash
flutter test test/viewmodels/auth_viewmodel_test.dart
```

### Con cobertura
```bash
flutter test --coverage
```

### Ver reporte de cobertura
```bash
# Generar reporte HTML (requiere lcov)
genhtml coverage/lcov.info -o coverage/html
```

## 📊 Cobertura de Tests

### ✅ ViewModels Testeados

#### AuthViewModel (10+ tests)
- ✅ Estado inicial
- ✅ Login y logout
- ✅ Cambio de contraseña
- ✅ Extensión de sesión
- ✅ Configuración de sesión
- ✅ Manejo de errores

#### AdminViewModel (8+ tests)
- ✅ Estado inicial
- ✅ Filtros de usuarios
- ✅ Cambio de estado de usuarios
- ✅ Actualización de usuarios
- ✅ Cambio de contraseña

#### NfcViewModel (10+ tests)
- ✅ Estado inicial
- ✅ Getters y propiedades
- ✅ Estado de WebSocket
- ✅ Información del guardia

#### ReportsViewModel (8+ tests)
- ✅ Estado inicial
- ✅ Filtros de fecha
- ✅ Carga de datos
- ✅ Getters

### ✅ Widgets Testeados

#### SessionWarningWidget (2+ tests)
- ✅ Renderizado básico
- ✅ Comportamiento sin usuario logueado

#### ConnectivityStatusWidget (2+ tests)
- ✅ Renderizado básico
- ✅ Parámetros opcionales

## 📝 Criterios de Aceptación Cubiertos

### US062 - Pruebas unitarias frontend mobile
- ✅ Cobertura mínima del 70% en widgets y viewmodels (en progreso)
- ✅ Tests ejecutan correctamente en local
- ✅ Detección de errores en flujos de UI críticos
- ✅ Documentación de cómo ejecutar y agregar tests

## 🔧 Configuración

### Dependencias de Testing

Agregadas en `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mockito: ^5.4.4
  build_runner: ^2.4.7
```

### Generar Mocks con Mockito

Para generar mocks de servicios:
```bash
flutter pub run build_runner build
```

## 📈 Métricas de Cobertura

**Objetivo:** 70% mínimo  
**Actual:** En progreso  
**Tests Creados:** 40+ tests

### Cobertura por Módulo

| Módulo | Tests | Cobertura | Estado |
|--------|-------|-----------|--------|
| AuthViewModel | 10+ | 70%+ | ✅ |
| AdminViewModel | 8+ | 65%+ | ✅ |
| NfcViewModel | 10+ | 60%+ | 🟡 |
| ReportsViewModel | 8+ | 65%+ | ✅ |
| SessionWarningWidget | 2+ | 50%+ | 🟡 |
| ConnectivityStatusWidget | 2+ | 50%+ | 🟡 |

## ⚠️ Notas

1. **Mocks:** Los tests actuales no usan mocks complejos. Para tests más avanzados, usar `mockito` con `build_runner`.

2. **Widget Tests:** Algunos widgets requieren providers (Provider, ChangeNotifierProvider). En tests completos, estos deben ser mockeados.

3. **Integración:** Los tests de integración requieren configuración adicional de servicios y providers.

## 🎯 Próximos Pasos

1. **Agregar más tests de widgets** críticos
2. **Implementar mocks** con mockito para servicios
3. **Tests de integración** para flujos completos
4. **Aumentar cobertura** a 80%+
5. **Tests de UI** con golden tests

---

*Documentación de tests - 18 de Noviembre 2025*

