USE AllCeramic2024
go




go
--qry_Color_Sel 0
alter PROCEDURE qry_Color_Sel
@intColorID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		intColorID = CL.intColor, 
		CL.strNombre,
		CL.intColorimetro,
		strColorimetro = CM.strNombre,
		CL.IsActivo,CL.IsBorrado,
		CL.strUsuarioAlta,CL.strMaquinaAlta,CL.datFechaAlta,CL.strUsuarioMod,CL.strMaquinaMod,CL.datFechaMod
		FROM tbColor AS CL WITH(NOLOCK)
			JOIN tbColorimetro AS CM WITH(NOLOCK) ON CM.intColorimetro = CL.intColorimetro
	WHERE CL.IsBorrado <> 1
		AND (CL.intColor = @intColorID OR @intColorID = 0)
END
go




 

go
--qry_Color_Del 17, 'MR-JOC'
alter PROCEDURE qry_Color_Del
	@intColor	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbColor 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intColor = @intColor;

	select @intColor as Id;
END
go



go
--qry_Color_APP 
alter PROCEDURE qry_Color_APP
	@strNombre				NVARCHAR(500), 
	@intColorimetro			INT,
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
	IF @strNombre = 'JOC'
	BEGIN
		SELECT @MensajeError =  'El nombre de "JOC" no es válido y se coloca para marcar error .'
		GOTO ERROR
	END
	
	--EN CASO DE QUE TRATEMOS DE REGISTRAR DOS EMPLEADOS CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT * FROM tbColor WHERE strNombre = @strNombre AND intColorimetro = @intColorimetro AND isBorrado = 0)
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrado un Color con este Nombre y para este colorímetro.'
		GOTO ERROR
	END
	
	

	INSERT tbColor(strNombre, intColorimetro, isActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta, IsBorrado)
	SELECT strNombre = UPPER(@strNombre), intColorimetro = @intColorimetro, 
		isActivo = @IsActivo, strUsuarioAlta = UPPER(@strUsuarioGuarda), strMaquinaAlta = UPPER(@strUsuarioGuarda), datFechaAlta = GETDATE(), IsBorrado = 0
	

	SET @ID = IDENT_CURRENT('tbColor')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Color: '+@strNombre+'.' AS Mensaje;
	END	
	RETURN 0
END
go





go
--qry_getColor_Sel 1
alter PROCEDURE qry_getColor_Sel
@intColorID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		intColorID = CL.intColor, 
		CL.strNombre,
		CL.intColorimetro,
		strColorimetro = CM.strNombre,
		CL.IsActivo,CL.IsBorrado,
		CL.strUsuarioAlta,CL.strMaquinaAlta,CL.datFechaAlta,CL.strUsuarioMod,CL.strMaquinaMod,CL.datFechaMod
		FROM tbColor AS CL WITH(NOLOCK)
			JOIN tbColorimetro AS CM WITH(NOLOCK) ON CM.intColorimetro = CL.intColorimetro
	WHERE CL.intColor = @intColorID
END
go

 

go
alter PROCEDURE qry_Color_Upd	
	@intColorID				INT,
	@strNombre				NVARCHAR(500), 
	@intColorimetro			INT,
	@IsActivo				BIT,
	@strUsuarioGuarda		NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT 

	UPDATE tbColor 
	SET 
		strNombre			= UPPER(@strNombre),
		intColorimetro			= @intColorimetro,
		isActivo			= @IsActivo,
		strUsuarioMod		= @strUsuarioGuarda,
		strMaquinaMod		= @strUsuarioGuarda,
		datFechaMod			= GETDATE()
	WHERE intColor = @intColorID

	SELECT @intColorID AS Id, 'Datos actualizados, Color: '+@strNombre+'.' AS Mensaje;

END
go





go
--qry_ListarColorimetrosActivos_SEL 0
alter  PROCEDURE qry_ListarColorimetrosActivos_SEL  
    @intColorimetro INT = NULL
AS   
BEGIN
	SET @intColorimetro = ISNULL(@intColorimetro, 0) 

	SET NOCOUNT ON;
    SELECT intColorimetro, strNombreColorimetro=strNombre, isActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod
	FROM tbColorimetro WITH(NOLOCK)
    WHERE isActivo = 1
		AND (intColorimetro = @intColorimetro or @intColorimetro = 0)
END
go


