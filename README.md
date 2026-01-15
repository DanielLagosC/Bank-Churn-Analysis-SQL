# Análisis de abandono de clientes bancarios realizado con herramienta SQL Server.

# Descripción del Proyecto
En este proyecto se realiza un **análisis Exploratorio de Datos para resolver un caso de negocio**: El abandono de clientes (Churn) en una entidad bancaria. A diferencia de un análisis generalista, este trabajo aplica un enfoque en identificar y desglosar el perfil demográfico con la tasa de abandono más crítica del dataset.

El objetivo principal es **identificar el segmento específico donde el banco está perdiendo más capital y clientes**, permitiendo diseñar estrategias de retención de alta precisión y máximo retorno de inversión (ROI).

# Alcance del Proyecto
Este análisis descriptivo se basa en un dataset estático de clientes bancarios y tiene como objetivo identificar patrones de abandono y segmentos con mayor riesgo de churn. Los resultados se interpretan como asociaciones y se utilizan para generar hipótesis analíticas. Las conclusiones se interpretan como asociaciones propias de un análisis exploratorio.

## Herramientas y Tecnologías: 
- Limpieza y auditoría en SQL para asegurar la calidad del dato.
- SQL Server Management Studio (SSMS)Functions
- Data Cleaning: Comprobación de correcta integridad y coherencia de datos (descartes de outliers o malos tipeos).
- Excel/CSV: Fuente de datos original (Raw Data): Customer-Churn-Records.csv

### 1. Arquitectura y Modelado de Datos 
Para simular un entorno profesional, diseñé una arquitectura basada en **Normalización de Base de Datos**:
Se descompuso la tabla original RAW en un modelo relacional de **5 tablas normalizadas**.
Luego se desarrolló un proceso **ETL (Extract, Transform, Load)** manual utilizando sentencias INSERT INTO... SELECT para migrar y estructurar los datos desde la fuente cruda hacia el nuevo modelo relacional.
Los nombres de las tablas y columnas se han mantenido en **español** para simular un entorno de trabajo real en banca local (LATAM/Perú), donde las bases de datos suelen estar en el idioma nativo.
<img width="927" height="619" alt="image" src="https://github.com/user-attachments/assets/9111f56c-9144-49e2-b563-1d62cb0e690d" />

### 2. Análisis Exploratorio
Uso de funciones de agregación, Joins, CTEs y segmentacion para aislar perfiles de riesgo.

## IMPORTANTE: Instrucciones de Ejecución para poder reproducir el análisis en SQL Server
Dado que el proyecto utiliza una carga manual para asegurar la integridad de los datos, siga estos pasos:
1. Baje el archivo .csv adjunto en este repositorio (Customer-Churn-Records.csv).
2. Abra SQL Server y cree una base de datos nombrada exactamente como: **portafolio** (de esto depende el correcto funcionamiento de los scripts). 
3. En SQL Server utilice la herramienta **Import Wizard** para cargar el CSV en la base de datos 'portafolio'.
4. Asegúrese de nombrar la tabla de destino exactamente como:[dbo].[Customer-Churn-Records] (El script de análisis depende de este nombre específico para funcionar).
5. Finalmente abra los archivos archivo .sql y ejecute las consultas para ver el análisis.


## HALLAZGOS (INSIGHTS)

<img width="1354" height="763" alt="image" src="https://github.com/user-attachments/assets/fdc3f07d-2406-4347-9bf2-15933146a471" />

- **Zona geográfica crítica: Alemania**, su tasa de abandono duplica a la de otros países.
- **Dentro de Alemania, el género que presenta mayor proporción de abandono son: las mujeres**.
- Con esto se determina el segmento en el cual se enfocará el análisis: **Mujeres Alemmanas**
- **Edad crítica:** contrario a lo que se podría pensar, los jóvenes presentan una mayor lealtad al banco que las personas mayores al tener un mayor promedio de años de antiguedad en el banco, lo que indica que pertenecer a la edad de jubilación, incrementa el riesgo de abandono, llegando a un pico de 73% entre las edades de 50 y 59 años. A esto podría indicar insatisfacción de las mujeres alemanas por los servicios o trato que ofrece el banco en esta etapa de su vida, pudiendo escoger mudarse a otro banco que le brinde más beneficios en su jubilación.
- **Cantidad de productos (el factor más influyente):** tener 3 y 4 productos dispara el riesgo de abandono hasta llegar al 100%. (Tener en cuenta que el número de muestra es reducido en ambos casos). Y el hecho de tener un producto conlleva un nivel de riesgo alarmante de abandonar el banco (casi 50%).
- **Balance en la cuenta**: aunque parezca contraintuitivo nuevamente, que una mujer alemana tenga un Balance considerado Alto (entre 100 000 y 150 000) en vez de fidelizarla, incrementa su riesgo de abandono, esto es malo pues indica, además de una pérdida de clientes, una pérdida considerable de capitales.
- **Puntos de fidelidad acumulados:** 







---
**Autor:** Daniel Alberto Lagos Carrillo

LinkedIn: https://www.linkedin.com/in/daniellagos/
