USE AllCeramic2024
go


UPDATE tbMenu SET Vista = 'AdministrarMenu', Controlador = 'AdministrarMenu' WHERE intMenu = 7


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
GO

qry_AdministrarMenu_SEL @internalID = 0, @intPerfil = 0
go
--select * from segusuarios

go
alter PROCEDURE  qry_agregaPermisoPerfil_APP
@intMenu		INT,
@DesgloseMenus	NVARCHAR(100),
@intPerfil		INT,
@strUsuario		NVARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- -----------------------------------------------------------------------------------------
	-- DECLARACIÓN DE VARIABLES
	-- -----------------------------------------------------------------------------------------
	DECLARE
		 @RESULT			INT
		,@MensajeError		VARCHAR(256)	--	Mensaje de Error
		,@TranCount			INT				--	@@TRANCOUNT
		,@BitInsert			BIT				--	Usaremos este bit para declarar si se inserta o no, creo que nos sirve en la fase de desarrollo para las pruebas :)
		,@MensajeResultado	VARCHAR(256)	--	Mensaje de Resultado

		

	DECLARE @ID INT, @Posicion2 INT, @idMenu VARCHAR(150) 
	DECLARE @tbMenu TABLE (Menu NVARCHAR(20))

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END
	
	--ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	IF @DesgloseMenus = ''
	BEGIN
		SELECT @MensajeError =  'Elije un renglón.'
		GOTO ERROR
	END
	
	
	SET @DesgloseMenus = @DesgloseMenus + '~'
	WHILE patindex('%~%' , @DesgloseMenus) <> 0
	BEGIN
		SELECT @Posicion2 =  patindex('%~%' , @DesgloseMenus)
		SELECT @idMenu = left(@DesgloseMenus, @Posicion2 - 1)
		IF NOT EXISTS (SELECT Menu FROM @tbMenu WHERE Menu = @idMenu)BEGIN INSERT INTO @tbMenu  SELECT @idMenu WHERE @idMenu <> 0 END

		SELECT @DesgloseMenus = stuff(@DesgloseMenus, 1, @Posicion2, '')
	END

	
	SELECT intMenu,intRol = @intPerfil,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta
	INTO #tmpMenuCompleto
	FROM tbMenuDtl		AS DTL WITH(NOLOCK) 
		JOIN @tbMenu	AS   M ON M.Menu = DTL.intMenu
	AND intRol = 1

	DELETE COMPLETO
	FROM #tmpMenuCompleto	AS COMPLETO	WITH(NOLOCK)
		JOIN tbMenuDtl		AS      DTL	WITH(NOLOCK) ON DTL.intMenu = COMPLETO.intMenu AND DTL.intRol = COMPLETO.intRol AND DTL.subMenu = COMPLETO.subMenu AND DTL.intOrden = COMPLETO.intOrden

	INSERT tbMenuDtl(intMenu,intRol,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT intMenu,intRol = @intPerfil,subMenu,intOrden,strUsuarioAlta,strMaquinaAlta,datFechaAlta 
	FROM #tmpMenuCompleto

	

	SET @ID = IDENT_CURRENT('tbMenuDTL')
				
	--SUPONIENDO QUE TODO SALIÓ BIEN NOS VAMOS A BRINCAR A LA SECCIÓN DE FIN
	GOTO FIN
	-- -----------------------------------------------------------------------------------------
	-- CUALQUIER SP, INSERT, VALIDACIÓN, ETC QUE NO FUNCIONE BIEN HACE QUE NOS VAYAMOS DIRECTO A ESTA SECCIÓN DE ERROR
	-- EN ELLA SOLO TOMAMOS EL TEXTO PREVIAMENTE ASIGNADO AL ERROR PARA MOSTRARLO Y HACEMOS UN ROLLBACK
	ERROR:
	-- -----------------------------------------------------------------------------------------
	IF @TranCount = 0	--	Si hay una transacción, hacer rollback
	BEGIN		
		IF @@TRANCOUNT <> 0
		BEGIN
			ROLLBACK TRANSACTION
		END
	END
	RAISERROR(@MensajeError, 16, 1)
	RETURN 1

	-- -----------------------------------------------------------------------------------------
	-- AQUI EN LA SECCIÓN DE FIN HACEMOS EL COMMIT Y DEVOLVEMOS LAS PALABRAS "INICIO" O "FIN" PARA QUE LA VISTA SEPA QUE HACER
	FIN:
	-- -----------------------------------------------------------------------------------------
	IF @TranCount = 0	--	Si hay una transacción, hacer un commit
	BEGIN
		IF @@TRANCOUNT <> 0
		BEGIN
			COMMIT TRANSACTION
		END
		SELECT @ID AS Id, 
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+'.' AS Mensaje;
	END	
	RETURN 0
END
go


--qry_agregaPermisoPerfil_APP @intMenu = 1, @DesgloseMenus = '25~50~51~0', @intPerfil = 2, @strUsuario = 'MR-JOC'





--SELECT * FROM tbMenuDtl

/*
declare 
@listaJobs Varchar(4000)=  '408009-1-1~408009-2-1~408009-3-1~408009-4-1~408009-5-1~408009-6-1~408009-7-1~408009-8-1~408009-9-1~408009-10-1~',
	@Usuario VARCHAR (30)=NULL


	DECLARE @Posicion2 INT, @idJob VARCHAR(150) 
	DECLARE @tbJobs TABLE (jobNum NVARCHAR(20))


	--COMMIT TRANSACTION

	SET @listaJobs = @listaJobs + '~'
	WHILE patindex('%~%' , @listaJobs) <> 0
	BEGIN
		SELECT @Posicion2 =  patindex('%~%' , @listaJobs)
		SELECT @idJob = left(@listaJobs, @Posicion2 - 1)
		IF NOT EXISTS (SELECT jobNum FROM @tbJobs WHERE jobNum = @idJob)BEGIN INSERT INTO @tbJobs  SELECT @idJob END

		SELECT @listaJobs = stuff(@listaJobs, 1, @Posicion2, '')
	END

	SELECT * FROM @tbJobs


	*/










