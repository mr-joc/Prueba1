USE LabAllCeramic
go


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--INSERT tbMenu2024(strDescripcion,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select strDescripcion,Parametro,Nivel,IsNodo,strIcono='icon-note',IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta
from tbMenu2024 where Nivel=1 AND intMenu =	3 --

UPDATE tbMenu2024 SET strDescripcion='Inventario' where intMenu=6654

select nuevoid=IDENT_CURRENT('tbMenu2024')--6654

--INSERT tbMenuDtl2024(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT intMenu=6654, intRol=1, subMenu, intOrden=3, strUsuarioAlta, strMaquinaAlta, datFechaAlta=GETDATE()
FROM tbMenuDtl2024
where intMenu IN (3) and intRol=1 Order by intOrden


--INSERT tbMenuDtl2024(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT intMenu, intRol=2, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta=GETDATE()
FROM tbMenuDtl2024 WHERE intMenu = 6654 and intRol = 1

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT tbMenu2024(strDescripcion,Vista,controlador,Parametro,Nivel,IsNodo,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select strDescripcion='Operaciones',Vista = 'Operaciones',controlador='Operacion',Parametro,Nivel,IsNodo,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE()
from tbMenu2024 where Nivel=2  and intMenu=14



select nuevoid=IDENT_CURRENT('tbMenu2024') --6655


--INSERT tbMenuDtl2024(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT intMenu=6655,intRol,subMenu=6654,intOrden=5,strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE() 
FROm tbMenuDtl2024 where intMenu IN (14) and intRol=1 Order by intOrden


--INSERT tbMenuDtl2024(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT intMenu=6655,intRol=2,subMenu=6654,intOrden=5,strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE() 
FROm tbMenuDtl2024 where intMenu =6655 and intRol = 1





---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ahora El registro de Operaciones
--select * from allceramic2024.dbo.tbmenu

--INSERT tbMenu2024(strDescripcion,Parametro,Nivel,IsNodo,strIcono,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select strDescripcion='Producción',Parametro,Nivel,IsNodo,strIcono='fas fa-cog',IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE()
from tbMenu2024 where Nivel=1 AND intMenu =	3 --

UPDATE tbMenu2024 SET strDescripcion='Producción' where intMenu=6656

select nuevoid=IDENT_CURRENT('tbMenu2024')--6656

--INSERT tbMenuDtl2024(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT intMenu=6656, intRol=1, subMenu, intOrden=8, strUsuarioAlta, strMaquinaAlta, datFechaAlta=GETDATE()
FROM tbMenuDtl2024
where intMenu IN (3) and intRol=1 Order by intOrden


--INSERT tbMenuDtl2024(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT intMenu, intRol=2, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta=GETDATE()
FROM tbMenuDtl2024 WHERE intMenu = 6656 and intRol = 1

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT tbMenu2024(strDescripcion,Vista,controlador,Parametro,Nivel,IsNodo,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select strDescripcion='Yesos',Vista = 'YesoOeracion',controlador='Production',Parametro,Nivel,IsNodo,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE()
from tbMenu2024 where Nivel=2  and intMenu=14



select nuevoid=IDENT_CURRENT('tbMenu2024') --6657


--INSERT tbMenuDtl2024(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT intMenu=6657,intRol,subMenu=6656,intOrden=5,strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE() 
FROm tbMenuDtl2024 where intMenu IN (14) and intRol=1 Order by intOrden


--INSERT tbMenuDtl2024(intMenu, intRol, subMenu, intOrden, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT intMenu=6657,intRol=2,subMenu=6654,intOrden=5,strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE() 
FROm tbMenuDtl2024 where intMenu =6657 and intRol = 1





---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

