# Issues Completos del Proyecto

**Fecha de revisión:** 18 de November 2025  
**Total de Issues:** 84  
**Issues Abiertos:** 12  
**Issues Cerrados:** 72

---

## Índice

- [Issues Abiertos](#issues-abiertos)
- [Issues Cerrados](#issues-cerrados)
- [Estadísticas Generales](#estadísticas-generales)

---

# Issues Abiertos

## 1. [#159] [US076] Integración de tests en CI/CD
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/159
- **Etiquetas:** documentation, enhancement, sprint-5, integration, medium
- **Prioridad:** ** Media
- **Story Points:** ** 3
- **Estimación:** ** 8-12h
- **Creado:** 2025-11-11
- **Dependencias:** ** Acceso a workflows; permisos de CI/CD

### User Story
---
Automatizar la ejecución de pruebas unitarias y de integración en el pipeline CI/CD para asegurar calidad continua antes de cada merge.

### Acceptance Criteria
- [ ] Tests corren automáticamente en cada push y PR.
- [ ] Falla el pipeline si algún test falla.
- [ ] Reportes de resultados accesibles para el equipo.
- [ ] Documentación de la integración y troubleshooting.

### Tasks
- [ ] Añadir jobs de test a workflows de GitHub Actions.
- [ ] Configurar matrices para diferentes entornos (Node, Flutter).
- [ ] Validar ejecución automática en PRs y merges.
- [ ] Publicar resultados y logs.
- [ ] Documentar integración y solución de problemas.

---

## 2. [#158] [US075] Cobertura de código y reportes
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/158
- **Etiquetas:** documentation, sprint-5, reporting, analytics, medium
- **Prioridad:** ** Media
- **Story Points:** ** 3
- **Estimación:** ** 8-12h
- **Creado:** 2025-11-11
- **Dependencias:** ** Pipeline CI/CD; herramientas de coverage instaladas

### User Story
---
Configurar y mantener la generación automática de reportes de cobertura de código para backend y frontend, facilitando la visualización y mejora continua.

### Acceptance Criteria
- [ ] Reportes de cobertura generados automáticamente en cada push.
- [ ] Acceso fácil a reportes históricos desde CI/CD.
- [ ] Alertas si la cobertura baja del umbral definido.
- [ ] Documentación de acceso y uso de reportes.

### Tasks
- [ ] Configurar herramientas de coverage (Jest, lcov, cobertura Dart).
- [ ] Integrar generación de reportes en pipeline CI/CD.
- [ ] Publicar reportes en dashboard o como artefactos.
- [ ] Configurar alertas de umbral.
- [ ] Documentar acceso y mantenimiento.

---

## 3. [#157] [US074] Pruebas unitarias frontend mobile
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/157
- **Etiquetas:** documentation, enhancement, sprint-5, integration, high
- **Prioridad:** ** Alta
- **Story Points:** ** 3
- **Estimación:** ** 8-12h
- **Creado:** 2025-11-11
- **Dependencias:** ** Emuladores/dispositivos configurados; acceso a código fuente

### User Story
---
Desarrollar pruebas unitarias para la app móvil, asegurando que los widgets y lógica de negocio funcionen correctamente en diferentes escenarios.

### Acceptance Criteria
- [ ] Cobertura mínima del 70% en widgets y viewmodels.
- [ ] Tests ejecutan correctamente en local y CI.
- [ ] Detección de errores en flujos de UI críticos.
- [ ] Documentación de cómo ejecutar y agregar tests.

### Tasks
- [ ] Identificar widgets y viewmodels críticos.
- [ ] Escribir pruebas unitarias con Flutter/Dart.
- [ ] Configurar scripts de test y coverage.
- [ ] Ejecutar y validar resultados en CI.
- [ ] Documentar proceso en README_TESTING.md.

---

## 4. [#156] [US073] Pruebas unitarias backend
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/156
- **Etiquetas:** documentation, sprint-5, integration, high, backend
- **Prioridad:** ** Alta
- **Story Points:** ** 3
- **Estimación:** ** 8-12h (coordinación inicial; ejecución puede extenderse)
- **Creado:** 2025-11-11
- **Dependencias:** ** Acceso a base de datos de pruebas; scripts de seed

### User Story
---
Implementar y mantener pruebas unitarias en el backend para asegurar la calidad y robustez de los servicios y controladores.

### Acceptance Criteria
- [ ] Cobertura mínima del 80% en módulos críticos.
- [ ] Tests ejecutan correctamente en local y CI.
- [ ] Detección temprana de regresiones en endpoints principales.
- [ ] Documentación de cómo ejecutar y agregar tests.

### Tasks
- [ ] Identificar módulos y endpoints críticos a testear.
- [ ] Escribir pruebas unitarias con Jest/Supertest.
- [ ] Configurar scripts de test y coverage.
- [ ] Ejecutar y validar resultados en CI.
- [ ] Documentar proceso en README_TESTING.md.

---

## 5. [#149] [US072] — Optimización y automatización de workflows
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/149
- **Etiquetas:** bug, sprint-5
- **Prioridad:** Alta
- **Story Points:** 13
- **Estimación:** 28h
- **Creado:** 2025-11-06
- **Dependencias:** N/A

### User Story
Como DevOps Engineer quiero optimizar y automatizar los workflows de CI/CD para reducir tiempos de deployment, mejorar la calidad del código y garantizar entregas más rápidas y confiables
✅

### Acceptance Criteria
- [ ] Pipeline de CI/CD completamente automatizado desde commit hasta producción
- [ ] Tiempo de build y deployment reducido en al menos 40%
- [ ] Ejecución automática de tests unitarios, integración y E2E
- [ ] Code quality checks automáticos (linting, análisis estático)
- [ ] Análisis de cobertura de código (mínimo 80%)
- [ ] Deployment automático a staging tras merge a develop
- [ ] Deployment a producción con aprobación manual
- [ ] Rollback automático en caso de fallos post-deployment
- [ ] Notificaciones automáticas de estado de pipelines (Slack/Email)
- [ ] Cache de dependencias para acelerar builds
- [ ] Paralelización de jobs independientes
- [ ] Documentación de workflows y procesos

### Tasks
- [ ] Auditar workflows actuales e identificar cuellos de botella
- [ ] Optimizar Dockerfile y uso de capas para builds más rápidos
- [ ] Configurar cache de dependencias (npm, pip, gradle, etc.)
- [ ] Implementar matrix builds para tests en paralelo
- [ ] Integrar herramientas de code quality (SonarQube, ESLint, etc.)
- [ ] Configurar análisis de cobertura de código
- [ ] Crear workflow de deployment automático a staging
- [ ] Implementar estrategia de deployment blue-green o canary
- [ ] Configurar health checks post-deployment
- [ ] Desarrollar scripts de rollback automático
- [ ] Integrar notificaciones con Slack/Teams
- [ ] Crear workflow de release con changelog automático
- [ ] Implementar semantic versioning automático
- [ ] Documentar procesos y mejores prácticas
- [ ] Capacitar al equipo en nuevos workflows

---

## 6. [#142] [US068] — Auditoría y trazabilidad
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/142
- **Etiquetas:** enhancement, sprint-5, integration, analytics, medium
- **Prioridad:** Media
- **Story Points:** 10
- **Estimación:** 20h
- **Creado:** 2025-11-06
- **Dependencias:** N/A

### User Story
Como Administrador del Sistema quiero registrar todas las acciones críticas del sistema para garantizar trazabilidad completa, cumplir con normativas y facilitar investigación de incidentes

✅

### Acceptance Criteria
- [ ] Registro de todas las operaciones CRUD sobre entidades críticas
- [ ] Captura de quién, qué, cuándo y desde dónde se realizó cada acción
- [ ] Log de accesos y cambios en información de estudiantes
- [ ] Registro de eventos de entrada/salida con timestamps
- [ ] Historial de asociaciones y desasociaciones de pulseras
- [ ] Sistema de consulta y filtrado de logs de auditoría
- [ ] Retención de logs según política de compliance (mínimo 1 año)
- [ ] Logs inmutables o protegidos contra modificación

### Tasks
- [ ] Diseñar esquema de base de datos para audit logs
- [ ] Implementar interceptores/middleware para captura automática
- [ ] Crear servicio de auditoría centralizado
- [ ] Desarrollar API de consulta de logs de auditoría
- [ ] Implementar filtros por usuario, entidad, fecha, tipo de acción
- [ ] Crear interfaz de consulta para administradores
- [ ] Configurar rotación y archivado de logs antiguos
- [ ] Documentar eventos auditables y formato de logs

---

## 7. [#113] [US066]Beta testing con usuarios reales
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/113
- **Etiquetas:** documentation, question, sprint-5, reporting
- **Prioridad:** ** Media
- **Story Points:** ** 3
- **Estimación:** ** 8-12h (coordinación inicial; ejecución puede extenderse)
- **Creado:** 2025-11-04
- **Dependencias:** ** Acceso a stores/platforms; builds estables; infra de telemetría

### User Story
---
Ejecutar beta testing con usuarios reales para validar UX, rendimiento y detectar regresiones en condiciones reales.

### Acceptance Criteria
- [ ] Programa de beta con cohortes definidos y objetivos de feedback.
- [ ] Captura de métricas y errores de los testers (telemetría habilitada).
- [ ] Recolección y priorización de feedback/bugs en staging antes de release.
- [ ] Documentación del plan, reclutamiento y criterios de éxito.

### Tasks
- [ ] Diseñar plan de beta (duración, cohortes, objetivos).
- [ ] Preparar builds (Play Store alpha/beta, TestFlight) y onboarding.
- [ ] Instrumentar telemetría y formularios de feedback in-app.
- [ ] Ejecutar beta, recopilar datos y generar informe con acciones.
- [ ] Cerrar ciclo con fixes y revalidación en staging.

---

## 8. [#109] [US063]Optimizar tamaño APK
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/109
- **Etiquetas:** enhancement, sprint-4, offline-support, medium
- **Prioridad:** Media - Alta
- **Story Points:** 5
- **Estimación:** 12-16h
- **Creado:** 2025-11-04
- **Dependencias:** Pipeline de builds; acceso a dispositivos/emuladores en CI

### User Story
---
Reducir tamaño del APK para mejorar instalación y rendimiento en dispositivos reales sin romper flujos críticos.

### Acceptance Criteria
- [ ] APK reducido respecto a baseline (objetivo % o MB definido).
- [ ] App optimizada pasa todos los tests E2E críticos en staging.
- [ ] Build reproducible y documentado (ProGuard/R8, split APKs, resource shrinking).
- [ ] CI produce APK optimizado en artifact store.

### Tasks
- [ ] Analizar tamaño actual (bundle analyzer).
- [ ] Configurar R8/ProGuard, resource shrinking y split APKs por ABI.
- [ ] Eliminar assets innecesarios y revisar dependencias.
- [ ] Ejecutar tests E2E en staging con APK optimizado.
- [ ] Documentar proceso de build y comandos en TESTING.md.

---

## 9. [#62] [US060] Actualizaciones tiempo real - 13pts
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/62
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Alta
- **Story Points:** 13
- **Estimación:** 52h
- **Creado:** 2025-09-02
- **Dependencias:** N/A

### User Story
Como Usuario quiero recibir actualizaciones tiempo real entre app y web para información siempre actualizada
✅

### Acceptance Criteria
- [ ] WebSockets o polling implementado
- [ ] Notificaciones push configuradas
- [ ] Latencia <2s garantizada

### Tasks
- [ ] Sistema notificaciones
- [ ] WebSockets/polling tiempo real
- [ ] Notificaciones push
- [ ] Optimización latencia <2s

---

## 10. [#36] [US026] Registrar accesos - 5pts
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/36
- **Etiquetas:** enhancement, database, sprint-2
- **Prioridad:** ** Crítica
- **Story Points:** ** 5
- **Estimación:** ** 20h
- **Creado:** 2025-09-02
- **Dependencias:** N/A

### User Story
Como Sistema quiero registrar accesos entrada/salida para llevar control de movimientos

## ✅

### Acceptance Criteria
- [ ] Registro tipo acceso
- [ ] Timestamp, estudiante, guardia
- [ ] Punto control

### Tasks
- [ ] Esquema BD eventos acceso
- [ ] Service registro accesos
- [ ] Validación datos obligatorios
- [ ] Índices rendimiento

---

## 11. [#35] [US025] Registrar decisión timestamp - 3pts
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/35
- **Etiquetas:** enhancement, database, sprint-2
- **Prioridad:** ** Media
- **Story Points:** ** 3
- **Estimación:** ** 12h
- **Creado:** 2025-09-02
- **Dependencias:** N/A

### User Story
Como Sistema quiero registrar decisión con timestamp para mantener trazabilidad completa

## ✅

### Acceptance Criteria
- [ ] Timestamp preciso
- [ ] ID guardia
- [ ] Decisión tomada
- [ ] Persistencia BD

### Tasks
- [ ] Modelo entidad evento
- [ ] Timestamp UTC preciso
- [ ] Persistencia BD
- [ ] Índices optimización

---

## 12. [#29] [US021] Validar ID pulsera - 5pts
- **Estado:** Abierto
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/29
- **Etiquetas:** enhancement, database, nfc, sprint-2
- **Prioridad:** ** Alta
- **Story Points:** ** 5
- **Estimación:** ** 20h
- **Creado:** 2025-09-02
- **Dependencias:** N/A

### User Story
Como Sistema quiero validar ID contra BD para verificar autenticidad de pulsera

## ✅

### Acceptance Criteria
- [ ] Query BD pulseras
- [ ] Validación existencia
- [ ] Manejo IDs inválidos

### Tasks
- [ ] Query validación BD
- [ ] Cache pulseras válidas
- [ ] Manejo IDs inválidos
- [ ] Logs seguridad

---

# Issues Cerrados

## 1. [#145] [US071] Tests de carga y performance
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/145
- **Etiquetas:** bug, documentation, sprint-5, integration, analytics, dashboard, medium
- **Prioridad:** Media
- **Story Points:** 8
- **Creado:** 2025-11-06
- **Cerrado:** 2025-11-06

### User Story
Como Arquitecto de Sistema quiero realizar pruebas de carga y análisis de performance para garantizar que el sistema soporte la carga esperada y mantener tiempos de respuesta óptimos

✅

### Acceptance Criteria
- [x] Tests de carga para escenarios de uso pico (horario de entrada/salida)
- [x] Simulación de carga concurrente (mínimo 500 usuarios simultáneos)
- [x] Tiempo de respuesta promedio < 200ms para operaciones críticas
- [x] Tasa de éxito > 99.5% bajo carga normal
- [x] Identificación de cuellos de botella
- [x] Reporte de métricas de performance (latencia P50, P95, P99)
- [x] Tests de stress para identificar punto de quiebre
- [x] Pruebas de resistencia (soak tests) de 24 horas
- [x] Plan de optimización basado en resultados

### Tasks
- [x] Definir escenarios de prueba realistas (check-in masivo, consultas, reportes)
- [x] Configurar herramientas de testing (JMeter, K6, Gatling, Locust)
- [x] Crear scripts de pruebas de carga
- [x] Configurar ambiente de staging con datos representativos
- [x] Ejecutar tests de carga incremental
- [x] Realizar tests de stress y soak
- [x] Monitorear métricas durante pruebas (CPU, memoria, DB)
- [x] Analizar resultados e identificar bottlenecks
- [x] Documentar hallazgos y recomendaciones
- [x] Implementar optimizaciones críticas
- [x] Re-ejecutar tests para validar mejoras

---

## 2. [#144] [US070] Documentación API completa
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/144
- **Etiquetas:** documentation, authentication, sprint-5, reporting, real-time, medium
- **Prioridad:** Media
- **Story Points:** 5
- **Creado:** 2025-11-06
- **Cerrado:** 2025-11-07

### User Story
Como Desarrollador Frontend/Mobile quiero documentación completa y actualizada de todas las APIs para integrarme eficientemente y reducir errores de implementación
✅

### Acceptance Criteria
- [x] Documentación OpenAPI/Swagger de todos los endpoints
- [x] Descripción clara de cada endpoint (propósito, parámetros, respuestas)
- [x] Ejemplos de requests y responses para cada endpoint
- [x] Códigos de error documentados con significado
- [x] Documentación de modelos de datos y esquemas
- [x] Guía de autenticación y autorización
- [x] Ejemplos de flujos completos (onboarding, check-in, etc.)
- [x] Sandbox/ambiente de pruebas disponible
- [x] Versionado de API documentado
- [x] Changelog de cambios entre versiones

### Tasks
- [x] Generar documentación OpenAPI automática desde código
- [x] Completar anotaciones/decoradores en endpoints
- [x] Escribir descripciones detalladas de cada endpoint
- [x] Crear ejemplos realistas de uso
- [x] Documentar todos los códigos de error
- [x] Desarrollar guía de inicio rápido (Quick Start)
- [x] Crear colección de Postman/Insomnia
- [x] Configurar entorno de sandbox con datos de prueba
- [x] Publicar documentación en portal accesible
- [x] Establecer proceso de actualización continua

---

## 3. [#143] [US069] Backup y recuperación automática
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/143
- **Etiquetas:** documentation, sprint-5, dashboard, backend
- **Prioridad:** Alta
- **Story Points:** 13
- **Creado:** 2025-11-06
- **Cerrado:** 2025-11-06

### User Story
Como Administrador del Sistema quiero backups automáticos y procedimientos de recuperación probados para garantizar continuidad del negocio y protección contra pérdida de datos
✅

### Acceptance Criteria
- [x] Backups automáticos diarios de base de datos
- [x] Backups incrementales cada 6 horas
- [x] Retención de backups: 7 diarios, 4 semanales, 3 mensuales
- [x] Almacenamiento de backups en ubicación separada/cloud
- [x] Encriptación de backups en reposo
- [x] Verificación automática de integridad de backups
- [x] Procedimiento documentado y probado de recuperación
- [x] Tiempo de recuperación objetivo (RTO) < 4 horas
- [x] Punto de recuperación objetivo (RPO) < 6 horas
- [x] Alertas si fallan backups

### Tasks
- [x] Configurar sistema de backup automatizado (pg_dump, mysqldump, etc.)
- [x] Implementar backups incrementales
- [x] Configurar almacenamiento remoto (AWS S3, Azure Blob, etc.)
- [x] Implementar encriptación de backups
- [x] Crear scripts de verificación de integridad
- [x] Desarrollar procedimiento de restauración automatizado
- [x] Documentar runbook de recuperación ante desastres
- [x] Realizar pruebas de restauración en ambiente de staging
- [x] Configurar monitoreo y alertas de backups
- [x] Establecer política de retención y limpieza

---

## 4. [#141] [US067] - Monitoreo de Salud del Sistema
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/141
- **Etiquetas:** bug, sprint-5, integration, analytics, high, backend
- **Prioridad:** Alta
- **Story Points:** 5
- **Creado:** 2025-11-06
- **Cerrado:** 2025-11-06

---

## 5. [#112] [US065]Configurar monitoreo y alertas mobile
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/112
- **Etiquetas:** enhancement, sprint-4, integration, analytics, security, high
- **Prioridad:** Alta
- **Story Points:** 5
- **Creado:** 2025-11-04
- **Cerrado:** 2025-11-06

### User Story
---
Configurar monitoreo y alertas básicas para la app mobile en staging (crashes, latencia, errores críticos).

### Acceptance Criteria
- [x] Métricas clave (crashes, ANR, latencia, error rate) reportadas a sistema de monitoring.
- [x] Alertas mínimas configuradas (p.ej. aumento de crash rate, error rate > umbral).
- [x] Pruebas que disparen alertas en staging y validen notificaciones.
- [x] Dashboard básico disponible para el equipo.

### Tasks
- [x] Seleccionar tool (Sentry/Firebase Crashlytics + Datadog/Prometheus).
- [x] Instrumentar SDKs en app y backend para métricas y errores.
- [x] Definir umbrales de alerta y configurar notificaciones (Slack/Email).
- [x] Ejecutar pruebas que simulen condiciones para disparar alertas.
- [x] Documentar dashboards y procedimientos de respuesta.

---

## 6. [#110] [US064]Implementar logging centralizado
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/110
- **Etiquetas:** enhancement, sprint-4, integration, analytics, high, backend
- **Prioridad:** Alta
- **Story Points:** 5
- **Creado:** 2025-11-04
- **Cerrado:** 2025-11-06

### User Story
---
Implementar logging centralizado para facilitar debugging y correlación entre mobile y backend.

### Acceptance Criteria
- [x] Logs estructurados (JSON) enviados a solución central (ELK/Datadog/Cloud Logging).
- [x] Correlación request-id entre mobile y backend disponible.
- [x] Pruebas E2E validan que eventos críticos generen logs en el sistema central.
- [x] Retención y acceso básico configurados para staging.

### Tasks
- [x] Seleccionar stack (ELK/Datadog/Cloud) y agregar SDKs/agents.
- [x] Establecer formato estructurado y request-id propagation.
- [x] Instrumentar logs en mobile y backend para eventos críticos.
- [x] Crear pruebas que verifiquen aparición de logs en staging.
- [x] Documentar acceso y queries útiles en TESTING.md.

---

## 7. [#108] [US062]Implementar rate limiting
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/108
- **Etiquetas:** enhancement, sprint-3, integration, security, high, backend
- **Prioridad:** Alta
- **Story Points:** 3
- **Creado:** 2025-11-04
- **Cerrado:** 2025-11-06

### User Story
---
Implementar rate limiting para proteger endpoints críticos contra abuso y garantizar estabilidad.

### Acceptance Criteria
- [x] Rate limiting aplicado a endpoints críticos (login, auth, CRUD usuarios, métricas).
- [x] Respuestas controladas (HTTP 429) con headers explicativos (Retry-After).
- [x] Tests E2E y unitarios verifican comportamiento bajo límite.
- [x] Configuración configurable por entorno (staging/production).

### Tasks
- [x] Seleccionar e integrar solución (middleware: express-rate-limit, gateway o similar).
- [x] Definir políticas por endpoint y entorno.
- [x] Implementar mensajes y headers estándar para 429.
- [x] Crear tests que simulan exceder límites y validan respuesta.
- [x] Añadir configuración en infra/CI para staging.

---

## 8. [#107] [US061]Optimizar consultas MongoDB
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/107
- **Etiquetas:** enhancement, database, sprint-3, integration, high, backend
- **Prioridad:** Alta
- **Story Points:** 5
- **Creado:** 2025-11-04
- **Cerrado:** 2025-11-06

### User Story
---
Como UX Designer quiero validar que la interfaz mobile cumple con estándares de usabilidad y accesibilidad para garantizar una buena experiencia de usuario.

### Acceptance Criteria
- [x] Consultas críticas tienen índices adecuados y tiempos de respuesta mejorados (baseline vs nueva).
- [x] No se introducen regresiones funcionales en endpoints críticos.
- [x] Tests de integración y de rendimiento automatizados validan cambios en staging.
- [x] Documentación de cambios en queries/indexes incluida en TESTING.md o DB_README.md.

### Tasks
- [x] Identificar consultas críticas y crear baseline de rendimiento.
- [x] Añadir/ajustar índices y reescribir queries problemáticas.
- [x] Escribir tests automatizados (integration + smoke + simple perf) para staging.
- [x] Ejecutar pruebas de carga leve y comparar métricas.
- [x] Documentar cambios e impactos.

---

## 9. [#106] [US071]Testing de UI/UX en Frontend Mobile
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/106
- **Etiquetas:** documentation, sprint-5, dashboard, real-time, medium
- **Prioridad:** Media
- **Story Points:** 5
- **Creado:** 2025-11-04
- **Cerrado:** 2025-11-04

### User Story
---
Como UX Designer quiero validar que la interfaz mobile cumple con estándares de usabilidad y accesibilidad para garantizar una buena experiencia de usuario.

### Acceptance Criteria
- [x] Tests de accesibilidad automatizados (contraste, tamaños, labels)
- [x] Pruebas de usabilidad en dispositivos Android de diferentes tamaños
- [x] Verificación de tiempos de respuesta visual (<300ms para interacciones)
- [x] Tests de navegación y flujos principales sin errores
- [x] Cumplimiento de guías Material Design / iOS Human Interface

### Tasks
- [x] Configurar herramienta de testing de accesibilidad (Accessibility Scanner, axe)
- [x] Realizar pruebas manuales en dispositivos físicos (3+ tamaños diferentes)
- [x] Implementar tests automatizados de componentes UI con Jest/Testing Library
- [x] Medir y optimizar tiempos de respuesta de interacciones
- [x] Documentar hallazgos y crear tickets para mejoras identificadas
- [x] Validar cumplimiento de guías de diseño con checklist

---

## 10. [#105] [US70]Testing de Integración Backend-Frontend
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/105
- **Etiquetas:** documentation, sprint-5, security, backend
- **Prioridad:** Alta
- **Story Points:** 8
- **Creado:** 2025-11-04
- **Cerrado:** 2025-11-04

### User Story
---
Como QA Engineer quiero tests de integración end-to-end para verificar que el backend y frontend mobile funcionan correctamente juntos.

### Acceptance Criteria
- [x] Suite de tests E2E que cubra flujos críticos (login, CRUD usuarios, dashboard)
- [x] Tests ejecutándose contra ambiente de staging antes de producción
- [x] Verificación de contratos API (request/response esperados)
- [x] Tests automatizados en CI con reporte de resultados
- [x] Documentación de cómo ejecutar tests localmente

### Tasks
- [x] Configurar framework de testing E2E (Detox para mobile, Supertest para API)
- [x] Escribir tests para flujos: autenticación, gestión de usuarios, consulta de métricas
- [x] Implementar contract testing (Pact o validación de schemas)
- [x] Configurar ambiente de staging para tests automáticos
- [x] Integrar suite E2E en pipeline CI/CD
- [x] Documentar setup y ejecución en TESTING.md

---

## 11. [#104] [US069]Mejorar Tests Unitarios
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/104
- **Etiquetas:** documentation, sprint-5
- **Prioridad:** Alta | Dependencias: Ninguna
- **Story Points:** 5 | Estimación: 10-12h | Prioridad: Alta | Dependencias: Ninguna
- **Creado:** 2025-11-04
- **Cerrado:** 2025-11-04

### User Story
Como Desarrollador quiero aumentar la cobertura y calidad de los tests unitarios para detectar bugs tempranamente y facilitar refactorizaciones seguras.

### Acceptance Criteria
- [x] Cobertura de código ≥80% en backend y ≥75% en frontend mobile
- [x] Tests unitarios para casos edge y manejo de errores
- [x] Mocks configurados para dependencias externas (MongoDB, APIs)
- [x] Tests ejecutándose automáticamente en CI/CD
- [x] Reporte de cobertura generado y accesible en cada build

### Tasks
- [x] Auditar cobertura actual con herramientas (jest --coverage, nyc)
- [x] Identificar módulos críticos sin tests adecuados
- [x] Escribir tests para funciones de negocio, validaciones y utilidades
- [x] Configurar mocks para llamadas a base de datos y servicios externos
- [x] Integrar reporte de cobertura en pipeline CI
- [x] Establecer umbral mínimo que bloquee merges si no se cumple

---

## 12. [#103] [US068]Documentar API endpoints
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/103
- **Etiquetas:** documentation, sprint-5, backend, medium
- **Prioridad:** Media
- **Story Points:** 3
- **Creado:** 2025-10-30
- **Cerrado:** 2025-11-04

### User Story
Como Desarrollador quiero contar con documentación Swagger/OpenAPI para entender y probar fácilmente los endpoints de la API.

##

### Acceptance Criteria
- [x] `/api-docs` disponible con Swagger UI
- [x] Esquema OpenAPI 3.0 válido con `bearerAuth (JWT)`
- [x] Endpoints documentados: `POST /login`, `GET/POST/PUT /usuarios`, `GET /dashboard/metrics`
- [x] Ejemplos de request/response y códigos de estado comunes
- [x] Verificación en CI que alerta si la documentación queda desactualizada

### Tasks
- [x] Configurar `swagger-jsdoc` y `swagger-ui-express`
- [x] Añadir anotaciones OpenAPI a endpoints clave
- [x] Incluir ejemplos y descripciones de parámetros
- [x] Integrar verificación en CI (paso que falla si cambia `API.md`)
- [x] Enlazar `/api-docs` desde `README.md`

---

## 13. [#102] [US067]Auditoría de seguridad
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/102
- **Etiquetas:** sprint-5, security, high, backend
- **Prioridad:** Alta
- **Story Points:** 5
- **Creado:** 2025-10-30
- **Cerrado:** 2025-11-04

### User Story
Como Admin quiero asegurar la autenticación y la validación de datos para reducir riesgos y accesos no autorizados.

##

### Acceptance Criteria
- [x] JWT emitido y verificado con expiración y algoritmo seguro
- [x] Contraseñas hasheadas con bcrypt y sal adecuada
- [x] Validación de inputs en login/usuarios/asistencias con errores claros
- [x] Helmet y rate limiting aplicados a endpoints sensibles
- [x] Evidencias en PR (pruebas, logs) y checklist OWASP básico

### Tasks
- [x] Implementar middleware `authenticateToken` y generación de token
- [x] Validar `email/password` en `/login` y campos en `/usuarios`
- [x] Añadir `helmet` y `express-rate-limit` (p.ej. en `/login`)
- [x] Revisar respuestas de error para no filtrar información sensible
- [x] Documentar riesgos y mitigaciones encontradas

---

## 14. [#63] [US052] Horarios pico ML - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/63
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Alta
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Administrador quiero ver reporte de horarios pico por ML para validar predicciones del modelo
✅

### Acceptance Criteria
- [x] Comparación ML vs real disponible
- [x] Precisión por horario calculada
- [x] Ajustes sugeridos generados

### Tasks
- [x] Modelo ML validado
- [x] Comparación ML vs real
- [x] Métricas precisión por horario
- [x] Generador ajustes sugeridos

---

## 15. [#61] [US058] Web y app mismo servidor - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/61
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Crítica
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Sistema quiero que web y app consuman mismo servidor para mantener consistencia datos
✅

### Acceptance Criteria
- [x] API unificada implementada
- [x] Misma BD utilizada
- [x] Endpoints compatibles configurados

### Tasks
- [x] API centralizada
- [x] Unificación BD
- [x] Endpoints compatibles
- [x] Testing integración

---

## 16. [#60] [US057] Funcionalidad offline - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/60
- **Etiquetas:** enhancement, sprint-3
- **Prioridad:** Alta
- **Story Points:** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-11

### User Story
Como Guardia quiero usar app offline con sincronización posterior para trabajar sin conexión internet
✅

### Acceptance Criteria
- [x] Cache local implementado
- [x] Queue eventos offline funcional
- [x] Sync automático al reconectar

### Tasks
- [x] Storage local app
- [x] Cache local datos
- [x] Queue eventos offline
- [x] Sync automático reconexión

---

## 17. [#59] [US056] Sincronización app-servidor - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/59
- **Etiquetas:** enhancement, sprint-3
- **Prioridad:** Crítica
- **Story Points:** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Sistema quiero sincronizar app móvil con servidor central para mantener datos consistentes
✅

### Acceptance Criteria
- [x] Sync bidireccional implementado
- [x] Manejo conflictos configurado
- [x] Versionado datos funcional

### Tasks
- [x] API REST completa
- [x] Sync bidireccional
- [x] Manejo conflictos datos
- [x] Versionado datos

---

## 18. [#58] [US055] Comparativo antes/después - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/58
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Alta
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Administrador quiero ver reporte comparativo antes/después implementación para demostrar ROI del proyecto
✅

### Acceptance Criteria
- [x] Métricas pre/post sistema calculadas
- [x] KPIs impacto definidos y medidos
- [x] Análisis costo-beneficio realizado

### Tasks
- [x] Datos baseline pre-sistema
- [x] Métricas pre/post implementación
- [x] KPIs impacto proyecto
- [x] Análisis costo-beneficio ROI

---

## 19. [#57] [US054] Uso buses sugerido vs real - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/57
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Media
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Administrador quiero ver reporte uso buses sugerido vs real para evaluar adopción de sugerencias
✅

### Acceptance Criteria
- [x] Comparativo horarios sugeridos vs implementados
- [x] Impacto medido y cuantificado
- [x] Dashboard adopción sugerencias

### Tasks
- [x] Tracking implementación sugerencias
- [x] Comparativo sugerido vs real
- [x] Medición impacto adopción
- [x] Dashboard seguimiento buses

---

## 20. [#56] [US059] Múltiples guardias simultáneos - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/56
- **Etiquetas:** enhancement, sprint-3, integration
- **Prioridad:** ** Alta
- **Story Points:** ** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Sistema quiero soportar múltiples guardias simultáneos para escalabilidad operacional

## ✅

### Acceptance Criteria
- [x] Concurrencia manejada
- [x] Locks optimistas
- [x] Resolución conflictos

### Tasks
- [x] Manejo concurrencia BD
- [x] Locks optimistas
- [x] Resolución conflictos
- [x] Testing concurrencia

---

## 21. [#55] [US053] Precisión modelo ML - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/55
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Media
- **Story Points:** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Administrador quiero ver reporte de precisión del modelo ML para monitorear calidad predicciones
✅

### Acceptance Criteria
- [x] Métricas precisión, recall, F1-score calculadas
- [x] Evolución temporal mostrada
- [x] Dashboard métricas ML disponible

### Tasks
- [x] Sistema métricas ML
- [x] Cálculo precisión/recall/F1
- [x] Evolución temporal métricas
- [x] Dashboard monitoreo ML

---

## 22. [#54] [US057] Funcionalidad offline - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/54
- **Etiquetas:** enhancement, sprint-3, offline-support
- **Prioridad:** ** Alta
- **Story Points:** ** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Guardia quiero usar app offline con sincronización posterior para trabajar sin conexión internet

## ✅

### Acceptance Criteria
- [x] Cache local
- [x] Queue eventos offline
- [x] Sync automático al reconectar

### Tasks
- [x] Storage local SQLite
- [x] Queue eventos offline
- [x] Detección conexión
- [x] Sync automático reconexión
- [x] Resolución conflictos

---

## 23. [#53] [US052] Horarios pico ML - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/53
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Alta
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Administrador quiero ver reporte de horarios pico por ML para validar predicciones del modelo
✅

### Acceptance Criteria
- [x] Comparación ML vs real disponible
- [x] Precisión por horario calculada
- [x] Ajustes sugeridos generados

### Tasks
- [x] Modelo ML validado
- [x] Comparación ML vs real
- [x] Métricas precisión por horario
- [x] Generador ajustes sugeridos

---

## 24. [#52] [US056] Sincronización app-servidor - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/52
- **Etiquetas:** enhancement, sprint-3, integration
- **Prioridad:** ** Crítica
- **Story Points:** ** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Sistema quiero sincronizar app móvil con servidor central para mantener datos consistentes

## ✅

### Acceptance Criteria
- [x] Sync bidireccional
- [x] Manejo conflictos
- [x] Versionado datos

### Tasks
- [x] API REST sincronización
- [x] Manejo conflictos datos
- [x] Versionado datos
- [x] Queue sincronización
- [x] Logs de sincronización

---

## 25. [#51] [US051] Estudiantes más activos - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/51
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Baja
- **Story Points:** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-07

### User Story
Como Administrador quiero ver reporte de estudiantes más activos para identificar usuarios frecuentes
✅

### Acceptance Criteria
- [x] Ranking por accesos disponible
- [x] Período configurable implementado
- [x] Datos estadísticos calculados

### Tasks
- [x] Análisis estadístico usuarios
- [x] Ranking por accesos
- [x] Configuración períodos
- [x] Dashboard estudiantes activos

---

## 26. [#50] [US035] Filtrar por carrera y fechas - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/50
- **Etiquetas:** enhancement, sprint-3, search-filters
- **Prioridad:** ** Media
- **Story Points:** ** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Guardia quiero filtrar por carrera o rango de fechas para análisis específico de datos

## ✅

### Acceptance Criteria
- [x] Filtros múltiples
- [x] Date picker
- [x] Dropdown carreras
- [x] Combinaciones

### Tasks
- [x] Componentes filtro UI
- [x] Date picker rango fechas
- [x] Dropdown carreras
- [x] Combinación múltiples filtros

---

## 27. [#49] [US050] Exportar reportes PDF/Excel - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/49
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Media
- **Story Points:** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Administrador quiero exportar reportes en PDF/Excel para compartir con otros departamentos
✅

### Acceptance Criteria
- [x] Exportación PDF con gráficos funcional
- [x] Excel con datos raw disponible
- [x] Formato profesional aplicado

### Tasks
- [x] Librerías exportación integradas
- [x] Exportación PDF con gráficos
- [x] Exportación Excel datos raw
- [x] Templates formato profesional

---

## 28. [#48] [US034] Historial accesos recientes - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/48
- **Etiquetas:** enhancement, sprint-3, search-filters
- **Prioridad:** ** Baja
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Guardia quiero ver historial de accesos recientes para revisar actividad pasada

## ✅

### Acceptance Criteria
- [x] Lista cronológica
- [x] Últimas 24h/48h
- [x] Detalles completos

### Tasks
- [x] Query accesos recientes
- [x] Filtro temporal configurable
- [x] Lista cronológica
- [x] Detalles completos evento

---

## 29. [#47] [US049] Reportes eficiencia buses - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/47
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Media
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Administrador quiero ver reportes de eficiencia de buses para evaluar impacto de optimizaciones
✅

### Acceptance Criteria
- [x] Métricas utilización calculadas
- [x] Comparativo antes/después disponible
- [x] ROI calculado automáticamente

### Tasks
- [x] Datos eficiencia buses
- [x] Métricas utilización
- [x] Comparativo antes/después
- [x] Cálculo ROI automatizado

---

## 30. [#46] [US033] Buscar estudiante - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/46
- **Etiquetas:** enhancement, sprint-3, search-filters
- **Prioridad:** ** Media
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Guardia quiero buscar estudiante por nombre o ID para encontrar información específica

## ✅

### Acceptance Criteria
- [x] Search box
- [x] Autocompletado
- [x] Resultados múltiples
- [x] Datos completos

### Tasks
- [x] Componente search box
- [x] Autocompletado con AJAX
- [x] Búsqueda full-text
- [x] Display resultados múltiples

---

## 31. [#45] [US032] Lista estudiantes en campus - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/45
- **Etiquetas:** enhancement, sprint-3, real-time
- **Prioridad:** ** Alta
- **Story Points:** ** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-04

### User Story
Como Guardia quiero ver estudiantes actualmente en campus para conocer ocupación actual

## ✅

### Acceptance Criteria
- [x] Lógica entrada-salida
- [x] Estado actual
- [x] Contador total

### Tasks
- [x] Algoritmo estudiantes actuales
- [x] Query estado tiempo real
- [x] Contador ocupación
- [x] Actualización automática

---

## 32. [#44] [US048] Predicciones modelo ML - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/44
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Alta
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Administrador quiero visualizar predicciones del modelo ML para planificar basado en predicciones
✅

### Acceptance Criteria
- [x] Gráficos predicción vs real disponibles
- [x] Intervalos confianza mostrados
- [x] Actualización automática configurada

### Tasks
- [x] Modelo ML productivo integrado
- [x] Gráficos predicción vs real
- [x] Intervalos confianza
- [x] Actualización automática

---

## 33. [#43] [US031] Lista estudiantes hoy - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/43
- **Etiquetas:** enhancement, sprint-3, search-filters
- **Prioridad:** ** Media
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Guardia quiero ver lista de estudiantes que ingresaron hoy para monitorear actividad diaria

## ✅

### Acceptance Criteria
- [x] Query fecha actual
- [x] Lista ordenada por hora
- [x] Filtros básicos

### Tasks
- [x] Query estudiantes día actual
- [x] Ordenamiento por hora
- [x] Filtros básicos
- [x] Paginación resultados

---

## 34. [#42] [US030] Historial completo - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/42
- **Etiquetas:** enhancement, database, sprint-2
- **Prioridad:** ** Media
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-04

### User Story
Como Sistema quiero mantener historial completo de movimientos para análisis y auditorías

## ✅

### Acceptance Criteria
- [x] Almacenamiento permanente
- [x] Índices optimizados
- [x] Políticas retención

### Tasks
- [x] Particionamiento tabla eventos
- [x] Índices optimizados
- [x] Políticas retención datos
- [x] Archivado histórico

---

## 35. [#41] [US029] Registrar ubicación - 3pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/41
- **Etiquetas:** enhancement, database, sprint-2
- **Prioridad:** ** Media
- **Story Points:** ** 3
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-04

### User Story
Como Sistema quiero registrar ubicación/punto de control para saber por dónde accedió

## ✅

### Acceptance Criteria
- [x] ID punto control
- [x] Coordenadas si aplica
- [x] Descripción ubicación

### Tasks
- [x] Campo punto control en eventos
- [x] Coordenadas GPS opcionales
- [x] Descripción ubicación
- [x] Mapa puntos control

---

## 36. [#40] [US047] Gráficos flujo horarios - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/40
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Alta
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-07

### User Story
Como Administrador quiero ver gráficos de flujo por horarios y días para identificar patrones visualmente
✅

### Acceptance Criteria
- [x] Charts interactivos implementados
- [x] Filtros temporales funcionales
- [x] Drill-down por día/hora disponible

### Tasks
- [x] Librería charting integrada
- [x] Charts interactivos flujo
- [x] Filtros temporales
- [x] Drill-down día/hora

---

## 37. [#39] [US028] Distinguir entrada/salida - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/39
- **Etiquetas:** enhancement, database, sprint-2
- **Prioridad:** ** Alta
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-04

### User Story
Como Sistema quiero distinguir entrada/salida de campus para saber quién está dentro

## ✅

### Acceptance Criteria
- [x] Campo tipo movimiento
- [x] Lógica entrada/salida
- [x] Validación coherencia

### Tasks
- [x] Enum tipo movimiento
- [x] Lógica entrada/salida
- [x] Validación coherencia temporal
- [x] Cálculo estudiantes en campus

---

## 38. [#38] [US046] Dashboard general accesos - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/38
- **Etiquetas:** enhancement, sprint-5
- **Prioridad:** Crítica
- **Story Points:** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Administrador quiero visualizar dashboard general de accesos para monitorear sistema en tiempo real
✅

### Acceptance Criteria
- [x] Métricas tiempo real disponibles
- [x] Gráficos interactivos implementados
- [x] Responsive design funcional

### Tasks
- [x] Framework web base
- [x] Métricas tiempo real
- [x] Gráficos interactivos
- [x] Responsive design

---

## 39. [#37] [US027] Guardar fecha, hora, datos - 3pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/37
- **Etiquetas:** enhancement, database, sprint-2
- **Prioridad:** ** Media
- **Story Points:** ** 3
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Sistema quiero guardar fecha, hora, estudiante, guardia y decisión para tener registro completo del evento

## ✅

### Acceptance Criteria
- [x] Persistencia completa datos
- [x] Integridad referencial
- [x] Backup automático

### Tasks
- [x] Integridad referencial FK
- [x] Triggers BD auditoría
- [x] Backup automático
- [x] Validación consistencia

---

## 40. [#34] [US045] Actualización semanal modelo - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/34
- **Etiquetas:** enhancement, sprint-4
- **Prioridad:** Media
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Sistema quiero actualizar modelo semanalmente para mantener precisión con datos recientes
✅

### Acceptance Criteria
- [x] Job automático semanal configurado
- [x] Reentrenamiento incremental implementado
- [x] Validación performance automatizada

### Tasks
- [x] Job automático semanal
- [x] Reentrenamiento incremental
- [x] Validación performance continua
- [x] Monitoreo drift modelo

---

## 41. [#33] [US024] Autorización manual - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/33
- **Etiquetas:** enhancement, user-management, sprint-2
- **Prioridad:** ** Crítica
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Guardia quiero autorizar/denegar manualmente para tener control final sobre acceso

## ✅

### Acceptance Criteria
- [x] Botones claros Autorizar/Denegar
- [x] Confirmación visual
- [x] Registro decisión

### Tasks
- [x] Botones Autorizar/Denegar
- [x] Modal confirmación
- [x] Registro decisión BD
- [x] Feedback visual inmediato

---

## 42. [#32] [US023] Mostrar datos estudiante - 3pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/32
- **Etiquetas:** enhancement, user-management, sprint-2
- **Prioridad:** ** Media
- **Story Points:** ** 3
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Guardia quiero ver datos básicos del estudiante para confirmar identidad visualmente

## ✅

### Acceptance Criteria
- [x] Display nombre, foto, carrera
- [x] ID claramente visible
- [x] Interfaz clara

### Tasks
- [x] Componente display estudiante
- [x] Carga de foto estudiante
- [x] Formato datos legible
- [x] Responsive design

---

## 43. [#31] [US044] Entrenar con históricos - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/31
- **Etiquetas:** enhancement, database, sprint-4
- **Prioridad:** Crítica
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Sistema quiero entrenar modelo con datos históricos mínimo 3 meses para obtener modelo confiable
✅

### Acceptance Criteria
- [x] Dataset ≥3 meses disponible
- [x] Train/test split realizado
- [x] Métricas validación calculadas

### Tasks
- [x] Recopilación dataset 3+ meses
- [x] Implementación train/test split
- [x] Pipeline entrenamiento
- [x] Métricas validación modelo

---

## 44. [#30] [US022] Verificar estado activo - 3pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/30
- **Etiquetas:** enhancement, database, sprint-2
- **Prioridad:** ** Alta
- **Story Points:** ** 3
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-30

### User Story
Como Sistema quiero verificar estado activo del estudiante para autorizar solo estudiantes vigentes

## ✅

### Acceptance Criteria
- [x] Check estado en BD
- [x] Validación temporal
- [x] Indicador status

### Tasks
- [x] Verificación estado activo
- [x] Validación temporal matrícula
- [x] Indicadores status UI

---

## 45. [#28] [US043] Series temporales - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/28
- **Etiquetas:** enhancement, sprint-4
- **Prioridad:** Alta
- **Story Points:** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-04

### User Story
Como Sistema quiero implementar series temporales para modelar evolución temporal
✅

### Acceptance Criteria
- [x] ARIMA o similar implementado
- [x] Estacionalidad detectada
- [x] Forecast precisión >75%

### Tasks
- [x] Modelo ARIMA
- [x] Detección estacionalidad
- [x] Validación forecast
- [x] Métricas precisión temporal

---

## 46. [#27] [US020] Múltiples detecciones - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/27
- **Etiquetas:** enhancement, nfc, sprint-2
- **Prioridad:** ** Alta
- **Story Points:** ** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-11

### User Story
Como Sistema quiero manejar múltiples detecciones simultáneas para procesar varios estudiantes a la vez

## ✅

### Acceptance Criteria
- [x] Queue detecciones
- [x] Procesamiento secuencial
- [x] Priorización por tiempo

### Tasks
- [x] Queue procesamiento async
- [x] Algoritmo priorización
- [x] Manejo concurrencia
- [x] Optimización rendimiento
- [x] Stress testing

---

## 47. [#26] [US042] Clustering - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/26
- **Etiquetas:** enhancement, sprint-4
- **Prioridad:** Media
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-04

### User Story
Como Sistema quiero implementar clustering para agrupar patrones similares
✅

### Acceptance Criteria
- [x] K-means o similar implementado
- [x] Número óptimo clusters determinado
- [x] Validación silhouette realizada

### Tasks
- [x] Algoritmo K-means
- [x] Determinación clusters óptimos
- [x] Validación silhouette
- [x] Visualización clusters

---

## 48. [#25] [US019] Mostrar detecciones tiempo real - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/25
- **Etiquetas:** enhancement, nfc, sprint-2, real-time
- **Prioridad:** ** Media
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-30

### User Story
Como Guardia quiero ver dispositivos detectados en tiempo real para monitorear actividad NFC

## ✅

### Acceptance Criteria
- [x] Lista tiempo real
- [x] Actualización automática
- [x] Indicadores de estado

### Tasks
- [x] Interface tiempo real
- [x] WebSocket para updates
- [x] Indicadores estado visual
- [x] Lista detecciones activas

---

## 49. [#24] [US041] Regresión lineal - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/24
- **Etiquetas:** enhancement, sprint-4
- **Prioridad:** Media
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Sistema quiero implementar regresión lineal para modelar relaciones lineales en datos
✅

### Acceptance Criteria
- [x] Algoritmo regresión implementado
- [x] R² > 0.7 alcanzado
- [x] Validación cruzada realizada
- [x] Métricas error calculadas

### Tasks
- [x] Algoritmo regresión lineal
- [x] Validación cruzada
- [x] Métricas error MSE/RMSE
- [x] Optimización parámetros

---

## 50. [#23] [US018] Asociar ID con estudiante - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/23
- **Etiquetas:** enhancement, database, nfc, sprint-2
- **Prioridad:** ** Alta
- **Story Points:** ** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-07

### User Story
Como Sistema quiero asociar ID pulsera con estudiante para vincular identidad física con digital

## ✅

### Acceptance Criteria
- [x] Mapping ID-estudiante
- [x] Validación asociación
- [x] Manejo no encontrados

### Tasks
- [x] Tabla mapping pulsera-estudiante
- [x] CRUD asociaciones
- [x] Validaciones integridad
- [x] Manejo casos no encontrados

---

## 51. [#22] [US012] Sincronización datos estudiantes - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/22
- **Etiquetas:** enhancement, database, sprint-2, integration
- **Prioridad:** ** Alta
- **Story Points:** ** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-11

### User Story
Como Sistema quiero sincronizar automáticamente datos para mantener información actualizada

## ✅

### Acceptance Criteria
- [x] Sync programado
- [x] Detección cambios
- [x] Log sincronización

### Tasks
- [x] Scheduler de sincronización
- [x] Detección de cambios (CDC)
- [x] Log de sincronización
- [x] Manejo de conflictos

---

## 52. [#21] [US010] Reportes actividad guardias - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/21
- **Etiquetas:** enhancement, sprint-3, reporting
- **Prioridad:** ** Media
- **Story Points:** ** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Administrador quiero generar reportes de actividad para supervisar desempeño del equipo

## ✅

### Acceptance Criteria
- [x] Reporte por periodo
- [x] Métricas actividad
- [x] Exportación PDF

### Tasks
- [x] Query builder para reportes
- [x] Generación de métricas
- [x] Exportación PDF
- [x] Programación automática

---

## 53. [#20] [US040] Alertas congestión - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/20
- **Etiquetas:** enhancement, sprint-4
- **Prioridad:** Alta
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-04

### User Story
Como Administrador quiero recibir alertas de congestión prevista para tomar medidas preventivas
✅

### Acceptance Criteria
- [x] Sistema alertas automático activo
- [x] Thresholds configurables
- [x] Notificaciones múltiples canales

### Tasks
- [x] Sistema alertas automático
- [x] Configuración thresholds
- [x] Notificaciones múltiples
- [x] Dashboard alertas admin

---

## 54. [#19] [US039] Sugerir horarios buses - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/19
- **Etiquetas:** enhancement, sprint-4
- **Prioridad:** Alta
- **Story Points:** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Sistema quiero sugerir horarios óptimos de buses para optimizar transporte universitario
✅

---

## 55. [#18] [US009] Modificar datos guardias - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/18
- **Etiquetas:** enhancement, user-management, sprint-2
- **Prioridad:** ** Media
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Administrador quiero modificar datos de guardias para mantener información actualizada

## ✅

### Acceptance Criteria
- [x] Formulario edición
- [x] Validación cambios
- [x] Historial modificaciones

### Tasks
- [x] Formulario edición guardia
- [x] Validaciones de integridad
- [x] Log de cambios históricos
- [x] Interfaz de historial

---

## 56. [#17] [US008] Asignar puntos de control - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/17
- **Etiquetas:** enhancement, user-management, sprint-2
- **Prioridad:** ** Alta
- **Story Points:** ** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-11

### User Story
Como Administrador quiero asignar guardias a puntos específicos para organizar la cobertura de seguridad

## ✅

### Acceptance Criteria
- [x] Lista puntos control
- [x] Asignación múltiple
- [x] Visualización asignaciones

### Tasks
- [x] CRUD puntos de control
- [x] Interface asignación múltiple
- [x] Mapa visual de asignaciones
- [x] Validaciones de conflictos

---

## 57. [#16] [US038] Predecir horarios pico - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/16
- **Etiquetas:** enhancement, sprint-4
- **Prioridad:** Crítica
- **Story Points:** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Sistema quiero predecir horarios pico entrada/salida para anticipar congestión
✅

### Acceptance Criteria
- [x] Modelo predictivo implementado
- [x] Precisión >80% alcanzada
- [x] Predicción 24h adelante funcional

### Tasks
- [x] Modelo predictivo base
- [x] Entrenamiento modelo
- [x] Validación precisión
- [x] API predicción 24h

---

## 58. [#15] [US007] Activar/desactivar guardias - 3pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/15
- **Etiquetas:** enhancement, user-management, sprint-2
- **Prioridad:** ** Media
- **Story Points:** ** 3
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-30

### User Story
Como Administrador quiero activar/desactivar cuentas de guardias para controlar acceso al sistema

## ✅

### Acceptance Criteria
- [x] Toggle activación
- [x] Bloqueo de acceso
- [x] Notificación al usuario

### Tasks
- [x] Implementar toggle activación
- [x] Bloqueo de acceso en BD
- [x] Sistema de notificaciones

---

## 59. [#14] [US037] Analizar patrones flujo - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/14
- **Etiquetas:** enhancement, sprint-4
- **Prioridad:** Crítica
- **Story Points:** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-04

### User Story
Como Sistema quiero analizar patrones de flujo de estudiantes para identificar tendencias
✅

### Acceptance Criteria
- [x] Algoritmos análisis temporal implementados
- [x] Detección patrones automatizada
- [x] Visualización tendencias disponible

### Tasks
- [x] Algoritmos análisis temporal
- [x] Detección patrones flujo
- [x] Visualización tendencias
- [x] Dashboard analítica

---

## 60. [#13] [US006] Registrar guardias - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/13
- **Etiquetas:** enhancement, user-management, sprint-2
- **Prioridad:** ** Alta
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Administrador quiero registrar nuevos guardias para ampliar el equipo de seguridad

## ✅

### Acceptance Criteria
- [x] Formulario registro
- [x] Validación datos
- [x] Asignación credenciales

### Tasks
- [x] Diseñar formulario registro
- [x] Validaciones de datos
- [x] Generación automática credenciales
- [x] Notificación al nuevo usuario

---

## 61. [#12] [US036] Recopilar datos ML - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/12
- **Etiquetas:** enhancement, database, sprint-4
- **Prioridad:** Crítica
- **Story Points:** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-10-30

### User Story
Como Sistema quiero recopilar datos entrada/salida por horarios para alimentar algoritmos ML
✅

### Acceptance Criteria
- [x] ETL datos históricos implementado
- [x] Estructura para ML definida
- [x] Limpieza datos automatizada

### Tasks
- [x] Diseño ETL datos históricos
- [x] Estructura base datos ML
- [x] Algoritmos limpieza datos
- [x] Validación calidad datos

---

## 62. [#11] [US017] Leer ID único pulsera - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/11
- **Etiquetas:** enhancement, sprint-1, nfc
- **Prioridad:** ** Crítica
- **Story Points:** ** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Sistema quiero leer ID único en rango 10cm para identificar cada pulsera específicamente

## ✅

### Acceptance Criteria
- [x] Lectura precisa en 10cm
- [x] ID único válido
- [x] Manejo errores lectura

### Tasks
- [x] Algoritmo lectura precisa
- [x] Validación ID único
- [x] Manejo errores lectura
- [x] Logs de eventos NFC

---

## 63. [#10] [US016] Detectar pulseras NFC - 13pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/10
- **Etiquetas:** enhancement, sprint-1, nfc
- **Prioridad:** ** Crítica
- **Story Points:** ** 13
- **Creado:** 2025-09-02
- **Cerrado:** 2025-11-06

### User Story
Como Sistema quiero detectar pulseras NFC automáticamente para identificar estudiantes en proximidad

## ✅

### Acceptance Criteria
- [x] Detección en 10cm
- [x] Lectura automática
- [x] Feedback visual/sonoro

### Tasks
- [x] Driver NFC reader
- [x] Algoritmo detección 10cm
- [x] Feedback visual/auditivo
- [x] Calibración distancia
- [x] Pruebas hardware

---

## 64. [#9] [US015] Verificar vigencia matrícula - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/9
- **Etiquetas:** enhancement, sprint-1, database
- **Prioridad:** ** Alta
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Sistema quiero verificar vigencia de matrícula para autorizar solo estudiantes activos

## ✅

### Acceptance Criteria
- [x] Consulta vigencia automática
- [x] Indicador visual claro
- [x] Manejo expirados

### Tasks
- [x] Lógica validación vigencia
- [x] Indicadores visuales estado
- [x] Alertas matrícula expirada
- [x] Configuración períodos académicos

---

## 65. [#8] [US014] Obtener datos básicos - 3pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/8
- **Etiquetas:** enhancement, sprint-1, database
- **Prioridad:** ** Media
- **Story Points:** ** 3
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-04

### User Story
Como Guardia quiero ver ID, nombre y carrera para identificar al estudiante

## ✅

### Acceptance Criteria
- [x] Display datos claros
- [x] Formato consistente
- [x] Carga rápida

### Tasks
- [x] API datos básicos estudiante
- [x] Componente UI display
- [x] Formateo de datos
- [x] Optimización carga

---

## 66. [#7] [US013] Consultar estado estudiante - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/7
- **Etiquetas:** enhancement, sprint-1, database
- **Prioridad:** ** Alta
- **Story Points:** ** 5
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-18

### User Story
Como Sistema quiero verificar estado activo/inactivo para validar elegibilidad de acceso

## ✅

### Acceptance Criteria
- [x] Query estado en tiempo real
- [x] Cache temporal
- [x] Indicador visual claro

### Tasks
- [x] API consulta estado
- [x] Implementar caché Redis
- [x] Indicadores visuales UI
- [x] Optimización queries

---

## 67. [#6] [US011] Conexión BD estudiantes - 8pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/6
- **Etiquetas:** enhancement, sprint-1, database
- **Prioridad:** ** Crítica
- **Story Points:** ** 8
- **Creado:** 2025-09-02
- **Cerrado:** 2025-09-11

### User Story
Como Sistema quiero conectar con BD existente para validar datos estudiantiles

## ✅

### Acceptance Criteria
- [x] Conexión estable
- [x] Consulta tiempo real
- [x] Manejo errores conexión

### Tasks
- [x] Configurar connection string
- [x] Implementar pool de conexiones
- [x] Manejo de errores y reconexión
- [x] Pruebas de rendimiento

---

## 68. [#5] [US005] Cambio de contraseña - 3pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/5
- **Etiquetas:** enhancement, sprint-1, authentication
- **Prioridad:** ** Baja
- **Story Points:** ** 3
- **Creado:** 2025-08-21
- **Cerrado:** 2025-09-30

### User Story
Como Usuario quiero cambiar mi contraseña para mantener mi cuenta segura

## ✅

### Acceptance Criteria
- [x] Validación contraseña actual
- [x] Nueva contraseña segura
- [x] Confirmación

### Tasks
- [x] Formulario cambio contraseña
- [x] Validaciones de seguridad
- [x] Encriptación y almacenamiento

---

## 69. [#4] [US004] Sesión configurable - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/4
- **Etiquetas:** enhancement, sprint-1, user-management
- **Prioridad:** ** Media
- **Story Points:** ** 5
- **Creado:** 2025-08-21
- **Cerrado:** 2025-09-30

### User Story
Como Administrador quiero configurar tiempo de sesión activa para balancear seguridad y usabilidad

## ✅

### Acceptance Criteria
- [x] Configuración por admin
- [x] Auto-logout por tiempo
- [x] Notificación previa

### Tasks
- [x] Crear configuración de timeout
- [x] Implementar auto-logout
- [x] Agregar notificaciones previas
- [x] Panel de configuración admin

---

## 70. [#3] [US003] Logout seguro - 2pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/3
- **Etiquetas:** enhancement, sprint-1, authentication
- **Prioridad:** ** Media
- **Story Points:** ** 2
- **Creado:** 2025-08-21
- **Cerrado:** 2025-09-18

### User Story
Como Usuario quiero cerrar sesión de forma segura para proteger mi cuenta

## ✅

### Acceptance Criteria
- [x] Botón logout visible
- [x] Limpieza de sesión
- [x] Redirección a login

### Tasks
- [x] Implementar función logout
- [x] Limpiar datos de sesión
- [x] Redireccionar a login

---

## 71. [#2] [US002] Manejo de roles - 3pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/2
- **Etiquetas:** enhancement, sprint-1, user-management
- **Prioridad:** ** Crítica
- **Story Points:** ** 3
- **Creado:** 2025-08-17
- **Cerrado:** 2025-09-04

### User Story
Como Sistema quiero distinguir roles Guardia y Administrador para controlar acceso a funcionalidades

## ✅

### Acceptance Criteria
- [x] Identificación de rol post-login
- [x] Interfaz adaptativa
- [x] Restricciones por rol

### Tasks
- [x] Crear tabla de roles en BD
- [x] Implementar middleware de autorización
- [x] Adaptar UI por roles

---

## 72. [#1] [US001] Autenticación de guardias - 5pts
- **Estado:** Cerrado
- **URL:** https://github.com/Sistema-de-control-de-acceso/MovilesII/issues/1
- **Etiquetas:** enhancement, sprint-1, authentication
- **Prioridad:** ** Crítica
- **Story Points:** ** 5
- **Creado:** 2025-08-17
- **Cerrado:** 2025-09-04

### User Story
Como Guardia quiero autenticarme con usuario y contraseña para acceder al sistema de control

## ✅

### Acceptance Criteria
- [x] Sistema valida credenciales
- [x] Manejo de errores
- [x] Interfaz de login funcional

### Tasks
- [x] Diseñar interfaz de login
- [x] Implementar validación de credenciales
- [x] Configurar sesiones de usuario
- [x] Pruebas de seguridad

---

# Estadísticas Generales

## Por Estado
- **Abiertos:** 12
- **Cerrados:** 72
- **Tasa de Completitud:** 85.7%

## Por Prioridad
- **** Alta:** 15
- **** Baja:** 2
- **** Crítica:** 8
- **** Media:** 18
- **Alta:** 19
- **Alta | Dependencias: Ninguna:** 1
- **Baja:** 1
- **Crítica:** 7
- **Media:** 12
- **Media - Alta:** 1

---

**Última actualización:** 18 de November 2025
**Generado automáticamente con:** `scripts/extract_issues.py`
