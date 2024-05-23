USE AllCeramic2024
go


--SELECT * FROM tbRoles


--2

--INSERT tbmenuDTL (intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
----SELECT M.*, D.*
SELECT D.intMenu,intRol=2,D.subMenu,D.intOrden,D.strUsuarioAlta,D.strMaquinaAlta,datFechaAlta=GETDATE()
FROM tbMenu				AS M WITH(NOLOCK)
	JOIN tbMenuDtl		AS D WITH(NOLOCK) ON D.intMenu = M.intMenu
WHERE D.intRol = 1
AND M.intMenu IN (1, 3, 9, 10)

--INSERT segUsuarios(strUsuario,strNombreUsuario,strPassword,intRol,isActivo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
SELECT 'EMMA', 'EMMA SOFIA', 'emma',2 , 1, strUsuarioAlta,strMaquinaAlta,datFechaAlta
FROM segUsuarios WHERE intUsuario = 1


sp_GetMenuByRol 2