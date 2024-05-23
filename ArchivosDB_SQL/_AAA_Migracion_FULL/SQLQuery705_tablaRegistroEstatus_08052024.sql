USE LabAllCeramic
go

 DROP TABLE tbRegistroCambioEstatus
go

go
CREATE TABLE [dbo].[tbRegistroCambioEstatus](
	[RegistroCambioEstatusID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderHead] INT NOT NULL,
	[OrderDtl]  INT NOT NULL,
	[OrderRel]  INT NOT NULL,
	[JobNum] [nvarchar](32) NULL,
	[Status] [nvarchar](128) NULL,
	[Inicio] [bit] NULL,
	[Fin] [bit] NULL,
	--[CodigoEstacion] [nvarchar](15) NULL,
	[isOcupado] [bit] NULL,
	[Usuario] [nvarchar](50) NULL,
	[Fecha] [datetime] NULL,
	[UsuarioCaptura] [nvarchar](100) NULL,
 CONSTRAINT [Unique_tbRegistroCambioEstatus] UNIQUE NONCLUSTERED 
(
	[OrderHead] ASC,
	[OrderDtl] ASC,
	[OrderRel] ASC,
	[Status] ASC,
	[Inicio] ASC,
	[Fin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SELECT * FROm tbRegistroCambioEstatus
go

/*

UPDATE tbJobHead SET isYesosEnd = 0, strUsuarioMod = null, strMaquinaMod = null, datFechaMod = null 
UPDATE tbJobOper SET OpComplete = 0, LastLaborDate = null, strUsuarioMod = null, strMaquinaMod = null, datFechaMod = null 
UPDATE tbJobMTL SET CantUtilizada = 0, IssuedComplete = 0, strUsuarioMod = NULL, strMaquinaMod = NULL, datFechaMod = NULL 




*/

--UPDATE tbJobHead SET isAutorizadoEnd = 0  WHERE OrderHead = 6745