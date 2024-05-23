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

	SELECT SIST.IDMenu, SIST.Descripcion, SIST.Parametro, SIST.ViewVista, SIST.Controller, IDRol= @IDRol, SIST.subMenu, SIST.Nivel, SIST.IsNode, SIST.orden, SIST.Icon
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
	INTO #mpFin
	FROM #MenuRol	AS MR WITH(NOLOCK)
	UNION 
	SELECT SIST.IDMenu, SIST.Descripcion, SIST.Parametro, SIST.ViewVista, SIST.Controller, SIST.IDRol, SIST.subMenu, SIST.Nivel, SIST.IsNode, SIST.orden, SIST.Icon
	FROM #MenuAgregado	AS SIST WITH(NOLOCK)

	SELECT FF.IDMenu, FF.Descripcion, FF.Parametro, FF.ViewVista, FF.Controller, FF.IDRol, FF.subMenu, FF.Nivel, FF.IsNode, FF.orden, FF.Icon
	FROM #mpFin AS FF WITH(NOLOCK)
	GROUP BY FF.IDMenu, FF.Descripcion, FF.Parametro, FF.ViewVista, FF.Controller, FF.IDRol, FF.subMenu, FF.Nivel, FF.IsNode, FF.orden, FF.Icon
	ORDER BY FF.subMenu, FF.orden ASC
END
go

sp_GetMenuByRol @IDRol = 5, @InternalIDUser = 6
go


