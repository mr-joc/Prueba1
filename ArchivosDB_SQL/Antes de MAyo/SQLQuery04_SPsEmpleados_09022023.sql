USE Dev1
go

--SELECT * FROM tbEmpleados

go
--qry_getDatosEmpleado_Sel 26
alter PROCEDURE qry_getDatosEmpleado_Sel
@intNumEmpleado INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		EMP.intEmpleadoID,strNombreCompleto = EMP.strNombres+' '+EMP.strApPaterno+' '+EMP.strApMaterno,
		EMP.intNumEmpleado,
		EMP.intRol,
		intMes = 1,
		strNombreRol = ROL.strNombre,
		EMP.IsActivo,EMP.IsBorrado,EMP.strUsuarioAlta,EMP.strMaquinaAlta,EMP.datFechaAlta
	FROM tbEmpleados AS EMP WITH(NOLOCK)
		JOIN tbRoles AS ROL WITH(NOLOCK) ON ROL.intRol = EMP.intRol
	WHERE EMP.IsBorrado <> 1
		AND EMP.intNumEmpleado = @intNumEmpleado
END
go


go
--qry_getEmpleado_Sel 1
alter PROCEDURE qry_getEmpleado_Sel
@intEmpleadoID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		EMP.intEmpleadoID,EMP.strNombres,EMP.strApPaterno,EMP.strApMaterno,EMP.intNumEmpleado,
		EMP.intRol,
		strNombreRol = ROL.strNombre,
		EMP.IsActivo,EMP.IsBorrado,EMP.strUsuarioAlta,EMP.strMaquinaAlta,EMP.datFechaAlta
	FROM tbEmpleados AS EMP WITH(NOLOCK)
		JOIN tbRoles AS ROL WITH(NOLOCK) ON ROL.intRol = EMP.intRol
	WHERE EMP.IsBorrado <> 1
		AND EMP.intEmpleadoID = @intEmpleadoID
END
go



go
--qry_Empleado_Upd 1, 'jorge alberto','oviedo', 'cerda', 27, 1, 1, 'MR-JOC'
alter PROCEDURE qry_Empleado_Upd
	@intEmpleadoID		NVARCHAR(50), 
	@strNombres			NVARCHAR(200), 
	@strApPaterno		NVARCHAR(200), 
	@strApMaterno		NVARCHAR(200), 
	@intNumEmpleado		INT,
	@intRol				INT,
	@IsActivo			BIT,
	@strUsuario			NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT 

	UPDATE tbEmpleados 
	SET 
		strNombres		= UPPER(@strNombres),
		strApPaterno	= UPPER(@strApPaterno),
		strApMaterno	= UPPER(@strApMaterno),
		intNumEmpleado	= @intNumEmpleado,
		intRol			= @intRol,
		IsActivo		= @IsActivo,
		strUsuarioMod	= @strUsuario,
		strMaquinaMod	= @strUsuario,
		datFechaMod		= GETDATE()
	WHERE intEmpleadoID = @intEmpleadoID

	SELECT @intEmpleadoID AS Id, 'Datos actualizados, ID: '+CONVERT(VARCHAR(10), @intEmpleadoID)+'.' AS Mensaje;

END
go



go
--qry_Empleado_Sel 0
alter PROCEDURE [dbo].[qry_Empleado_Sel]
@intEmpleadoID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		EMP.intEmpleadoID,EMP.strNombres,EMP.strApPaterno,EMP.strApMaterno,EMP.intNumEmpleado,
		EMP.intRol,
		strRol = ROL.strNombre,
		EMP.IsActivo,EMP.IsBorrado,
		EMP.strUsuarioAlta,EMP.strMaquinaAlta,EMP.datFechaAlta,EMP.strUsuarioMod,EMP.strMaquinaMod,EMP.datFechaMod
		FROM tbEmpleados AS EMP WITH(NOLOCK)
			JOIN tbRoles AS ROL WITH(NOLOCK) ON ROL.intRol = EMP.intRol
	WHERE EMP.IsBorrado <> 1
		AND (EMP.intEmpleadoID = @intEmpleadoID OR @intEmpleadoID = 0)
END
go



go
--qry_Empleado_Del 17, 'MR-JOC'
alter PROCEDURE qry_Empleado_Del
	@intEmpleadoID	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbEmpleados 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intEmpleadoID = @intEmpleadoID;

	select @intEmpleadoID as Id;
END
go

--SELECT * fROM tbEmpleados

go
--qry_Empleado_APP 'jorgre alberto', 'rOVIEDO',' rCERDA', 26, 1, 1, 'MR-JOC'
alter PROCEDURE qry_Empleado_APP
	@strNombres				NVARCHAR(200), 
	@strApPaterno			NVARCHAR(200), 
	@strApMaterno			NVARCHAR(200), 
	@intNumEmpleado			INT,
	@intRol					INT,
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
	IF @strNombres = 'JOC'
	BEGIN
		SELECT @MensajeError =  'El nombre de "JOC" no es válido y se coloca para marcar error .'
		GOTO ERROR
	END
	
	--EN CASO DE QUE TRATEMOS DE REGISTRAR DOS EMPLEADOS CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT * FROM tbEmpleados WHERE strNombres = @strNombres AND strApPaterno = @strApPaterno AND strApMaterno = @strApMaterno)
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrado un empleado con estos mismos nombres.'
		GOTO ERROR
	END
	
	--NO PODEMOS REGISTRAR DOS EMPLEADOS CON EL MISMO NUMERO Y DIFERENTES NOMBRES
	IF EXISTS(SELECT * FROM tbEmpleados WHERE intNumEmpleado = @intNumEmpleado AND (strNombres <> @strNombres OR strApPaterno <> @strApPaterno OR strApMaterno <> @strApMaterno))
	BEGIN
		SELECT @MensajeError =  'Ya existe un empleado con el número .'+CONVERT(VARCHAR(10), @intNumEmpleado)+' registrado.'
		GOTO ERROR
	END

	

	INSERT tbEmpleados(strNombres,strApPaterno,strApMaterno,intNumEmpleado,intRol,IsActivo,IsBorrado,
						strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT UPPER(@strNombres), UPPER(@strApPaterno), UPPER(@strApMaterno), @intNumEmpleado, @intRol, @IsActivo, 0, 
			@strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbEmpleados')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el empleado '+CONVERT(VARCHAR(10), @intNumEmpleado)+'.' AS Mensaje;
	END	
	RETURN 0
END 
go
