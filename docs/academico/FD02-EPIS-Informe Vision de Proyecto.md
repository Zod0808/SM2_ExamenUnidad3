**![C:\\Users\\EPIS\\Documents\\upt.png][image1]**

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
| 1.0 | CCL | OJF | OJF | 24/09/2025 | Versión Original |

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

# **Documento de Visión**

# 

# **Versión 1.0**

| CONTROL DE VERSIONES |  |  |  |  |  |
| :---: | :---: | :---: | :---: | :---: | ----- |
| Versión | Hecha por | Revisada por | Aprobada por | Fecha | Motivo |
| 1.0 | CCL | OJF | OJF | 24/09/2025 | Versión Original |

**ÍNDICE GENERAL**

1\.	Introducción	1

1.1	Propósito	1

1.2	Alcance	1

1.3	Definiciones, Siglas y Abreviaturas	1

1.4	Referencias	1

1.5	Visión General	1

2\.	Posicionamiento	1

2.1	Oportunidad de negocio	1

2.2	Definición del problema	2

3\.	Descripción de los interesados y usuarios	3

3.1	Resumen de los interesados	3

3.2	Resumen de los usuarios	3

3.3	Entorno de usuario	4

3.4	Perfiles de los interesados	4

3.5	Perfiles de los Usuarios	4

3.6	Necesidades de los interesados y usuarios	6

4\.	Vista General del Producto	7

4.1	Perspectiva del producto	7

4.2	Resumen de capacidades	8

4.3	Suposiciones y dependencias	8

4.4	Costos y precios	9

4.5	Licenciamiento e instalación	9

5\.	Características del producto	9

6\.	Restricciones	10

7\.	Rangos de calidad	10

8\.	Precedencia y Prioridad	10

9\.	Otros requerimientos del producto	10

	[b) Estandares legales](#heading=h.5ny9t6gbogm1)	32

	[c) Estandares de comunicación](#heading=h.5ny9t6gbogm1)	37

	[d) Estandaraes de cumplimiento de la plataforma](#heading=h.5ny9t6gbogm1)	42

	[e) Estandaraes de calidad y seguridad](#heading=h.5ny9t6gbogm1)	42

[CONCLUSIONES](#heading=h.hbp4n4v6ebj2)	46

[RECOMENDACIONES](#heading=h.x6zczl28roiu)	46

[BIBLIOGRAFIA](#heading=h.4idlrnc7my76)	46

[WEBGRAFIA](#heading=h.7rm9u17unafv)	46

**1\. INTRODUCCIÓN**

**1.1 Propósito**

Este documento de visión define los requisitos de alto nivel y la arquitectura del Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas. Su propósito es establecer una comprensión común entre todos los interesados sobre las funcionalidades, objetivos y beneficios esperados del sistema, proporcionando la base para las decisiones de diseño y desarrollo del proyecto.

**1.2 Alcance**

El sistema abarca el desarrollo de una solución integral de control de acceso que incluye:

* Aplicación móvil multiplataforma para control de acceso  
* API REST para gestión de datos y comunicación  
* Dashboard web para análisis y reportes  
* Integración con pulseras inteligentes mediante Bluetooth  
* Sistema de machine learning para análisis predictivo  
* Módulos de administración de usuarios y reportería

El alcance excluye la fabricación de hardware de pulseras y la modificación de infraestructura física existente.

**1.3 Definiciones, Siglas y Abreviaturas**

BLE: Bluetooth Low Energy \- Tecnología de comunicación inalámbrica de bajo consumo

API: Application Programming Interface \- Interfaz de programación de aplicaciones

REST: Representational State Transfer \- Arquitectura para servicios web

JWT: JSON Web Token \- Estándar para tokens de acceso seguros

ML: Machine Learning \- Aprendizaje automático

GDPR: General Data Protection Regulation \- Reglamento General de Protección de Datos

IoT: Internet of Things \- Internet de las cosas

TIR: Tasa Interna de Retorno

VAN: Valor Actual Neto

**1.4 Referencias**

* IEEE 830-1998: Recommended Practice for Software Requirements Specifications  
* Ley N° 29733: Ley de Protección de Datos Personales del Perú  
* GDPR: Reglamento General de Protección de Datos de la UE  
* Flutter Documentation: https://flutter.dev/docs  
* Node.js Documentation: https://nodejs.org/docs  
* MongoDB Atlas Documentation: https://docs.atlas.mongodb.com

**1.5 Visión General**

Este documento presenta la visión del sistema desde la perspectiva del negocio y los usuarios finales, describiendo las oportunidades identificadas, los problemas a resolver, las necesidades de los interesados y las características principales del producto propuesto.

**2\. POSICIONAMIENTO**

**2.1 Oportunidad de negocio**

Contexto del mercado:

Las instituciones educativas están experimentando una transformación digital acelerada, impulsada por la necesidad de mejorar la eficiencia operativa y la experiencia estudiantil. El mercado global de sistemas de control de acceso inteligente se proyecta con un crecimiento del 8.7% anual, siendo el sector educativo uno de los más dinámicos.

Oportunidades identificadas:

* Modernización tecnológica: Las universidades buscan adoptar tecnologías IoT e inteligencia artificial para optimizar sus operaciones  
* Seguridad mejorada: Creciente demanda por sistemas de seguridad sin contacto post-pandemia  
* Análisis de datos: Necesidad de datos estructurados para la toma de decisiones basada en evidencia  
* Eficiencia operativa: Presión por reducir costos operativos y mejorar la asignación de recursos  
* Experiencia del usuario: Expectativas más altas de los estudiantes por servicios digitales modernos  
* Ventaja competitiva: Diferenciación institucional mediante innovación tecnológica

Valor propuesto:

* Reducción del 60% en tiempo de acceso estudiantil  
* Ahorro anual de S/. 114,000 en costos operativos  
* Datos en tiempo real para optimización de transporte universitario  
* ROI positivo con TIR del 18.5%  
* Cumplimiento de estándares internacionales de privacidad

**2.2 Definición del problema**

| Aspecto | Descripción |
| ----- | ----- |
| El problema | Los sistemas de control de acceso tradicionales en instituciones educativas generan cuellos de botella, largos tiempos de espera, procesos manuales propensos a errores y falta de trazabilidad en tiempo real, además de no proporcionar datos estructurados para análisis y optimización de recursos. |
| Afecta a | Estudiantes, personal de seguridad, administradores académicos, departamento de TI, y dirección de transporte universitario. |
| El impacto del cual es | \- Pérdida de tiempo académico por colas en accesos \- Congestiones en horarios pico \- Dificultades en planificación de transporte \- Ausencia de métricas para toma de decisiones \- Riesgos de seguridad por procesos manuales \- Experiencia estudiantil deficiente |
| Una solución exitosa sería | Un sistema integral que automatice el control de acceso mediante pulseras inteligentes, proporcione análisis predictivo en tiempo real, optimice el flujo estudiantil, y genere datos estructurados para la toma de decisiones estratégicas. |

**3\. DESCRIPCIÓN DE LOS INTERESADOS Y USUARIOS**

**3.1 Resumen de los interesados**

| Nombre | Descripción | Responsabilidades |
| ----- | ----- | ----- |
| Dirección Académica | Autoridades universitarias que toman decisiones estratégicas | Aprobación del proyecto, asignación de presupuesto, supervisión general |
| Departamento de TI | Equipo técnico institucional | Soporte técnico, mantenimiento, integración con sistemas existentes |
| Personal de Seguridad | Guardias y supervisores de seguridad | Operación diaria del sistema, monitoreo de accesos |
| Dirección de Transporte | Responsables del transporte universitario | Utilización de datos para optimización de rutas y horarios |
| Comité de Privacidad | Encargados del cumplimiento legal | Supervisión del cumplimiento de normativas de protección de datos |

**3.2. Resumen de los usuarios**

| Nombre | Descripción | Interesado |
| ----- | ----- | ----- |
| Estudiantes | Usuarios principales del sistema de acceso | Dirección Académica |
| Guardias de Seguridad | Operadores del sistema de control | Personal de Seguridad |
| Administradores del Sistema | Gestores de configuraciones y reportes | Departamento de TI |
| Analistas de Transporte | Usuarios de datos para optimización | Dirección de Transporte |

**3.3 Entorno de usuario**

Entorno físico:

* Puntos de acceso en edificios universitarios  
* Dispositivos móviles Android e iOS  
* Red Wi-Fi institucional  
* Computadoras para dashboard web

Entorno técnico:

* Sistemas operativos: Android 8.0+, iOS 12.0+, Windows 10+  
* Navegadores web modernos (Chrome, Firefox, Safari, Edge)  
* Conectividad: Wi-Fi, Bluetooth 4.0+  
* Resolución de pantalla: 1280x720 mínimo

Entorno organizacional:

* Horarios de operación: 6:00 AM \- 10:00 PM  
* Volumen de usuarios: 500-1000 estudiantes concurrentes  
* Estructura jerárquica con roles diferenciados  
* Cultura organizacional orientada a la innovación

**3.4 Perfiles de los interesados**

**3.4.1 Dirección Académica**

* Representante: Rector/Vicerrector Académico  
* Tipo: Decisor ejecutivo  
* Responsabilidades: Aprobación de presupuesto, supervisión estratégica  
* Criterios de éxito: ROI positivo, mejora en indicadores institucionales  
* Grado de participación: Alto en decisiones, bajo en operación  
* Comentarios: Enfoque en beneficios institucionales y competitividad

**3.4.2 Departamento de TI**

* Representante: Director de Tecnología  
* Tipo: Implementador técnico  
* Responsabilidades: Integración, mantenimiento, soporte técnico  
* Criterios de éxito: Sistema estable, bajo mantenimiento, escalable  
* Grado de participación: Alto durante todo el proyecto  
* Comentarios: Preocupación por compatibilidad y recursos técnicos

**3.4.3 Personal de Seguridad**

* Representante: Jefe de Seguridad  
* Tipo: Usuario operativo  
* Responsabilidades: Operación diaria, monitoreo, reportes de incidentes  
* Criterios de éxito: Sistema fácil de usar, confiable, mejore eficiencia  
* Grado de participación: Alto en pruebas y capacitación  
* Comentarios: Necesidad de capacitación y soporte continuo

**3.5 Perfiles de los Usuarios**

**3.5.1 Estudiantes**

* Tipo: Usuario final primario  
* Responsabilidades: Portación de pulsera, respeto de protocolos  
* Criterios de éxito: Acceso rápido y sin complicaciones  
* Grado de participación: Alto en uso, bajo en configuración  
* Comentarios: Expectativa de tecnología intuitiva y confiable

**3.5.2 Guardias de Seguridad**

Tipo: Usuario operativo

Responsabilidades:

* Monitorear accesos en tiempo real  
* Gestionar incidencias  
* Generar reportes básicos

Criterios de éxito:

* Interfaz intuitiva y rápida  
* Alertas claras y oportunas  
* Reducción de trabajo manual

Grado de participación: Alto en operación diaria

Comentarios: Necesitan capacitación en nuevas tecnologías

**3.5.3 Administradores del Sistema**

Tipo: Usuario avanzado

Responsabilidades:

* Configuración de parámetros del sistema  
* Gestión de usuarios y permisos  
* Análisis de reportes avanzados  
* Mantenimiento de datos

Criterios de éxito:

* Control granular sobre configuraciones  
* Reportes completos y personalizables  
* Herramientas de diagnóstico efectivas

Grado de participación: Alto en configuración y mantenimiento

Comentarios: Requieren funcionalidades avanzadas de administración

**3.5.4 Analistas de Transporte**

Tipo: Usuario especializado

Responsabilidades:

* Análisis de patrones de flujo estudiantil  
* Optimización de rutas y horarios  
* Predicción de demanda de transporte

Criterios de éxito:

* Datos precisos y oportunos  
* Herramientas de análisis predictivo  
* Dashboards especializados

Grado de participación: Medio en análisis de datos

Comentarios: Necesitan datos estructurados y herramientas de visualización

**3.6 Necesidades de los interesados y usuarios**

| Necesidad | Prioridad | Preocupaciones | Solución Actual | Solución Propuesta |
| ----- | ----- | ----- | ----- | ----- |
| Control de acceso rápido | Alta | Colas y demoras en horarios pico | Control manual con tarjetas | Sistema automatizado con pulseras BLE |
| Trazabilidad de accesos | Media | Falta de registros detallados | Registros manuales incompletos | Base de datos centralizada en tiempo real |
| Análisis predictivo | Media | Planificación ineficiente de recursos | Decisiones basadas en intuición | Machine learning para predicciones |
| Seguridad de datos | Alta | Cumplimiento normativo | Sistemas fragmentados | Arquitectura segura con encriptación |
| Facilidad de uso | Baja | Resistencia al cambio | Procesos complejos | Interfaz intuitiva y capacitación |
| Escalabilidad | Media | Crecimiento futuro | Limitaciones técnicas | Arquitectura cloud escalable |
| Costos operativos | Alta | Presupuesto limitado | Alto costo de personal | Automatización y optimización |

**4\. VISTA GENERAL DEL PRODUCTO**

**4.1 Perspectiva del producto**

Contexto del sistema:

El Sistema de Control de Acceso con Pulseras Inteligentes se posiciona como una solución integral que reemplaza los métodos tradicionales de control de acceso en instituciones educativas. El sistema opera como una plataforma independiente que se integra con la infraestructura tecnológica existente.

**Interfaces del sistema:**

* Interfaz de hardware: Comunicación con pulseras inteligentes vía Bluetooth Low Energy  
* Interfaz de red: Conexión con servicios cloud y bases de datos remotas  
* Interfaz de usuario: Aplicación móvil Flutter y dashboard web responsivo  
* Interfaz de datos: API REST para integración con sistemas universitarios existentes  
* Interfaz de seguridad: Sistemas de autenticación y encriptación de datos

**Funciones principales:**

* Control de acceso automatizado sin contacto  
* Gestión centralizada de usuarios y permisos  
* Análisis predictivo mediante machine learning  
* Generación de reportes y dashboards en tiempo real  
* Optimización de flujos y recursos institucionales

**4.2 Resumen de capacidades**

| Beneficio para el cliente | Características que lo soportan |
| :---- | :---- |
| Acceso rápido y eficiente | • Detección automática por Bluetooth • Tiempo de respuesta \< 2 segundos • Procesamiento en paralelo de múltiples accesos |
| Trazabilidad completa | • Registro de todos los accesos con timestamp • Geolocalización de puntos de acceso • Historial completo por usuario |
| Análisis inteligente | • Algoritmos de machine learning • Predicción de patrones de flujo • Recomendaciones automáticas |
| Administración centralizada | • Panel de control web • Gestión de roles y permisos • Configuración remota |
| Seguridad de datos | • Encriptación end-to-end • Autenticación JWT • Cumplimiento GDPR |
| Escalabilidad | • Arquitectura cloud • Balanceador de carga • Base de datos distribuida |

**4.3 Suposiciones y dependencias**

Suposiciones:

* Los usuarios tienen acceso a dispositivos móviles Android/iOS compatibles  
* La infraestructura de red Wi-Fi institucional es estable y tiene cobertura completa  
* Los estudiantes están dispuestos a portar pulseras inteligentes  
* La institución cuenta con personal técnico para soporte básico  
* Las pulseras inteligentes tienen una vida útil mínima de 2 años

Dependencias:

* Dependencias de hardware: Disponibilidad de pulseras BLE compatibles  
* Dependencias de red: Estabilidad de conexión a internet institucional  
* Dependencias de terceros: Servicios de MongoDB Atlas y hosting cloud  
* Dependencias regulatorias: Aprobación de comités de privacidad y ética  
* Dependencias organizacionales: Apoyo de la dirección académica  
* Dependencias técnicas: Compatibilidad con sistemas universitarios existentes

**4.4 Costos y precios**

Estructura de costos:

| Categoría | Costo | Descripción |
| ----- | ----- | ----- |
| Desarrollo inicial | S/. 127,300 | Costo único de desarrollo del sistema |
| Licencias anuales | S/. 12,000 | Servicios cloud y software |
| Mantenimiento anual | S/. 15,000 | Soporte técnico y actualizaciones |
| Capacitación | S/. 8,000 | Entrenamiento inicial de usuarios |

Modelo de precios:

* Inversión inicial: S/. 127,300  
* Costos operativos anuales: S/. 35,000  
* ROI esperado: 18.5% TIR  
* Payback period: 2.1 años

**4.5 Licenciamiento e instalación**

Modelo de licenciamiento:

* Licencia empresarial para uso institucional  
* Actualizaciones incluidas durante el primer año  
* Soporte técnico 24/7 durante horarios académicos  
* Licencias adicionales para expansión modular

Proceso de instalación:

* Fase 1: Configuración de infraestructura cloud (1 semana)

Fase 2: Desarrollo e implementación de software (14 semanas)

* Fase 3: Testing y capacitación (2 semanas)  
* Fase 4: Deployment y puesta en producción (1 semana)

**5\. CARACTERÍSTICAS DEL PRODUCTO**

**CAR-01: Autenticación y Control de Acceso**

* Descripción: Sistema de autenticación segura con detección automática de pulseras  
* Prioridad: Alta  
* Funcionalidades:  
  * Autenticación de guardias mediante credenciales  
  * Detección automática de pulseras BLE  
  * Validación de permisos de acceso  
  * Registro de eventos de acceso

**CAR-02: Gestión de Usuarios y Roles**

* Descripción: Administración centralizada de usuarios con roles diferenciados  
* Prioridad: Alta  
* Funcionalidades:  
  * Registro y activación de cuentas de guardias  
  * Asignación de roles (Guardia/Administrador)  
  * Gestión de permisos por punto de acceso  
  * Cambio de contraseñas y recuperación de cuenta

**CAR-03: Dashboard y Reportería**

* Descripción: Interfaz web para visualización de datos y generación de reportes  
* Prioridad: Media  
* Funcionalidades:  
  * Dashboard en tiempo real de accesos  
  * Gráficos de flujo por horarios  
  * Exportación de reportes  
  * Alertas automáticas de congestión

**CAR-04: Análisis Predictivo con Machine Learning**

* Descripción: Sistema de inteligencia artificial para predicción de patrones  
* Prioridad: Media  
* Funcionalidades:  
  * Algoritmos de regresión lineal y clustering  
  * Análisis de series temporales  
  * Predicción de horarios pico  
  * Recomendaciones para optimización de transporte

**CAR-05: API REST de Integración**

* Descripción: Servicios web para integración con sistemas externos  
* Prioridad: Alta  
* Funcionalidades:  
  * Endpoints RESTful documentados  
  * Autenticación JWT  
  * Versionado de API  
  * Rate limiting y throttling

**6\. RESTRICCIONES**

**Restricciones Técnicas:**

* RES-01: La aplicación móvil debe ser compatible con Android 8.0+ e iOS 12.0+  
* RES-02: El alcance de comunicación Bluetooth está limitado a 10 metros  
* RES-03: La base de datos debe almacenar mínimo 2 años de historial  
* RES-04: El sistema debe soportar hasta 1000 usuarios concurrentes

**Restricciones de Diseño:**

* RES-05: La interfaz debe seguir principios de Material Design (Android) y Human Interface Guidelines (iOS)  
* RES-06: El tiempo de respuesta máximo para autenticación es 3 segundos  
* RES-07: La aplicación debe funcionar offline para accesos de emergencia

**Restricciones Organizacionales:**

* RES-08: El proyecto debe completarse en 4 meses  
* RES-09: El presupuesto máximo es S/. 127,300  
* RES-10: Debe cumplir con la Ley N° 29733 de Protección de Datos Personales

**7\. RANGOS DE CALIDAD**

| Atributo de Calidad | Muy Bueno | Bueno | Normal | Pobre |
| ----- | ----- | ----- | ----- | ----- |
| Facilidad de Uso | Intuitivo sin capacitación | Requiere capacitación mínima | Requiere capacitación formal | Difícil de usar |
| Rendimiento | \< 1 segundo respuesta | \< 2 segundos respuesta | \< 3 segundos respuesta | \> 3 segundos respuesta |
| Confiabilidad | 99.9% uptime | 99.5% uptime | 99% uptime | \< 99% uptime |
| Escalabilidad | \> 2000 usuarios | 1000-2000 usuarios | 500-1000 usuarios | \< 500 usuarios |
| Seguridad | Encriptación militar | Encriptación estándar | Autenticación básica | Sin encriptación |

**8\. PRECEDENCIA Y PRIORIDAD**

| Característica | Prioridad | Precedencia | Justificación |
| ----- | ----- | ----- | ----- |
| Control de Acceso | Crítica | 1 | Funcionalidad principal del sistema |
| Autenticación | Crítica | 2 | Prerrequisito para seguridad |
| Gestión de Usuarios | Alta | 3 | Necesario para administración |
| API REST | Alta | 4 | Base para integraciones |
| Dashboard Web | Media | 5 | Importante para reportes |
| Machine Learning | Media | 6 | Valor agregado para optimización |
| Notificaciones | Baja | 7 | Mejora la experiencia de usuario |

**9\. OTROS REQUERIMIENTOS DEL PRODUCTO**

**a) Estándares Aplicables**

* IEEE 802.15.1: Estándar para comunicaciones Bluetooth  
* ISO 27001: Gestión de seguridad de la información  
* W3C Web Standards: Para desarrollo del dashboard web  
* RESTful API Design: Principios REST para servicios web

**b) Estándares Legales**

**Protección de Datos:**

**Ley N° 29733 \- Ley de Protección de Datos Personales (Perú)**

* Consentimiento explícito para recolección de datos  
* Derecho de acceso, rectificación y cancelación  
* Medidas de seguridad técnicas y organizativas  
* Transferencia internacional bajo estándares adecuados

**GDPR \- Reglamento General de Protección de Datos (UE)**

* Privacy by Design en arquitectura del sistema  
* Minimización de datos recolectados  
* Portabilidad de datos del usuario  
* Notificación de brechas de seguridad en 72 horas

**Seguridad Informática:**

* Ley N° 30096 \- Ley de Delitos Informáticos  
* DS N° 003-2013-JUS \- Reglamento de la Ley de Protección de Datos  
* Directiva de Seguridad de la Información del Estado

**c) Estándares de Comunicación**

**Protocolos de Red:**

* HTTPS/TLS 1.3: Comunicación segura cliente-servidor  
* WebSocket Secure (WSS): Comunicaciones en tiempo real  
* OAuth 2.0 / OpenID Connect: Autorización y autenticación  
* JWT (JSON Web Tokens): Tokens de sesión seguros

**Comunicación Bluetooth:**

* Bluetooth Low Energy (BLE) 4.0+  
* Generic Access Profile (GAP)  
* Generic Attribute Profile (GATT)  
* Protocolos de pareamiento seguro

**APIs y Servicios Web:**

* RESTful API Design Principles  
* OpenAPI 3.0 Specification  
* JSON Schema for data validation  
* Rate limiting and throttling standards

**d) Estándares de Cumplimiento de la Plataforma**

**Plataformas Móviles:**

**Android:**

* Material Design Guidelines  
* Android Security Model  
* Google Play Store Policies  
* Android Runtime Permissions

**iOS:**

* Human Interface Guidelines  
* App Store Review Guidelines  
* iOS Security Architecture  
* Core Bluetooth Framework

**Plataformas Web:**

* W3C Web Standards  
* WCAG 2.1 AA (Web Content Accessibility Guidelines)  
* Progressive Web App (PWA) Standards  
* Cross-browser compatibility (Chrome, Firefox, Safari, Edge)

**e) Estándares de Calidad y Seguridad**

**Calidad de Software:**

**ISO/IEC 25010 \- Software Quality Mod**el

* Funcionalidad: Completitud, corrección, pertinencia  
* Confiabilidad: Madurez, tolerancia a fallos, recuperabilidad  
* Usabilidad: Reconocimiento, aprendizaje, operabilidad  
* Eficiencia: Tiempo, recursos, capacidad  
* Mantenibilidad: Modularidad, reusabilidad, analizabilidad  
* Portabilidad: Adaptabilidad, instalabilidad, reemplazabilidad

**Seguridad de la Información:**

* ISO 27001/27002 \- Information Security Management  
* OWASP Top 10 \- Web Application Security Risks  
* NIST Cybersecurity Framework  
* CIS Controls for Effective Cyber Defense

**Arquitectura y Desarrollo:**

* Clean Architecture Principles  
* SOLID Design Principles  
* RESTful API Design Best Practices  
* Microservices Architecture Patterns  
* Test-Driven Development (TDD)  
* Continuous Integration/Continuous Deployment (CI/CD)

**Monitoreo y Operaciones:**

* ITIL v4 \- Service Management  
* SLA (Service Level Agreement) Standards  
* Application Performance Monitoring (APM)  
* Log Management and Analysis Standards

**CONCLUSIONES**

El Sistema de Control de Acceso con Pulseras Inteligentes representa una solución innovadora que aborda las necesidades críticas de las instituciones educativas modernas. El análisis de visión confirma que:

1. Existe una oportunidad de mercado clara con beneficios cuantificables y ROI positivo  
2. Los interesados están alineados en los objetivos y beneficios esperados del sistema  
3. Las características propuestas satisfacen las necesidades identificadas de todos los usuarios  
4. El alcance del proyecto es realizable dentro de las restricciones de tiempo y presupuesto establecidas  
5. Los estándares de calidad y seguridad garantizan un producto robusto y confiable

**RECOMENDACIONES**

1. Proceder con el desarrollo del sistema según las especificaciones definidas  
2. Implementar un piloto inicial con un grupo reducido de usuarios para validar funcionalidades  
3. Establecer un programa de capacitación para garantizar adopción exitosa  
4. Definir métricas de éxito claras para evaluar el impacto del sistema  
5. Planificar actualizaciones futuras basadas en feedback de usuarios y evolución tecnológica

**BIBLIOGRAFÍA**

* Sommerville, I. (2016). Software Engineering. 10th Edition. Pearson Education.  
* Pressman, R. & Maxim, B. (2019). Software Engineering: A Practitioner's Approach. 9th Edition. McGraw-Hill Education.  
* Cockburn, A. (2000). Writing Effective Use Cases. Addison-Wesley Professional.  
* IEEE Computer Society (1998). IEEE Recommended Practice for Software Requirements Specifications. IEEE Std 830-1998.  
* Beck, K. & Fowler, M. (2000). Planning Extreme Programming. Addison-Wesley Professional.  
* Martin, R. C. (2017). Clean Architecture: A Craftsman's Guide to Software Structure and Design. Prentice Hall.

**WEBGRAFÍA**

* Flutter Development Documentation. (2025). Building Mobile Applications. Retrieved from: https://flutter.dev/docs  
* MongoDB Atlas Documentation. (2025). Cloud Database Services. Retrieved from: https://docs.atlas.mongodb.com  
* Node.js Official Documentation. (2025). Runtime Environment. Retrieved from: https://nodejs.org/docs  
* Bluetooth SIG. (2025). Bluetooth Low Energy Specifications. Retrieved from: https://www.bluetooth.com/specifications/bluetooth-core-specification  
* OWASP Foundation. (2025). Web Application Security. Retrieved from: https://owasp.org/www-project-top-ten  
* W3C Web Standards. (2025). Web Technologies and Standards. Retrieved from: https://www.w3.org/standards  
* ISO/IEC 27001:2022. Information Security Management Systems. Retrieved from: https://www.iso.org/standard/27001  
* Gobierno del Perú. (2011). Ley N° 29733 \- Ley de Protección de Datos Personales. Retrieved from: https://www.gob.pe/institucion/congreso-de-la-republica/normas-legales/243470-29733

[image1]: <data:image/png;base64,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>