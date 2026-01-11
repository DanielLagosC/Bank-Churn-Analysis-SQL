# Bank-Churn-Analysis-SQL (Análisis de Deserción de Clientes)
Análisis de deserción de clientes bancarios realizado con herramienta SQL Server.

## Descripción del Proyecto
Este proyecto analiza la deserción de clientes (Churn) en una entidad bancaria ficticia. El objetivo principal es identificar al perfil demográfico de cliente con más riesgo de desertar y los factores de riesgo que lo lleven a abandonar el banco, permitiendo tomar decisiones basadas en datos para mejorar la retención.

Este proyecto demuestra habilidades de modelado y consultas analíticas complejas utilizando **SQL Server**.

## Herramientas y Tecnologías
* Visual Studio Code
* SQL Server Management Studio (SSMS)
* Functions: Joins, CTEs, Funciones de Agregación, Group By.
* Data Cleaning: Comprobación de correcta integridad y coherencia de datos (descartes de outliers o malos tipeos).
* Excel/CSV: Fuente de datos original (Raw Data): Customer-Churn-Records.csv

### 1. Arquitectura y Modelado de Datos 
A diferencia de un análisis estándar sobre una tabla plana (Excel), en este proyecto se aplicaron principios de **Normalización de Base de Datos**:
* Se descompuso la tabla original `RAW` en un modelo relacional de **5 tablas normalizadas**.
* Se desarrolló un proceso **ETL (Extract, Transform, Load)** manual utilizando sentencias `INSERT INTO... SELECT` para migrar y estructurar los datos desde la fuente cruda hacia el nuevo modelo relacional.
* El código y los nombres de las tablas se han mantenido en **español** para simular un entorno de trabajo real en banca local (LATAM/Perú), donde las bases de datos suelen estar en el idioma nativo.

### 2. Análisis Exploratorio
Uso de funciones de agregación, Joins, CTEs y segmentación avanzada para aislar perfiles de riesgo.

## ⚙️ Instrucciones de Ejecución (Cómo reproducir el análisis)
Dado que el proyecto utiliza una carga manual para asegurar la integridad de los datos, siga estos pasos:

1.  **Descargar Datos:** Baje el archivo `.csv` adjunto en este repositorio (`Customer-Churn-Records.csv`).
2.  **Importar:** Abra SQL Server y utilice el **Import Wizard** (Asistente de Importación) para cargar el CSV.
3.  **⚠️ IMPORTANTE - Nombre de Tabla:**
    Asegúrese de nombrar la tabla de destino exactamente como:
    `[dbo].[Customer-Churn-Records]`
    *(El script de análisis depende de este nombre específico para funcionar).*
4.  **Ejecutar Script:** Abra el archivo `.sql` y ejecute las consultas para ver el análisis.


## 📊 Insights Clave y Hallazgos

### 1. Panorama General
* **Total de Clientes:** 10,000
* **Tasa de Abandono Global:** 20.38% (2,038 clientes abandonaron el banco).

### 2. Análisis Geográfico (El problema alemán)
Alemania presenta la tasa de fuga más alarmante, duplicando prácticamente a los otros países:
* 🇩🇪 **Alemania:** 32.44% de abandono (814 de 2509 clientes). 🔴 *Foco del análisis*
* 🇪🇸 **España:** 16.67%
* 🇫🇷 **Francia:** 16.17%

Dentro de Alemania, el género femenino es el más afectado, elevando la tasa de riesgo al **37.55%**.

### 3. Perfil de Riesgo: Mujeres en Alemania
Se realizó un "Deep Dive" en este segmento crítico, encontrando patrones determinantes:

**A) La Trampa de la Cantidad de Productos**
Existe una correlación directa (y peligrosa) entre tener pocos y demasiados productos y abandonar el banco.
* **Zona Segura:** Clientes con **2 productos** tienen una tasa de fuga baja (16%).
* **Zona de Peligro:**
    * 1 Producto: 47.13% de riesgo.
    * 3 Productos: **86.79%** de riesgo.
    * 4 Productos: **100%** de fuga (Abandono total).

**B) Vulnerabilidad por Edad**
El riesgo aumenta drásticamente con la edad, alcanzando su pico en la pre-jubilación:
* **50-59 años:** 73% de tasa de abandono (El grupo más crítico).
* **60-69 años:** 60% de tasa de abandono.
* **40-49 años:** 48% de tasa de abandono.

**C) Comportamiento Financiero**
* **Balance:** Sorprendentemente, las clientas con **Balance Alto** (100k - 150k) tienen casi el doble de riesgo de irse (43.78%) comparado con saldos menores. Esto indica una posible fuga de capitales hacia competidores con mejores ofertas VIP.
* **Actividad:** Si bien los clientes inactivos suelen irse más (44.63%), es alarmante que el **29.51% de las clientas ACTIVAS** también abandonan el banco. (1 de cada 3 usuarias activas se va).

---
**Autor:** [Daniel Alberto Lagos Carrillo]
*Estudiante de Ingeniería Industrial | Data Analytics Enthusiast*
[https://www.linkedin.com/in/daniellagos/]
