USE AllCeramic2024
go


--UPDATE tbMenu SET Vista = 'TipoTrabajo', Controlador = 'TipoTrabajo' where intmenu = 28


go
--qry_TipoTrabajo_Sel 0
alter PROCEDURE qry_TipoTrabajo_Sel
@intTipoTrabajoID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		TTR.intTipoTrabajo, intTipoTrabajoID = TTR.intTipoTrabajo, 
		TTR.strNombre,
		TTR.strNombreCorto,
		TTR.intMaterial,
		strMaterial = MAT.strNombre,
		TTR.dblPrecio, TTR.dblPrecioUrgencia,
		TTR.IsActivo,TTR.IsBorrado,
		TTR.strUsuarioAlta,TTR.strMaquinaAlta,TTR.datFechaAlta,TTR.strUsuarioMod,TTR.strMaquinaMod,TTR.datFechaMod
		FROM tbTipoTrabajo AS TTR WITH(NOLOCK)
			JOIN tbMaterial AS MAT WITH(NOLOCK) ON MAT.intMaterial = TTR.intMaterial
	WHERE TTR.IsBorrado <> 1
		AND (TTR.intTipoTrabajo = @intTipoTrabajoID OR @intTipoTrabajoID = 0)
END
go



go
--qry_TipoTrabajo_Del 17, 'MR-JOC'
alter PROCEDURE qry_TipoTrabajo_Del
	@intTipoTrabajo	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbTipoTrabajo 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intTipoTrabajo = @intTipoTrabajo;

	select @intTipoTrabajo as Id;
END
go



go
--qry_TipoTrabajo_APP 'jorgre alberto', 'rOVIEDO',' rCERDA', 26, 1, 1, 'MR-JOC'
alter PROCEDURE qry_TipoTrabajo_APP
	@strNombre				NVARCHAR(500), 
	@strNombreCorto			NVARCHAR(500), 
	@intMaterial			INT,
	@dblPrecio				DECIMAL(10, 2),
	@dblPrecioUrgencia		DECIMAL(10, 2),
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
	IF EXISTS(SELECT * FROM tbTipoTrabajo WHERE strNombre = @strNombre AND strNombreCorto = @strNombreCorto AND intMaterial = @intMaterial)
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrado un Tipo de Trabajo con estas mismas características.'
		GOTO ERROR
	END
	
	

	INSERT tbTipoTrabajo(strNombre, strNombreCorto, intMaterial, dblPrecio, dblPrecioUrgencia, isActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta, IsBorrado)
	SELECT strNombre = UPPER(@strNombre), strNombreCorto = UPPER(@strNombreCorto), intMaterial = @intMaterial, dblPrecio = @dblPrecio, dblPrecioUrgencia = @dblPrecioUrgencia, 
		isActivo = @IsActivo, strUsuarioAlta = UPPER(@strUsuarioGuarda), strMaquinaAlta = UPPER(@strUsuarioGuarda), datFechaAlta = GETDATE(), IsBorrado = 0
	

	SET @ID = IDENT_CURRENT('tbTipoTrabajo')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Tipo de Trabajo: '+@strNombre+'.' AS Mensaje;
	END	
	RETURN 0
END
go


 

go
--qry_getTipoTrabajo_Sel 1
alter PROCEDURE qry_getTipoTrabajo_Sel
@intTipoTrabajoID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		intTipoTrabajoID = TTR.intTipoTrabajo, 
		TTR.strNombre,
		TTR.strNombreCorto,
		TTR.intMaterial,
		strMaterial = MAT.strNombre,
		TTR.dblPrecio, TTR.dblPrecioUrgencia,
		TTR.IsActivo,TTR.IsBorrado,
		TTR.strUsuarioAlta,TTR.strMaquinaAlta,TTR.datFechaAlta,TTR.strUsuarioMod,TTR.strMaquinaMod,TTR.datFechaMod
		FROM tbTipoTrabajo AS TTR WITH(NOLOCK)
			JOIN tbMaterial AS MAT WITH(NOLOCK) ON MAT.intMaterial = TTR.intMaterial
	WHERE TTR.intTipoTrabajo = @intTipoTrabajoID
END
go



 
go
--qry_TipoTrabajo_Upd 5, 'jorgedlberto','oviedo', 'cerda', 27, 1, 1, 'MR-JOC'
alter PROCEDURE qry_TipoTrabajo_Upd	
	@intTipoTrabajoID			INT,
	@strNombre				NVARCHAR(500), 
	@strNombreCorto			NVARCHAR(500), 
	@intMaterial			INT,
	@dblPrecio				DECIMAL(10, 2),
	@dblPrecioUrgencia		DECIMAL(10, 2),
	@IsActivo				BIT,
	@strUsuarioGuarda		NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT 

	UPDATE tbTipoTrabajo 
	SET 
		strNombre			= UPPER(@strNombre),
		strNombreCorto		= UPPER(@strNombreCorto), 
		intMaterial			= @intMaterial,
		isActivo			= @IsActivo,
		dblPrecio			= @dblPrecio,
		dblPrecioUrgencia	= @dblPrecioUrgencia,
		strUsuarioMod		= @strUsuarioGuarda,
		strMaquinaMod		= @strUsuarioGuarda,
		datFechaMod			= GETDATE()
	WHERE intTipoTrabajo = @intTipoTrabajoID

	SELECT @intTipoTrabajoID AS Id, 'Datos actualizados, Tipo de Trabajo: '+@strNombre+'.' AS Mensaje;

END
go


 


go
--qry_ListarMaterialesActivos_SEL 0
alter  PROCEDURE qry_ListarMaterialesActivos_SEL  
    @intMaterial INT = NULL
AS   
BEGIN
	SET @intMaterial = ISNULL(@intMaterial, 0) 

	SET NOCOUNT ON;
    SELECT intMaterial, strNombreMaterial=strNombre, isActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod
	FROM tbMaterial WITH(NOLOCK)
    WHERE isActivo = 1
		AND (intMaterial = @intMaterial or @intMaterial = 0)
END
go


UPDATE tbTipoTrabajo SET isactivo =1, isborrado =0 where inttipotrabajo = 64



select * from tbTipoTrabajo
