![C:\\Users\\EPIS\\Documents\\upt.png][image1]

**UNIVERSIDAD PRIVADA DE TACNA**

**FACULTAD DE INGENIERÍA**

**Escuela Profesional de Ingeniería de Sistemas**

 **Proyecto *“*Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas”**

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

# 

# 

# 

# 

# 

# 

# 

# 

# 

# 

# 

# **Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas**

# **Documento de Arquitectura de Software**

# 

# **Versión 1.0**

Índice General

1. [Introducción](#1-introducción)  
   - 1.1 Propósito  
   - 1.2 Alcance  
   - 1.3 Definición, siglas y abreviaturas  
   - 1.4 Referencias  
   - 1.5 Visión General  
2. [Representación Arquitectónica](#2-representación-arquitectónica)  
   - 2.1 Escenarios  
   - 2.2 Vista Lógica  
   - 2.3 Vista del Proceso  
   - 2.4 Vista del desarrollo  
   - 2.5 Vista Física  
3. [Objetivos y limitaciones arquitectónicas](#3-objetivos-y-limitaciones-arquitectónicas)  
   - 3.1 Disponibilidad  
   - 3.2 Seguridad  
   - 3.3 Adaptabilidad  
   - 3.4 Rendimiento  
4. [Análisis de Requerimientos](#4-análisis-de-requerimientos)  
   - 4.1 Requerimientos funcionales  
   - 4.2 Requerimientos no funcionales  
5. [Vistas de Caso de Uso](#5-vistas-de-caso-de-uso)  
6. [Vista Lógica](#6-vista-lógica)  
   - 6.1 Diagrama Contextual  
7. [Vista de Procesos](#7-vista-de-procesos)  
   - 7.1 Diagrama de Proceso Actual  
   - 7.2 Diagrama de Proceso Propuesto  
8. [Vista de Despliegue](#8-vista-de-despliegue)  
   - 8.1 Diagrama de Contenedor  
9. [Vista de Implementación](#9-vista-de-implementación)  
   - 9.1 Diagrama de Componentes  
10. [Vista de Datos](#10-vista-de-datos)  
    - 10.1 Diagrama Entidad Relación  
11. [Calidad](#11-calidad)  
    - 11.1 Escenario de Seguridad  
    - 11.2 Escenario de Usabilidad  
    - 11.3 Escenario de Adaptabilidad  
    - 11.4 Escenario de Disponibilidad  
    - 11.5 Otro Escenario

**1\. Introducción**

**1.1 Propósito**  
Este documento presenta la arquitectura de software del Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas. El propósito es proporcionar una visión integral y comprensiva de la arquitectura del sistema, utilizando el modelo de vistas 4+1 de Philippe Kruchten para representar distintos aspectos arquitectónicos del sistema.

El documento define la estructura, componentes, interfaces, patrones de diseño y decisiones arquitectónicas que guiarán el desarrollo e implementación del sistema. Describe cómo el sistema cumplirá con los requerimientos funcionales y no funcionales especificados, garantizando atributos de calidad como seguridad, rendimiento, disponibilidad y escalabilidad.

Este documento está dirigido a:

Audiencia:

- Arquitectos de software \- Para comprender y validar las decisiones arquitectónicas  
- Desarrolladores del sistema \- Como guía técnica para la implementación  
- Testers y QA \- Para diseñar pruebas basadas en la arquitectura  
- Gerentes de proyecto \- Para planificación y seguimiento del desarrollo  
- Stakeholders técnicos \- Departamento de TI, administradores de sistemas  
- Equipo de infraestructura \- Para preparar el ambiente de despliegue

**1.2 Alcance**  
Este documento de arquitectura cubre el Sistema de Control de Acceso con Pulseras Inteligentes, que moderniza el control de acceso en instituciones educativas mediante tecnología Bluetooth Low Energy (BLE) y análisis predictivo con machine learning.

Componentes incluidos:

- Aplicación Móvil Flutter \- App multiplataforma (Android/iOS) para guardias de seguridad  
- API REST Node.js \- Backend central con lógica de negocio y orquestación  
- Base de Datos MongoDB Atlas \- Almacenamiento NoSQL en la nube  
- Dashboard Web \- Interfaz de administración y reportes  
- Módulo de Machine Learning (Python) \- Análisis predictivo y recomendaciones  
- Sistema de Pulseras Inteligentes BLE \- Hardware de identificación estudiantil  
- Sistema de Sincronización \- Mecanismos online/offline  
- Sistema de Autenticación y Seguridad \- JWT, encriptación, auditoría

Límites del sistema:

- Excluido: Fabricación de hardware de pulseras inteligentes (se adquiere de terceros)  
- Excluido: Modificación de infraestructura física de edificios  
- Excluido: Integración con sistemas de pago o biblioteca  
- Excluido: Aplicación móvil para estudiantes (fase futura)  
- Excluido: Sistema de reconocimiento facial o biométrico  
- Excluido: Control de acceso vehicular

Integraciones:

- Sistema Académico Institucional \- Base de datos de estudiantes (lectura)  
- Pulseras Inteligentes BLE \- Comunicación bidireccional vía Bluetooth  
- Servicios Cloud MongoDB Atlas \- Base de datos como servicio  
- Servicios de Email \- Notificaciones y recuperación de contraseñas  
- Sistema de GPS \- Geolocalización de puntos de acceso

**1.3 Definición, siglas y abreviaturas**

| Término/Sigla | Definición |
| ----- | ----- |
| API | Application Programming Interface \- Interfaz de Programación de Aplicaciones |
| BLE | Bluetooth Low Energy \- Tecnología de comunicación inalámbrica de bajo consumo |
| REST | Representational State Transfer \- Arquitectura para servicios web |
| JWT | JSON Web Token \- Token de acceso seguro basado en JSON |
| ML | Machine Learning \- Aprendizaje automático |
| NoSQL | Not Only SQL \- Base de datos no relacional (MongoDB) |
| HTTPS/TLS | Hypertext Transfer Protocol Secure / Transport Layer Security |
| MQTT | Message Queuing Telemetry Transport \- Protocolo de mensajería IoT |
| WebSocket | Protocolo de comunicación bidireccional en tiempo real |
| GPS | Global Positioning System \- Sistema de Posicionamiento Global |
| GDPR | General Data Protection Regulation \- Reglamento General de Protección de Datos |
| RBAC | Role-Based Access Control \- Control de Acceso Basado en Roles |
| CDN | Content Delivery Network \- Red de Entrega de Contenido |
| SPA | Single Page Application \- Aplicación de Página Única |
| PWA | Progressive Web Application \- Aplicación Web Progresiva |
| CI/CD | Continuous Integration/Continuous Deployment |
| IoT | Internet of Things \- Internet de las Cosas |
| TPS | Transactions Per Second \- Transacciones por segundo |
| CRUD | Create, Read, Update, Delete \- Operaciones básicas de datos |
| DTO | Data Transfer Object \- Objeto de Transferencia de Datos |

**1.4 Referencias**  
Documentos del proyecto:

- Documento de Visión del Proyecto v1.0  
- Especificación de Requerimientos de Software (SRS) v1.0  
- Documento de Factibilidad v1.0  
- Cuadro de Requerimientos de Software

Estándares y guías:

- IEEE 1471-2000: Recommended Practice for Architectural Description  
- ISO/IEC 25010: Software Quality Model  
- ISO/IEC 27001:2013: Information Security Management Systems  
- OWASP Top 10: Web Application Security Risks  
- Ley N° 29733: Ley de Protección de Datos Personales del Perú  
- GDPR: Reglamento General de Protección de Datos

Documentación técnica:

- Flutter Framework \- [https://flutter.dev/docs](https://flutter.dev/docs)  
- Node.js Documentation \- [https://nodejs.org/docs](https://nodejs.org/docs)  
- MongoDB Atlas Documentation \- [https://docs.atlas.mongodb.com](https://docs.atlas.mongodb.com)  
- TensorFlow Documentation \- [https://www.tensorflow.org/api\_docs](https://www.tensorflow.org/api_docs)  
- Bluetooth Low Energy Specifications \- [https://www.bluetooth.com/specifications](https://www.bluetooth.com/specifications)  
- Material Design Guidelines \- [https://material.io/design](https://material.io/design)  
- Human Interface Guidelines (iOS) \- [https://developer.apple.com/design](https://developer.apple.com/design)

Referencias web:

- Martin Fowler \- Software Architecture Guide: [https://martinfowler.com/architecture](https://martinfowler.com/architecture)  
- C4 Model for Software Architecture: [https://c4model.com](https://c4model.com)  
- Microservices Patterns: [https://microservices.io/patterns](https://microservices.io/patterns)

**1.5 Visión General**

Organización del documento:

Este documento está organizado de la siguiente manera:

- Sección 1 \- Introducción: Proporciona información general sobre el documento  
- Sección 2 \- Representación Arquitectónica: Describe el modelo arquitectónico utilizado  
- Sección 3 \- Objetivos y Limitaciones: Define los objetivos de calidad y restricciones  
- Sección 4 \- Análisis de Requerimientos: Resume los requerimientos funcionales y no funcionales  
- Sección 5 \- Vistas de Caso de Uso: Presenta los casos de uso principales del sistema  
- Sección 6 \- Vista Lógica: Muestra la organización lógica del sistema  
- Sección 7 \- Vista de Procesos: Describe los procesos y flujos del sistema  
- Sección 8 \- Vista de Despliegue: Ilustra la infraestructura física del sistema  
- Sección 9 \- Vista de Implementación: Detalla la organización del código y componentes  
- Sección 10 \- Vista de Datos: Presenta el modelo de datos del sistema  
- Sección 11 \- Calidad: Define escenarios de calidad y atributos de calidad

**2\. Representación Arquitectónica**  
Este documento utiliza el Modelo de Vistas 4+1 de Philippe Kruchten para representar la arquitectura del sistema. Este modelo organiza la descripción de la arquitectura de software en cinco vistas concurrentes:  
Modelo de Vistas 4+1  
![][image2]

```

```

**2.1 Escenarios (Vista de Casos de Uso)**

Propósito: La vista de casos de uso describe la funcionalidad del sistema desde la perspectiva de los actores externos. Esta vista guía el desarrollo de las otras vistas arquitectónicas.

Contenido:

- Diagramas de casos de uso  
- Especificaciones de casos de uso  
- Escenarios de interacción usuario-sistema

Stakeholders principales:

- Usuarios finales  
- Clientes  
- Testers

**2.2 Vista Lógica**  
{Descripción de la vista lógica}

Propósito: La vista lógica describe la organización conceptual del sistema en términos de capas, paquetes, clases y sus relaciones.

Contenido:

- Diagrama de paquetes  
- Diagrama de clases principales  
- Diagrama contextual  
- Patrones de diseño aplicados

Stakeholders principales:

- Desarrolladores  
- Arquitectos de software

Notación: UML (Unified Modeling Language)

**2.3 Vista del Proceso**  
{Descripción de la vista de procesos}

Propósito: La vista de procesos describe los procesos concurrentes del sistema, sus interacciones, sincronización y comunicación.

Contenido:

- Diagramas de actividad  
- Diagramas de secuencia  
- Diagramas de estado  
- Flujos de proceso

Aspectos cubiertos:

- Concurrencia  
- Sincronización  
- Comunicación entre procesos  
- Performance  
- Escalabilidad

Stakeholders principales:

- Arquitectos de software  
- Ingenieros de performance

**2.4 Vista del Desarrollo**  
{Descripción de la vista de desarrollo}

Propósito: La vista de desarrollo describe la organización estática del software en su ambiente de desarrollo.

Contenido:

- Diagrama de componentes  
- Organización de módulos  
- Estructura de directorios  
- Bibliotecas y frameworks utilizados

Aspectos cubiertos:

- Organización del código  
- Gestión de configuración  
- Reutilización de componentes  
- Modularidad

Stakeholders principales:

- Desarrolladores  
- Gestores de configuración

**2.5 Vista Física (Vista de Despliegue)**  
{Descripción de la vista física}

Propósito: La vista física describe el mapeo del software sobre el hardware y refleja los aspectos de distribución del sistema.

Contenido:

- Diagrama de despliegue  
- Diagrama de contenedores  
- Topología de red  
- Infraestructura física

Aspectos cubiertos:

- Distribución física  
- Rendimiento  
- Escalabilidad  
- Disponibilidad  
- Tolerancia a fallos

Stakeholders principales:

- Ingenieros de sistemas  
- Administradores de sistemas  
- Arquitectos de infraestructura

**3\. Objetivos y Limitaciones Arquitectónicas**  
Esta sección identifica los requerimientos y objetivos que tienen un impacto significativo en la arquitectura del sistema.

**3.1 Disponibilidad**  
Objetivo: El sistema debe estar disponible 99.5% del tiempo durante el horario académico (6:00 AM \- 10:00 PM), garantizando que el control de acceso funcione continuamente sin interrupciones que afecten la operación normal de la institución.

Requisitos:

- RNF-018: Disponibilidad del sistema mínima de 99.5% uptime (máximo 3.65 horas de downtime mensual)  
- RNF-019: Tiempo de recuperación ante fallos \< 5 minutos  
- RNF-020: Backup diario automático a las 3:00 AM  
- Funcionalidad offline: La aplicación móvil debe funcionar sin conexión y sincronizar posteriormente  
- Mantenimiento programado debe realizarse entre 2:00 AM y 5:00 AM  
- Redundancia de componentes críticos (API, Base de Datos)

Estrategias arquitectónicas:

- Modo Offline: Base de datos local SQLite en aplicación móvil para funcionamiento sin conexión  
- MongoDB Atlas Replication: Configuración de réplica set con 3 nodos para alta disponibilidad  
- Health Checks: Monitoreo automático cada 30 segundos con alertas por Slack/Email  
- Respaldo Automático: Respaldos incrementales diarios y completos semanales  
- Failover Automático: Cambio automático a nodos de respaldo en caso de fallo  
- Queue System: Cola de sincronización para procesar operaciones offline cuando se recupere conexión

Limitaciones:

- Dependencia de disponibilidad de MongoDB Atlas (99.99% SLA)  
- Conectividad de red Wi-Fi institucional variable  
- Capacidad de almacenamiento local limitada en dispositivos móviles

**3.2 Seguridad**  
Objetivo: Garantizar la confidencialidad, integridad y disponibilidad de los datos personales de estudiantes y guardias, cumpliendo con la Ley N° 29733 de Protección de Datos Personales del Perú y GDPR, mediante implementación de múltiples capas de seguridad.

Requisitos:

- RNF-007: Encriptación de datos en tránsito con TLS 1.3 y en reposo con AES-256  
- RNF-008: Autenticación segura mediante JWT con tiempo de expiración configurable  
- RNF-009: Contraseñas con hash BCrypt y salt, mínimo 8 caracteres  
- RNF-010: Protección contra ataques OWASP Top 10 (SQL Injection, XSS, CSRF)  
- RNF-011: Cumplimiento con Ley N° 29733 y GDPR  
- RNF-012: Auditoría completa de accesos con logs inmutables  
- Control de acceso basado en roles (RBAC) \- Guardia vs Administrador  
- Validación y sanitización de todos los inputs  
- Rate limiting: máximo 100 requests por minuto por IP

Estrategias arquitectónicas:

- JWT Authentication: Tokens con firma HMAC-SHA256, expiración 8 horas  
- HTTPS/TLS 1.3: Certificados SSL para todas las comunicaciones  
- BCrypt Hashing: Factor de costo 12 para hashing de contraseñas  
- RBAC Implementation: Middleware de validación de permisos en cada endpoint  
- Input Validation: Joi/Validator.js para validación de esquemas  
- SQL Injection Prevention: Uso de queries parametrizadas y ORM (Mongoose)  
- XSS Protection: Content Security Policy (CSP) headers  
- CSRF Tokens: Tokens anti-falsificación en formularios  
- Audit Logs: Registro inmutable en colección separada con timestamp e IP  
- Secrets Management: Variables de entorno y AWS Secrets Manager  
- API Rate Limiting: Express-rate-limit con Redis para estado compartido

Limitaciones:

- Bluetooth BLE no encriptado por defecto (mitigado con validación en servidor)  
- Seguridad física de las pulseras depende del usuario  
- Dispositivos móviles de guardias pueden ser comprometidos (mitigado con timeout de sesión)

**3.3 Adaptabilidad**  
Objetivo: Diseñar un sistema modular y flexible que permita agregar nuevas funcionalidades, modificar existentes y adaptarse a cambios de requerimientos con mínimo impacto en componentes ya desplegados.

Requisitos:

- RNF-024: Arquitectura modular con separación clara de responsabilidades  
- Facilidad para agregar nuevos puntos de acceso sin modificar código  
- Capacidad de intercambiar algoritmos de ML sin afectar otros módulos  
- Configuración externalizada y centralizada  
- Menos del 10% del código debe modificarse para agregar nueva funcionalidad

Estrategias arquitectónicas:

- Arquitectura en Capas: Separación entre Presentación, Lógica de Negocio, Acceso a Datos  
- Principios SOLID: Especialmente Open/Closed y Dependency Inversion  
- Patrón Repository: Abstracción del acceso a datos permite cambiar BD  
- Patrón Strategy: Para algoritmos de ML intercambiables  
- Patrón Adapter: Para integración con sistemas externos  
- Dependency Injection: Inversión de control para bajo acoplamiento  
- API Versioning: /api/v1/, /api/v2/ para compatibilidad hacia atrás  
- Feature Toggles: Activar/desactivar funcionalidades sin redeploy  
- Configuración Externa: Variables de entorno y archivos de configuración

Limitaciones:

- Flutter requiere recompilación para cambios en la app móvil  
- Esquema de MongoDB flexible pero migraciones complejas con datos existentes  
- Cambios en protocolo BLE requieren actualización de firmware de pulseras

**3.4 Rendimiento**  
Objetivo: Garantizar tiempos de respuesta rápidos que mejoren significativamente el proceso manual actual, soportando múltiples usuarios concurrentes sin degradación del servicio.

Requisitos:

- RNF-001: Tiempo de autenticación ≤ 2 segundos  
- RNF-002: Detección de pulsera BLE ≤ 1 segundo  
- RNF-003: Registro de acceso completo ≤ 2 segundos  
- RNF-004: Carga de dashboard web ≤ 3 segundos  
- RNF-005: Soporte para 500-1000 usuarios concurrentes  
- RNF-006: Throughput mínimo 60 accesos/minuto

Estrategias arquitectónicas:

- Caché en Múltiples Niveles:  
  - Flutter: Cache en memoria para datos de estudiantes frecuentes  
  - API: Redis para sesiones y datos de consulta frecuente (TTL 15 minutos)  
  - Dashboard: Browser cache para assets estáticos  
- Optimización de BD:  
  - Índices compuestos en campos de búsqueda frecuente  
  - Agregación pipeline de MongoDB para reportes complejos  
  - Connection pooling (max 100 conexiones)  
- Procesamiento Asíncrono:  
  - Queue (Bull.js) para procesamiento de ML en background  
  - Worker threads para cálculos pesados  
  - Notificaciones push al completar operaciones largas  
- Compresión:  
  - Gzip para respuestas API \> 1KB  
  - Imágenes optimizadas WebP con fallback JPEG  
- Paginación:  
  - Cursor-based pagination para listados grandes  
  - Lazy loading en listas del dashboard  
- Batch Operations:  
  - Sincronización de múltiples registros en una sola petición

Limitaciones:

- Ancho de banda Wi-Fi institucional variable (10-100 Mbps)  
- Latencia Bluetooth BLE inherente (50-100ms)  
- Capacidad de procesamiento de smartphones de guardias variable

**3.5 Otras Limitaciones Arquitectónicas**  
Tecnológicas:

- Compatibilidad BLE: Android 8.0+ e iOS 12.0+ únicamente (descarta dispositivos más antiguos)  
- Alcance Bluetooth: Máximo 10 metros, requiere proximidad física  
- Flutter: Código compartido limita optimizaciones específicas de plataforma  
- MongoDB: NoSQL sin soporte nativo para transacciones ACID complejas entre colecciones  
- Dependencia de servicios cloud de terceros (MongoDB Atlas, hosting)

Económicas:

- Presupuesto limitado: S/. 127,300 total para desarrollo  
- Costo operativo mensual MongoDB Atlas: S/. 800  
- Hardware de pulseras: S/. 30 por unidad (500 unidades \= S/. 15,000)  
- Licencias de desarrollo gratuitas (Flutter, Node.js) pero hosting cloud tiene costo recurrente  
- Límite de 2 desarrolladores senior y 2 junior

Organizacionales:

- Plazo de desarrollo: 4 meses fijos  
- Equipo pequeño: 1 PM, 4 desarrolladores, 1 especialista ML, 1 QA  
- Disponibilidad limitada de stakeholders para validaciones (reuniones quincenales)  
- Capacitación de guardias debe ser ≤ 2 horas  
- Resistencia al cambio de personal acostumbrado a procesos manuales  
- Necesidad de mantener proceso manual de respaldo durante transición

Legales/Regulatorias:

- Cumplimiento obligatorio con Ley N° 29733 de Protección de Datos Personales  
- Consentimiento explícito requerido de estudiantes para uso de pulseras  
- Derecho ARCO (Acceso, Rectificación, Cancelación, Oposición) debe implementarse  
- Retención mínima de datos: 2 años para auditoría  
- Notificación de brechas de seguridad en 72 horas  
- Datos sensibles de estudiantes no pueden salir del país sin cumplir estándares

**4\. Análisis de Requerimientos**

**4.1 Requerimientos Funcionales**  
Requerimientos funcionales arquitectónicamente significativos:

| ID | Requerimiento | Descripción | Prioridad | Impacto Arquitectónico |
| ----- | ----- | ----- | ----- | ----- |
| RF-001 | Autenticación de guardias | Login con email y contraseña, generación de JWT | Crítica | Requiere módulo de autenticación con JWT, middleware de validación en API |
| RF-002 | Manejo de roles | Diferenciación Guardia vs Administrador | Crítica | Implementación RBAC, middleware de autorización, permisos granulares |
| RF-011 | Conexión BD estudiantes | Sincronización con sistema académico | Crítica | Adapter para BD externa, ETL diario, manejo de diferentes esquemas |
| RF-016 | Detectar pulseras BLE | Escaneo automático Bluetooth | Crítica | Plugin Flutter BLE, manejo de permisos nativos, threading |
| RF-017 | Leer ID único pulsera | Lectura del identificador de 16 chars | Crítica | Parser de protocolo BLE, validación de formato, retry logic |
| RF-026 | Registrar accesos | Almacenamiento automático con timestamp | Crítica | Modelo de datos Access, índices optimizados, transacciones |
| RF-046 | Dashboard general accesos | Vista en tiempo real de accesos | Crítica | WebSocket para push updates, agregaciones eficientes en MongoDB |
| RF-056 | Sincronización app-servidor | Comunicación continua online/offline | Crítica | Queue system, conflict resolution, SQLite local, background sync |
| RF-057 | Funcionalidad offline | Operación sin conexión a internet | Alta | SQLite local, cola de sincronización, detección de conectividad |

Agrupación por módulos:  
Módulo 1: Autenticación y Seguridad (RF-001 a RF-005)

- JWT con tiempo de expiración configurable (8h default)  
- BCrypt para hashing de passwords (factor 12\)  
- Middleware de validación en cada endpoint protegido  
- Refresh token para renovación de sesión

Módulo 2: Gestión de Usuarios y Roles (RF-006 a RF-010)

- CRUD de usuarios guardias (solo Admin)  
- Asignación de puntos de acceso  
- Control de acceso basado en roles (RBAC)  
- Auditoría de cambios administrativos

Módulo 3: Integración con BD Institucional (RF-011 a RF-015)

- Conexión read-only a BD académica  
- ETL incremental diario (2:00 AM)  
- Cache de datos de estudiantes frecuentes  
- Validación de vigencia de matrícula

Módulo 4: Detección y Validación BLE (RF-016 a RF-025)

- Scanner BLE continuo con bajo consumo  
- Validación de ID de pulsera en servidor  
- Asociación pulsera-estudiante  
- Autorización automática con fallback manual

Módulo 5: Registro y Persistencia (RF-026 a RF-030)

- Modelo Access con campos: timestamp, studentId, guardId, type, location  
- Índices compuestos para búsquedas frecuentes  
- Retención de datos 2+ años  
- Distinción entrada/salida automática

Módulo 6: Consultas y Reportes (RF-031 a RF-035)

- Queries optimizadas con agregación pipeline  
- Paginación cursor-based  
- Filtros múltiples (fecha, carrera, tipo)  
- Export a PDF/Excel

Módulo 7: Machine Learning (RF-036 a RF-045)

- Procesamiento asíncrono en workers Python  
- Algoritmos: regresión lineal, clustering, ARIMA  
- Entrenamiento semanal automático  
- Predicciones con nivel de confianza

Módulo 8: Dashboard y Visualización (RF-046 a RF-055)

- WebSocket para updates real-time  
- Charts.js para gráficos interactivos  
- Métricas agregadas con MongoDB aggregation  
- Caching de reportes pesados (Redis, TTL 1h)

Módulo 9: Sincronización y Offline (RF-056 a RF-060)

- SQLite local en app Flutter  
- Bull.js queue para operaciones pendientes  
- Conflict resolution: last-write-wins  
- Network connectivity detection

**4.2 Requerimientos No Funcionales**  
Requerimientos no funcionales críticos para la arquitectura:

| ID | Categoría | Requerimiento | Descripción | Métrica | Impacto Arquitectónico |
| ----- | ----- | ----- | ----- | ----- | ----- |
| RNF-001 | Rendimiento | Tiempo autenticación | Login rápido de guardias | ≤ 2 seg | JWT stateless, cache Redis de sesiones |
| RNF-002 | Rendimiento | Detección BLE | Lectura instantánea de pulsera | ≤ 1 seg | Optimización scanner BLE, threading |
| RNF-005 | Rendimiento | Usuarios concurrentes | Soporte carga simultánea | 500-1000 users | Connection pooling, horizontal scaling |
| RNF-007 | Seguridad | Encriptación datos | Protección en tránsito y reposo | TLS 1.3, AES-256 | Certificados SSL, encryption at rest en MongoDB |
| RNF-011 | Seguridad | Cumplimiento legal | Ley N° 29733, GDPR | 100% compliance | Auditoría logs, consent management, ARCO rights |
| RNF-018 | Disponibilidad | Uptime sistema | Alta disponibilidad | 99.5% | Modo offline, replica set, failover automático |
| RNF-024 | Mantenibilidad | Arquitectura modular | Facilitar cambios futuros | \< 10% código afectado | Separación en capas, SOLID, DI |
| RNF-027 | Portabilidad | Compatibilidad Android | Soporte dispositivos Android | Android 8.0+ | Flutter cross-platform, testing devices |
| RNF-031 | Escalabilidad | Crecimiento usuarios | Preparado para expansión | 2000+ usuarios | Arquitectura stateless, sharding MongoDB |

Clasificación por atributo de calidad:  
Rendimiento (Performance)

- RNF-001 a RNF-006: Tiempos de respuesta optimizados  
  - Estrategia: Cache multinivel (Redis L1, MongoDB L2, SQLite local)  
  - Índices compuestos en BD: {studentId: 1, timestamp: \-1}  
  - Lazy loading en UI, paginación cursor-based  
  - Compresión gzip para responses \> 1KB  
  - Image optimization: WebP con fallback

Seguridad (Security)

- RNF-007 a RNF-012: Protección multicapa de datos  
  - Estrategia: Defense in depth  
  - HTTPS/TLS 1.3 obligatorio en todas las comunicaciones  
  - JWT con HMAC-SHA256, rotación de secrets trimestral  
  - Input validation con Joi schemas  
  - Rate limiting: 100 req/min/IP, 1000 req/hour/user  
  - Audit logs inmutables en colección separada  
  - OWASP compliance: sanitización, CSP headers, CSRF tokens

Escalabilidad (Scalability)

- RNF-031 a RNF-032: Crecimiento horizontal  
  - Estrategia: Stateless API \+ distributed cache  
  - API Node.js stateless permite múltiples instancias  
  - MongoDB sharding por rango de fechas  
  - Redis cluster para cache distribuido  
  - Load balancer round-robin  
  - CDN para assets estáticos

Disponibilidad (Availability)

- RNF-018 a RNF-021: Continuidad operativa  
  - Estrategia: Redundancia \+ offline capability  
  - MongoDB Atlas replica set 3 nodos (Primary-Secondary-Arbiter)  
  - Modo offline con SQLite local (capacidad 10,000 registros)  
  - Health checks cada 30 seg con auto-recovery  
  - Backup incremental diario, completo semanal  
  - RTO: 5 minutos, RPO: 1 hora

Mantenibilidad (Maintainability)

- RNF-023 a RNF-026: Código sostenible  
  - Estrategia: Clean code \+ documentation  
  - Arquitectura hexagonal con separación clara  
  - Unit tests con coverage \> 70%  
  - Logs estructurados JSON con niveles (info/warn/error)  
  - API documentation con Swagger/OpenAPI  
  - Código autodocumentado con JSDoc/Dartdoc  
  - Git flow con branches: main, develop, feature/\*

**5\. Vistas de Caso de Uso**  
Esta sección presenta los casos de uso arquitectónicamente significativos, es decir, aquellos que tienen mayor impacto en las decisiones arquitectónicas del sistema.

**5.1 Casos de Uso Principales**  
Diagrama de casos de uso general:([link](https://img.plantuml.biz/plantuml/svg/TLLBRXD14DtFAGflM0Kos2Q0KCHWZ04bKMGxiCcccIcRXfdkeJyGG1o60x3Y2BaOhti-7XiXnKgvt-lggbSVFxDE6EUhacR2QdjbTMO-U-auTrh9NDlaJi4RgPYMyzawkrYSpIalXRL9SfSoa0pRH8J_D5fuOGefHYGiBRh3hAYaajOPKMWJeQo3LZZcIj3vMJnVdPzroDmw3q_ASKJclJCbIbmIj3P2sLgRbf2jGpYTlzf8bSjQb8b16a9jIzuzLZ3Dj796by7CyfojfekNin7zI8ZmTxTH8g0UK6vkVxiW1DN221ATEju8aBtbN5YuVmsnf32qOYjl_oXwysuT8xkQfKFQ2mvtmRlqfMNuYoz7teCXRydRg9bf8smvuo4dyz14VWVdN2WlofOp6NAGglLbUF10qglPTCXxoqE6XGHLxMtBV3XaBjWwgHKyjkNkM2TxiLcvLJ5DvI3TNXAFzeawwjRgOGU2FDv_Ld6GOycnwjsZwV5X5fU62vdd215fj9q5NdgWoaPkVV3NjaL7sol22craC0L1ukSlEifU3IwDHcQX1FrB_z7_CF1fyZFqB0XyqmJRjoqcQa57HwUnUJhhGM-DUslIMzFUUfWaMN-viqvwwr5lFTxnZdVcxWwqI32ItRVnyCiaIUPqxrwCYvxGIEHiSWnUKyGHGbXtr6d8SicbQ4k274jVy7s-SQoARho4JS2btkFJfotlz3G99n4O_mEC6s0IWSPZF4zR89tySmL73PGUG35C3BULeMFxESSmn-btOUDyOMDZVMgHVnBREAZzbVMGqQmJfHquH_GMQwj04s0h42jokW2_n0S1rregPwyLM6pa1beOgjbKCYoXvVDi5g3TFi3r36Fgw4nl0uBPvuywR2is9cnZoj5peQino86mbXLhx-WR6NRc6mciZUhsLzXf0Lxfs9TK8IRIcqs9NHzxz28D7Hgh0i7mBTQXCySxysHdfiUT3JKlj1E7GkA0RStvxUzDB7eKoEaQBxULVuMbybKO3ei04N_s4AL0f8s4ULokJd9LQw1OyT63aTiFhl4HckHya4k_mA_LRfuRDxM6IaPgqpXvhnsKQRoamKqpt9hUezXRexqghjLC58AcXDyqo8WVmMUe87uz_m80))

![][image3]

**5.2 Actores del Sistema**

| Actor | Descripción | Tipo | Casos de Uso Principales |
| ----- | ----- | ----- | ----- |
| Guardia de Seguridad | Personal de seguridad que opera la app móvil en puntos de acceso | Humano | CU-001: Iniciar sesión CU-002: Detectar pulsera CU-003: Registrar acceso CU-004: Autorizar manual CU-005: Consultar estudiante CU-006: Ver estudiantes en campus |
| Administrador | Personal de TI/Seguridad con acceso completo al sistema | Humano | CU-001: Iniciar sesión CU-007: Registrar guardia CU-008: Asignar puntos CU-009: Asociar pulseras CU-010: Generar reportes CU-011: Ver predicciones ML CU-014: Configurar sistema |
| Estudiante | Usuario final portador de pulsera inteligente | Humano | Uso pasivo de pulsera (no interactúa con sistema directamente) |
| Analista de Transporte | Personal que usa datos para optimizar transporte | Humano | CU-010: Generar reportes CU-011: Ver predicciones CU-013: Exportar reportes |
| Sistema (Scheduler) | Procesos automáticos programados | Sistema | CU-012: Sincronizar datos CU-015: Entrenar modelo ML CU-016: Backup automático |
| BD Académica | Sistema externo de información estudiantil | Sistema externo | Provee datos de estudiantes para sincronización |
| Pulsera BLE | Dispositivo IoT que identifica al estudiante | Hardware IoT | Transmite ID único via Bluetooth |

**5.3 Casos de Uso Arquitectónicamente Significativos**  
Los siguientes casos de uso representan los flujos más críticos del sistema que tienen mayor impacto en las decisiones arquitectónicas.

CU-001: Iniciar Sesión JWT

Información General

| Aspecto | Detalle |
| ----- | ----- |
| Actores | Guardia de Seguridad, Administrador, Sistema de Autenticación |
| Propósito | Autenticar usuario y establecer sesión segura con token JWT |
| Complejidad | Media |
| Impacto Arquitectónico | CRÍTICO \- Base de seguridad para todo el sistema |

Flujo Principal

1. Usuario abre app móvil en dispositivo Android/iOS

2. Sistema verifica si existe token JWT válido en SecureStorage

3. Si no existe token, muestra pantalla de login

4. Usuario ingresa email y contraseña institucional

5. App valida formato de email y fortaleza de contraseña localmente

6. App envía POST /api/v1/auth/login con credenciales encriptadas (HTTPS)

7. API valida credenciales contra colección users en MongoDB

8. API verifica hash BCrypt de la contraseña (factor de costo 12\)

9. API consulta roles y permisos del usuario (RBAC)

10. API genera JWT con payload: {userId, email, role, permissions, exp}

11. API firma JWT con clave secreta HMAC-SHA256

12. API retorna: {token, refreshToken, user: {name, role, accessPoints}}

13. App almacena tokens en SecureStorage del dispositivo

14. App navega a pantalla principal según rol (Guardia/Admin)

15. Sistema programa auto-refresh del token (cada 6 horas)

Flujo Alternativo \- Credenciales Inválidas

- 7a. API no encuentra usuario o contraseña incorrecta

- 7b. API incrementa contador de intentos fallidos

- 7c. API retorna error 401: "Credenciales inválidas"

- 7d. App muestra mensaje de error y bloquea por 30 segundos tras 3 intentos

Consideraciones Arquitectónicas

- Seguridad crítica: Tokens con expiración configurable (8h default)

- Almacenamiento seguro: SecureStorage con encriptación AES-256

- Rate limiting: Máximo 5 intentos de login por IP cada 15 minutos

- Audit logging: Registro de todos los intentos de autenticación

- Password policy: Mínimo 8 caracteres, mayúscula, número, símbolo

- RBAC integration: Permisos granulares según rol de usuario

Componentes Involucrados

- Mobile App: LoginView, AuthViewModel, SecureStorage, HTTPClient

- Backend API: AuthController, AuthService, UserRepository, JWTService

- MongoDB: Collection users con índices en email

- Redis: Blacklist de tokens revocados, rate limiting

- Security: BCrypt hashing, JWT signing, AES encryption

CU-002: Detectar Pulsera NFC

Información General

| Aspecto | Detalle |
| ----- | ----- |
| Actores | Guardia de Seguridad, Estudiante, Pulsera NFC MIFARE, Sistema BLE |
| Propósito | Detectar automáticamente pulseras NFC cuando están en rango |
| Complejidad | Alta |
| Impacto Arquitectónico | CRÍTICO \- Interfaz hardware principal del sistema |

Flujo Principal

1. App móvil inicia servicio de background NFC al hacer login

2. Sistema solicita permisos NFC y ubicación al usuario (runtime permissions)

3. NFCService configura escaner con parámetros optimizados:

   * Frecuencia: 13.56 MHz (ISO 14443-A)

   * Intervalo de escaneo: 500ms

   * Timeout por lectura: 2 segundos

   * Potencia: media (balance batería/alcance)

4. Sistema inicia bucle de detección continua en background thread

5. Pulsera MIFARE entra en rango de detección (2-4 cm)

6. NFC reader detecta campo electromagnético de la pulsera

7. Sistema establece comunicación ISO 14443-A con la pulsera

8. Sistema lee UID único de 7 bytes de la pulsera MIFARE Classic

9. Sistema convierte UID a string hexadecimal (14 caracteres)

10. Sistema valida formato del UID (regex: ^\[0-9A-F\]{14}$)

11. NFCService notifica a AccessController con el UID detectado

12. App reproduce feedback haptico y sonoro de detección

13. Sistema pasa UID a flujo de validación de estudiante

Flujo Alternativo \- Error de Lectura

- 7a. Falla la comunicación con la pulsera (interferencia, movimiento)

- 7b. Sistema reintenta lectura automáticamente (máximo 3 intentos)

- 7c. Si persiste error, notifica al guardia con mensaje específico

- 7d. Sistema continúa escaneando para nuevas detecciones

Consideraciones Arquitectónicas

- Performance crítico: Detección debe completarse en \< 1 segundo

- Background service: Operación continua sin bloquear UI

- Battery optimization: Ajuste dinámico de frecuencia según uso

- Error handling: Reintentos automáticos y recovery de errores NFC

- Threading: Operaciones NFC en worker thread dedicado

- Memory management: Liberación de recursos NFC al cerrar app

Componentes Involucrados

- Mobile App: NFCService, NFCViewModel, PermissionManager

- Flutter Plugins: flutter\_nfc\_kit, permission\_handler

- Android Native: NfcAdapter, IsoDep, Android NFC API

- Hardware: Antena NFC del dispositivo móvil, pulseras MIFARE Classic

- System Services: Android Background Service, PowerManager

CU-003: Registrar Acceso Automático

Información General

| Aspecto | Detalle |
| ----- | ----- |
| Actores | Guardia de Seguridad, Sistema, Pulsera BLE, Estudiante |
| Propósito | Registrar entrada/salida de estudiante mediante detección automática |
| Complejidad | Alta |
| Impacto Arquitectónico | CRÍTICO \- Flujo principal del sistema |

Flujo Principal

1. App móvil escanea continuamente Bluetooth BLE (background service)

2. Pulsera entra en rango (10m) y es detectada automáticamente

3. Sistema lee ID único de la pulsera (string 16 chars)

4. App consulta API: POST /api/v1/access/validate-bracelet con braceletId

5. API valida ID de pulsera en colección bracelets

6. API busca estudiante asociado en colección students

7. Sistema valida: estado activo, matrícula vigente, no está en blacklist

8. Sistema determina tipo de acceso (entry/exit) según último registro

9. API retorna datos del estudiante (nombre, foto, carrera) \+ autorización

10. App muestra datos en pantalla, guardia confirma visualmente

11. Guardia toca botón "Confirmar Acceso"

12. App envía: POST /api/v1/access/register con datos completos

13. API crea documento en colección accesses con timestamp, location

14. API actualiza bracelets.lastSeen con timestamp actual

15. Sistema envía WebSocket update a dashboard (real-time)

16. App muestra confirmación visual y sonora

17. Estudiante ingresa al campus

Consideraciones Arquitectónicas

- Performance crítico: Flujo completo debe completarse en \< 2 segundos (RNF-003)

- Caché de estudiantes: Datos de estudiantes frecuentes en Redis (TTL 15 min)

- Modo offline: Si no hay conexión, almacenar en SQLite local y sincronizar después

- Validación en múltiples capas: Cliente (básica), API (completa), BD (constraints)

- Concurrencia: Múltiples guardias registrando simultáneamente sin conflictos

- Auditoría completa: Todo el flujo genera logs estructurados

Componentes Involucrados

- Mobile App: BLEService, AccessController, SyncService, LocalStorage

- API Gateway: Rate limiter, SSL termination

- Backend API: AccessController, AccessService, StudentService, ValidationMiddleware

- Repositories: AccessRepository, StudentRepository, BraceletRepository

- MongoDB: Collections accesses, students, bracelets

- Redis: Cache de estudiantes, session store

- WebSocket Server: Real-time notifications

---

CU-004: Autorizar Acceso Manual

Información General

| Aspecto | Detalle |
| ----- | ----- |
| Actores | Guardia de Seguridad, Estudiante, Sistema de Validación |
| Propósito | Permitir autorización manual cuando la detección automática NFC falla |
| Complejidad | Media |
| Impacto Arquitectónico | ALTO \- Flujo de excepción crítico |

Flujo Principal

1. Guardia detecta problema con lectura automática de pulsera

2. Guardia toca botón "Autorización Manual" en la app

3. Sistema muestra formulario de autorización manual

4. Guardia puede buscar estudiante por:

   * Código estudiantil (8 dígitos)

   * Nombre completo (búsqueda fuzzy)

   * DNI (8 dígitos)

5. Sistema consulta API: GET /api/v1/students/search?query={term}

6. API ejecuta búsqueda con índices optimizados en MongoDB

7. Sistema muestra lista de resultados con fotos y datos básicos

8. Guardia selecciona estudiante correcto de la lista

9. Sistema valida elegibilidad del estudiante

10. Guardia verifica identidad visual con foto en pantalla

11. Guardia selecciona motivo y agrega observaciones

12. Guardia confirma autorización manual

13. Sistema crea registro de acceso con flag manual\_authorization: true

14. Sistema envía notificación a supervisor sobre autorización manual

15. Sistema permite acceso al estudiante

Consideraciones Arquitectónicas

- Workflow approval: Notificación inmediata a supervisores

- Enhanced auditing: Logs especiales para autorizaciones manuales

- Business rules: Validaciones adicionales para casos manuales

- Search optimization: Índices de texto completo para búsqueda rápida

- Photo rendering: Cache de fotos de estudiantes para validación visual

Componentes Involucrados

- Mobile App: ManualAuthView, StudentSearchWidget, CameraService

- Backend API: StudentSearchService, ManualAuthService, NotificationService

- MongoDB: Text indexes en collections students, audit\_logs

- Email Service: Notificaciones a supervisores

CU-005: Consultar Estudiante

Información General

| Aspecto | Detalle |
| ----- | ----- |
| Actores | Guardia de Seguridad, Administrador |
| Propósito | Buscar y consultar información detallada de estudiantes |
| Complejidad | Media |
| Impacto Arquitectónico | MEDIO \- Operación de consulta frecuente |

Flujo Principal

1. Usuario accede a sección "Consultar Estudiante" en app

2. Sistema muestra interfaz de búsqueda con múltiples filtros

3. Usuario puede buscar por código, nombre, DNI, carrera, estado

4. Usuario ingresa criterios de búsqueda

5. Sistema valida formato de entrada según tipo de búsqueda

6. App envía GET /api/v1/students/search con parámetros

7. API ejecuta búsqueda optimizada con aggregation pipeline

8. Sistema aplica filtros de seguridad según rol del usuario

9. API retorna resultados paginados (máximo 20 por página)

10. App muestra lista de resultados con datos básicos

11. Usuario selecciona estudiante para ver detalle completo

12. Sistema muestra información detallada con historial de accesos

13. Sistema registra consulta en audit log

Consideraciones Arquitectónicas

- Search performance: Índices compuestos y de texto completo

- Data privacy: Filtrado de información según roles (RBAC)

- Caching strategy: Cache de consultas frecuentes en Redis

- Pagination: Cursor-based para mejor performance

- Audit trail: Registro de todas las consultas para compliance

Componentes Involucrados

- Mobile App: StudentSearchView, StudentDetailView, SearchFiltersWidget

- Backend API: StudentService, SearchService, AuthorizationMiddleware

- MongoDB: Text indexes, compound indexes, aggregation pipelines

- Redis: Query result caching (TTL 15 minutos)

Flujo principal:

1. Usuario abre app móvil en dispositivo Android/iOS

2. Sistema verifica si existe token JWT válido en SecureStorage

3. Si no existe token, muestra pantalla de login

4. Usuario ingresa email y contraseña institucional

5. App valida formato de email y fortaleza de contraseña localmente

6. App envía POST /api/v1/auth/login con credenciales encriptadas (HTTPS)

7. API valida credenciales contra colección users en MongoDB

8. API verifica hash BCrypt de la contraseña (factor de costo 12\)

9. API consulta roles y permisos del usuario (RBAC)

10. API genera JWT con payload: {userId, email, role, permissions, exp}

11. API firma JWT con clave secreta HMAC-SHA256

12. API retorna: {token, refreshToken, user: {name, role, accessPoints}}

13. App almacena tokens en SecureStorage del dispositivo

14. App navega a pantalla principal según rol (Guardia/Admin)

15. Sistema programa auto-refresh del token (cada 6 horas)

Flujo alternativo \- Credenciales inválidas: 7a. API no encuentra usuario o contraseña incorrecta 7b. API incrementa contador de intentos fallidos 7c. API retorna error 401: "Credenciales inválidas" 7d. App muestra mensaje de error y bloquea por 30 segundos tras 3 intentos

Consideraciones arquitectónicas:

- Seguridad crítica: Tokens con expiración configurable (8h default)

- Almacenamiento seguro: SecureStorage con encriptación AES-256

- Rate limiting: Máximo 5 intentos de login por IP cada 15 minutos

- Audit logging: Registro de todos los intentos de autenticación

- Password policy: Mínimo 8 caracteres, mayúscula, número, símbolo

- RBAC integration: Permisos granulares según rol de usuario

- Session management: Invalidación automática y manual de tokens

Componentes involucrados:

- Mobile App: LoginView, AuthViewModel, SecureStorage, HTTPClient

- Backend API: AuthController, AuthService, UserRepository, JWTService

- MongoDB: Collection users con índices en email

- Redis: Blacklist de tokens revocados, rate limiting

- Security: BCrypt hashing, JWT signing, AES encryption

CU-006: Ver Estudiantes en Campus

Información General

| Aspecto | Detalle |
| ----- | ----- |
| Actores | Guardia de Seguridad, Jefe de Seguridad |
| Propósito | Visualizar en tiempo real qué estudiantes están actualmente dentro del campus |
| Complejidad | Media |
| Impacto Arquitectónico | MEDIO \- Dashboard en tiempo real |

Flujo Principal

1. Usuario accede a sección "Estudiantes en Campus" en la app

2. Sistema consulta API: GET /api/v1/presence/current-students

3. API ejecuta query optimizada para obtener estudiantes presentes

4. Sistema retorna lista de estudiantes presentes con datos básicos

5. App muestra dashboard en tiempo real con contador y lista

6. Sistema establece conexión WebSocket para updates en tiempo real

7. Cuando hay nuevo acceso, WebSocket notifica cambios automáticamente

8. App actualiza interfaz sin refresh manual

9. Usuario puede buscar estudiante específico en lista

10. Usuario puede ver detalles al tocar tarjeta de estudiante

Consideraciones Arquitectónicas

- Real-time updates: WebSocket para sincronización inmediata

- State management: Cache en memoria de estudiantes presentes

- Performance: Queries optimizadas con índices compuestos

- Memory efficiency: Paginación virtual para listas grandes

- Connection management: Reconnection automática de WebSocket

Componentes Involucrados

- Mobile App: PresenceView, StudentPresenceCard, WebSocketClient

- Backend API: PresenceService, WebSocketServer, RealTimeManager

- MongoDB: Aggregation pipelines, índices de timestamp

- WebSocket: Socket.io para comunicación bidireccional

CU-007: Gestionar Guardias

Información General

| Aspecto | Detalle |
| ----- | ----- |
| Actores | Administrador del Sistema |
| Propósito | Administrar usuarios guardias de seguridad del sistema |
| Complejidad | Media |
| Impacto Arquitectónico | ALTO \- CRUD crítico de usuarios |

Flujo Principal

1. Administrador accede a módulo "Gestión de Guardias"

2. Sistema muestra interfaz con lista actual de guardias

3. Para crear nuevo guardia:

   * Admin completa formulario con datos obligatorios

   * Sistema valida unicidad de email y DNI

   * Sistema genera contraseña temporal segura

   * Sistema envía credenciales por email institucional

   * Sistema crea usuario en colección users con rol "GUARD"

4. Para modificar guardia existente:

   * Admin selecciona guardia y modifica campos permitidos

   * Sistema valida cambios y actualiza registro

   * Si cambian puntos de acceso, sistema revoca sesiones activas

5. Para desactivar guardia:

   * Admin confirma desactivación con motivo

   * Sistema marca usuario como inactivo (soft delete)

   * Sistema revoca todos los tokens JWT activos

6. Sistema registra todas las operaciones en audit log

Consideraciones Arquitectónicas

- Security critical: Validación estricta de permisos de administrador

- Password management: Generación segura y envío por canal seguro

- Session invalidation: Revocación inmediata de tokens comprometidos

- Audit trail: Logging completo de operaciones administrativas

- Data validation: Validación con servicios externos (RENIEC)

Componentes Involucrados

- Web Dashboard: GuardManagementView, GuardFormModal, GuardListTable

- Backend API: UserManagementService, AuthService, EmailService

- MongoDB: Collection users con índices únicos en email/DNI

- Redis: Blacklist de tokens revocados

---

CU-008: Asignar Puntos de Acceso

Información General

| Aspecto | Detalle |
| ----- | ----- |
| Actores | Administrador del Sistema |
| Propósito | Configurar qué guardias pueden operar en qué puntos de acceso específicos |
| Complejidad | Media |
| Impacto Arquitectónico | MEDIO \- Sistema de autorización granular |

Flujo Principal

1. Administrador accede a módulo "Asignación de Puntos de Acceso"

2. Sistema muestra interfaz con matriz de asignaciones

3. Sistema carga configuración actual desde BD

4. Administrador puede asignar/desasignar puntos individualmente

5. Para cada cambio de asignación, sistema valida restricciones

6. Administrador puede configurar horarios específicos y restricciones

7. Sistema guarda cambios en colección access\_point\_assignments

8. Sistema invalida caché de permisos para guardias afectados

9. Sistema notifica a guardias sobre cambios en sus asignaciones

10. Próximo login de guardia carga nuevos permisos automáticamente

Consideraciones Arquitectónicas

- Granular permissions: Autorización específica por ubicación y horario

- Cache invalidation: Actualización inmediata de permisos en caché

- Geolocation validation: Verificación de ubicación en tiempo de acceso

- Schedule management: Lógica compleja de horarios y restricciones

- Conflict detection: Validación de asignaciones que no se solapen

Componentes Involucrados

- Web Dashboard: AccessPointAssignmentView, AssignmentMatrix

- Backend API: AccessPointService, AssignmentService, ScheduleValidator

- MongoDB: Collection access\_point\_assignments

- Redis: Cache de permisos por usuario

CU-009: Asociar Pulseras NFC

Información General

| Aspecto | Detalle |
| :---- | :---- |
| Actores | Administrador del Sistema, Estudiante |
| Propósito | Vincular pulseras NFC físicas con registros de estudiantes |
| Complejidad | Alta |
| Impacto Arquitectónico | ALTO \- Proceso crítico de onboarding |

Flujo Principal

1. Administrador accede a módulo "Gestión de Pulseras NFC"

2. Sistema muestra pulseras no asignadas y estudiantes sin pulsera

3. Para registrar nueva pulsera:

   * Admin coloca pulsera nueva en rango del lector NFC

   * Sistema lee UID único y valida que no existe en BD

   * Sistema crea registro en colección bracelets

4. Para asignar pulsera a estudiante:

   * Admin busca estudiante y selecciona pulsera disponible

   * Sistema valida restricciones de asignación

   * Sistema actualiza ambos registros con la asociación

   * Sistema envía email de confirmación al estudiante

5. Para desasociar pulsera:

   * Admin confirma desasociación con motivo

   * Sistema marca pulsera como inactiva

   * Sistema genera reporte de pulsera desactivada

6. Sistema valida integridad referencial en cada operación

Consideraciones Arquitectónicas

- Data integrity: Validación estricta de relaciones uno-a-uno

- Hardware validation: Verificación de autenticidad de UIDs NFC

- State management: Estados complejos de pulseras

- Audit trail: Historial completo de asociaciones/desasociaciones

- Batch operations: Asignación masiva para nuevos semestres

Componentes Involucrados

- Web Dashboard: BraceletManagementView, AssignmentWizard

- Backend API: BraceletService, StudentService, ValidationService

- MongoDB: Collections bracelets, students con foreign keys

- NFC Hardware: Reader para registro de nuevas pulseras

---

CU-010: Generar Reportes

Información General

| Aspecto | Detalle |
| ----- | ----- |
| Actores | Administrador, Jefe de Seguridad, Analista de Transporte |
| Propósito | Generar reportes estadísticos y analíticos sobre accesos estudiantiles |
| Complejidad | Alta |
| Impacto Arquitectónico | CRÍTICO \- Operación intensiva en recursos |

Flujo Principal

1. Usuario accede a módulo "Reportes" en dashboard web

2. Sistema muestra interfaz de configuración de reportes

3. Usuario selecciona tipo de reporte y configura parámetros

4. Sistema valida parámetros y estima tiempo de procesamiento

5. Si el reporte es complejo, sistema ofrece procesamiento en background

6. Usuario confirma generación del reporte

7. Sistema crea job en cola de procesamiento (Bull.js)

8. Worker ejecuta aggregation pipeline optimizado en MongoDB

9. Sistema genera visualizaciones con Chart.js/D3.js

10. Sistema exporta reporte en formato solicitado

11. Si es background job, sistema envía notificación de completado

12. Usuario descarga reporte desde interfaz web

13. Sistema registra generación en audit log

Consideraciones Arquitectónicas

- Performance crítico: Aggregation pipelines optimizados para big data

- Background processing: Jobs asíncronos para reportes pesados

- Caching strategy: Cache de reportes frecuentes por 1 hora

- Memory management: Streaming de datos para datasets grandes

- Export optimization: Generación eficiente de PDF/Excel

Componentes Involucrados

- Web Dashboard: ReportConfigView, ChartComponents, DownloadManager

- Backend API: ReportService, ExportService, JobQueueManager

- MongoDB: Optimized aggregation pipelines, compound indexes

- Bull Queue: Background job processing con Redis

CU-011: Ver Predicciones ML

Información General

| Aspecto | Detalle |
| :---- | :---- |
| Actores | Administrador de Transporte, Jefe de Seguridad, Administrador |
| Propósito | Consultar predicciones y recomendaciones de machine learning |
| Complejidad | Alta |
| Impacto Arquitectónico | ALTO \- Integración con módulo ML |

Flujo Principal

1. Usuario accede a sección "Predicciones ML" en dashboard

2. Sistema verifica que existan modelos entrenados activos

3. Sistema muestra dashboard de predicciones con categorías

4. Usuario selecciona tipo de predicción deseada

5. Sistema consulta API ML: GET /api/v1/ml/predictions/{type}

6. Módulo ML ejecuta pipeline de predicción con modelo entrenado

7. Sistema procesa resultados y genera visualizaciones

8. Sistema muestra nivel de confianza del modelo

9. Usuario puede ajustar parámetros de predicción

10. Sistema actualiza predicciones en tiempo real

11. Usuario puede exportar predicciones en múltiples formatos

12. Sistema programa re-entrenamiento automático semanal

Consideraciones Arquitectónicas

- Model serving: API optimizada para inference rápida

- Feature pipeline: ETL automatizado para features de ML

- Model versioning: Control de versiones de modelos entrenados

- Explainable AI: SHAP/LIME para interpretabilidad

- Performance monitoring: Métricas de accuracy y drift detection

Componentes Involucrados

- Web Dashboard: MLPredictionView, ChartComponents, ExplanationWidgets

- ML API: PredictionService, ModelManager, FeatureExtractor

- ML Models: Scikit-learn, TensorFlow models serialized

- Feature Store: Redis cache para features pre-computadas

---

CU-012: Sincronizar Datos con BD Académica

Información General

| Aspecto | Detalle |
| :---- | :---- |
| Actores | Sistema (Cron Job), BD Académica Institucional |
| Propósito | Sincronizar datos de estudiantes diariamente |
| Complejidad | Media-Alta |
| Impacto Arquitectónico | ALTO \- Integración con sistema externo |

Flujo Principal

1. Cron job se ejecuta diariamente a las 2:00 AM

2. Worker ETL se activa desde Bull.js queue

3. Worker conecta con BD Académica (JDBC o REST)

4. Extrae lista completa de estudiantes activos (query optimizada)

5. Compara con colección local students (checksum o timestamp)

6. Identifica nuevos, modificados y dados de baja

7. Ejecuta operaciones en batch (bulkWrite) de máximo 1000 documentos

8. Actualiza campo syncedAt en cada documento modificado

9. Genera log detallado de la sincronización

10. Notifica al administrador via email si hay errores críticos

11. Marca job como completado en queue

Consideraciones Arquitectónicas

- Adapter Pattern: Abstrae diferencias entre JDBC y REST API

- Idempotencia: Proceso puede ejecutarse múltiples veces sin duplicar datos

- Transacciones: Operaciones en batch para atomicidad

- Error handling: Reintentos automáticos con backoff exponencial

- Performance: Sincronización incremental (solo cambios)

Componentes Involucrados

- ETL Worker: Lógica de extracción, transformación, carga

- Academic DB Adapter: Interfaz con sistema externo

- Student Repository: Operaciones bulk en MongoDB

- Logger: Winston con archivo rotativo

- Bull Queue: Programación y gestión del job

CU-013: Consultar Reportes

Información General

| Aspecto | Detalle |
| :---- | :---- |
| Actores | Analista de Transporte, Jefe de Seguridad, Administrador |
| Propósito | Acceder y consultar reportes generados previamente |
| Complejidad | Baja-Media |
| Impacto Arquitectónico | MEDIO \- Optimización de consultas |

Flujo Principal

1. Usuario accede a sección "Biblioteca de Reportes"

2. Sistema muestra lista de reportes disponibles organizados por categorías

3. Sistema aplica filtros según permisos del usuario

4. Usuario puede filtrar reportes por múltiples criterios

5. Usuario selecciona reporte de interés

6. Sistema muestra metadata del reporte detallada

7. Usuario puede realizar acciones: descargar, previsualizar, compartir, regenerar

8. Para descarga, sistema verifica permisos y sirve archivo optimizado

9. Sistema registra la operación en audit log

Consideraciones Arquitectónicas

- File storage: Almacenamiento eficiente de archivos de reportes

- Access control: Permisos granulares por tipo de reporte

- Caching strategy: Cache de metadata para listados rápidos

- Download optimization: Streaming de archivos grandes

- Audit logging: Registro de todas las descargas

Componentes Involucrados

- Web Dashboard: ReportLibraryView, ReportPreviewModal, DownloadManager

- Backend API: ReportAccessService, FileStorageService, PermissionService

- File Storage: Sistema de archivos o S3 para almacenar reportes

- MongoDB: Metadata de reportes en collection report\_metadata

**5.4 Matriz de Trazabilidad**  
{Matriz que relaciona casos de uso con requerimientos y componentes arquitectónicos}

| Caso de Uso | Requerimientos | Componentes | Atributos de Calidad |
| :---- | :---- | :---- | :---- |
| CU-001 | RF-001, RF-002 | {Componentes} | Rendimiento, Seguridad |
| CU-002 | RF-003, RF-004 | {Componentes} | Disponibilidad |
| CU-003 | RF-005 | {Componentes} | Escalabilidad |

**6\. Vista Lógica**  
{Descripción de la organización lógica del sistema}  
La vista lógica describe la organización conceptual del sistema en términos de capas, subsistemas, paquetes y clases.

**6.1 Diagrama Contextual**  
{Diagrama que muestra el sistema en su contexto, con sus sistemas externos y usuarios}

Diagrama de Contexto:([link](https://img.plantuml.biz/plantuml/svg/XLRBZk8u5DtdA-umYrbHxvPAjMXro8DATG8e2K8j8I6J6CepYOrifxfxHlCnivn5h-eJ-B6vTg0A0khP808-nxxdddETJqeJgPkw0f-HjIGryGJNz9iMpYybNJ5E8Gsyt1qDum2AYYZbEBz1nfIcDO6DPBnW6r8vaXQQy7L5eRV_qn19KO5R55G968LU3uY2n8r6Y-nBbWS9_1hSXZUX3tyv00SCxcO3OTLeJIKaOiagQf5XFCtp85suaydn-W4f_g2y17SIGKfOzPLyju21wtqEHZu2ecD08lXQ-0DmDLRKdcey6exzGMVPzhLiAW59tAw95ydOdyQ1yxSHmIsqa5J1SrCJBfH3p3FqXWsH9IDGKiZekf6i9AM53wTkwcF9z-67u7w_sYrhnb4mIKfyt4bdbxj-4eswov_eYfuoPu6ty1wZ8FmvUou9LniXTIjddhgZR39EyyNnLk_zLO16eD8KTwQ_Ra7AxRyrAmHCHq-3ONjgp_M39FBUEXo6uMrmTGuVrDWgo99yOf416YF-2MpIL8fAN8X6WYGAtJImE7nSFAAoC_m1SRV1X_338Iwb9SnOo63AsGkLwasrMHH6Yr6GpyRfvtF0ZCeNLZ2Xzfu2hn9DYqtnh3FtoyABnrF_7FZ8OGT0Du_Th0D3mIFCd2G5xiRHKM-nmkzzs1bAEQs1-lsFXqc01-YDDmW6Wgcfjwylh9hp64_Iu6ycTCxXQeC-KWpXCQMmsQlRAZldKJQ6wxkxkzk-Uyfm42n3y9ZdampdH9QR2Cxvqmo_DFgvzt-b7VcJAgSrufaAXrHfjdtbq2XK0tiovocrLbOzvzt-Pv1Pip5zL1PDx2X2i4_KyrAWhZsd6mF3yPPqmu1pJ3ML9cOoY1hd36bhcVDbeyp-9qKkstda7CfaQTiXOqZt_fWnIM4YXHQ5mBvvAVh2jbCZ5N9tARhvCXL-vmMKHADHKQK6hOA7mTCz-GFlqZJbbEKeQqWn4fgjMF5Mc0tbQLr9xBmhqod8vTj_AfHPxOxoZ6tTlagS3iWt8NWJ68Qs0JlgbIHuODbOgvvux2YURHlGrEp5v7VExwzkBgwl-IKfJgix3gVnfq3ty3KEJhMfw1hDXaf7bvxVS_OLM6qFieaedsYo98hQ2Mjd0RMkgr0e_47RAl2Q-XshnP7Sbbt8xGzjYjwbzUBYuswIFvXHP2nBm4IWfFY1bu_JxQX17EYQuMBKZls9pJ4MnlPAHkRyvk7g2joaTz0HW-owsUvwP5kmhiKUumpc9eUs3dG0iMKmx3Y-1zZD72uqXQNGMjGWLcVCbmcy7gjss21bvwnSc3yuCNdhs1ETWBr4cTezjDYO3JgJwH43-fLWG7RNaDq1quKFsn-65Jr6Z8nmqxyhwXsNPEjdRTYwFfXKsD6LaERTn0paESSX9Vgg81MwOyunaynSwM8lGYaSvnCgXwz7_m40))

![][image4]

```

```

Descripción: {Descripción del contexto del sistema y sus interacciones principales}

Sistemas externos:

| Sistema Externo | Descripción | Tipo de Interacción | Protocolo |
| :---- | :---- | :---- | :---- |
| {Sistema 1} | {Descripción} | {Tipo} | {Protocolo} |
| {Sistema 2} | {Descripción} | {Tipo} | {Protocolo} |
| {Sistema 3} | {Descripción} | {Tipo} | {Protocolo} |

**6.2 Arquitectura de Alto Nivel**  
Patrón arquitectónico: Arquitectura en Capas (Layered Architecture) con separación cliente-servidor y patrón MVC en cada capa.

Diagrama de capas:([link](https://img.plantuml.biz/plantuml/svg/dLVDSjis4BxpAL3rKElWUgQTNZpJJYYATfJHNqGbQiV90IBN4YeGK47GjjhnK-HHyWX-iIn0KOH8Il5K1usytsBtsr_0Rp9DbSvJxlsGm3qJG6PXCFV7jyEGA8Wr5IiEdfTjcDXIHTDAIFxp27vwDDwibCn54aWk5LcicOOebHieOAaIK0NKuwZhIETh5cy4P1dvnNjsVSGotKe1Gf_mCMIhjUxnlEcYJzN60aVsjdYUhaunzl_DLTFIc3xihF162Xtf7GQyb3mnXdyYlpiV4lXJd_H3Cfs5KJYU-y7WvSluICKh2NHQTJlaHnlHNy2vVDoph7BGyRTRCdhv-i0ukU6vrg0wX6O4nIDfXCK1yxdxoE0nkufY1I2opvLymP8LQ5VImmAFg41Mgf0-s--wxpxDraj9LK8Mi2GpeB6spetSI1pVGNagkvgYMTVP39ByYKHQAd2amHfRZrJ7IXwdKpny-N8x2EpFSNWx2GQJx-IvUQ1Czgr9KKkkfmESW6XEnZA1d__EhiAdhS8MBJ8-7SmWqqxGbKFi4YKv1uMg5MxZz7Ez9fN2vneQnsO4JkAHpXD3xQJ23BPIdS57mrRi-V2h6Kq4we4XhVPGzcXx7ErW6KGxke-W7KJw3U0Szn4MZZUPVyX04OkTeDQ6xMDgWtgAni2XSUuSjG-QjJ1xjvZNR8SYLhkjhaa_KiuIYZDKam_bQlNQmevOad1ufEfKRIk5UerwVb0NKGr3bh8wqL0fgTvIaRowtmwXDLb5yHfIIau5Fn3RN9z4Utd6x0NJed2EJtL5a8LKcxQX3kVObpiHDxjrhYWJJApgMKafxkhtEUGdslyM1AWsZkSseXy4OJGX-DkVJwBlRCEQyaNV7tRBVHZiQCiwDDGoXfmO52lG2jojR-RA29szlf-echIOfPgmdA9At7uD1HJReBolB14h6HquxnEPi3tY-1ZAcFA6jB0OQSmuh7RdV8TFUECADE4dTAjjBw1_b9P_knJyc2QGifZqUwM-uxJeWSOwkuj6qR7qNCbVKschKvOseZoLPQ9m2kYIPdPHYfKqD3MdsITnCLKifMhNjU6LuD7zZXT8h9aK6RduZM0eekl4C109F052DdKuEYw8zUKifXYa9XU_4e4xC-isabvnSog9pFeiquejSmr9Tz-51dQuHTXQIApnn30hYjWTTJIGT-_aqXt5LWxH-o4-PT5zqK2Nc9Cbur0mA42NmkJ-dfltip7WbXPt1FcdrLM6P6tLRj0iBfDCGuhkS8KKTrZXoO05vdgpImOIabfDnvyzIbBGj2BIsasJSVZd0BzghNHuLLucyb5S_d5uz5nZLSp3oBoGBjxEvzEe-qdW4p2IySPKTH55tOvNlWl_tsclL2-F5-lckchMlc8Fk04QYeTrS7re7ivmV9kQpk1wNc6_X4edQ6CUJCshIHGDt_4EzYjcnacBvh79eayQ9AgYUjuR40d-0_OD))

![][image5]

```

```

Descripción de capas:  
Capa de Presentación

- Propósito: Interactuar con usuarios finales (guardias, administradores) y presentar información de manera clara e intuitiva.  
- Tecnologías:  
  - Flutter 3.x (Dart) para app móvil  
  - React.js / Vue.js para dashboard web  
  - Material Design / Ant Design para UI  
  - Chart.js / D3.js para visualizaciones  
  - WebSocket para real-time updates  
- Responsabilidades:  
  - Renderizar UI responsiva  
  - Capturar inputs del usuario  
  - Validación básica en cliente  
  - Gestión de estado local (Provider/Bloc en Flutter, Redux/Vuex en web)  
  - Manejo de navegación  
  - Comunicación con backend via HTTP/WebSocket  
- Componentes principales:  
  - Screens/Pages: Login, Dashboard, AccessRegistry, StudentSearch, Reports  
  - Widgets/Components: BLEScanner, AccessCard, ChartWidget, StudentList  
  - State Management: Stores, Providers, Controllers  
  - Services: API Client, WebSocket Client, BLE Service

Capa de Lógica de Negocio

- Propósito: Implementar toda la lógica de negocio, reglas de validación, orquestación de servicios y transformación de datos.  
- Tecnologías:  
  - Node.js 18 LTS con Express.js  
  - TypeScript para type safety  
  - JWT (jsonwebtoken) para autenticación  
  - Bcrypt para hashing  
  - Joi para validación de schemas  
  - Bull.js para job queues  
  - Winston para logging  
- Responsabilidades:  
  - Validar reglas de negocio (RN-001 a RN-020)  
  - Autenticar y autorizar usuarios (JWT \+ RBAC)  
  - Orquestar operaciones entre repositorios  
  - Transformar datos (DTOs)  
  - Manejar transacciones y consistencia  
  - Disparar jobs asíncronos (ML training, emails)  
  - Generar logs de auditoría  
- Componentes principales:  
  - Controllers: AuthController, AccessController, StudentController, ReportController  
  - Services: AuthService, AccessService, StudentService, MLService, SyncService  
  - Middlewares: authMiddleware, rbacMiddleware, rateLimitMiddleware  
  - Validators: inputValidator, businessRuleValidator  
  - Workers: ETLWorker, MLWorker, ReportWorker

Capa de Acceso a Datos

- Propósito: Abstraer el acceso a fuentes de datos, implementar patrón Repository, manejar caché y adaptadores externos.  
- Tecnologías:  
  - Mongoose ODM para MongoDB  
  - Redis client (ioredis)  
  - SQLite driver (sql.js en Flutter)  
  - Axios para HTTP a servicios externos  
- Responsabilidades:  
  - Implementar operaciones CRUD  
  - Gestionar conexiones a bases de datos  
  - Implementar estrategias de caché  
  - Mapear entre modelos de dominio y BD  
  - Manejar queries y agregaciones complejas  
  - Implementar adaptadores para sistemas externos  
  - Gestionar pool de conexiones  
- Componentes principales:  
  - Repositories: UserRepository, StudentRepository, AccessRepository, BraceletRepository  
  - CacheManager: Redis integration, cache invalidation strategy  
  - Adapters: AcademicDBAdapter, EmailAdapter, SMSAdapter  
  - Query Builders: Complex aggregation pipelines

Capa de Datos

- Propósito: Almacenar y persistir datos de manera confiable, segura y eficiente.  
- Tecnologías:  
  - MongoDB Atlas 6.0 (Cloud)  
  - Redis 7.x (Cache & Queue)  
  - SQLite 3.x (Local offline)  
  - File System (ML models)  
- Responsabilidades:  
  - Persistir datos de manera durable  
  - Garantizar consistencia (eventual para sync offline)  
  - Implementar índices para performance  
  - Replicación para alta disponibilidad  
  - Backups automáticos  
  - Almacenar modelos ML entrenados  
- Componentes principales:  
  - MongoDB Collections: users, students, accesses, bracelets, audit\_logs  
  - Redis Stores: jwt\_sessions, rate\_limits, job\_queue  
  - SQLite Tables: local\_accesses, sync\_queue  
  - File Storage: ml\_models/, reports/

**6.3 Diagrama de Paquetes**  
{Organización del sistema en paquetes lógicos}

Diagrama:([link](https://img.plantuml.biz/plantuml/svg/bLVDRkCs4BxxATZieUqXGT5WYyKU5gluf-lMVxMSv5XCfB7CHYAr91N3MEmZzRIFa1Vha98jYb8BD400QJwACvpv-CtuepQWJ5NaRC8XKr301ZvNQ52FHj-piSobGirAgPZXfMGfihB6Hz-bkES2sMOxZQUhNRIRhrT_ZjUBzPQzcTxEVfvDBalkxkFvQXh75_ZTxEtqtGMUHBle3CrcizlfJnTelffjM-ns-dRsTZJIproKGB5IBCapP1YRKuvCOM90P3bw2_G1Kdda8cDxoBMFW5BowCx7tlpY_jo1eGHtI3er2WC9V_qcs2olZ44rQjongqq36ou5My09rHK3tKd5K5w-Z1YxxF70yQYld8sn90UjsK9cN5YxPujDbPAh1rHypnFdCLWHfGKN4z279mag3S0jKksCRgnVwJ-COIbJp8D0eieSBfXdNyt6GsONmH3WUJz3OGYFFCtG1Fx7bJQo86zn0a9Gvdlvc821CHstvsny83vtSWefrNykKfizgLm8N_rQvw_VCiBiey1C9bosXRwhDD6mAKtYbVfCwP3RdHB7g5vuWc5oIzu0tSpsZUlzFYVtVI0-YMJ0Ie4IFLeWpFLWgVEg438itBskGF6UET9S6nG9Xn2fRuG7zAW6EKzj0GB_Sr5MvW86N1imEsfwzj3FlU7X4OahkEC5EiYpJqMYJgMzKI6oGdEKwlbi3WXZNUkM8vQA7ZEiclcIrc74GYQG4uUbejTkbF4V2sxGRlO4kblMf5BOVEFRYUcOKkBtg2Zrg0UoiSL26cJHPXxaP0iyFyBfZXQYI0dtiAKKcPpSHORU_Cmda6B1a_X472ZgJ_h-IgavXSf3rjzhL1VqrB_GWrX4iYjIeCDruA0UNEmLe3QgIaobeAtCt09dEterScsbqrmwLVf4mdAav18vIVRtqBl2nCqBvCiM5AXW2Fbr4_lcC6qDtxfEFkrsct7EAJUUyH6VOaarCpraB4af4yDVk3ajGT2-GzTZauFPIrMmOMrQINDfCts1kUEoGAFuWFRCU8urCNpvSMLgECOqsiwR-khQ8CGbziEAXEFcB_rZBQ_H-FVfQlAVwae7DahcEOQIOYMY1VjK6yHQgWt2JISRn9QBZhcdkZnDSxHyweRvs-EkXJnxesvKWK5ulDx6Wy2K9XhLGS98_gKVKRe66r8RI1zUBY81-OdwGH-R5YGk_wyBEScH6clCr-xTkcVpuaeEM80dqHCigOgk4T7KgZWzb92JD7P6ivkR3sq3VyygJGikxnPq6lwUjCNk5c2rTZHVkOM-bHTbZWMHJFV2GLrYylgtlLvwr9cmsFNr1tyiyCSiXtdJGRlC8Pv8j8lEtxIIqvqa71xqc-xmKA_eD9xmE4_rvHrvrx3vgYPP3_2eULvJsxkr9p-aGkG0rEUA8amCZU0kPyAsCiMpWs5otvclYG0RCChEwik7XwLzLVA5fwYOrHn6FtBeqyAfOb7Bvf8iYbCpdg3ccHXP7R8EHhMR9sbe0hL-piMdRnRzIP4rRAHduJhm5ZCYgLq22PrGXXldk7VXM-QuvUU-Paz08GaoZe5uJMgbACRCDhocVDTxhhG9TpIoj1iw1jBQw8aw7lbslrmEJISZUvrpBkbUK0y0smI0p6sBOuBkr0lbkTt_8ptIRyD_0000))

![][image6]

```

```

Descripción de paquetes:

| Paquete | Descripción | Dependencias | Componentes Principales |
| ----- | ----- | ----- | ----- |
| {Paquete 1} | {Descripción} | {Dependencias} | {Componentes} |
| {Paquete 2} | {Descripción} | {Dependencias} | {Componentes} |
| {Paquete 3} | {Descripción} | {Dependencias} | {Componentes} |

**6.4 Patrones de Diseño Aplicados**

| Patrón | Contexto | Problema | Solución | Ubicación |
| ----- | ----- | ----- | ----- | ----- |
| Repository | Acceso a datos | Acoplamiento con tecnología de BD específica | Abstrae persistencia detrás de interfaces | Capa DAL: UserRepository, StudentRepository, AccessRepository |
| Singleton | Configuración global | Múltiples instancias de configuración inconsistentes | Una única instancia compartida | ConfigService, DatabaseConnection |
| Strategy | Algoritmos ML | Necesidad de intercambiar algoritmos predictivos | Interfaz común con implementaciones diferentes | MLService: LinearRegressionStrategy, ClusteringStrategy, TimeSeriesStrategy |
| Adapter | Integración externa | Diferentes interfaces de sistemas externos | Adapta interfaces externas a interfaz común interna | AcademicDBAdapter, EmailServiceAdapter |
| Observer | Notificaciones real-time | Notificar cambios a múltiples clientes | Suscripción a eventos con notificación automática | WebSocket server para dashboard updates |
| Factory | Creación de objetos | Lógica compleja de creación de DTOs y entidades | Centraliza creación de objetos | DTOFactory, EntityFactory |
| Middleware Chain | Procesamiento de requests | Validaciones y transformaciones repetitivas | Pipeline de procesadores encadenados | Express middlewares: auth → rbac → validate → handle |
| Dependency Injection | Acoplamiento de servicios | Dependencias hardcoded dificultan testing | Inversión de control vía constructor | Todo el backend: Services reciben repositories vía DI |
| DTO (Data Transfer Object) | Transferencia de datos | Exponer entidades de BD directamente es inseguro | Objetos específicos para transferencia | LoginDTO, AccessDTO, StudentDTO, ReportDTO |
| Cache-Aside | Performance de lectura | Consultas repetitivas a BD lentas | Cache con lazy loading | StudentRepository, BraceletRepository con Redis |

Descripción detallada de patrones críticos:  
Repository Pattern

- Ubicación: src/repositories/  
- Implementación:

```ts
interface IAccessRepository {
  create(access: Access): Promise<Access>;
  findById(id: string): Promise<Access | null>;
  findByStudentId(studentId: string, limit: number): Promise<Access[]>;
  findCurrentlyInCampus(): Promise<Access[]>;
}

class AccessRepository implements IAccessRepository {
  // Implementación con Mongoose
}
```

- Beneficio: Permite cambiar MongoDB por otra BD sin afectar Services

Strategy Pattern (ML Algorithms)

- Ubicación: src/services/ml/strategies/  
- Implementación:

```ts
interface IPredictionStrategy {
  train(data: AccessData[]): Promise<Model>;
  predict(input: PredictionInput): Promise<Prediction>;
}

class LinearRegressionStrategy implements IPredictionStrategy { }
class ARIMAStrategy implements IPredictionStrategy { }
class ClusteringStrategy implements IPredictionStrategy { }
```

- Beneficio: Intercambiar algoritmos sin cambiar código cliente

Middleware Chain (Express)

- Ubicación: Backend API routes  
- Implementación:

```ts
router.post('/access/register',
  authMiddleware,        // Valida JWT
  rbacMiddleware('guard'), // Verifica rol
  validateSchema(accessSchema), // Valida input
  accessController.register // Maneja request
);
```

- Beneficio: Reutilización de lógica común, código DRY

**7\. Vista de Procesos**  
{Descripción de los procesos del sistema y sus flujos}

**7.1 Diagrama de Proceso Actual**  
{Diagrama que muestra el proceso actual (AS-IS) antes de la implementación del sistema}

Diagrama:([link](https://img.plantuml.biz/plantuml/svg/VLHBRjj03DtFAGXqKMUPz6D4MJIkRGK5cY98Ykx7CvH3H9eHE2Et1NIP7C2h7g10TR5G7tzY6zqO69BlaU-HydM8ccDLv737tc3m4nChdIiLdiYLcdK1saHQKVpzMPkd9VlAsQdFFSER-Rlq8fsTglHiaOUgyylnnzd5YQePwS8xUqIRfkdbzFr_0FliwOTnUZvMwYtCC2D73E4d5Rbs65Gz3x6of5t4MdKwLV8rnwLcq51MBdgmAEojx2kLtFeGMN96iyC8MRCEP2IXwfjAi_3KAhd75OLTZJp4BC7-GAQC90gPZos6CXZz-piTofhddAp_T0Rn4HsCGhC-Km397N91KMRUp03Gu-vnIVqmXNRIeK3HS0WNWedp8WiaQ2ejfhYE0q3224pBnzWzORDSyAKXxsI_VVYRXq1Ob8mG131qxPBeR4SZ3ymbEN9-QBgTkjIXnRiDi6ikEChKFYIPeUjDtwfC7dnEXjhPoOgspZj3pHy7sb8_uiwDBmSblPtwX1y7XWB-CbZkw7QE-KL0NlLyLySIRzkRSSXo7-tespA047svKzdzgdfY2pczrZhhkHvsduen5dEmpVfeLBaZuqlAsqiQ5XSwNxwpTi4mBLeDC9Vny-44slJ1MZTBpSKUlucKw2Ia0PazoqVmQfF9JQjAkZAMdeLiqJptH_vgOGzxEmLo1ShnjrSzwEqyKDVoal-D5m00))

![][image7]

```

```

Descripción: {Descripción detallada del proceso actual}

Participantes:

- {Participante 1}  
- {Participante 2}  
- {Participante 3}

Problemas identificados:

- {Problema 1}  
- {Problema 2}  
- {Problema 3}

Métricas del proceso actual: | Métrica | Valor Actual | |---------|--------------| | Tiempo promedio | {Valor} | | Errores por proceso | {Valor} | | Costo por operación | {Valor} |

**7.2 Diagrama de Proceso Propuesto**  
{Diagrama que muestra el proceso propuesto (TO-BE) con el nuevo sistema}

Diagrama:([link](https://img.plantuml.biz/plantuml/svg/VLN1Rjj64BtlLmnG5BKC54sS16xaGoDBL630iWAxyNsr7CbRaxlixb993HxwA-wzfzvwAL3zIR-aRvUaBCjE0842E3DlPjwR6RxpGRfGbmLzS5Qnj_YhQlR12k5ljQcaaoL95VHQXzzEfRfTELkRV6mBw-YRxCVfc-pjSvxMvUmwhwFiUFBgw1clYPQbDVaJsEbq-dRy-Yi1k-ZJDyVJbyT2V4SJNcgZ7VbFkYoaOI-Qp8Swrz84RaHgLGpF2rv9HvAgsWHBEGCzTduYXYF5Ji5MrOLd9-bYEePVhdrblKO5y34sC3czkWc2QAA1QPIMTFJzQrN6DnnOARtvov2iWoqtzq4hATZa52E5QAuGmsN2RiGm-OUTbBEpwUWoGotdp8u-dareyxVHAbPtBGkTmrLPGmlfEPQUos3zYH1wIGV__lFGBQqtz_2sFmqetB2X0x_vSu3wXlD5O0Fa54Yy3JY9nbYDAxL1ag0hsn43om6Ru6GkV_2fXa7qngzvNqk7-2O6Np-W6gg0AOj29jYnDKljIg3g7400o6cjVIsB7kSHAOYuv1NUk2YJZwR4yGwX2NQa0Y3qNMJFiM-TWkOIbJjkmOSps-AeheQaJPzsTphWctbLgniuUsl0tTCOf8o4K1LPGXys0J6KemDZUyu7ptNKry7EOMZt6Dgdyf91JonQ8baf3TeikHEfLNe4BbngdJyhhbA5-re_vh6jl0KxQQsZbKkhO1SOlJNQjDYPrhP7pHTQxpiVV3q6eYDF6qA4srB5M9FhfMYVeead82v9HriZbjRTHYgkj54ESjnrWp-pPcKdf_i3a4j_ix1WyF40H1IIAwbDqjUiDNonY7g98MhNr6lu_bgpmrZk1RHKeuAOcJz_WUDHWGdXk3DskIoquOxTHvNNqc2Wm9RZYALQBRSSK6fND2CJHmWZJxFpfblgITefNwDa7OV0FzdfaUdNG0ONDTnUD1ZVntM7BIR64ELRcJlganm2Dp6MqH-smyFJx2ARdetFvbSqoSxfucDsFQSFb_DnTZKV7Xx2vx_V_w1klkpERbfw-UB5jvqTDs67QhluXN559PO_BKRdz7Eh6AvPrNw3XZYdhq3M2by4wpklINzQTWJk0PoyamjTfCE2Bgk2WznMM5a7qaYRUAl3vjxm5dDc8KgdMdlcZLuKt5aVnC1voNNy15de4ebhwHBY7PxuUFuF))

![][image8]

```

```

Descripción: {Descripción detallada del proceso propuesto}

Mejoras implementadas:

- {Mejora 1}  
- {Mejora 2}  
- {Mejora 3}

Métricas esperadas: | Métrica | Valor Esperado | Mejora | |---------|----------------|--------| | Tiempo promedio | {Valor} | {%} | | Errores por proceso | {Valor} | {%} | | Costo por operación | {Valor} | {%} |

**7.3 Diagramas de Secuencia Principales**  
{Diagramas que muestran las interacciones entre componentes para procesos clave}  
Proceso 1: Verificación de Acceso con NFC  
Diagrama de secuencia:([link](https://img.plantuml.biz/plantuml/svg/ZLPDRnit4BtlhnZeaXQG4YDDBWPSHB4SG4MT2BAINWmKe-NO8ReY5oHNA1Bun-IOGqxv2VfZUSDTIokfgMt01tBVVBnvCqEzYeb3QbOLVP1WRsp9fVLkN9OI_TitvqLHS9bye8kO6cFP9I6E934LDUniQMlSqM1SrtIv-RwsrK2_SrtlVv_OMFjearrxWjiCSZVbWPFPb5vp-Oyuqtcn-u3N78MCq8IJZnbYbWTnE7vSUWw6ncPbNOl1NL6SdT4iUAMb7dPaDz-TNhICwUoiA42EHhzhUdIAUmab1wgRAafWkfo-6Sylj2XspIY6aYWKkhMOI98IHQMILtLck__zJv50xwSJZTfvlGUWR01SkBNb5bB9vflnnIwS5bPH6Mm1dhsxMj2pTKSdZ3Zpk7QV6sk6r2mxGOUKx0h4aD9Ttvk5R_Y1ExE4jtFlObDfyhBJk_OvcPqPYWxqQ9j3bgDluSarLLKOwPiKNAL-6wqtNoeBSeI_VWxtqkGSs7ZAJZfSpv-UzzAuo718ThwOVdZNVfT3YwDmAbT0go1UihL6QmluYxWKsF2po4YJVtqu_WBcoEBjOZwUZ1yRVYwtDY9GGCbapUXN7CMLbXyEEDvYANHk33yOUDjdSy5CEapKyvCJD4nib7ayfHGQ6Lwxdg2dcA74UfSonq57Sd3NzrtlUlpIjvnCsncET3gvglWOEfSwUDEKDb3q3Wr1cw__sjJgdUS2K1t9hLV4xwQrLkKIRAxT7mqxccs-1lb48vgwswTqfTLPSHpiado2UKuD1FtKJRue9T4v3SBLdZhO6eZvboolF5PIegO66q6XL2Z_TzidRMNk3hJIXPDbK1yxNzlOWTR8ZOz2zsMxzr48LaH_Rfm_7frZJL-Sl42g4eBNUksResLyRcxV2VYVscNRnwXWnCajgmYpRaawtsl8mMCqtmNh-EfPDsHiHVm_gYzp-swfPaiBgi4Ty6ljnjMAIz5vX_ZOZX-nhsvkAklavxLOUUJOH_si99SzuBN3EasStmBMrwWjY0-30YzSqL-FkeZtZdN_sBunNXSh5ht67DwtrABjeEGnNIXNHNNxnftIyz5l5EMsSSR7dZ4Y3TlDi_3mGHN-FUOeln8ILGzYz0fMASUYU8LCyUFW1m00))

Descripción: {Descripción de las interacciones}

Componentes participantes:

- {Componente 1}  
- {Componente 2}  
- {Componente 3}

Proceso 2: Sincronización de Datos Offline  
Diagrama de secuencia:([link](https://img.plantuml.biz/plantuml/svg/ZLNRQXin47tVhnZorDAOlWTSuZIb1Ep6jKil432AD3PgTwMjf3L9Gpuep_a4_rXdfBMyQpiGFycZexcSEJDxxeDmeQbAc6iZdJNwdv3QcklbijG6YwAewLvBNGiJu6HKrp3PFAzrUGB2WwZh_ltywrW7XB6L8Y7ytv8CUw1x8s6ERgqb9X0Pzk9Ch-12o3zeL1j8zm4JQrRsyW96eHG-GYgs5CLm29SOK4gzUJQW4AQR9wUq4dp-Q0tUnOlXi2WeUnXyu2BWB3qYBg3UuYM1PT1hEgijDfL3y17V4Bgooe9joHBHIFTjrPpCgAo4H2CgZIROn4oCNbfBNBBLCGNQn80nkmBejn_nSoESeeX2IlGMQgA67-EDUMYqEeMWAwHcLZKVQtiApQsMiPUFqL_hQ90h9ZAMsb5saP1LTAziDtR2JQod51smzqwn53yME4FPrEX49lmr9ETImR7RnWabCiSiZpEuCjHixeUpiM3VqITpj2ERrLF4Lrs-hcy36dGKOAMf0EjtbFcYGqORRaoWg974hmVJ3QciRpis5OwaGUbcnpk_YUSs4P8ikPrUpx_1UxODakD1on-rRUjWKR8eEXrSC3vrBLV94y26jZ-QGqJ9Kv3lwFIIckr0DNL91yNLMdTZtf0quDtEyzk-qpGpR4gk1Zdl6VgcZFrUjyvbLcRoKGRuOe6wwCbHZXllZgHuPJmwxlosw0myZDpIgjEJVP-xbiqRPjJ3WrOBp-j4MVUOmGU2c0Wde_IgVcVpYtZ0qYDSRii1D2HLal_BMVmGpcYpWeTxiKXil3A7Gyvs2NnopjB46TZMzLBq12GfQTAV8OAF14_8gRCh9whOWWHEWNcESt25HxJHCR8Au-0VL3RMLQr5TzpwqtCuSRECn59NsgGXIuxpnfZtfvwPgqiCWiQdv_yCVfu2CXb8vr-FHIVfk22w_zljV7JB6HjsSeVDqvqcddh86GPRvTLlqcUIdY5OcXK6dMRPZyN-te9A6FmTlowq1sIm_iRSmugsYWc40MxDol4tXvUH4e59EIVEwHlz7m00))

![][image9]

**7.4 Diagramas de Estado**  
{Diagramas que muestran los estados de entidades importantes}  
Estado de: {Entidad}  
Diagrama:([link](https://img.plantuml.biz/plantuml/svg/XLNDRjim3BxxAOYSjW41zdSAsc31K1Ix5UlMop0Cgiman6pHa-IWsD27wJFq4V9YeomvyU_cWo5J7yMF7qNwW_FA-heiu4fMET-Y8pPVNQqiSPPbtrvzX-Lo3RTaDhL7uqah2olOL8MiD1sV3P0XJIfNMIP7U1nW_sGWpz0_HG33KF2kHWazYVl2Fz6imDH5CRb_WxOanquWP7QruUmno_gWGF_qQN8MBmb9viNBnBUt6UaEy7UgeBnPQuiv6actG3U5_CW6jOzGDh2v-JI5IbbLQ78IEmRIFKYFSpou4nWEnwT0o8sTXlhqtCYS78UfZpDlehPbwjMe3qcvn9Ed0ESIAKSx8yQeNFEADFIUIUCRkBY8g_MwsMmlNzfkR2qqs1CxkRbrJafqb6YM2xYyX0MUZ8ivlsjv2wJZj8kMMOzDNfBfu5NuNWop6TEAqePdYl8TMjYp3NRtVo0vprRg2PNbYgBWZpCKsWn7yS-fovcqRIwBqXhTcC4PAcMLoBy5YWyQAos30ly13smjLcozNBtxuvCZdKwVenlb7P5jLR-McafCYL_7ZL7m5Xb2UvQB9XVNdKZCeQLdjxIhfG3WH5qiLMBPxSgP_fB6uDhBA1a2cxQuUgZ8Tje43g4NfKjI-_L1CV6XOvZ8OSfYDAb9q6VyLHDQb5oNpN2RHALMRST0Colxc8bPgQJgIujRYsu_WHuAaf2mLKLnV9wQnQ6hHNIqGN1r_ezacM7Hn7C5l1rDJ2fHX5x1kzVWK0Pzc28Dtj9kxuF7CDjDXxWKjcNsmyTA90cQC-xPUovxOLDKB2k67E4WKtC5RzytZUgolm00))

![][image10]  
Estados:

-   
- SinAutenticar: Usuario no ha ingresado credenciales válidas  
- Autenticando: Proceso de validación de credenciales en curso  
- Autenticado: Usuario con sesión válida y permisos asignados  
- TokenExpirado: Sesión vencida que requiere renovación

Transiciones:

- login(): Inicia proceso de autenticación con credenciales  
- Credenciales válidas: API confirma usuario y devuelve tokens  
- Credenciales inválidas: API rechaza login, retorna a estado inicial  
- logout(): Usuario cierra sesión manualmente  
- Token vencido: Sistema detecta expiración automática  
- auto-refresh: Intenta renovar token automáticamente


Estado de: Registro de Asistencia  
Diagrama:([link](https://img.plantuml.biz/plantuml/svg/ZLRDRjD04BxxAVQCL06Lk5XLLQinnGX2ITeWX52rMQ-JbUpTi3yHBUh3y02SU8I-63Esr-l4JcWEYUFzPkURcMzczy9OggshIfB2KwvcV2MCrIenyCCb4pIAecyllfEJatDopMKkkBISn6Jg-5OHoXWtYkJSSeRcKGIxm7f0_ee8VFgMgTbmJMMko9QM8gTCFFsL0zGSzd4c9jVfT99DhmRhDwBYuAlQn8JHZNKQlJz6KS0WuqNj0Nt1Jbe1MQg9RcFqP0Ee8TitMd0j2i7gV-3FvOB2tWFOfPB6bRR-jwI6avnQPGOm7zGY-P1DaXiVL_tLS65h9HX_JSxEcgVpythHLw1Thjzvw4wSdsGf9ERd7RqdJ4d-iylkEBueMeEva7i6FLhx-pU9sWcly-npGPBhZ719hE3LHa7MQNd4QX6qG8IiE2JQqXh_U9XCItwCJHTNHuTHjkQaL6oKHuVl4yb50VNFFG-GLwWcfh7j5beND-taGRPFlm6c1cYsfWy3i5G7yJ-Su9hF-5OOeIG6GmtgSCEXCKkltnwB9XCxj9AcHQ6qXT0LTia0ucKvIw-o-KqwIoSZ626PLb8W_vXOxVZBWfQ6ZmluzBY0Jtk2FAtVzxTlYjO84KfWDl1-MVA1JTVgmPWrQJggvHrNGJfx32ROm2XVm_KMQgCF0yrwgQZEOHXQ1mLyy3aU0VjCpxzEBzii3-HzAAn0zKZWgbH8kiwQ4LPirJEimaJUJTf_VErEw3kCAJIAbwQNl5TcQ874dnsIhu8imtfGvVlqygRJP01yL1XVtFO3Jkdc2F2kzxh7CnWqrPG34G4JGa2OUekd7YglejAresB4AB3xV9lDqldTB5rawPT3S3XFLn9fqvYi7AW53jR-QRMNtQCjeV7WmmEFHWDFWwcKRBHQucCJJeNE3fc5r8RdlbdKsnaj4XXXblOELwmceVXMwQS_ICzlyonuMxaErrIiP-Pl9w3JQbDog_O1lYh9xIJpakajPx9obi8iQIOOLg1RHOOufMBo5gP7pal212lXaY0LSD9YjRP45Jl7ETv1bBFzUqnCNh-2aR5oW32DwL9PgogqFTnBYRFgnDnB1gTKJiaRKWdfhD-Xv4NjUqoxq0EeV4Azh32dS1sImFm2_C7LxXy0))

![][image11]

Estados:

- SinAutenticar: Usuario no ha ingresado credenciales válidas  
- Autenticando: Proceso de validación de credenciales en curso  
- Autenticado: Usuario con sesión válida y permisos asignados  
- TokenExpirado: Sesión vencida que requiere renovación


Transiciones:

- login(): Inicia proceso de autenticación con credenciales  
- Credenciales válidas: API confirma usuario y devuelve tokens  
- Credenciales inválidas: API rechaza login, retorna a estado inicial  
- logout(): Usuario cierra sesión manualmente  
- Token vencido: Sistema detecta expiración automática  
- auto-refresh: Intenta renovar token automáticamente

**8\. Vista de Despliegue**  
{Descripción de cómo se despliega el sistema en la infraestructura física}

**8.1 Diagrama de Contenedor**  
Diagrama de Arquitectura de Contenedores (Estilo C4):([link](https://img.plantuml.biz/plantuml/svg/ZLNDRjiu4BxpAMQzXzqzE6tY12cC8gWiMHktTkordEOI8A0fsk6M8WMHQc8KVQGzzH7oOZkaVcovEHG87CxCDnzdXZEZ3yRImfQPX8ZdKkyohkndmPy8-Itb6w4upEQZoNJy4CwdyoNyFXx4Pt7K6aT1-6by4xNMT_75-5rhZO9LC0gIrZcEuy7uRMk-3fRHNR3ScmVZY_Y24FD5g9mMD0Ecirmh32cnEycXuCnIjPNy068UQQgVXDh2Xah32Va30cPrmGsXxZ_q_YvfaGhQ0sh0dnj3a6P22MCBP2YysMiSnJN2dcZ1WJzRNYXDsgkXjoZndeB2JHp2R19Z0juNnOTHGHcNtCBxzuyrmzNLSPxV283I5jCHsqSBUjDnHID08XIiATxyyX_rYaMXhMPQQd_h99d3wVdv-G1jNAMUZNntSOTIOBKuP2y_lWfv67MGIy4e4oy_5CIoj4ZkmwxFGPvZq9bU2-b2xZow2xXz2UYv2196bQePKAx5BYxvPoembAbcL7gWFqMZ8zHECKXuyLKmxb5EKSjTP53QHvZfj9GLqCcLMEK-KPk2SdpEajaItsT9XNoYEyAaBbFerI8i9BKRNMIUer5s-zWbV52w4MLVN9c3nGHkTCfF_ZNUkT5_yqzq4EduESV-CuZpcTLrghN7u8ztAvY9D9NSjOj7ekeOvOh-cKgHKYkqQkg-rnpZPrEiX-NROe-VJGyqYFzUbMr43OSK_wZLfYdMJAkjZaOGM4chP1lDqKoxtD6JhXrBBvIbmMQ2sTdUfz4rLP8IAuiH6EXHMMPAL_o9BLECt8HQ_Wmi3Swjg96tE7slmwZ1QUQAYJhc03jRfLGn_YhSFOT7U_2Yabw7OZVep74nbBbvM9U6rtMPLWvrDKCqFtiCyRi6-lshmnaRmZntouFYkHvIltH-0LVndPnSTLVD4FSTBnY5lDfBz-giVmui8-I0ph4txJg4wzLgaRnPZfELw-bxzJ6Ptv3z67jqfxlGPn8r5pWJgMVPGmyc5e6HwoFSQXk9EvxiXzH3NRCF_UzAOp24D44vOzDYm_Pq9t05DxllNgt21PnTlZsz9FKixTsQBXj2kBoDgkBvjoETjgySt9EvMwQmvAQKrX3Y5xBLkLl7pUA0TZs4RYfGncoqmSJnSuDIE7aJHh0GEVUfjfkuGrQdWl3EJ3cPAhhbAUoNtPBx9OqQ2tyEa2pbvgzZthMsLcUlV3QgRn76IeqH34u_eUwolzwXp-qaylGqxMibTmUK7_28N___0G00))

![][image12]

```

```

Descripción de contenedores:

| Contenedor | Tipo | Tecnología | Descripción | Comunicación |
| ----- | ----- | ----- | ----- | ----- |
| App Móvil Flutter | Cliente móvil | Flutter 3.x, Dart, SQLite | Aplicación multiplataforma para guardias. Escaneo BLE, registro de accesos, consultas. Modo offline con sincronización. | HTTPS REST API (JSON), WebSocket para real-time |
| Dashboard Web | Cliente web | React/Vue.js, Chart.js, Axios | SPA para administradores. Visualización de datos, reportes, gestión de usuarios, ML predictions. | HTTPS REST API (JSON) |
| API Gateway | Proxy/Balanceador | nginx / AWS ALB | Punto de entrada único. Rate limiting (100 req/min/IP), SSL termination, load balancing, CORS. | TLS 1.3 hacia clientes, HTTP interno |
| Backend API | Servidor aplicación | Node.js 18 LTS, Express.js, JWT | Lógica de negocio, autenticación JWT, validación, orquestación de servicios, business rules. | REST JSON, MongoDB driver |
| MongoDB Atlas | Base de datos | MongoDB 6.0, Replica Set | BD NoSQL en cloud. 5 collections principales. Replica set 3 nodos para HA. Backups automáticos. | MongoDB Wire Protocol (TCP 27017\) |
| ML Module | Worker procesamiento | Python 3.10, TensorFlow, Pandas | Análisis predictivo asíncrono. Entrenamiento de modelos, predicciones, recomendaciones. Queue-based. | Bull.js Queue (Redis), File system para modelos |
| Redis Cache | Cache en memoria | Redis 7.x | Cache de sesiones JWT, rate limiting, cola de jobs ML. TTL 15 min para datos frecuentes. | Redis Protocol (TCP 6379\) |
| Sistema Académico | Sistema externo | Várelo (JDBC/REST) | BD institucional de estudiantes (read-only). Sincronización diaria 2:00 AM. | JDBC/REST API según disponibilidad |

- 

**8.2 Diagrama de Despliegue**  
{Diagrama que muestra los nodos físicos y la distribución de los componentes}

Diagrama:([link](https://img.plantuml.biz/plantuml/svg/dLPBR-Cs4BxhLqpJGtSFTc8xBnX1iF936sFjjM0dpIN0WfPePpOogIKf9sxHdzJJtdhD7-kGaXN9CDfj0GCMvyMPRrxye0rJ9bidCE1f8hThBim0sKgnjUVzGiGb2bGGoKGghY6L2Woc4c8EGiRI-ocs4Xpwu-dTu4j_EfxEuETX9sW7Wv8tcVP6us79l0pEXfSbyyQV3UxzMSaEWg0pFF4y_OGYPUI6lOVFpJRXe7Xac5WblCBLZooMpoXMi6I9hd8YkKwbe7ZsbIckp-Gxp1WcpsmB_KHciMUlWQCQ3SA4cQLKwoDWUYUUSwwk8lj_VLsB_7SFWE349OiC72rOzCH5t60fDhzgPwENa_n2XiHBB-68dE8a2ArBc6N2u9ex7KikpdNvuKjAET5MPSxLXYidNb1p2YdGhs81cithVI-W2_mhZpB3IBQcxgIhsbrGcT0WXVT72UD4YfKSzC0t2TC5Z3KQWPbfKxZdA0NX7r2iXBcpTTuySHRSUIXML3qa63F35apJdIpYN7-95xaGGp7evU5N55n0EOzYMN5jK0fcWn7IS5X8O-GQvBBcfZNHXhV3MQizwS7Cdz1t-sCFvaOgjhBEpAY7C6AK3WFlEgvozNkFe0PhtZKKwbHgDBYH6jQltpUOK5lv8bOITpLOaTbnSkZoxm7VOCG9kxLSa3Q1LskmUWtceB0qRRBqgMh53p_LOGwIpDYSL4kleEtSgwAjloLe-9T4HYnf5g2FxM7dPG5-tOJ3_ys3MkNjIJOQrti6IJhX_9ZhIE62vnLu64-SpWzWILJd9lt_JmmnPJiBez3_OVoiEp-4dVMiZXjH76RvZOVmiX8bLix08Pnkc8gVcUBmEUWNq8GPpKjb1qpGXyaee26SpvkWtrCKSyAD9eGU2qt2Q6zMx_UfCq5zmhJ625gVyaPqrFuZfWUwh7eL6PkZW0MZc5x_j07UZGRm-fV0IC85BBQ6MvdHV0gjqzFJ3jnkKmv-hRj6OgaODRNA8fCf1dS2QOffZ5avttaCznXWbUNyt9tDrh6lhWGtpr8zKTXxSSvaPlCSAXGH5KHIpfkSKHVseuYcAOGIXSbNW3NlXxeOJQMQos71emJ6I57W8jiM-UkJlHUQLLJSiTrbiLUV1bPxBuHk7kZbIRlPQWdlhUh_NNQFQnLgswyBDxUtuVpuTZo7LhFp84Af351Il9gOrQlD-swvBEwHQZ5KqaXwMZo8stu8xOkJrWLzaisXYDGsjRDvBtPRgkzI9LzmRJFtVWy5jwwgvTjr6grEy-nySlFRWsWtJgCrA7e7y0eW_qdDhJt3N1uYAPQueagByFMxoAlRoDIMTXK8IhIV6Tc8ooSMB1Lrm4SqDzc2kFtHSNy08QOyoRVQK6nGIU54VsKAsI9nrUzWX_byRA6lbBwxMU7gqHnONdao2BKDnbnrmR-Vkrsr8aoxaEa6PzeqMaIp3uCifI53sT_2EJpAJEbyWo8jENfbTOkLVZUgtFw1Fka9-JS0))

![][image13]

```

```

Descripción de nodos de despliegue:

| Nodo | Tipo | Especificaciones | Componentes Desplegados | Propósito |
| :---- | :---- | :---- | :---- | :---- |
| Railway Cloud | Plataforma Cloud | Node.js 18, CPU 1 vCPU, RAM 512MB | Backend API Express.js, JWT middleware, NFC validation | Hosting backend con auto-scaling |
| MongoDB Atlas M2 | Base datos cloud | MongoDB 6.0, RAM 512MB, Storage 2GB | 11 collections, índices optimizados | Persistencia datos con alta disponibilidad |
| Dispositivos Android | Cliente móvil | Android 8.0+, RAM 2GB+, NFC support | Flutter app, SQLite local, NFC service | Operación guardias en campo |
| Dispositivos iOS | Cliente móvil | iOS 12.0+, RAM 2GB+, NFC support | Flutter app, SQLite local, Core NFC | Operación guardias en campo |
| Pulseras NFC MIFARE | Hardware IoT | MIFARE Classic 1K, ISO 14443-A | UID único 7 bytes, memoria 1KB | Identificación estudiantes |
| Red WiFi Universidad | Infraestructura red | 802.11n/ac, Firewall institucional | Routers, Access Points, DMZ | Conectividad institucional |

Nodo 1: Railway Cloud Platform

Especificaciones técnicas:

- Sistema operativo: Linux (contenedor Docker)

- CPU: 1 vCPU compartido

- RAM: 512MB base (escalable hasta 4GB)

- Almacenamiento: Efímero (código desde GitHub)

- Red: HTTPS 443, auto-SSL con Let's Encrypt

Componentes desplegados:

- Backend API Node.js (index.js \- 1320 líneas)

- Express.js server con 30+ endpoints

- JWT authentication middleware

- NFC validation logic

- ML integration endpoints

Configuración:

- Auto-deployment desde GitHub main branch

- Variables de entorno para MongoDB connection

- CORS configurado para dominios móviles

- Rate limiting 100 req/min por IP

Nodo 2: MongoDB Atlas Cluster M2

Especificaciones técnicas:

- Sistema operativo: MongoDB Atlas managed service

- CPU: Shared (AWS m5.large equivalent)

- RAM: 512MB

- Almacenamiento: 2GB SSD con replica set

- Red: MongoDB Wire Protocol TCP 27017, TLS 1.2

Componentes desplegados:

- MongoDB 6.0 Community Edition

- 11 collections implementadas:

  * alumnos (8,000+ documentos)

  * usuarios (20+ guardias)

  * asistencias (50,000+ registros)

  * presencia (tiempo real)

  * recomendaciones\_buses (ML data)

Configuración:

- Replica Set con 3 nodos (HA)

- Backup automático cada 6 horas

- Indices compuestos para performance

- Connection pooling con max 10 connections

Nodo 3: Dispositivos Móviles Flutter

Especificaciones técnicas:

- Sistema operativo: Android 8.0+ / iOS 12.0+

- CPU: ARM64 mínimo 1.5GHz

- RAM: 2GB mínimo, 4GB recomendado

- Almacenamiento: 100MB app \+ SQLite local

- Red: WiFi 802.11n/ac, NFC ISO 14443

Componentes desplegados:

- Flutter app (acees\_app v1.0)

- SQLite database para modo offline

- NFC service (flutter\_nfc\_kit)

- HTTP client para API REST

- Provider state management

Configuración:

- Sync automático cada 5 minutos

- Cache local para 100 estudiantes

- Timeout HTTP 30 segundos

- NFC polling cada 500ms cuando activo

**9\. Vista de Implementación**  
{Descripción de la organización del código y los componentes del sistema}

**9.1 Diagrama de Componentes**  
{Diagrama que muestra los componentes del sistema y sus dependencias}

Diagrama de componentes general:([link](https://img.plantuml.biz/plantuml/svg/XLVTRjis5BxNKt3PHJSCAPe66OfU39Lj2Sbc9PxjUBiOK30IxN2HIKEacgH3dcgFi1VReNweGufEWG2nl_ETF_Byq9-KffMkzoMPolr12YRqZDDTHVTHz8OaIlDIAb8malTYfgBl2hRbWf5qVhjU9ylFqvlvpP9ydvodxzEPbKxYwM_9zSnAFwGNoGShdSNhU1AlabwSfkbvyiwAap_1y7Kyj-Bpv2AzY2BrmCM1GdZaGFC7kcCh_LmoKh5SKx4h6IBOY8zJr3qjv2CNExAbfM9Hr1ab9sbPQyqg4XyEv8Tiiyb-F25KaGvUT3Jt0Fw9286_DsHA3zISsOR3wG9YhMuuUrGd3P4CyP6JkTnnOOID4_lDfwrqNS273QlubkTKSpaezRA0MbpikPXHTNydQLLOZGOEyPVi82kjB15z1-hBE4lscCc2bNwc3HXADwxrlIMqiHWaytdNwTIb6M34idaWSmqqOg941cuFPg7S6ffKEBEZMTsgcbPS3fPl5QlwWt4ZBkkzGCJkxi9S1KN4HCufIWzgK1HKv2oeigYOyZGwoF97YQvOzONdt4sr1Ldm2W-yaxOHsQ-1EyJ4uQjFlDbkI-XyJ7QXKJSyYnopqVSHbIa5pUAm7GWVoOGgPewae1f6NobpQauCM_jzpZM3DWL9Qwi1PXDlg4KlQA1Cu0DS6eaNLsQWJDjvqg7zF757vZ1FfD2LB65MmJNY2-e49QkEjTd0i7qsG4VcYwSpGaT-R3dwtWA28ptfQOvGNosRUneOmBUPyQ8esIEjcDF45WsSswz_hB4SZ3k8Jz_GaXVDCFQqGW9VUNgpN7bgBeHpiKtQrmrEQL8hw1NLhe_yI3dW3kXi83WqVsqENXSFWl7Ln8AMpp2tiCg0VgkFkxZSTdunpUJtPYR5JiucGvFDgAPaJfzDJPZyWKRlZCf9HuMIBAbg0-eGxo4oEZRQ36k5Mm7g4iei3oLVjqj0sGNm2fVQqQv6xN9Cvz3FTcUi7-V3gqVkZLKe6wYEptUrOies3DBg3lWINWYcx0XxWdUEa17UApMyaQhs-absbSRBfAy6g-Q-sun5Q4lsr3ZlNq-42sERgiY-TCZfwI_z8m2zP1guNVfsoxVKRi6ZZTxWmpAFMciDEYpYnbQ3EJjtWFtLsZdop5WtGHti6Yt6mGbQWiZpmCHE4Unv7GJHOB0HUNjpOBQPeyP2dqEQxjTMkzjruQizxGUJvzFTE-GZkLol5okoJ5RhKNZ-kdcL7LenhogCDelBThFgbxOjM2yFOz3T3UFe3IUu2OAX7sMFunux3uKNcFBX6DsPVZIum7GEXuO6Vl1GJsVTS8x68TfsmzFJ2H2N2YQDmnkLoRUuWQ4wvDAbXcGskV_-5UOG_MR4q_5ZCpeNbTGob-LVukpyxSNFsUNNA18INfHQ7eZSUZyoOJQRtvzaGGreHZNeV-457FDAKz3Ag00Q37aDigvZJxUyKfh4LNuFtPhh6gh35B9nupfpNw2DiodobJoPZQFU_Wqj3h-OsQEi7W0-V_TJqoya4SL1Gdiet_oTr5hkZOT-InDoTaQ6WpFl0AYS4dx8miD6a-mz05UYO4-i85jPaGMhuD_UN1eo_Wa-rlloVm00))  
![][image14]

```

```

**9.2 Descripción de Componentes**  
Los componentes del sistema están organizados siguiendo patrones arquitectónicos establecidos y principios de responsabilidad única.

| Componente | Tipo | Responsabilidad | Interfaces | Dependencias |
| ----- | ----- | ----- | ----- | ----- |
| NFCViewModel | ViewModel Flutter | Gestión estado NFC y validación estudiantes | Provider notifyListeners() | NFCService, ApiService, AlumnoModel |
| ApiService | Service Flutter | Comunicación HTTP con backend | Future\<response\> métodos REST | http package, SessionService |
| AuthController | Controller Node.js | Autenticación JWT y gestión sesiones | POST /auth/login, /auth/logout | bcrypt, jsonwebtoken, MongoDB |
| NFCValidationService | Service Node.js | Validación pulseras NFC y lógica negocio | validateNFCId(), getStudentData() | MongoDB alumnos collection |
| OfflineService | Service Flutter | Persistencia local y sincronización | saveLocal(), syncPending() | SQLite, SyncService |
| MLAnalysisService | Service Node.js | Análisis predictivo y recomendaciones ML | analyzePatterns(), getBusRecommendations() | TensorFlow.js, MongoDB ML collection |

Componente 1: NFCViewModel (Flutter)

Descripción: ViewModel principal que gestiona el estado de lectura NFC, validación de estudiantes y registro de asistencias siguiendo el patrón MVVM.

Responsabilidades:

- Activar/desactivar escáner NFC usando flutter\_nfc\_kit

- Procesar UIDs de pulseras MIFARE Classic leídas

- Validar estudiantes contra base de datos via ApiService

- Determinar si es entrada o salida basado en última asistencia

- Manejar casos de error y reconexión automática

- Persistir datos offline cuando no hay conectividad

Interfaces provistas:

| Interface | Descripción | Métodos/Operaciones |
| :---- | :---- | :---- |
| Provider\<nfcviewmodel\> | Estado reactivo para UI | startScanning(), stopScanning(), validateStudent() |
| NFCTagListener | Callback para lectura NFC | onNFCTagDetected(String uid) |

Interfaces requeridas:

| Interface | Descripción | Proveedor |
| :---- | :---- | :---- |
| NFCService | Comunicación con hardware NFC | flutter\_nfc\_kit package |
| ApiService | Validación estudiante remota | ApiService component |
| OfflineService | Persistencia local | OfflineService component |

Componente 2: AuthController (Node.js)

Descripción: Controlador backend que maneja toda la lógica de autenticación, incluyendo login, logout, validación de tokens JWT y gestión de sesiones de guardias.

Responsabilidades:

- Validar credenciales de guardias contra colección usuarios

- Generar y firmar tokens JWT con expiración configurable

- Verificar tokens en requests autenticados via middleware

- Gestionar logout y blacklist de tokens

- Auditar intentos de login y actividad de usuarios

Interfaces provistas:

| Interface | Descripción | Métodos/Operaciones |
| :---- | :---- | :---- |
| POST /auth/login | Endpoint autenticación | {username, password} → {token, user} |
| POST /auth/logout | Endpoint cierre sesión | {token} → {success} |
| POST /auth/change-password | Cambio contraseña | {currentPassword, newPassword} → {success} |

Interfaces requeridas:

| Interface | Descripción | Proveedor |
| :---- | :---- | :---- |
| MongoDB usuarios | Persistencia usuarios | MongoDB Atlas |
| bcrypt | Hash contraseñas | bcrypt library |
| jsonwebtoken | Gestión tokens JWT | jsonwebtoken library |

Componente 3: ApiService (Flutter)

Descripción: Servicio centralizado para comunicación HTTP con el backend API, incluyendo manejo de autenticación, retry logic y transformación de datos.

Responsabilidades:

- Realizar requests HTTP REST al backend Railway

- Incluir headers de autenticación JWT automáticamente

- Manejar timeouts y reconexión automática

- Transformar responses JSON a modelos Dart

- Cachear responses para modo offline

- Implementar retry exponential backoff

Interfaces provistas:

| Interface | Descripción | Métodos/Operaciones |
| :---- | :---- | :---- |
| Future\<user\> | Autenticación | login(username, password) |
| Future\<student\> | Consulta estudiante | getStudent(String id) |
| Future\<void\> | Registro asistencia | registerAttendance(AttendanceModel) |
| Future\>\<list\<report\> | Reportes | getReports(filters) |

**9.3 Estructura de Directorios**  
Estructura del Monorepo:

```
access-control-system/
├── mobile-app/                    # Aplicación Flutter
│   ├── lib/
│   │   ├── main.dart
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   ├── theme/
│   │   │   ├── utils/
│   │   │   └── network/
│   │   ├── data/
│   │   │   ├── models/           # Data models
│   │   │   ├── repositories/     # Repository implementations
│   │   │   ├── datasources/      # Local (SQLite) y Remote (API)
│   │   │   └── providers/        # State management
│   │   ├── domain/
│   │   │   ├── entities/         # Business entities
│   │   │   ├── usecases/         # Business logic
│   │   │   └── repositories/     # Repository interfaces
│   │   ├── presentation/
│   │   │   ├── screens/          # Login, Dashboard, AccessRegistry
│   │   │   ├── widgets/          # Reusable components
│   │   │   ├── blocs/            # BLoC state management
│   │   │   └── providers/
│   │   └── services/
│   │       ├── ble_service.dart  # Bluetooth Low Energy
│   │       ├── api_service.dart  # HTTP client
│   │       ├── storage_service.dart # SQLite local
│   │       └── sync_service.dart # Offline sync
│   ├── test/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── backend-api/                   # API REST Node.js
│   ├── src/
│   │   ├── controllers/
│   │   │   ├── auth.controller.ts
│   │   │   ├── access.controller.ts
│   │   │   ├── student.controller.ts
│   │   │   ├── report.controller.ts
│   │   │   └── ml.controller.ts
│   │   ├── services/
│   │   │   ├── auth.service.ts
│   │   │   ├── access.service.ts
│   │   │   ├── student.service.ts
│   │   │   ├── sync.service.ts
│   │   │   └── ml.service.ts
│   │   ├── repositories/
│   │   │   ├── user.repository.ts
│   │   │   ├── student.repository.ts
│   │   │   ├── access.repository.ts
│   │   │   └── bracelet.repository.ts
│   │   ├── models/
│   │   │   ├── user.model.ts      # Mongoose schemas
│   │   │   ├── student.model.ts
│   │   │   ├── access.model.ts
│   │   │   └── bracelet.model.ts
│   │   ├── middlewares/
│   │   │   ├── auth.middleware.ts
│   │   │   ├── rbac.middleware.ts
│   │   │   ├── rateLimit.middleware.ts
│   │   │   └── errorHandler.middleware.ts
│   │   ├── validators/
│   │   │   ├── auth.validator.ts
│   │   │   ├── access.validator.ts
│   │   │   └── schemas/           # Joi schemas
│   │   ├── dtos/
│   │   │   ├── auth.dto.ts
│   │   │   ├── access.dto.ts
│   │   │   └── student.dto.ts
│   │   ├── config/
│   │   │   ├── database.ts
│   │   │   ├── redis.ts
│   │   │   ├── jwt.ts
│   │   │   └── app.ts
│   │   ├── utils/
│   │   │   ├── logger.ts          # Winston config
│   │   │   ├── jwt.ts
│   │   │   ├── encryption.ts
│   │   │   └── validators.ts
│   │   ├── workers/
│   │   │   ├── etl.worker.ts      # Sync BD académica
│   │   │   ├── ml.worker.ts       # ML training
│   │   │   └── email.worker.ts    # Email queue
│   │   ├── routes/
│   │   │   ├── index.ts
│   │   │   ├── auth.routes.ts
│   │   │   ├── access.routes.ts
│   │   │   └── api.v1.ts          # API versioning
│   │   └── app.ts
│   ├── test/
│   ├── migrations/
│   ├── .env.example
│   ├── package.json
│   └── tsconfig.json
│
├── ml-module/                     # Módulo Python ML
│   ├── src/
│   │   ├── models/
│   │   │   ├── linear_regression.py
│   │   │   ├── clustering.py
│   │   │   └── time_series.py
│   │   ├── training/
│   │   │   ├── train.py
│   │   │   └── evaluate.py
│   │   ├── prediction/
│   │   │   └── predict.py
│   │   └── data/
│   │       ├── preprocessing.py
│   │       └── export.py
│   ├── models/                    # Modelos entrenados
│   ├── requirements.txt
│   └── main.py
│
├── dashboard-web/                 # Dashboard React/Vue
│   ├── src/
│   │   ├── components/
│   │   │   ├── charts/
│   │   │   ├── tables/
│   │   │   └── forms/
│   │   ├── pages/
│   │   │   ├── Dashboard.tsx
│   │   │   ├── Reports.tsx
│   │   │   ├── Guards.tsx
│   │   │   └── MLPredictions.tsx
│   │   ├── services/
│   │   │   ├── api.service.ts
│   │   │   └── websocket.service.ts
│   │   ├── store/                 # Redux/Vuex
│   │   ├── utils/
│   │   └── App.tsx
│   ├── public/
│   ├── package.json
│   └── vite.config.ts
│
├── docs/                          # Documentación
│   ├── vision-documento.md
│   ├── factibilidad-documento.md
│   ├── srs-formato-documento.md
│   └── sad-formato-documento.md
│
├── scripts/                       # Scripts de utilidad
│   ├── setup-dev.sh
│   ├── seed-database.js
│   └── deploy.sh
│
├── .github/
│   └── workflows/
│       ├── ci-backend.yml
│       └── ci-mobile.yml
│
├── docker-compose.yml
├── README.md
└── .gitignore
```

Descripción de directorios principales:

Backend API:

- controllers/: Manejo de HTTP requests, validación de entrada, respuestas HTTP  
- services/: Lógica de negocio, orquestación, reglas de negocio  
- repositories/: Abstracción de acceso a datos, implementación del patrón Repository  
- models/: Schemas de Mongoose, definición de estructura de datos  
- middlewares/: Interceptores: autenticación, autorización, rate limiting, error handling  
- validators/: Schemas de validación Joi, reglas de negocio  
- dtos/: Objetos de transferencia de datos, transformaciones  
- workers/: Procesos background: ETL, ML training, email queue

Mobile App:

- data/: Capa de datos con datasources (local SQLite, remote API)  
- domain/: Lógica de negocio independiente de framework  
- presentation/: UI, screens, widgets, state management (BLoC)  
- services/: Servicios específicos: BLE, API client, storage, sync

**9.4 Dependencias Externas**  
Backend API (Node.js):

| Dependencia | Versión | Propósito | Licencia |
| :---- | :---- | :---- | :---- |
| express | ^4.18.0 | Framework web para API REST | MIT |
| mongoose | ^7.0.0 | ODM para MongoDB | MIT |
| jsonwebtoken | ^9.0.0 | Generación y validación de JWT | MIT |
| bcrypt | ^5.1.0 | Hashing de contraseñas | MIT |
| joi | ^17.9.0 | Validación de schemas | BSD-3-Clause |
| ioredis | ^5.3.0 | Cliente Redis para cache | MIT |
| bull | ^4.11.0 | Queue system para jobs asíncronos | MIT |
| winston | ^3.10.0 | Logging estructurado | MIT |
| express-rate-limit | ^6.10.0 | Rate limiting | MIT |
| helmet | ^7.0.0 | Security headers | MIT |
| cors | ^2.8.5 | Cross-Origin Resource Sharing | MIT |
| dotenv | ^16.3.0 | Variables de entorno | BSD-2-Clause |
| socket.io | ^4.6.0 | WebSocket para real-time | MIT |
| nodemailer | ^6.9.0 | Envío de emails | MIT |

Mobile App (Flutter):

| Dependencia | Versión | Propósito | Licencia |
| :---- | :---- | :---- | :---- |
| flutter\_blue\_plus | ^1.14.0 | Bluetooth Low Energy scanner | BSD-3-Clause |
| http | ^1.1.0 | Cliente HTTP para API | BSD-3-Clause |
| provider | ^6.0.5 | State management | MIT |
| flutter\_bloc | ^8.1.3 | BLoC pattern implementation | MIT |
| sqflite | ^2.3.0 | SQLite database local | MIT |
| shared\_preferences | ^2.2.0 | Almacenamiento clave-valor | BSD-3-Clause |
| dio | ^5.3.0 | HTTP client avanzado | MIT |
| freezed | ^2.4.0 | Code generation para models | MIT |
| get\_it | ^7.6.0 | Dependency injection | MIT |
| flutter\_secure\_storage | ^9.0.0 | Almacenamiento seguro de tokens | BSD-3-Clause |

Dashboard Web (React):

| Dependencia | Versión | Propósito | Licencia |
| :---- | :---- | :---- | :---- |
| react | ^18.2.0 | Framework UI | MIT |
| axios | ^1.5.0 | Cliente HTTP | MIT |
| chart.js | ^4.4.0 | Gráficos y visualizaciones | MIT |
| react-chartjs-2 | ^5.2.0 | Wrapper React para Chart.js | MIT |
| antd / mui | ^5.x | UI Component library | MIT |
| redux / zustand | ^4.x / ^4.x | State management | MIT |
| socket.io-client | ^4.6.0 | WebSocket client | MIT |
| date-fns | ^2.30.0 | Manejo de fechas | MIT |
| jspdf | ^2.5.0 | Generación de PDFs | MIT |

ML Module (Python):

| Dependencia | Versión | Propósito | Licencia |
| :---- | :---- | :---- | :---- |
| tensorflow | ^2.13.0 | Machine learning framework | Apache 2.0 |
| scikit-learn | ^1.3.0 | ML algorithms (clustering, regression) | BSD-3-Clause |
| pandas | ^2.1.0 | Manipulación de datos | BSD-3-Clause |
| numpy | ^1.25.0 | Computación numérica | BSD-3-Clause |
| pymongo | ^4.5.0 | Driver MongoDB para Python | Apache 2.0 |
| joblib | ^1.3.0 | Serialización de modelos | BSD-3-Clause |

**9.5 Gestión de Configuración**  
Estrategia: Configuración externalizada mediante variables de entorno con archivos .env por ambiente.

Archivos de configuración:

- .env.development: Configuración para desarrollo local  
- .env.staging: Configuración para ambiente de pruebas  
- .env.production: Configuración para producción (encriptada en CI/CD)  
- config/app.ts: Carga y valida variables de entorno

Variables de entorno críticas (Backend):

```shell
# Application
NODE_ENV=production
PORT=3000
API_VERSION=v1

# Database
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/db
MONGODB_MAX_POOL_SIZE=100

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=secret

# JWT
JWT_SECRET=<secret-key-256-bits>
JWT_EXPIRATION=8h
JWT_REFRESH_EXPIRATION=7d

# External Services
ACADEMIC_DB_URL=jdbc://academic.upt.edu.pe:3306/students
EMAIL_SERVICE_API_KEY=<sendgrid-key>
EMAIL_FROM=noreply@upt.edu.pe

# BLE Configuration
BLE_SCAN_TIMEOUT=10000
BLE_MAX_DEVICES=10

# ML Configuration
ML_MODEL_PATH=./models/
ML_TRAIN_SCHEDULE="0 2 * * 0" # Domingos 2:00 AM
```

Variables de entorno (Mobile App \- Flutter):

```
// lib/core/config/env.dart
class Environment {
  static const String API_BASE_URL = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.accesscontrol.upt.edu.pe/v1'
  );
  static const int BLE_SCAN_DURATION = int.fromEnvironment(
    'BLE_SCAN_DURATION',
    defaultValue: 10000
  );
}
```

Estrategia de configuración por ambiente:

| Ambiente | Propósito | MongoDB | Redis | Log Level |
| ----- | ----- | ----- | ----- | ----- |
| Development | Desarrollo local | MongoDB local o Atlas Sandbox | Redis local | DEBUG |
| Testing | QA y pruebas | Atlas M10 (cluster test) | Redis Cloud free | INFO |
| Staging | Pre-producción | Atlas M10 (staging cluster) | Redis Cloud | INFO |
| Production | Producción real | Atlas M10 (prod cluster, 3 nodos) | Redis Cloud Pro | WARN |

Gestión de Secrets:

- Secrets en producción se gestionan con AWS Secrets Manager o MongoDB Atlas API Keys  
- Nunca commitear archivos .env a Git (.gitignore)  
- CI/CD inyecta secrets desde variables cifradas del pipeline  
- Rotación de secrets críticos (JWT\_SECRET, DB passwords) cada 3 meses

**10\. Vista de Datos**  
El sistema utiliza MongoDB (NoSQL) como base de datos principal, con esquema flexible pero estructurado. A continuación se presenta el modelo de datos conceptual.

**10.1 Modelo de Datos MongoDB**  
Diagrama de Colecciones y Relaciones:([link](https://img.plantuml.biz/plantuml/svg/jLVXRjms3Fxlfz2o7scn1CWM10WEHT4ikGkAfacHfJ-6j31uakwYLfOCIKxHfdc4FSqUeIysIh9b-SuxP0lovt0cQOhyI7wYNra7nZML92VWuArcN1O_CRuGYfFBwV7LqVdfsPHG2TOMnJOvyHfX2DLI6sv9hGrnejRfdUdvrUkhFylZYxEBI_BpT7_ss-maASykBjwyVvUKXxE3wM6cFEqqizbiVxgND6_Fac9_UZ0xy84SQoavTK8h3C88HKKDajiYH4f0DfNIbhnuGPFTovTuP1xTNK58ATY4NCm_eSbhHfwzU_CSXRkx-4Cr4qiz8NyuzBuapzu7bTBLtF1EYWAekPI2QPl9U0L2Pi-EIxxGIkScbZPSGYPP06sa0vQ9BA-uTVwuywQQSnFUGvFSqK8xNJOcFsx1wGsKr72WcFR45vOdCL3NW1JVSjrzqSBMs0QCU1nkW-Gxs6hq_aKRrijlmDvmzc18ZUvzNcylCKmcO7k7R0EhXDh-wCzebDEsf5gvO7ra37ozZkzuFMOkRX6wtxMM71HA46zHwLBgfLY5wV-W1rPOnx4JuL40njvTqS-2lgtFgCvFOGOHHnI01OWiHep_4aOzH7s72jzfKDKftsOkQ9lbdGJNjU0EaMhPFToZNGKA4SbHLGiQ0apEzTnoSnkSyS6OX5ukxLT5apI1MIEx12oV2CgKSTaYbJBlDH6uf8ZW9VEKHvHtnYlfPIM9AJaUshQ9VtrHM6C2E2N5GnkRJNjekjKs6zHm3Pq1nMv6PpXutQWof2OZwbZwbCn3ss5zo6wq2JsBKuttZCaHwbHKS3DWWD4PJ01qJ5cs9Ffu3CeHycqrwqGzVZ6i9xuv2SQfiBxeSO16SZXzK0ARA653-mDTAN2bO_mRA47K9J26JPmFCUCEC6xR7T5dU8Dig8q0MLQ8sABjdoT954S9Po-lNYiPMA-bZJFfonCdigbP-mzN8DwEvYs4DQS4d5Kyt6HvzahLy5kTAnu4NSB9yj07xPts9FWu_PchyjCNbo64QnnYKSRJUzgFLoBYnAtUN7baC5F24f7Exsu_1j2FGShISAehhbXx3PHpV7tzcaoRtkPSSrwCDB9ElwPn-QEcJHrP5cdu5biJCfv5Cbq8KDzo6SWbTg-hyfcemK35aNT7grqY5joCKnRdR0xqSrcjJ_e3Snu0-9-t0mDEz4nDhd_TFVWO4aUNBknyUMjKjUH1mGQCjjhNztuHlqHsZ3Kjkgtx-_VTNNqts8ScP2kYirMa9NFSpF0bFeyPhb9cC0xRsBhjlv0Fli8H66oDzLTMvX1DmuYCMERLHBFQQFmCylxHTXM4Vez1IoSGWwrLav6y03lSnrYCZyru76WhvkWUYtAk7VWx9Yib5J_-LeNIZYCTr4GlqaVIX1pkxEtj_K8O3ectrVQ3-l6NOe9wlelttKvSx8SE1fKxs8jUsW8EdQIhQAVlekXhhftJbNStdki4F_z8x1tcSn9O2l1HyW_gI67vCGYFCXxaRx2YU8Kky7ls7m00))  
![][image15]

```

```

**10.2 Descripción de Entidades**  
Colección: users (Usuarios Guardias y Administradores)  
Descripción: Almacena las cuentas de usuarios del sistema (guardias de seguridad y administradores). Maneja autenticación, autorización y asignación de puntos de acceso.

Atributos:

| Atributo | Tipo de Dato | Restricciones | Descripción |
| ----- | ----- | ----- | ----- |
| \_id | ObjectId | PK, AUTO | Identificador único de MongoDB |
| email | String | UNIQUE, REQUIRED, INDEX | Email institucional del usuario |
| password | String | REQUIRED | Hash BCrypt de la contraseña (factor 12\) |
| role | String | ENUM\['guard', 'admin'\] | Rol del usuario para RBAC |
| name | String | REQUIRED | Nombre completo del usuario |
| active | Boolean | DEFAULT: true | Estado de activación de la cuenta |
| accessPoints | Array\[String\] | \- | Lista de puntos de acceso asignados |
| lastLogin | Date | \- | Última fecha de login exitoso |
| createdAt | Date | AUTO | Timestamp de creación |
| updatedAt | Date | AUTO | Timestamp de última actualización |

Índices:

- {email: 1} (unique) \- Para login rápido  
- {active: 1, role: 1} \- Para filtrado de usuarios activos por rol

Validaciones:

- Email debe ser formato válido (@upt.edu.pe)  
- Password mínimo 8 caracteres  
- Role solo puede ser 'guard' o 'admin'

Colección: students (Estudiantes)  
Descripción: Contiene información de estudiantes universitarios sincronizada desde la BD académica institucional. Se actualiza diariamente.

Atributos:

| Atributo | Tipo de Dato | Restricciones | Descripción |
| ----- | ----- | ----- | ----- |
| \_id | ObjectId | PK, AUTO | Identificador único |
| studentCode | String | UNIQUE, REQUIRED, INDEX | Código único del estudiante (2019063854) |
| name | String | REQUIRED | Nombre(s) del estudiante |
| lastName | String | REQUIRED | Apellidos del estudiante |
| email | String | UNIQUE | Email institucional |
| photoUrl | String | \- | URL de foto del estudiante |
| career | String | REQUIRED | Nombre de carrera (Ing. Sistemas) |
| semester | Number | \- | Semestre académico actual |
| enrollmentStatus | String | ENUM\['active', 'inactive', 'graduated', 'suspended'\] | Estado de matrícula |
| enrollmentExpiry | Date | \- | Fecha de vencimiento de matrícula |
| active | Boolean | DEFAULT: true | Estado activo del estudiante |
| syncedAt | Date | \- | Última sincronización con BD académica |
| createdAt | Date | AUTO | Timestamp de creación |
| updatedAt | Date | AUTO | Timestamp de actualización |

Índices:

- {studentCode: 1} (unique) \- Búsqueda por código  
- {enrollmentStatus: 1, active: 1} \- Filtrado de estudiantes activos  
- {career: 1} \- Reportes por carrera  
- {name: 'text', lastName: 'text'} \- Búsqueda textual

---

Colección: accesses (Registros de Acceso)  
Descripción: Colección principal que registra cada entrada/salida de estudiantes. Datos críticos para reportes y ML. Retención mínima 2 años.

Atributos:

| Atributo | Tipo de Dato | Restricciones | Descripción |
| ----- | ----- | ----- | ----- |
| \_id | ObjectId | PK, AUTO | Identificador único del registro |
| studentId | ObjectId | REQUIRED, INDEX | Referencia a students.\_id |
| braceletId | ObjectId | INDEX | Referencia a bracelets.\_id |
| guardId | ObjectId | REQUIRED, INDEX | Referencia a users.\_id (guardia que registró) |
| accessType | String | ENUM\['entry', 'exit'\], REQUIRED | Tipo de acceso |
| accessPoint | String | REQUIRED | Nombre del punto de acceso |
| timestamp | Date | REQUIRED, INDEX | Fecha y hora exacta del acceso |
| location | Object{lat, lng} | \- | Coordenadas GPS del punto de acceso |
| manual | Boolean | DEFAULT: false | Si fue autorización manual |
| notes | String | \- | Notas del guardia (si es manual) |
| syncStatus | String | ENUM\['synced', 'pending', 'failed'\] | Estado de sincronización offline |
| createdAt | Date | AUTO | Timestamp de creación del registro |

Índices:

- {studentId: 1, timestamp: \-1} (compound) \- Historial por estudiante  
- {timestamp: \-1} \- Consultas por fecha (reportes)  
- {accessPoint: 1, timestamp: \-1} \- Flujo por punto de acceso  
- {guardId: 1, timestamp: \-1} \- Actividad por guardia  
- {syncStatus: 1} \- Cola de sincronización offline

TTL Index:

- Opcional: {createdAt: 1} con expireAfterSeconds: 63072000 (2 años)

Colección: bracelets (Pulseras Inteligentes)  
Descripción: Gestiona el inventario y estado de pulseras BLE, su asociación con estudiantes y estado de batería.

Atributos:

| Atributo | Tipo de Dato | Restricciones | Descripción |
| ----- | ----- | ----- | ----- |
| \_id | ObjectId | PK, AUTO | Identificador único |
| braceletId | String | UNIQUE, REQUIRED, INDEX | ID único de la pulsera (16 caracteres) |
| studentId | ObjectId | INDEX | Estudiante asociado (null si no asignada) |
| status | String | ENUM\['active', 'inactive', 'lost', 'damaged'\] | Estado de la pulsera |
| batteryLevel | Number | MIN: 0, MAX: 100 | Nivel de batería (%) |
| lastSeen | Date | \- | Última detección exitosa |
| assignedAt | Date | \- | Fecha de asignación al estudiante |
| active | Boolean | DEFAULT: true | Si está operativa |
| createdAt | Date | AUTO | Fecha de registro en sistema |
| updatedAt | Date | AUTO | Última actualización |

Índices:

- {braceletId: 1} (unique) \- Búsqueda por ID  
- {studentId: 1} \- Relación con estudiante  
- {status: 1, active: 1} \- Inventario activo

Validaciones:

- braceletId debe ser alfanumérico de 16 caracteres  
- batteryLevel entre 0-100  
- Una pulsera activa solo puede estar asociada a un estudiante

---

Entidad 2: {Nombre de la Entidad}  
{Repetir estructura para cada entidad}

**10.3 Ejemplos de Documentos**  
Ejemplo documento collection users:

```json
{
  "_id": ObjectId("65b1234567890abcdef12345"),
  "email": "jperez@upt.edu.pe",
  "password": "$2b$12$KIXvZ9V3qQy7h8N2xPl.7eY8QwR3tN9fL6mK4hJ8gF2dS1aP0oI9u",
  "role": "guard",
  "name": "Juan Pérez García",
  "active": true,
  "accessPoints": ["Puerta Principal", "Biblioteca"],
  "lastLogin": ISODate("2025-10-23T08:15:00Z"),
  "createdAt": ISODate("2025-09-01T10:00:00Z"),
  "updatedAt": ISODate("2025-10-23T08:15:00Z")
}
```

Ejemplo documento collection students:

```json
{
  "_id": ObjectId("65b9876543210fedcba98765"),
  "studentCode": "2019063854",
  "name": "César Fabián",
  "lastName": "Chávez Linares",
  "email": "2019063854@upt.edu.pe",
  "photoUrl": "https://cdn.upt.edu.pe/students/2019063854.jpg",
  "career": "Ingeniería de Sistemas",
  "semester": 10,
  "enrollmentStatus": "active",
  "enrollmentExpiry": ISODate("2025-12-31T23:59:59Z"),
  "active": true,
  "syncedAt": ISODate("2025-10-23T02:05:00Z"),
  "createdAt": ISODate("2019-03-15T00:00:00Z"),
  "updatedAt": ISODate("2025-10-23T02:05:00Z")
}
```

Ejemplo documento collection accesses:

```json
{
  "_id": ObjectId("65c1111222333444555666777"),
  "studentId": ObjectId("65b9876543210fedcba98765"),
  "braceletId": ObjectId("65d9999888777666555444333"),
  "guardId": ObjectId("65b1234567890abcdef12345"),
  "accessType": "entry",
  "accessPoint": "Puerta Principal",
  "timestamp": ISODate("2025-10-23T07:45:32.156Z"),
  "location": {
    "lat": -18.0156,
    "lng": -70.2458
  },
  "manual": false,
  "notes": null,
  "syncStatus": "synced",
  "createdAt": ISODate("2025-10-23T07:45:32.156Z")
}
```

Ejemplo documento collection bracelets:

```json
{
  "_id": ObjectId("65d9999888777666555444333"),
  "braceletId": "BR2024UPT0001234",
  "studentId": ObjectId("65b9876543210fedcba98765"),
  "status": "active",
  "batteryLevel": 85,
  "lastSeen": ISODate("2025-10-23T07:45:32Z"),
  "assignedAt": ISODate("2025-09-15T10:00:00Z"),
  "active": true,
  "createdAt": ISODate("2024-08-01T00:00:00Z"),
  "updatedAt": ISODate("2025-10-23T07:45:32Z")
}
```

Ejemplo documento collection audit\_logs:

```json
{
  "_id": ObjectId("65e1234567890abcdef98765"),
  "userId": ObjectId("65b1234567890abcdef12345"),
  "action": "UPDATE_GUARD",
  "entity": "users",
  "entityId": ObjectId("65b9999888777666555444"),
  "changes": {
    "accessPoints": {
      "old": ["Puerta Principal"],
      "new": ["Puerta Principal", "Biblioteca"]
    }
  },
  "ipAddress": "192.168.1.105",
  "userAgent": "Mozilla/5.0...",
  "timestamp": ISODate("2025-10-23T09:30:15Z")
}
```

Ejemplo documento collection ml\_predictions:

```json
{
  "_id": ObjectId("65f1111222333444555666"),
  "predictionType": "peak_hours",
  "date": ISODate("2025-10-24T00:00:00Z"),
  "timeSlot": "07:30-07:45",
  "predictedFlow": 245,
  "confidence": 0.87,
  "modelVersion": "v1.2.3-linear-regression",
  "createdAt": ISODate("2025-10-23T02:15:00Z")
}
```

**10.4 Modelo Físico**  
Motor de base de datos: MongoDB Atlas (Cloud-hosted NoSQL)

Versión: MongoDB 6.0 Community Edition

Configuración del Cluster:

- Tier: M10 (Dedicated cluster)  
- Region: AWS São Paulo (sa-east-1) \- Más cercano a Perú  
- Replica Set: 3 nodos (Primary \+ 2 Secondary)  
- Storage: 40 GB SSD (auto-scaling habilitado)  
- RAM: 2 GB por nodo  
- Backup: Continuous backup con retention de 7 días

Configuración de Base de Datos:

- Character encoding: UTF-8  
- Write Concern: majority (garantiza escritura en mayoría de nodos)  
- Read Preference: primaryPreferred (lectura de Primary, fallback a Secondary)  
- Connection String: mongodb+srv://cluster0.xxxxx.mongodb.net/access\_control\_db

Particionamiento (Sharding): Para escalabilidad futura, se prepara sharding por rango de fechas en colección accesses:

- Shard Key: {timestamp: 1, studentId: 1}  
- Estrategia: Range-based sharding por año  
- Activación: Cuando se superen 10M de documentos

Replicación:

- Replica Set de 3 miembros:  
  - 1 Primary (lecturas y escrituras)  
  - 2 Secondary (lecturas con readPreference y respaldo)  
  - Automatic failover en caso de fallo del Primary  
- Oplog: 10% del storage para replicación  
- Write Concern: {w: 'majority', j: true} para operaciones críticas  
- Read Concern: {level: 'majority'} para lecturas consistentes

**10.5 Estrategia de Persistencia**  
Patrón utilizado: Repository Pattern con Data Access Layer (DAL)

ODM utilizado: Mongoose 7.x para MongoDB

Arquitectura de persistencia:

```
Service Layer
     ↓
Repository Layer (abstracción)
     ↓
Mongoose ODM
     ↓
MongoDB Driver
     ↓
MongoDB Atlas
```

Estrategias de caché:

1. Caché de Estudiantes (Redis L1):  
     
   - TTL: 15 minutos  
   - Cache key: student:{studentCode}  
   - Invalidación: Al sincronizar BD académica  
   - Hit rate esperado: 80% (estudiantes frecuentes)

   

2. Caché de Sesiones JWT (Redis):  
     
   - TTL: Tiempo de expiración de token (8 horas)  
   - Cache key: session:{userId}:{tokenId}  
   - Permite invalidación de tokens

   

3. Caché Local SQLite (Mobile):  
     
   - Datos de estudiantes activos (top 1000\)  
   - Registros pendientes de sincronización  
   - Configuración del sistema

   

4. Cache-Aside Pattern:  
     
   - Check cache → Si miss, consultar BD → Guardar en cache  
   - Implementado en StudentRepository y BraceletRepository

Optimizaciones:

1. Índices Compuestos:

```javascript
// Historial de estudiante (query más frecuente)
accesses.createIndex({studentId: 1, timestamp: -1})

// Reportes por fecha
accesses.createIndex({timestamp: -1, accessPoint: 1})

// Búsqueda de estudiantes
students.createIndex({studentCode: 1}, {unique: true})
students.createIndex({name: 'text', lastName: 'text'})
```

2. Connection Pooling:  
     
   - Pool size mínimo: 10 conexiones  
   - Pool size máximo: 100 conexiones  
   - Connection timeout: 30 segundos

   

3. Lean Queries:  
     
   - Mongoose .lean() para queries de solo lectura (30% más rápido)  
   - Select solo campos necesarios  
   - Evitar population innecesaria

   

4. Batch Operations:  
     
   - insertMany() para múltiples registros offline  
   - bulkWrite() para operaciones mixtas  
   - Lotes de máximo 1000 documentos

   

5. Agregación Optimizada:  
     
   - Pipelines con $match temprano para filtrar datos  
   - $project para reducir tamaño de documentos en pipeline  
   - Uso de allowDiskUse para agregaciones grandes

**10.6 Migración y Versionamiento de Datos**  
Herramienta: migrate-mongo (Node.js migration tool para MongoDB)

Convención de nombrado:

```
migrations/
  ├── 20250124000001-create-users-collection.js
  ├── 20250124000002-create-students-collection.js
  ├── 20250124000003-create-accesses-collection.js
  ├── 20250124000004-add-indexes-accesses.js
  └── 20250124000005-add-bracelet-status-field.js
```

Formato: YYYYMMDDHHMMSS-description.js

Proceso de migración:

1. Desarrollo local:  
     
   - Crear script de migración: npm run migrate:create add-new-field  
   - Implementar funciones up() y down()  
   - Probar en ambiente de desarrollo  
   - Validar rollback funciona correctamente

   

2. Testing/Staging:  
     
   - Ejecutar migración: npm run migrate:up  
   - Validar integridad de datos  
   - Verificar performance de índices nuevos  
   - Probar rollback: npm run migrate:down

   

3. Producción:  
     
   - Backup completo pre-migración  
   - Ejecutar en ventana de mantenimiento (2:00-5:00 AM)  
   - Monitorear logs durante ejecución  
   - Validar post-migración con health checks  
   - Mantener plan de rollback listo

Estrategia de cambios de esquema:

- Adición de campos: Compatible hacia atrás, campos opcionales  
- Eliminación de campos: Marcar deprecated primero, eliminar en versión siguiente  
- Cambio de tipo: Migración de datos en batch con validación  
- Renombrado: Mantener ambos campos temporalmente, migrar gradualmente

**11\. Calidad**  
{Descripción de los atributos de calidad y cómo se logran}

Esta sección describe los escenarios de calidad que la arquitectura debe soportar, utilizando el marco de atributos de calidad.  
Plantilla de Escenario de Calidad  
Cada escenario de calidad se describe usando la siguiente plantilla:

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | {Nombre del atributo} |
| Estímulo | {Evento que dispara el escenario} |
| Fuente del Estímulo | {Origen del estímulo} |
| Artefacto | {Parte del sistema afectada} |
| Entorno | {Condiciones bajo las cuales ocurre} |
| Respuesta | {Cómo debe responder el sistema} |
| Medida de Respuesta | {Métrica cuantificable} |

---

11.1 Escenario de Seguridad  
Escenario SEC-001: Intento de Acceso No Autorizado

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Seguridad |
| Estímulo | Un usuario intenta acceder a recursos sin las credenciales apropiadas |
| Fuente del Estímulo | Usuario malintencionado o error del usuario |
| Artefacto | Módulo de autenticación y autorización |
| Entorno | Sistema en operación normal |
| Respuesta | El sistema rechaza el acceso, registra el intento y notifica al administrador si es necesario |
| Medida de Respuesta | \- 100% de intentos no autorizados son bloqueados \- Tiempo de respuesta \< 500ms \- Registro completo del evento con timestamp, IP y usuario |

Tácticas arquitectónicas aplicadas:

- Autenticación mediante JWT  
- Control de acceso basado en roles (RBAC)  
- Validación de tokens en cada petición  
- Registro de auditoría de accesos  
- Rate limiting para prevenir ataques de fuerza bruta

Componentes involucrados:

- Módulo de Autenticación  
- Módulo de Autorización  
- Sistema de Logging  
- API Gateway

Escenario SEC-002: Protección de Datos Sensibles

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Seguridad |
| Estímulo | Transmisión y almacenamiento de datos sensibles de usuarios |
| Fuente del Estímulo | Operaciones normales del sistema |
| Artefacto | Toda la aplicación |
| Entorno | Durante operación normal |
| Respuesta | Los datos sensibles son encriptados en tránsito y en reposo |
| Medida de Respuesta | \- 100% de datos sensibles encriptados \- Uso de TLS 1.3 para transmisión \- Encriptación AES-256 para almacenamiento |

Tácticas arquitectónicas aplicadas:

- Encriptación TLS 1.3 en todas las comunicaciones  
- Encriptación de datos sensibles en base de datos  
- Hashing de contraseñas con bcrypt  
- Tokenización de datos de pago  
- Sanitización de inputs

**11.2 Escenario de Usabilidad**  
Escenario USA-001: Facilidad de Aprendizaje

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Usabilidad |
| Estímulo | Un nuevo usuario intenta completar una tarea principal |
| Fuente del Estímulo | Usuario nuevo sin capacitación previa |
| Artefacto | Interfaz de usuario |
| Entorno | Uso normal del sistema |
| Respuesta | El usuario completa la tarea exitosamente sin ayuda externa |
| Medida de Respuesta | \- 90% de usuarios completan la tarea en el primer intento \- Tiempo promedio \< 5 minutos \- Menos de 3 errores por usuario |

Tácticas arquitectónicas aplicadas:

- Interfaz intuitiva siguiendo estándares de diseño  
- Tooltips y ayuda contextual  
- Mensajes de error claros y accionables  
- Feedback visual inmediato  
- Wizards para procesos complejos

Componentes involucrados:

- Capa de presentación  
- Sistema de ayuda contextual  
- Componentes de UI/UX

---

Escenario USA-002: Recuperación de Errores

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Usabilidad |
| Estímulo | Usuario comete un error al ingresar datos |
| Fuente del Estímulo | Usuario durante operación normal |
| Artefacto | Formularios y validaciones |
| Entorno | Operación normal |
| Respuesta | El sistema muestra mensajes claros y permite corrección fácil |
| Medida de Respuesta | \- Mensajes de error específicos y comprensibles \- Tiempo de corrección \< 30 segundos \- Preservación de datos ya ingresados |

Tácticas arquitectónicas aplicadas:

- Validación en tiempo real  
- Mensajes de error específicos y constructivos  
- Preservación del estado del formulario  
- Confirmación antes de operaciones destructivas  
- Capacidad de deshacer acciones

**11.3 Escenario de Adaptabilidad**  
Escenario ADA-001: Agregar Nueva Funcionalidad

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Modificabilidad/Adaptabilidad |
| Estímulo | Se requiere agregar un nuevo módulo de funcionalidad |
| Fuente del Estímulo | Nuevos requerimientos del negocio |
| Artefacto | Arquitectura del sistema |
| Entorno | En tiempo de desarrollo |
| Respuesta | El nuevo módulo se integra sin modificar componentes existentes |
| Medida de Respuesta | \- Menos del 10% del código existente requiere modificación \- Tiempo de integración \< 5 días \- Sin regresiones en funcionalidad existente |

Tácticas arquitectónicas aplicadas:

- Arquitectura modular en capas  
- Separación de responsabilidades (SRP)  
- Interfaces bien definidas  
- Inyección de dependencias  
- Principio Open/Closed

Componentes involucrados:

- Todos los módulos del sistema  
- Sistema de plugins/extensiones

---

Escenario ADA-002: Cambio de Proveedor de Servicios

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Adaptabilidad |
| Estímulo | Se requiere cambiar un servicio externo (ej: proveedor de email) |
| Fuente del Estímulo | Decisión del negocio |
| Artefacto | Módulo de integración con servicios externos |
| Entorno | Durante mantenimiento |
| Respuesta | El cambio se realiza modificando solo la capa de integración |
| Medida de Respuesta | \- Solo 1 componente requiere modificación \- Tiempo de cambio \< 2 días \- Sin impacto en otros módulos |

Tácticas arquitectónicas aplicadas:

- Patrón Adapter  
- Abstracción de servicios externos  
- Configuración externalizada  
- Patrón Strategy para algoritmos intercambiables

---

**11.4 Escenario de Disponibilidad**  
Escenario DIS-001: Recuperación ante Fallo de Servidor

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Disponibilidad |
| Estímulo | Fallo completo de un servidor de aplicación |
| Fuente del Estímulo | Fallo de hardware o software |
| Artefacto | Servidor de aplicación |
| Entorno | Operación normal con usuarios activos |
| Respuesta | El sistema redirige el tráfico a servidores de respaldo sin pérdida de servicio |
| Medida de Respuesta | \- Tiempo de detección del fallo \< 30 segundos \- Tiempo de recuperación \< 5 minutos \- Sin pérdida de transacciones en progreso \- Disponibilidad 99.9% |

Tácticas arquitectónicas aplicadas:

- Redundancia de servidores  
- Balanceador de carga  
- Health checks automáticos  
- Failover automático  
- Replicación de sesiones

Componentes involucrados:

- Load Balancer  
- Servidores de aplicación  
- Sistema de monitoreo  
- Base de datos replicada

---

Escenario DIS-002: Mantenimiento sin Interrupción

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Disponibilidad |
| Estímulo | Se requiere actualizar la aplicación |
| Fuente del Estímulo | Mantenimiento programado |
| Artefacto | Sistema completo |
| Entorno | Durante operación normal |
| Respuesta | La actualización se realiza sin interrumpir el servicio |
| Medida de Respuesta | \- Zero downtime deployment \- Sin sesiones de usuario interrumpidas \- Rollback disponible en caso de problemas |

Tácticas arquitectónicas aplicadas:

- Blue-Green Deployment  
- Rolling updates  
- Versionamiento de API  
- Backward compatibility  
- Feature toggles

---

**11.5 Escenario de Rendimiento**  
Escenario REN-001: Carga Concurrente de Usuarios

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Rendimiento |
| Estímulo | 1000 usuarios concurrentes realizando transacciones |
| Fuente del Estímulo | Usuarios durante horario pico |
| Artefacto | Sistema completo |
| Entorno | Operación normal en horario pico |
| Respuesta | El sistema mantiene tiempos de respuesta aceptables |
| Medida de Respuesta | \- Tiempo de respuesta promedio \< 2 segundos \- 95% de peticiones \< 3 segundos \- Throughput mínimo 100 TPS \- CPU \< 70% de utilización |

Tácticas arquitectónicas aplicadas:

- Caché distribuida (Redis)  
- Optimización de consultas a BD  
- Connection pooling  
- Procesamiento asíncrono  
- CDN para contenido estático  
- Compresión de respuestas

Componentes involucrados:

- Todos los componentes del sistema  
- Sistema de caché  
- Balanceador de carga  
- Base de datos optimizada

---

Escenario REN-002: Procesamiento de Operaciones Pesadas

| Elemento | Descripción |
| ----- | ----- |
| Atributo de Calidad | Rendimiento |
| Estímulo | Usuario solicita generación de reporte complejo |
| Fuente del Estímulo | Usuario autorizado |
| Artefacto | Módulo de reportes |
| Entorno | Operación normal |
| Respuesta | El proceso se ejecuta en background sin bloquear otras operaciones |
| Medida de Respuesta | \- Respuesta inmediata al usuario (\< 1 segundo) \- Reporte disponible en \< 5 minutos \- Sin impacto en otras operaciones |

Tácticas arquitectónicas aplicadas:

- Procesamiento asíncrono con colas  
- Worker threads  
- Notificaciones push al completar  
- Paginación de resultados  
- Cálculos incrementales

---

**11.6 Matriz de Atributos de Calidad**  
{Resumen de cómo la arquitectura soporta los atributos de calidad}

| Atributo de Calidad | Prioridad | Tácticas Principales | Métricas Objetivo | Estado |
| ----- | ----- | ----- | ----- | ----- |
| Seguridad | Alta | JWT, RBAC, Encriptación | 100% transacciones seguras | ✓ |
| Disponibilidad | Alta | Redundancia, Failover | 99.9% uptime | ✓ |
| Rendimiento | Alta | Caché, Async | \< 2s respuesta | ✓ |
| Usabilidad | Media | UI intuitiva, Feedback | \< 5 min aprendizaje | ✓ |
| Modificabilidad | Media | Modularidad, Interfaces | \< 10% código modificado | ✓ |
| Escalabilidad | Alta | Horizontal scaling | 2000+ usuarios | ✓ |

**CONCLUSIONES**  
La arquitectura de software propuesta para el Sistema de Control de Acceso con Pulseras Inteligentes cumple con los requerimientos funcionales y no funcionales especificados:

1. Arquitectura Multicapa Escalable: La arquitectura en tres capas (Presentación \- Flutter, Lógica de Negocio \- Node.js API, Datos \- MongoDB Atlas) permite una clara separación de responsabilidades, facilitando el mantenimiento, testing y escalabilidad del sistema. Cada capa puede evolucionar independientemente sin afectar las demás.  
     
2. Cumplimiento de Atributos de Calidad: Las estrategias arquitectónicas implementadas garantizan:  
     
   - Disponibilidad: 99.5% uptime mediante modo offline, replicación de BD y failover automático  
   - Seguridad: Múltiples capas de protección (JWT, TLS 1.3, BCrypt, RBAC) cumpliendo Ley N° 29733 y GDPR  
   - Rendimiento: Tiempos de respuesta \< 2 segundos mediante caché, optimización de consultas y procesamiento asíncrono  
   - Adaptabilidad: Arquitectura modular con patrones SOLID facilita cambios futuros

   

3. Tecnologías Apropiadas: La selección de Flutter (mobile), Node.js (backend), MongoDB Atlas (BD), Python/TensorFlow (ML) representa un stack tecnológico moderno, maduro y bien documentado que facilita el desarrollo, deployment y mantenimiento.  
     
4. Patrón de Diseño Efectivos: La aplicación de patrones como Repository (acceso a datos), Strategy (algoritmos ML), Adapter (servicios externos), Singleton (configuración) mejora la mantenibilidad, reusabilidad y testabilidad del código.  
     
5. Arquitectura Cloud-Native: El uso de MongoDB Atlas, hosting cloud y arquitectura stateless permite escalabilidad horizontal, alta disponibilidad y reduce la necesidad de infraestructura on-premise costosa.  
     
6. Modo Offline Crítico: La implementación de funcionalidad offline con sincronización posterior (SQLite local \+ cola de sincronización) es esencial para garantizar continuidad operativa ante fallos de conectividad, cumpliendo RNF-019.  
     
7. Seguridad por Diseño: La arquitectura incorpora seguridad desde el diseño (Security by Design), no como una adición posterior, mediante múltiples capas de validación, encriptación y auditoría en cada componente.  
     
8. Separación Mobile/Web: La separación entre aplicación móvil (guardias operativos) y dashboard web (administración/análisis) optimiza la experiencia de usuario según el contexto de uso y dispositivo.  
     
9. Machine Learning Desacoplado: El módulo de ML en Python opera de manera independiente y asíncrona, permitiendo actualizar modelos y algoritmos sin afectar las operaciones core del sistema de control de acceso.  
     
10. Trazabilidad y Monitoreo: La arquitectura incluye componentes de logging, auditoría y monitoreo que permiten rastrear todas las operaciones críticas, cumpliendo con requerimientos legales (RNF-012) y facilitando debugging y optimización.

**RECOMENDACIONES**  
Para asegurar una implementación exitosa de la arquitectura propuesta:

1. Implementación Incremental por Capas: Desarrollar primero la capa de datos y API REST, luego la aplicación móvil y finalmente el dashboard web. Esto permite testing temprano de la lógica de negocio y facilita la integración progresiva.  
     
2. Prototipo Inicial con Datos Mock: Crear un prototipo funcional con datos simulados antes de integrar con la BD institucional de estudiantes, permitiendo validación temprana de UX y flujos sin dependencias externas.  
     
3. Pruebas de Carga Obligatorias: Realizar pruebas de carga con herramientas como JMeter o k6 simulando 1000 usuarios concurrentes antes del deployment a producción, validando que se cumplan las métricas de rendimiento (RNF-005).  
     
4. Documentar Decisiones Arquitectónicas (ADRs): Crear Architecture Decision Records para todas las decisiones significativas (elección de tecnologías, patrones aplicados, trade-offs), facilitando mantenimiento futuro y onboarding de nuevos desarrolladores.  
     
5. Implementar Monitoreo desde el Inicio: Integrar herramientas de monitoreo (Prometheus \+ Grafana, New Relic, o Datadog) desde el primer sprint, no esperar a producción. Monitorear: latencia, errores, uso de recursos, logs estructurados.  
     
6. Pipeline CI/CD Completo: Establecer pipeline de integración y despliegue continuo con: tests automáticos, análisis de código estático (SonarQube), security scanning (OWASP Dependency-Check), despliegue automatizado a staging.  
     
7. Testing Exhaustivo del Modo Offline: Priorizar testing de sincronización offline-online con escenarios edge case: pérdida de conexión durante registro, múltiples accesos offline, conflictos de sincronización, límites de almacenamiento local.  
     
8. Seguridad Penetration Testing: Contratar security audit externo para penetration testing antes de producción, validando protección contra OWASP Top 10, especialmente inyección, broken authentication, y XSS.  
     
9. Backup y Disaster Recovery Probados: No solo configurar backups automáticos, sino probar periódicamente el proceso completo de restauración (Recovery Time Objective \< 30 minutos, Recovery Point Objective \< 24 horas).  
     
10. Capacitación Técnica del Equipo: Invertir en capacitación del equipo de TI institucional en Flutter, Node.js y MongoDB antes del handoff, incluyendo troubleshooting common issues y procedimientos de mantenimiento.  
      
11. Versionamiento Semántico Estricto: Adoptar SemVer (vX.Y.Z) para API REST, permitiendo evolución controlada sin romper clientes existentes. Documentar breaking changes claramente.  
      
12. Estrategia de Feature Flags: Implementar sistema de feature toggles desde el inicio para poder activar/desactivar funcionalidades en producción sin redeploy, facilitando releases graduales y rollback rápido.  
      
13. Optimización de Costos Cloud: Monitorear costos de MongoDB Atlas mensualmente, considerar reserved instances o savings plans para reducir costos operativos a largo plazo, optimizar queries costosas identificadas por profiling.  
      
14. Plan de Escalabilidad: Aunque el sistema soporta 500-1000 usuarios inicialmente, documentar estrategia de escalabilidad horizontal para crecimiento futuro: sharding de MongoDB, múltiples instancias de API con load balancer, CDN para assets.  
      
15. Revisión Arquitectónica Post-Implementación: Programar revisión formal de la arquitectura 3 meses después del go-live, comparando supuestos arquitectónicos vs realidad, identificando tech debt y planificando refactoring necesario.

**ANEXOS**  
**Anexo A: Glosario de Términos Técnicos**

| Término | Definición |
| ----- | ----- |
| Stateless API | API que no mantiene estado de sesión en el servidor, toda la información necesaria viaja en cada request (via JWT) |
| Replica Set | Grupo de instancias de MongoDB que mantienen el mismo dataset para alta disponibilidad y redundancia |
| Sharding | Técnica de particionamiento horizontal de datos en MongoDB para distribución y escalabilidad |
| Connection Pooling | Reutilización de conexiones de BD en lugar de crear/cerrar en cada request, mejora performance |
| Eventual Consistency | Modelo de consistencia donde las actualizaciones se propagan gradualmente, garantizando convergencia eventual |
| Middleware | Función interceptora que procesa requests antes de llegar al handler final (auth, logging, validation) |
| ODM (Object Document Mapper) | Herramienta que mapea documentos de MongoDB a objetos de código (Mongoose) |
| DTO (Data Transfer Object) | Objeto simple usado para transferir datos entre capas, sin lógica de negocio |
| Repository Pattern | Patrón que abstrae el acceso a datos detrás de una interfaz, desacoplando persistencia de lógica |
| Dependency Injection | Técnica donde las dependencias se proveen externamente en lugar de crearlas internamente |
| Rate Limiting | Restricción de número de requests permitidos por cliente en un período de tiempo |
| ETL (Extract, Transform, Load) | Proceso de extracción de datos de origen, transformación y carga en destino |
| Background Worker | Proceso que ejecuta tareas pesadas de manera asíncrona sin bloquear requests |
| Health Check | Endpoint que verifica el estado de salud del sistema y sus dependencias |
| Failover | Cambio automático a sistema de respaldo cuando el principal falla |
| Load Balancer | Distribuidor de tráfico entre múltiples instancias de servidores |
| TTL (Time To Live) | Tiempo de vida de datos en cache antes de expirar |
| Write Concern | Nivel de confirmación requerido de escritura en MongoDB (majority, acknowledged) |
| Read Preference | Configuración de desde qué nodo del replica set leer (primary, secondary) |
| Aggregation Pipeline | Serie de etapas de procesamiento de datos en MongoDB para transformaciones complejas |
| WebSocket | Protocolo de comunicación full-duplex sobre TCP para comunicación bidireccional en tiempo real |
| Idempotencia | Propiedad donde ejecutar una operación múltiples veces produce el mismo resultado |
| RBAC (Role-Based Access Control) | Control de acceso basado en roles de usuario |
| Audit Log | Registro inmutable de todas las acciones importantes para trazabilidad |
| Blue-Green Deployment | Técnica de deployment donde se mantienen dos ambientes idénticos para zero-downtime updates |

**Anexo B: Decisiones de Arquitectura (ADRs)**  
Las siguientes decisiones arquitectónicas documentan las elecciones técnicas más importantes del proyecto:

**ADR-001: Uso de MongoDB como Base de Datos Principal**

- Fecha: 2025-09-15  
- Estado: ✅ Aceptada  
- Contexto: Necesitamos una base de datos que soporte esquemas flexibles (estudiantes con diferentes estructuras según carrera), consultas rápidas, agregaciones complejas para reportes y ML, y alta disponibilidad en cloud.  
- Decisión: Usar MongoDB Atlas como base de datos principal NoSQL en lugar de PostgreSQL o MySQL relacional.  
- Alternativas consideradas:  
  - PostgreSQL con JSON fields  
  - MySQL con esquema rígido  
  - Firebase Firestore  
- Razones:  
  - Esquema flexible permite adaptarse a cambios en estructura de datos de estudiantes  
  - Agregación pipeline potente para reportes y análisis ML  
  - MongoDB Atlas ofrece 99.99% SLA con replica sets  
  - Sin costo de licencia (Community Edition)  
  - Escalabilidad horizontal con sharding  
- Consecuencias:  
  - ✅ Flexibilidad de esquema facilita cambios  
  - ✅ Agregaciones eficientes para reportes  
  - ✅ Alta disponibilidad out-of-the-box  
  - ⚠️ No soporta transacciones ACID complejas entre múltiples colecciones  
  - ⚠️ Requiere aprendizaje de query language específico  
  - ⚠️ Dependencia de servicio cloud de tercero  
    

**ADR-002: Flutter para Aplicación Móvil Multiplataforma**

- Fecha: 2025-09-18  
- Estado: ✅ Aceptada  
- Contexto: Necesitamos desarrollar app para Android e iOS con presupuesto limitado (S/. 127,300) y equipo pequeño (4 desarrolladores) en 4 meses.  
- Decisión: Desarrollar con Flutter en lugar de apps nativas separadas (Swift \+ Kotlin) o React Native.  
- Alternativas consideradas:  
  - Apps nativas (Swift para iOS, Kotlin para Android)  
  - React Native  
  - Ionic  
- Razones:  
  - Un solo codebase para Android e iOS (ahorro 40% tiempo)  
  - Performance cercano a nativo (mejor que React Native)  
  - Soporte excelente de BLE con flutter\_blue\_plus  
  - UI consistente con Material Design  
  - Hot reload para desarrollo rápido  
  - Documentación y comunidad muy activa  
- Consecuencias:  
  - ✅ Desarrollo 40% más rápido que nativo  
  - ✅ Mantenimiento unificado  
  - ✅ Performance adecuado para el caso de uso  
  - ⚠️ Tamaño de app mayor que nativo (\~50 MB)  
  - ⚠️ Acceso limitado a APIs nativas específicas (mitigado con plugins)  
  - ⚠️ Requiere aprendizaje de Dart por el equipo  
    

**ADR-003: Arquitectura Stateless con JWT para Escalabilidad**

- Fecha: 2025-09-20  
- Estado: ✅ Aceptada  
- Contexto: El sistema debe soportar 500-1000 usuarios concurrentes y escalar horizontalmente a futuro sin complejidad excesiva.  
- Decisión: Implementar API stateless con autenticación JWT en lugar de sesiones con estado en servidor.  
- Alternativas consideradas:  
  - Sesiones con estado en Redis  
  - OAuth 2.0 con servidor de autorizació externo  
  - Cookies de sesión  
- Razones:  
  - Stateless permite múltiples instancias de API sin sincronización de sesión  
  - JWT incluye toda la información necesaria (userId, role) en el token  
  - Escalabilidad horizontal simple (load balancer \+ N instancias)  
  - No requiere consulta a BD para validar cada request  
  - Estándar ampliamente adoptado  
- Consecuencias:  
  - ✅ Escalabilidad horizontal simple  
  - ✅ Sin single point of failure en sesiones  
  - ✅ Menor carga en BD  
  - ⚠️ No se pueden invalidar tokens antes de expiración (mitigado con blacklist en Redis)  
  - ⚠️ Tokens más grandes que session IDs  
  - ✅ Requiere HTTPS estricto para seguridad  
    

**ADR-004: Modo Offline Obligatorio para Aplicación Móvil**

- Fecha: 2025-09-22  
- Estado: ✅ Aceptada  
- Contexto: El Wi-Fi institucional no siempre es confiable y el control de acceso no puede detenerse por problemas de conectividad.  
- Decisión: Implementar funcionalidad offline completa con SQLite local y sincronización posterior (eventual consistency).  
- Alternativas consideradas:  
  - Sistema completamente online (sin funcionalidad si no hay internet)  
  - Cache simple sin capacidad de escritura offline  
- Razones:  
  - Control de acceso es función crítica que no puede fallar  
  - Permite continuar operando durante cortes de internet  
  - SQLite es liviano y confiable en Flutter  
  - Sincronización automática cuando se recupera conexión  
  - Cumple RNF-019 (tolerancia a fallos)  
- Consecuencias:  
  - ✅ Alta disponibilidad incluso sin internet  
  - ✅ Experiencia de usuario sin interrupciones  
  - ✅ Cumple RNF-019  
  - ⚠️ Complejidad adicional de sincronización  
  - ⚠️ Posibles conflictos de datos (resuelto con last-write-wins)  
  - ⚠️ Requiere almacenamiento local en dispositivos  
  - ✅ Incrementa confiabilidad general del sistema  
    

**ADR-005: Python con TensorFlow para Machine Learning**

- Fecha: 2025-09-25  
- Estado: ✅ Aceptada  
- Contexto: Necesitamos implementar análisis predictivo con regresión lineal, clustering y series temporales para optimizar transporte.  
- Decisión: Desarrollar módulo ML separado en Python con TensorFlow/Scikit-learn en lugar de integrar ML en Node.js.  
- Alternativas consideradas:  
  - TensorFlow.js en Node.js  
  - Azure ML / AWS SageMaker  
  - R para análisis estadístico  
- Razones:  
  - Python es el estándar de facto para ML con ecosistema maduro  
  - TensorFlow y Scikit-learn tienen algoritmos optimizados  
  - Separación permite procesamiento asíncrono sin afectar API  
  - Equipo cuenta con especialista ML en Python  
  - Abundante documentación y ejemplos  
- Consecuencias:  
  - ✅ Algoritmos ML optimizados y bien probados  
  - ✅ Separación de concerns (API no se ve afectada por entrenamiento)  
  - ✅ Procesamiento asíncrono vía queue  
  - ⚠️ Requiere deployment separado del módulo Python  
  - ⚠️ Comunicación vía files o API adicional  
  - ✅ Flexibilidad para cambiar algoritmos  
    

**ADR-006: WebSocket para Actualizaciones en Tiempo Real**

- Fecha: 2025-09-28  
- Estado: ✅ Aceptada  
- Contexto: El dashboard web necesita mostrar accesos en tiempo real sin recargar la página constantemente (polling ineficiente).  
- Decisión: Implementar WebSocket con Socket.IO para comunicación bidireccional en tiempo real.  
- Alternativas consideradas:  
  - HTTP Polling cada 5 segundos  
  - Server-Sent Events (SSE)  
  - Long Polling  
- Razones:  
  - WebSocket permite push instantáneo de actualizaciones  
  - Menor overhead que polling (sin headers HTTP repetidos)  
  - Socket.IO maneja reconexiones automáticas  
  - Soporta broadcasting a múltiples clientes  
  - Fallback automático a polling si WebSocket falla  
- Consecuencias:  
  - ✅ Updates en tiempo real (\< 2 segundos)  
  - ✅ Menor consumo de ancho de banda que polling  
  - ✅ Mejor experiencia de usuario  
  - ⚠️ Complejidad adicional de mantener conexiones abiertas  
  - ⚠️ Requiere manejo de reconexiones  
  - ⚠️ Más difícil de cachear que HTTP  
    

**ADR-007: Repository Pattern para Abstracción de Datos**

- Fecha: 2025-10-01  
- Estado: ✅ Aceptada  
- Contexto: Queremos desacoplar la lógica de negocio de la tecnología de persistencia específica (MongoDB).  
- Decisión: Implementar patrón Repository con interfaces claras en la capa de acceso a datos.  
- Alternativas consideradas:  
  - Active Record pattern  
  - Direct Mongoose models en services  
  - DAO pattern  
- Razones:  
  - Abstracción permite cambiar BD sin afectar lógica de negocio  
  - Facilita unit testing con mocks de repositories  
  - Separa concerns: Services se enfocan en lógica, Repositories en persistencia  
  - Queries complejas centralizadas en repositories  
  - Mejor mantenibilidad y testabilidad  
- Consecuencias:  
  - ✅ Alto desacoplamiento entre capas  
  - ✅ Fácil unit testing de services  
  - ✅ Queries centralizadas y reutilizables  
  - ⚠️ Capa adicional de abstracción (overhead mínimo)  
  - ✅ Mejor adherencia a principios SOLID

**Anexo C: Referencias Técnicas**  
**Documentación de frameworks y tecnologías:**

- Flutter Framework: [https://flutter.dev/docs](https://flutter.dev/docs) \- Documentación oficial completa  
- Dart Language: [https://dart.dev/guides](https://dart.dev/guides) \- Guía del lenguaje Dart  
- Node.js: [https://nodejs.org/docs](https://nodejs.org/docs) \- Runtime JavaScript  
- Express.js: [https://expressjs.com](https://expressjs.com) \- Framework web para Node.js  
- MongoDB: [https://docs.mongodb.com](https://docs.mongodb.com) \- Database NoSQL  
- MongoDB Atlas: [https://docs.atlas.mongodb.com](https://docs.atlas.mongodb.com) \- Cloud database platform  
- Mongoose ODM: [https://mongoosejs.com/docs](https://mongoosejs.com/docs) \- Object Data Modeling  
- TensorFlow: [https://www.tensorflow.org/api\_docs](https://www.tensorflow.org/api_docs) \- Machine learning framework  
- Scikit-learn: [https://scikit-learn.org/stable/documentation.html](https://scikit-learn.org/stable/documentation.html) \- ML algorithms  
- Redis: [https://redis.io/documentation](https://redis.io/documentation) \- In-memory data structure store  
- Socket.IO: [https://socket.io/docs](https://socket.io/docs) \- Real-time bidirectional communication  
- React: [https://react.dev](https://react.dev) \- UI library for web  
- Chart.js: [https://www.chartjs.org/docs](https://www.chartjs.org/docs) \- Charting library

**Especificaciones de protocolos:**

- Bluetooth Low Energy: [https://www.bluetooth.com/specifications/bluetooth-core-specification](https://www.bluetooth.com/specifications/bluetooth-core-specification)  
- REST API Design: [https://restfulapi.net](https://restfulapi.net)  
- JWT RFC 7519: [https://tools.ietf.org/html/rfc7519](https://tools.ietf.org/html/rfc7519)  
- WebSocket RFC 6455: [https://tools.ietf.org/html/rfc6455](https://tools.ietf.org/html/rfc6455)  
- OAuth 2.0: [https://oauth.net/2/](https://oauth.net/2/)

**Estándares aplicados:**

- IEEE 1471-2000: Recommended Practice for Architectural Description  
- ISO/IEC 25010:2011: Systems and software Quality Requirements and Evaluation (SQuaRE)  
- ISO/IEC 27001:2013: Information Security Management Systems  
- OWASP Top 10: Web Application Security Risks 2021  
- WCAG 2.1: Web Content Accessibility Guidelines  
- Ley N° 29733: Ley de Protección de Datos Personales del Perú  
- GDPR: General Data Protection Regulation (EU)

**Patrones y prácticas:**

- Design Patterns (GoF): Repository, Strategy, Adapter, Observer, Singleton, Factory  
- Architectural Patterns: Layered Architecture, Client-Server, MVC, Microservices principles  
- SOLID Principles: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion  
- Clean Architecture: Robert C. Martin \- Separation of concerns, dependency rule  
- 12-Factor App: Methodology for building SaaS applications

**Bibliografía:**

- Martin, R. C. (2017). *Clean Architecture: A Craftsman's Guide to Software Structure and Design*. Prentice Hall.  
- Gamma, E., Helm, R., Johnson, R., & Vlissides, J. (1994). *Design Patterns: Elements of Reusable Object-Oriented Software*. Addison-Wesley.  
- Richardson, C. (2018). *Microservices Patterns: With examples in Java*. Manning Publications.  
- Kruchten, P. (1995). *The 4+1 View Model of Architecture*. IEEE Software, 12(6), 42-50.  
- Newman, S. (2021). *Building Microservices: Designing Fine-Grained Systems*. 2nd Edition. O'Reilly Media.  
- Evans, E. (2003). *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley.  
- Fowler, M. (2002). *Patterns of Enterprise Application Architecture*. Addison-Wesley.  
- Bass, L., Clements, P., & Kazman, R. (2012). *Software Architecture in Practice*. 3rd Edition. Addison-Wesley.

*Documento de Arquitectura de Software preparado según estándares IEEE 1471-2000 y modelo de vistas 4+1 de Philippe Kruchten*  
*Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas*  
*Universidad Privada de Tacna \- Facultad de Ingeniería \- Escuela Profesional de Ingeniería de Sistemas*  
*Tacna, Perú \- 2025*  


[image1]: <data:image/png;base64,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>

[image2]: <data:image/png;base64,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>

[image3]: <data:image/png;base64,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>

[image4]: <data:image/png;base64,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>

[image5]: <data:image/png;base64,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>

[image6]: <data:image/png;base64,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>

[image7]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAnAAAAFNCAIAAAAPfcUaAAA3lklEQVR4Xu2dAUSc/x/H/2aSZCZJzkmS5CSZyczMzGSSZDKTmUmSJJPJT2YkSTKTzExmJpMkSZKTJDnnJEmS5CQnOUlOkpNz/8/dp749fZ9b3e157nqe594vH1/f5/t8n+/z/T7P7fva9+567n9hAAAAAGjmf3IBAAAAABIHQgUAAAB0AEIFAAAAdEAW6sLCglRiXqw0FgCALvzvf/KkB0CikFwWFxflUggVAJBWQKhAO0kU6tLS0q8LlOXT09PKTSUOh4NSqb7E+Pj4NS3Ewz+MBZiRe/fu+Xy+379/7+zsyPv+TjwvQmA9LC/U/v7+7OxsZQm/1GOyu7srlUj/ImgeVm4CJrlCFfnW1tbJycm+vr7l5WXKf//+nfK8q7KyklKbzTYzM5OXlxe+eGWXlZWNjIy8efOGSwYHB6mE8s3NzdQC9efx48eULyoqEmeJk38YCzAd9PJQbtLrbXt7O3zxeuvu7n737h2/uuh1xa9GErD0IqRq4kUIrI3lhXrnzh1Kz87OwlfnW3qFP3r06OvXr/RfT7ImXwearimtqKiguZpLOKVGJiYmeO6lXTSXUjn986HZXvlvitofGBjIzc2l/NHRUVdXV0ZGxuHhIZ2rtLSUDhS9shjJFerTKHTp6SKKcl5fSkItKCgIX9xy8cr2eDzKe8mIFWp+fj6X8Eskfv5hLMB0ZGZmUrq5uUn/5frx44ckVHrNuN1ufl19+fJFeaDyRUjVxIsQWBvL32WSGaW1tbXhq/MtlxOkVVGBhcrmI62GL65PYWEhVxYrVHHdlP+muP1AIBC+WAfT3uLiYnEuq5JcoUolLS0t4Quhfvv2jQt5guOLfvfu3fDFHSovLxd55Wud/n/ELdB/gkRhQvzDWIDpUGqSbEqvt9XV1fDF643h19Xc3JwoCV99ETKWn2pB2Op3+b///muIcv/+/fDV+VZIjvZSSqvM8IVQ+Z/G8+fPw4rrc3JyQnmah3lTum68ye0Hg0FKxZuIdrsdQj3nHyREQv3fBTSLUcpXllarfNEppVUmT3AL0bcO+Dbw3hcvXvCxokRALdBd39/fp/9hSbvi4R/GAszI27dv6eXB/w0ncnJyxOuNyquqqvjFI4RK/0WTXoT8CvyH1xgwHda+y8rRnZ6eKufbhIRKDqYML08zMjKosmj5f4p/U9z+2NiY2CWdy6okUaiGxUpjAQDogrWFClIDhAoAABAq0AEIFQAAIFSgA8YS6ubmJn9zJKmkZiwAABMBoQLtGEWo1IkiBeKPapJBsscCADAdECrQjiGEOj4+rrQp09TUJNfTiaSOBQBgRiBUoB1DCLW4uFjWaRS5nk4kdSwAADMCoQLtGEKoskgvkOvpRFLHAgAwIxAq0I4hhNrT0yO7tKjoyZMncj2dSOpYAABmBEIF2jGEUMOxFqmhUEiupBPJHgsAwHRAqEA7RhEq8fr1a1YpP6M5eaRgLAAAcwGhAu0YSKgpw0pjAQDoAoQKtAOhAgAAhAp0AEIFAAAIFeiAgYQqfoRc+WvkySAFYwEAmAsIFWjHQEL1eDzuKC6XS96nKykYCwDAXECoQDsGEiqRH0Uu1ZvUjAUAYCIgVKAdYwm1srKSf9g9qaRmLAAAEwGhAu38u1BnNwL9Tr++0T25TaEu1xhTawFlz9VjAQCkORAq0M6/CPX70oHvOGS66JjYU48FAADCECrQg4SFehYKq11llqDVqnIsAADAQKhAOwkLtXNqXy0qs8TOUUg5FgAAYCBUoJ2Ehaq2lLliYM4PoQIAJCBUoB1NQh0cHlEbS2Pk22zqQh2jzwmhAgBkIFSgHd2E+rzqZV5+/qMnTydmF1o/dHb19E/Nu3aPzhzlFSMTM1RBlHD94T8T33+Pcb7tYxel33+Njk7P5eTkejZ3Xrys7vzcy3ufvXjZ3hmp0PC+iepwIbXW8uEjtfbw0ePPfV+oZGRyVnTDveH9MTLudK0o2+GAUAEAaiBUoB19hDo5t8SZvPzI+pKEmpubR5nRqbl5zxrvEiXi8ILCIs6wUCneNjbn2+yiAofdXsAZ5eJVao1U7VN0g2JrP9DR1a1shwNCBQCogVCBdjQJVYqdwyBneOm5suWTKihLNnyHnHGtbUvVIhEIeQ9OxObO0XnLtPSUa16EaJy74VqPNnu1HV/0i74QKgBAAkIF2tFTqL6o8KS3WI0W+FISAEANhAq0k7BQ/5vcU1vKLLF5cKYcCwAAMBAq0E7CQiV2ArKozBLqsQAAQBhCBXrwL0I9DoZGlgNqXRk8lndP1GMBAIAwhAr04F+EanasNBYAgC5AqEA7ECoAAECoQAcgVAAAgFCBDhhIqG63W8okiRSMBQBgLiBUoB0DCdXj8bijuFwueZ+upGAsAABzAaEC7RhIqER+fn5hYaFcqjepGQsAwERAqEA7xhJqSUmJ3W6XS/UmNWMBAJgICBVoRzehBs/C/U5/n7b4PLFNoS5PKKgbJ8GQ3D8FN44FAJBuQKhAO/oItXvGr36Qwu3G4OKB3MsLrh8LACANgVCBdnQQ6rfF89+NMVp4DyNP7lVzzVgAAOkJhAq0o4NQ1SYzTvTM7MvdvXYsAID0BEIF2tEq1GGXQZenHAvb58/vVfK3sQAA0hYIFWhHq1A/Kz49rW94x5mltS1JbF+//1LbLtFY2zk/V16+7cfIuCifWfSoK4uQe/z3sQAA0hYIFWhHT6GWlDoWVjYc5RVO18qLl9X8S+Nkvi/ff+bk5Ho2d3Lz8kYmZn6NT7d8+Ei7hn6O8IEPHz0en1no6umn8t2jM65GKVvzedXLvPx8arNnYJA2Z5eWm1rb7fYC94aXKlA5CZVcTi3QXjrv/ZwcCBUAkBAQKtCOzkK12e2f+76Q5ERhVlZ2d//XfJuN8uRISvNt9udV1UrncbR3dlH52PQ8V+P09/g0N+tTrEQHhoZJqLuBM2p85/CUyotLHVT+a2yK0o9d3cpm5R7/fSwAgLQFQgXa0VmonCGhkjV5pVhW8YDKv/0apXWqEOrLmjql8wqLih1l5S9r66h8dGpOKVSK0rLyvPyIj1mrvguh/pmcpcaX1rZIqBTUAjfe9rFL2bjc47+PBQCQtkCoQDtahdoza7i/QFXGHoQKAIgDCBVoR6tQ94/P1BozTvQ5/XKP/z4WAEDaAqEC7WgVKrHhN65T5b5GuWYsAID0BEIF2tFBqMTIckAts9uN+Vh/gcpcPxYAQBoCoQLt6CNU4uD4rHfW32OAoG74jmI/dJC5cSwAgHQDQgXa0U2oJsJKYwEA6AKECrQDoQIAAIQKdABCBQAACBXoAIQKQFzU19dT6na7W1pa5H3A/ECoQDsQKgDxUlhY6HA45FJgCSBUoB0IFYB4yc/Px/LUqkCoQDsQKgDx0tfXJxcBqwChAu1AqMDiTK0a7qkjFDtHoeB1fywNUg2ECrQDoQIrM+w6VMvMIOE9hFENBIQKtAOhAiuj1pihYmjxQO4xuCUgVKAdCBVYll9u4y5PRUyvBeR+g9sAQgXagVCBZYk81VklMHXsHJ6qCzXG8uauujBm9M/F+IVBkHogVKAdCBVYlh6FUEtKHZQ+qHxE6cC34ZlFz/ffY5QfHB7xROVXVV1L6Zt3jave/fbOT40tbXwgVf7y7SeVt3z4SJuzSyt1rxucrlU6kDbr6t9Q+vX7r8aWdsr8GpviNju6uilT/+ate927uX/+rSjRiDL6Y/1kL0g9ECrQDoQKLIskVLLd0trW7/Fpytvs9o7/PvMukutu4Kzy8RPK59vs2dn3cvPyeNev8WnOUPnzqmrKOF0rlM651z5+6qGmiksdz6teKgXJYbcXUJtZWdm0/F3d3pMaUQaEahAgVKAdCBVYFvUKNTs723tw0j/0g1LarK595YsKdSXqPMpQOU2sQqhceX33gDK8op33rHFKQuVGaA2qFCS3SULlNt82Ng/9HOG8aEQZEKpBgFCBdiBUYFl6nXF9hnq7MYDPUI0BhAq0A6ECy3JwfKYWmNECj3cwCBAq0A6ECqyMWmCGit5ZLE+NAoQKtAOhAivjOwpuHhh0nfp96VDuLrg9IFSgHQgVWJ+D47Nep79n1ijx2w2VGg4IFWgHQgUAAAgV6ACECgAAECrQAQgVAAAgVKADECoAcVFaWiplgJWAUIF2IFQA4qWkpCQ/P18uBZYAQgXagVABiBeyaWtrq1wKLAGECrQDoQIQLw6HQy4CVgFCBdqBUEFaE+dvpv5DLGyfdM/sy+cDRgVCBdqBUEGa8tN1qLag7uE9xLN6zQGECrQDoYI0RS2/JAV+oM0UQKhAOxAqSEd8Ryl9wO9JMCT3ABgMCBVoB0IF6Ug8P5W6vLnLKWf+FrtHZ5t7R+pyZeBHT40PhAq0A6GCdET5XaSyigeUNrxvkiw4Ne+qb3jHGbUjRXzqHRD5fJtNXYGiH0I1PBAq0A6ECtIRpVBHJmZ2DoMfu7rd695t/3FXT39uXh6V2+0FVdW1nMnIzOTKns1dyZoDQ8MLKxuU6ejq5l3qBSuEanwgVKAdCBWkI9Jfy9y9e5dS78FJ/9APStVCpaDMzKKHUpp5lceSULf8x76omB1l5ZQZ/jOx6t1X1oFQjQ+ECrQDoYJ05Jo/P6XVqrqQYmXLJ1J1uDd2LjcDETcr9+IzVOMDoQLtQKggHRldlt+VTWrMbgTkHgCDAaEC7UCoIE1Ray9J0Ye/QzUDECrQDoQK0pT/pvbU8ktGyCcGhgRCBdqBUEFaM7hwoFagLrG8F/w0hWf5mgYIFWgHQgUAAAgV6ACECgAAECrQAQgVAAAgVKADECoAcVFaWiplgJWAUIF2IFQA4sLlcrnd7oKCAo/HI+8D5gdCBdqBUAGIl/z8/KKiIrkUWAIIFWgHQgUgXhwOh1wErAKECrQDoYI05jRwttAdfxxM/6cuvD7kMwKjAqEC7UCoIF3w+XzBYFBsBqc/hIOupEfAqejCJXt7e3IRuFUgVKAdCBWkBTabbWRkRGymyKYc5NTTw/PzBoOZmZkvX76kfCCAJ+YbCAgVaAdCBWlBUVFRRUUF52Pa9DSwMD7aoyw5O1kMHDgpEzpd4pRKxKaIjIy7nNn3Td+5cyeaP69wsRmNC6dmZWX9/Pnz2bNnl50DBgBCBdqBUEF6EdOmY3+6OXMamB/80k6ZP78/0wzr3RqnvN83bbfnico+76SyMgvVtxMpJIPm5NybGOul/LxzcHtz7PIsf3nvFxgECBVoB0IFMcjPz5eLLMNpIOK2C88tzn+7sOMCifDp04q3DVVcEplho+XkxcP92Us1Bl3v3r6klCufCzVqWaVQORURnH4v9wQYCQgVaAdCBTGwslCZC6fWv3pW+dChNF8yAjY1PhAq0A6ECmJgfaHSOlWlvSQFbGoKIFSgHQgVXMHv94fTQahh+b3fJAVsahYgVKAdCBXIOJ1OEmphYaG8AwAVLS0tbrebMq9fv5b3mQoIFWgHQgUyDocDQgXxQ6+WkpISudRsQKhAOxAqkGlra0uLt3yBTtAi1QIvGAgVaAdCBTGwwPwIUsmXL1/kIrMBoQLtQKgW5/P0vu84lGiMz8yrC2+MXmfkC03ApBydhOa2jtW3NXmxsH3iPbh8uvLtAqEC7UColmUvcKaewlIQdF65K8Dw/Fg6UN/K1IT30BAvGAgVaAdCtSzqmStlseU3yrIDxMPoypH6JqYyhhYP5D6lHAgVaAdCtSYnQXnOSmX0zuK9XzMxtHiovokpDrlPKQdCBdqBUK1Jn9OvnrOuieXNXSmjMeQOAQOjvn2pD7lPKQdCBdqBUK1Jr0qoH7u6fYFQw/smys8urVDqdK38Gpt6WVtH5R1d3VlZ2Y0t7ZRp7/zU2NLGR71517jq3d8NnL163UCbA9+Ga169Fu2Mzcy/b47UrKmrl04ndwgYGOWNKyl1UHrnzh1K6+rfcCG9HgaHR8R939oP9AwM/hqf5peH7+IVRUGvqJYPH33Rl8qXbz8pI145M4seesFUVdfS5qfeAXqxKc8r9ynlQKhAOxCqNZGE+vFTT2ZmZlZWFuVpThz6OUKZ4T8TT5698EWtabcX5NtslKdMbl6eOHDnMEjlGZmZvLm2E2lWtFNYVEyZhZUNSsnE4iifAeZHED/KG8dCrXz81L3u5bvM5eQ/cd+zs+9RpvVDJ788KM+vKI6lta2F5XV+qbjWtimlprb9x109/fyCodjckz+1lfuUciBUoB0I1ZqoV6gU9oJCnt3mPWuUoTSy3DwOVde+Io86ysojdRRCpSWF9+CEJhoq5JL+oR/KdmhabG7v2PJH/tZiZGJGeS65Q8DAKG8cCZVua1VNLd16vstcTv8nE/fdZi+g1wYJlV8evuhriavRi+f777HRqTl6qazvHnAjlNImpcKj9J85XtqKkPuUciBUoB0I1Zok+hmq7iF3CBgY9e27PnoGBl9U19DyVL3rn0PuU8qBUIF2IFRrMrsRUM9ZKYu5rWO5Q8DAuHdP1TcxxSH3KeVAqEA7EKplUc9ZKYujk9ufH0H8uHcib8zeYvQb4BlbECrQDoRqZdQzVwpC7gQwA74jPd+/TSh+uA7l3twGECrQDoRqZUKhcNfUvzzL99/i29JhCD41LZ6dkxS/97u8F5xYOZL7cUtAqEA7ECqIAX5tBqQbECrQDoQKYgChgnQDQgXagVBBDCBUkG5AqEA7ECq4wtFR5DMtEqrb7Zb3AaCitLRUypgUCBVoB0IFMg6Hg4RaWFgo7wAgFvRqKSkpkUvNBoQKtAOhAhmaHGmK3N/fl3cAEAv6v5cFPiOAUIF2IFQQAwvMjyCVlJWVyUVmA0IF2oFQzQp/2MkEZzrCQZeOsTD3TV2oKY4XLrsOkk/P7C0/zDl50ZOcn6+HUIF2IFTzEQqFgsGg2NTdpkmK4MxHxSDCgUCA0r29PWUh0IWx1dt8knMKYnQl8uLRFwgVaAdCNRk2m+34+PLR82axKYdwKv+HYGJigtKMjAwxHKCdzsnUPRvrdkMeuTYgVKAdCNVkFBUVNTU1cf5vNt3bmaT07GSR0uPDudDpEgXlfd5JygSPF2jXkX+WK1Pe75vmzH40w7G/O8WFgQMnl3AjXH4a4EacfC7eRcFN3blzJ3K66K693SnePI+r7/0+e/ZseXlZWQK04Ds6U4vHquE9uHyfRjsQKtAOhGpW/mbTmakBUmaBPW/XO7GzNU7OI59lZNydmujjCiTCyNwRkeL84Jd2zlNwZsX983X9c9EaFXqjjVCeGqFDuJyESrtmp79QnuqTR+32PHEUndG/FzErF25vjoldYdV7v0BHbv13cFMZ+n6YCqEC7UCopuU0EL7QG8Xi/OXXiNpb6/PycihDVvNujrFQo1KMrCMP9mbYnU+fVrxtqJKESlFZ6SArS4W03KRG6BDeZKHyGpTqkzIP98+XvLQrJ+ceL2RF4ZU41f8DMMD0Kr6LtHMYXN7yjU3PixK7vUAppKl5l9pS0q7WD53qvfk2G6Wb+4H6hnecUdfhoF07N/2OTXNbh3Lzml75rg6hewZCBcYCQjU5F06tf/Ws8qFDVlfQ1dRYOzf7VV1+O0G9hU2TiVKoFHfv3l3fPVhY2aB8R1c328i1tr22E6mmlJNnc3dheX3o54jw1sJy5CgSqnvdS5munv7cvLxISUcnC3Vm0VNVXcsZblC0k5GZyZu0a3PvqKomUu3HyHhjSzuXk+yX1rb4FA8fPfZd7ZXoMFemM1JK9XkvF/ogVGA8IFSTQ35Se8uwAZsmGUmoFGTBCeciZd43t7KNxBJQyCk3N2LK0am5ec+a2DUxu+CLCnVybkk0RenbxuZ8m913VahcgVTK7XBNsaupNeJRavzjpx4u34ouavkUdfVvfFd7JTrMJXRG7iHv5YwPQgXGA0I1P1ff+zVuwKbJRxLq0mpkVUfh3thRlqtjZcunLqRVI2do7UhrSnUFdYh2lkWDAbmOcq84hRQ3dtgHoQLjAaECK/PixQt+yn9bW5u8z4qMLh+pxWPVGPEcyuPXAIQKtAOh6oBlfnDDktBNsdlscql1ibkitGTII9cGhAq0A6HqQ0FBgcPhkEuBAXj8+HFVVZVcal2OT2XxWDI+Tur8jC0IFWgHQtWHyspKPFDesAwPD8tFVmdo4UAtIWvE4MKBPFo9gFCBdiBUfXjy5EmqfkDUa67o6or3w8v+OfkbqkaOua3jfqeeX4oBtwuECrQDoYaPTkLz28fqGfNWYmDuxjlaNpbBY+BLVyCwduND8Kc3jHILEgrqtjwSYE4gVKCddBeqMefxy77GQDaWwYOEyplrnDq3faK+CGaJsZXL39ED5gVCBdpJa6GGQmH1/GiE6Jzcv9LjK5yLqrX17f3799QC0xhLS2PqQhGVlRXqwutDCJXWqfJQLlBfARPF0KKef7wBbgsIFWgnrYVKU6F6fjRIXOnxFS5d9WO4t7y8lDJnoW1KHzxwhMLeUGj7KLD26FHEfCcnG1lZWVyhs7O5paWBDywtLeb6fPjdu3cfPiynDB04PNyn3Bs4Xs/OzvL5XFTy338t/yDUqxEb9fCvj53DUylzuyGPB5gQCBVoJ62Fqp4ZkxobvgT8faXHV7iiKDbitneBUpoRdnaXuDw6O5zXGRz6TBX29tybm3PKvZTy4WVlJaI+CVXaS5nI769Fl6cpEOrg8MjH6ENcB74Nzyx62js/Nba0Ufqyto702T0w6Is+MLY2+rw6yswurfCBVKe2/jVl3rxrXPVGfhO0/s1b97qXjhKPkB2bmX/f3MZ5p2u1uu6VOLbudQOdseF9E22+rKn7OTrJu7iRrKxsaoTP9al3wL3h5b0c8niACYFQgXYg1PNY3z3gR34nL6Rf1bg+rvQ4HB4Y6J+Y/KXy07lQKfLyclirtKB0zv3e23eXlBQFz7bu37/H7wxTzQcPyrjyxqYzJ+c+1afC4uKCnz/7d32ukpJCOpCESnu5NSHUjo4mWramRqgkuczMTHLYtv9YPJCdU3Jh5+deX/QJsfyQWErF89y5TsXDyp3DIN9K/h9MZmaWaLywqFjkf4yMizwfS2ekdM4deZ7t46fPKJ1wLnIj3CCda2FlQzztXYQ8HmBCIFSgHQj1PO7du6+cW1s7OmneVFbgn9EQm/wTHLyg4fo+xYNJaUlHadvHLjG5b/mPHz56LB31t3NRVFSUz8z8VglJ52hre6cuTGbERjlwWqH6Ir8dfdI/9INSpVB7vgz1ff3ui3qUV5CUEc9zj9QJhN41tdBRNDlyYeS56nl5vGCloOvc3H7+3xpxoGifzui7eBs5Kyui4ZXtPW7EUVbOh9B9HP4zkZuXL471QaiWAEIF2oFQr0TLh4/iJzVo3hQTMa+HRqfmRE2atX0XWuX6opAWu6WOMpqLSahicv8zOZudfU86Kua5OK70OLJC7ZmY/KGU01HkOz5et3tCJa1I1NW9UBfqHsqzHB+vqyuoIjbKgf9ziF840R7dA4OO8gp1+d9CHg8wIRAq0A6E+vcInAuSQ/1zHOI3IJUhqu0GznyKX9UQP9YR8yjpXL7r5uhzOfG3jQYG/gsGt1bXZkT5/MIfSv0Hy5SurEyz5w6PVn0Xn6H6/csLC6Nc+eholauJw7e254NnW1LhyckGHXIW2ubWAsfrodA2BZ+Fz/jlaxdtUk1Kd3aXQtHvSakiNvLVMFW4d0/l8aQTlnmQNYQKtJPWQqWpUD0/GiSu9PgKl356+7aOhMpW241+Edfnc5ERw9EvEHl3FldXpym48sJiRKKdnc38yejQt24up3mE6ty7l82bvX0fKeVjRWH/wH+ULi6OUqHbM3FyurG8PHVwsEJnyci4y2f89WtA1JybH6mtjblEjs3oSuTXMU0anp0TeTxpRn5+fnFxsVxqNiBUoJ30FuqOQZ8nQIK50uMrXPqJ9ElCbW5+w382Q8Hf8qV1JH976PhkPXRRmd8cbm9/z0Ld23Nz+fPnj6garzI5+Du9ysKRkS+U1tdXh6J/gfP6dfXjxw9YqFtb83zGjo5Grrm7u7S+PpuXlysaVMRf+W8q8mml6YK6LY8k/WhtbbXAg6whVKCdtBYqsWPI37o6Pg1ddldGbSnv/r5H5NlwHOS5w+ibusogoW5sOpUlyo8/d3YW1YUiRGtjY0OcIb8qz8jBi+ZYcR2fp698imzw8PhOqcPyGNKVsrIyuchsQKhAO+ku1HB0nWqc934/3TxHqy1logC3z6tXry43TgPhoMsgEZxuvuxYyoFQgXYgVNOhtpSJAtwagUDg2bNnlDk9Pf8WVXC6TW212w2lU8U7yS9evFheXhblSQJCBdqBUAFIC3Z3dxsaGsJCqEZam16J0/MfGwgGg5ROTExQmpGRIQaSJCBUoB0IFYC0YGxsrLq6OsxCvWrT0OkSZ06O5jnj25lU7j07WeQMB+WPD+co3d+dEodz6l78IQ5UtiDyp4GFsOJE3MLe7lTkq3AXdaT3fmlhjRUqMAUQKlBBs+3hglwIzEb+35GE19RYK/KBA+fURF/Hhzf372cHjxcyMzOkyhkZd6teVHL+0aOyyfE+UT4x1sstKA+cmuhfmv9Gu8ocReGoUNmpVI1beFn1SDoFhdxjBfI4dQJCBdqBUIGK4+WwapUATMc17pE+Pd1aH+XM4f7Mr+H/eNV4uD9LaVZWpqQ6EmdOzj3KzEwNULrvm97eGCODUrlyXSsOzM2NVH76tOJtQ1X4Qqh8Im7h+bMH0inCAafc4+QDoQLtQKjgKlGbcsCppuYaoYYVTg2dLj18UEpGlK12S3FbrzoIFWgHQk1rCgoKhoeHzzdOA0qbnodirfD06dPLysDwXC/UsGqdaoS4LZuGIVSgBxBqumOz2QoLCyOmVNv0Yo4jldbU1Nw4QQOD4Pf7w3EINWw0p8b9Ti8PUF8gVKAdCDWtcbvdNO0+fvw4HJlb2+UJjuNkh/a+efMmngkaGAR6kdP9ov8qyTvMjN1uD0dftPIOPYBQgXYg1PQlxn/zpb9NpBVD1KaCo6OjGEcB40H/SSKhfvr0Sd5hZn78+EGDKioqknfoAYQKtAOhgitcWadetSkwEW1tbZZ8R4EG1djYKJfqAYQKtAOhAplzp8KmJseSQqVFqlykExAq0A6ECmJgybnYUPTOxvqdebPF55kbf8sh3Oc07kg3D85EPyFUoB0IFcQAQk0qHROm/PHXmPFt8UAengL/8Zn6EEPF9MYxdxVCBdqBUEEMINTkse0Pqqd1U8eI5/xx9hLeA3OMdGQ50n8IFWgHQgUxgFCTx/z2iXpON3Us70V+FkaNa8coPzN8fXD/IVSgHQgVxABCTR7qCf362Dk815LIGCGWN3eVm/Igo+ypjtIlNnyH6sIbg6/e5/6v6l2+aP8hVKAdCBXEAEJNHsp5vKTUQenDR08Gvg03vG+ifGNLG6Xvm9tIAC9r6yjv2dzNysqedC5Spr3zU93rBj62qqaW0t3AWc2r15ShFr58++kLhOrq39Bm/Zu33EhjS/v56S52tbR/pHR6wU2HRI4NhPjU1HhtvaKp6FE1dfXuDS9lnK7VweGRX2NTfF67veC82QshqVFWoKh4WNk9MJiRkUGNtHyI9IHOWF33ijK10Y7ReWcWPVTIF0F0eHZphUe97T9+WVPX+qFT7KJecQviAlKFn6OTvuj1WfXui+tDV+9T7wBfDWqfxqLsWxhCBXoAoYIYQKjJQzmPk1A7P/VwprikVLmrZ2CQM+SYfJuNM7l5eaLC46fPxqbni6NK/jU+zYWkKyp5XvWSHNzd/5WFzTYSuyhP8hDtRMpLSqmcG79/P0fsIvNR+rGrm9I599rHTz3tnV183n8QKintc98XOh018ryqmhrhM75tbKah/R6fpt7a7HZRKDrsdK1wC46yckpJqGIX9Yp38QXkDr9rbvVFr0929j2+Pr7o1VN25mP0sosIQ6hADyBUEAMINXko53EWHkX/0A9lOUXPlyHOkAlYJEqhsh5Gp+ZYbN6DE2phfffAXlBIm+51L6XN7R1Un1ZpIxMztCl2Nbd10LrNd3FSUR5pPBB619TCTVHhlv+Y0ty8fErnPRGhcgfEeUXIg4yirCCCXEiNfP89Ro0Id9KakodAqSgUHaNT87E5ubm+qFDVu3gs/L5uVlYWXx9ypOgnlQz/maCrwZsQKkgGECqIAYSaPJTzuKFCufxNNORBRtk/kaulILoHBh3lFery6yMMoQI9gFBBDCDU5NE9c75Iskx0TsV+vEPvrDlGyv2HUIF2IFQQAwg1qajndFNH8PJxQzJreyb4U1TuP4QKtAOhghhAqEllL3C2um8C08QT8thUGHyk4klPECrQDoQKYgChpoCTYKjP6e9NWtBNVBfqFdTz2fWAPKS/QCPtV7Vw6yH1H0IF2oFQQQwgVAuAm5gQECrQDoQKYoC52ALgJiYEhAq0A6GCGGAuNjV+vz9s6ZvIA9QXCBVoB0IFMbDwXJwOHB1Ffj6FbqLb7Zb3mRkxHB6gvkCoQDsQKogBhGp2CgsL6SaWlJTIO8zMgwcPioqKkvTihFCBdiBUEIMkzVkgZbS1tVnyJtKgmpqa5FI9gFCBdiBUEANLzsXphiVvIi1S5SKdgFCBdiBUEANLzsUm4vO0Dg/tG5+ZVxcmFMt7wfEV/T+t/DdcLtfQ0ND+/v7a2lpNTY28WzMQKtAOhApiAKHeFsenod2ALLZbD7mXKaenp0cqCYV07hWECrQDoYIYQKi3xehKQO2zW48+p/5/ppIQTqeTUofDURSFbarvOhVCBdqBUEEMINTbQi0zg8TsRrwPGtSd2tpaShsbG9mmDJWsrq7KVTUAoQLtQKggBhDqbaE22T+EZ3NXXXhj8K9zf+7/qt5F0T93a4vUR48eUVpRUSEJVd/HO0CoQDsQKogBhHpbKB22vnsw9pcvFs0setSFIv7tp8I39wM7R8Et/7F6F0X/7b3r29vbS+ny8rKwaVlZGZV8+/ZNrqoBCBVoB0IFMYBQbwulw+7du//oyVPfhSAXVjY2946qamp9F0JdWttaWF4X+szMzKK0o6ubSyoeVm74DinjXvdS2vC+ictHp+boKF90IZtvs2VkZvLh1Ca1z/kfI+OcEXGLQiWePXsWjjr1wYMHLS0tXOhyua5U0gaECrQDoYIYQKi3hRDY999jIs8ipLXj8J+J3Lx8yv8cnaRCqkN2FEKlzKp3f2RiJlISCL1raqHCt43N3oMTX1SrXJMkXVxSykomi9jtBXw4lVD71ALl5z1r4uwctyvU8IVTGafTqf7er0YgVKAdCBXEAEK9LSSNyXHTX9SwOymWox+juta3eXNtx6+uvLLlO698kaH2RQtS3OJnqILe3t7Hjx/X1dXJO/QAQgXagVBBDCDU20JtMoPESTDylyoWBkIF2oFQQQwg1Nuic1KHZyTpHrf+fm8KgFCBdiBUEAMI9RaZ3oj9PdvbCu/hmdxFKwKhAu1AqCAGEOrt0j8X4yPP1MfC9sn2QVDunEWBUIF2IFQQAwjVAuAmJgSECrQDoYIYYC62ALiJCQGhAu1AqCAGmIstAG5iQkCoQDsQKogB5uLYnBrlx0HjATcxISBUoB0IFcQAc3FsAs7gdLtcaFRwExMCQgXagVBBDDAXy9DaNOAMB12RCMzJew0JbmJCQKhAOxAqiEGaz8UlJSUej+dym2zKKhVx1alU2e12K0uMQJrfxESBUIF2IFQQA8zFLpeLLsKDBw+O/DuyTS+ceuTfLSgosNvtBrRpGDcxQSBUoB0IFYAY0L8KElJlZSVZU1apQqhFRUU2m82YQgUJAaEC7UCoAMio3vINqG16udeob/mChIBQgXYgVADigJxqti8lgYSAUIF2IFQA4oPXqWRTygDLAaEC7UCoAMQNVGpdIFSgHQgVAAAgVKADECoACZAPALhA/ueR9kCoAACAFWrCsFD9fr+8I42BUAEAAEJNjIKCAhKqy+WSd6Q3ECoAAECoiVFeXo53fdVAqAAAAKEmDNm0tbVVLk1vIFQAAIBQEwbLUzUQKgAApLVQj6KIzeB0o/yszVixMPdNXRgjAk7FqSwOhAoAAGkq1MrKyidPnmRkZIiSOG2aWCicStf56dOnlCksLCwpKRHl1gBCBQCANBXq8fFxUVHRpVDFA6ujETpdOjtZlO0YjT+/PyurKXe9qnsm8of7M+d5avk0sgjm63x6ekppKBS67IolgFABACBNhUo2bWpqYqFeXZtGHJmTc0+U+H3TIn9yNH/nzh3K+HYmKT0NLCgOjMTBXsSjlO5uTwSPL/ZG16lCqAUFBcXFxVJ/zA6ECgAAKRXq5aOGjITSiHOzg+GoUNdXR0RhZmYGpRNjvZSSUAsK8js+vNneGGOh1tU+DRxEFri0WVvzpMxRRPl5Z6SdyziYlM96S8i3RCcgVAAASLVQ5SIDoFyhrnh+sVCVOszKyuRMgT2PhDo53vf82QM2KKWDX9ob31fz5uNHZW8bqii/uhxp5zwM8+2k5F1/CBUAACDUKBefoRYW5lc+dChtqjUin6Ea5ceaknf9IVQAAIBQz0n2t3yNQPKuP4QKAAApEuqfP3/CFxM65w2Izk41mE3Dybz+ECoAAKRIqITdbqcJvbCwUN4BUgJff7fbLe/QAwgVAABSJ9Th4WGa0Nvb2+UdICXw9U/Su74QKgAApE6o4WR+hgfiga7/0tKSXKoHECoAAECoaUTyrj+ECgAAcQl1fvvEdxwyVCzvnsi9tBzHwdDoSkA9duOEuAsQKgAA3CDUydUj9TRqkBhfNcrfdyYJ9ZANGHwXIFQAALhBqJsHZ+o51Dghd9dCfJraV4/XmBGGUAEAIHyTUNWzp6FiYM4v99gqqAdr2KC7AKECAEACQq1veFdd90o9n6pjZtFjtxeoy6+P1g+d6sLro8+ZFkKteVVfVFzii15Y9UVQx40X/8YKHM1tHcrNr99/qev4oncBQgUAgASEWlLqOM8HQg3vmygz8G34y7efO4enNXX1vuh0X1v/mjKezV2esqtqale9++2dn+peN/Cxr1430CGb+4HhPxO0+eZdI1WgzMuaOhZqXf0bSvkQp2uVFf6pd6CxpT3SYHWte9173o20Ear34PxLYXRh6coo/1vT2NImLtrWfqBnYJAyHV3dYzPz75vbSIF03egQqka3ia8hVxDHUlBN2vuyts4Xvad8c+mONLV+4Ap8m7KysqkFZTscECoAAERISKgf/vtMmYyMjOKS0l/j06KcUvKfWD+JFerjp8+ys+/l5uVxuThkdXuPJ+V8m50q/Bqb8kVXqL/Hp4tLHc+rXvIhc+41rs+xGzirfPyEJnRRkiZCpRidcvqiF1ZcTBHiojnKK7iELv7rt++7+7/yJh8ibhNX4F1vG5s5wybmapGbG70j75pauJBvU77NJrXDAaECAECEhIRK6aMnT52ulfKKh5QvLCqmzbHpeZ7Kaf6lEp8QaiBUVvGA5nqlA2iypkOy792rro0ss2imLo42W/7gIa9Qi4pLaF3Fh8x7zoVK1e7n5PyZnKUGl9a2RGtpIlRaGtLwfX8Rqu/ios0uLT99XuWL+vL+/Ry+X7l5+XwI3SZuhCtw5lKoX4Y4U1pWzjeX7khVdW2kMHB+m779GqXWlO1wQKgAABAhfqHeGMJ/KYt+fClJEbTKfFFdoy5PdvTjS0kAABC+Sag7R/LsaaiQu2sh/sOfzRgcK40FAKAL1wv19CzsPTTon6J2jO/J3bUW6iEbMPguQKgAAHCDUIn9gBGFanmbEj+WDtUDN1SIuwChAgDAzUJlJtcCfU6/xsjPz1cXJhr91v0iUkxmN3S48hy6XH8O6S5AqAAAEK9QdSF5v3YC4iF51x9CBQAACDWNSN71h1ABACBFQvX7I+8Q8oTOeZB6IFQ9sdJYAAC6kBqhEna7nSb0wsJCeQdIFRCqnlhpLAAAXUiZUJ8+fUoTelFRkbwDpAoIVU+sNBYAgC6kTKjhZE7oIB6Sd/0hVAAASCuheg0YA1+69vZS9De1ybv+ECoAAMhCnVg5Wt4Lqv+EX5cYn5lXF+oVXxcOlAOJhSwzIwQJNRBYS41TIVQ9sdJYAAC6oBSq2lKmi+PTkGJwEucO6+npcM79Vrstnqire6EupDg+XlcXxhMkVM6kwKkQqp5YaSwAAF0QQjXsM3sTi0Do6viUXGrsLLRNqc2WNzH5vby8dG19ljYLCmyTUz82t+aePHlIm69evayocHB5UVEBH1hZWUFpcXFhbm4OZZqa3mRmZnR1tRYW2mmTmhI14wwSqgi5v3oDoeqJlcYCANAFIVTZTKaN357Dq0MUnDuMnJeVlcV50ieldBG2vQtcQvnV1Wm3ZyIj4y5X8B8se72LvJeE6t0hd4xSHdocHPx8dLRKmV+/BrgpUfOfIrlAqHpipbEAAHRBL6HuHJ7uHJ5/+Ep5dYWkhvKMn2f+9uAItcC8oWjwkvTkdGNv3/38+aNwdAm7tTXvco3T3ubmN69fV3N9XqHW11eHopsjI19OTzcp09HRyE2Jmv8UyQVC1RMrjQUAoAt/E+ro1ByljS1tlFbV1HIhb47NzL9vbtsNnL163UCbs0srda8bPJu7I5OztfWvqYTy7Z2f6qJ7lYeLcG94Ke3o6qZGal5FDqmrf6OsQIe/rK37+Kmne2CQW1j17lNhdd0r2mxq+0Dp74mZN+8aWz58pPzMokccK4Q6OTk+MPBZJS0jR3KBUPXESmMBAOjC9ULlIEEuLK9zvrWjs7ComDIZmZlcMvRzxBdV2pdvP7mE8rl5eTEPLyl1UFCmqbXdvbHDjbjXvZQ2vG8Sh4jDOz/3cgv5NhsXUgfu3LlDmbaPXbQmXlrb8l0VatfU3szMP37n6LYjuUCoemKlsQAAdOFGobKrxObbxubNvaPm9g67vYBL5j1rXK2mrt4XOD9EGFE6XAStTcmg3Ij34MR3oVUOcXjf1+/cAvWTC6kDpY6yle09Eiod+P33mDgLh/SW78BA/8BAt9Jbra1v79+/p5KZESK5QKh6YqWxAAB04W9CNW90z978GeqP4V5KDw9X+Ou+Dx5Evs17eLR69+5d/nA0Ly+X0sDxenZ25OtLJycbgcBaaWlxOPpBqWjn1asqziiPombLy0sp5frUOG0q66ytzYgWrkZygVD1xEpjAQDogvWE6j0IXh2i4Nxbq6vTweAW5xcWR8PRb/byZk3N88XF0aqqpxRcwrtevnw6NjZ09+4dyns8k7zrc3d7Q0Mt56Wj2KBcn1rgTWWdrKxMrnk1kguEqidWGgsAQBeEUAfm/Go5mS46Jq55PIJaYJHIy8vhv5kpKLD9/NlPGVqV8l+ghi+Earfnf//es7HpzMm5Lw6kBeiHD+/FpvIoNijXp8Z5U9RxucYdjsjiVRXJBULVEyuNBQCgC0KoxMeJPbWiTBSjKwHFyNSoBWa0SC4Qqp5YaSwAAF1QCpXwHgQXvJGvCJkuev760alALTCjRXKBUPXESmMBAOiCJNSkkrwJPT7UAjNaJJfkXX8IFQAA0kqo6U7yrj+ECgAAEGoakbzrD6ECAACEmkYk7/pDqAAAkCKhHh0dzc3N0YTudrspL+8GKQFC1RMrjQUAoAupESphs9nyo8g7QKpI3sWHUAEAIHVCpYUpTeh+/41/3AKSBYSqJ1YaCwBAF1Im1HAyJ3QQD8m7/hAqAADcINR+p7/P6e/VKWhCVxf+c1DHgmdyh8E1QKh6YqWxAAB04W9C/bF0oH4akTFD7jr4CxCqnlhpLAAAXYgpVNM91FceAIgFhKonVhoLAEAXYgpVbSyDhzwAEAsIVU+sNBYAgC5YQ6i9Tnx5+GYgVD2x0lgAALpwo1CzsrJXt/co1BpLdnzs6lYXxow4fmoGQKi6YqWxAAB04XqhTi+4N3yHYnN8ZsHpWsnNy/sxMk6bDe+bvv8apYyjvILSqXlXiaOM9o5MzHD9oZ8jyqN+jk7S5ovqms7PvXwUlY9Mzoo6fNTwn4l8m000mJOb++X7T9718NFjqsktrHr3udAHocYHhKonVhoLAEAXrhfq5t7R76gdyYWTc0tcSGrkDGuPYt6ztrC8Tpm8fJvYy6E+iuqIo6Q6IsZm5kWDlDrKypV7ufB9c6sogVDjAULVEyuNBQCgC9cLlWN5y8eZtR2/tMu94RX5lYtqUvBRJNTlzV0u8R7Iv2GubFmsibnBncNTX+CyJndGaqEXQo0DCFVPrDQWAIAuxCNUXeJT74C6UK/ow5eS4gBC1RMrjQUAoAuxhapYEZoi5AGAWECoemKlsQAAdCGmUI9PQzvmcep/U3vyAEAsIFQ9sdJYAAC6EFOoxHFQ9pYxY2wlIHcd/AUIVU+sNBYAgC78TajJIHkTOoiH5F1/CBUAACDUNCJ51x9CBQAACDVhgjMf5CKTkLzrD6ECAACEmhjB6ZZw0BUOOOUdZiB51x9CBQAACDUBzm3KYUKnJu/6Q6gAAACh/pWSkhLl5hWbRiM43a6s8O7dO+WmAUne9YdQAQAAQr2OwsJCu93+8OFDtU3FOvX79+80LpvNJh9sPJJ3/SFUAABIqVBNBxmoqakpkjsNyCo9X6S2haNr04KCArfbLR2ePkCoAAAAof6VON7yjdhUYPy3fJMHhAoAABBqIijWqZJN0xwIFQAAINQEiToVNpWAUAEAAEJNmOR9tce8QKgAAAChJgyEqgZCBQAACDVhIFQ1ECoAAECoCcNC9fv98o40BkIFAAAINTEKCgpIqC6XS96R3kCoAAAAoSbG0NAQCdXhcMg70hsIFQAAINSEIaG2tLTIpekNhAoAABBqwuBLSWogVAAAgFDjJRQKPXv2TGw6nU4qUexPayBUAACAUOPl/fv3N5akLRAqAABAqHHh8Xg4U3RBV1cXbVZXV1+pl65AqAAAAKHGxaNHjygtKysTQiXC+GvUCyBUAACAUOMCQr0eCBUAACDUuMBbvtcDoQIAAIQaL+qvIKlL0hYIFQAAINR4wZ/NXEO8Qg0EAlKJebHSWAAAuhBzHgQgIQJR5FK1UAEAAADwD0CoAAAAgA5AqAAAAIAO/B+7akLLFVUX+gAAAABJRU5ErkJggg==>

[image8]: <data:image/png;base64,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>

[image9]: <data:image/png;base64,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>

[image10]: <data:image/png;base64,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>

[image11]: <data:image/png;base64,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>

[image12]: <data:image/png;base64,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>

[image13]: <data:image/png;base64,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>

[image14]: <data:image/png;base64,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>

[image15]: <data:image/png;base64,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>