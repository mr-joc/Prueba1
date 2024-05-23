USE AllCeramic2024
go




go
alter PROCEDURE  qry_AgregarMenu_ExtraXUsuario_APP
@intMenu				INT,
@DesgloseMenus			NVARCHAR(100),
@intUsuarioAccede		INT,
@strUsuario				NVARCHAR(150)
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


	SELECT
		InternalIDUser = @intUsuarioAccede,IDMenu = Menu,IsActivo = 1, btAgregar = 1, strUsuarioAlta = @strUsuario, strMaquinaAlta = @strUsuario, datFechaAlta = GETDATE()
	INTO #tmpMenuInsertar
	FROM @tbMenu

	--SELECT MXU.* 
	DELETE MXU
	FROM tbMenuXUsuario			AS MXU WITH(NOLOCK)
		JOIN #tmpMenuInsertar	AS INS WITH(NOLOCK) ON INS.IDMenu = MXU.IDMenu AND MXU.InternalIDUser = INS.InternalIDUser

	INSERT tbMenuXUsuario(InternalIDUser, IDMenu, IsActivo, btAgregar, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
	SELECT
		InternalIDUser, IDMenu,IsActivo, btAgregar, strUsuarioAlta, strMaquinaAlta, datFechaAlta
	FROM #tmpMenuInsertar
	
	------select * from tbMenuXUsuario  WHERE InternalIDUser = @intUsuarioAccede
	

	SET @ID = IDENT_CURRENT('tbMenuXUsuario')
				
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

--qry_AgregarMenu_ExtraXUsuario_APP @intMenu = 0, @DesgloseMenus = '25~52~32~0', @intUsuarioAccede = 6, @strUsuario = 'MR-JOC'
go

				 
		
		 
				 




go
alter PROCEDURE qry_Restriccion_MenuXUsuario_APP
@intMenuRestringe	INT,
@DesgloseMenu		NVARCHAR(100),
@intUsuario			INT,
@strUsuario			NVARCHAR(150)
AS
BEGIN
	 DECLARE @ID INT, @Posicion2 INT, @idMenu VARCHAR(150), @NivelPerteneceMenu INT, @MenuSuperior4 INT, @Nodos3 INT, @MenuSuperior3 INT, @Nodos2 INT, @MenuSuperior2 INT, @Nodos1 INT--, @Nodos3 INT, @Nodos4 INT 
	DECLARE @tbMenu TABLE (idNivel INT IDENTITY(1, 1), intMenu NVARCHAR(20), intMenuSolicitado INT, btCoincide BIT, intMenuSuperior INT)

	CREATE TABLE #tbMenuBase(intMenuReal INT, intMenu1 INT, intMenu2 INT, intMenu3 INT, intMenu4 INT, 
				strDesgloseMenu NVARCHAR(200), strDescripcion1 NVARCHAR(200), strDescripcion2 NVARCHAR(200), strDescripcion3 NVARCHAR(200), strDescripcion4 NVARCHAR(200), strDescripcion5 NVARCHAR(200), 
				RowID1 INT, RowID2 INT, RowID3 INT, RowID4 INT, isActivo INT, intPerfil INT)

	INSERT #tbMenuBase(intMenuReal, intMenu1, intMenu2, intMenu3, intMenu4, 
				strDesgloseMenu, strDescripcion1, strDescripcion2, strDescripcion3, strDescripcion4 , strDescripcion5, 
				RowID1, RowID2, RowID3, RowID4, isActivo, intPerfil)
	EXEC qry_AdministrarMenu_SEL @internalID = 0, @intPerfil = 0

	--SELECT '#tbMenuBase',* FROM #tbMenuBase

	SELECT @DesgloseMenu = strDesgloseMenu FROM #tbMenuBase WHERE intMenuReal = @intMenuRestringe
	--SELECT '@DesgloseMenu'=@DesgloseMenu

	SET @DesgloseMenu = @DesgloseMenu + '~'
	WHILE patindex('%~%' , @DesgloseMenu) <> 0
	BEGIN
		SELECT @Posicion2 =  patindex('%~%' , @DesgloseMenu)
		SELECT @idMenu = left(@DesgloseMenu, @Posicion2 - 1)
		IF NOT EXISTS (SELECT intMenu FROM @tbMenu WHERE intMenu = @idMenu)
		BEGIN 
			INSERT @tbMenu (intMenu, intMenuSolicitado, btCoincide, intMenuSuperior)
			SELECT
				intMenu = @idMenu, 
				intMenuSolicitado = @intMenuRestringe, 
				btCoincide = (CASE WHEN @idMenu = @intMenuRestringe THEN 1 ELSE 0 END),
				intMenuSuperior = 0
				WHERE @idMenu <> 0 
		END

		SELECT @DesgloseMenu = stuff(@DesgloseMenu, 1, @Posicion2, '')
	END

	SELECT @NivelPerteneceMenu = idNivel
	FROM @tbMenu
	WHERE btCoincide = 1

	UPDATE M  
	SET M.intMenuSuperior = ISNULL((SELECT A.intMEnu 
							FROM @tbMenu AS A
							WHERE A.idNivel =  (M.idNivel -1) ), 0)
	FROM @tbMenu AS M

--	SELECT '@tbMenu',* FROM	@tbMenu

	
	DELETE tbMenuXUsuario  WHERE InternalIDUser = @intUsuario AND IDMenu = @intMenuRestringe -- AND btAgregar = 1

	INSERT tbMenuXUsuario(InternalIDUser,IDMenu,IsActivo,btAgregar,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT @intUsuario, @intMenuRestringe, IsActivo = 1, btAgregar = 0, strUsuarioAlta = @strUsuario, strMaquinaAlta = @strUsuario, datFechaAlta =GETDATE()


	--DELETE FROM tbMenuDtl WHERE intRol = @intPerfil AND intMenu = @intMenuElimina
	
	--CUANDO EL NIVEL DEL MENÚ ES 4, REVISAMOS QUE NO QUEDE PENDIENTE NADA EN LOS NIVELES SUPERIORES (DE UN NÚMERO MENOR)
	--IF @NivelPerteneceMenu = 4
	--BEGIN
	--	PRINT 'ENTRAMOS A LA LÓGICA DEL NIVEL 4'
	--	SELECT @MenuSuperior4 = MM.intMenuSuperior 
	--	FROM @tbMenu AS MM
	--	WHERE MM.idNivel = 4

	--	SELECT @Nodos3 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior4 AND intRol = @intPerfil

	--	IF @Nodos3 = 0
	--	BEGIN
	--		PRINT 'NO HAY NADA'
	--		DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior4 AND intRol = @intPerfil
	--	END
		
	--	SELECT @MenuSuperior3 = MM.intMenuSuperior 
	--	FROM @tbMenu AS MM
	--	WHERE MM.idNivel = 3

	--	SELECT @Nodos2 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior3 AND intRol = @intPerfil

	--	IF @Nodos2 = 0
	--	BEGIN
	--		PRINT 'NO HAY NADA'
	--		DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior3 AND intRol = @intPerfil
	--	END

		
	--	SELECT @MenuSuperior2 = MM.intMenuSuperior 
	--	FROM @tbMenu AS MM
	--	WHERE MM.idNivel = 2
	--	--SELECT '@MenuSuperior2' = @MenuSuperior2
		
	--	SELECT @Nodos1 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior2 AND intRol = @intPerfil
	--	--SELECT '@Nodos1' =  @Nodos1

	--	IF @Nodos1 = 0
	--	BEGIN
	--		PRINT 'NO HAY NADA'
	--		DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior2 AND intRol = @intPerfil
	--	END
	--END
	
	----CUANDO EL NIVEL DEL MENÚ ES 3, REVISAMOS QUE NO QUEDE PENDIENTE NADA EN LOS NIVELES SUPERIORES (DE UN NÚMERO MENOR)
	--IF @NivelPerteneceMenu = 3
	--BEGIN
	--	PRINT 'ENTRAMOS A LA LÓGICA DEL NIVEL 3'
	--	SELECT @MenuSuperior3 = MM.intMenuSuperior 
	--	FROM @tbMenu AS MM
	--	WHERE MM.idNivel = 3

	--	SELECT @Nodos2 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior3 AND intRol = @intPerfil

	--	IF @Nodos2 = 0
	--	BEGIN
	--		PRINT 'NO HAY NADA'
	--		DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior3 AND intRol = @intPerfil
	--	END

		
	--	SELECT @MenuSuperior2 = MM.intMenuSuperior 
	--	FROM @tbMenu AS MM
	--	WHERE MM.idNivel = 2
	--	--SELECT '@MenuSuperior2' = @MenuSuperior2
		
	--	SELECT @Nodos1 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior2 AND intRol = @intPerfil
	--	--SELECT '@Nodos1' =  @Nodos1

	--	IF @Nodos1 = 0
	--	BEGIN
	--		PRINT 'NO HAY NADA'
	--		DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior2 AND intRol = @intPerfil
	--	END
	--END
	
	----CUANDO EL NIVEL DEL MENÚ ES 2, REVISAMOS QUE NO QUEDE PENDIENTE NADA EN LOS NIVELES SUPERIORES (DE UN NÚMERO MENOR)
	--IF @NivelPerteneceMenu = 2
	--BEGIN
	--	PRINT 'ENTRAMOS A LA LÓGICA DEL NIVEL 2'

		
	--	SELECT @MenuSuperior2 = MM.intMenuSuperior 
	--	FROM @tbMenu AS MM
	--	WHERE MM.idNivel = 2
	--	--SELECT '@MenuSuperior2' = @MenuSuperior2
		
	--	SELECT @Nodos1 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior2 AND intRol = @intPerfil
	--	--SELECT '@Nodos1' =  @Nodos1

	--	IF @Nodos1 = 0
	--	BEGIN
	--		PRINT 'NO HAY NADA'
	--		DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior2 AND intRol = @intPerfil
	--	END
	--END

	select @intMenuRestringe as Id;
END
go


 qry_Restriccion_MenuXUsuario_APP @intMenuRestringe = 32, @DesgloseMenu = 'XXX', @intUsuario = 6, @strUsuario	= 'MR-JOC'
 go


 	 
select * from tbMenuXUsuario  WHERE InternalIDUser = 6
go

