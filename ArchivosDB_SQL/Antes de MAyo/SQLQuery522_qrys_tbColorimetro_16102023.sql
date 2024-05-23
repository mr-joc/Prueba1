USE AllCeramic2024
go


----UPDATE tbMenu SET Vista = 'Colorimetro', Controlador='Colorimetro', strDescripcion = 'Colorímetros', IsNodo=0 WHERE intMenu = 30
--go
--sp_GetMenuByRol 1
--go




go
--qry_Colorimetro_Sel 0
alter PROCEDURE qry_Colorimetro_Sel
@intColorimetro INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		COL.intColorimetro, COL.strNombre,
		COL.IsActivo,COL.IsBorrado,
		COL.strUsuarioAlta,COL.strMaquinaAlta,COL.datFechaAlta,COL.strUsuarioMod,COL.strMaquinaMod,COL.datFechaMod
		FROM tbColorimetro AS COL WITH(NOLOCK)
	WHERE IsBorrado <> 1
		AND (COL.intColorimetro = @intColorimetro OR @intColorimetro = 0)
END
go



go
--qry_Colorimetro_Del 5, 'MR-JOC'
alter PROCEDURE qry_Colorimetro_Del
	@intColorimetro	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbColorimetro 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intColorimetro = @intColorimetro;

	select @intColorimetro as Id;
END
go




go
--qry_Colorimetro_APP 'otro ROL', 1, 1, 'MR-JOC'
alter PROCEDURE qry_Colorimetro_APP
	@strNombre				NVARCHAR(200),
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

		

	DECLARE @ID INT

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
	IF EXISTS(SELECT * FROM tbColorimetro WHERE strNombre = @strNombre AND IsBorrado = 0 )
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrado un Colorimetro con estes nombre.'
		GOTO ERROR
	END

	INSERT tbColorimetro(strNombre,IsActivo,IsBorrado,
						strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT UPPER(@strNombre), @IsActivo, 0, 
			@strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbColorimetro')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Colorimetro: '+UPPER(@strNombre)+'.' AS Mensaje;
	END	
	RETURN 0
END 
go


go
--qry_getColorimetro_Sel 1
alter PROCEDURE qry_getColorimetro_Sel
@intColorimetro INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COL.intColorimetro, COL.strNombre, COL.isActivo, COL.IsBorrado, 
		COL.strUsuarioAlta, COL.strMaquinaAlta, COL.datFechaAlta, COL.strUsuarioMod, COL.strMaquinaMod, COL.datFechaMod
	FROM  tbColorimetro AS COL WITH(NOLOCK)
	WHERE COL.IsBorrado <> 1
		AND COL.intColorimetro= @intColorimetro
END
go




go
--qry_Colorimetro_Upd 1, 'sistemas', 1, 1, 'MR-JOC'
alter PROCEDURE qry_Colorimetro_Upd
	@intColorimetro		INT, 
	@strNombre			NVARCHAR(200),
	@IsActivo			BIT,
	@strUsuario			NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT

	UPDATE tbColorimetro 
	SET 
		strNombre			= UPPER(@strNombre),
		IsActivo			= @IsActivo,
		strUsuarioMod		= @strUsuario,
		strMaquinaMod		= @strUsuario,
		datFechaMod			= GETDATE()
	WHERE intColorimetro = @intColorimetro

	SELECT @intColorimetro AS Id, 'Datos actualizados, ID: '+CONVERT(VARCHAR(10), @intColorimetro)+'.' AS Mensaje;

END
go

