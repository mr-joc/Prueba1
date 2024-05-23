USE AllCeramic2024
go



CREATE TABLE [dbo].[tbMaterial](
	[intMaterial] [int] NOT NULL IDENTITY(1, 1),
	[strNombre] [varchar](500) NULL,
	[strNombreCorto] [varchar](500) NULL,
	[isActivo]  [BIT] NULL,
	[isBorrado] [BIT] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbMaterial] UNIQUE NONCLUSTERED 
(
	[intMaterial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--drop table [tbTipoTrabajo]

CREATE TABLE [dbo].[tbTipoTrabajo]( 
	[intTipoTrabajo] [int]  NOT NULL IDENTITY(1, 1),
	[strNombre] [varchar](500) NULL,
	[strNombreCorto] [varchar](500) NULL,
	[intMaterial] [int] NULL,
	[dblPrecio] [numeric](18, 2) NULL,
	[dblPrecioUrgencia] [numeric](18, 2) NULL,
	[isActivo]  [BIT] NULL,
	[isBorrado] [BIT] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbtipotrabajo] UNIQUE NONCLUSTERED 
( 
	[intTipoTrabajo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


