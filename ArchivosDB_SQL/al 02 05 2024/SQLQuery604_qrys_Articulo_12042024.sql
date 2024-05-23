USE LabAllCeramic
go

--

go
--qry_V2_Articulo_APP 'prtnum', 'articulo de prueba para eliminar y todo',1 ,1,1,1,1,1, 1, 'MR-JOC'
alter PROCEDURE qry_V2_Articulo_APP
	@strPartNum					NVARCHAR(150), 
	@strPartDesc				NVARCHAR(4000),  
	@intUnidadMedidaCompra		INT,
	@dblConversion_Comp_Alm		NUMERIC(18,4),			
	@intUnidadMedidaAlmacen		INT,
	@dblConversion_Alm_Vta		NUMERIC(18,4),
	@intUnidadMedidaVenta		INT,
	@intProveedorBase			INT,
	@IsActivo					BIT,
	@strUsuario					NVARCHAR(50)
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
	IF @strPartNum = 'JOC'
	BEGIN
		SELECT @MensajeError =  'El nombre de "JOC" no es válido y se coloca para marcar error .'
		GOTO ERROR
	END	

	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT * FROM tbArticulo2024 WHERE PartNum = @strPartNum AND IsBorrado = 0 )
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrada una Articulo con estes nombre.'
		GOTO ERROR
	END
	
	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS CON LOS MISMOS NOMBRES CORTOS
	IF EXISTS(SELECT * FROM tbArticulo2024 WHERE PartDesc = @strPartDesc AND IsBorrado = 0 )
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrada una Articulo con esta abreviatura.'
		GOTO ERROR
	END

	INSERT tbArticulo2024(PartNum,PartDesc,intUnidadMedidaCompra,dblConversionCompraAlmacen,intUnidadMedidaAlmacen,dblConversionAlmacenVenta,intUnidadMedidaVenta,
						intProveedorBase,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT UPPER(@strPartNum), UPPER(@strPartDesc), @intUnidadMedidaCompra, @dblConversion_Comp_Alm,@intUnidadMedidaAlmacen,@dblConversion_Alm_Vta,@intUnidadMedidaVenta,
			1, @IsActivo, 0, @strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbArticulo2024')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Articulo: '+UPPER(@strPartDesc)+'.' AS Mensaje;
	END	
	RETURN 0
END
go


go
--qry_V2_Articulo_Upd 17, 'prtnum1', 'articulo de prueba para eliminar y todo1',1 ,2,1,2,1,2, 0, 'MR-JOC'
alter PROCEDURE qry_V2_Articulo_Upd
	@intArticulo				INT, 
	@strPartNum					NVARCHAR(150), 
	@strPartDesc				NVARCHAR(4000),  
	@intUnidadMedidaCompra		INT,
	@dblConversion_Comp_Alm		NUMERIC(18,4),			
	@intUnidadMedidaAlmacen		INT,
	@dblConversion_Alm_Vta		NUMERIC(18,4),
	@intUnidadMedidaVenta		INT,
	@intProveedorBase			INT,
	@IsActivo					BIT,
	@strUsuario					NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT

	UPDATE tbArticulo2024 
	SET 
		PartNum							= UPPER(@strPartNum),
		PartDesc						= UPPER(@strPartDesc),
		intUnidadMedidaCompra			= @intUnidadMedidaCompra,
		dblConversionCompraAlmacen		= @dblConversion_Comp_Alm,
		intUnidadMedidaAlmacen			= @intUnidadMedidaAlmacen,
		dblConversionAlmacenVenta		= @dblConversion_Alm_Vta,
		intUnidadMedidaVenta			= @intUnidadMedidaVenta,
		intProveedorBase				= @intProveedorBase,
		IsActivo						= @IsActivo,
		strUsuarioMod					= @strUsuario,
		strMaquinaMod					= @strUsuario,
		datFechaMod						= GETDATE()
	WHERE intArticulo = @intArticulo

	SELECT @intArticulo AS Id, 'Datos actualizados, '+@strPartDesc+' ('+@strPartNum+').' AS Mensaje;

END
go


go
--qry_V2_Articulo_Del 17, 'MR-JOC'
alter PROCEDURE qry_V2_Articulo_Del
	@intArticulo	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbArticulo2024 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intArticulo = @intArticulo;

	select @intArticulo as Id;
END
go


--update  tbArticulo2024 set isborrado=0, isactivo = 0 where intarticulo = 17


go
--qry_V2_Articulo_Sel @intArticulo = 0, @intActivo = 1
alter PROCEDURE qry_V2_Articulo_Sel
	 @intArticulo INT = 0
	,@intActivo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SET @intActivo = ISNULL(@intActivo, 0)

	SELECT
		ART.intArticulo, 
		ART.PartNum, ART.PartDesc,
		strNombreCorto = ART.PartNum, strNombre = ART.PartDesc,
		ART.intUnidadMedidaCompra, strUMCompra = UMC.strNombre,
		ART.dblConversionCompraAlmacen,
		ART.intUnidadMedidaAlmacen, strUMAlmacen = UMA.strNombre,
		ART.dblConversionAlmacenVenta,
		ART.intUnidadMedidaVenta, strUMVenta = UMV.strNombre,
		ART.intProveedorBase,
		strProVeedor = PRV.strNombre,
		ART.IsActivo,ART.IsBorrado,
		ART.strUsuarioAlta,ART.strMaquinaAlta,ART.datFechaAlta,ART.strUsuarioMod,ART.strMaquinaMod,ART.datFechaMod
	FROM tbArticulo2024				AS ART WITH(NOLOCK)
		JOIN tbUnidadMedida2024		AS UMC WITH(NOLOCK) ON UMC.intUnidadMedida = ART.intUnidadMedidaCompra
		JOIN tbUnidadMedida2024		AS UMA WITH(NOLOCK) ON UMA.intUnidadMedida = ART.intUnidadMedidaAlmacen
		JOIN tbUnidadMedida2024		AS UMV WITH(NOLOCK) ON UMV.intUnidadMedida = ART.intUnidadMedidaVenta
		JOIN tbProveedor2024		AS PRV WITH(NOLOCK) ON PRV.intProveedor = ART.intProveedorBase
	WHERE ART.IsBorrado <> 1
		AND (ART.intArticulo = @intArticulo OR @intArticulo = 0)
			AND (ART.isActivo = @intActivo OR @intActivo = 0)
END
go

 
 qry_V2_Articulo_Sel @intArticulo = 0, @intActivo = 1


 


