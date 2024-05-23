USE LabAllCeramic
go


 /*

DROP TABLE tbDoctor2024
go
DROP TABLE tbTipoProtesis2024
go
DROP TABLE tbTipoTrabajo2024
go
DROP TABLE tbTipoGasto2024
go
DROP TABLE tbProceso2024
go
DROP TABLE tbMaterial2024
go
DROP TABLE tbColor2024
go
DROP TABLE tbColorimetro2024
go
*/

go
CREATE TABLE [dbo].[tbDoctor2024](
	[intDoctor] [int] IDENTITY(1,1) NOT NULL,
	[strNombre] [varchar](500) NULL,
	[strApPaterno] [varchar](500) NULL,
	[strApMaterno] [varchar](500) NULL,
	[strDireccion] [varchar](500) NULL,
	[strEMail] [varchar](50) NULL,
	[strColonia] [varchar](500) NULL,
	[strRFC] [varchar](500) NULL,
	[strNombreFiscal] [varchar](500) NULL,
	[intCP] [int] NULL,
	[strTelefono] [varchar](500) NULL,
	[strCelular] [varchar](500) NULL,
	[strDireccionFiscal] [varchar](500) NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbDoctor2024] UNIQUE NONCLUSTERED 
(
	[intDoctor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Unique_tbDoctor2_2024] UNIQUE NONCLUSTERED 
(
	[strNombre] ASC
	,[strApPaterno] ASC
	,[strApMaterno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
go

 

GO
CREATE TABLE [dbo].[tbTipoProtesis2024](
	[intEmpresa] [int] NULL,
	[intSucursal] [int] NULL,
	[intTipoProtesis] [int] IDENTITY(1,1) NOT NULL,
	[strNombreTipoProtesis] [varchar](150) NULL,
	[intProcesoLaboratorio] [int] NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbTipoProtesis2024] UNIQUE NONCLUSTERED 
(
	[intTipoProtesis] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbTipoProtesis2024] ADD  DEFAULT ((1)) FOR [intEmpresa]
GO

ALTER TABLE [dbo].[tbTipoProtesis2024] ADD  DEFAULT ((1)) FOR [intSucursal]
GO

go


go 
CREATE TABLE [dbo].[tbTipoTrabajo2024](
	[intTipoTrabajo] [int] IDENTITY(1,1) NOT NULL,
	[strNombre] [varchar](500) NULL,
	[strNombreCorto] [varchar](500) NULL,
	[intMaterial] [int] NULL,
	[dblPrecio] [numeric](18, 2) NULL,
	[dblPrecioUrgencia] [numeric](18, 2) NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbtipotrabajo2024] UNIQUE NONCLUSTERED 
(
	[intTipoTrabajo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO 
go


go 
CREATE TABLE [dbo].[tbTipoGasto2024](
	[intTipoGasto] [int] IDENTITY(1,1) NOT NULL,
	[strNombre] [varchar](500) NULL,
	[strNombreCorto] [varchar](500) NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbtipoGasto2024] UNIQUE NONCLUSTERED 
(
	[intTipoGasto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO 
go

	
go 
CREATE TABLE [dbo].[tbProceso2024](
	[intEmpresa] [int] NOT NULL,
	[intSucursal] [int] NOT NULL,
	[intProceso] [int] NOT NULL,
	[intLaboratorio] [int] NULL,
	[intFolioProceso] [int] NULL,
	[strNombreProceso] [varchar](500) NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbProceso2024] ADD  DEFAULT ((1)) FOR [intEmpresa]
GO

ALTER TABLE [dbo].[tbProceso2024] ADD  DEFAULT ((1)) FOR [intSucursal]
GO
 
 --
go 
CREATE TABLE [dbo].[tbMaterial2024](
	[intMaterial] [int] IDENTITY(1,1) NOT NULL,
	[strNombre] [varchar](500) NULL,
	[strNombreCorto] [varchar](500) NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbMaterial2024] UNIQUE NONCLUSTERED 
(
	[intMaterial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

go

  
go 
CREATE TABLE [dbo].[tbColor2024](
	[intColor] [int] IDENTITY(1,1) NOT NULL,
	[strNombre] [varchar](500) NULL,
	[intColorimetro] [int] NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL
) ON [PRIMARY]
GO



    
GO
CREATE TABLE [dbo].[tbColorimetro2024](
	[intColorimetro] [int] IDENTITY(1,1) NOT NULL,
	[strNombre] [varchar](500) NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbColorimetro2024] UNIQUE NONCLUSTERED 
(
	[intColorimetro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

 
 
  
  


