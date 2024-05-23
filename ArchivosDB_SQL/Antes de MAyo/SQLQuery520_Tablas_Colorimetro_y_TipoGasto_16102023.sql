USE AllCeramic2024
go



CREATE TABLE [dbo].[tbTipoGasto](
	[intTipoGasto] [int] NOT NULL IDENTITY(1, 1),
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
 CONSTRAINT [Unique_tbtipoGasto] UNIQUE NONCLUSTERED 
(
	[intTipoGasto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[tbColorimetro](
	[intColorimetro] [int] NOT NULL IDENTITY(1, 1),
	[strNombre] [varchar](500) NULL,
	[isActivo]  [BIT] NULL,
	[isBorrado] [BIT] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbColorimetro] UNIQUE NONCLUSTERED 
( 
	[intColorimetro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE AllCeramic2024
go

----INSERT tbTipoGasto(strNombre,strNombreCorto,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod)
--select -- intTipoGasto,
--strNombre,strNombreCorto,isActivo=intActivo,isBorrado=0,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod from LabAllCeramic.dbo.tbTipoGasto ORDER BY intTipoGasto



select * from [tbTipoGasto]

----INSERT tbColorimetro(strNombre,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod)
--SELECT --intColorimetro,
--strNombre,isActivo=intActivo,isBorrado=0,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod FROM LabAllCeramic.dbo.tbColorimetro ORDER BY intColorimetro


SELECT * FROM tbColorimetro






