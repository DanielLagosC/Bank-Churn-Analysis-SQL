/*
============================================================================================
PROYECTO   : Análisis de Retención de Clientes Bancarios 
AUTOR      : Daniel Alberto Lagos Carrillo
DESCRIPCIÓN: Scripts de carga desde los datos de la tabla RAW a las tablas normalizadas
============================================================================================
*/
-- =============================================================================
-- Carga de datos a tabla Geografia
-- =============================================================================
INSERT INTO portafolio.dbo.Geografia (Paises)
SELECT DISTINCT Geography
FROM portafolio.dbo.[Customer-Churn-Records]

-- =============================================================================
-- Carga de datos a tabla Tarjetas
-- =============================================================================
INSERT INTO portafolio.dbo.Tarjetas (NombreTarjeta)
SELECT DISTINCT Card_Type
FROM portafolio.dbo.[Customer-Churn-Records]

-- =============================================================================
-- Carga de datos a tabla Clientes
-- =============================================================================
INSERT INTO portafolio.dbo.Clientes (ClienteId, Apellido, Edad, Genero, Id_Pais)
SELECT raw.CustomerId, raw.Surname, raw.Age, raw.Gender, g.Id_Pais
FROM portafolio.dbo.[Customer-Churn-Records] AS     raw
JOIN portafolio.dbo.Geografia AS     g
ON raw.[Geography] = g.Paises

-- =============================================================================
-- Carga de datos a tabla Productos
-- =============================================================================
INSERT INTO portafolio.dbo.Productos (ClienteId, TieneTarjCred, Id_Tarjeta, Puntos_Acum, Cant_de_Prod)
SELECT raw.CustomerId, raw.HasCrCard, t.Id, raw.Point_Earned, raw.NumOfProducts
FROM portafolio.dbo.[Customer-Churn-Records] AS    raw    
JOIN portafolio.dbo.Tarjetas AS     t
ON raw.Card_Type = t.NombreTarjeta

-- =============================================================================
-- Carga de datos a tabla Comportamiento
-- =============================================================================
INSERT INTO portafolio.dbo.Comportamiento (ClienteId, ScoreCrediticio, Antiguedad, EsMiembroActivo,  Abandono, Queja, ScoreSatisfaccion, Balance, SalarioEstimado)
SELECT CustomerId, CreditScore, Tenure, IsActiveMember, Exited, Complain, Satisfaction_Score, Balance, EstimatedSalary
FROM portafolio.dbo.[Customer-Churn-Records] 