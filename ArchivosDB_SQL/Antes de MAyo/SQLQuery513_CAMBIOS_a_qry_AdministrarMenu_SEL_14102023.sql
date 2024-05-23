USE AllCeramic2024
go




go
--qry_AdministrarMenu_SEL 0
alter PROCEDURE qry_AdministrarMenu_SEL
@internalID INT = NULL,
@intPerfil INT = NULL
AS
BEGIN
	SELECT M.intMenu, DTL.subMenu, strDescripcion1 = M.strDescripcion, strDescripcion2 =  '', strDescripcion3 =  '', strDescripcion4 =  '', strDescripcion5 =  '',M.Nivel, M.IsNodo, M.strIcono,
		DTL.intRol, DTL.intOrden, RowID = (ROW_NUMBER() OVER(PARTITION BY DTL.Submenu ORDER BY DTL.intOrden))
	INTO #Nivel1
	FROM tbMenu			AS   M WITH(NOLOCK)
		JOIN tbMenuDtl	AS DTL  WITH(NOLOCK) ON DTL.intMenu = M.intMenu
	WHERE M.Nivel = 1 
		AND DTL.intRol = 1

	SELECT M.intMenu, DTL.subMenu, strDescripcion1 = '', strDescripcion2 = M.strDescripcion, strDescripcion3 =  '', strDescripcion4 =  '', strDescripcion5 =  '', M.Nivel, M.IsNodo, M.strIcono,
		DTL.intRol, DTL.intOrden, RowID = (ROW_NUMBER() OVER(PARTITION BY DTL.Submenu ORDER BY DTL.intOrden))
	INTO #Nivel2
	FROM tbMenu			AS   M WITH(NOLOCK)
		JOIN tbMenuDtl	AS DTL  WITH(NOLOCK) ON DTL.intMenu = M.intMenu
	WHERE M.Nivel = 2 
		AND DTL.intRol = 1
	ORDER BY DTL.subMenu, DTL.intOrden

	SELECT M.intMenu, DTL.subMenu, strDescripcion1 = '', strDescripcion2 = '', strDescripcion3 = M.strDescripcion, strDescripcion4 =  '', strDescripcion5 =  '', M.Nivel, M.IsNodo, M.strIcono,
		DTL.intRol, DTL.intOrden, RowID = (ROW_NUMBER() OVER(PARTITION BY DTL.Submenu ORDER BY DTL.intOrden))
	INTO #Nivel3
	FROM tbMenu			AS   M WITH(NOLOCK)
		JOIN tbMenuDtl	AS DTL  WITH(NOLOCK) ON DTL.intMenu = M.intMenu
	WHERE M.Nivel = 3 
		AND DTL.intRol = 1
	ORDER BY DTL.subMenu, DTL.intOrden

	SELECT M.intMenu, DTL.subMenu, strDescripcion1 = '', strDescripcion2 = '', strDescripcion3 = '', strDescripcion4 = M.strDescripcion, strDescripcion5 =  '', M.Nivel, M.IsNodo, M.strIcono,
		DTL.intRol, DTL.intOrden, RowID = (ROW_NUMBER() OVER(PARTITION BY DTL.Submenu ORDER BY DTL.intOrden))
	INTO #Nivel4
	FROM tbMenu			AS   M WITH(NOLOCK)
		JOIN tbMenuDtl	AS DTL  WITH(NOLOCK) ON DTL.intMenu = M.intMenu
	WHERE M.Nivel = 4 
		AND DTL.intRol = 1
	ORDER BY DTL.subMenu, DTL.intOrden
 
	SELECT  
		intMenuReal = (CASE 
						WHEN (ISNULL(N4.intMenu, 0) = 0) AND (ISNULL(N3.intMenu, 0) = 0) AND (ISNULL(N2.intMenu, 0) = 0) THEN ISNULL(N1.intMenu, 0)
						WHEN (ISNULL(N4.intMenu, 0) = 0) AND (ISNULL(N3.intMenu, 0) = 0) THEN ISNULL(N2.intMenu, 0)
						WHEN (ISNULL(N4.intMenu, 0) = 0) THEN ISNULL(N3.intMenu, 0)
					END),
		intMenu1 = ISNULL(N1.intMenu, 0), 
		intMenu2 = ISNULL(N2.intMenu, 0), 
		intMenu3 = ISNULL(N3.intMenu, 0), 
		intMenu4 = ISNULL(N4.intMenu, 0),
		strDesgloseMenu = CONVERT(VARCHAR(10), ISNULL(N1.intMenu, 0))+'~'+CONVERT(VARCHAR(10), ISNULL(N2.intMenu, 0))+'~'+CONVERT(VARCHAR(10), ISNULL(N3.intMenu, 0))+'~'+CONVERT(VARCHAR(10), ISNULL(N4.intMenu, 0)),
		--subMenu1 = ISNULL(N1.subMenu, 0), subMenu2 = ISNULL(N2.subMenu, 0), subMenu3 = ISNULL(N3.subMenu, 0), subMenu4 = ISNULL(N4.subMenu, 0), 
		strDescripcion1 = IIF(((ISNULL(N2.RowID, 1)) = 1 AND (ISNULL(N3.RowID, 1)) = 1), N1.strDescripcion1, ''),
		strDescripcion2 = IIF((ISNULL(N3.RowID, 1)) = 1, (ISNULL(N2.strDescripcion2, '')), ''),
		strDescripcion3 = ISNULL(N3.strDescripcion3, ''),
		strDescripcion4 = N1.strDescripcion4, 
		strDescripcion5 = N1.strDescripcion5,
		--N1.Nivel, N1.IsNodo, N1.strIcono, N1.intRol, N1.intOrden, 
		RowID1 = ISNULL(N1.RowID, 1), RowID2 = ISNULL(N2.RowID, 1), RowID3 = ISNULL(N3.RowID, 1), RowID4 = ISNULL(N4.RowID, 1)
		--,RowID1=N1.RowID,RowID2=N2.RowID,RowID3=N3.RowID,RowID4=N4.RowID
		,isActivo = CAST (0 AS bit)
		,subMenu = ISNULL(N1.subMenu, 0),intOrden = ISNULL(N1.intOrden, 0)
	INTO #Resultado
	FROM #Nivel1		AS N1 WITH(NOLOCK)
		LEFT JOIN #Nivel2	AS N2 WITH(NOLOCK) ON N2.subMenu = N1.intMenu
		LEFT JOIN #Nivel3	AS N3 WITH(NOLOCK) ON N3.subMenu = N2.intMenu
		LEFT JOIN #Nivel4	AS N4 WITH(NOLOCK) ON N4.subMenu = N3.intMenu

	UPDATE MENU
	SET MENU.isActivo = 1
	FROM #Resultado		AS MENU WITH(NOLOCK)
		JOIN tbMenuDtl	AS  DTL WITH(NOLOCK) ON DTL.intMenu = MENU.intMenuReal
	AND DTL.intRol = @intPerfil

	IF (@internalID <> 0 )
	BEGIN
		UPDATE MR1
		SET MR1.isActivo = 0
		--SELECT * 
		FROM #Resultado				AS MR1 WITH(NOLOCK)
			JOIN tbMenuXUsuario		AS DEL WITH(NOLOCK) ON DEL.IDMenu = MR1.intMenuReal
		WHERE DEL.btRestringir = 1 AND DEL.IsActivo = 1
			AND DEL.InternalIDUser = @internalID

			
		UPDATE MR1
		SET MR1.isActivo = 1
		--SELECT * 
		FROM #Resultado				AS MR1 WITH(NOLOCK)
			JOIN tbMenuXUsuario		AS DEL WITH(NOLOCK) ON DEL.IDMenu = MR1.intMenuReal
		WHERE DEL.btAgregar = 1 
			AND DEL.IsActivo = 1
			AND DEL.InternalIDUser = @internalID

	END

	SELECT 
		R1.intMenuReal, R1.intMenu1, R1.intMenu2, R1.intMenu3, R1.intMenu4, R1.strDesgloseMenu, 
		R1.strDescripcion1, R1.strDescripcion2, R1.strDescripcion3, R1.strDescripcion4, R1.strDescripcion5, R1.RowID1, R1.RowID2, R1.RowID3, R1.RowID4, 
		R1.isActivo, intPerfil = @intPerfil
	FROM #Resultado AS R1
	ORDER BY R1.subMenu, R1.intOrden
	
	DROP TABLE #Nivel1
	DROP TABLE #Nivel2
	DROP TABLE #Nivel3
	DROP TABLE #Nivel4
END
go


qry_AdministrarMenu_SEL @internalID = 7, @intPerfil = 5
go

select * from tbMenuXUsuario  WHERE InternalIDUser = 7

--qry_Usuario_Sel 1