/*
============================================================================================
PROYECTO   : Análisis de Retención de Clientes Bancarios 
AUTOR      : Daniel Alberto Lagos Carrillo
DESCRIPCIÓN: Scripts de creación de tablas normalizadas
============================================================================================
*/
USE portafolio
-- =============================================================================
-- TABLA DE GEOGRAFIA:
-- =============================================================================
CREATE TABLE [dbo].[Geografia] (
    [Id_Pais] INT          IDENTITY (1, 1) NOT NULL,
    [Paises]  VARCHAR (50) NULL,
    CONSTRAINT [PK_Geografia] PRIMARY KEY CLUSTERED ([Id_Pais] ASC)
);

-- =============================================================================
-- TABLA DE TARJETAS:
-- =============================================================================
CREATE TABLE [dbo].[Tarjetas] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [NombreTarjeta] VARCHAR (50) NULL,
    CONSTRAINT [PK_Tarjetas] PRIMARY KEY CLUSTERED ([Id] ASC)
);

-- =============================================================================
-- TABLA DE CLIENTES:	
-- =============================================================================
CREATE TABLE [dbo].[Clientes] (
    [ClienteId] INT          NOT NULL,
    [Apellido]    VARCHAR (100) NULL,
    [Edad]        TINYINT      NULL,
    [Genero]     VARCHAR (50) NULL,
    [Id_Pais]    INT          NULL,
    CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED ([ClienteId] ASC),  
    CONSTRAINT [FK_Clientes_Geografia] FOREIGN KEY ([Id_Pais]) REFERENCES [dbo].[Geografia]([Id_Pais])
);

-- =============================================================================
-- TABLA DE PRODUCTOS:
-- =============================================================================
CREATE TABLE [dbo].[Productos] (
    [Id_Producto]   INT          IDENTITY (1, 1) NOT NULL,
    [ClienteId]     INT          NOT NULL,
    [TieneTarjCred] INT          NULL,
    [Id_Tarjeta]    INT          NULL,
    [Puntos_Acum]   INT          NULL,
    [Cant_de_Prod]  INT          NULL,
    CONSTRAINT [PK_Productos] PRIMARY KEY CLUSTERED ([Id_Producto] ASC),
    CONSTRAINT [FK_Productos_Clientes] FOREIGN KEY ([ClienteId]) REFERENCES [dbo].[Clientes]([ClienteId]),
    CONSTRAINT [FK_Productos_Tarjetas] FOREIGN KEY ([Id_Tarjeta]) REFERENCES [dbo].[Tarjetas]([Id])
);

-- =============================================================================
-- TABLA DE COMPORTAMIENTO:
-- =============================================================================
CREATE TABLE [dbo].[Comportamiento] (
    [Id_Comportamiento] INT          IDENTITY (1, 1) NOT NULL,
    [ClienteId]         INT          NOT NULL,
    [ScoreCrediticio]   INT          NULL,
    [Antiguedad]        INT          NULL,
    [EsMiembroActivo]   INT          NULL,
    [Abandono]          INT          NULL,
    [Queja]             INT          NULL,
    [ScoreSatisfaccion] INT          NULL,
    [Balance]           DECIMAL (18,10) NULL,
    [SalarioEstimado]   DECIMAL (18,10) NULL,
    CONSTRAINT [PK_Comportamiento] PRIMARY KEY CLUSTERED ([Id_Comportamiento] ASC),
    CONSTRAINT [FK_Comportamiento_Clientes] FOREIGN KEY ([ClienteId]) REFERENCES [dbo].[Clientes]([ClienteId])
);
