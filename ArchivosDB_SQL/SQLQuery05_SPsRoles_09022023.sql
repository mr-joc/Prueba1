USE Dev1 
go


go
--qry_ListarRolesActivos_SEL 0
alter  PROCEDURE [dbo].[qry_ListarRolesActivos_SEL]  
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

--qry_ListarRolesActivos_SEL 0
go



USE Dev1
go


go
--qry_getRol_Sel 1
alter PROCEDURE qry_getRol_Sel
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

--select *  from tbroles

go
--qry_Rol_Upd 1, 'sistemas', 1, 1, 'MR-JOC'
alter PROCEDURE qry_Rol_Upd
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
--qry_Rol_Sel 0
alter PROCEDURE [dbo].[qry_Rol_Sel]
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
--qry_Rol_Del 5, 'MR-JOC'
alter PROCEDURE qry_Rol_Del
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


--SELECT * fROM tbRoles
--SELECT * fROM tbempleados

go
--qry_Rol_APP 'otro ROL', 1, 1, 'MR-JOC'
alter PROCEDURE qry_Rol_APP
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

