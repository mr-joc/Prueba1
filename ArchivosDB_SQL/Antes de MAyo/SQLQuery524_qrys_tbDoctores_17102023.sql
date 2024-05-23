USE AllCeramic2024
go

--update tbMenu SET Vista ='Doctor', Controlador ='Doctor' WHERE intMenu = 65


go
--qry_Doctor_Sel 0
alter PROCEDURE qry_Doctor_Sel
@intDoctor INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		DR.intDoctor, DR.strNombre, DR.strApPaterno, DR.strApMaterno, strNombreCompleto = DR.strNombre+' '+DR.strApPaterno+' '+DR.strApMaterno, 
		DR.strDireccion, DR.strEMail, DR.strColonia,
		DR.strRFC, DR.strNombreFiscal, DR.intCP, DR.strTelefono, DR.strCelular, DR.strDireccionFiscal, 	
		DR.isActivo, DR.IsBorrado, 
		DR.strUsuarioAlta, DR.strMaquinaAlta, DR.datFechaAlta, DR.strUsuarioMod, DR.strMaquinaMod, DR.datFechaMod
	FROM  tbDoctor AS DR WITH(NOLOCK)
	WHERE DR.IsBorrado <> 1
		AND (DR.intDoctor = @intDoctor OR @intDoctor = 0)
END
go

go
--qry_Doctor_Del 5, 'MR-JOC'
alter PROCEDURE qry_Doctor_Del
	@intDoctor		INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbDoctor 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intDoctor = @intDoctor;

	select @intDoctor as Id;
END
go




go
--qry_Doctor_APP
alter PROCEDURE qry_Doctor_APP
	@strNombre				VARCHAR(500),
	@strApPaterno			VARCHAR(500),
	@strApMaterno			VARCHAR(500),
	@strDireccion			VARCHAR(500),
	@strEMail				VARCHAR(50),
	@strColonia				VARCHAR(500),
	@strRFC					VARCHAR(500),
	@strNombreFiscal		VARCHAR(500),
	@intCP					INT,
	@strTelefono			VARCHAR(500),
	@strCelular				VARCHAR(500),
	@strDireccionFiscal		VARCHAR(500),
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
	IF EXISTS(SELECT * FROM tbDoctor WHERE strNombre = @strNombre AND strApPaterno = @strApPaterno AND strApMaterno = @strApMaterno AND IsBorrado = 0 )
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrado un Doctor con estes nombre.'
		GOTO ERROR
	END
	
	INSERT tbDoctor(strNombre, strApPaterno, strApMaterno, strDireccion, strEMail, strColonia, strRFC, 
					strNombreFiscal, intCP, strTelefono, strCelular, strDireccionFiscal, 
					isActivo, isBorrado, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
	SELECT UPPER(@strNombre), UPPER(@strApPaterno), UPPER(@strApMaterno), @strDireccion, LOWER(@strEMail), @strColonia, @strRFC, @strNombreFiscal, @intCP, @strTelefono, @strCelular, @strDireccionFiscal,
					@IsActivo, isBorrado = 0, @strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbDoctor')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Doctor: '+UPPER(@strNombre)+' '+UPPER(@strApPaterno)+' '+UPPER(@strApMaterno)+'.' AS Mensaje;
	END	
	RETURN 0
END
go

go
--qry_getDoctor_Sel 1
alter PROCEDURE qry_getDoctor_Sel
@intDoctor INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		DR.intDoctor, DR.strNombre, DR.strApPaterno, DR.strApMaterno, DR.strDireccion, DR.strEMail, DR.strColonia,
		DR.strRFC, DR.strNombreFiscal, DR.intCP, DR.strTelefono, DR.strCelular, DR.strDireccionFiscal, 	
		DR.isActivo, DR.IsBorrado, 
		DR.strUsuarioAlta, DR.strMaquinaAlta, DR.datFechaAlta, DR.strUsuarioMod, DR.strMaquinaMod, DR.datFechaMod
	FROM  tbDoctor AS DR WITH(NOLOCK)
	WHERE DR.IsBorrado <> 1
		AND DR.intDoctor =  @intDoctor
END
go



go
alter PROCEDURE qry_Doctor_Upd
	@intDoctor				INT, 
	@strNombre				VARCHAR(500),
	@strApPaterno			VARCHAR(500),
	@strApMaterno			VARCHAR(500),
	@strDireccion			VARCHAR(500),
	@strEMail				VARCHAR(50),
	@strColonia				VARCHAR(500),
	@strRFC					VARCHAR(500),
	@strNombreFiscal		VARCHAR(500),
	@intCP					INT,
	@strTelefono			VARCHAR(500),
	@strCelular				VARCHAR(500),
	@strDireccionFiscal		VARCHAR(500),
	@IsActivo				BIT,
	@strUsuario				NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT

	UPDATE tbDoctor 
	SET
		strNombre = @strNombre,
		strApPaterno = @strApPaterno,
		strApMaterno = @strApMaterno,
		strDireccion = @strDireccion,
		strEMail = @strEMail,
		strColonia = @strColonia,
		strRFC = @strRFC,
		strNombreFiscal = @strNombreFiscal,
		intCP = @intCP,
		strTelefono = @strTelefono,
		strCelular = @strCelular,
		strDireccionFiscal = @strDireccionFiscal,
		IsActivo			= @IsActivo,
		strUsuarioMod		= @strUsuario,
		strMaquinaMod		= @strUsuario,
		datFechaMod			= GETDATE()
	WHERE intDoctor = @intDoctor

	SELECT @intDoctor AS Id, 'Datos actualizados, ID: '+CONVERT(VARCHAR(10), @intDoctor)+'.' AS Mensaje;

END
go


























