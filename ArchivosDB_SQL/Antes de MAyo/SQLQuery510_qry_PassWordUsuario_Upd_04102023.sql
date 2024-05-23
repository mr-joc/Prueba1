USE AllCeramic2024
go


UPDATE tbMenu SET strDescripcion= 'Cambiar Contraseña' ,Vista = 'CambiarPassWord', Controlador = 'Usuario' WHERE intMenu = 14

go
--qry_PassWordUsuario_Upd 'jorgre alberto', 'rOVIEDO',' rCERDA', 26, 1, 1, 'MR-JOC'
alter PROCEDURE qry_PassWordUsuario_Upd
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


qry_PassWordUsuario_Upd @strUsuario = 'mr-joc',  @strPassword = 'c4l4b4z4', @strNewPass1 = 'c4l4b4z4', @strNewPass2 = 'c4l4b4z4', @strUsuarioGuarda = 'MR-JOC'
go






--