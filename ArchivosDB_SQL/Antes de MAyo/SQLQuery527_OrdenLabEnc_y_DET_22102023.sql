USE AllCeramic2024
go



DROP TABLE tbOrdenLaboratorioEnc
GO
DROP TABLE tbOrdenLaboratorioDet
GO





CREATE TABLE [dbo].[tbOrdenLaboratorioEnc](
	[intOrdenLaboratorioEnc] [int] IDENTITY(1,1) /**/NOT NULL,
	[intFolio] [int] NOT NULL,
	[intClinica] [int] NULL,
	[intDoctor] [int] NOT NULL,
	[strNombrePaciente] [varchar](500) NULL,
	[intExpediente] [int] NOT NULL,
	[intTipoProtesis] [int] NOT NULL,
	[intPieza] [numeric](18, 2) NOT NULL,
	[intProceso] [int] NOT NULL,
	[intTipoTrabajo] [int] NOT NULL,
	[strColor] [varchar](10) NULL,
	[strComentario] [varchar](500) NULL,
	[intEstatus] [int] NULL,
	[intCajaAlmacenamiento] [int] NULL,
	[datFechaEntrega] [datetime] NULL,
	[datFechaColocacion] [datetime] NULL,
	[intColorimetro] [int] NULL,
	[intFolioPago] [int] NULL,
	[intUrgente] [int] NULL,
	[intLabExterno] [int] NULL,
	[dblPrecio] [numeric](18, 2) NULL,
	[intPagado] [int] NULL,
	[strObservaciones] [varchar](500) NULL,
	[intEdad] [int] NULL,
	[intSexo] [int] NULL,
	[intConGarantia] [int] NULL,
	[strImagen01] [varchar](300) NULL,
	[strImagen02] [varchar](300) NULL,
	[strImagen03] [varchar](300) NULL,
	[strImagen04] [varchar](300) NULL,
	[strImagen05] [varchar](300) NULL,
	[strImagen06] [varchar](300) NULL,
	[strImagen07] [varchar](300) NULL,
	[strImagen08] [varchar](300) NULL,
	[strImagen09] [varchar](300) NULL,
	[strImagen10] [varchar](300) NULL,
	[strImagen11] [varchar](300) NULL,
	[strImagen12] [varchar](300) NULL,
	[strImagen13] [varchar](300) NULL,
	[strImagen14] [varchar](300) NULL,
	[strImagen15] [varchar](300) NULL,
	[strImagen16] [varchar](300) NULL,
	[strImagen17] [varchar](300) NULL,
	[strImagen18] [varchar](300) NULL,
	[strImagen19] [varchar](300) NULL,
	[strImagen20] [varchar](300) NULL,
	[intColor] [int] NULL,
	[intFactura] [int] NULL,
	[intEstatusProceso] [int] NULL,
	[intSolicitudFacturaDet] [int] NULL,
	[intFacturaEnc_Pertenece] [int] NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	intOrdenLaboratorioEnc__RESPALDO INT,
 CONSTRAINT [PK_tbOrdenLaboratorioEnc] PRIMARY KEY CLUSTERED 
(
	[intOrdenLaboratorioEnc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



CREATE TABLE [dbo].[tbOrdenLaboratorioDet](
	[intOrdenLaboratorioDet] [int] /*IDENTITY(1,1)*/ NOT NULL,
	[intOrdenLaboratorioEnc] [int] NOT NULL,
	[intPieza] [varchar](30) NULL,
	[intMaterial] [int] NOT NULL,
	[intTipoTrabajo] [int] NOT NULL,
	[strColor] [varchar](10) NOT NULL,
	[intLabPredeterminado] [int] NULL,
	[dblPrecioLab] [numeric](18, 2) NULL,
	[intCantidad] [int] NULL,
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
) ON [PRIMARY]
GO


INSERT tbOrdenLaboratorioEnc(
 intFolio
,intClinica
,intDoctor
,strNombrePaciente
,intExpediente
,intTipoProtesis
,intPieza
,intProceso
,intTipoTrabajo
,strColor
,strComentario
,intEstatus
,intCajaAlmacenamiento
,datFechaEntrega
,datFechaColocacion
,intColorimetro
,intFolioPago
,intUrgente
,intLabExterno
,dblPrecio
,intPagado
,strObservaciones
,intEdad
,intSexo
,intConGarantia
,strImagen01
,strImagen02
,strImagen03
,strImagen04
,strImagen05
,strImagen06
,strImagen07
,strImagen08
,strImagen09
,strImagen10
,strImagen11
,strImagen12
,strImagen13
,strImagen14
,strImagen15
,strImagen16
,strImagen17
,strImagen18
,strImagen19
,strImagen20
,intColor
,intFactura
,intEstatusProceso
,intSolicitudFacturaDet
,intFacturaEnc_Pertenece
,isActivo
,isBorrado
,datFechaAlta
,strUsuarioAlta
,strMaquinaAlta
,datFechaMod
,strUsuarioMod
,strMaquinaMod
,intOrdenLaboratorioEnc__RESPALDO)
SELECT
 intFolio
,intClinica
,intDoctor
,strNombrePaciente
,intExpediente
,intTipoProtesis
,intPieza
,intProceso
,intTipoTrabajo
,strColor
,strComentario
,intEstatus
,intCajaAlmacenamiento
,datFechaEntrega
,datFechaColocacion
,intColorimetro
,intFolioPago
,intUrgente
,intLabExterno
,dblPrecio
,intPagado
,strObservaciones
,intEdad
,intSexo
,intConGarantia
,strImagen01
,strImagen02
,strImagen03
,strImagen04
,strImagen05
,strImagen06
,strImagen07
,strImagen08
,strImagen09
,strImagen10
,strImagen11
,strImagen12
,strImagen13
,strImagen14
,strImagen15
,strImagen16
,strImagen17
,strImagen18
,strImagen19
,strImagen20
,intColor
,intFactura
,intEstatusProceso
,intSolicitudFacturaDet
,intFacturaEnc_Pertenece
,isActivo	 = 1
,isBorrado	 = 0
,datFechaAlta
,strUsuarioAlta
,strMaquinaAlta
,datFechaMod
,strUsuarioMod
,strMaquinaMod
,intOrdenLaboratorioEnc
FROM LabAllCeramic.dbo.tbOrdenLaboratorioEnc



SELECT intOrdenLaboratorioEnc,intOrdenLaboratorioEnc__RESPALDO,* FROM tbOrdenLaboratorioEnc
GO

INSERT tbOrdenLaboratorioDet(
 intOrdenLaboratorioDet
,intOrdenLaboratorioEnc
,intPieza
,intMaterial
,intTipoTrabajo
,strColor
,intLabPredeterminado
,dblPrecioLab
,intCantidad
,isActivo
,isBorrado
,strUsuarioAlta
,strMaquinaAlta
,datFechaAlta
,strUsuarioMod
,strMaquinaMod
,datFechaMod)
SELECT 
 DET.intOrdenLaboratorioDet
,ENC.intOrdenLaboratorioEnc
,DET.intPieza
,DET.intMaterial
,DET.intTipoTrabajo
,DET.strColor
,DET.intLabPredeterminado
,DET.dblPrecioLab
,DET.intCantidad
,isActivo	   =1
,isBorrado	   = 0
,DET.strUsuarioAlta
,DET.strMaquinaAlta
,DET.datFechaAlta
,DET.strUsuarioMod
,DET.strMaquinaMod
,DET.datFechaMod
FROM LabAllCeramic.dbo.tbOrdenLaboratorioDet	AS DET WITH(NOLOCK)
	JOIN tbOrdenLaboratorioENC					AS ENC WITH(NOLOCK) ON DET.intOrdenLaboratorioEnc = ENC.intOrdenLaboratorioEnc__RESPALDO


SELECT * FROM tbOrdenLaboratorioDet
GO



/*

*/

