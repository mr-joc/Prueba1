USE LabAllCeramic
go

SELECT * FROM tbMenu2024 where Nivel =3 and intMenu = 51

--INSERT tbMenu2024(strDescripcion,Vista,Controlador,Parametro,Nivel,IsNodo,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
SELECT strDescripcion='Administrar Órdenes',Vista='adminOrdenLab',Controlador='OrdenLaboratorio',
	Parametro,Nivel,IsNodo,IsActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE()
FROM tbMenu2024 where Nivel =3 and intMenu = 51
 
 /*
SELECT * FROM tbMenu2024 order by intMenu    
 select IDENt= IDENT_CURRENT('tbMenu2024')

*/

6653
--INSERT tbMenuDtl2024(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
select 
intMenu=6653,intRol,subMenu,intOrden=intOrden+5,strUsuarioAlta,strMaquinaAlta,datFechaAlta=GETDATE()
FROM tbMenuDtl2024 where intMenu = 51 and intRol IN (1,2)
