/*
================================================================================================
PROYECTO   : Análisis de Abandono de Clientes Bancarios 
AUTOR      : Daniel Alberto Lagos Carrillo
DESCRIPCIÓN: Script maestro de análisis exploratorio (EDA) y detección de patrones de abandono.
================================================================================================
*/
-- =============================================================================
-- 1. KPI: BASE DE CLIENTES
-- =============================================================================
SELECT DISTINCT COUNT(ClienteId) AS CantidadUnicosClientes
FROM portafolio.dbo.Clientes

-- =============================================================================
-- 2. TASA DE RETENCIÓN GLOBAL
-- Identificación de la cantidad de clientes que abandonan y que se quedan
-- =============================================================================
SELECT 
      CASE WHEN Abandono = 0 THEN 'NO ABANDONÓ'ELSE 'ABANDONÓ'END AS Abandono,
      COUNT(com.ClienteId) AS CantidadClientes
FROM portafolio.dbo.Clientes AS c   
JOIN portafolio.dbo.Comportamiento AS com  
     ON c.ClienteId = com.ClienteId
GROUP BY Abandono

-- =============================================================================================================
-- 3. SEGMENTACIÓN GEOGRÁFICA
-- Objetivo: Identificar zona geográfica más crítica según su tasa de abandono
-- Hallazgo: Alemania presenta el riesgo más alto, teniendo 2509 clientes, se van 814, un 32.44% de la población
-- =============================================================================================================
SELECT Paises,
       SUM(Abandono) AS CantidadAbandono, --SUM() funciona como una especie de conteo de solo los que se fueron (Abandono = 1)
       COUNT(com.ClienteId) AS CantidadTotal,
       (CAST(SUM(Abandono) AS decimal(10,2))/CAST(COUNT(com.ClienteId) AS decimal(10,2)))*100 AS 'TasaAbandono (%)' -- Calcular la tasa
FROM portafolio.dbo.Comportamiento AS com    
JOIN portafolio.dbo.Clientes AS c ON com.ClienteId = c.ClienteId
JOIN portafolio.dbo.Geografia AS g ON g.Id_Pais = c.Id_Pais
GROUP BY Paises

-- ==============================================================================================================
-- 4. DESGLOSE DEMOGRÁFICO: ALEMANIA
-- Objetivo: Aislar el género de mayor riesgo dentro de la zona geográfica crítica (Alemania).
-- Hallazgo: Tasa de Abandono en Mujeres (37.55%) supera por mucha diferencia a la tasa de los hombres (27.81%).
-- ==============================================================================================================
SELECT 
      c.Genero AS Genero,
      SUM(Abandono) AS CantidadAbandono, 
      COUNT(com.ClienteId) AS CantidadTotal, 
      (SUM(CAST(Abandono AS decimal(10,2)))/COUNT(CAST(com.ClienteId AS decimal(10,2))))*100 AS Tasa_Abandono 
FROM portafolio.dbo.Clientes AS c   
     JOIN portafolio.dbo.Comportamiento AS com ON c.ClienteId = com.ClienteId
     JOIN portafolio.dbo.Geografia AS g ON c.Id_Pais = g.Id_Pais
WHERE Paises = 'Germany'
GROUP BY Genero

-- =============================================================================
-- 5. SEGMENTO CRÍTICO OBJETIVO: MUJERES ALEMANAS 
-- Se evalúan variables clave filtrando exclusivamente el segmento objetivo.
-- =============================================================================

-- 5.1. Impacto según la cantidad de productos que se tengan
-- INSIGHT: Mujeres Alemanas con 1 producto llegan al casi 50% de riesgo de abandono, 
--          Pero las que tienen 3 y 4 productos presentan un riesgo absoluto (86% y 100%), la zona más crítica
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

-- 5.2. Impacto según segmentación por edad
-- INSIGHT: Los grupos de edades que van desde los 40 hasta los 69 demuestran altos niveles de abandono, 
--          destacar que coincide con la etapa de jubilación de las clientas. Además destacar
--          hecho de que al mismo tiempo registran un promedio de años de antiguedad menor a otros grupos
--          de edad.
WITH Segmentacion_Edad AS(
    SELECT
        Abandono, 
        Antiguedad,
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
        AVG(Antiguedad) AS PromedioAñosAntiguedad,
        SUM(Abandono) AS CantidadAbandono,
        COUNT(Abandono) AS CantidadTotal,
        (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS tasa_edad
FROM Segmentacion_Edad
GROUP BY Segmentacion_Edad
ORDER BY Segmentacion_Edad;

-- 5.3. Impacto según la cantidad de dinero que se tenga en la cuenta del Banco
-- INSIGHT Las clientas con un Balance entre 100 000 y 150 000 presentan casi el doble de riesgo de abandono que 
-- los demás grupos.
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

-- 5.4. Impacto según si se tiene o no actividad en el banco
-- Insight: Alta fuga incluso en miembros activos: sugiere insatisfacción grave con los servicios del banco
--          (aproximadamente 1 de cada 3 clientas activos abandonan).
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
GROUP BY EsMiembroActivo;

-- 5.5. Impacto según los puntos acumulados
-- Insight: Se observa un incremento en la tasa de abandono conforme va creciendo la cantidad de puntos de fidelidad acumulados,
--          esto señala insatisfacción con los posibles beneficios o servicios entregados a partir de estos puntos
WITH Segmentacion_Puntos AS(
    SELECT 
            Abandono,
            CASE 
             WHEN Puntos_Acum < 400 THEN '219-399'
             WHEN Puntos_Acum < 600 THEN '400-599'
             WHEN Puntos_Acum < 800 THEN '600-799'
             ELSE '800-1000'
            END AS Puntos_Acumulados
    FROM portafolio.dbo.Productos AS p   
    JOIN portafolio.dbo.Clientes AS c ON c.ClienteId = p.ClienteId 
    JOIN portafolio.dbo.Geografia AS g ON c.Id_Pais = g.Id_Pais
    JOIN portafolio.dbo.Comportamiento AS com ON com.ClienteId = c.ClienteId
    WHERE Paises = 'Germany' AND Genero = 'Female'
)
SELECT Puntos_Acumulados,
       SUM(Abandono) AS CantidadAbandono,
       COUNT(Abandono) AS CantidadTotal,
       (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS Tasa_Puntos
FROM Segmentacion_Puntos
GROUP BY Puntos_Acumulados