# Nuevas User Stories Propuestas
**Sistema de Control de Acceso - MovilesII**

**Fecha de creación:** 18 de Noviembre 2025  
**Última actualización:** 18 de Noviembre 2025  
**Fuente:** Issues abiertos en GitHub  
**Total de Issues Abiertos:** 12  
**User Stories Propuestas:** 8 nuevas (US061-US068)  
**User Stories Completadas:** 5 (US061, US062, US063, US064, US067) ✅

---

## 📊 Resumen Ejecutivo

Basado en el análisis de los [issues abiertos en GitHub](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues), se han identificado **7 nuevas User Stories** que complementan las 60 ya implementadas. Estas nuevas User Stories se enfocan principalmente en:

- **Testing y Calidad** (4 User Stories)
- **Optimización** (2 User Stories)
- **Auditoría y Trazabilidad** (1 User Story)

---

## 🎯 Nuevas User Stories Propuestas

### ✅ US061: Pruebas unitarias backend
**Prioridad:** Alta  
**Story Points:** 5  
**Estimación:** 16-24h (completado)  
**Issue:** [#156](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/156)  
**Estado:** ✅ **COMPLETADO**

**User Story:**
Como **Desarrollador** quiero **tener pruebas unitarias para el backend** para **asegurar la calidad y estabilidad del código**.

**Acceptance Criteria:**
- ✅ Cobertura mínima del 70% en servicios críticos (completado)
- ✅ Tests ejecutan correctamente en local y CI (completado)
- ✅ Detección de errores en lógica de negocio (completado)
- ✅ Documentación de cómo ejecutar y agregar tests (completado)

**Tasks Completadas:**
- ✅ Identificar servicios críticos del backend
- ✅ Escribir pruebas unitarias con Jest (60+ tests nuevos)
- ✅ Configurar scripts de test y coverage
- ✅ Actualizar umbral de cobertura a 70%
- ✅ Documentar proceso en README_TESTING.md

**Archivos Creados:**
- `backend/tests/unit/student_sync_service.test.js` (20+ tests)
- `backend/tests/unit/student_sync_scheduler.test.js` (15+ tests)
- `backend/tests/unit/notification_service.test.js` (10+ tests)
- `backend/tests/unit/bus_schedule_tracking_service.test.js` (15+ tests)

**Documentación:** Ver `docs/RESUMEN_US061_COMPLETADO.md` para detalles.

**Dependencias:** 
- Acceso a código fuente del backend
- Framework de testing configurado (Jest)

**Categoría:** Testing/Backend

---

### ✅ US062: Pruebas unitarias frontend mobile
**Prioridad:** Alta  
**Story Points:** 3  
**Estimación:** 8-12h (completado)  
**Issue:** [#157](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/157)  
**Estado:** ✅ **COMPLETADO**

**User Story:**
Como **Desarrollador** quiero **tener pruebas unitarias para la app móvil** para **asegurar que los widgets y lógica de negocio funcionen correctamente**.

**Acceptance Criteria:**
- ✅ Cobertura mínima del 70% en widgets y viewmodels (completado)
- ✅ Tests ejecutan correctamente en local y CI (completado)
- ✅ Detección de errores en flujos de UI críticos (completado)
- ✅ Documentación de cómo ejecutar y agregar tests (completado)

**Tasks Completadas:**
- ✅ Identificar widgets y viewmodels críticos
- ✅ Escribir pruebas unitarias con Flutter/Dart (40+ tests)
- ✅ Configurar scripts de test y coverage
- ✅ Documentar proceso en README_TESTING.md

**Archivos Creados:**
- `test/viewmodels/auth_viewmodel_test.dart` (10+ tests)
- `test/viewmodels/admin_viewmodel_test.dart` (8+ tests)
- `test/viewmodels/nfc_viewmodel_test.dart` (10+ tests)
- `test/viewmodels/reports_viewmodel_test.dart` (8+ tests)
- `test/widgets/session_warning_widget_test.dart` (2+ tests)
- `test/widgets/connectivity_status_widget_test.dart` (2+ tests)
- `test/README_TESTING.md` (documentación)

**Documentación:** Ver `docs/RESUMEN_US062_COMPLETADO.md` para detalles.

**Dependencias:**
- Emuladores/dispositivos configurados
- Acceso a código fuente Flutter

**Categoría:** Testing/Frontend

---

### ✅ US063: Integración de tests en CI/CD
**Prioridad:** Media  
**Story Points:** 3  
**Estimación:** 8-12h (completado)  
**Issue:** [#159](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/159)  
**Estado:** ✅ **COMPLETADO**

**User Story:**
Como **Equipo de Desarrollo** quiero **automatizar la ejecución de pruebas en CI/CD** para **asegurar calidad continua antes de cada merge**.

**Acceptance Criteria:**
- ✅ Tests corren automáticamente en cada push y PR (completado)
- ✅ Falla el pipeline si algún test falla (completado)
- ✅ Reportes de resultados accesibles para el equipo (completado)
- ✅ Documentación de la integración y troubleshooting (completado)

**Tasks Completadas:**
- ✅ Añadir jobs de test a workflows de GitHub Actions
- ✅ Configurar matrices para diferentes entornos (Node 18/20, Flutter stable/beta)
- ✅ Validar ejecución automática en PRs y merges
- ✅ Publicar resultados y logs (artefactos, Codecov, Step Summary)
- ✅ Documentar integración y solución de problemas

**Archivos Creados/Modificados:**
- `.github/workflows/ci.yml` (mejorado con matrices y reportes)
- `.github/workflows/test-only.yml` (nuevo workflow optimizado)
- `docs/CI_CD_TESTING.md` (documentación completa)

**Documentación:** Ver `docs/RESUMEN_US063_COMPLETADO.md` para detalles.

**Dependencias:**
- Acceso a workflows de CI/CD
- Permisos de CI/CD configurados

**Categoría:** Testing/CI/CD

---

### ✅ US064: Cobertura de código y reportes
**Prioridad:** Media  
**Story Points:** 3  
**Estimación:** 8-12h (completado)  
**Issue:** [#158](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/158)  
**Estado:** ✅ **COMPLETADO**

**User Story:**
Como **Equipo de Desarrollo** quiero **generar reportes automáticos de cobertura de código** para **visualizar y mejorar la calidad del código continuamente**.

**Acceptance Criteria:**
- ✅ Reportes de cobertura generados automáticamente (completado)
- ✅ Cobertura visible en dashboard o reportes (completado)
- ✅ Alertas cuando cobertura baja del umbral mínimo (completado)
- ✅ Historial de cobertura a lo largo del tiempo (completado)

**Tasks Completadas:**
- ✅ Configurar herramientas de coverage (Jest, lcov)
- ✅ Integrar en pipeline CI/CD
- ✅ Configurar umbrales mínimos de cobertura (70% global, 75% crítico)
- ✅ Publicar reportes en dashboard o artefactos (HTML, Markdown, JSON, LCOV)
- ✅ Documentar proceso y métricas

**Archivos Creados/Modificados:**
- `backend/jest.config.js` (mejorado con múltiples formatos)
- `backend/scripts/generate-coverage-report.js` (generador de reporte Markdown)
- `scripts/generate-flutter-coverage-report.sh` (script Flutter Linux/macOS)
- `scripts/generate-flutter-coverage-report.ps1` (script Flutter Windows)
- `.github/workflows/ci.yml` (integración de reportes y alertas)
- `docs/COVERAGE_REPORTS.md` (documentación completa)

**Documentación:** Ver `docs/RESUMEN_US064_COMPLETADO.md` para detalles.

**Dependencias:**
- Pipeline CI/CD configurado
- Herramientas de coverage instaladas

**Categoría:** Testing/Análisis

---

### 🟢 US065: Optimizar tamaño APK
**Prioridad:** Baja  
**Story Points:** 5  
**Estimación:** 16-24h  
**Issue:** [#109](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/109)

**User Story:**
Como **Usuario** quiero **que la aplicación móvil tenga un tamaño optimizado** para **facilitar la descarga e instalación**.

**Acceptance Criteria:**
- ✅ Tamaño del APK reducido al menos 30%
- ✅ Funcionalidad completa mantenida
- ✅ Tiempo de carga optimizado
- ✅ Análisis de dependencias y recursos

**Tasks:**
- [ ] Analizar tamaño actual del APK
- [ ] Identificar dependencias innecesarias
- [ ] Optimizar recursos (imágenes, assets)
- [ ] Implementar code splitting si es necesario
- [ ] Validar funcionalidad después de optimización

**Dependencias:**
- Acceso a build de producción
- Herramientas de análisis de tamaño

**Categoría:** Optimización/Mobile

---

### 🟢 US066: Optimización y automatización de workflows
**Prioridad:** Baja  
**Story Points:** 5  
**Estimación:** 16-24h  
**Issue:** [#149](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/149)

**User Story:**
Como **Equipo de Desarrollo** quiero **optimizar y automatizar los workflows de desarrollo** para **mejorar la eficiencia y reducir errores manuales**.

**Acceptance Criteria:**
- ✅ Workflows automatizados para tareas comunes
- ✅ Reducción de tiempo en tareas repetitivas
- ✅ Documentación de workflows optimizados
- ✅ Integración con herramientas de desarrollo

**Tasks:**
- [ ] Identificar workflows manuales repetitivos
- [ ] Automatizar procesos de build y deploy
- [ ] Configurar scripts de desarrollo
- [ ] Documentar workflows optimizados
- [ ] Validar eficiencia mejorada

**Dependencias:**
- Acceso a herramientas de automatización
- Permisos de CI/CD

**Categoría:** Optimización/DevOps

---

### ✅ US067: Auditoría y trazabilidad avanzada
**Prioridad:** Media  
**Story Points:** 8  
**Estimación:** 32-40h (completado)  
**Issue:** [#142](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/142)  
**Estado:** ✅ **COMPLETADO**

**User Story:**
Como **Administrador** quiero **tener un sistema avanzado de auditoría y trazabilidad** para **cumplir con requisitos de seguridad y compliance**.

**Acceptance Criteria:**
- ✅ Logs detallados de todas las operaciones críticas (completado)
- ✅ Trazabilidad completa de cambios en datos (completado)
- ✅ Reportes de auditoría exportables (completado)
- ✅ Búsqueda y filtrado avanzado de logs (completado)

**Tasks Completadas:**
- ✅ Expandir sistema de auditoría existente (AdvancedAuditService)
- ✅ Implementar logs estructurados (ya existente, mejorado)
- ✅ Crear dashboard de auditoría (estadísticas avanzadas)
- ✅ Implementar exportación de reportes (JSON, CSV, PDF)
- ✅ Documentar sistema de auditoría

**Archivos Creados/Modificados:**
- `backend/services/advanced_audit_service.js` (servicio avanzado)
- `backend/index.js` (6 nuevos endpoints)
- `docs/AUDITORIA_AVANZADA.md` (documentación completa)

**Endpoints Implementados:**
- `GET /api/audit/search` - Búsqueda avanzada
- `GET /api/audit/dashboard` - Dashboard de auditoría
- `GET /api/audit/suspicious` - Detección de actividad sospechosa
- `GET /api/audit/traceability/:entityType/:entityId` - Trazabilidad completa
- `GET /api/audit/export` - Exportación de reportes
- `PUT /api/audit/alert-thresholds` - Configurar umbrales

**Documentación:** Ver `docs/RESUMEN_US067_COMPLETADO.md` para detalles.

**Dependencias:**
- Sistema de auditoría base (ya implementado)
- Acceso a logs y base de datos

**Categoría:** Seguridad/Auditoría

---

### 🟢 US068: Beta testing con usuarios reales
**Prioridad:** Baja  
**Story Points:** 5  
**Estimación:** 20-32h  
**Issue:** [#113](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/113)

**User Story:**
Como **Equipo de Desarrollo** quiero **realizar beta testing con usuarios reales** para **validar la usabilidad y detectar problemas antes del lanzamiento**.

**Acceptance Criteria:**
- ✅ Programa de beta testing establecido
- ✅ Feedback de usuarios recopilado sistemáticamente
- ✅ Issues identificados priorizados y resueltos
- ✅ Reporte de resultados del beta testing

**Tasks:**
- [ ] Seleccionar grupo de beta testers
- [ ] Configurar sistema de recopilación de feedback
- [ ] Crear guías de testing para usuarios
- [ ] Analizar feedback y priorizar issues
- [ ] Generar reporte de resultados

**Dependencias:**
- Aplicación estable para testing
- Acceso a usuarios beta

**Categoría:** Testing/QA

---

## 📊 Resumen por Categoría

| Categoría | User Stories | Prioridad Alta | Prioridad Media | Prioridad Baja |
|-----------|--------------|----------------|-----------------|----------------|
| **Testing** | 4 (US061-US064) | 2 | 2 | 0 |
| **Optimización** | 2 (US065-US066) | 0 | 0 | 2 |
| **Auditoría** | 1 (US067) | 0 | 1 | 0 |
| **QA** | 1 (US068) | 0 | 0 | 1 |
| **Total** | **8** | **2** | **3** | **3** |

---

## 🎯 Priorización Recomendada

### 🔴 Prioridad ALTA (Completar en 2-4 semanas)
1. **US061:** Pruebas unitarias backend (16-24h) ✅ *COMPLETADO*
2. **US062:** Pruebas unitarias frontend mobile (8-12h) ✅ *COMPLETADO*

**Total estimado:** 0 horas restantes (todas las tareas de alta prioridad completadas)

### 🟡 Prioridad MEDIA (Completar en 1-2 meses)
3. **US063:** Integración de tests en CI/CD (8-12h) ✅ *COMPLETADO*
4. **US064:** Cobertura de código y reportes (8-12h) ✅ *COMPLETADO*
5. **US067:** Auditoría y trazabilidad avanzada (32-40h) ✅ *COMPLETADO*

**Total estimado:** 0 horas restantes (todas las tareas de prioridad media completadas)

### 🟢 Prioridad BAJA (Completar en 2-3 meses)
6. **US065:** Optimizar tamaño APK (16-24h)
7. **US066:** Optimización workflows (16-24h)
8. **US068:** Beta testing con usuarios reales (20-32h)

**Total estimado:** 52-80 horas

---

## 📝 Notas Importantes

### Issues que Parecen Ya Implementados
Los siguientes issues están marcados como abiertos pero las funcionalidades parecen estar implementadas según la documentación:

- **#62 [US060]:** Actualizaciones tiempo real - ✅ **YA COMPLETADO** (marcado como 100% en informe)
- **#36 [US026]:** Registrar accesos - ✅ **YA COMPLETADO** (marcado como 100% en informe)
- **#35 [US025]:** Registrar decisión timestamp - ✅ **YA COMPLETADO** (marcado como 100% en informe)
- **#29 [US021]:** Validar ID pulsera - ✅ **YA COMPLETADO** (marcado como 100% en informe)

**Recomendación:** Verificar estos issues y cerrarlos si las funcionalidades están realmente implementadas.

---

## 🚀 Plan de Implementación Sugerido

### Fase 1: Testing (Semanas 1-4)
- Semana 1-2: US061 (Pruebas unitarias backend)
- Semana 3: US062 (Pruebas unitarias frontend)
- Semana 4: US063 (Integración CI/CD)

### Fase 2: Calidad y Auditoría (Semanas 5-8)
- Semana 5: US064 (Cobertura de código)
- Semana 6-7: US067 (Auditoría avanzada)

### Fase 3: Optimización (Semanas 9-12)
- Semana 9-10: US065 (Optimizar APK)
- Semana 11: US066 (Optimización workflows)
- Semana 12: US068 (Beta testing)

---

## 📈 Impacto Esperado

### Beneficios Técnicos
- ✅ Mayor confiabilidad del código (testing)
- ✅ Mejor calidad de código (cobertura)
- ✅ Procesos más eficientes (automatización)
- ✅ Mejor cumplimiento (auditoría)

### Beneficios de Negocio
- ✅ Menor tiempo de desarrollo (automatización)
- ✅ Menor costo de mantenimiento (testing)
- ✅ Mejor experiencia de usuario (optimización)
- ✅ Mayor confianza en el sistema (auditoría)

---

## 🔄 Próximos Pasos

1. **Revisar y validar** las User Stories propuestas con el equipo
2. **Priorizar** según necesidades del proyecto
3. **Asignar responsables** para cada User Story
4. **Establecer timeline** de implementación
5. **Verificar y cerrar** issues que ya están implementados

---

**Última actualización:** 18 de Noviembre 2025  
**Fuente:** [Issues Abiertos en GitHub](https://github.com/Sistema-de-control-de-acceso/MovilesII/issues)  
**Total de User Stories del Proyecto:** 60 (completadas) + 8 (propuestas) = **68 User Stories**

