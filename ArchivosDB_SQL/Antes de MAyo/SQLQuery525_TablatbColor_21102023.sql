USE AllCeramic2024
GO

 /*
CREATE TABLE [dbo].[tbColor](
	[intColor] [int] NOT NULL IDENTITY(1, 1),
	[strNombre] [varchar](500) NULL,
	[intColorimetro] [int] NULL,
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


*/


/*
--INSERT tbColor(strNombre, intColorimetro, isActivo, isBorrado, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod)
SELECT 
strNombre, intColorimetro, isActivo = 1, isBorrado = 0, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod
FROM LabAllCeramic.dbo.tbColor WHERE intColor <= 35 ORDER BY intColor
*/

/*
--INSERT tbColor(strNombre, intColorimetro, isActivo, isBorrado, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod)
SELECT 
'REPATIDO_'+strNombre+'_NO USAR', intColorimetro, isActivo = 0, isBorrado = 0, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod
FROM LabAllCeramic.dbo.tbColor WHERE intColor = 35 ORDER BY intColor
*/


/*
--INSERT tbColor(strNombre, intColorimetro, isActivo, isBorrado, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod)
SELECT 
strNombre, intColorimetro, isActivo = 1, isBorrado = 0, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod
FROM LabAllCeramic.dbo.tbColor WHERE intColor >= 37 ORDER BY intColor
*/





SELECT * FROM tbColor


SELECT intColor,
strNombre, intColorimetro, isActivo = 1, isBorrado = 0, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod
FROM LabAllCeramic.dbo.tbColor ORDER BY intColor



--INSERT tbMenu(strDescripcion,Vista, Controlador, Parametro, Nivel, IsNodo, strIcono, IsActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT strDescripcion='Colores',Vista='Color', Controlador='Color', Parametro, Nivel, IsNodo, strIcono, IsActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta=GETDATE()
FROM tbMenu WHERE intMenu = 27

SELECT IDENT_CURRENT=IDENT_CURRENT('tbMenu')

--INSERT tbMenuDtl(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT 
intMenu=89, intRol, subMenu, intOrden=10, strUsuarioAlta, strMaquinaAlta, datFechaAlta=GETDATE()
FROM tbMenuDtl    WHERE intMenu = 27 AND intRol IN (1,2)


SELECT * FROM tbMenu WHERE intMenu = 89
SELECT * FROM tbMenuDtl    WHERE intMenu = 89
go

