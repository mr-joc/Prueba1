USE Dev1
go

select * from tbMovimientos ORDER BY intnumempleado, intMes
go

go
--qry_MovimientosXMes_APP 26, 2,55, 'MR-JOC'
alter PROCEDURE qry_MovimientosXMes_APP
	@intNumEmpleado			INT,
	@intMes					INT,
	@intCantidadEntregas	INT,
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

		

	DECLARE @ID INT, @intEmpleadoID INT, @isOperativo BIT

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END

	SELECT TOP 1 
		@intEmpleadoID =  ISNULL(EMP.intEmpleadoID, 0),
		@isOperativo = ROL.isOperativo
	FROM tbEmpleados AS EMP WITH(NOLOCK)
		JOIN tbRoles AS ROL WITH(NOLOCK) ON ROL.intRol = EMP.intRol
	WHERE EMP.intNumEmpleado = @intNumEmpleado

	SELECT @intEmpleadoID = ISNULL(@intEmpleadoID, 0), @isOperativo = ISNULL(@isOperativo, 0)

	PRINT '@intEmpleadoID = '+CONVERT(VARCHAR(10), @intEmpleadoID)
	
	--ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	IF @intEmpleadoID = 0
	BEGIN
		SELECT @MensajeError =  'El empleado con el número "'+CONVERT(VARCHAR(10), @intNumEmpleado)+'" NO EXISTE.'
		GOTO ERROR
	END
	
	--SI NO ES OPERATIVO, NO PUEDE REGISTRAR ENTREGAS
	IF @isOperativo = 0
	BEGIN
		SELECT @MensajeError =  'Este empleado es ADMINISTRATIVO, por lo cual no puede tener registro de entregas.'
		GOTO ERROR
	END
	
	--EN CASO DE QUE TRATEMOS DE REGISTRAR DOS EMPLEADOS CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT * FROM tbMovimientos WHERE intMes = @intMes AND intNumEmpleado = @intNumEmpleado AND intEmpleadoID = @intEmpleadoID)
	BEGIN
		SELECT @MensajeError =  'Ya Registraste los datos para este Empleado en el mes que intentas hacerlo.'
		GOTO ERROR
	END	

	INSERT tbMovimientos(intEmpleadoID,intNumEmpleado,intMes,intCantidadEntregas,IsBorrado,
						strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT @intEmpleadoID, @intNumEmpleado, @intMes, @intCantidadEntregas, 0, 
			@strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbMovimientos')
				
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
		'Se generó el ID: "'+CONVERT(VARCHAR(10), @ID)+'" para este movimiento.' AS Mensaje;
	END	
	RETURN 0
END 
go