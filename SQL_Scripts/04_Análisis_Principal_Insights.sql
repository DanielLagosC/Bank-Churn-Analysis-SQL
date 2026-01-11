/*
============================================================================================
PROYECTO   : Análisis de Retención de Clientes Bancarios 
AUTOR      : Daniel Alberto Lagos Carrillo
DESCRIPCIÓN: Script maestro de análisis exploratorio (EDA) y detección de patrones de fuga.
============================================================================================
*/
-- =============================================================================
-- 1. KPI MACRO: BASE DE CLIENTES
-- =============================================================================
SELECT DISTINCT COUNT(ClienteId) AS CantidadUnicosClientes
FROM portafolio.dbo.Clientes

-- =============================================================================
-- 2. TASA DE RETENCIÓN GLOBAL
-- Identificación de la distribución de fuga vs. retención.
-- =============================================================================
SELECT 
      CASE WHEN Abandono = 0 THEN 'NO ABANDONÓ'ELSE 'ABANDONÓ'END AS Abandono,
      COUNT(com.ClienteId) AS CantidadClientes
FROM portafolio.dbo.Clientes AS c   
JOIN portafolio.dbo.Comportamiento AS com  
     ON c.ClienteId = com.ClienteId
GROUP BY Abandono

-- =============================================================================
-- 3. SEGMENTACIÓN GEOGRÁFICA
-- Objetivo: Identificar zonas críticas. 
-- Hallazgo: Alemania presenta el riesgo más alto.
-- =============================================================================
SELECT Paises,
       SUM(Abandono) AS CantidadAbandono, --aprovechando que la columna Abandono tiene puros 0 y 1, 
                                          --SUM() funciona como una especie de conteo de solo los que se fueron (Abandono = 1)
       COUNT(com.ClienteId) AS CantidadTotal,
       (CAST(SUM(Abandono) AS decimal(10,2))/CAST(COUNT(com.ClienteId) AS decimal(10,2)))*100 AS 'TasaAbandono (%)'
FROM portafolio.dbo.Comportamiento AS com    
JOIN portafolio.dbo.Clientes AS c ON com.ClienteId = c.ClienteId
JOIN portafolio.dbo.Geografia AS g ON g.Id_Pais = c.Id_Pais
GROUP BY Paises

-- =============================================================================
-- 4. DESGLOSE DEMOGRÁFICO: ALEMANIA
-- Objetivo: Aislar el género de mayor riesgo dentro de la zona crítica.
-- Hallazgo: Mujeres en Alemania superan la media global de abandono.
-- =============================================================================
SELECT 
      c.Genero AS Genero,
      SUM(Abandono) AS CantidadAbandono, 
      COUNT(com.ClienteId) AS CantidadTotal, 
      (SUM(CAST(Abandono AS decimal(10,2)))/COUNT(CAST(com.ClienteId AS decimal(10,2))))*100 AS Tasa_Abandono -- Calcular la tasa
FROM portafolio.dbo.Clientes AS c   
     JOIN portafolio.dbo.Comportamiento AS com ON c.ClienteId = com.ClienteId
     JOIN portafolio.dbo.Geografia AS g ON c.Id_Pais = g.Id_Pais
WHERE Paises = 'Germany'
GROUP BY Genero

-- =============================================================================
-- 5. PERFIL DE RIESGO: MUJERES ALEMANAS (ANÁLISIS DE SENSIBILIDAD)
-- Se evalúan variables clave filtrando exclusivamente el segmento objetivo.
-- =============================================================================

-- 5.1. Impacto de la Tenencia de Productos
-- INSIGHT: Relación no lineal. "La Curva de la Muerte" en 3 y 4 productos.
SELECT
      Cant_de_Prod,
      SUM(Abandono) AS CantidadAbandono,
      COUNT(Abandono) AS CantidadTotal,
      (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS Tasa_CantidadProd
FROM portafolio.dbo.Productos AS p   
JOIN portafolio.dbo.Clientes AS c ON c.ClienteId = p.ClienteId 
JOIN portafolio.dbo.Geografia AS g ON c.Id_Pais = g.Id_Pais
JOIN portafolio.dbo.Comportamiento AS com ON com.ClienteId = c.ClienteId
WHERE Paises = 'Germany' AND Genero = 'Female'
GROUP BY Cant_de_Prod;

-- 5.2. Segmentación Etaria (Cohortes de Edad)
-- INSIGHT: Los grupos de edades que van desde los 40 hasta los 69 demuestran altos niveles de abandono
WITH Segmentacion_Edad AS(
    SELECT
        Abandono, 
        CASE
        WHEN Edad < 30  THEN '18-29'
        WHEN Edad < 40 THEN '30-39'
        WHEN Edad < 50 THEN '40-49'
        WHEN Edad < 60 THEN '50-59'
        WHEN Edad < 70 THEN '60-69'
        ELSE '70-77'
        END AS Segmentacion_Edad
    FROM portafolio.dbo.Comportamiento AS com  
    JOIN portafolio.dbo.Clientes AS c ON c.ClienteId = com.ClienteId
    JOIN portafolio.dbo.Geografia AS g ON c.Id_Pais = g.Id_Pais
    WHERE Paises = 'Germany' AND Genero = 'Female'
)
SELECT  
        Segmentacion_Edad,
        SUM(Abandono) AS CantidadAbandono,
        COUNT(Abandono) AS CantidadTotal,
        (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS tasa_edad
FROM Segmentacion_Edad
GROUP BY Segmentacion_Edad
ORDER BY Segmentacion_Edad;

-- 5.3. Sensibilidad al Balance Bancario
WITH Segmentacion_Balance AS(
    SELECT
        Abandono, 
        CASE
        WHEN com.Balance < 50000 THEN 'Balance Bajo'
        WHEN com.Balance < 100000 THEN 'Balance Moderado'
        WHEN com.Balance < 150000 THEN 'Balance Alto'
        ELSE 'Balance Muy Alto'
        END AS Segmentacion_Balance
    FROM portafolio.dbo.Comportamiento AS com  
    JOIN portafolio.dbo.Clientes AS c ON c.ClienteId = com.ClienteId
    JOIN portafolio.dbo.Geografia AS g ON c.Id_Pais = g.Id_Pais
    WHERE Paises = 'Germany' AND Genero = 'Female'
)
SELECT 
    Segmentacion_Balance,
    SUM(Abandono) AS CantidadAbandono,
    COUNT(Abandono) AS CantidadTotal,
    (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS tasa_balance
FROM Segmentacion_Balance
GROUP BY Segmentacion_Balance;

-- 5.4. Correlación con Actividad (Miembro Activo)
-- Insight: Alta fuga incluso en miembros activos sugiere insatisfacción grave (1 de cada 3 clientas se van)
SELECT 
       CASE 
        WHEN EsMiembroActivo = 0 THEN 'NO'
        WHEN EsMiembroActivo = 1 THEN 'SI'
        END AS EsMiembroActivo,
       SUM(Abandono) AS CantidadAbandono,
       COUNT(Abandono) AS CantidadTotal,
       (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS tasa_esmiembroactivo
FROM portafolio.dbo.Comportamiento AS com  
JOIN portafolio.dbo.Clientes AS c ON c.ClienteId = com.ClienteId
JOIN portafolio.dbo.Geografia AS g ON c.Id_Pais = g.Id_Pais
WHERE Genero = 'Female' AND Paises = 'Germany'
GROUP BY EsMiembroActivo
