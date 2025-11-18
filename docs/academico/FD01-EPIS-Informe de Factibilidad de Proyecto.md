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

# **Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas**

# **Documento Informe de Factibilidad**

# 

# **Versión 1.0**

| CONTROL DE VERSIONES |  |  |  |  |  |
| :---: | :---: | :---: | :---: | :---: | ----- |
| Versión | Hecha por | Revisada por | Aprobada por | Fecha | Motivo |
| 1.0 | CCL | OJF | OJF | 24/09/2025 | Versión Original |

**ÍNDICE GENERAL**

[Objetivos:	3](#heading=h.rp36mafvccfa)

[1\.	Descripción del Proyecto	3](#descripción-del-proyecto)

[2\.	Riesgos	3](#riesgos)

[3\.	Análisis de la Situación actual	3](#análisis-de-la-situación-actual)

[4\.	Estudio de Factibilidad	3](#estudio-de-factibilidad)

[4.1	Factibilidad Técnica	4](#factibilidad-técnica)

[4.2	Factibilidad económica	4](#factibilidad-económica)

[4.3	Factibilidad Operativa	4](#factibilidad-operativa)

[4.4	Factibilidad Legal	4](#factibilidad-legal)

[4.5	Factibilidad Social	5](#factibilidad-social)

[4.6	Factibilidad Ambiental	5](#factibilidad-ambiental)

[5\.	Análisis Financiero	5](#análisis-financiero)

[6\.	Conclusiones	5](#conclusiones)

**Informe de Factibilidad**

1. Descripción del Proyecto  
   1. Nombre del proyecto

Sistema de Control de Acceso con Pulseras Inteligentes para Instituciones Educativas

2. Duración del proyecto

4 meses

3. Descripción 

El proyecto consiste en desarrollar un sistema integral de control de acceso sin contacto para instituciones educativas, utilizando pulseras inteligentes con tecnología Bluetooth. El sistema permitirá un control de acceso rápido y seguro, además de recopilar datos para análisis predictivo mediante machine learning, optimizando el flujo de estudiantes y la gestión del transporte universitario. La solución incluye una aplicación móvil desarrollada en Flutter, una API REST con Node.js, base de datos MongoDB Atlas, y una página web para reportes y análisis de datos.

1.4 Objetivos

       1.4.1 Objetivo general

Garantizar un control de acceso rápido, seguro y sin contacto para instituciones educativas mediante pulseras inteligentes, mejorando la eficiencia operativa y proporcionando análisis predictivo para la optimización de recursos.

        1.4.2 Objetivos Específicos

* Implementar sistema de autenticación: Desarrollar un sistema seguro de autenticación con roles diferenciados para guardias y administradores  
* Desarrollar funcionalidades de gestión: Crear módulos para el registro, activación y gestión de usuarios guardias  
* Integrar tecnología Bluetooth: Implementar detección automática de pulseras inteligentes para control de acceso sin contacto  
* Implementar análisis predictivo: Desarrollar algoritmos de machine learning para predecir patrones de flujo estudiantil  
* Crear dashboard de reportes: Desarrollar una interfaz web para visualización de datos y reportes de actividad  
* Optimizar transporte universitario: Proporcionar recomendaciones para horarios óptimos de buses basadas en análisis de datos

2. Riesgos

Los principales riesgos que podrían afectar el éxito del proyecto incluyen:

* Riesgos Técnicos: Incompatibilidad entre dispositivos Bluetooth, limitaciones de alcance de conectividad, fallos en la sincronización de datos  
* Riesgos de Adopción: Resistencia al cambio por parte de los usuarios, curva de aprendizaje del nuevo sistema  
* Riesgos de Seguridad: Vulnerabilidades en la transmisión de datos, posibles ataques cibernéticos, pérdida de información sensible  
* Riesgos Operativos: Fallas en la infraestructura de red, problemas de rendimiento con alto volumen de usuarios  
* Riesgos Financieros: Sobrecostos en el desarrollo, necesidad de hardware adicional no contemplado inicialmente  
* Riesgos de Tiempo: Retrasos en la integración de componentes, complejidad mayor a la estimada en el desarrollo del machine learning

3. Análisis de la Situación actual  
   1. Planteamiento del problema

Actualmente, las instituciones educativas enfrentan desafíos significativos en el control de acceso tradicional, que incluyen largos tiempos de espera, procesos manuales propensos a errores, falta de trazabilidad en tiempo real, y dificultades para analizar patrones de flujo estudiantil. Los sistemas convencionales basados en tarjetas o códigos requieren contacto físico, lo que puede representar riesgos sanitarios y generar cuellos de botella en horarios pico.  
La problemática se agrava por la falta de datos estructurados sobre los patrones de entrada y salida de estudiantes, lo que impide una planificación eficiente del transporte universitario y la optimización de recursos. La ausencia de análisis predictivo resulta en congestiones imprevistas y subutilización de la capacidad de transporte.

2. Consideraciones de hardware y software

Hardware disponible:

\-	Dispositivos móviles Android/iOS para la aplicación

\-	Pulseras inteligentes con conectividad Bluetooth Low Energy (BLE)

\-	Servidores para alojar la API y base de datos

\-	Infraestructura de red Wi-Fi institucional

\-	Computadoras para el dashboard web

Software requerido:

\-	Flutter para desarrollo de aplicación móvil multiplataforma

\-	Node.js para desarrollo de API REST

\-	MongoDB Atlas como base de datos en la nube

\-	Herramientas de machine learning (Python/TensorFlow)

\-	Navegadores web modernos para el dashboard

\-	Sistemas operativos: Android 8.0+, iOS 12.0+

4. Estudio de Factibilidad

Este estudio evalúa la viabilidad del proyecto desde múltiples perspectivas, considerando los recursos tecnológicos, económicos, operativos, legales, sociales y ambientales. Las actividades realizadas incluyen análisis de mercado, evaluación técnica, estimación de costos y análisis de riesgos, aprobado por la dirección académica y el comité técnico de la universidad.

1. Factibilidad Técnica

La evaluación técnica confirma la disponibilidad de recursos tecnológicos necesarios y su aplicabilidad al proyecto propuesto.  
Tecnología disponible:

* Desarrollo móvil: Flutter proporciona desarrollo multiplataforma eficiente  
* Backend: Node.js ofrece escalabilidad y rendimiento adecuados  
* Base de datos: MongoDB Atlas garantiza disponibilidad y escalabilidad en la nube  
* Conectividad: Bluetooth Low Energy es ampliamente compatible y eficiente energéticamente  
* Machine Learning: Python y TensorFlow proporcionan herramientas robustas para análisis predictivo


Infraestructura requerida:

* Servidores cloud con capacidad de procesamiento para 500-1000 usuarios concurrentes  
* Red Wi-Fi institucional con cobertura completa  
* Sistema de respaldo y recuperación de datos  
* Herramientas de monitoreo y análisis de rendimiento


La tecnología propuesta es madura, bien documentada y cuenta con amplio soporte de la comunidad, garantizando la factibilidad técnica del proyecto.

2. Factibilidad Económica

El análisis económico evalúa los beneficios del proyecto en relación con los costos de inversión y operación.

1. Costos Generales 

| *Concepto* | *Cantidad* | *Costo Unitario* | *Costo Total* |
| :---: | :---: | :---: | :---: |
| *Material de oficina* | *1 lote* | *S/. 500* | *S/. 500* |
| *Equipos de cómputo adicionales* | *2 unidades* | *S/. 2,500* | *S/. 5,000* |
| *Licencias de software* | *1 paquete* | *S/. 1,200* | *S/. 1,200* |
| ***Total Costos Generales*** |   |   | ***S/. 6,700*** |

   2. Costos operativos durante el desarrollo 

| *Concepto* | *Costo Mensual* | *18 Meses* | *Costo Total* |
| :---: | :---: | :---: | :---: |
| *Servicios cloud (MongoDB Atlas, hosting)* | *S/. 800* | *4* | *S/. 3,200* |
| *Internet y comunicaciones* | *S/. 200* | *4* | *S/. 800* |
| *Energía eléctrica* | *S/. 150* | *4* | *S/. 600* |
| ***Total Costos Operativos*** |   |   | ***S/. 4,600*** |

      3. Costos del ambiente

| *Concepto* | *Costo* |
| :---: | :---: |
| *Configuración de servidores cloud* | *S/. 2,000* |
| *Implementación de infraestructura de red* | *S/. 3,500* |
| *Pulseras inteligentes (500 unidades)* | *S/. 15,000* |
| *Configuración y testing del ambiente* | *S/. 1,500* |
| ***Total Costos del Ambiente*** | ***S/. 22,000*** |

      4. Costos de personal

| *Rol* | *Cantidad* | *Salario Mensual* | *4 Meses* | *Total* |
| :---: | :---: | :---: | :---: | :---: |
| *Project Manager* | *1* | *S/. 4,500* | *4* | *S/. 18,000* |
| *Desarrollador Senior* | *2* | *S/. 4,000* | *4* | *S/. 32,000* |
| *Desarrollador Junior* | *2* | *S/. 2,800* | *4* | *S/. 22,400* |
| *Especialista ML/Data* | *1* | *S/. 4,200* | *3* | *S/. 12,600* |
| *QA Tester* | *1* | *S/. 3,000* | *3* | *S/. 9,000* |
| ***Total Costos de Personal*** |   |   |   | ***S/. 94,000*** |

      5. Costos totales del desarrollo del sistema 

| Categoría | Costo |
| :---: | :---: |
| Costos Generales | S/. 6,700 |
| Costos Operativos | S/. 4,600 |
| Costos del Ambiente | S/. 22,000 |
| Costos de Personal | S/. 94,000 |
| **COSTO TOTAL DEL PROYECTO** | **S/. 127,300** |

Forma de pago: 30% al inicio, 40% en hitos intermedios, 30% al final del proyecto.

3. Factibilidad Operativa

El sistema ofrece beneficios operativos significativos y la institución cuenta con la capacidad para mantenerlo funcionando:

* Beneficios del producto:  
  \-	Reducción del 60% en tiempo de acceso de estudiantes  
  \-	Eliminación de colas y procesos manuales  
  \-	Trazabilidad completa de accesos en tiempo real  
  \-	Análisis predictivo para optimización de recursos  
  \-	Mejora en la experiencia del usuario  
  \-	Datos estructurados para toma de decisiones

* Capacidad del cliente:  
  \-	Personal técnico disponible para mantenimiento básico  
  \-	Infraestructura IT existente compatible  
  \-	Presupuesto asignado para soporte técnico  
  \-	Compromiso institucional con la innovación tecnológica

* Lista de interesados:  
  \-	Estudiantes universitarios  
  \-	Personal de seguridad  
  \-	Administradores académicos  
  \-	Departamento de TI  
  \-	Dirección de transporte universitario

  4. Factibilidad Legal

El proyecto cumple con las regulaciones legales aplicables:

* Cumplimiento normativo:  
  \-	Ley de Protección de Datos Personales (Ley N° 29733\)  
  \-	Reglamento General de Protección de Datos (GDPR) para estándares internacionales  
  \-	Normas de seguridad informática institucionales  
  \-	Regulaciones de dispositivos IoT y comunicaciones inalámbricas  
    
* Medidas implementadas:  
  \-	Encriptación de datos en tránsito y almacenamiento  
  \-	Políticas de retención y eliminación de datos  
  \-	Consentimiento explícito para recolección de datos  
  \-	Auditorías de seguridad periódicas

  5. Factibilidad Social

El proyecto considera aspectos sociales y culturales del entorno:

* **Factores positivos:**

  \-   Mejora en la experiencia estudiantil

  \-   Reducción de estrés en horarios pico

  \-   Cultura tecnológica favorable en el ámbito universitario

  \-   Apoyo institucional a la innovación


* **Consideraciones éticas:**

  \-   Respeto a la privacidad estudiantil

  \-   Transparencia en el uso de datos

  \-   Inclusión de estudiantes con necesidades especiales

  \-   Comunicación clara sobre beneficios y funcionamiento

  6. Factibilidad Ambiental

El proyecto tiene impacto ambiental positivo:

* **Beneficios ambientales:**

  \-   Reducción en uso de papel (procesos digitales)

  \-   Optimización de rutas de transporte reduce emisiones

  \-   Pulseras reutilizables y de larga duración

  \-   Eficiencia energética de dispositivos BLE


* **Medidas de sostenibilidad:**

  \-   Programa de reciclaje de pulseras al final de su vida útil

  \-   Optimización de algoritmos para reducir consumo computacional

  \-   Uso de servicios cloud eficientes energéticamente


5. Análisis Financiero

   1. Justificación de la Inversión

*5.1.1 Beneficios* del Proyecto

* Beneficios tangibles:  
  \-	Reducción de costos operativos: S/. 45,000 anuales por automatización de procesos

  \-	Ahorro en personal: S/. 36,000 anuales por optimización de guardias

  \-	Optimización de transporte: S/. 25,000 anuales por mejores rutas y horarios

  \-	Reducción de pérdidas: S/. 8,000 anuales por mejor control de acceso

* Beneficios intangibles:  
  \-	Mejora significativa en la experiencia estudiantil

  \-	Mayor prestigio institucional por innovación tecnológica

  \-	Disponibilidad de datos para futuras mejoras

  \-	Mejor imagen corporativa ante stakeholders

  \-	Cumplimiento de estándares de calidad educativa

  \-	Ventaja competitiva frente a otras instituciones

  \-	Mejora en procesos de toma de decisiones

  \-	Mayor confiabilidad en sistemas de seguridad

5.1.2 Criterios de Inversión  
   
*5.1.2.1 Relación Beneficio/Costo (B/C)*

\-   **Beneficios anuales:** S/. 114,000

\-   **Costos de inversión:** S/. 127,300

\-   **Costos operativos anuales:** S/. 35,000

\-   **B/C a 2 años:** 1.16

                    *5.1.2.2 Valor Actual Neto (VAN)*  
Considerando una tasa de descuento del 12% y un horizonte de 2 años:  
\-	VAN: S/. 6,208.02  
Como el VAN es mayor que cero, se acepta el proyecto.

*5.1.2.3 Tasa Interna de Retorno (TIR)*

- TIR: 18.5%  
- Costo de oportunidad (COK): 12%

  Como la TIR (18.5%) es mayor que el COK (12%), se acepta el proyecto.


6. Conclusiones

Los resultados del análisis de factibilidad indican que el proyecto Sistema de Control de Acceso con Pulseras Inteligentes es VIABLE y FACTIBLE desde todas las perspectivas evaluadas:

Factibilidad Técnica:  FAVORABLE \- La tecnología requerida está disponible y madura, con recursos técnicos suficientes para la implementación.

Factibilidad Económica:  FAVORABLE \- Los indicadores financieros (B/C: 1.16, VAN: S/. 6,208, TIR: 18.5%) demuestran viabilidad económica positiva.

Factibilidad Operativa:  FAVORABLE \- Los beneficios operativos superan las barreras de adopción, con fuerte apoyo institucional.

Factibilidad Legal:  FAVORABLE \- Cumple con todas las regulaciones aplicables de protección de datos y seguridad.

Factibilidad Social:  FAVORABLE \- Alto nivel de aceptación esperado y beneficios sociales claros para la comunidad universitaria.

Factibilidad Ambiental:  FAVORABLE \- Impacto ambiental positivo con reducción de emisiones y uso eficiente de recursos.

RECOMENDACIÓN FINAL: Se recomienda PROCEDER con la implementación del proyecto, iniciando con una fase piloto de 6 meses para validar los resultados esperados antes de la implementación completa.

[image1]: <data:image/png;base64,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>