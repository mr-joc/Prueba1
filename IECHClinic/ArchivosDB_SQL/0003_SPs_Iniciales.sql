USE IECHClinic
go

--

go
--qry_infoUsuario_SEL 'MR-JOC'
alter PROCEDURE [dbo].[qry_infoUsuario_SEL]
	(@strUsuario nVarchar(50))
AS
BEGIN
	SELECT  
			S.intUsuario			AS intUsuario,
			S.strUsuario			AS strUsuario,
			S.strNombreUsuario		AS strNomUsuario, 
			S.intRol				AS intRol,
			R.strNombre				AS strNombreRol
	FROM segUsuarios AS S WITH(NOLOCK)
		JOIN tbRoles AS R WITH(NOLOCK) ON S.introl = R.intRol
	WHERE S.strUsuario = @strUsuario

END
go


go
--qry_V2_ValidarPasword 'mr-joc', 'c4l4b4z4'
CREATE PROCEDURE qry_V2_ValidarPasword
@strUsuario NVARCHAR(100),
@strPassword NVARCHAR(100)
AS
BEGIN
	PRINT 'Revisamos que exista y que esté ACTIVO'
	IF EXISTS(SELECT * FROM segUsuarios WHERE strUsuario = @strUsuario AND strPassword = @strPassword AND isActivo = 1)
	BEGIN
		PRINT 'EL CÓDIGO SI EXISTE, por lo tanto devolvemos sus credenciales'

		SELECT intUsuario, Usuario = strUsuario, Pass = strPassword, isActivo
		FROM segUsuarios WITH(NOLOCK)
		WHERE strUsuario = @strUsuario AND strPassword = @strPassword
			 AND isActivo = 1
	END

END
go


--SELECT '@RolID' = intRol,'@DCDUserID' = strUsuario,* 	FROM SegUsuarios	


go
--qry_V2_Notificaciones_SEL @InternalID = 2
CREATE PROCEDURE [dbo].[qry_V2_Notificaciones_SEL]
@InternalID NVARCHAR(100)
AS
BEGIN
	DECLARE @RolID INT, @DCDUserID NVARCHAR(50)

	SELECT TOP 1 @RolID = intRol,
			@DCDUserID = strUsuario
	FROM SegUsuarios
	WHERE intUsuario = @InternalID

	
	SELECT intNotificacion,InternalID,RolID,strTitulo,strsubTitulo,
		strEnlace = ISNULL(strEnlace, '#'),
		Nivel = 1, strIcono,intOrden,
		datFechaAlta,datFechaInicia,datFechaVigencia 
	INTO #Notificaciones 
	FROM tbNotificaciones
	WHERE CONVERT(DATETIME, (CONVERT(VARCHAR(10), GETDATE(), 103)), 103) BETWEEN datFechaInicia AND datFechaVigencia 
		AND RolID = @RolID 
	UNION	
	SELECT intNotificacion,InternalID,RolID,strTitulo,strsubTitulo,
		strEnlace = ISNULL(strEnlace, '#'),
		Nivel = 1, strIcono,intOrden,
		datFechaAlta,datFechaInicia,datFechaVigencia 
	FROM tbNotificaciones
	WHERE CONVERT(DATETIME, (CONVERT(VARCHAR(10), GETDATE(), 103)), 103) BETWEEN datFechaInicia AND datFechaVigencia 
		AND InternalID = @InternalID

	IF (SELECT COUNT (*) FROM #Notificaciones)=0
	BEGIN
		SELECT Total = 0, intNotificacion=0, InternalID=0, RolID=0, strTitulo = '', strsubTitulo = '', strEnlace = '#', Nivel=1, strIcono = '', intOrden=1, datFechaAlta=GETDATE(), datFechaVigencia=GETDATE()

	END

	SELECT 
		Total=(SELECT COUNT (*) FROM #Notificaciones),
		intNotificacion,InternalID,RolID,strTitulo,strsubTitulo,strEnlace,Nivel, strIcono,intOrden,datFechaAlta,datFechaInicia,datFechaVigencia
	FROM #Notificaciones
	ORDER BY intOrden
END
go




 

go
--sp_V2_GetMenuByRol 1
alter PROCEDURE [dbo].[sp_V2_GetMenuByRol]
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


go
--qry_V2_infoUsuario_SEL 'mr-joc'
alter PROCEDURE [dbo].[qry_V2_infoUsuario_SEL]
	(@strUsuario nVarchar(50))
AS
BEGIN
	SELECT  
			S.intUsuario			AS intUsuario,
			S.strUsuario			AS strUsuario,
			S.strNombreUsuario		AS strNomUsuario, 
			S.intRol				AS intRol,
			R.strNombre				AS strNombreRol
	FROM segUsuarios AS S WITH(NOLOCK)
		JOIN tbRoles AS R WITH(NOLOCK) ON S.introl = R.intRol
	WHERE S.strUsuario = @strUsuario

END
go

go

