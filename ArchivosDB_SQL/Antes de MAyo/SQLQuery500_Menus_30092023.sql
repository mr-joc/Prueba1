USE AllCeramic2024
go

ALTER TABLE tbMenu ADD intRespMEnu int
update tbMenu set  intRespMEnu  = intMenu*100

SELECT * from ERPWeb.dbo.tbMenu

INSERT tbMenu(strDescripcion, Vista, Controlador, Parametro, Nivel, IsNodo, strIcono, IsActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta, intRespMEnu)
SELECT Descripcion, Viewer, Controller, Parametro, Nivel, IsNode, Icon, IsActivo, strUsuarioAlta = 'MR-JOC', strMaquinaAlta='127.0.0.1', datFechaAlta=GETDATE(), IDMenu 
FROM ERPWeb.dbo.tbMenu
WHERE IDMenu <= 88 
ORDER BY IDMenu


--INSERT tbMenuDtl(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT DT2.IDMenu, intRol = 1, DT2.subMenu, DT2.orden, strUsuarioAlta = 'MR-JOC', strMaquinaAlta='127.0.0.1', datFechaAlta=GETDATE()
FROM ERPWeb.dbo.tbMenuDtl	AS  DT2
WHERE DT2.IDRol = 1
	AND DT2.IDMenu  <= 88 


	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM tbMenuDtl WHERE intMenu IN (79,87,88,88)
DELETE FROM tbMenu WHERE intMenu IN (79,87,88,88)

UPDATE tbMenu SET strDescripcion = 'Nosotros', Vista = 'About', Controlador ='Home', IsNodo =0, strIcono = 'icon-notebook' where nivel = 1 AND intMenu = 78

select * from tbMenu    where nivel = 1 AND intMenu = 78



DELETE FROM tbMenuDtl	WHERE intMenu IN (4, 18, 15)
DELETE FROM tbMenu		WHERE intMenu IN (4, 18, 15)


UPDATE tbMenu SET strDescripcion = 'Cambiar Password', Vista = 'PassRenew', Controlador ='Sesion' where intMenu = 14

UPDATE tbMenu SET strDescripcion = 'Sesión' where intMenu = 3



DELETE FROM tbMenuDtl	WHERE intMenu IN (72, 73,8,10,9,21,11,12,17)
DELETE FROM tbMenu		WHERE intMenu IN (72, 73,8,10,9,21,11,12,17)



UPDATE tbMenu SET strDescripcion = 'Seguridad', strIcono = 'icon-lock' where intMenu = 2

UPDATE tbMenu SET strDescripcion = 'Administrar Perfiles', Vista='Rol', Controlador = 'Rol' where intMenu = 13
UPDATE tbMenu SET strDescripcion = 'Administrar Usuarios', Vista='Usuario', Controlador = 'Usuario' where intMenu = 6
UPDATE tbMenu SET strDescripcion = 'Administrar Permisos', strIcono = 'icon-lock' where intMenu = 7




DELETE FROM tbMenuDtl	WHERE intMenu IN (19, 74,23,75,77,24,22,20)
DELETE FROM tbMenu		WHERE intMenu IN (19, 74,23,75,77,24,22,20)

UPDATE tbMenu SET strDescripcion = 'Principal' where intMenu = 25




DELETE FROM tbMenuDtl	WHERE intMenu IN (53,54,55,85,35,82,34,83,84,36,37,56,57,81,86)
DELETE FROM tbMenu		WHERE intMenu IN (53,54,55,85,35,82,34,83,84,36,37,56,57,81,86)


UPDATE tbMenu SET strDescripcion = 'Catálogos' where intMenu = 26
UPDATE tbMenu SET strDescripcion = 'Opciones' where intMenu = 50
UPDATE tbMenu SET strDescripcion = 'Reportes' where intMenu = 52



DELETE FROM tbMenuDtl	WHERE intMenu IN (71,63,59,33,39,80,40,41,42,43,44,45,47,49,67,69,69)
DELETE FROM tbMenu		WHERE intMenu IN (71,63,59,33,39,80,40,41,42,43,44,45,47,49,67,69,69)


UPDATE tbMenu SET strDescripcion = 'Materiales' where intMenu = 27
UPDATE tbMenu SET strDescripcion = 'Tipos de Trabajo' where intMenu = 28
UPDATE tbMenu SET strDescripcion = 'Doctores' where intMenu = 65
UPDATE tbMenu SET strDescripcion = 'Colorímetros' where intMenu = 30
UPDATE tbMenu SET strDescripcion = 'Tipos de Gasto' where intMenu = 48
UPDATE tbMenu SET strDescripcion = 'Orden de Trabajo' where intMenu = 51
UPDATE tbMenu SET strDescripcion = 'Orden de Trabajo' where intMenu = 51
UPDATE tbMenu SET strDescripcion = 'Cuentas por Cobrar' where intMenu = 29
UPDATE tbMenu SET strDescripcion = 'Reporte de Pagos' where intMenu = 32
UPDATE tbMenu SET strDescripcion = 'Materiales y Trabajos' where intMenu = 64





select * from segUsuarios
select * from tbRoles


sp_GetMenuByRol 1
	 
                                                    
