# Plan de Pruebas - Sistema de Control de Acceso

## Documento de Plan de Pruebas

**Versión:** 1.0.0  
**Fecha:** Enero 2025  
**Estado:** ✅ Implementado

---

## 1. Introducción

### 1.1 Propósito

Este documento describe el plan de pruebas para el Sistema de Control de Acceso con Pulseras Inteligentes. El plan define las estrategias, casos de prueba y criterios de aceptación para garantizar la calidad del sistema.

### 1.2 Alcance

El plan cubre:
- Tests unitarios de servicios backend
- Tests de integración de API
- Tests de validación de datos
- Tests de funcionalidades críticas
- Tests de rendimiento (futuro)
- Tests de seguridad (futuro)

### 1.3 Objetivos

- Garantizar 60%+ de cobertura de código
- Validar funcionalidades críticas
- Detectar bugs temprano en el desarrollo
- Asegurar calidad antes de producción

---

## 2. Estrategia de Pruebas

### 2.1 Niveles de Prueba

#### Nivel 1: Tests Unitarios
- **Objetivo:** Validar componentes individuales
- **Cobertura:** 60%+ mínimo
- **Herramienta:** Jest
- **Ejecución:** En cada commit

#### Nivel 2: Tests de Integración
- **Objetivo:** Validar interacción entre componentes
- **Cobertura:** Flujos críticos
- **Herramienta:** Jest + Supertest
- **Ejecución:** En cada PR

#### Nivel 3: Tests de Sistema
- **Objetivo:** Validar sistema completo
- **Cobertura:** Casos de uso principales
- **Herramienta:** Manual + Automatizado
- **Ejecución:** Antes de release

### 2.2 Tipos de Prueba

- **Funcionales:** Validar funcionalidades
- **No Funcionales:** Rendimiento, seguridad, usabilidad
- **Regresión:** Validar que cambios no rompan funcionalidades existentes
- **Aceptación:** Validar criterios de aceptación de User Stories

---

## 3. Casos de Prueba

### 3.1 Módulo: Autenticación

#### CP-001: Login Exitoso
**Prioridad:** Crítica  
**Precondiciones:** Usuario existe y está activo

**Pasos:**
1. Enviar POST /login con credenciales válidas
2. Verificar respuesta 200 OK
3. Verificar datos de usuario en respuesta
4. Verificar que no se incluya contraseña

**Resultado Esperado:**
- Status 200
- Datos de usuario correctos
- Sin contraseña en respuesta

**Estado:** ✅ Implementado

---

#### CP-002: Login con Credenciales Inválidas
**Prioridad:** Alta  
**Precondiciones:** Usuario existe

**Pasos:**
1. Enviar POST /login con contraseña incorrecta
2. Verificar respuesta 401 Unauthorized
3. Verificar mensaje de error

**Resultado Esperado:**
- Status 401
- Mensaje: "Credenciales incorrectas"

**Estado:** ✅ Implementado

---

#### CP-003: Login con Usuario Inactivo
**Prioridad:** Media  
**Precondiciones:** Usuario existe pero está inactivo

**Pasos:**
1. Enviar POST /login con usuario inactivo
2. Verificar respuesta 401 Unauthorized

**Resultado Esperado:**
- Status 401
- Usuario inactivo no puede autenticarse

**Estado:** ✅ Implementado

---

### 3.2 Módulo: Control de Accesos

#### CP-004: Registrar Acceso Entrada
**Prioridad:** Crítica  
**Precondiciones:** Estudiante válido, guardia autenticado

**Pasos:**
1. Escanear pulsera NFC
2. Validar estudiante en BD
3. Registrar acceso tipo "entrada"
4. Actualizar presencia en campus

**Resultado Esperado:**
- Acceso registrado con timestamp
- Presencia actualizada
- Tipo correcto (entrada)

**Estado:** ✅ Implementado

---

#### CP-005: Registrar Acceso Salida
**Prioridad:** Crítica  
**Precondiciones:** Estudiante está en campus

**Pasos:**
1. Escanear pulsera NFC
2. Validar que estudiante está dentro
3. Registrar acceso tipo "salida"
4. Actualizar presencia (esta_dentro = false)

**Resultado Esperado:**
- Acceso registrado como salida
- Presencia actualizada correctamente
- Tiempo en campus calculado

**Estado:** ✅ Implementado

---

#### CP-006: Validar Movimiento (Entrada después de Salida)
**Prioridad:** Alta  
**Precondiciones:** Último acceso fue salida

**Pasos:**
1. Consultar último acceso (tipo: salida)
2. Intentar registrar entrada
3. Validar que movimiento es válido

**Resultado Esperado:**
- Movimiento válido
- Acceso registrado correctamente

**Estado:** ✅ Implementado

---

#### CP-007: Validar Movimiento Inválido (Entrada después de Entrada)
**Prioridad:** Alta  
**Precondiciones:** Último acceso fue entrada

**Pasos:**
1. Consultar último acceso (tipo: entrada)
2. Intentar registrar otra entrada
3. Validar que movimiento es inválido

**Resultado Esperado:**
- Movimiento inválido detectado
- Error o advertencia mostrada

**Estado:** ✅ Implementado

---

### 3.3 Módulo: Gestión de Estudiantes

#### CP-008: Buscar Estudiante por Código
**Prioridad:** Crítica  
**Precondiciones:** Estudiante existe en BD

**Pasos:**
1. Enviar GET /alumnos/:codigo
2. Verificar respuesta 200 OK
3. Verificar datos del estudiante

**Resultado Esperado:**
- Status 200
- Datos completos del estudiante
- Código universitario correcto

**Estado:** ✅ Implementado

---

#### CP-009: Buscar Estudiante No Existente
**Prioridad:** Media  
**Precondiciones:** Código no existe

**Pasos:**
1. Enviar GET /alumnos/codigo-inexistente
2. Verificar respuesta 404 Not Found

**Resultado Esperado:**
- Status 404
- Mensaje: "Alumno no encontrado"

**Estado:** ✅ Implementado

---

#### CP-010: Validar Estudiante No Matriculado
**Prioridad:** Alta  
**Precondiciones:** Estudiante existe pero estado = false

**Pasos:**
1. Buscar estudiante con estado inactivo
2. Verificar respuesta 403 Forbidden
3. Verificar mensaje de error

**Resultado Esperado:**
- Status 403
- Mensaje: "Alumno no matriculado o inactivo"

**Estado:** ✅ Implementado

---

### 3.4 Módulo: Sincronización Offline

#### CP-011: Almacenar Operación Offline
**Prioridad:** Alta  
**Precondiciones:** App sin conexión

**Pasos:**
1. Registrar acceso sin conexión
2. Verificar que se guarda en SQLite local
3. Verificar que se agrega a cola de sincronización

**Resultado Esperado:**
- Datos guardados localmente
- Operación en cola de sync
- Sin errores

**Estado:** ✅ Implementado

---

#### CP-012: Sincronizar Operaciones Offline
**Prioridad:** Alta  
**Precondiciones:** Operaciones pendientes en cola

**Pasos:**
1. Recuperar conexión a internet
2. Procesar cola de sincronización
3. Verificar que operaciones se envían al servidor
4. Verificar que se eliminan de la cola

**Resultado Esperado:**
- Operaciones sincronizadas
- Cola vacía
- Datos actualizados en servidor

**Estado:** ✅ Implementado

---

#### CP-013: Resolver Conflictos de Sincronización
**Prioridad:** Media  
**Precondiciones:** Conflicto entre datos local y servidor

**Pasos:**
1. Detectar conflicto en sincronización
2. Aplicar estrategia de resolución (last-write-wins)
3. Actualizar datos locales
4. Verificar consistencia

**Resultado Esperado:**
- Conflicto resuelto
- Datos consistentes
- Sin pérdida de información crítica

**Estado:** ✅ Implementado

---

### 3.5 Módulo: Backup y Auditoría

#### CP-014: Crear Backup Manual
**Prioridad:** Alta  
**Precondiciones:** Sistema funcionando

**Pasos:**
1. Enviar POST /api/backup/create
2. Verificar creación de backup
3. Verificar que backup es válido
4. Verificar ubicación del backup

**Resultado Esperado:**
- Backup creado exitosamente
- Archivo válido y accesible
- Timestamp correcto

**Estado:** ✅ Implementado

---

#### CP-015: Restaurar Backup
**Prioridad:** Alta  
**Precondiciones:** Backup válido existe

**Pasos:**
1. Listar backups disponibles
2. Seleccionar backup a restaurar
3. Enviar POST /api/backup/restore/:id
4. Verificar restauración exitosa

**Resultado Esperado:**
- Backup restaurado
- Datos correctos en BD
- Sistema funcionando normalmente

**Estado:** ✅ Implementado

---

#### CP-016: Registrar Evento de Auditoría
**Prioridad:** Alta  
**Precondiciones:** Operación CRUD realizada

**Pasos:**
1. Realizar operación (create, update, delete)
2. Verificar que se registra en auditoría
3. Verificar datos del evento
4. Verificar timestamp y usuario

**Resultado Esperado:**
- Evento registrado
- Datos completos
- Timestamp correcto

**Estado:** ✅ Implementado

---

### 3.6 Módulo: Machine Learning

#### CP-017: Recolectar Dataset para ML
**Prioridad:** Media  
**Precondiciones:** Datos históricos disponibles

**Pasos:**
1. Enviar POST /ml/dataset/collect
2. Verificar recolección de datos
3. Verificar estructura del dataset
4. Verificar estadísticas

**Resultado Esperado:**
- Dataset recolectado
- Estructura válida
- Estadísticas correctas

**Estado:** ✅ Implementado

---

#### CP-018: Entrenar Modelo de Regresión
**Prioridad:** Media  
**Precondiciones:** Dataset válido disponible

**Pasos:**
1. Enviar POST /ml/regression/train
2. Verificar entrenamiento exitoso
3. Verificar métricas del modelo
4. Verificar que modelo se guarda

**Resultado Esperado:**
- Modelo entrenado
- Métricas dentro de rangos aceptables
- Modelo guardado correctamente

**Estado:** ✅ Implementado

---

#### CP-019: Realizar Predicción
**Prioridad:** Media  
**Precondiciones:** Modelo entrenado disponible

**Pasos:**
1. Enviar POST /ml/models/predict con features
2. Verificar predicción
3. Verificar nivel de confianza
4. Verificar formato de respuesta

**Resultado Esperado:**
- Predicción generada
- Confianza > umbral mínimo
- Formato correcto

**Estado:** ✅ Implementado

---

## 4. Criterios de Aceptación

### 4.1 Criterios Generales

- ✅ Todos los tests unitarios pasan
- ✅ Cobertura de código ≥ 60%
- ✅ No hay errores críticos
- ✅ Performance dentro de límites aceptables

### 4.2 Criterios por Módulo

#### Autenticación
- ✅ Login funciona correctamente
- ✅ Contraseñas hasheadas con BCrypt
- ✅ Usuarios inactivos no pueden autenticarse
- ✅ Manejo correcto de errores

#### Control de Accesos
- ✅ Registro correcto de entrada/salida
- ✅ Validación de movimientos válidos
- ✅ Actualización correcta de presencia
- ✅ Timestamps precisos

#### Sincronización
- ✅ Funcionalidad offline operativa
- ✅ Sincronización automática funciona
- ✅ Conflictos resueltos correctamente
- ✅ Sin pérdida de datos

---

## 5. Entorno de Pruebas

### 5.1 Configuración

- **Base de Datos:** MongoDB Atlas (test) o MongoDB Memory Server
- **Node.js:** 18.x LTS
- **Variables de Entorno:** `.env.test`

### 5.2 Datos de Prueba

- Usuarios de prueba (admin, guardia)
- Estudiantes de prueba
- Datos históricos de prueba
- Backups de prueba

---

## 6. Ejecución de Pruebas

### 6.1 Automatizadas

```bash
# Todos los tests
npm test

# Tests específicos
npm test -- backup_service.test.js

# Con cobertura
npm test -- --coverage
```

### 6.2 Manuales

- Pruebas de UI/UX
- Pruebas de integración end-to-end
- Pruebas de rendimiento
- Pruebas de seguridad

---

## 7. Reportes

### 7.1 Reportes Automáticos

- Cobertura de código (HTML, JSON)
- Resultados de tests (Jest)
- Métricas de calidad

### 7.2 Métricas

- Tasa de éxito de tests
- Cobertura por módulo
- Tiempo de ejecución
- Bugs encontrados y corregidos

---

## 8. Mantenimiento

### 8.1 Actualización del Plan

- Revisar y actualizar casos de prueba mensualmente
- Agregar casos para nuevas funcionalidades
- Actualizar criterios de aceptación según cambios

### 8.2 Mejoras Continuas

- Aumentar cobertura gradualmente
- Agregar más tests de integración
- Implementar tests de rendimiento
- Agregar tests de seguridad

---

**Última Actualización:** Enero 2025  
**Versión:** 1.0.0

