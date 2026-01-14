/*
============================================================================================
PROYECTO   : Análisis de Retención de Clientes Bancarios 
AUTOR      : Daniel Alberto Lagos Carrillo
DESCRIPCIÓN: Scripts de variables / hipótesis descartadas
============================================================================================
*/
/*
--------------------------------------------------------------------------------------------------------------
Creación de Tabla Temporal para evitar repetir los JOINS en cada script y hacer más legible el código
--------------------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS #TablaTemporal;
SELECT Abandono,
       com.ScoreSatisfaccion AS ScoreSatisfaccion,
       com.Antiguedad AS Antiguedad,
       CASE
        WHEN com.ScoreCrediticio < 450  THEN '01_Score Muy Bajo'
        WHEN com.ScoreCrediticio < 550 THEN '02_Score Bajo'
        WHEN com.ScoreCrediticio < 650 THEN '03_Score Moderado'
        WHEN com.ScoreCrediticio < 750 THEN '04Score Alto'
        ELSE '05_Score Muy Alto'
       END AS Segmentacion_ScoreCreditico,
       CASE 
        WHEN Queja = 0 THEN 'NO'
        WHEN Queja = 1 THEN 'SI'
       END AS PresentoQueja,
       CASE
        WHEN SalarioEstimado < 50000 THEN '01_Salario Bajo'
        WHEN SalarioEstimado < 100000 THEN '02_Salario Moderado'
        WHEN SalarioEstimado < 150000 THEN '03_Salario Alto'
        ELSE '04_Salario Muy Alto'
       END AS Segmentacion_SalarioEstimado,
       CASE 
        WHEN TieneTarjCred = 0 THEN 'NO TIENE'
        WHEN TieneTarjCred = 1 THEN 'SÍ TIENE'
       END AS TieneTarjetaCredito,
       CASE 
            WHEN Puntos_Acum < 400 THEN '219-399'
            WHEN Puntos_Acum < 600 THEN '400-599'
            WHEN Puntos_Acum < 800 THEN '600-799'
            ELSE '800-1000'
           END AS Puntos_Acumulados,
       NombreTarjeta AS TipoTarjeta
INTO #TablaTemporal
FROM portafolio.dbo.Productos AS p   
JOIN portafolio.dbo.Clientes AS c ON c.ClienteId = p.ClienteId 
JOIN portafolio.dbo.Geografia AS g ON c.Id_Pais = g.Id_Pais
JOIN portafolio.dbo.Comportamiento AS com ON com.ClienteId = c.ClienteId
JOIN portafolio.dbo.Tarjetas AS t ON t.Id = p.Id_Tarjeta
WHERE Paises = 'Germany' AND Genero = 'Female'

/*
--------------------------------------------------------------------------------------------------------------
1) Tasa de abandono según el Score de Satisfacción
COMENTARIO: se descartó esta variable ya que no se encontró una variación significativa entre los distintos
            scores de satisfaccion que pueda tener una clienta alemana, es decir esta variable no influye en 
            la decisión de abandonar
--------------------------------------------------------------------------------------------------------------
*/
SELECT
        ScoreSatisfaccion,
        SUM(Abandono) AS CantidadAbandono,
        COUNT(Abandono) AS CantidadTotal,
        (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS tasa_satisfaccion
    FROM #TablaTemporal
    GROUP BY ScoreSatisfaccion
    ORDER BY ScoreSatisfaccion asc;

/*
--------------------------------------------------------------------------------------------------------------
2) Tasa de abandono según la Antiguedad
COMENTARIO: se descartó por falta de variación entre los distintos años de antiguedad, no hay patrón reconocible
            o un segmento especial que represente una explicación a la decisión de abandono
--------------------------------------------------------------------------------------------------------------
*/
SELECT
        Antiguedad,
        SUM(Abandono) AS CantidadAbandono,
        COUNT(Abandono) AS CantidadTotal,
        (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS tasa_antiguedad
    FROM #TablaTemporal
    GROUP BY Antiguedad
    ORDER BY Antiguedad asc;

/*
--------------------------------------------------------------------------------------------------------------
3) Tasa de abandono según el Score Crediticio
COMENTARIO: Se descartó la variable por no representar variaciones entre los distintos grupos, a excepción de
            uno que sí destaca, pero ese resultado diferenciador se puede tomar como un comportamiento esperable
--------------------------------------------------------------------------------------------------------------
*/
SELECT  
        Segmentacion_ScoreCreditico,
        SUM(Abandono) AS CantidadAbandono,
        COUNT(Abandono) AS CantidadTotal,
        (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS tasa_score
FROM #TablaTemporal
GROUP BY Segmentacion_ScoreCreditico
ORDER BY Segmentacion_ScoreCreditico;

/*
--------------------------------------------------------------------------------------------------------------
4) Tasa de abandono según si tuvo una Queja
COMENTARIO: El resultado más redundante y esperado, es la correlación más directa y clara del dataset: casi la
            la totalidad de las mujeres alemanas que presentaron una queja en el banco, abandonaron.
            Incluso se podría hipotetizar que la queja es consecuencia a la decisión de abandono.
--------------------------------------------------------------------------------------------------------------
*/
SELECT PresentoQueja,
       SUM(Abandono) AS CantidadAbandono,
       COUNT(Abandono) AS CantidadTotal,
       (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS tasa_esmiembroactivo
FROM #TablaTemporal
GROUP BY PresentoQueja     -- Da  un dato redundante pero que igual necesita ser verificado

/*
--------------------------------------------------------------------------------------------------------------
5) Tasa de abandono según su Salario Estimado
COMENTARIO: Se descartó porque no se encontró un patrón claro o significativo que explique el abandono, no hay
            variación entre los segmentos.
--------------------------------------------------------------------------------------------------------------
*/
SELECT 
    Segmentacion_SalarioEstimado,
    SUM(Abandono) AS CantidadAbandono,
    COUNT(Abandono) AS CantidadTotal,
    (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS tasa_balance
FROM #TablaTemporal
GROUP BY Segmentacion_SalarioEstimado
ORDER BY Segmentacion_SalarioEstimado ASC;

/*
--------------------------------------------------------------------------------------------------------------
6) Tasa de abandono según si tiene tarjeta de crédito o no
COMENTARIO: La tasa de abandono es prácticamente igual si se tiene tarjeta o no, lo que indica que la posesión
            de una tarjeta no tiene impacto alguno en la decisión de abandonar el banco
--------------------------------------------------------------------------------------------------------------
*/
SELECT 
      TieneTarjetaCredito,
      SUM(Abandono) AS CantidadAbandono,
      COUNT(Abandono) AS CantidadTotal,
      (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS Tasa_TieneTarj
FROM #TablaTemporal
GROUP BY TieneTarjetaCredito;    --RESULTADO: NADA REVELADOR

/*
--------------------------------------------------------------------------------------------------------------
7) Tasa de abandono según su tipo de tarjeta
COMENTARIO: No hay variación entre las tasas, lo que indica que el tipo de tarjeta que se posea (o al cual una
            mujer alemana pueda postular), no tiene impacto significativo en la decisión de abandonar el banco
--------------------------------------------------------------------------------------------------------------
*/
SELECT
      TipoTarjeta,
      SUM(Abandono) AS CantidadAbandono,
      COUNT(Abandono) AS CantidadTotal,
      (CAST(SUM(Abandono) AS DECIMAL(10,2))/CAST(COUNT(Abandono) AS DECIMAL(10,2)))*100 AS Tasa_TipoTarjeta
FROM #TablaTemporal
GROUP BY TipoTarjeta;      
