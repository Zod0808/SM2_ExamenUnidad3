# 📚 Índice de Documentación

**Sistema de Control de Acceso - MovilesII**  
**Última actualización:** 18 de Noviembre 2025

---

## 📋 Documentos Esenciales

### 🎯 Documentación Principal

1. **[README.md](../README.md)** ⭐ **PRINCIPAL**
   - Resumen ejecutivo del proyecto
   - Instalación y configuración
   - Guía rápida de uso
   - Estado actual del proyecto

2. **[user_stories.md](./user_stories.md)**
   - Lista completa de las 60 User Stories originales
   - Organizadas por sprints
   - Detalles de cada US

3. **[INFORME_AVANCE_USER_STORIES.md](./INFORME_AVANCE_USER_STORIES.md)**
   - Estado detallado de cada User Story
   - Evidencia de implementación
   - Porcentajes de completitud

4. **[NUEVAS_USER_STORIES_PROPUESTAS.md](./NUEVAS_USER_STORIES_PROPUESTAS.md)**
   - 8 nuevas User Stories (US061-US068)
   - Estado de completitud
   - Priorización

### 🔧 Documentación Técnica

5. **[API.md](./API.md)**
   - Documentación completa de endpoints REST
   - Ejemplos de uso
   - Autenticación y autorización

6. **[ARCHITECTURE.md](./ARCHITECTURE.md)**
   - Arquitectura del sistema
   - Diagramas y flujos
   - Decisiones de diseño

7. **[DEPLOYMENT.md](./DEPLOYMENT.md)**
   - Guía de despliegue
   - Configuración de producción
   - Variables de entorno

8. **[CI_CD_TESTING.md](./CI_CD_TESTING.md)**
   - Configuración de CI/CD
   - Workflows de GitHub Actions
   - Troubleshooting

9. **[COVERAGE_REPORTS.md](./COVERAGE_REPORTS.md)**
   - Guía de reportes de cobertura
   - Generación de reportes
   - Interpretación de métricas

10. **[AUDITORIA_AVANZADA.md](./AUDITORIA_AVANZADA.md)**
    - Sistema de auditoría avanzada
    - Búsqueda y exportación
    - Dashboard de auditoría

### 📊 Documentación de Funcionalidades

11. **[backend/README.md](../backend/README.md)**
    - Documentación del backend
    - Servicios y modelos
    - Configuración

12. **[backend/tests/README.md](../backend/tests/README.md)**
    - Guía de testing
    - Ejecución de tests
    - Cobertura

13. **[backend/ml/README_COMPLETO_ML.md](../backend/ml/README_COMPLETO_ML.md)**
    - Sistema de Machine Learning
    - Modelos implementados
    - Entrenamiento y predicción

---

## 📝 Documentos de Referencia (Pueden Consolidarse)

### Resúmenes de Completación
- `RESUMEN_US004_COMPLETADO.md` - US004
- `RESUMEN_US007_COMPLETADO.md` - US007
- `RESUMEN_US009_COMPLETADO.md` - US009
- `RESUMEN_US010_COMPLETADO.md` - US010
- `RESUMEN_US012_COMPLETADO.md` - US012
- `RESUMEN_US050_COMPLETADO.md` - US050
- `RESUMEN_US054_COMPLETADO.md` - US054
- `RESUMEN_US055_COMPLETADO.md` - US055
- `RESUMEN_US060_COMPLETADO.md` - US060
- `RESUMEN_US061_COMPLETADO.md` - US061
- `RESUMEN_US062_COMPLETADO.md` - US062
- `RESUMEN_US063_COMPLETADO.md` - US063
- `RESUMEN_US064_COMPLETADO.md` - US064
- `RESUMEN_US067_COMPLETADO.md` - US067

**Recomendación:** Consolidar en un solo documento `RESUMEN_COMPLETACION_USER_STORIES.md`

### Documentos Históricos
- `PLAN_ACCION_USER_STORIES_PENDIENTES.md` - Ya no aplica (todo completado)
- `ISSUES_PENDIENTES.md` - Ya no aplica
- `ISSUES_COMPLETO.md` - Referencia histórica
- `RESUMEN_IMPLEMENTACION_CRITICAS.md` - Consolidar
- `RESUMEN_FINAL_CRITICAS.md` - Consolidar
- `RESUMEN_US_100_PORCIENTO.md` - Consolidar
- `VERIFICACION_US011_CONEXION_BD_ESTUDIANTES.md` - Consolidar

**Recomendación:** Mover a carpeta `docs/historial/` o consolidar

### Documentos de Proyecto Académico
- `FD01-EPIS-Informe de Factibilidad de Proyecto.md`
- `FD02-EPIS-Informe Vision de Proyecto.md`
- `FD03-Informe de SRS.md`
- `FD04-Informe de SAD.md`
- `FD05-EPIS-Informe ProyectoFinal.docx.md`
- `FD06-Propuesta de Proyecto.md`

**Recomendación:** Mover a carpeta `docs/academico/`

---

## 🗂️ Estructura Recomendada

```
docs/
├── README.md (índice principal)
├── INDICE_DOCUMENTACION.md (este archivo)
│
├── esenciales/                    # Documentos esenciales
│   ├── user_stories.md
│   ├── INFORME_AVANCE_USER_STORIES.md
│   ├── NUEVAS_USER_STORIES_PROPUESTAS.md
│   ├── API.md
│   ├── ARCHITECTURE.md
│   ├── DEPLOYMENT.md
│   ├── CI_CD_TESTING.md
│   ├── COVERAGE_REPORTS.md
│   └── AUDITORIA_AVANZADA.md
│
├── completacion/                  # Resúmenes de completación
│   └── RESUMEN_COMPLETACION_USER_STORIES.md (consolidado)
│
├── historial/                     # Documentos históricos
│   ├── PLAN_ACCION_USER_STORIES_PENDIENTES.md
│   ├── ISSUES_PENDIENTES.md
│   └── ...
│
└── academico/                     # Documentos académicos
    ├── FD01-EPIS-Informe de Factibilidad.md
    └── ...
```

---

## 📌 Guía de Uso

### Para Desarrolladores Nuevos
1. Leer `README.md` principal
2. Revisar `ARCHITECTURE.md`
3. Consultar `API.md` para endpoints
4. Ver `user_stories.md` para funcionalidades

### Para Administradores
1. Leer `DEPLOYMENT.md`
2. Revisar `AUDITORIA_AVANZADA.md`
3. Consultar `CI_CD_TESTING.md`

### Para Testing
1. Ver `backend/tests/README.md`
2. Consultar `COVERAGE_REPORTS.md`
3. Revisar `CI_CD_TESTING.md`

---

**Última actualización:** 18 de Noviembre 2025

