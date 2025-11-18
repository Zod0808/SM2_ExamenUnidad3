# User Stories - Sistema de Control de Acceso

## US001: Autenticación de guardias

**User Story**
Como Guardia quiero autenticarme con usuario y contraseña para acceder al sistema de control

**Acceptance Criteria**
- Sistema valida credenciales correctamente
- Manejo de errores de autenticación
- Interfaz de login funcional y amigable

**Tasks**
- Diseñar interfaz de login
- Implementar validación de credenciales
- Configurar sesiones de usuario
- Pruebas de seguridad

**Story Points:** 5  
**Estimación:** 16h  
**Prioridad:** Crítica  
**Dependencias:** Base de datos usuarios

---

## US002: Manejo de roles

**User Story**
Como Sistema quiero distinguir roles Guardia y Administrador para controlar acceso a funcionalidades

**Acceptance Criteria**
- Identificación de rol post-login
- Interfaz adaptativa según rol
- Restricciones por rol implementadas

**Tasks**
- Crear tabla de roles en BD
- Implementar middleware de autorización
- Adaptar UI por roles

**Story Points:** 3  
**Estimación:** 12h  
**Prioridad:** Crítica  
**Dependencias:** US001

---

## US003: Logout seguro

**User Story**
Como Usuario quiero cerrar sesión de forma segura para proteger mi cuenta

**Acceptance Criteria**
- Botón logout visible
- Limpieza de sesión
- Redirección a login

**Tasks**
- Implementar función logout
- Limpiar datos de sesión
- Redireccionar a login

**Story Points:** 2  
**Estimación:** 8h  
**Prioridad:** Media  
**Dependencias:** US001

---

## US004: Sesión configurable

**User Story**
Como Administrador quiero configurar tiempo de sesión activa para balancear seguridad y usabilidad

**Acceptance Criteria**
- Configuración por admin
- Auto-logout por tiempo
- Notificación previa

**Tasks**
- Crear configuración de timeout
- Implementar auto-logout
- Agregar notificaciones previas
- Panel de configuración admin

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Media  
**Dependencias:** US001, US002

---

## US005: Cambio de contraseña

**User Story**
Como Usuario quiero cambiar mi contraseña para mantener mi cuenta segura

**Acceptance Criteria**
- Validación contraseña actual
- Nueva contraseña segura
- Confirmación

**Tasks**
- Formulario cambio contraseña
- Validaciones de seguridad
- Encriptación y almacenamiento

**Story Points:** 3  
**Estimación:** 12h  
**Prioridad:** Baja  
**Dependencias:** US001

---

## US006: Registrar guardias

**User Story**
Como Administrador quiero registrar nuevos guardias para ampliar el equipo de seguridad

**Acceptance Criteria**
- Formulario registro
- Validación datos
- Asignación credenciales

**Tasks**
- Diseñar formulario registro
- Validaciones de datos
- Generación automática credenciales
- Notificación al nuevo usuario

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Alta  
**Dependencias:** US002

---

## US007: Activar/desactivar guardias

**User Story**
Como Administrador quiero activar/desactivar cuentas de guardias para controlar acceso al sistema

**Acceptance Criteria**
- Toggle activación
- Bloqueo de acceso
- Notificación al usuario

**Tasks**
- Implementar toggle activación
- Bloqueo de acceso en BD
- Sistema de notificaciones

**Story Points:** 3  
**Estimación:** 12h  
**Prioridad:** Media  
**Dependencias:** US006

---

## US008: Asignar puntos de control

**User Story**
Como Administrador quiero asignar guardias a puntos específicos para organizar la cobertura de seguridad

**Acceptance Criteria**
- Lista puntos control
- Asignación múltiple
- Visualización asignaciones

**Tasks**
- CRUD puntos de control
- Interface asignación múltiple
- Mapa visual de asignaciones
- Validaciones de conflictos

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Alta  
**Dependencias:** US006

---

## US009: Modificar datos guardias

**User Story**
Como Administrador quiero modificar datos de guardias para mantener información actualizada

**Acceptance Criteria**
- Formulario edición
- Validación cambios
- Historial modificaciones

**Tasks**
- Formulario edición guardia
- Validaciones de integridad
- Log de cambios históricos
- Interfaz de historial

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Media  
**Dependencias:** US006

---

## US010: Reportes actividad guardias

**User Story**
Como Administrador quiero generar reportes de actividad para supervisar desempeño del equipo

**Acceptance Criteria**
- Reporte por periodo
- Métricas actividad
- Exportación PDF

**Tasks**
- Query builder para reportes
- Generación de métricas
- Exportación PDF
- Programación automática

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US006

---

## US011: Conexión BD estudiantes

**User Story**
Como Sistema quiero conectar con BD existente para validar datos estudiantiles

**Acceptance Criteria**
- Conexión estable
- Consulta tiempo real
- Manejo errores conexión

**Tasks**
- Configurar connection string
- Implementar pool de conexiones
- Manejo de errores y reconexión
- Pruebas de rendimiento

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Crítica  
**Dependencias:** Acceso BD universidad

---

## US012: Sincronización datos estudiantes

**User Story**
Como Sistema quiero sincronizar automáticamente datos para mantener información actualizada

**Acceptance Criteria**
- Sync programado
- Detección cambios
- Log sincronización

**Tasks**
- Scheduler de sincronización
- Detección de cambios (CDC)
- Log de sincronización
- Manejo de conflictos

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Alta  
**Dependencias:** US011

---

## US013: Consultar estado estudiante

**User Story**
Como Sistema quiero verificar estado activo/inactivo para validar elegibilidad de acceso

**Acceptance Criteria**
- Query estado en tiempo real
- Cache temporal
- Indicador visual

**Tasks**
- API consulta estado
- Implementar caché Redis
- Indicadores visuales UI
- Optimización queries

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Alta  
**Dependencias:** US011

---

## US014: Obtener datos básicos

**User Story**
Como Guardia quiero ver ID, nombre y carrera para identificar al estudiante

**Acceptance Criteria**
- Display datos claros
- Formato consistente
- Carga rápida

**Tasks**
- API datos básicos estudiante
- Componente UI display
- Formateo de datos
- Optimización carga

**Story Points:** 3  
**Estimación:** 12h  
**Prioridad:** Media  
**Dependencias:** US011

---

## US015: Verificar vigencia matrícula

**User Story**
Como Sistema quiero verificar vigencia de matrícula para autorizar solo estudiantes activos

**Acceptance Criteria**
- Consulta vigencia automática
- Indicador visual claro
- Manejo expirados

**Tasks**
- Lógica validación vigencia
- Indicadores visuales estado
- Alertas matrícula expirada
- Configuración períodos académicos

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Alta  
**Dependencias:** US011

---

## US016: Detectar pulseras NFC

**User Story**
Como Sistema quiero detectar pulseras NFC automáticamente para identificar estudiantes en proximidad

**Acceptance Criteria**
- Detección en 10cm
- Lectura automática
- Feedback visual/sonoro

**Tasks**
- Driver NFC reader
- Algoritmo detección 10cm
- Feedback visual/auditivo
- Calibración distancia
- Pruebas hardware

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Crítica  
**Dependencias:** Hardware NFC

---

## US017: Leer ID único pulsera

**User Story**
Como Sistema quiero leer ID único en rango 10cm para identificar cada pulsera específicamente

**Acceptance Criteria**
- Lectura precisa en 10cm
- ID único válido
- Manejo errores lectura

**Tasks**
- Algoritmo lectura precisa
- Validación ID único
- Manejo errores lectura
- Logs de eventos NFC

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Crítica  
**Dependencias:** US016

---

## US018: Asociar ID con estudiante

**User Story**
Como Sistema quiero asociar ID pulsera con estudiante para vincular identidad física con digital

**Acceptance Criteria**
- Mapping ID-estudiante
- Validación asociación
- Manejo no encontrados

**Tasks**
- Tabla mapping pulsera-estudiante
- CRUD asociaciones
- Validaciones integridad
- Manejo casos no encontrados

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Alta  
**Dependencias:** US017, US011

---

## US019: Mostrar detecciones tiempo real

**User Story**
Como Guardia quiero ver dispositivos detectados en tiempo real para monitorear actividad NFC

**Acceptance Criteria**
- Lista tiempo real
- Actualización automática
- Indicadores de estado

**Tasks**
- Interface tiempo real
- WebSocket para updates
- Indicadores estado visual
- Lista detecciones activas

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Media  
**Dependencias:** US016

---

## US020: Múltiples detecciones

**User Story**
Como Sistema quiero manejar múltiples detecciones simultáneas para procesar varios estudiantes a la vez

**Acceptance Criteria**
- Queue detecciones
- Procesamiento secuencial
- Priorización por tiempo

**Tasks**
- Queue procesamiento async
- Algoritmo priorización
- Manejo concurrencia
- Optimización rendimiento
- Stress testing

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Alta  
**Dependencias:** US016

---

## US021: Validar ID pulsera

**User Story**
Como Sistema quiero validar ID contra BD para verificar autenticidad de pulsera

**Acceptance Criteria**
- Query BD pulseras
- Validación existencia
- Manejo IDs inválidos

**Tasks**
- Query validación BD
- Cache pulseras válidas
- Manejo IDs inválidos
- Logs seguridad

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Alta  
**Dependencias:** US018

---

## US022: Verificar estado activo

**User Story**
Como Sistema quiero verificar estado activo del estudiante para autorizar solo estudiantes vigentes

**Acceptance Criteria**
- Check estado en BD
- Validación temporal
- Indicador status

**Tasks**
- Verificación estado activo
- Validación temporal matrícula
- Indicadores status UI

**Story Points:** 3  
**Estimación:** 12h  
**Prioridad:** Alta  
**Dependencias:** US013

---

## US023: Mostrar datos estudiante

**User Story**
Como Guardia quiero ver datos básicos del estudiante para confirmar identidad visualmente

**Acceptance Criteria**
- Display nombre, foto, carrera, ID
- Claramente visible

**Tasks**
- Componente display estudiante
- Carga de foto estudiante
- Formato datos legible
- Responsive design

**Story Points:** 3  
**Estimación:** 12h  
**Prioridad:** Media  
**Dependencias:** US014

---

## US024: Autorización manual

**User Story**
Como Guardia quiero autorizar/denegar manualmente para tener control final sobre acceso

**Acceptance Criteria**
- Botones claros Autorizar/Denegar
- Confirmación visual
- Registro decisión

**Tasks**
- Botones Autorizar/Denegar
- Modal confirmación
- Registro decisión BD
- Feedback visual inmediato

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Crítica  
**Dependencias:** US023

---

## US025: Registrar decisión timestamp

**User Story**
Como Sistema quiero registrar decisión con timestamp para mantener trazabilidad completa

**Acceptance Criteria**
- Timestamp preciso
- ID guardia
- Decisión tomada
- Persistencia BD

**Tasks**
- Modelo entidad evento
- Timestamp UTC preciso
- Persistencia BD
- Índices optimización

**Story Points:** 3  
**Estimación:** 12h  
**Prioridad:** Media  
**Dependencias:** US024

---

## US026: Registrar accesos

**User Story**
Como Sistema quiero registrar accesos entrada/salida para llevar control de movimientos

**Acceptance Criteria**
- Registro tipo acceso
- Timestamp
- Estudiante, guardia, punto control

**Tasks**
- Esquema BD eventos acceso
- Service registro accesos
- Validación datos obligatorios
- Índices rendimiento

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Crítica  
**Dependencias:** US025

---

## US027: Guardar fecha, hora, datos

**User Story**
Como Sistema quiero guardar fecha, hora, estudiante, guardia y decisión para tener registro completo del evento

**Acceptance Criteria**
- Persistencia completa datos
- Integridad referencial
- Backup automático

**Tasks**
- Integridad referencial FK
- Triggers BD auditoría
- Backup automático
- Validación consistencia

**Story Points:** 3  
**Estimación:** 12h  
**Prioridad:** Media  
**Dependencias:** US026

---

## US028: Distinguir entrada/salida

**User Story**
Como Sistema quiero distinguir entrada/salida de campus para saber quién está dentro

**Acceptance Criteria**
- Campo tipo movimiento
- Lógica entrada/salida
- Validación coherencia

**Tasks**
- Enum tipo movimiento
- Lógica entrada/salida
- Validación coherencia temporal
- Cálculo estudiantes en campus

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Alta  
**Dependencias:** US026

---

## US029: Registrar ubicación

**User Story**
Como Sistema quiero registrar ubicación/punto de control para saber por dónde accedió

**Acceptance Criteria**
- ID punto control
- Coordenadas si aplica
- Descripción ubicación

**Tasks**
- Campo punto control en eventos
- Coordenadas GPS opcionales
- Descripción ubicación
- Mapa puntos control

**Story Points:** 3  
**Estimación:** 12h  
**Prioridad:** Media  
**Dependencias:** US008

---

## US030: Historial completo

**User Story**
Como Sistema quiero mantener historial completo de movimientos para análisis y auditorías

**Acceptance Criteria**
- Almacenamiento permanente
- Índices optimizados
- Políticas retención

**Tasks**
- Particionamiento tabla eventos
- Índices optimizados
- Políticas retención datos
- Archivado histórico

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Media  
**Dependencias:** US026

---

## US031: Lista estudiantes hoy

**User Story**
Como Guardia quiero ver lista de estudiantes que ingresaron hoy para monitorear actividad diaria

**Acceptance Criteria**
- Query fecha actual
- Lista ordenada por hora
- Filtros básicos

**Tasks**
- Query estudiantes día actual
- Ordenamiento por hora
- Filtros básicos
- Paginación resultados

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Media  
**Dependencias:** US030

---

## US032: Lista estudiantes en campus

**User Story**
Como Guardia quiero ver estudiantes actualmente en campus para conocer ocupación actual

**Acceptance Criteria**
- Lógica entrada-salida
- Estado actual
- Contador total

**Tasks**
- Algoritmo estudiantes actuales
- Query estado tiempo real
- Contador ocupación
- Actualización automática

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Alta  
**Dependencias:** US028

---

## US033: Buscar estudiante

**User Story**
Como Guardia quiero buscar estudiante por nombre o ID para encontrar información específica

**Acceptance Criteria**
- Search box
- Autocompletado
- Resultados múltiples
- Datos completos

**Tasks**
- Componente search box
- Autocompletado con AJAX
- Búsqueda full-text
- Display resultados múltiples

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Media  
**Dependencias:** US014

---

## US034: Historial accesos recientes

**User Story**
Como Guardia quiero ver historial de accesos recientes para revisar actividad pasada

**Acceptance Criteria**
- Lista cronológica
- Últimas 24h/48h
- Detalles completos

**Tasks**
- Query accesos recientes
- Filtro temporal configurable
- Lista cronológica
- Detalles completos evento

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Baja  
**Dependencias:** US030

---

## US035: Filtrar por carrera y fechas

**User Story**
Como Guardia quiero filtrar por carrera o rango de fechas para análisis específico de datos

**Acceptance Criteria**
- Filtros múltiples
- Date picker
- Dropdown carreras
- Combinaciones

**Tasks**
- Componentes filtro UI
- Date picker rango fechas
- Dropdown carreras
- Combinación múltiples filtros

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US034

---

## US036: Recopilar datos ML

**User Story**
Como Sistema quiero recopilar datos entrada/salida por horarios para alimentar algoritmos ML

**Acceptance Criteria**
- ETL datos históricos
- Estructura para ML
- Limpieza datos

**Tasks**
- ETL pipeline datos
- Estructura dataset ML
- Limpieza y normalización
- Validación calidad datos

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US030

---

## US037: Analizar patrones flujo

**User Story**
Como Sistema quiero analizar patrones de flujo de estudiantes para identificar tendencias

**Acceptance Criteria**
- Algoritmos análisis temporal
- Detección patrones
- Visualización tendencias

**Tasks**
- Algoritmos análisis temporal
- Detección patrones estadísticos
- Visualización tendencias
- Métricas estadísticas
- Validación modelos

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Media  
**Dependencias:** US036

---

## US038: Predecir horarios pico

**User Story**
Como Sistema quiero predecir horarios pico entrada/salida para anticipar congestión

**Acceptance Criteria**
- Modelo predictivo
- Precisión >80%
- Predicción 24h adelante

**Tasks**
- Modelo predictivo ML
- Validación precisión >80%
- Predicción 24h adelante
- Métricas evaluación modelo
- Pipeline entrenamiento

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Alta  
**Dependencias:** US037

---

## US039: Sugerir horarios buses

**User Story**
Como Sistema quiero sugerir horarios óptimos de buses para optimizar transporte universitario

**Acceptance Criteria**
- Algoritmo optimización
- Sugerencias horarios
- Métricas eficiencia

**Tasks**
- Algoritmo optimización horarios
- Sugerencias automáticas
- Métricas eficiencia
- Interface sugerencias
- Validación impacto

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Media  
**Dependencias:** US038

---

## US040: Alertas congestión

**User Story**
Como Administrador quiero recibir alertas de congestión prevista para tomar medidas preventivas

**Acceptance Criteria**
- Sistema alertas automático
- Thresholds configurables
- Notificaciones múltiples

**Tasks**
- Sistema alertas automático
- Configuración thresholds
- Múltiples canales notificación
- Dashboard alertas

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Alta  
**Dependencias:** US038

---

## US041: Regresión lineal

**User Story**
Como Sistema quiero implementar regresión lineal para modelar relaciones lineales en datos

**Acceptance Criteria**
- Algoritmo regresión
- R² > 0.7
- Validación cruzada
- Métricas error

**Tasks**
- Implementar regresión lineal
- Validación cruzada
- Métricas R², RMSE
- Optimización hiperparámetros

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US036

---

## US042: Clustering

**User Story**
Como Sistema quiero implementar clustering para agrupar patrones similares

**Acceptance Criteria**
- K-means o similar
- Número óptimo clusters
- Validación silhouette

**Tasks**
- Algoritmo K-means
- Elbow method clusters óptimos
- Validación silhouette
- Visualización clusters

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Baja  
**Dependencias:** US036

---

## US043: Series temporales

**User Story**
Como Sistema quiero implementar series temporales para modelar evolución temporal

**Acceptance Criteria**
- ARIMA o similar
- Estacionalidad detectada
- Forecast precisión >75%

**Tasks**
- Modelo ARIMA/LSTM
- Detección estacionalidad
- Forecast precisión >75%
- Validación temporal
- Pipeline predicción

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Alta  
**Dependencias:** US036

---

## US044: Entrenar con históricos

**User Story**
Como Sistema quiero entrenar modelo con datos históricos mínimo 3 meses para obtener modelo confiable

**Acceptance Criteria**
- Dataset ≥3 meses
- Train/test split
- Métricas validación

**Tasks**
- Preparación dataset ≥3 meses
- Train/validation/test split
- Entrenamiento modelos
- Métricas validación

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Alta  
**Dependencias:** US041, US042, US043

---

## US045: Actualización semanal modelo

**User Story**
Como Sistema quiero actualizar modelo semanalmente para mantener precisión con datos recientes

**Acceptance Criteria**
- Job automático semanal
- Reentrenamiento incremental
- Validación performance

**Tasks**
- Job scheduler semanal
- Reentrenamiento incremental
- Validación performance
- Deploy automático modelo

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US044

---

## US046: Dashboard general accesos

**User Story**
Como Administrador quiero visualizar dashboard general de accesos para monitorear sistema en tiempo real

**Acceptance Criteria**
- Métricas tiempo real
- Gráficos interactivos
- Responsive design

**Tasks**
- Dashboard responsive
- Métricas tiempo real
- Gráficos interactivos Chart.js
- WebSocket updates
- Filtros temporales

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Crítica  
**Dependencias:** US030

---

## US047: Gráficos flujo horarios

**User Story**
Como Administrador quiero ver gráficos de flujo por horarios y días para identificar patrones visualmente

**Acceptance Criteria**
- Charts interactivos
- Filtros temporales
- Drill-down por día/hora

**Tasks**
- Charts flujo horarios
- Filtros temporales
- Drill-down interactivo
- Exportación gráficos

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US046

---

## US048: Predicciones modelo ML

**User Story**
Como Administrador quiero visualizar predicciones del modelo ML para planificar basado en predicciones

**Acceptance Criteria**
- Gráficos predicción vs real
- Intervalos confianza
- Actualización automática

**Tasks**
- Gráficos predicción vs real
- Intervalos confianza
- Actualización automática
- Métricas precisión visual

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Alta  
**Dependencias:** US044, US046

---

## US049: Reportes eficiencia buses

**User Story**
Como Administrador quiero ver reportes de eficiencia de buses para evaluar impacto de optimizaciones

**Acceptance Criteria**
- Métricas utilización
- Comparativo antes/después
- ROI calculado

**Tasks**
- Métricas utilización buses
- Comparativo antes/después
- Cálculo ROI
- Reportes visuales

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US039, US046

---

## US050: Exportar reportes PDF/Excel

**User Story**
Como Administrador quiero exportar reportes en PDF/Excel para compartir con otros departamentos

**Acceptance Criteria**
- Exportación PDF con gráficos
- Excel con datos raw
- Formato profesional

**Tasks**
- Exportación PDF reportes
- Exportación Excel datos
- Formato profesional
- Templates personalizables

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Baja  
**Dependencias:** US046

---

## US051: Estudiantes más activos

**User Story**
Como Administrador quiero ver reporte de estudiantes más activos para identificar usuarios frecuentes

**Acceptance Criteria**
- Ranking por accesos
- Período configurable
- Datos estadísticos

**Tasks**
- Query ranking accesos
- Filtros período configurable
- Estadísticas descriptivas
- Visualización ranking

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Baja  
**Dependencias:** US046

---

## US052: Horarios pico ML

**User Story**
Como Administrador quiero ver reporte de horarios pico por ML para validar predicciones del modelo

**Acceptance Criteria**
- Comparación ML vs real
- Precisión por horario
- Ajustes sugeridos

**Tasks**
- Comparación predicción vs real
- Métricas precisión horario
- Sugerencias ajustes modelo
- Gráficos validación

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US048

---

## US053: Precisión modelo ML

**User Story**
Como Administrador quiero ver reporte de precisión del modelo ML para monitorear calidad predicciones

**Acceptance Criteria**
- Métricas precisión, recall, F1-score
- Evolución temporal

**Tasks**
- Métricas precisión, recall, F1
- Evolución temporal métricas
- Dashboard calidad modelo
- Alertas degradación

**Story Points:** 5  
**Estimación:** 20h  
**Prioridad:** Media  
**Dependencias:** US044

---

## US054: Uso buses sugerido vs real

**User Story**
Como Administrador quiero ver reporte uso buses sugerido vs real para evaluar adopción de sugerencias

**Acceptance Criteria**
- Comparativo horarios sugeridos vs implementados
- Impacto medido

**Tasks**
- Tracking sugerencias implementadas
- Comparativo sugerido vs real
- Métricas adopción
- Análisis impacto eficiencia

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US049

---

## US055: Comparativo antes/después

**User Story**
Como Administrador quiero ver reporte comparativo antes/después implementación para demostrar ROI del proyecto

**Acceptance Criteria**
- Métricas pre/post sistema
- KPIs impacto
- Análisis costo-beneficio

**Tasks**
- Métricas baseline pre-sistema
- KPIs post-implementación
- Análisis costo-beneficio
- Dashboard ROI ejecutivo

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Alta  
**Dependencias:** US046

---

## US056: Sincronización app-servidor

**User Story**
Como Sistema quiero sincronizar app móvil con servidor central para mantener datos consistentes

**Acceptance Criteria**
- Sync bidireccional
- Manejo conflictos
- Versionado datos

**Tasks**
- API REST sincronización
- Manejo conflictos datos
- Versionado datos
- Queue sincronización
- Logs de sincronización

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Crítica  
**Dependencias:** API REST completa

---

## US057: Funcionalidad offline

**User Story**
Como Guardia quiero usar app offline con sincronización posterior para trabajar sin conexión internet

**Acceptance Criteria**
- Cache local
- Queue eventos offline
- Sync automático al reconectar

**Tasks**
- Storage local SQLite
- Queue eventos offline
- Detección conexión
- Sync automático reconexión
- Resolución conflictos

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Alta  
**Dependencias:** US056

---

## US058: Web y app mismo servidor

**User Story**
Como Sistema quiero que web y app consuman mismo servidor para mantener consistencia datos

**Acceptance Criteria**
- API unificada
- Misma BD
- Endpoints compatibles

**Tasks**
- API unificada web/app
- Endpoints compatibles
- Autenticación unificada
- Documentación API

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Media  
**Dependencias:** US056

---

## US059: Múltiples guardias simultáneos

**User Story**
Como Sistema quiero soportar múltiples guardias simultáneos para escalabilidad operacional

**Acceptance Criteria**
- Concurrencia manejada
- Locks optimistas
- Resolución conflictos

**Tasks**
- Manejo concurrencia BD
- Locks optimistas
- Resolución conflictos
- Testing concurrencia

**Story Points:** 8  
**Estimación:** 32h  
**Prioridad:** Alta  
**Dependencias:** US056

---

## US060: Actualizaciones tiempo real

**User Story**
Como Usuario quiero recibir actualizaciones tiempo real entre app y web para información siempre actualizada

**Acceptance Criteria**
- WebSockets o polling
- Notificaciones push
- Latencia <2s

**Tasks**
- WebSockets servidor
- SignalR implementación
- Notificaciones push
- Optimización latencia <2s
- Fallback polling

**Story Points:** 13  
**Estimación:** 52h  
**Prioridad:** Alta  
**Dependencies:** US058