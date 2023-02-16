--CREATE DATABASE Dev1
go


USE Dev1
go


go
CREATE PROCEDURE Busca      
(      
@Buscar VarChar(4000),  
@strOrden VARCHAR(10) =  NULL    
)      
AS  
BEGIN  
	SET NOCOUNT ON       
	SELECT DISTINCT idObjeto=sc.ID, nomObjeto=OBJECT_NAME(sc.ID)  
	INTO #Result  
	FROM sysComments sc      
	WHERE sc.Text Like '%' + @Buscar + '%'  
  
	IF @strOrden IS NULL  
	BEGIN  
		SELECT O.idObjeto, O.nomObjeto, Creado=SYS.create_date, Modificado=SYS.modify_date  
		FROM #Result AS O, sys.all_objects AS SYS  
		WHERE SYS.object_id=O.idObjeto  
		ORDER BY O.idObjeto ASC  
	END  
	ELSE  
	BEGIN  
		IF @strOrden = 'M'  
		BEGIN  
			SELECT O.idObjeto, O.nomObjeto, Creado=SYS.create_date, Modificado=SYS.modify_date  
			FROM #Result AS O, sys.all_objects AS SYS  
			WHERE SYS.object_id=O.idObjeto  
			ORDER BY SYS.modify_date DESC  
		END  
		IF @strOrden = 'C'  
		BEGIN  
			SELECT O.idObjeto, O.nomObjeto, Creado=SYS.create_date, Modificado=SYS.modify_date  
			FROM #Result AS O, sys.all_objects AS SYS  
			WHERE SYS.object_id=O.idObjeto  
			ORDER BY SYS.create_date DESC  
		END  
		IF @strOrden = 'N'  
		BEGIN  
			SELECT O.idObjeto, O.nomObjeto, Creado=SYS.create_date, Modificado=SYS.modify_date  
			FROM #Result AS O, sys.all_objects AS SYS  
			WHERE SYS.object_id=O.idObjeto  
			ORDER BY O.nomObjeto ASC  
		END  
	END  
END
go



go
CREATE PROCEDURE BuscaTablas
(      
@Buscar VarChar(4000),  
@strOrden VARCHAR(10) =  NULL    
)      
AS  
BEGIN  
	SET NOCOUNT ON
	
	SELECT 
		ID=OBJ.object_id,
		Tabla=INF.TABLE_NAME,
		Creada=OBJ.create_date,
		Modificada=OBJ.modify_date,
		SELECCION = 'SELECT TOP 100 Tabla='''+INF.TABLE_NAME+''', * FROM '+INF.TABLE_NAME+' WITH (NOLOCK)'
	INTO #Result  
	FROM Information_Schema.Tables AS INF
		INNER JOIN sys.objects AS OBJ ON OBJ.name = INF.TABLE_NAME
	WHERE INF.table_type = 'BASE TABLE' 
		AND INF.TABLE_NAME LIKE '%' + @Buscar + '%' 
   
	IF @strOrden IS NULL  
	BEGIN
		SELECT R.ID, R.Tabla, R.Creada, R.Modificada, R.SELECCION
		FROM #Result AS R
		ORDER BY R.ID
	END  
	ELSE  
	BEGIN  
		IF @strOrden = 'M'  
		BEGIN
			SELECT R.ID, R.Tabla, R.Creada, R.Modificada, R.SELECCION
			FROM #Result AS R
			ORDER BY R.Modificada DESC
		END  
		IF @strOrden = 'C'  
		BEGIN  
			SELECT R.ID, R.Tabla, R.Creada, R.Modificada, R.SELECCION
			FROM #Result AS R
			ORDER BY R.Creada DESC
		END  
		IF @strOrden = 'N'  
		BEGIN
			SELECT R.ID, R.Tabla, R.Creada, R.Modificada, R.SELECCION
			FROM #Result AS R
			ORDER BY R.Tabla DESC
		END  
	END  
END
go





IF EXISTS(SELECT * FROM sysobjects WHERE type = 'U' AND name ='tbRoles')
BEGIN
   DROP TABLE tbRoles;
END
IF EXISTS(SELECT * FROM sysobjects WHERE type = 'U' AND name ='segUsuarios')
BEGIN
   DROP TABLE segUsuarios;
END
IF EXISTS(SELECT * FROM sysobjects WHERE type = 'U' AND name ='tbMenuDtl')
BEGIN
	DROP TABLE tbMenuDtl 
END
IF EXISTS(SELECT * FROM sysobjects WHERE type = 'U' AND name ='tbMenu')
BEGIN
   DROP TABLE tbMenu;
END
 



CREATE TABLE [dbo].[tbMenu](
	[intMenu] [int] IDENTITY(1,1) NOT NULL,
	[strDescripcion] [varchar](80) NULL,
	[Vista] [varchar](50) NULL,
	[Controlador] [varchar](50) NULL,
	[Parametro] [varchar](150) NULL,
	[Nivel] [int] NULL,
	[IsNodo] [bit] NULL,
	[strIcono] [varchar](50) NULL,
	[IsActivo] [bit] NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL
) ON [PRIMARY]
GO

alter TABLE [tbMenu] add CONSTRAINT [PK_tbMenu] PRIMARY KEY CLUSTERED 
(
	[intMenu] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]


INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Inicio','Index','Home','', 1, 0,'fas fa-home',1, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Catálogos',NULL,NULL,'', 1, 1,'icon-notebook',1, 'JORGE', '127.0.0.1',GETDATE() 
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Salir','LogOff','Account','', 1, 0,'fas fa-power-off',1, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Roles','Rol','Rol','', 2, 0,NULL,1, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Empleados','Empleado','Empleado','', 2, 0,NULL,1, 'JORGE', '127.0.0.1',GETDATE()  
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Opciones',NULL,NULL,'', 1, 1,'icon-notebook',1, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Captura de Movimientos','Movimiento','Movimiento','', 2, 0,NULL,1, 'JORGE', '127.0.0.1',GETDATE() 
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Acerca de nosotros','Contact','Home','', 2, 0,NULL,1, 'JORGE', '127.0.0.1',GETDATE()   
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Reportes',NULL,NULL,'', 1, 1,'fas fa-cogs fa-fw',1, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Reporte de Pagos','ReportePagos','ReportePagos','', 2, 0,NULL,1, 'JORGE', '127.0.0.1',GETDATE()   
INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Reporte 2','Empleado','Empleado','', 2, 0,NULL,1, 'JORGE', '127.0.0.1',GETDATE()   
   


SELECT * FROM tbMenu




CREATE TABLE [dbo].[tbMenuDtl](
	[intMenuDtl] [int] IDENTITY(1,1) NOT NULL,
	[intMenu] [int] NULL,
	[intRol] [int] NULL,
	[subMenu] [int] NULL,
	[intOrden] [int] NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL
) ON [PRIMARY]
GO


--Agregar una llave foranea referenciada
ALTER TABLE [dbo].[tbMenuDtl]  WITH CHECK ADD  CONSTRAINT [FK_tbMenuDtl_tbMenu] FOREIGN KEY([intMenu])
REFERENCES [dbo].[tbMenu] ([intMenu])
--y luego la activamos
ALTER TABLE [dbo].[tbMenuDtl] CHECK CONSTRAINT [FK_tbMenuDtl_tbMenu]




INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1,1,0,5, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2,1,0,10, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 6,1,0,15, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 9,1,0,20, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3,1,0,25, 'JORGE', '127.0.0.1',GETDATE()

INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4,1,2,5, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 5,1,2,10, 'JORGE', '127.0.0.1',GETDATE()

INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 7,1,6,5, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 8,1,6,10, 'JORGE', '127.0.0.1',GETDATE()

INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 10,1,9,5, 'JORGE', '127.0.0.1',GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intorden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 11,1,9,10, 'JORGE', '127.0.0.1',GETDATE()

SELECT * FROM tbMenuDtl


CREATE TABLE [dbo].[tbRoles](
	[intRol] [int] IDENTITY(1,1) NOT NULL,
	[strNombre] [nvarchar](100) NOT NULL,
	[isAdministrativo] BIT NOT NULL,
	[isOperativo] BIT NOT NULL,
	[isActivo] BIT NULL,
	[IsBorrado] BIT NOT NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbRoles] UNIQUE NONCLUSTERED 
(
	[intRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


INSERT tbRoles(strNombre, isAdministrativo, isOperativo,strUsuarioAlta,strMaquinaAlta,datFechaAlta,isActivo,IsBorrado)
SELECT 'SISTEMAS', 1, 0, 'JORGE', '127.0.0.1',GETDATE(), 1, 0
go
INSERT tbRoles(strNombre, isAdministrativo, isOperativo,strUsuarioAlta,strMaquinaAlta,datFechaAlta,isActivo,IsBorrado)
SELECT 'CHOFER', 0, 1, 'JORGE', '127.0.0.1',GETDATE(), 1, 0
go
INSERT tbRoles(strNombre, isAdministrativo, isOperativo,strUsuarioAlta,strMaquinaAlta,datFechaAlta,isActivo,IsBorrado)
SELECT 'CARGADOR', 0, 1, 'JORGE', '127.0.0.1',GETDATE(), 1, 0
go
INSERT tbRoles(strNombre, isAdministrativo, isOperativo,strUsuarioAlta,strMaquinaAlta,datFechaAlta,isActivo,IsBorrado)
SELECT 'AUXILIAR', 0, 1, 'JORGE', '127.0.0.1',GETDATE(), 1, 0
go


SELECT * FROM tbRoles
go



CREATE TABLE [dbo].[segUsuarios](
	[intUsuario] [int] IDENTITY(1,1) NOT NULL,
	[strUsuario] [nvarchar](100) NOT NULL,
	[strNombreUsuario] [nvarchar](100) NOT NULL,
	[strPassword] [nvarchar](512) NOT NULL,
	[intRol] [int] NOT NULL,
	[isActivo] [bit] NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_segUsuarios] UNIQUE NONCLUSTERED 
(
	[strUsuario] ASC, 
	[strPassword] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[segUsuarios] ADD  DEFAULT ((0)) FOR [isActivo]
GO

INSERT segUsuarios(strUsuario,strNombreUsuario,strPassword, intRol, strUsuarioAlta,strMaquinaAlta,datFechaAlta,isActivo)
SELECT UPPER('mr-joc'), UPPER('Jorge Alberto Oviedo Cerda'), UPPER('c4l4b4z4'), 1, 'JORGE', '127.0.0.1',GETDATE(), 1


SELECT * FROM segUsuarios
go
