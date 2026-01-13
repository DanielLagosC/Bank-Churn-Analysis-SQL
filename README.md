# Análisis de deserción de clientes bancarios realizado con herramienta SQL Server.

# Descripción del Proyecto
En este proyecto se realiza un análisis profundo sobre la deserción de clientes (Churn) en una entidad bancaria usando **SQL Server**. A diferencia de un análisis generalista, este trabajo aplica un enfoque quirúrgico para identificar y desglosar el perfil demográfico con la tasa de abandono más crítica del dataset.

El objetivo principal es **identificar el segmento específico donde el banco está perdiendo más capital y clientes**, permitiendo diseñar estrategias de retención de alta precisión y máximo retorno de inversión (ROI).


## Herramientas y Tecnologías: 
- Visual Studio Code
- SQL Server Management Studio (SSMS)Functions
- Data Cleaning: Comprobación de correcta integridad y coherencia de datos (descartes de outliers o malos tipeos).
- Excel/CSV: Fuente de datos original (Raw Data): Customer-Churn-Records.csv

### 1. Arquitectura y Modelado de Datos 
Para simular un entorno profesional, diseñé una arquitectura basada en **Normalización de Base de Datos**:
Se descompuso la tabla original RAW en un modelo relacional de **5 tablas normalizadas**.
Luego se desarrolló un proceso **ETL (Extract, Transform, Load)** manual utilizando sentencias INSERT INTO... SELECT para migrar y estructurar los datos desde la fuente cruda hacia el nuevo modelo relacional.
Los nombres de las tablas y columnas se han mantenido en **español** para simular un entorno de trabajo real en banca local (LATAM/Perú), donde las bases de datos suelen estar en el idioma nativo.

### 2. Análisis Exploratorio
Uso de funciones de agregación, Joins, CTEs y segmentacion para aislar perfiles de riesgo.

## IMPORTANTE: Instrucciones de Ejecución para poder reproducir el análisis
Dado que el proyecto utiliza una carga manual para asegurar la integridad de los datos, siga estos pasos:
1. Baje el archivo .csv adjunto en este repositorio (Customer-Churn-Records.csv).
2. Abra SQL Server y utilice la herramienta **Import Wizard** para cargar el CSV.
3. Asegúrese de nombrar la tabla de destino exactamente como:[dbo].[Customer-Churn-Records] (El script de análisis depende de este nombre específico para funcionar).
4. Finalmente abra los archivos archivo .sql y ejecute las consultas para ver el análisis.


## HALLAZGOS

<img width="1352" height="771" alt="IMAGEN DASHBOARD" src="https://github.com/user-attachments/assets/16392759-dc24-44d4-800f-dedced0eb554" />


### 1. Panorama General
**Total de Clientes:** 10,000
**Tasa de Abandono Global:** 20.38% (2,038 clientes abandonaron el banco).

### 2. Análisis Geográfico
Alemania presenta la tasa de fuga más alarmante, duplicando prácticamente a los otros países:
a) Alemania: 32.44% de abandono (814 de 2509 clientes). **Este será el foco del análisis**
b) España: 16.67%
c) Francia: 16.17%

Dentro de Alemania, el género femenino es el más afectado, elevando la tasa de riesgo al **37.55%**.

### 3. Perfil de Riesgo Objetivo: Mujeres en Alemania
Se realizó un desglose en este segmento crítico, encontrando patrones determinantes:

**A) Cantidad de Productos**
Existe una correlación directa entre 1, 3 y 4 productos y abandonar el banco.
**La Zona Segura:** Clientes con **2 productos** tienen una tasa de fuga baja (16%).
**Zona de Peligro:**
1 Producto: **47.13%** de riesgo.
3 Productos: **86.79%** de riesgo.
4 Productos: **100%** de fuga (Abandono total).

**B) Grupos de Edad**
El riesgo aumenta drásticamente con la edad, alcanzando su pico en la pre-jubilación:
**40-49 años:** 48% de tasa de abandono.
**50-59 años:** 73% de tasa de abandono
**60-69 años:** 60% de tasa de abandono.

**C) Comportamiento Financiero**
* **Balance:** Sorprendentemente, las clientas con **Balance Alto** (100k - 150k) tienen casi el doble de riesgo de irse (43.78%) comparado con saldos menores.
* **Actividad:** Si bien los clientes inactivos suelen irse más (44.63%), es alarmante que el **29.51% de las clientas ACTIVAS** también abandonan el banco. (1 de cada 3 usuarias activas se va).

## CONCLUSIÓN:




---
**Autor:** Daniel Alberto Lagos Carrillo

LinkedIn: https://www.linkedin.com/in/daniellagos/
