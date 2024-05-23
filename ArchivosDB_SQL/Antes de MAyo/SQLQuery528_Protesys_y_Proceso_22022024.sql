USE AllCeramic2024
go

--USE LabAllCeramic
go




/*
DROP TABLE tbTipoProtesis

go
CREATE TABLE [dbo].[tbTipoProtesis](
	[intEmpresa] [int] NULL  DEFAULT(1),
	[intSucursal] [int] NULL DEFAULT(1),
	[intTipoProtesis] [int] NOT NULL IDENTITY(1, 1),
	[strNombreTipoProtesis] [varchar](150) NULL,
	[intProcesoLaboratorio] [int] NULL,
	[isActivo]  [BIT] NULL,
	[isBorrado] [BIT] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbTipoProtesis] UNIQUE NONCLUSTERED 
(
	[intTipoProtesis] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

*/

/*

--INSERT tbTipoProtesis(intEmpresa, intSucursal, strNombreTipoProtesis, intProcesoLaboratorio, isActivo, isBorrado, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod)
SELECT intEmpresa, intSucursal, strNombreTipoProtesis, intProcesoLaboratorio, isActivo = 1, isBorrado = 0, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod
FROM LabAllCeramic.dbo.tbTipoProtesis
ORDER BY intTipoProtesis


--SELECT * FROM LabAllCeramic.dbo.tbProceso
*/



--SELECT * FROM tbTipoProtesis
go


go
--qryTipoProtesis_Sel @intEmpresa = 1, @intSucursal = 1, @intTipoProtesis = 0 , @intActivas= 1
alter PROCEDURE qryTipoProtesis_Sel(
	 @intEmpresa		INT     
	,@intSucursal		INT     
	,@intTipoProtesis	INT   
	,@intActivas		INT = NULL
)    
AS    
BEGIN    

	SET @intActivas = ISNULL(@intActivas, 0)


	SET NOCOUNT ON;    
	SELECT intEmpresa,intSucursal,intTipoProtesis,strNombreTipoProtesis,intProcesoLaboratorio   
	FROM tbTipoProtesis(NOLOCK)    
	WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal 
		AND (intTipoProtesis=@intTipoProtesis OR @intTipoProtesis=0)    
		AND (isActivo = @intActivas OR @intActivas=0)    
END
go


/*
 
qryProcesosIniciales_Sel 

--qryProcesosIniciales_Sel 1,1,1,0
CREATE PROCEDURE qryProcesosIniciales_Sel
	 @intEmpresa INT 
	,@intSucursal INT 
	,@intProtesis INT 
	,@intProceso INT
AS
BEGIN
	SET NOCOUNT ON
	SELECT intProceso, intLaboratorio, intFolioProceso, strNombreProceso
	FROM tbProceso P WHERE 
		(intProceso = @intProceso OR @intProceso=0)
		AND intEmpresa=@intEmpresa
		AND intSucursal=@intSucursal
		--AND intFolioProceso=1
		AND intLaboratorio=@intProtesis
	SET NOCOUNT OFF
END
*/


/*

--drop table tbProceso
go
CREATE TABLE [dbo].[tbProceso](
	[intEmpresa] [int]  NOT NULL DEFAULT(1),
	[intSucursal] [int] NOT NULL DEFAULT(1),
	[intProceso] [int] NOT NULL,
	[intLaboratorio] [int] NULL,
	[intFolioProceso] [int] NULL,
	[strNombreProceso] [varchar](500) NULL,
	[isActivo]  [BIT] NULL,
	[isBorrado] [BIT] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
) ON [PRIMARY]
GO
go

*/

/*
--INSERT  tbProceso  (intEmpresa,intSucursal,intProceso,intLaboratorio,intFolioProceso,strNombreProceso,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod )
SELECT intEmpresa,intSucursal,intProceso,intLaboratorio,intFolioProceso,strNombreProceso,isActivo=1,isBorrado=0,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod FROM LabAllCeramic.dbo.tbProceso  

*/



--SELECT * FROM tbProceso  


--qryProcesosIniciales_Sel @intEmpresa = 1, @intSucursal = 1, @intProtesis = 1, @intProceso = 0, @intActivos = 1
alter PROCEDURE qryProcesosIniciales_Sel
	 @intEmpresa	INT 
	,@intSucursal	INT 
	,@intProtesis	INT 
	,@intProceso	INT
	,@intActivos	INT = NULL
AS
BEGIN
	SET NOCOUNT ON

	SET @intActivos = ISNULL(@intActivos, 0)


	SELECT 
		intProceso, intLaboratorio, intFolioProceso, strNombreProceso
	FROM tbProceso P WHERE 
		(intProceso = @intProceso OR @intProceso=0)
		AND intEmpresa=@intEmpresa
		AND intSucursal=@intSucursal 
		AND intLaboratorio=@intProtesis 
		AND (isActivo = @intActivos OR @intActivos=0)    
	SET NOCOUNT OFF
END




--USE LabAllCeramic
go
