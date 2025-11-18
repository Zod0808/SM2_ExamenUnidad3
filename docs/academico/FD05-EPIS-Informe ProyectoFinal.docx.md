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
| 1.0 | CCL | OJF | OJF | 24/10/2025 | Versión Original |

# **ÍNDICE GENERAL**

[1\.	Antecedentes	2](#heading)

[2\.	Planteamiento del Problema	2](#planteamiento-del-problema)

[c.	Alcance	3](#alcance)

[3\.	Objetivos	3](#objetivos)

[4\.	Marco Teórico	3](#marco-teórico)

[5\.	Desarrollo de la Solución	3](#desarrollo-de-la-solución)

[c.	Metodología de implementación (Documento de VISION, SRS, SAD)	3](#metodología-de-implementación-\(documento-de-vision,-srs,-sad\))

[6\.	Cronograma	3](#cronograma)

[7\.	Presupuesto	3](#presupuesto)

[8\.	Conclusiones	3](#conclusiones)

[Recomendaciones	3](#recomendaciones)

[Bibliografía	3](#bibliografía)

[Anexos	3](#anexos)

[Anexo 01 \- Informe de Factibilidad	3](#anexo-01---informe-de-factibilidad)

[Anexo 02 \- Documento de Visión	3](#anexo-02---documento-de-visión)

[Anexo 03 \- Documento SRS	3](#anexo-03---documento-srs)

[Anexo 04 \- Documento SAD	3](#anexo-04---documento-sad)

[Anexo 05 \- Manuales y otros documentos	3](#anexo-05---manuales-y-otros-documentos)

# **1. Antecedentes**

Las instituciones educativas en el Perú y a nivel mundial enfrentan desafíos significativos en la gestión eficiente del control de acceso estudiantil. Los sistemas tradicionales basados en tarjetas físicas, códigos manuales o registros en papel presentan limitaciones que afectan la operatividad institucional, la experiencia estudiantil y la capacidad de análisis de datos para la toma de decisiones.

La Universidad Privada de Tacna, como institución comprometida con la innovación tecnológica y la mejora continua de sus servicios, ha identificado la necesidad de modernizar su sistema de control de acceso mediante la implementación de tecnologías emergentes como Internet de las Cosas (IoT), Bluetooth Low Energy (BLE) y Machine Learning.

El proyecto "Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas" surge como respuesta a esta necesidad, buscando aprovechar las ventajas de las tecnologías móviles modernas, la computación en la nube y la inteligencia artificial para crear una solución integral que mejore la eficiencia operativa, proporcione datos estructurados para análisis predictivo y optimice la experiencia de todos los usuarios del sistema.

Este proyecto se desarrolla en el contexto del curso Soluciones Móviles II de la Escuela Profesional de Ingeniería de Sistemas, bajo la supervisión del Dr. Oscar Juan Jimenez Flores, y representa un esfuerzo conjunto de un equipo multidisciplinario de estudiantes comprometidos con la excelencia académica y la innovación tecnológica.

# **2. Planteamiento del Problema** {#planteamiento-del-problema}

## **2.1 Problema**

Actualmente, las instituciones educativas enfrentan desafíos significativos en el control de acceso tradicional de estudiantes, que incluyen:

- **Largos tiempos de espera:** Los sistemas convencionales basados en tarjetas o códigos requieren contacto físico y validación manual, generando cuellos de botella en horarios pico (7:00 AM - 8:30 AM y 12:00 PM - 2:00 PM), donde los estudiantes pueden esperar hasta 15 minutos para ingresar al campus.

- **Procesos manuales propensos a errores:** El registro manual de accesos resulta en información incompleta, errores de transcripción y falta de precisión en los datos, dificultando la trazabilidad y el análisis posterior.

- **Falta de trazabilidad en tiempo real:** No existe un sistema que permita conocer en tiempo real cuántos estudiantes están en el campus, qué estudiantes han ingresado o salido, y cuáles son los patrones de flujo estudiantil.

- **Riesgos sanitarios:** Los sistemas que requieren contacto físico (tarjetas, teclados, torniquetes) representan riesgos de transmisión de enfermedades, especialmente relevante en contextos post-pandemia.

- **Ausencia de análisis predictivo:** No hay datos estructurados que permitan predecir patrones de flujo estudiantil, lo que impide una planificación eficiente del transporte universitario y la optimización de recursos.

- **Dificultades en la gestión de transporte:** La falta de información sobre horarios pico y demanda real resulta en buses subutilizados en algunos horarios y sobrecargados en otros, generando ineficiencia operativa y mala experiencia estudiantil.

La problemática se agrava por la falta de integración entre los sistemas de seguridad, transporte y administración académica, lo que impide una visión holística de la movilidad estudiantil y dificulta la toma de decisiones basada en datos.

## **2.2 Justificación**

La implementación de un sistema de control de acceso con pulseras inteligentes se justifica por las siguientes razones:

**Justificación Técnica:**
- La tecnología Bluetooth Low Energy (BLE) está madura y ampliamente disponible, permitiendo comunicación sin contacto a distancias de hasta 10 metros.
- Las tecnologías de desarrollo móvil (Flutter) y backend (Node.js) ofrecen soluciones robustas y escalables para sistemas de este tipo.
- La infraestructura cloud (MongoDB Atlas) garantiza disponibilidad, escalabilidad y respaldo automático de datos.

**Justificación Económica:**
- El análisis financiero demuestra un ROI positivo con TIR del 18.5% y VAN de S/. 6,208.02.
- Beneficios anuales estimados de S/. 114,000 incluyendo reducción de costos operativos (S/. 45,000), ahorro en personal (S/. 36,000), optimización de transporte (S/. 25,000) y reducción de pérdidas (S/. 8,000).
- Periodo de recuperación de inversión de 2.1 años.

**Justificación Operativa:**
- Reducción del 60% en tiempo de acceso estudiantil, mejorando significativamente la experiencia del usuario.
- Eliminación de procesos manuales propensos a errores mediante automatización completa.
- Trazabilidad completa de accesos en tiempo real para mejorar la seguridad institucional.

**Justificación Social:**
- Mejora en la experiencia estudiantil mediante acceso rápido y sin contacto físico.
- Reducción de estrés en horarios pico al eliminar colas y esperas prolongadas.
- Cultura tecnológica favorable en el ámbito universitario que apoya la innovación.

**Justificación Legal:**
- Cumplimiento con Ley N° 29733 de Protección de Datos Personales del Perú.
- Adherencia a estándares internacionales GDPR para protección de datos.
- Implementación de medidas de seguridad informática según normativas vigentes.

## **2.3 Alcance** {#alcance}

### **Dentro del Alcance:**

**Aplicación Móvil Flutter:**
- Sistema de autenticación de guardias con roles diferenciados (Guardia/Administrador)
- Detección automática de pulseras inteligentes vía Bluetooth Low Energy (BLE)
- Registro de accesos (entrada/salida) con timestamp y geolocalización
- Visualización de estudiantes en tiempo real
- Historial de accesos y búsqueda de estudiantes
- Funcionalidad offline con sincronización posterior

**API REST Node.js:**
- Endpoints para autenticación y autorización con JWT
- Gestión de usuarios (guardias y administradores)
- Procesamiento de eventos de acceso
- Integración con base de datos MongoDB Atlas
- Servicios de sincronización online/offline
- Rate limiting y seguridad de endpoints

**Base de Datos MongoDB Atlas:**
- Almacenamiento de datos de estudiantes, guardias y administradores
- Registro histórico de accesos con retención mínima de 2 años
- Gestión de puntos de control y asignaciones
- Datos para análisis predictivo y machine learning

**Dashboard Web:**
- Visualización de accesos en tiempo real
- Reportes y gráficos de flujo estudiantil
- Análisis de patrones y tendencias
- Exportación de datos para análisis externo
- Configuración de parámetros del sistema

**Módulo de Machine Learning:**
- Algoritmos de regresión lineal para predicción de flujo
- Clustering para identificación de patrones
- Análisis de series temporales para predicción de horarios pico
- Recomendaciones para optimización de transporte universitario

### **Fuera del Alcance:**

- Fabricación de hardware de pulseras inteligentes (se adquiere de terceros)
- Modificación de infraestructura física de edificios
- Integración con sistemas de pago o biblioteca
- Aplicación móvil para estudiantes (fase futura)
- Sistema de reconocimiento facial o biométrico
- Control de acceso vehicular
- Integración con sistemas académicos más allá de lectura de datos básicos

# **3. Objetivos** {#objetivos}

## **3.1 Objetivo General**

Garantizar un control de acceso rápido, seguro y sin contacto para instituciones educativas mediante pulseras inteligentes, mejorando la eficiencia operativa y proporcionando análisis predictivo para la optimización de recursos.

## **3.2 Objetivos Específicos**

**Objetivos de Negocio:**
- **OBN-01:** Reducir en un 60% el tiempo promedio de acceso de estudiantes al campus universitario.
- **OBN-02:** Disminuir los costos operativos de seguridad en S/. 45,000 anuales mediante la automatización de procesos.
- **OBN-03:** Optimizar el servicio de transporte universitario, ahorrando S/. 25,000 anuales en costos operativos mediante mejor planificación de rutas y horarios.
- **OBN-04:** Generar datos estructurados y análisis predictivo para mejorar la toma de decisiones institucionales.
- **OBN-05:** Mejorar la experiencia estudiantil mediante un acceso fluido y sin contacto físico.
- **OBN-06:** Proporcionar trazabilidad completa de accesos para mejorar la seguridad institucional.
- **OBN-07:** Obtener un retorno de inversión (ROI) positivo con una TIR del 18.5% en un periodo de 2.1 años.

**Objetivos de Diseño:**
- **OD-01:** Implementar un sistema de autenticación robusto con roles diferenciados (Guardia y Administrador) utilizando JWT y encriptación de contraseñas.
- **OD-02:** Desarrollar módulos de detección automática de pulseras inteligentes mediante Bluetooth Low Energy (BLE) con alcance efectivo de 10 metros y tiempo de respuesta menor a 2 segundos.
- **OD-03:** Diseñar una arquitectura basada en microservicios con API REST en Node.js y base de datos MongoDB Atlas, capaz de soportar hasta 1000 usuarios concurrentes.
- **OD-04:** Crear una aplicación móvil nativa con Flutter compatible con Android 8.0+ e iOS 12.0+, siguiendo principios de Material Design y Human Interface Guidelines.
- **OD-05:** Desarrollar una interfaz web responsiva para visualización de datos en tiempo real, reportes y análisis predictivo, compatible con navegadores modernos.
- **OD-06:** Implementar algoritmos de aprendizaje automático (regresión lineal, clustering, series temporales) para predicción de patrones de flujo estudiantil y optimización de transporte.
- **OD-07:** Diseñar mecanismos de funcionamiento offline para garantizar continuidad del servicio en caso de pérdida de conectividad, con sincronización automática posterior.
- **OD-08:** Asegurar cumplimiento con estándares de seguridad (ISO 27001), protección de datos (Ley N° 29733, GDPR) y calidad de software (ISO/IEC 25010).

# **4. Marco Teórico** {#marco-teórico}

## **4.1 Tecnologías de Desarrollo Móvil**

**Flutter:** Framework de desarrollo multiplataforma desarrollado por Google que permite crear aplicaciones nativas para Android e iOS desde un único código base. Utiliza el lenguaje Dart y proporciona widgets personalizables de alto rendimiento. Flutter es ideal para este proyecto debido a su capacidad de acceso a APIs nativas como Bluetooth, GPS y almacenamiento local.

**Bluetooth Low Energy (BLE):** Tecnología de comunicación inalámbrica diseñada para dispositivos IoT que consume mínima energía. BLE permite comunicación bidireccional a distancias de hasta 10 metros, ideal para pulseras inteligentes que requieren batería de larga duración. El protocolo GATT (Generic Attribute Profile) permite la transmisión de datos estructurados entre dispositivos.

## **4.2 Arquitectura de Software**

**Arquitectura REST:** Representational State Transfer es un estilo arquitectónico para servicios web que utiliza métodos HTTP estándar (GET, POST, PUT, DELETE) y formatos de datos como JSON. Esta arquitectura facilita la integración entre diferentes sistemas y garantiza escalabilidad y mantenibilidad.

**Arquitectura de Microservicios:** Patrón arquitectónico que divide una aplicación en servicios independientes y desacoplados. Cada microservicio puede desarrollarse, desplegarse y escalarse independientemente, mejorando la flexibilidad y resiliencia del sistema.

**Modelo Vista-Controlador (MVC):** Patrón de diseño que separa la lógica de negocio (Modelo), la presentación (Vista) y el control de flujo (Controlador). Este patrón facilita el mantenimiento y la escalabilidad del código.

## **4.3 Bases de Datos NoSQL**

**MongoDB:** Base de datos NoSQL orientada a documentos que almacena datos en formato BSON (Binary JSON). MongoDB Atlas proporciona una solución cloud escalable con replicación automática, respaldo y alta disponibilidad. Ideal para sistemas que manejan grandes volúmenes de datos no estructurados y requieren escalabilidad horizontal.

## **4.4 Machine Learning y Análisis Predictivo**

**Regresión Lineal:** Algoritmo de aprendizaje supervisado que modela la relación entre variables dependientes e independientes mediante una función lineal. Utilizado para predecir patrones de flujo estudiantil basados en variables como día de la semana, hora y eventos académicos.

**Clustering:** Técnica de aprendizaje no supervisado que agrupa datos similares en clusters. Permite identificar patrones de comportamiento estudiantil y segmentar usuarios según sus hábitos de acceso.

**Series Temporales:** Análisis estadístico de datos ordenados cronológicamente para identificar tendencias, estacionalidad y patrones cíclicos. Fundamental para predecir horarios pico y optimizar recursos de transporte.

## **4.5 Seguridad y Protección de Datos**

**JWT (JSON Web Tokens):** Estándar abierto para transmitir información de forma segura entre partes como objeto JSON. Los tokens JWT permiten autenticación stateless y son ideales para APIs REST.

**Encriptación:** Proceso de codificación de información para protegerla de accesos no autorizados. El sistema utiliza encriptación AES-256 para datos en reposo y TLS 1.3 para datos en tránsito.

**Ley N° 29733:** Ley de Protección de Datos Personales del Perú que establece principios y medidas para el tratamiento de datos personales, garantizando los derechos de acceso, rectificación y cancelación de información.

**GDPR:** Reglamento General de Protección de Datos de la Unión Europea que establece estándares internacionales para la protección de datos personales, incluyendo principios de Privacy by Design y minimización de datos.

## **4.6 Metodologías de Desarrollo**

**Desarrollo Ágil:** Metodología iterativa e incremental que enfatiza la colaboración, flexibilidad y entrega continua de valor. Permite adaptación rápida a cambios en requisitos y feedback temprano de usuarios.

**DevOps:** Conjunto de prácticas que combina desarrollo de software (Dev) y operaciones (Ops) para acortar el ciclo de vida del desarrollo y proporcionar entrega continua con alta calidad.

**Test-Driven Development (TDD):** Metodología de desarrollo que requiere escribir pruebas antes del código de producción, garantizando mayor cobertura de pruebas y código más robusto.

# **5. Desarrollo de la Solución** {#desarrollo-de-la-solución}

## **5.1 Análisis de Factibilidad**

### **5.1.1 Factibilidad Técnica**

La evaluación técnica confirma la disponibilidad de recursos tecnológicos necesarios y su aplicabilidad al proyecto propuesto.

**Tecnología Disponible:**
- **Desarrollo móvil:** Flutter proporciona desarrollo multiplataforma eficiente con acceso a APIs nativas de Bluetooth y GPS.
- **Backend:** Node.js ofrece escalabilidad y rendimiento adecuados para APIs REST con soporte para hasta 1000 usuarios concurrentes.
- **Base de datos:** MongoDB Atlas garantiza disponibilidad y escalabilidad en la nube con replicación automática y respaldo.
- **Conectividad:** Bluetooth Low Energy es ampliamente compatible y eficiente energéticamente, con soporte nativo en dispositivos Android e iOS.
- **Machine Learning:** Python y TensorFlow proporcionan herramientas robustas para análisis predictivo y modelado de datos.

**Infraestructura Requerida:**
- Servidores cloud con capacidad de procesamiento para 500-1000 usuarios concurrentes
- Red Wi-Fi institucional con cobertura completa en puntos de acceso
- Sistema de respaldo y recuperación de datos con replicación automática
- Herramientas de monitoreo y análisis de rendimiento

**Conclusión:** La tecnología propuesta es madura, bien documentada y cuenta con amplio soporte de la comunidad, garantizando la factibilidad técnica del proyecto.

### **5.1.2 Factibilidad Económica**

El análisis económico evalúa los beneficios del proyecto en relación con los costos de inversión y operación.

**Costos del Proyecto:**
- **Costos Generales:** S/. 6,700 (material de oficina, equipos adicionales, licencias)
- **Costos Operativos (4 meses):** S/. 4,600 (servicios cloud, internet, energía)
- **Costos del Ambiente:** S/. 22,000 (configuración de servidores, infraestructura de red, pulseras inteligentes)
- **Costos de Personal (4 meses):** S/. 94,000 (Project Manager, desarrolladores, especialista ML, QA)
- **COSTO TOTAL DEL PROYECTO:** S/. 127,300

**Beneficios Anuales Estimados:**
- Reducción de costos operativos: S/. 45,000 anuales
- Ahorro en personal: S/. 36,000 anuales
- Optimización de transporte: S/. 25,000 anuales
- Reducción de pérdidas: S/. 8,000 anuales
- **TOTAL BENEFICIOS ANUALES:** S/. 114,000

**Indicadores Financieros:**
- **Relación Beneficio/Costo (B/C) a 2 años:** 1.16
- **Valor Actual Neto (VAN) al 12%:** S/. 6,208.02
- **Tasa Interna de Retorno (TIR):** 18.5%
- **Periodo de Recuperación:** 2.1 años

**Conclusión:** Los indicadores financieros demuestran viabilidad económica positiva con ROI favorable y recuperación de inversión en plazo razonable.

### **5.1.3 Factibilidad Operativa**

El sistema ofrece beneficios operativos significativos y la institución cuenta con la capacidad para mantenerlo funcionando.

**Beneficios del Producto:**
- Reducción del 60% en tiempo de acceso de estudiantes
- Eliminación de colas y procesos manuales
- Trazabilidad completa de accesos en tiempo real
- Análisis predictivo para optimización de recursos
- Mejora en la experiencia del usuario
- Datos estructurados para toma de decisiones

**Capacidad del Cliente:**
- Personal técnico disponible para mantenimiento básico
- Infraestructura IT existente compatible
- Presupuesto asignado para soporte técnico
- Compromiso institucional con la innovación tecnológica

**Conclusión:** Los beneficios operativos superan las barreras de adopción, con fuerte apoyo institucional y capacidad técnica para mantener el sistema.

### **5.1.4 Factibilidad Legal**

El proyecto cumple con las regulaciones legales aplicables.

**Cumplimiento Normativo:**
- Ley de Protección de Datos Personales (Ley N° 29733)
- Reglamento General de Protección de Datos (GDPR) para estándares internacionales
- Normas de seguridad informática institucionales
- Regulaciones de dispositivos IoT y comunicaciones inalámbricas

**Medidas Implementadas:**
- Encriptación de datos en tránsito y almacenamiento
- Políticas de retención y eliminación de datos
- Consentimiento explícito para recolección de datos
- Auditorías de seguridad periódicas

**Conclusión:** El proyecto cumple con todas las regulaciones aplicables de protección de datos y seguridad.

### **5.1.5 Factibilidad Social**

El proyecto considera aspectos sociales y culturales del entorno.

**Factores Positivos:**
- Mejora en la experiencia estudiantil
- Reducción de estrés en horarios pico
- Cultura tecnológica favorable en el ámbito universitario
- Apoyo institucional a la innovación

**Consideraciones Éticas:**
- Respeto a la privacidad estudiantil
- Transparencia en el uso de datos
- Inclusión de estudiantes con necesidades especiales
- Comunicación clara sobre beneficios y funcionamiento

**Conclusión:** Alto nivel de aceptación esperado y beneficios sociales claros para la comunidad universitaria.

### **5.1.6 Factibilidad Ambiental**

El proyecto tiene impacto ambiental positivo.

**Beneficios Ambientales:**
- Reducción en uso de papel (procesos digitales)
- Optimización de rutas de transporte reduce emisiones
- Pulseras reutilizables y de larga duración
- Eficiencia energética de dispositivos BLE

**Medidas de Sostenibilidad:**
- Programa de reciclaje de pulseras al final de su vida útil
- Optimización de algoritmos para reducir consumo computacional
- Uso de servicios cloud eficientes energéticamente

**Conclusión:** Impacto ambiental positivo con reducción de emisiones y uso eficiente de recursos.

## **5.2 Tecnología de Desarrollo**

### **5.2.1 Stack Tecnológico Frontend**

**Aplicación Móvil:**
- **Framework:** Flutter 3.x con Dart 3.x
- **Estado:** Provider/Riverpod para gestión de estado
- **Navegación:** Navigator 2.0 con go_router
- **Bluetooth:** flutter_blue_plus para comunicación BLE
- **Almacenamiento Local:** SQLite con sqflite
- **HTTP:** Dio para comunicación con API REST
- **Geolocalización:** geolocator para coordenadas GPS

**Dashboard Web:**
- **Framework:** React.js o Vue.js para interfaz interactiva
- **Visualización:** Chart.js o D3.js para gráficos y reportes
- **Estilos:** Bootstrap o Tailwind CSS para diseño responsivo
- **WebSockets:** Socket.io para actualizaciones en tiempo real

### **5.2.2 Stack Tecnológico Backend**

**API REST:**
- **Runtime:** Node.js 18.x LTS
- **Framework:** Express.js para servidor HTTP
- **Autenticación:** jsonwebtoken para JWT
- **Validación:** Joi o express-validator
- **Base de Datos:** Mongoose ODM para MongoDB
- **Cache:** Redis para sesiones y datos temporales
- **Logging:** Winston para registro de eventos
- **Testing:** Jest para pruebas unitarias e integración

**Base de Datos:**
- **Motor:** MongoDB Atlas (Cloud)
- **Modelado:** Esquemas Mongoose con validación
- **Índices:** Optimización de consultas frecuentes
- **Replicación:** Replica sets para alta disponibilidad

**Machine Learning:**
- **Lenguaje:** Python 3.9+
- **Framework:** TensorFlow/Keras para modelos de deep learning
- **Análisis:** Pandas y NumPy para procesamiento de datos
- **Visualización:** Matplotlib y Seaborn para gráficos
- **API:** Flask o FastAPI para servicios ML

### **5.2.3 Infraestructura y DevOps**

**Cloud Services:**
- **Hosting:** MongoDB Atlas (M0-M10 según carga)
- **API Hosting:** Heroku, AWS EC2 o DigitalOcean
- **CDN:** CloudFlare para entrega de contenido estático
- **Monitoreo:** New Relic o Datadog para APM

**CI/CD:**
- **Control de Versiones:** Git con GitHub/GitLab
- **CI:** GitHub Actions o GitLab CI
- **Testing Automatizado:** Jest, Flutter Test
- **Deployment:** Docker containers para consistencia

## **5.3 Metodología de Implementación (Documento de VISION, SRS, SAD)** {#metodología-de-implementación-(documento-de-vision,-srs,-sad)}

### **5.3.1 Fase de Análisis y Planificación**

**Documento de Visión:**
El Documento de Visión estableció la base conceptual del proyecto, definiendo:
- Oportunidades de negocio y valor propuesto
- Descripción de interesados y usuarios
- Características principales del producto
- Restricciones y rangos de calidad
- Precedencia y prioridad de funcionalidades

**Resultados:**
- Identificación clara de objetivos de negocio y diseño
- Definición de perfiles de usuarios (Guardias, Administradores, Estudiantes, Analistas)
- Establecimiento de criterios de éxito medibles
- Priorización de características según impacto y complejidad

### **5.3.2 Fase de Especificación de Requerimientos**

**Documento SRS (Especificación de Requerimientos de Software):**
El documento SRS detalló los requerimientos funcionales y no funcionales del sistema:

**Requerimientos Funcionales Principales:**
- RF-001: Sistema de autenticación con roles diferenciados
- RF-002: Detección automática de pulseras BLE
- RF-003: Registro de accesos (entrada/salida)
- RF-004: Gestión de usuarios y permisos
- RF-005: Dashboard de reportes y visualización
- RF-006: Funcionalidad offline con sincronización
- RF-007: Módulo de machine learning para predicciones

**Requerimientos No Funcionales:**
- Rendimiento: Tiempo de respuesta < 2 segundos
- Seguridad: Encriptación AES-256, JWT, HTTPS
- Usabilidad: Interfaz intuitiva siguiendo Material Design
- Confiabilidad: 99.5% uptime, tolerancia a fallos
- Escalabilidad: Soporte para 1000 usuarios concurrentes

**Modelos de Diseño:**
- Diagrama de Casos de Uso: 5 módulos principales con 20+ casos de uso
- Diagrama de Clases: Arquitectura orientada a objetos con separación de responsabilidades
- Diagrama de Secuencia: Flujos de interacción entre componentes
- Reglas de Negocio: 10 reglas críticas definidas (matrícula vigente, alternancia entrada/salida, etc.)

### **5.3.3 Fase de Arquitectura y Diseño**

**Documento SAD (Arquitectura de Software):**
El documento SAD definió la arquitectura del sistema utilizando el modelo de vistas 4+1:

**Vista Lógica:**
- Arquitectura de microservicios con separación de responsabilidades
- Módulos: Autenticación, Control de Acceso, Administración, Reportes, ML
- Patrones de diseño: Repository, Factory, Strategy, Observer

**Vista de Procesos:**
- Diagrama de proceso actual vs. proceso propuesto
- Flujos de trabajo optimizados para reducir tiempos
- Procesamiento asíncrono para operaciones pesadas

**Vista de Despliegue:**
- Arquitectura cloud con MongoDB Atlas
- API REST en servidores escalables
- Aplicación móvil distribuida vía App Store y Play Store
- Dashboard web accesible desde navegadores

**Vista de Implementación:**
- Componentes reutilizables y modulares
- Interfaces bien definidas entre capas
- Separación entre lógica de negocio y presentación

**Vista de Datos:**
- Modelo de datos NoSQL optimizado para consultas frecuentes
- Índices estratégicos para rendimiento
- Estrategia de particionamiento y sharding

**Atributos de Calidad:**
- Seguridad: Autenticación multi-factor, encriptación end-to-end
- Disponibilidad: Replicación, respaldo automático, failover
- Rendimiento: Caché, optimización de consultas, CDN
- Escalabilidad: Arquitectura horizontal, balanceo de carga

### **5.3.4 Fase de Desarrollo**

**Metodología Ágil:**
- Sprints de 2 semanas con entregas incrementales
- Daily standups para seguimiento de progreso
- Retrospectivas al final de cada sprint
- Backlog priorizado según valor de negocio

**Prácticas de Desarrollo:**
- Code reviews obligatorias antes de merge
- Testing continuo (unitario, integración, E2E)
- Integración continua con CI/CD
- Documentación técnica actualizada

**Control de Calidad:**
- Cobertura de pruebas > 80%
- Análisis estático de código (SonarQube)
- Pruebas de seguridad (OWASP Top 10)
- Pruebas de rendimiento y carga

### **5.3.5 Fase de Testing y Validación**

**Tipos de Pruebas:**
- **Unitarias:** Componentes individuales (Jest, Flutter Test)
- **Integración:** Interacción entre módulos
- **Sistema:** Flujos completos de usuario
- **Aceptación:** Validación con usuarios finales
- **Rendimiento:** Carga y estrés del sistema
- **Seguridad:** Vulnerabilidades y penetración

**Validación con Usuarios:**
- Pruebas piloto con grupo reducido de guardias
- Feedback continuo para ajustes de UX
- Capacitación y documentación de usuarios

### **5.3.6 Fase de Despliegue y Puesta en Producción**

**Estrategia de Despliegue:**
- Ambiente de desarrollo → Staging → Producción
- Despliegue gradual (canary deployment)
- Rollback plan para reversión rápida
- Monitoreo continuo post-despliegue

**Capacitación:**
- Sesiones de entrenamiento para guardias
- Manuales de usuario y administrador
- Videos tutoriales y documentación online
- Soporte técnico durante periodo de transición

# **6. Cronograma** {#cronograma}

El proyecto tiene una duración total de **4 meses** (16 semanas), dividido en las siguientes fases:

## **Fase 1: Análisis y Planificación (Semanas 1-2)**

**Semana 1:**
- Reunión de kickoff y alineación de equipo
- Análisis de requerimientos y levantamiento de información
- Definición de alcance y objetivos
- Elaboración de Documento de Visión

**Semana 2:**
- Análisis técnico y evaluación de tecnologías
- Diseño de arquitectura preliminar
- Planificación de sprints y asignación de tareas
- Elaboración de Documento SRS

## **Fase 2: Diseño y Arquitectura (Semanas 3-4)**

**Semana 3:**
- Diseño detallado de arquitectura del sistema
- Modelado de base de datos y esquemas
- Diseño de interfaces de usuario (mockups)
- Elaboración de Documento SAD

**Semana 4:**
- Revisión y aprobación de documentos de diseño
- Configuración de ambientes de desarrollo
- Setup de repositorios y herramientas CI/CD
- Planificación detallada de desarrollo

## **Fase 3: Desarrollo Backend (Semanas 5-8)**

**Semana 5-6:**
- Desarrollo de API REST (autenticación, usuarios)
- Configuración de MongoDB Atlas
- Implementación de servicios de sincronización
- Testing unitario de módulos backend

**Semana 7-8:**
- Desarrollo de endpoints de control de acceso
- Integración con servicios de geolocalización
- Implementación de lógica de negocio
- Testing de integración backend

## **Fase 4: Desarrollo Frontend Móvil (Semanas 9-12)**

**Semana 9-10:**
- Desarrollo de aplicación Flutter (autenticación, navegación)
- Integración con Bluetooth BLE
- Implementación de detección de pulseras
- Desarrollo de interfaz de guardias

**Semana 11-12:**
- Funcionalidad offline y sincronización
- Historial y búsqueda de estudiantes
- Optimización de rendimiento móvil
- Testing de aplicación móvil

## **Fase 5: Desarrollo Dashboard y ML (Semanas 13-14)**

**Semana 13:**
- Desarrollo de dashboard web
- Visualización de datos en tiempo real
- Implementación de reportes y gráficos
- Integración de módulo de Machine Learning

**Semana 14:**
- Algoritmos de predicción y análisis
- Optimización de modelos ML
- Testing de dashboard y ML
- Integración completa de componentes

## **Fase 6: Testing y Ajustes (Semana 15)**

**Semana 15:**
- Testing integral del sistema
- Pruebas de carga y rendimiento
- Corrección de bugs y ajustes
- Pruebas de aceptación con usuarios

## **Fase 7: Despliegue y Capacitación (Semana 16)**

**Semana 16:**
- Despliegue en ambiente de producción
- Capacitación de usuarios finales
- Documentación final y manuales
- Entrega del proyecto

# **7. Presupuesto** {#presupuesto}

## **7.1 Costos de Desarrollo**

| Categoría | Concepto | Cantidad | Costo Unitario | Costo Total |
|:---------:|:--------|:--------:|:--------------:|:-----------:|
| **Costos Generales** | Material de oficina | 1 lote | S/. 500 | S/. 500 |
| | Equipos de cómputo adicionales | 2 unidades | S/. 2,500 | S/. 5,000 |
| | Licencias de software | 1 paquete | S/. 1,200 | S/. 1,200 |
| | **Subtotal Costos Generales** | | | **S/. 6,700** |
| **Costos Operativos (4 meses)** | Servicios cloud (MongoDB Atlas, hosting) | 4 meses | S/. 800/mes | S/. 3,200 |
| | Internet y comunicaciones | 4 meses | S/. 200/mes | S/. 800 |
| | Energía eléctrica | 4 meses | S/. 150/mes | S/. 600 |
| | **Subtotal Costos Operativos** | | | **S/. 4,600** |
| **Costos del Ambiente** | Configuración de servidores cloud | 1 | S/. 2,000 | S/. 2,000 |
| | Implementación de infraestructura de red | 1 | S/. 3,500 | S/. 3,500 |
| | Pulseras inteligentes (500 unidades) | 500 | S/. 30 | S/. 15,000 |
| | Configuración y testing del ambiente | 1 | S/. 1,500 | S/. 1,500 |
| | **Subtotal Costos del Ambiente** | | | **S/. 22,000** |
| **Costos de Personal (4 meses)** | Project Manager | 4 meses | S/. 4,500/mes | S/. 18,000 |
| | Desarrollador Senior | 2 personas × 4 meses | S/. 4,000/mes | S/. 32,000 |
| | Desarrollador Junior | 2 personas × 4 meses | S/. 2,800/mes | S/. 22,400 |
| | Especialista ML/Data | 3 meses | S/. 4,200/mes | S/. 12,600 |
| | QA Tester | 3 meses | S/. 3,000/mes | S/. 9,000 |
| | **Subtotal Costos de Personal** | | | **S/. 94,000** |
| | **COSTO TOTAL DEL PROYECTO** | | | **S/. 127,300** |

## **7.2 Forma de Pago**

- **30% al inicio:** S/. 38,190 (inicio del proyecto)
- **40% en hitos intermedios:** S/. 50,920 (al completar desarrollo backend y móvil)
- **30% al final:** S/. 38,190 (entrega final y aceptación)

## **7.3 Costos Operativos Anuales Post-Implementación**

| Concepto | Costo Anual |
|:---------|:-----------:|
| Servicios cloud y hosting | S/. 9,600 |
| Mantenimiento y soporte técnico | S/. 15,000 |
| Licencias y actualizaciones | S/. 4,800 |
| Capacitación continua | S/. 2,000 |
| Infraestructura de red | S/. 3,600 |
| **TOTAL COSTOS OPERATIVOS ANUALES** | **S/. 35,000** |

## **7.4 Análisis de Retorno de Inversión**

**Beneficios Anuales:**
- Reducción de costos operativos: S/. 45,000
- Ahorro en personal: S/. 36,000
- Optimización de transporte: S/. 25,000
- Reducción de pérdidas: S/. 8,000
- **TOTAL BENEFICIOS ANUALES:** S/. 114,000

**Indicadores Financieros:**
- **Inversión Inicial:** S/. 127,300
- **Beneficios Netos Anuales:** S/. 79,000 (S/. 114,000 - S/. 35,000)
- **Relación Beneficio/Costo (2 años):** 1.16
- **Valor Actual Neto (VAN) al 12%:** S/. 6,208.02
- **Tasa Interna de Retorno (TIR):** 18.5%
- **Periodo de Recuperación:** 2.1 años

# **8. Conclusiones** {#conclusiones}

El análisis integral del proyecto "Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas" demuestra que es **VIABLE y FACTIBLE** desde todas las perspectivas evaluadas:

1. **Factibilidad Técnica:** La tecnología requerida está disponible y madura, con recursos técnicos suficientes para la implementación. El stack tecnológico propuesto (Flutter, Node.js, MongoDB Atlas) es ampliamente utilizado y cuenta con excelente documentación y soporte comunitario.

2. **Factibilidad Económica:** Los indicadores financieros (B/C: 1.16, VAN: S/. 6,208, TIR: 18.5%) demuestran viabilidad económica positiva con retorno de inversión favorable en un periodo de 2.1 años. Los beneficios anuales estimados (S/. 114,000) superan significativamente los costos operativos (S/. 35,000).

3. **Factibilidad Operativa:** Los beneficios operativos superan las barreras de adopción, con fuerte apoyo institucional. La reducción del 60% en tiempo de acceso, eliminación de procesos manuales y trazabilidad completa justifican la inversión en el sistema.

4. **Factibilidad Legal:** El proyecto cumple con todas las regulaciones aplicables de protección de datos (Ley N° 29733, GDPR) y seguridad informática, implementando medidas adecuadas de encriptación, auditoría y gestión de privacidad.

5. **Factibilidad Social:** Alto nivel de aceptación esperado y beneficios sociales claros para la comunidad universitaria. La mejora en experiencia estudiantil y reducción de estrés en horarios pico son factores positivos significativos.

6. **Factibilidad Ambiental:** Impacto ambiental positivo con reducción de emisiones mediante optimización de transporte, reducción de uso de papel y eficiencia energética de dispositivos BLE.

El proyecto representa una solución innovadora que aborda necesidades críticas de las instituciones educativas modernas, proporcionando no solo un sistema de control de acceso eficiente, sino también capacidades avanzadas de análisis predictivo y optimización de recursos mediante machine learning.

La metodología de implementación basada en documentos de Visión, SRS y SAD garantiza un desarrollo estructurado y controlado, con claridad en objetivos, requerimientos y arquitectura del sistema.

El cronograma de 4 meses es realista y alcanzable con el equipo y recursos propuestos, permitiendo una implementación completa y exitosa del sistema.

# **Recomendaciones** {#recomendaciones}

1. **Proceder con la implementación del proyecto** según las especificaciones definidas en los documentos de Visión, SRS y SAD, iniciando con una fase piloto de 6 meses para validar los resultados esperados antes de la implementación completa.

2. **Implementar un programa de capacitación estructurado** para garantizar adopción exitosa del sistema por parte de guardias y administradores, incluyendo sesiones prácticas, manuales de usuario y soporte técnico continuo durante el periodo de transición.

3. **Establecer métricas de éxito claras** para evaluar el impacto del sistema, incluyendo tiempo promedio de acceso, satisfacción de usuarios, precisión de predicciones ML y reducción efectiva de costos operativos.

4. **Planificar actualizaciones futuras** basadas en feedback de usuarios y evolución tecnológica, considerando funcionalidades adicionales como aplicación móvil para estudiantes, integración con sistemas académicos y expansión a otros puntos de acceso.

5. **Mantener un enfoque en seguridad y privacidad** mediante auditorías periódicas, actualizaciones de seguridad y cumplimiento continuo con normativas de protección de datos.

6. **Establecer un plan de mantenimiento y soporte** que incluya monitoreo proactivo del sistema, resolución rápida de incidencias y mejoras continuas basadas en métricas de rendimiento.

7. **Considerar la escalabilidad desde el inicio** para permitir expansión futura a otras facultades, sedes o instituciones educativas, garantizando que la arquitectura pueda soportar crecimiento sin requerir rediseño completo.

8. **Fomentar la cultura de innovación** mediante comunicación clara de beneficios del sistema, involucramiento de stakeholders en el proceso de desarrollo y celebración de logros alcanzados.

# **Bibliografía** {#bibliografía}

1. Sommerville, I. (2016). *Software Engineering*. 10th Edition. Pearson Education.

2. Pressman, R. & Maxim, B. (2019). *Software Engineering: A Practitioner's Approach*. 9th Edition. McGraw-Hill Education.

3. Cockburn, A. (2000). *Writing Effective Use Cases*. Addison-Wesley Professional.

4. IEEE Computer Society (1998). *IEEE Recommended Practice for Software Requirements Specifications*. IEEE Std 830-1998.

5. Beck, K. & Fowler, M. (2000). *Planning Extreme Programming*. Addison-Wesley Professional.

6. Martin, R. C. (2017). *Clean Architecture: A Craftsman's Guide to Software Structure and Design*. Prentice Hall.

7. Kruchten, P. (1995). *The 4+1 View Model of Architecture*. IEEE Software, 12(6), 42-50.

8. Bass, L., Clements, P., & Kazman, R. (2012). *Software Architecture in Practice*. 3rd Edition. Addison-Wesley Professional.

9. Fowler, M. (2002). *Patterns of Enterprise Application Architecture*. Addison-Wesley Professional.

10. Gamma, E., Helm, R., Johnson, R., & Vlissides, J. (1994). *Design Patterns: Elements of Reusable Object-Oriented Software*. Addison-Wesley Professional.

# **Anexos** {#anexos}

## **Anexo 01 - Informe de Factibilidad** {#anexo-01---informe-de-factibilidad}

El Informe de Factibilidad completo del proyecto se encuentra en el documento **FD01-EPIS-Informe de Factibilidad de Proyecto.md**, el cual incluye:

- Descripción detallada del proyecto
- Análisis de riesgos
- Análisis de la situación actual
- Estudio completo de factibilidad (técnica, económica, operativa, legal, social, ambiental)
- Análisis financiero con indicadores (B/C, VAN, TIR)
- Conclusiones y recomendaciones

Este documento establece la viabilidad del proyecto desde múltiples perspectivas y proporciona la base para la toma de decisiones de inversión.

## **Anexo 02 - Documento de Visión** {#anexo-02---documento-de-visión}

El Documento de Visión completo se encuentra en **FD02-EPIS-Informe Vision de Proyecto.md**, el cual contiene:

- Introducción y propósito del proyecto
- Posicionamiento (oportunidades de negocio, definición del problema)
- Descripción detallada de interesados y usuarios
- Vista general del producto (perspectiva, capacidades, suposiciones)
- Características del producto (CAR-01 a CAR-05)
- Restricciones técnicas, de diseño y organizacionales
- Rangos de calidad y precedencia de características
- Estándares aplicables (legales, de comunicación, de plataforma, de calidad)

Este documento establece la visión estratégica del proyecto y define el alcance y objetivos desde la perspectiva del negocio y usuarios finales.

## **Anexo 03 - Documento SRS** {#anexo-03---documento-srs}

La Especificación de Requerimientos de Software completa se encuentra en **FD03-Informe de SRS.md**, incluyendo:

- Generalidades de la empresa (Universidad Privada de Tacna)
- Visionamiento de la empresa (problema, objetivos, alcance, viabilidad)
- Análisis de procesos (diagramas de proceso actual y propuesto)
- Especificación detallada de requerimientos funcionales y no funcionales
- Reglas de negocio (RN-001 a RN-020)
- Perfiles de usuario (Guardias, Administradores, Estudiantes, Analistas)
- Modelo conceptual (diagramas de paquetes, casos de uso)
- Modelo lógico (análisis de objetos, diagramas de actividades, secuencia y clases)
- Conclusiones y recomendaciones

Este documento proporciona la especificación técnica detallada de todos los requerimientos del sistema.

## **Anexo 04 - Documento SAD** {#anexo-04---documento-sad}

El Documento de Arquitectura de Software completo se encuentra en **FD04-Informe de SAD.md**, el cual incluye:

- Introducción y propósito de la arquitectura
- Representación arquitectónica (modelo de vistas 4+1)
- Objetivos y limitaciones arquitectónicas (disponibilidad, seguridad, adaptabilidad, rendimiento)
- Análisis de requerimientos funcionales y no funcionales
- Vistas de caso de uso
- Vista lógica (diagrama contextual, arquitectura de microservicios)
- Vista de procesos (diagramas de proceso actual y propuesto)
- Vista de despliegue (diagrama de contenedor, arquitectura cloud)
- Vista de implementación (diagrama de componentes)
- Vista de datos (diagrama entidad-relación, modelo NoSQL)
- Escenarios de calidad (seguridad, usabilidad, adaptabilidad, disponibilidad)

Este documento define la arquitectura técnica del sistema y las decisiones de diseño que guían la implementación.

## **Anexo 05 - Manuales y otros documentos** {#anexo-05---manuales-y-otros-documentos}

Los siguientes documentos complementarios están disponibles en el repositorio del proyecto:

**Manuales de Usuario:**
- Manual de Usuario para Guardias de Seguridad
- Manual de Administrador del Sistema
- Guía de Uso del Dashboard Web

**Documentación Técnica:**
- README.md del proyecto con instrucciones de instalación y configuración
- Documentación de API REST (endpoints, autenticación, ejemplos)
- Guía de desarrollo para contribuidores
- Documentación de arquitectura técnica detallada

**Documentos de Configuración:**
- Archivos de configuración de ambientes (desarrollo, staging, producción)
- Scripts de despliegue y migración de base de datos
- Configuración de CI/CD (GitHub Actions/GitLab CI)

**Documentos de Machine Learning:**
- README_COMPLETO_ML.md - Documentación completa del módulo ML
- README_ETL.md - Proceso de extracción, transformación y carga de datos
- README_LINEAR_REGRESSION.md - Algoritmos de regresión lineal
- README_PEAK_HOURS_PREDICTION.md - Predicción de horarios pico
- README_MONITORING_DASHBOARD.md - Dashboard de monitoreo ML

**Documentos de Testing:**
- README_BACKUP_AUDIT_TESTS.md - Pruebas de respaldo y auditoría
- RESUMEN_TESTS.md - Resumen de pruebas realizadas
- Plan de pruebas y casos de prueba

**Otros Documentos:**
- API.md - Documentación completa de la API REST
- ARCHITECTURE.md - Documentación de arquitectura del sistema
- DEPLOYMENT.md - Guía de despliegue en producción
- README_OFFLINE.md - Funcionalidad offline y sincronización
- README_STUDENT_STATUS.md - Gestión de estado de estudiantes