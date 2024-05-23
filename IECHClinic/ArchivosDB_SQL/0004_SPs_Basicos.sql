USE IECHClinic
go

 

go
--qry_V2_limpiarPermisosEspeciales_XUsuario_DEL @intUsuario = 6, @strUsuario = 'mr-joc'
CREATE PROCEDURE qry_V2_limpiarPermisosEspeciales_XUsuario_DEL 
@intUsuario			INT,
@strUsuario			NVARCHAR(150)
AS
BEGIN
	
	DELETE tbMenuXUsuario WHERE InternalIDUser = @intUsuario	


	SELECT @intUsuario as Id;
END
go


go
--qry_V2_ListarRolesActivos_SEL 0
CREATE  PROCEDURE  qry_V2_ListarRolesActivos_SEL  
    @intRol INT = NULL
AS   
BEGIN
	SET @intRol = ISNULL(@intRol, 0) 

	SET NOCOUNT ON;
    SELECT intRol, strNombre, isAdministrativo, isOperativo, isActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod
	FROM tbRoles WITH(NOLOCK)
    WHERE isActivo = 1
		AND (intRol = @intRol or @intRol = 0)
END
go


go
CREATE PROCEDURE qry_V2_Restriccion_MenuXUsuario_APP
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
	EXEC qry_V2_AdministrarMenu_SEL @internalID = 0, @intPerfil = 0

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
	 

	
	DELETE tbMenuXUsuario  WHERE InternalIDUser = @intUsuario AND IDMenu = @intMenuRestringe -- AND btAgregar = 1

	INSERT tbMenuXUsuario(InternalIDUser,IDMenu,IsActivo,btAgregar,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT @intUsuario, @intMenuRestringe, IsActivo = 1, btAgregar = 0, strUsuarioAlta = @strUsuario, strMaquinaAlta = @strUsuario, datFechaAlta =GETDATE()


	select @intMenuRestringe as Id;
END
go

go
CREATE PROCEDURE  qry_V2_AgregarMenu_ExtraXUsuario_APP
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


go
--qry_PassWordUsuario_Upd 'jorgre alberto', 'rOVIEDO',' rCERDA', 26, 1, 1, 'MR-JOC'
CREATE PROCEDURE qry_V2_PassWordUsuario_Upd
	@strUsuario				NVARCHAR(200), 
	@strPassword			NVARCHAR(200), 
	@strNewPass1			NVARCHAR(200), 
	@strNewPass2			NVARCHAR(200), 
	@strUsuarioGuarda		NVARCHAR(50)
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

		

	DECLARE @ID INT

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END
	
	--ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	IF @strUsuario = ''
	BEGIN
		SELECT @MensajeError =  'El usuario no existe o su tiempo de sesión ha caducado.'
		GOTO ERROR
	END
	
	--EN CASO DE QUE TRATEMOS DE REGISTRAR DOS EMPLEADOS CON LOS MISMOS NOMBRES
	IF NOT EXISTS(SELECT strUsuario FROM segUsuarios WHERE strUsuario = @strUsuario)
	BEGIN
		SELECT @MensajeError =  'El Usuario no Coincide con la lista actual.'
		GOTO ERROR
	END
	
	--EN CASO DE QUE TRATEMOS DE REGISTRAR DOS EMPLEADOS CON LOS MISMOS NOMBRES
	IF NOT EXISTS(SELECT strUsuario FROM segUsuarios WHERE strUsuario = @strUsuario AND strPassword = @strPassword)
	BEGIN
		SELECT @MensajeError =  'La contraseña Actual es INCORRECTA'
		GOTO ERROR
	END
	
	
	UPDATE segUsuarios 
	SET strPassword = @strNewPass1
		,strUsuarioMod = @strUsuario
		,strMaquinaMod = @strUsuario+'. Pwd Actualizado'
		,datFechaMod = GETDATE()
	WHERE strUsuario = @strUsuarioGuarda
	

	SET @ID = (SELECT intUsuario FROM segUsuarios WHERE strUsuario = @strUsuarioGuarda AND strPassword = @strPassword)
				
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
		'Gracias '+UPPER(@strUsuario)+'. Tu Contraseña ha sido actualizada' AS Mensaje;
	END	
	RETURN 0
END
go



go
--qry_Usuario_Upd 5, 'jorgedlberto','oviedo', 'cerda', 27, 1, 1, 'MR-JOC'
CREATE PROCEDURE qry_V2_Usuario_Upd	
	@intUsuarioID		INT,
	@strUsuario			NVARCHAR(200), 
	@strNombres			NVARCHAR(200), 
	@strApPaterno		NVARCHAR(200), 
	@strApMaterno		NVARCHAR(200), 
	@strPassword		NVARCHAR(200), 
	@intRol				INT,
	@IsActivo			BIT,
	@strUsuarioGuarda	NVARCHAR(200)

AS
BEGIN
	DECLARE @ID INT 

	UPDATE segUsuarios
	SET 
		strUsuario			= UPPER(@strUsuario),
		strNombreUsuario	= UPPER(@strNombres+' '+@strApPaterno+' '+@strApMaterno),
		strPassword			= @strPassword,
		intRol				= @intRol,
		isActivo			= @IsActivo,
		strNombre			= UPPER(@strNombres),
		strApPaterno		= UPPER(@strApPaterno),
		strApMaterno		= UPPER(@strApMaterno),
		strUsuarioMod		= @strUsuarioGuarda,
		strMaquinaMod		= @strUsuarioGuarda,
		datFechaMod			= GETDATE()
	WHERE intUsuario = @intUsuarioID

	SELECT @intUsuarioID AS Id, 'Datos actualizados, Clave: '+@strUsuario+'.' AS Mensaje;

END
go


go
--qry_V2_getUsuario_Sel 1
alter PROCEDURE qry_V2_getUsuario_Sel
@intUsuarioID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		intUsuarioID = EMP.intUsuario, strUsuario, strNombres = EMP.strNombre, strApPaterno = EMP.strApPaterno, strApMaterno = EMP.strApMaterno, strContrasena = EMP.strPassword, strContrasena2 = EMP.strPassword,
		EMP.intRol,
		strNombreRol = ROL.strNombre,
		EMP.IsActivo,EMP.IsBorrado,EMP.strUsuarioAlta,EMP.strMaquinaAlta,EMP.datFechaAlta
	FROM segUsuarios AS EMP WITH(NOLOCK)
		JOIN tbRoles AS ROL WITH(NOLOCK) ON ROL.intRol = EMP.intRol
	WHERE EMP.IsBorrado <> 1
		AND EMP.intUsuario = @intUsuarioID
END
go


go
--qry_V2_Usuario_APP 'jorgre alberto', 'rOVIEDO',' rCERDA', 26, 1, 1, 'MR-JOC'
CREATE PROCEDURE qry_V2_Usuario_APP
	@strUsuario				NVARCHAR(200), 
	@strNombres				NVARCHAR(200), 
	@strApPaterno			NVARCHAR(200), 
	@strApMaterno			NVARCHAR(200), 
	@strPassword			NVARCHAR(200), 
	@intRol					INT,
	@IsActivo				BIT,
	@strUsuarioGuarda		NVARCHAR(50)
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

		

	DECLARE @ID INT

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END
	
	--ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	IF @strNombres = 'JOC'
	BEGIN
		SELECT @MensajeError =  'El nombre de "JOC" no es válido y se coloca para marcar error .'
		GOTO ERROR
	END
	
	--EN CASO DE QUE TRATEMOS DE REGISTRAR DOS EMPLEADOS CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT * FROM segUsuarios WHERE strNombreUsuario = @strNombres+' '+@strApPaterno+' '+@strApMaterno)
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrado un empleado con estos mismos nombres.'
		GOTO ERROR
	END
	
	

	INSERT segUsuarios(strUsuario, strNombreUsuario, strPassword, intRol, isActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strNombre, strApPaterno, strApMaterno, IsBorrado)
	SELECT strUsuario = UPPER(@strUsuario), strNombreUsuario = UPPER(@strNombres+' '+@strApPaterno+' '+@strApMaterno), strPassword = UPPER(@strPassword), intRol = @intRol, 
		isActivo = @IsActivo, strUsuarioAlta = UPPER(@strUsuarioGuarda), strMaquinaAlta = UPPER(@strUsuarioGuarda), datFechaAlta = GETDATE(), 
		strNombre = UPPER(@strNombres), strApPaterno = UPPER(@strApPaterno), strApMaterno = UPPER(@strApMaterno), IsBorrado = 0
	

	SET @ID = IDENT_CURRENT('segUsuarios')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el empleado con la clave: '+@strUsuario+'.' AS Mensaje;
	END	
	RETURN 0
END
go


go
--qry_Usuario_Del 17, 'MR-JOC'
CREATE PROCEDURE qry_V2_Usuario_Del
	@intUsuarioID	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE segUsuarios
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intUsuario = @intUsuarioID;

	select @intUsuarioID as Id;
END
go



go
--qry_V2_Usuario_Sel 0
alter PROCEDURE qry_V2_Usuario_Sel 
@intUsuarioID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		intUsuarioID = EMP.intUsuario, 
		EMP.strNombreUsuario,
		strUsuario, strNombres = EMP.strNombre, strApPaterno = EMP.strApPaterno, strApMaterno = EMP.strApMaterno, intNumUsuario = EMP.intUsuario,
		EMP.intRol,
		strRol = ROL.strNombre,
		EMP.IsActivo,EMP.IsBorrado,
		EMP.strUsuarioAlta,EMP.strMaquinaAlta,EMP.datFechaAlta,EMP.strUsuarioMod,EMP.strMaquinaMod,EMP.datFechaMod
		FROM segUsuarios AS EMP WITH(NOLOCK)
			JOIN tbRoles AS ROL WITH(NOLOCK) ON ROL.intRol = EMP.intRol
	WHERE EMP.IsBorrado <> 1
		AND (EMP.intUsuario = @intUsuarioID OR @intUsuarioID = 0)
END
go

 

go
--qry_Rol_Upd 1, 'sistemas', 1, 1, 'MR-JOC'
CREATE PROCEDURE qry_V2_Rol_Upd
	@intRol				NVARCHAR(50), 
	@strNombre			NVARCHAR(200), 
	@IsAdministrativo	BIT,
	@IsActivo			BIT,
	@strUsuario			NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT , @isOperativo BIT

	SELECT @isOperativo = (CASE @IsAdministrativo WHEN 1 THEN 0 ELSE 1 END)

	UPDATE tbRoles
	SET 
		strNombre			= UPPER(@strNombre),
		isAdministrativo	= @IsAdministrativo,
		isOperativo			= @isOperativo,
		IsActivo			= @IsActivo,
		strUsuarioMod		= @strUsuario,
		strMaquinaMod		= @strUsuario,
		datFechaMod			= GETDATE()
	WHERE intRol = @intRol

	SELECT @intRol AS Id, 'Datos actualizados, ID: '+CONVERT(VARCHAR(10), @intRol)+'.' AS Mensaje;

END
go



go
--qry_V2_getRol_Sel 1
CREATE PROCEDURE qry_V2_getRol_Sel
@intRol INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ROL.intRol, ROL.strNombre, ROL.isAdministrativo, ROL.isOperativo, ROL.isActivo, ROL.IsBorrado, 
		ROL.strUsuarioAlta, ROL.strMaquinaAlta, ROL.datFechaAlta, ROL.strUsuarioMod, ROL.strMaquinaMod, ROL.datFechaMod
	FROM  tbRoles AS ROL WITH(NOLOCK)
	WHERE ROL.IsBorrado <> 1
		AND ROL.intRol= @intRol
END
go


go
--qry_Rol_APP 'otro ROL', 1, 1, 'MR-JOC'
CREATE PROCEDURE qry_V2_Rol_APP
	@strNombre				NVARCHAR(200), 
	@IsAdministrativo		BIT,
	@IsActivo				BIT,
	@strUsuario				NVARCHAR(50)
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

		

	DECLARE @ID INT, @isOperativo BIT

	SELECT @isOperativo = (CASE @IsAdministrativo WHEN 1 THEN 0 ELSE 1 END)

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END
	
	--ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	IF @strNombre = 'JOC'
	BEGIN
		SELECT @MensajeError =  'El nombre de "JOC" no es válido y se coloca para marcar error .'
		GOTO ERROR
	END	
	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS ROLES CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT * FROM tbRoles WHERE strNombre = @strNombre AND IsBorrado = 0 )
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrado un rol con estes nombre.'
		GOTO ERROR
	END

	INSERT tbRoles(strNombre,isAdministrativo,isOperativo,IsActivo,IsBorrado,
						strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT UPPER(@strNombre), @IsAdministrativo, @isOperativo, @IsActivo, 0, 
			@strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbRoles')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Rol: '+UPPER(@strNombre)+'.' AS Mensaje;
	END	
	RETURN 0
END
go



go
--qry_V2_Rol_Del 5, 'MR-JOC'
CREATE PROCEDURE qry_V2_Rol_Del
	@intRol	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbRoles
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intRol = @intRol;

	select @intRol as Id;
END
go


go
--qry_V2_Rol_Sel 0
CREATE PROCEDURE qry_V2_Rol_Sel 
@intRol INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		ROL.intRol, ROL.strNombre, ROL.isAdministrativo, ROL.isOperativo,
		ROL.IsActivo,ROL.IsBorrado,
		ROL.strUsuarioAlta,ROL.strMaquinaAlta,ROL.datFechaAlta,ROL.strUsuarioMod,ROL.strMaquinaMod,ROL.datFechaMod
		FROM tbRoles AS ROL WITH(NOLOCK)
	WHERE IsBorrado <> 1
		AND (ROL.intRol = @intRol OR @intRol = 0)
END
go
 
go
alter PROCEDURE qry_V2_AdministrarMenu_DEL
@intMenuElimina	INT,
@DesgloseMenu	NVARCHAR(100),
@intPerfil		INT,
@strUsuario		NVARCHAR(150)
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
	EXEC qry_V2_AdministrarMenu_SEL @internalID = 0, @intPerfil = 0

	--SELECT '#tbMenuBase',* FROM #tbMenuBase

	SELECT @DesgloseMenu = strDesgloseMenu FROM #tbMenuBase WHERE intMenuReal = @intMenuElimina
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
				intMenuSolicitado = @intMenuElimina, 
				btCoincide = (CASE WHEN @idMenu = @intMenuElimina THEN 1 ELSE 0 END),
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


	--SELECT *,'@NivelPerteneceMenu'=@NivelPerteneceMenu FROM @tbMenu

	DELETE FROM tbMenuDtl WHERE intRol = @intPerfil AND intMenu = @intMenuElimina
	
	--CUANDO EL NIVEL DEL MENÚ ES 4, REVISAMOS QUE NO QUEDE PENDIENTE NADA EN LOS NIVELES SUPERIORES (DE UN NÚMERO MENOR)
	IF @NivelPerteneceMenu = 4
	BEGIN
		PRINT 'ENTRAMOS A LA LÓGICA DEL NIVEL 4'
		SELECT @MenuSuperior4 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 4

		SELECT @Nodos3 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior4 AND intRol = @intPerfil

		IF @Nodos3 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior4 AND intRol = @intPerfil
		END
		
		SELECT @MenuSuperior3 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 3

		SELECT @Nodos2 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior3 AND intRol = @intPerfil

		IF @Nodos2 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior3 AND intRol = @intPerfil
		END

		
		SELECT @MenuSuperior2 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 2
		--SELECT '@MenuSuperior2' = @MenuSuperior2
		
		SELECT @Nodos1 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior2 AND intRol = @intPerfil
		--SELECT '@Nodos1' =  @Nodos1

		IF @Nodos1 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior2 AND intRol = @intPerfil
		END
	END
	
	--CUANDO EL NIVEL DEL MENÚ ES 3, REVISAMOS QUE NO QUEDE PENDIENTE NADA EN LOS NIVELES SUPERIORES (DE UN NÚMERO MENOR)
	IF @NivelPerteneceMenu = 3
	BEGIN
		PRINT 'ENTRAMOS A LA LÓGICA DEL NIVEL 3'
		SELECT @MenuSuperior3 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 3

		SELECT @Nodos2 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior3 AND intRol = @intPerfil

		IF @Nodos2 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior3 AND intRol = @intPerfil
		END

		
		SELECT @MenuSuperior2 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 2
		--SELECT '@MenuSuperior2' = @MenuSuperior2
		
		SELECT @Nodos1 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior2 AND intRol = @intPerfil
		--SELECT '@Nodos1' =  @Nodos1

		IF @Nodos1 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior2 AND intRol = @intPerfil
		END
	END
	
	--CUANDO EL NIVEL DEL MENÚ ES 2, REVISAMOS QUE NO QUEDE PENDIENTE NADA EN LOS NIVELES SUPERIORES (DE UN NÚMERO MENOR)
	IF @NivelPerteneceMenu = 2
	BEGIN
		PRINT 'ENTRAMOS A LA LÓGICA DEL NIVEL 2'

		
		SELECT @MenuSuperior2 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 2
		--SELECT '@MenuSuperior2' = @MenuSuperior2
		
		SELECT @Nodos1 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior2 AND intRol = @intPerfil
		--SELECT '@Nodos1' =  @Nodos1

		IF @Nodos1 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior2 AND intRol = @intPerfil
		END
	END
	select @intMenuElimina as Id;
END 
go


go
CREATE PROCEDURE  qry_V2_agregaPermisoPerfil_APP
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


go
--qry_AdministrarMenu_SEL 0
CREATE PROCEDURE qry_V2_AdministrarMenu_SEL
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
		FROM #Resultado					AS MR1 WITH(NOLOCK)
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


 
