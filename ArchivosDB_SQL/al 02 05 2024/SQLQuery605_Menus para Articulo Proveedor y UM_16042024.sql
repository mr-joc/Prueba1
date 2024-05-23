USE LabAllCeramic
go

UPDATE  tbMenu2024 SET strDescripcion = 'Artículo',Vista = 'Articulo',Controlador = 'Articulo'  where intMenu = 6655


--INSERT tbMenu2024(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select strDescripcion='Unidades de Medida',Vista = 'UnidadMedida',Controlador = 'UnidadMedida',Parametro,Nivel,IsNodo,strIcono,IsActivo,
	strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE()
from tbMenu2024 where intMenu = 6655

--INSERT tbMenu2024(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select strDescripcion='Proveedores',Vista = 'Proveedor',Controlador = 'Proveedor',Parametro,Nivel,IsNodo,strIcono,IsActivo,
	strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE()
from tbMenu2024 where intMenu = 6655


--INSERT tbMenu2024(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select strDescripcion='Operaciones',Vista = 'Operacion',Controlador = 'Operacion',Parametro,Nivel,IsNodo,strIcono,IsActivo,
	strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE()
from tbMenu2024 where intMenu = 6655


SELECT LastID=IDENT_CURRENT('tbMenu2024')


-- INSERT tbMenuDtl2024(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select 
intMenu=6658,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta =GETDATE()
from tbMenuDtl2024 where intMenu IN (6655, 6655)


-- INSERT tbMenuDtl2024(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select 
intMenu=6659,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta =GETDATE()
from tbMenuDtl2024 where intMenu IN (6655, 6655)



-- INSERT tbMenuDtl2024(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select 
intMenu=6660,intRol,subMenu,intOrden=intOrden*2,strUsuarioAlta,strMaquinaAlta,datFechaAlta =GETDATE()
from tbMenuDtl2024 where intMenu IN (6655, 6655)




select * from tbMenu2024 where intMenu IN (6658, 6655, 6659)
select * from tbMenuDtl2024 where intMenu IN (6658, 6655, 6659)

----