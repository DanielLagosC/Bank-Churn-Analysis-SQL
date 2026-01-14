-- ================================================================================================
-- VERIFICACIÓN DE EXISTENCIA DE NULLS
-- COMENTARIO: Usé la estructura de SUM (CASE WHEN) para que funcione como un COUNT() pero con
--             filtro incluido, donde la parte "THEN 1 ELSE 0" marca la pauta de qué sumar y qué no
-- RESULTADO: Todas las columnas dan 0 como resultado, indicando que no hay existencias de nulls.
-- ================================================================================================
SELECT 
       SUM(CASE WHEN CustomerId IS NULL THEN 1 ELSE 0 END) AS Nulos_en_CustomerId, 
       SUM(CASE WHEN Surname IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Surname, 
       SUM(CASE WHEN CreditScore IS NULL THEN 1 ELSE 0 END) AS Nulos_en_CreditScore, 
       SUM(CASE WHEN [Geography] IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Geography, 
       SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Gender, 
       SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Age, 
       SUM(CASE WHEN Tenure IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Tenure, 
       SUM(CASE WHEN Balance IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Balance, 
       SUM(CASE WHEN NumOfProducts IS NULL THEN 1 ELSE 0 END) AS Nulos_en_NumOfProducts, 
       SUM(CASE WHEN HasCrCard IS NULL THEN 1 ELSE 0 END) AS Nulos_en_HasCrCard, 
       SUM(CASE WHEN IsActiveMember IS NULL THEN 1 ELSE 0 END) AS Nulos_en_IsActiveMember, 
       SUM(CASE WHEN EstimatedSalary IS NULL THEN 1 ELSE 0 END) AS Nulos_en_EstimatedSalary, 
       SUM(CASE WHEN Exited IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Exited, 
       SUM(CASE WHEN Complain IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Complain, 
       SUM(CASE WHEN Satisfaction_Score IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Satisfaction_Score, 
       SUM(CASE WHEN Card_Type IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Card_Type, 
       SUM(CASE WHEN Point_Earned IS NULL THEN 1 ELSE 0 END) AS Nulos_en_Point_Earned
FROM portafolio.dbo.[Customer-Churn-Records]

-- ================================================================================================
-- VERIFICACIÓN DE QUE NO HAY CLIENTES DUPLICADOS SEGUN CUSTOMERID
-- RESULTADO: La tabla no tiene ninguna entrada, lo que indica que no existe ningún cliente duplicado
-- ================================================================================================
SELECT CustomerId,
       COUNT(*) AS Cantidad_Duplicado
FROM portafolio.dbo.[Customer-Churn-Records]
GROUP BY CustomerId
HAVING COUNT(*) > 1

-- ================================================================================================
-- VERIFICACIÓN DE NO DUPLICADOS SEGÚN LOS ATRIBUTOS DEL CLIENTE
-- COMENTARIO 1: Se vió pertinente buscar un duplicado teniendo en cuenta todas las columnas
--               al mismo tiempo, ya que hacía más estricto la identificación.
-- COMENTARIO 2: No se tomó en cuenta Surname por precaución contra posible error de tipeo en el nombre
--               (ya sea mala coincidencia de incluso un digito errado) o contra casos de homonimia
-- RESULTADO: La tabla no tiene ninguna entrada, lo que indica que no existe ningún cliente duplicado
-- ================================================================================================
SELECT CreditScore, [Geography], Gender, Age, Tenure, Balance, NumOfProducts, HasCrCard, IsActiveMember, EstimatedSalary, Exited,
       Complain, Satisfaction_Score, Card_Type, Point_Earned, COUNT(*) AS Cantidad_Duplicado
FROM portafolio.dbo.[Customer-Churn-Records]
GROUP BY CreditScore, [Geography], Gender, Age, Tenure, Balance, NumOfProducts, HasCrCard, IsActiveMember, EstimatedSalary, Exited,
       Complain, Satisfaction_Score, Card_Type, Point_Earned
HAVING COUNT(*) > 1

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA CREDITSCORE
-- ================================================================================================
-- a) Para demostrar que no hay ningún decimal colado ni negativos
SELECT CreditScore 
FROM portafolio.dbo.[Customer-Churn-Records]
WHERE CreditScore < 0 OR CreditScore % 1 <> 0
-- b) Muestra los valores límites de la columna: MIN = 350, MAX = 850
SELECT MIN(CreditScore) AS Min_CreditScore, MAX(CreditScore) AS Max_CreditScore
FROM portafolio.dbo.[Customer-Churn-Records];

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA GEOGRAPHY
-- RESULTADO: No hay errores de tipeo o espacios extra
-- ================================================================================================
SELECT DISTINCT [Geography]
FROM portafolio.dbo.[Customer-Churn-Records]

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA GENDER
-- RESULTADO: Se comprueba que no existen errores de tipeo o espacios extra
-- ================================================================================================
SELECT DISTINCT [Gender]
FROM portafolio.dbo.[Customer-Churn-Records]

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA AGE
-- ================================================================================================
-- a) Para demostrar que no hay ningún decimal colado ni negativos
SELECT Age 
FROM portafolio.dbo.[Customer-Churn-Records]
WHERE Age < 0 OR Age % 1 <> 0
-- b) Muestra los valores límites de la columna: MIN = 18, MAX = 92
SELECT MIN(Age) AS Min_Age, MAX(Age) AS Max_Age
FROM portafolio.dbo.[Customer-Churn-Records];

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA TENURE 
-- ================================================================================================
-- a) Para demostrar que no hay ningún decimal colado ni negativos
SELECT Tenure
FROM portafolio.dbo.[Customer-Churn-Records]
WHERE Tenure < 0 OR Tenure % 1 <> 0
-- b) Muestra los valores límites de la columna: MIN = 0, MAX = 10
SELECT MIN(Tenure) AS Min_Tenure, MAX(Tenure) AS Max_Tenure
FROM portafolio.dbo.[Customer-Churn-Records];


-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA BALANCE
-- ================================================================================================
-- a) Para demostrar que no hay negativos
SELECT Balance
FROM portafolio.dbo.[Customer-Churn-Records]
WHERE Balance < 0
-- b) Muestra los valores límites de la columna: MIN = 0, MAX = 250898.09375
SELECT MIN(Balance) AS Min_Balance, MAX(Balance) AS Max_Balance
FROM portafolio.dbo.[Customer-Churn-Records];


-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA NUMOFPRODUCTS
-- RESULTADO: Se comprueba que no existen errores de tipeo o espacios extra
-- ================================================================================================
SELECT DISTINCT NumOfProducts
FROM portafolio.dbo.[Customer-Churn-Records]
ORDER BY NumOfProducts ASC

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA HASCRCARD 
-- RESULTADO: Se comprueba que no existen errores de tipeo o espacios extra
-- ================================================================================================
SELECT DISTINCT HasCrCard
FROM portafolio.dbo.[Customer-Churn-Records]

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA ISACTIVEMEMBER 
-- RESULTADO: Se comprueba que no existen errores de tipeo o espacios extra
-- ================================================================================================
SELECT DISTINCT IsActiveMember
FROM portafolio.dbo.[Customer-Churn-Records]

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA ESTIMATEDSALARY
-- ================================================================================================
-- a) Demostrar que no hay negativos
SELECT EstimatedSalary
FROM portafolio.dbo.[Customer-Churn-Records]
WHERE EstimatedSalary < 0
-- b) Muestra los valores límites de la columna: MIN = 11.579999923706055, MAX = 199992.484375
SELECT MIN(EstimatedSalary) AS Min_Salary, MAX(EstimatedSalary) AS Max_Salary
FROM portafolio.dbo.[Customer-Churn-Records];

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA EXITED
-- RESULTADO: Se comprueba que no existen errores de tipeo o espacios extra
-- ================================================================================================
SELECT DISTINCT Exited
FROM portafolio.dbo.[Customer-Churn-Records]

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA COMPLAIN
-- RESULTADO: Se comprueba que no existen errores de tipeo o espacios extra
-- ================================================================================================
SELECT DISTINCT Complain
FROM portafolio.dbo.[Customer-Churn-Records]

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA SATISFACTION_SCORE 
-- RESULTADO: Se comprueba que no existen errores de tipeo o espacios extra
-- ================================================================================================
SELECT DISTINCT Satisfaction_Score
FROM portafolio.dbo.[Customer-Churn-Records]
ORDER BY Satisfaction_Score ASC

-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA CARD_TYPE 
-- RESULTADO: Se comprueba que no existen errores de tipeo o espacios extra
-- ================================================================================================
SELECT DISTINCT Card_Type
FROM portafolio.dbo.[Customer-Churn-Records]


-- ================================================================================================
-- VALIDACIÓN EN LA COLUMNA POINT_EARNED 
-- ================================================================================================
-- a) Demostrar que no hay negativos
SELECT Point_Earned
FROM portafolio.dbo.[Customer-Churn-Records]
WHERE Point_Earned < 0 OR Point_Earned % 1 <> 0
-- b) Muestra los valores límites de la columna: MIN = 119, MAX = 1000
SELECT MIN(Point_Earned) AS Min_Point, MAX(Point_Earned) AS Max_Point
FROM portafolio.dbo.[Customer-Churn-Records];



