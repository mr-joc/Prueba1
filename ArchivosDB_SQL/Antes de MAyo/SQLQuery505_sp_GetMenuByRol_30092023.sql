USE AllCeramic2024
go


go
--sp_GetMenuByRol 1
alter PROCEDURE [dbo].[sp_GetMenuByRol]
	@IDRol int,
	@InternalIDUser int = NULL
AS
BEGIN
	DECLARE @PerfilSistemas INT = 1
	

	SELECT M.intMenu		AS [IDMenu]
		,M.strDescripcion	AS [Descripcion]
		,M.Parametro	AS [Parametro]
		,M.Vista		AS [ViewVista]
		,M.Controlador	AS [Controller]
		,D.intRol		AS [IDRol]
		,D.subMenu		AS [subMenu]
		,M.Nivel		AS [Nivel]
		,M.IsNodo		AS [IsNode]
		,D.intOrden		AS [orden]
		,M.strIcono			AS [Icon]
	INTO #MenuSistemasBase
	FROM tbMenu			AS M WITH(NOLOCK)
		JOIN tbMenuDtl	AS D WITH(NOLOCK) ON D.intMenu = M.intMenu
	WHERE D.intRol = @PerfilSistemas
		AND IsActivo = 1

	SELECT SIST.IDMenu, SIST.Descripcion, SIST.Parametro, SIST.ViewVista, SIST.Controller, SIST.IDRol, SIST.subMenu, SIST.Nivel, SIST.IsNode, SIST.orden, SIST.Icon
	INTO #MenuAgregado
	FROM #MenuSistemasBase	AS SIST WITH(NOLOCK)
		JOIN tbMenuXUsuario	AS  ME1 WITH(NOLOCK) ON ME1.IDMenu = SIST.IDMenu
	WHERE ME1.IsActivo = 1 AND btAgregar = 1
		AND ME1.InternalIDUser = @InternalIDUser

	SELECT M.intMenu		AS [IDMenu]
		,M.strDescripcion	AS [Descripcion]
		,M.Parametro		AS [Parametro]
		,M.Vista			AS [ViewVista]
		,M.Controlador		AS [Controller]
		,D.intRol			AS [IDRol]
		,D.subMenu			AS [subMenu]
		,M.Nivel			AS [Nivel]
		,M.IsNodo			AS [IsNode]
		,D.intOrden			AS [orden]
		,M.strIcono			AS [Icon]
	INTO #MenuRol
	FROM tbMenu					As M WITH(NOLOCK)
		JOIN tbMenuDtl			As D WITH(NOLOCK) ON D.intMenu = M.intMenu
	WHERE D.intRol = @IDRol
		AND IsActivo = 1

	DELETE MR1
	--SELECT * 
	FROM #MenuRol		AS MR1 WITH(NOLOCK)
		JOIN tbMenuXUsuario		AS DEL WITH(NOLOCK) ON DEL.IDMenu = MR1.IDMenu
	WHERE DEL.btRestringir = 1 AND DEL.IsActivo = 1
		AND DEL.InternalIDUser = @InternalIDUser
				
		

	SELECT MR.IDMenu, MR.Descripcion, MR.Parametro, MR.ViewVista, MR.Controller, MR.IDRol, MR.subMenu, MR.Nivel, MR.IsNode, MR.orden, MR.Icon
	FROM #MenuRol	AS MR WITH(NOLOCK)
	UNION 
	SELECT SIST.IDMenu, SIST.Descripcion, SIST.Parametro, SIST.ViewVista, SIST.Controller, SIST.IDRol, SIST.subMenu, SIST.Nivel, SIST.IsNode, SIST.orden, SIST.Icon
	FROM #MenuAgregado	AS SIST WITH(NOLOCK)
	ORDER BY subMenu, orden ASC
END
go

/*
INSERT tbMenuXUsuario(InternalIDUser, IDMenu, IsActivo, btAgregar, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT InternalIDUser = 1, IDMenu =1, IsActivo = 1, btAgregar =  0, strUsuarioAlta = 'MR-JOC', strMaquinaAlta = 'MR-JOC', datFechaAlta = GETDATE()

INSERT tbMenuXUsuario(InternalIDUser, IDMenu, IsActivo, btAgregar, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
SELECT InternalIDUser = 1, IDMenu =5, IsActivo = 1, btAgregar =  0, strUsuarioAlta = 'MR-JOC', strMaquinaAlta = 'MR-JOC', datFechaAlta = GETDATE()

*/



--SELECT * FROM  tbMenuXUsuario

sp_GetMenuByRol @IDRol = 1, @InternalIDUser = 1
go


----DELETE from tbmenu where intmenu in (57, 57, 66, 58,66,62,46,70,31)
----DELETE from tbmenudtl where intmenu in (57, 57, 66, 58,66,62,46,70,31)


