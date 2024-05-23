USE AllCeramic2024
go

DROP TABLE #Nivel1
DROP TABLE #Nivel2
DROP TABLE #Nivel3
DROP TABLE #Nivel4 


SELECT M.intMenu, DTL.subMenu, strDescripcion1 = M.strDescripcion, strDescripcion2 =  '', strDescripcion3 =  '', strDescripcion4 =  '', strDescripcion5 =  '',M.Nivel, M.IsNodo, M.strIcono,
	DTL.intRol, DTL.intOrden, RowID = 0
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
	N1.intMenu, 
	N1.subMenu, 
	strDescripcion1 = ISNULL(N1.strDescripcion1, ''),
	strDescripcion2 = ISNULL(N2.strDescripcion2, ''),
	strDescripcion3 = ISNULL(N3.strDescripcion3, ''),
	strDescripcion4 = N1.strDescripcion4, 
	strDescripcion5 = N1.strDescripcion5,
	N1.Nivel, 
	N1.IsNodo, 
	N1.strIcono,
	N1.intRol, N1.intOrden, 
	RowID2 = ISNULL(N2.RowID, 1), RowID3 = ISNULL(N3.RowID, 1), RowID4 = ISNULL(N4.RowID, 1),
	RowID2=N2.RowID,RowID3=N3.RowID,RowID4=N4.RowID
FROM #Nivel1		AS N1 WITH(NOLOCK)
	LEFT JOIN #Nivel2	AS N2 WITH(NOLOCK) ON N2.subMenu = N1.intMenu
	LEFT JOIN #Nivel3	AS N3 WITH(NOLOCK) ON N3.subMenu = N2.intMenu
	LEFT JOIN #Nivel4	AS N4 WITH(NOLOCK) ON N4.subMenu = N3.intMenu
ORDER BY N1.subMenu, N1.intOrden, N2.intOrden

--SELECT N2.intMenu, N2.subMenu, strDescripcion1 = N2.strDescripcion1, strDescripcion2 = N2.strDescripcion2, strDescripcion3 = N2.strDescripcion3, strDescripcion4 = N2.strDescripcion4, strDescripcion5 = N2.strDescripcion5,N2.Nivel, N2.IsNodo, N2.strIcono,
--	N2.intRol, N2.intOrden, N2.RowID
--FROM #Nivel4 AS N2
--ORDER BY N2.subMenu, N2.intOrden



