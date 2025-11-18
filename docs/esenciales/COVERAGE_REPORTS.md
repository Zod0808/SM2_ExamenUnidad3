# 📊 Reportes de Cobertura de Código

**Sistema de Control de Acceso - MovilesII**  
**Fecha:** 18 de Noviembre 2025  
**US064:** Cobertura de código y reportes

---

## 📋 Resumen

Este documento describe cómo generar, visualizar y usar los reportes de cobertura de código para el proyecto.

---

## 🎯 Objetivos

- **Umbral mínimo de cobertura:** 70%
- **Umbral para servicios críticos:** 75%
- **Generación automática:** En CI/CD y localmente
- **Visualización:** Reportes HTML, Markdown y JSON

---

## 🔧 Backend (Node.js/Jest)

### Generar Reportes

#### Reporte Completo
```bash
cd backend
npm test
```

Esto genera:
- `coverage/index.html` - Reporte HTML interactivo
- `coverage/lcov.info` - Formato LCOV para herramientas externas
- `coverage/coverage-summary.json` - Resumen en JSON
- `coverage/coverage-report.md` - Reporte Markdown (generado por script)

#### Solo Verificar Umbral
```bash
npm run coverage:check
```

#### Generar Reporte Markdown
```bash
npm test
node scripts/generate-coverage-report.js
```

Esto crea `coverage/coverage-report.md` con:
- Resumen global de cobertura
- Tabla de cobertura por archivo
- Lista de archivos con baja cobertura
- Estadísticas detalladas

### Ver Reportes

#### Reporte HTML
```bash
# Abrir en navegador
npm run test:coverage:html

# O manualmente
open coverage/index.html  # macOS
xdg-open coverage/index.html  # Linux
start coverage/index.html  # Windows
```

#### Reporte Markdown
```bash
cat coverage/coverage-report.md
# O abrir en tu editor favorito
```

### Configuración

**Umbrales mínimos** (en `jest.config.js`):
- Global: 70% (branches, functions, lines, statements)
- Servicios críticos: 75%

**Archivos incluidos:**
- `services/**/*.js`
- `ml/**/*.js`
- `models/**/*.js`

**Archivos excluidos:**
- `node_modules/`
- `coverage/`
- `tests/`
- `scripts/`

---

## 📱 Frontend (Flutter)

### Generar Reportes

#### Reporte Completo
```bash
flutter test --coverage
```

Esto genera:
- `coverage/lcov.info` - Formato LCOV

#### Generar Reporte HTML (requiere lcov)
```bash
# Linux/macOS
./scripts/generate-flutter-coverage-report.sh

# Windows PowerShell
.\scripts\generate-flutter-coverage-report.ps1
```

O manualmente:
```bash
# Instalar lcov primero
# Ubuntu/Debian: sudo apt-get install lcov
# macOS: brew install lcov

genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Ver Reportes

#### Reporte HTML
```bash
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

#### Resumen en Consola
```bash
lcov --summary coverage/lcov.info
```

### Configuración

**Archivos incluidos:**
- `lib/**/*.dart` (por defecto)

**Archivos excluidos:**
- `test/`
- Archivos generados automáticamente

---

## 🚀 CI/CD

### Generación Automática

Los reportes se generan automáticamente en cada ejecución de CI/CD:

1. **Backend:**
   - Tests ejecutados con `npm test`
   - Reporte Markdown generado automáticamente
   - Verificación de umbral mínimo
   - Artefactos subidos a GitHub Actions

2. **Flutter:**
   - Tests ejecutados con `flutter test --coverage`
   - Resumen generado automáticamente
   - Artefactos subidos a GitHub Actions

### Acceso a Reportes en CI/CD

1. **GitHub Actions:**
   - Ir a `Actions` → Seleccionar workflow run
   - Descargar artefactos en la sección `Artifacts`
   - Ver resumen en `Step Summary`

2. **Codecov (opcional):**
   - Si está configurado, ver reportes en dashboard de Codecov
   - Badges de cobertura en README

---

## 📊 Interpretación de Reportes

### Métricas de Cobertura

1. **Statements (Declaraciones):**
   - Porcentaje de declaraciones ejecutadas
   - Incluye asignaciones, llamadas a funciones, etc.

2. **Branches (Ramas):**
   - Porcentaje de ramas de código ejecutadas
   - Incluye if/else, switch, operadores ternarios

3. **Functions (Funciones):**
   - Porcentaje de funciones llamadas al menos una vez

4. **Lines (Líneas):**
   - Porcentaje de líneas ejecutadas
   - Métrica más común y fácil de entender

### Colores y Estados

- ✅ **Verde:** Cobertura >= umbral mínimo (70%)
- ⚠️ **Amarillo:** Cobertura entre 60-70%
- ❌ **Rojo:** Cobertura < 60%

---

## 🎯 Mejora de Cobertura

### Identificar Archivos con Baja Cobertura

1. **Backend:**
   ```bash
   cat backend/coverage/coverage-report.md
   # Ver sección "Archivos con Baja Cobertura"
   ```

2. **Flutter:**
   ```bash
   lcov --summary coverage/lcov.info | grep -A 20 "lines"
   ```

### Estrategias para Mejorar

1. **Agregar Tests:**
   - Identificar funciones/ramas no cubiertas
   - Escribir tests para casos faltantes

2. **Revisar Código:**
   - Eliminar código muerto (no usado)
   - Simplificar lógica compleja

3. **Priorizar:**
   - Enfocarse en servicios críticos primero
   - Aumentar cobertura gradualmente

---

## 📈 Historial de Cobertura

### Seguimiento Manual

1. **Guardar reportes:**
   ```bash
   # Backend
   cp backend/coverage/coverage-summary.json backend/coverage/history/$(date +%Y%m%d).json
   
   # Flutter
   cp coverage/lcov.info coverage/history/$(date +%Y%m%d).info
   ```

2. **Comparar reportes:**
   - Usar herramientas de diff
   - Comparar JSON summaries

### Seguimiento Automático (Codecov)

Si Codecov está configurado:
- Historial automático en dashboard
- Gráficos de tendencia
- Comparación entre commits
- Alertas cuando cobertura baja

---

## ⚠️ Alertas y Umbrales

### Alertas Automáticas

**En CI/CD:**
- Pipeline falla si cobertura < 70% (configurable)
- Warning en Step Summary si está cerca del umbral

**Configuración:**
- Backend: `jest.config.js` → `coverageThreshold`
- CI/CD: Verificación en `.github/workflows/ci.yml`

### Umbrales Configurados

| Módulo | Umbral Global | Umbral Crítico |
|--------|---------------|----------------|
| Backend | 70% | 75% (services/) |
| Flutter | 70% | 70% |

---

## 🔗 Enlaces Útiles

### Herramientas

- **Jest Coverage:** https://jestjs.io/docs/configuration#coveragethreshold-object
- **Flutter Coverage:** https://flutter.dev/docs/testing/code-coverage
- **LCOV Format:** http://ltp.sourceforge.net/coverage/lcov.php
- **Codecov:** https://codecov.io/

### Documentación del Proyecto

- `docs/CI_CD_TESTING.md` - Guía de CI/CD
- `backend/tests/README.md` - Tests del backend
- `test/README_TESTING.md` - Tests de Flutter

---

## 📝 Notas Importantes

1. **Cobertura no es calidad:**
   - Alta cobertura no garantiza código sin bugs
   - Enfocarse en tests significativos

2. **Umbrales flexibles:**
   - Pueden ajustarse según necesidades
   - Servicios críticos pueden tener umbrales más altos

3. **Excluir código no testeable:**
   - Configuraciones
   - Archivos generados
   - Código legacy

4. **Mantener reportes actualizados:**
   - Ejecutar tests regularmente
   - Revisar reportes antes de merge

---

**Última actualización:** 18 de Noviembre 2025  
**Mantenido por:** Equipo de Desarrollo - MovilesII

