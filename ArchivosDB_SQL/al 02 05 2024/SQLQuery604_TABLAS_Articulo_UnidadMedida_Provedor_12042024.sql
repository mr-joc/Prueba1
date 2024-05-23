USE LabAllCeramic
go

--
/*

 DROP TABLE tbUnidadMedida2024

CREATE TABLE [dbo].[tbUnidadMedida2024](
	[intUnidadMedida] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [Unique_tbUnidadMedida2024] UNIQUE NONCLUSTERED 
(
	[intUnidadMedida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


SELECT * FROM tbUnidadMedida2024

--

*/



 DROP TABLE tbProveedor2024

CREATE TABLE [dbo].[tbProveedor2024](
	[intProveedor] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [Unique_tbProveedor2024] UNIQUE NONCLUSTERED 
(
	[intProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--INSERT tbProveedor2024(strNombre,strNombreCorto,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
--SELECT strNombre = 'PROVEEDOR SIN NOMBRE',strNombreCorto = 'PROV1' ,isActivo = 1,isBorrado = 0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()

--SELECT * FROM tbProveedor2024



SELECT * FROM tbUnidadMedida2024


 DROP TABLE tbArticulo2024

CREATE TABLE [dbo].[tbArticulo2024](
	[intArticulo] [int] IDENTITY(1,1) NOT NULL,
	[PartNum] [varchar](150) NULL,
	[PartDesc] [varchar](500) NULL,
	[intUnidadMedidaCompra] [int] NOT NULL,
	[dblConversionCompraAlmacen] [NUMERIC](18, 4) NOT NULL,
	[intUnidadMedidaAlmacen] [int] NOT NULL,
	[dblConversionAlmacenVenta] [NUMERIC](18, 4) NOT NULL,
	[intUnidadMedidaVenta] [int] NOT NULL,	
	[intProveedorBase] [int] NOT NULL,	
	[isActivo] [bit] NULL,
	[isBorrado] [bit] NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbArticulo2024] UNIQUE NONCLUSTERED 
(
	[intArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'YS5','Yeso tipo 5',	10,	8	,11, 2000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'YSP','Yeso Piedra',	10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'SIL','Silicon',		10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'CUE','Cueles',			10,	20	,2,		1, 1,2,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'REV','Revestimento',	10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'CERA','Cera',			10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'CEP','Ceparador',		10,	20	,2,     1, 1,2,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'MET01','Metal',		10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'OXI01','Oxido',		10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
 

INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'PW','Porcelana para wash',		10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE() 
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'GL','Glass',		10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'PCP','Porcelana por capas',		10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'DENT','Dentina',		10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'ESM','Esmalte',		10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'TRSL','Traslucido',		10,	3	,12, 1000, 5,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()
INSERT tbArticulo2024(PartNum, PartDesc, intUnidadMedidaCompra, dblConversionCompraAlmacen, intUnidadMedidaAlmacen, dblConversionAlmacenVenta, intUnidadMedidaVenta, intProveedorBase, isActivo, isBorrado, strUsuarioAlta,strMaquinaAlta, datFechaAlta) SELECT 'AG','AGUA DESTILADA',		3,	1	,3, 1000, 4,1,1,0,strUsuarioAlta ='MR-JOC', strMaquinaAlta = '127.0.0.1', datFechaAlta =GETDATE()


SELECT * FROM tbArticulo2024
