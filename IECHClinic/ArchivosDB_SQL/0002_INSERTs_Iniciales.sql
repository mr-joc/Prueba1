USE IECHClinic
go



INSERT segUsuarios(strUsuario,strNombreUsuario,strPassword,intRol,isActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strNombre,strApPaterno,strApMaterno,IsBorrado)	SELECT 'MR-JOC', 'JORGE ALBERTO OVIEDO CERDA','c4l4b4z4',1,1,'JORGE','127.0.0.1', GETDATE(),'JORGE ALBERTO','OVIEDO','CERDA',0
INSERT segUsuarios(strUsuario,strNombreUsuario,strPassword,intRol,isActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strNombre,strApPaterno,strApMaterno,IsBorrado)	SELECT 'NORMA', 'NORMA ORTIZ','NORTIZ',2,1,'JORGE','127.0.0.1', GETDATE(),'NORMA','ORTIZ','.',0


SELECT * FROM segUsuarios


INSERT tbMenu(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta) 
SELECT TOP 10000 'xxx','xxx','xxx','xxx',0,0,'xxx',0,'MR-JOC','127.0.0.1',GETDATE()
FROM LabAllCeramic.dbo.tbOrdenLaboratorioEnc
go

UPDATE tbMenu SET strDescripcion ='Inicio', Vista = 'Index', Controlador= 'Home', Parametro = '', Nivel = 1, IsNodo = 0, strIcono = 'fas fa-home', IsActivo = 1WHERE intMEnu = 1
UPDATE tbMenu SET strDescripcion ='Seguridad', Vista = 'NULL', Controlador= 'NULL', Parametro = '', Nivel = 1, IsNodo = 1, strIcono = 'icon-lock', IsActivo = 1WHERE intMEnu = 2
UPDATE tbMenu SET strDescripcion ='Sesión', Vista = 'NULL', Controlador= 'NULL', Parametro = '', Nivel = 1, IsNodo = 1, strIcono = 'icon-social-dropbox', IsActivo = 1WHERE intMEnu = 3
UPDATE tbMenu SET strDescripcion ='Salir', Vista = 'LogOff', Controlador= 'Account', Parametro = '', Nivel = 1, IsNodo = 0, strIcono = 'fas fa-power-off', IsActivo = 1WHERE intMEnu = 5
UPDATE tbMenu SET strDescripcion ='Administrar Usuarios', Vista = 'Usuario', Controlador= 'Usuario', Parametro = '', Nivel = 2, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 6
UPDATE tbMenu SET strDescripcion ='Administrar Permisos', Vista = 'AdministrarMenu', Controlador= 'AdministrarMenu', Parametro = '', Nivel = 2, IsNodo = 0, strIcono = 'icon-lock', IsActivo = 1WHERE intMEnu = 7
UPDATE tbMenu SET strDescripcion ='Administrar Perfiles', Vista = 'Rol', Controlador= 'Rol', Parametro = '', Nivel = 2, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 13
UPDATE tbMenu SET strDescripcion ='Cambiar Contraseña', Vista = 'CambiarPassWord', Controlador= 'Usuario', Parametro = '', Nivel = 2, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 14
UPDATE tbMenu SET strDescripcion ='Impresión de Etiquetas', Vista = 'ImpresionEtiquetas', Controlador= 'Operacion', Parametro = '', Nivel = 2, IsNodo = 0, strIcono = 'NULL', IsActivo = 0WHERE intMEnu = 16
UPDATE tbMenu SET strDescripcion ='Principal', Vista = 'NULL', Controlador= 'NULL', Parametro = '', Nivel = 1, IsNodo = 1, strIcono = 'icon-note', IsActivo = 1WHERE intMEnu = 25
UPDATE tbMenu SET strDescripcion ='Catálogos', Vista = 'NULL', Controlador= 'NULL', Parametro = '', Nivel = 2, IsNodo = 1, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 26
UPDATE tbMenu SET strDescripcion ='Materiales', Vista = 'Material', Controlador= 'Material', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 27
UPDATE tbMenu SET strDescripcion ='Tipos de Trabajo', Vista = 'TipoTrabajo', Controlador= 'TipoTrabajo', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 28
UPDATE tbMenu SET strDescripcion ='Cuentas por Cobrar', Vista = 'SubirOrdenCompra', Controlador= 'Inventario', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 29
UPDATE tbMenu SET strDescripcion ='Colorímetros', Vista = 'Colorimetro', Controlador= 'Colorimetro', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 30
UPDATE tbMenu SET strDescripcion ='Reporte de Pagos', Vista = 'IngresoArticulo', Controlador= 'Inventario', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 32
UPDATE tbMenu SET strDescripcion ='Transferencias', Vista = 'Crear', Controlador= 'Transferencias', Parametro = 'NULL', Nivel = 3, IsNodo = 0, strIcono = 'NULL', IsActivo = 0WHERE intMEnu = 38
UPDATE tbMenu SET strDescripcion ='Tipos de Gasto', Vista = 'TipoGasto', Controlador= 'TipoGasto', Parametro = 'NULL', Nivel = 3, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 48
UPDATE tbMenu SET strDescripcion ='Opciones', Vista = 'NULL', Controlador= 'NULL', Parametro = '', Nivel = 2, IsNodo = 1, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 50
UPDATE tbMenu SET strDescripcion ='Orden de Trabajo', Vista = 'Index', Controlador= 'OrdenCompra', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 51
UPDATE tbMenu SET strDescripcion ='Reportes', Vista = 'NULL', Controlador= 'NULL', Parametro = 'NULL', Nivel = 2, IsNodo = 1, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 52
UPDATE tbMenu SET strDescripcion ='Entrada Miscelánea', Vista = 'EntradaMiscelanea', Controlador= 'Transferencias', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = '', IsActivo = 0WHERE intMEnu = 60
UPDATE tbMenu SET strDescripcion ='Consumos', Vista = 'Crear', Controlador= 'Consumos', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = '', IsActivo = 0WHERE intMEnu = 61
UPDATE tbMenu SET strDescripcion ='Materiales y Trabajos', Vista = 'Index', Controlador= 'Packing', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = '', IsActivo = 1WHERE intMEnu = 64
UPDATE tbMenu SET strDescripcion ='Doctores', Vista = 'Doctor', Controlador= 'Doctor', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = '', IsActivo = 1WHERE intMEnu = 65
UPDATE tbMenu SET strDescripcion ='Ajuste Inventario', Vista = 'AjusteInventario', Controlador= 'Transferencias', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = '', IsActivo = 0WHERE intMEnu = 68
UPDATE tbMenu SET strDescripcion ='Mover Jobs (Sincronía)', Vista = 'AsignarJobsSincronia', Controlador= 'Production', Parametro = '', Nivel = 2, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 76
UPDATE tbMenu SET strDescripcion ='Nosotros', Vista = 'About', Controlador= 'Home', Parametro = '', Nivel = 1, IsNodo = 0, strIcono = 'icon-notebook', IsActivo = 1WHERE intMEnu = 78
UPDATE tbMenu SET strDescripcion ='Colores', Vista = 'Color', Controlador= 'Color', Parametro = '', Nivel = 3, IsNodo = 0, strIcono = 'NULL', IsActivo = 1WHERE intMEnu = 89
go

UPDATE tbMenu SET  strDescripcion = NULL WHERE strDescripcion  = 'NULL'
UPDATE tbMenu SET  Vista = NULL WHERE Vista  = 'NULL'
UPDATE tbMenu SET  Controlador = NULL WHERE Controlador  = 'NULL'
UPDATE tbMenu SET  Parametro = NULL WHERE Parametro  = 'NULL'
UPDATE tbMenu SET  strIcono = NULL WHERE strIcono  = 'NULL'
UPDATE tbMenu SET  strUsuarioAlta = NULL WHERE strUsuarioAlta  = 'NULL'
UPDATE tbMenu SET  strMaquinaAlta = NULL WHERE strMaquinaAlta  = 'NULL'
go


UPDATE tbMenu SET strDescripcion ='Orden de Trabajo', Vista = 'OrdenLaboratorio', Controlador= 'OrdenLaboratorio' WHERE intMEnu = 51

--
DELETE FROM tbMenu WHERE strDescripcion = 'xxx' AND Vista = 'xxx'  AND Controlador = 'xxx' 
go


INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1,1, 0, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2,1, 0, 20, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3,1, 0, 25, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 5,1, 0, 35, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 6,1, 2, 100, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 7,1, 2, 101, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 13,1, 2, 21, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 14,1, 3, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 16,1, 4, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,1, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,1, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 27,1, 26, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 28,1, 26, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 29,1, 52, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 30,1, 26, 4, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 32,1, 52, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 38,1, 55, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 48,1, 26, 5, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 60,1, 55, 4, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 61,1, 55, 5, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 64,1, 52, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 65,1, 26, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 68,1, 55, 6, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 50,1, 25, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 51,1, 50, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 52,1, 25, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 78,1, 0, 34, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 50,2, 25, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 51,2, 50, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 50,2, 25, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 51,2, 50, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,4, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 50,4, 25, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 51,4, 50, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,2, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 48,2, 26, 5, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1,2, 0, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 5,2, 0, 35, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,2, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 27,2, 26, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,2, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 28,2, 26, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,2, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 65,2, 26, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3,2, 0, 25, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 14,2, 3, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,2, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 30,2, 26, 4, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 29,2, 52, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 52,2, 25, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 32,2, 52, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 52,2, 25, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,2, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 52,2, 25, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 64,2, 52, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2,2, 0, 20, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 13,2, 2, 21, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2,2, 0, 20, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 6,2, 2, 100, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2,2, 0, 20, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 7,2, 2, 101, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 78,2, 0, 34, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,4, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 29,4, 52, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 52,4, 25, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,4, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 32,4, 52, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 52,4, 25, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,4, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 48,4, 26, 5, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 30,4, 26, 4, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,5, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3,5, 0, 25, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 14,5, 3, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 78,5, 0, 34, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 5,5, 0, 35, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 50,5, 25, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 51,5, 50, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,5, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 30,5, 26, 4, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 28,5, 26, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 27,5, 26, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 5,6, 0, 35, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1,6, 0, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,6, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,6, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 27,6, 26, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1,5, 0, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1,7, 0, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 5,7, 0, 35, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 78,7, 0, 34, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3,7, 0, 25, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 14,7, 3, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,7, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 64,7, 52, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 52,7, 25, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,7, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 30,7, 26, 4, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 89,1, 26, 10, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 89,2, 26, 10, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1,8, 0, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 5,8, 0, 35, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 78,8, 0, 34, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3,8, 0, 25, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 14,8, 3, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 25,8, 0, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 64,8, 52, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 52,8, 25, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 32,8, 52, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 29,8, 52, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 50,8, 25, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 51,8, 50, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 26,8, 25, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 89,8, 26, 10, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 48,8, 26, 5, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 30,8, 26, 4, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 65,8, 26, 3, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 28,8, 26, 2, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 27,8, 26, 1, 'MR-JOC', '127.0.0.1', GETDATE()
go



INSERT tbMenuXUsuario(InternalIDUser, IDMenu, IsActivo, btAgregar, strUsuarioAlta, strMaquinaAlta, datFechaAlta) SELECT 9, 27, 1, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuXUsuario(InternalIDUser, IDMenu, IsActivo, btAgregar, strUsuarioAlta, strMaquinaAlta, datFechaAlta) SELECT 9, 25, 1, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuXUsuario(InternalIDUser, IDMenu, IsActivo, btAgregar, strUsuarioAlta, strMaquinaAlta, datFechaAlta) SELECT 9, 26, 1, 1, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbMenuXUsuario(InternalIDUser, IDMenu, IsActivo, btAgregar, strUsuarioAlta, strMaquinaAlta, datFechaAlta) SELECT 9, 28, 1, 1, 'MR-JOC', '127.0.0.1', GETDATE()
go


INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Plan ERP', 'Conoce el documento inicial de Produccion','https://configurador.gacsa.online/Produccion/PlanERP.pdf','fab fa-twitter fa-2x text-info',1, GETDATE(), '2023-01-02','2052-12-31'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Prueba 2.1', 'Es aviso y no tenemos Documento a mostrar 1','NULL','fa fa-envelope fa-2x text-warning',3, GETDATE(), '2023-01-02','2023-01-04'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Prueba 2.2', 'Es aviso y no tenemos Documento a mostrar 2','NULL','fa fa-tasks fa-2x text-success',3, GETDATE(), '2023-01-02','2023-01-04'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Prueba 2.3', 'Es aviso y no tenemos Documento a mostrar 3','NULL','fa fa-tasks fa-2x text-success',3, GETDATE(), '2023-01-02','2023-01-04'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Prueba 3', 'Este solo es aviso y no tiene icono','NULL','NULL',4, GETDATE(), '2023-01-03','2023-01-15'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'otro Aviso', 'Este ya no esta vigente, solo debe verse el 03 de Enero','NULL','fas fa-id-badge',4, GETDATE(), '2023-01-02','2023-01-03'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Nueva línea agregada', 'CORTINERO-MOTORIZADA-NACIONAL','NULL','fa fa-envelope fa-2x text-success',1, GETDATE(), '2023-01-05','2023-01-05'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Nueva línea agregada', 'ENRO-MOTORIZADA-NACIONAL','NULL','fa fa-envelope fa-2x text-success',1, GETDATE(), '2023-01-05','2023-01-05'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Nueva línea agregada', 'ROMAN-MOTORIZADA-NACIONAL','NULL','fa fa-envelope fa-2x text-success',1, GETDATE(), '2023-01-05','2023-01-05'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Nueva línea agregada', 'SHEER-MOTORIZADA-NACIONAL','NULL','fa fa-envelope fa-2x text-success',1, GETDATE(), '2023-01-05','2023-01-05'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Nueva línea agregada', 'TOLDO-MANUAL-NACIONAL','NULL','fa fa-envelope fa-2x text-success',1, GETDATE(), '2023-01-05','2023-01-05'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Nueva línea agregada', 'TOLDO-MOTORIZADA-NACIONAL','NULL','fa fa-envelope fa-2x text-success',1, GETDATE(), '2023-01-05','2023-01-05'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Nueva línea agregada', 'CORTINERO-MOTORIZADA-NACIONAL<br/>Esta línea se agregó<br/>el día de hoy<br/>se prueban los saltos de línea<br/>Saludos','NULL','fa fa-envelope fa-2x text-success',1, GETDATE(), '2023-01-05','2023-01-10'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Generación de Guías', 'Revisa aquí el manual para la generación de guías','https://configurador.gacsa.online/Produccion/ManualGeneracionGuias.pdf','fa-2x mr-2 fas fa-book text-success',3, GETDATE(), '2023-01-30','2030-03-30'
INSERT tbNotificaciones(InternalID, RolID, strTitulo, strsubTitulo, strEnlace, strIcono, intOrden, datFechaAlta, datFechaInicia, datFechaVigencia) SELECT 1, 0, 'Guía Rápida', 'Ayuda a comprender el funcionamiento del sistema','https://configurador.gacsa.online/Produccion/GuiarapidaProduccion.pdf','fa-2x mr-2 fas fa-book text-success',5, GETDATE(), '2023-01-30','2030-03-30'
go


UPDATE tbNotificaciones  SET  strEnlace = NULL WHERE strEnlace  = 'NULL'
UPDATE tbNotificaciones  SET  strIcono = NULL WHERE strIcono  = 'NULL'
go


INSERT tbRoles(strNombre,isAdministrativo,isOperativo,isActivo,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'SISTEMAS', 1,0,1,0, 'MR-JOC', '127.0.0.1', GETDATE()
INSERT tbRoles(strNombre,isAdministrativo,isOperativo,isActivo,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 'Director General', 1,0,1,0, 'MR-JOC', '127.0.0.1', GETDATE()

go
 


SELECT * FROM segUsuarios
SELECT * FROM tbMenu 
SELECT * FROM tbMenuDtl 
SELECT * FROM tbMenuXUsuario 
SELECT * FROM tbNotificaciones 
SELECT * FROM tbRoles 



