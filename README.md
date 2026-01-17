# Análisis de abandono de clientes bancarios realizado con herramienta SQL Server y Power BI.

# Descripción del Proyecto
En este proyecto se realiza un **análisis Exploratorio de Datos para resolver un caso de negocio**: El abandono de clientes (Churn) en una entidad bancaria. A diferencia de un análisis generalista, este trabajo aplica un enfoque en identificar y desglosar el perfil demográfico con la tasa de abandono más crítica del dataset.

El objetivo principal es **identificar el segmento específico donde el banco está perdiendo más capital y clientes**, permitiendo hipotetizar el escenario que está produciendo esta fuga de clientes y diseñar estrategias de retención de alta precisión y máximo retorno de inversión (ROI).

# Alcance del Proyecto
Este análisis descriptivo se basa en un dataset estático de clientes bancarios y tiene como objetivo identificar patrones de abandono y segmentos con mayor riesgo de churn. Los resultados se interpretan como asociaciones y se utilizan para generar hipótesis analíticas. Las conclusiones se interpretan como asociaciones propias de un análisis exploratorio.

## Herramientas y Tecnologías: 
- SQL Server
- Power BI  
- Excel/CSV: Fuente de datos original (Raw Data): Customer-Churn-Records.csv

## Metodología
- Data Cleaning: Comprobación de correcta integridad y coherencia de datos (descartes de outliers o malos tipeos).
- Normalización de base de datos.
- Realización de proceso ETL para cargar los datos.
- Uso de funciones de agregación, Joins, CTEs y segmentacion para aislar perfiles de riesgo y calcular la tasa de abandono en cada uno.
  
### 1. Arquitectura y Modelado de Datos 
Para simular un entorno profesional, diseñé una arquitectura basada en **Normalización de Base de Datos**:
Se descompuso la tabla original RAW en un modelo relacional de **5 tablas normalizadas**.
Luego se desarrolló un proceso **ETL (Extract, Transform, Load)** manual utilizando sentencias INSERT INTO... SELECT para migrar y estructurar los datos desde la fuente cruda hacia el nuevo modelo relacional.
Los nombres de las tablas y columnas se han mantenido en **español** para simular un entorno de trabajo real en banca local (LATAM/Perú), donde las bases de datos suelen estar en el idioma nativo.
<img width="927" height="619" alt="image" src="https://github.com/user-attachments/assets/9111f56c-9144-49e2-b563-1d62cb0e690d" />

### 2. Análisis Exploratorio

## IMPORTANTE: Instrucciones de Ejecución para poder reproducir el análisis en SQL Server
Dado que el proyecto utiliza una carga manual para asegurar la integridad de los datos, siga estos pasos:
1. Baje el archivo .csv adjunto en este repositorio (Customer-Churn-Records.csv).
2. Abra SQL Server y cree una base de datos nombrada exactamente como: **portafolio** (de esto depende el correcto funcionamiento de los scripts). 
3. En SQL Server utilice la herramienta **Import Wizard** para cargar el CSV en la base de datos 'portafolio'.
4. Asegúrese de nombrar la tabla de destino exactamente como:[dbo].[Customer-Churn-Records] (El script de análisis depende de este nombre específico para funcionar).
5. Finalmente abra los archivos archivo .sql y ejecute las consultas para ver el análisis.


## HALLAZGOS (INSIGHTS)

<img width="1354" height="763" alt="image" src="https://github.com/user-attachments/assets/fdc3f07d-2406-4347-9bf2-15933146a471" />

- **Cantidad  de clientes que abandonaron en total: 2038**
- **Zona geográfica crítica: Alemania**, su tasa de abandono duplica a la de otros países, donde del total de su población de 2509 clientes, **814 abandonaron**
- **Dentro de Alemania, el género que presenta mayor proporción de abandono son: las mujeres**, donde de 1193 clientas en total, **448 abandonaron**
- Con esto se determina el segmento en el cual se enfocará el análisis: **Mujeres Alemanas**
- **Edad crítica:** contrario a lo que se podría pensar, los jóvenes presentan una mayor lealtad al banco que las personas mayores al tener un mayor promedio de años de antiguedad en el banco (los jovenes 5 años en promedio, mientras que las personas mayores 4 años promedio), lo que indica que pertenecer a la edad de jubilación, incrementa el riesgo de abandono, llegando a un pico de 73% entre las edades de 50 y 59 años. A esto podría indicar insatisfacción de las mujeres alemanas por los servicios o trato que ofrece el banco en esta etapa de su vida, pudiendo escoger mudarse a otro banco que le brinde más beneficios en su jubilación.
- **Cantidad de productos (el factor más influyente):** tener 3 y 4 productos dispara el riesgo de abandono hasta llegar al 100%. (Tener en cuenta que el número de muestra es reducido en ambos casos). Y el hecho de tener un producto conlleva un nivel de riesgo alarmante de abandonar el banco (casi 50%).
- **Balance en la cuenta**: aunque parezca contraintuitivo nuevamente, que una mujer alemana tenga un Balance considerado Alto (entre 100 000 y 150 000) en vez de fidelizarla, incrementa su riesgo de abandono, esto es malo pues indica, además de una pérdida de clientes, una pérdida considerable de capitales, esto puede señalar falta de valor en los servicios y consideraciones del banco conforme se tiene más capital en la cuentas.
- **Puntos de fidelidad acumulados:** demuestra un incremento de abandono más sutil conforme se tienen más puntos acumulados a partir de los 600 puntos de fidelidad, esto puede señalar falta de utilidad en servicios o paquetes en los cuales se puedan usar o canjear estos puntos. Esto refuerza la hipótesis que dan los anteriores insights, el banco está fallando en ofrecer servicios, consideraciones o atención adecuada al perfil de cliente donde se supone debería reforzar o hasta asegurar la fidelidad de la mujer alemana.
- **Clientes Activos vs No Activos:** la tasa de abandono alta en los clientes No Activos hasta cierto punto es esperable, ya que no usan el banco, lo crítico aquí es la tasa de abandono que tienen los clientes activos (de un 30%), clientes que, de primeras, no se supone que deberían abandonar tanto el banco, ya que se supone que usan sus servicios con regularidad, este insight es la última señal de insatisfacción de las mujeres alemanas en relación con el producto de valor que ofrece el banco para su segmento específico.

## CONCLUSIONES Y ACCIONES SUGERIDAS:
Los hallazgos permiten hipotetizar que el banco sufre de una falta de valor en sus servicios y productos ofrecidos a las mujeres alemanas en general, pero esto se agrava conforme el perfil de la mujer alemana va dirigiendose hacia una etapa donde se supone debería terminar de asegurar su fidelización al banco (tener balance alto en sus cuentas, llegar a una edad de jubilación, acumular la máxima cantidad de puntos de fidelidad), esto señala que el banco no está "recompensando" de alguna manera a estos perfiles de clientas y ellas, al estar buscando mejores tratos, opten por irse a otros bancos que les den mayores beneficios y consideraciones en los servicios brindados, terminando esto en una fuga grande de clientes y, peor aún, de capitales (recordar que las que tienen entre 100 000 y 150 000 son las que más se van) para el banco.

Sabiendo que, de los 2038 clientes que abandonaron en total, 448 son **mujeres alemanas, este segmento de clientes representa poco más de la quinta parte del total de la población que abandono**, se hace pertinente el accionar urgente de programas de fidelización y marketing enfocado especfícamente en este segmento de clientes del banco:
- Impulsar la venta de productos a las clientas alemanas para que pasen de tener de 1 producto a 2, bajando notoriamente el riesgo de que abandonen el banco ya que estarían en el punto más seguro dentro de este segmento, al mismo tiempo, cancelar el intento de ventas para que de 2 productos, pasen a tener 3 o más productos, ya que los casos han demostrado total disconformidad con la tenencia de mucha cantidad de productos de este banco.
- Crear programas de jubilación donde se ofrezcan beneficios claros y concretos (estos pueden ser planes de pensiones o rentas vitalicias) y acompañarlos con campañas de marketing para lograr que los clientes se adhieran a estos programas antes de llegar a los 4 años de antiguedad (si se puede mucho antes, mejor) para así reducir el riesgo de abandono tan alto en este grupo.
- Mejorar los servicios o sistemas de canjes que se ofrecen para darles una mejor utilidad a los puntos de fidelidad que puedan tener los clientes, para así darle un mejor enfoque de gamificación al sistema de puntos de fidelidad del banco y lograr un mayor enganche a los clientes a seguir usando los productos, provocando una mayor retención.






---
**Autor:** Daniel Alberto Lagos Carrillo

LinkedIn: https://www.linkedin.com/in/daniellagos/
