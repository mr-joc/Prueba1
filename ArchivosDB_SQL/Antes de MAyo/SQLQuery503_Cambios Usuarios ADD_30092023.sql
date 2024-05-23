USE AllCeramic2024
go



go
--qry_Usuario_Sel 0
alter PROCEDURE [dbo].[qry_Usuario_Sel]
@intUsuarioID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		intUsuarioID = EMP.intUsuario, strUsuario, strNombres = EMP.strNombre, strApPaterno = EMP.strApPaterno, strApMaterno = EMP.strApMaterno, intNumUsuario = EMP.intUsuario,
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

--qry_Usuario_Sel  @intUsuarioID = 0
go

select * from segUsuarios 
go
--qry_Usuario_APP 'jorgre alberto', 'rOVIEDO',' rCERDA', 26, 1, 1, 'MR-JOC'
alter PROCEDURE qry_Usuario_APP
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
--qry_getUsuario_Sel 1
alter PROCEDURE qry_getUsuario_Sel
@intUsuarioID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		intUsuarioID = EMP.intUsuario, strNombres = EMP.strNombre, strApPaterno = EMP.strApPaterno, strApMaterno = EMP.strApMaterno, strContrasena = EMP.strPassword, strContrasena2 = EMP.strPassword,
		EMP.intRol,
		strNombreRol = ROL.strNombre,
		EMP.IsActivo,EMP.IsBorrado,EMP.strUsuarioAlta,EMP.strMaquinaAlta,EMP.datFechaAlta
	FROM segUsuarios AS EMP WITH(NOLOCK)
		JOIN tbRoles AS ROL WITH(NOLOCK) ON ROL.intRol = EMP.intRol
	WHERE EMP.IsBorrado <> 1
		AND EMP.intUsuario = @intUsuarioID
END
go


qry_getUsuario_Sel 1
go








