# 🚀 CI/CD Testing - Guía de Integración

**Sistema de Control de Acceso - MovilesII**  
**Fecha:** 18 de Noviembre 2025  
**US063:** Integración de tests en CI/CD

---

## 📋 Resumen

Este documento describe la configuración de CI/CD para ejecutar tests automáticamente en cada push y pull request, asegurando calidad continua en el proyecto.

---

## 🔄 Workflows Configurados

### 1. CI Pipeline Principal (`.github/workflows/ci.yml`)

**Propósito:** Pipeline completo que ejecuta tests, análisis de código, formato y build.

**Triggers:**
- Push a `main` o `develop`
- Pull requests a `main` o `develop`
- Ejecución manual (`workflow_dispatch`)

**Jobs Incluidos:**
1. **Backend Tests** - Tests unitarios e integración del backend
2. **Flutter Tests** - Tests unitarios y de widgets de Flutter
3. **Code Format Check** - Verificación de formato de código
4. **Build Check** - Verificación de compilación

**Características:**
- ✅ Ejecuta tests en múltiples versiones de Node.js (18, 20)
- ✅ Ejecuta tests en diferentes canales de Flutter (stable, beta)
- ✅ Falla el pipeline si algún test falla
- ✅ Sube reportes de cobertura a Codecov
- ✅ Guarda artefactos de resultados de tests
- ✅ Publica resumen de tests en GitHub Actions

### 2. Tests Only (`.github/workflows/test-only.yml`)

**Propósito:** Workflow optimizado solo para ejecutar tests (más rápido para desarrollo).

**Triggers:**
- Push/PR cuando cambian archivos en `backend/`, `lib/`, `test/`
- Ejecución manual

**Jobs:**
1. **Backend Tests** - Solo tests (sin lint, sin build)
2. **Flutter Tests** - Solo tests (sin analyze, sin build)

**Ventajas:**
- ⚡ Más rápido (solo ejecuta tests)
- 💰 Menor consumo de recursos
- 🎯 Ideal para desarrollo iterativo

---

## ✅ Acceptance Criteria Cumplidos

### ✅ Tests corren automáticamente en cada push y PR

**Implementación:**
- Workflows configurados con triggers `on: push` y `on: pull_request`
- Ejecución automática en ramas `main` y `develop`
- Ejecución manual disponible con `workflow_dispatch`

**Verificación:**
```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
```

### ✅ Falla el pipeline si algún test falla

**Implementación:**
- `continue-on-error: false` en jobs de tests
- `fail-fast: false` en matrices para continuar con otras versiones
- Exit codes de Jest y Flutter test propagados correctamente

**Verificación:**
```yaml
- name: Run tests
  run: npm test
  continue-on-error: false  # Falla el pipeline si los tests fallan
```

### ✅ Reportes de resultados accesibles para el equipo

**Implementación:**
1. **Artefactos de GitHub Actions:**
   - Resultados de tests guardados como artefactos
   - Disponibles por 7 días
   - Descargables desde la interfaz de GitHub

2. **Codecov:**
   - Reportes de cobertura subidos automáticamente
   - Disponibles en dashboard de Codecov
   - Badges de cobertura en README

3. **GitHub Step Summary:**
   - Resumen de tests publicado en cada run
   - Visible en la interfaz de GitHub Actions

**Acceso a Reportes:**
- **Artefactos:** `Actions` → Seleccionar workflow run → `Artifacts`
- **Codecov:** Dashboard de Codecov (si está configurado)
- **Logs:** `Actions` → Seleccionar workflow run → Ver logs de cada job

### ✅ Documentación de la integración y troubleshooting

**Documentación Creada:**
- ✅ Este documento (`docs/CI_CD_TESTING.md`)
- ✅ Sección de troubleshooting incluida
- ✅ Guía de configuración local

---

## 🔧 Configuración Local

### Ejecutar Tests Localmente (Igual que en CI)

#### Backend:
```bash
cd backend
npm ci
npm test
```

#### Flutter:
```bash
flutter pub get
flutter test --coverage
```

### Variables de Entorno Necesarias

**Backend:**
```bash
MONGODB_URI=mongodb://localhost:27017/ASISTENCIA_TEST
NODE_ENV=test
```

**Flutter:**
No requiere variables de entorno adicionales para tests básicos.

---

## 🐛 Troubleshooting

### Problema: Tests fallan en CI pero pasan localmente

**Posibles Causas:**
1. **Versión de Node.js/Flutter diferente**
   - **Solución:** Verificar versión local vs CI
   - **CI usa:** Node 18/20, Flutter 3.7.2

2. **Variables de entorno faltantes**
   - **Solución:** Verificar que todas las variables estén en `.github/workflows/ci.yml`

3. **Dependencias no instaladas**
   - **Solución:** Verificar que `npm ci` y `flutter pub get` se ejecuten correctamente

4. **MongoDB no disponible**
   - **Solución:** Verificar que el servicio MongoDB esté configurado en el workflow

**Debug:**
```bash
# Ver logs completos en GitHub Actions
# Revisar sección "Run tests" en el job que falla
```

### Problema: Coverage no se sube a Codecov

**Posibles Causas:**
1. **Token de Codecov no configurado**
   - **Solución:** Agregar `CODECOV_TOKEN` en secrets de GitHub

2. **Rutas de coverage incorrectas**
   - **Solución:** Verificar que `directory` en `codecov-action` sea correcto

3. **Codecov service no disponible**
   - **Solución:** `fail_ci_if_error: false` previene que CI falle, pero verificar logs

**Debug:**
```bash
# Verificar que coverage se genera localmente
cd backend && npm test
ls coverage/  # Debe existir

# Ver logs de "Upload coverage to Codecov" en GitHub Actions
```

### Problema: Tests son lentos en CI

**Optimizaciones:**
1. **Usar `test-only.yml` para desarrollo**
   - Solo ejecuta tests, sin lint ni build

2. **Cache de dependencias**
   - Ya configurado con `cache: 'npm'` y Flutter cache automático

3. **Paralelización**
   - Jobs de backend y Flutter corren en paralelo

4. **Matrices con fail-fast: false**
   - Permite continuar con otras versiones si una falla

### Problema: Tests de integración fallan

**Solución:**
- Verificar que MongoDB service esté configurado correctamente
- Verificar que `MONGODB_URI` apunte al servicio correcto
- Revisar timeouts en tests de integración

---

## 📊 Métricas y Monitoreo

### Cobertura de Tests

**Backend:**
- Objetivo: 70%+
- Actual: Verificar en Codecov o `backend/coverage/`

**Flutter:**
- Objetivo: 70%+
- Actual: Verificar en Codecov o `coverage/`

### Tiempos de Ejecución

**Estimados:**
- Backend tests: ~2-5 minutos
- Flutter tests: ~3-7 minutos
- Pipeline completo: ~10-15 minutos

**Optimización:**
- Usar `test-only.yml` para desarrollo: ~5-8 minutos

---

## 🔄 Flujo de Trabajo Recomendado

### Desarrollo Normal:
1. Hacer cambios en código
2. Ejecutar tests localmente: `npm test` o `flutter test`
3. Hacer commit y push
4. CI ejecuta automáticamente
5. Revisar resultados en GitHub Actions

### Desarrollo Rápido (Solo Tests):
1. Hacer cambios en código
2. Hacer commit y push
3. `test-only.yml` se ejecuta automáticamente (más rápido)
4. Revisar resultados

### Antes de Merge:
1. Asegurar que todos los tests pasen localmente
2. Verificar que CI pase completamente
3. Revisar cobertura de tests
4. Hacer merge

---

## 📝 Notas Importantes

1. **Secrets de GitHub:**
   - `CODECOV_TOKEN` (opcional): Para subir coverage a Codecov
   - Configurar en: `Settings` → `Secrets and variables` → `Actions`

2. **Permisos:**
   - Workflows necesitan permisos de lectura/escritura
   - Configurado automáticamente en GitHub Actions

3. **Límites:**
   - GitHub Actions tiene límites de minutos gratuitos
   - Usar `test-only.yml` para ahorrar recursos

4. **Notificaciones:**
   - GitHub envía notificaciones cuando workflows fallan
   - Configurar en `Settings` → `Notifications`

---

## 🎯 Próximos Pasos

1. **Configurar Codecov:**
   - Agregar token en secrets
   - Configurar badges en README

2. **Agregar más matrices:**
   - Probar en diferentes sistemas operativos (Windows, macOS)
   - Agregar más versiones de Node.js/Flutter

3. **Notificaciones avanzadas:**
   - Slack/Discord notifications cuando tests fallan
   - Email notifications para el equipo

4. **Tests de rendimiento:**
   - Agregar benchmarks de rendimiento
   - Alertas si tests son más lentos

---

**Última actualización:** 18 de Noviembre 2025  
**Mantenido por:** Equipo de Desarrollo - MovilesII

