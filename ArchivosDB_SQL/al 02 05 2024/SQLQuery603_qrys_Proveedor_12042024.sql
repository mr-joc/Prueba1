USE LabAllCeramic
go

--
go
--qry_V2_Proveedor_APP 'Metroyinealy', 'ML', 1, 'MR-JOC'
alter PROCEDURE qry_V2_Proveedor_APP
	@strNombre				NVARCHAR(200), 
	@strNombreCorto			NVARCHAR(200),  
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

	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT * FROM tbProveedor2024 WHERE strNombre = @strNombre AND IsBorrado = 0 )
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrada una Proveedor con estes nombre.'
		GOTO ERROR
	END
	
	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS CON LOS MISMOS NOMBRES CORTOS
	IF EXISTS(SELECT * FROM tbProveedor2024 WHERE strNombreCorto = @strNombreCorto AND IsBorrado = 0 )
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrada una Proveedor con esta abreviatura.'
		GOTO ERROR
	END

	INSERT tbProveedor2024(strNombre,strNombreCorto,IsActivo,IsBorrado,
						strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT UPPER(@strNombre), UPPER(@strNombreCorto), @IsActivo, 0, 
			@strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbProveedor2024')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Proveedor: '+UPPER(@strNombre)+'.' AS Mensaje;
	END	
	RETURN 0
END
go


go
--qry_V2_Proveedor_Upd 1, 'METROss', 'mss', 1, 'MR-JOC'
alter PROCEDURE qry_V2_Proveedor_Upd
	@intProveedor		INT, 
	@strNombre			NVARCHAR(200), 
	@strNombreCorto		NVARCHAR(200), 
	@IsActivo			BIT,
	@strUsuario			NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT

	UPDATE tbProveedor2024 
	SET 
		strNombre			= UPPER(@strNombre),
		strNombreCorto		= UPPER(@strNombreCorto),
		IsActivo			= @IsActivo,
		strUsuarioMod		= @strUsuario,
		strMaquinaMod		= @strUsuario,
		datFechaMod			= GETDATE()
	WHERE intProveedor = @intProveedor

	SELECT @intProveedor AS Id, 'Datos actualizados, ID: '+CONVERT(VARCHAR(10), @intProveedor)+'.' AS Mensaje;

END
go


go
--qry_V2_Proveedor_Del 7, 'MR-JOC'
alter PROCEDURE qry_V2_Proveedor_Del
	@intProveedor	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbProveedor2024 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intProveedor = @intProveedor;

	select @intProveedor as Id;
END
go

--
go
--qry_V2_Proveedor_Sel @intProveedor = 0, @intActivo = 1
alter PROCEDURE qry_V2_Proveedor_Sel
	 @intProveedor INT = 0
	,@intActivo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SET @intActivo = ISNULL(@intActivo, 0)

	SELECT
		UM.intProveedor, UM.strNombre, UM.strNombreCorto,
		UM.IsActivo,UM.IsBorrado,
		UM.strUsuarioAlta,UM.strMaquinaAlta,UM.datFechaAlta,UM.strUsuarioMod,UM.strMaquinaMod,UM.datFechaMod
		FROM tbProveedor2024 AS UM WITH(NOLOCK)
	WHERE IsBorrado <> 1
		AND (UM.intProveedor = @intProveedor OR @intProveedor = 0)
			AND (UM.isActivo = @intActivo OR @intActivo = 0)
END
go

 

 
EXEC qry_V2_Proveedor_APP 'x1', 'x1', 1, 'MR-JOC'; 
go 
EXEC qry_V2_Proveedor_APP 'x2', 'x2', 1, 'MR-JOC'; 
go 


 EXEC qry_V2_Proveedor_Upd 1, 'PROVEEDOR SIN NOMBRE', 'PROV1', 1, 'MR-JOC' ;
 EXEC qry_V2_Proveedor_Upd 2, 'PROVEEDOR SIN NOMBRE 2', 'PROV2', 1, 'MR-JOC' ;


  