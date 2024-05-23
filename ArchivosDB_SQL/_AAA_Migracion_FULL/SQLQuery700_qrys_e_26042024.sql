USE LabAllCeramic
go




go
alter PROCEDURE BuscaTablas
(      
@Buscar VarChar(4000),  
@strOrden VARCHAR(10) =  NULL    
)      
AS  
BEGIN  
	SET NOCOUNT ON
	
	SELECT 
		ID=OBJ.object_id,
		Tabla=INF.TABLE_NAME,
		Creada=OBJ.create_date,
		Modificada=OBJ.modify_date,
		SELECCION = 'SELECT TOP 100 Tabla='''+INF.TABLE_NAME+''', * FROM '+INF.TABLE_NAME+' WITH (NOLOCK)'
	INTO #Result  
	FROM Information_Schema.Tables AS INF
		INNER JOIN sys.objects AS OBJ ON OBJ.name = INF.TABLE_NAME
	WHERE INF.table_type = 'BASE TABLE' 
		AND INF.TABLE_NAME LIKE '%' + @Buscar + '%' 
   
	IF @strOrden IS NULL  
	BEGIN
		SELECT R.ID, R.Tabla, R.Creada, R.Modificada, R.SELECCION
		FROM #Result AS R
		ORDER BY R.ID
	END  
	ELSE  
	BEGIN  
		IF @strOrden = 'M'  
		BEGIN
			SELECT R.ID, R.Tabla, R.Creada, R.Modificada, R.SELECCION
			FROM #Result AS R
			ORDER BY R.Modificada DESC
		END  
		IF @strOrden = 'C'  
		BEGIN  
			SELECT R.ID, R.Tabla, R.Creada, R.Modificada, R.SELECCION
			FROM #Result AS R
			ORDER BY R.Creada DESC
		END  
		IF @strOrden = 'N'  
		BEGIN
			SELECT R.ID, R.Tabla, R.Creada, R.Modificada, R.SELECCION
			FROM #Result AS R
			ORDER BY R.Tabla DESC
		END  
	END  
END
go





--qry_V2_Operacion_Sel @intOperacion = 0, @intActivo = 1


go
--qry_V2_OperacionXTipoTranajo_Sel @intTipoTrabajo = 3
alter PROCEDURE qry_V2_OperacionXTipoTranajo_Sel
	 @intTipoTrabajo INT
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		OP.intOperacionXTipoTrabajo,
		OP.intOperacion,
		OP.intTipoTrabajo,
		OP.Seq,
		OP.TypeOpr,
		OP.strDescripcion,
		OP.strDescripcionTrabajo,
		IsActivo = CAST(1 AS BIT), 
		intUltimaOperacion = (SELECT MAX(S.Seq) FROM tbOperacionXTipoTrabajo AS S WITH(NOLOCK) WHERE S.intTipoTrabajo = @intTipoTrabajo)
	FROM tbOperacionXTipoTrabajo	AS OP WITH(NOLOCK)
	WHERE intTipoTrabajo = @intTipoTrabajo
	ORDER BY OP.Seq
END
go


GO
--qry_V2_OperacionXTipoTrabajo_APP @intOperacion = 6, @intTipoTrabajo = 1, @TypeOer = 'BF', @strUsuario = 'MR-JOC'
alter PROCEDURE qry_V2_OperacionXTipoTrabajo_APP
	@intOperacion		INT, 
	@intTipoTrabajo		INT,  
	@TypeOer			NVARCHAR(6),
	@strUsuario			NVARCHAR(50)
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

		

	DECLARE @ID INT, @NuevaSeq INT, @Descripcion NVARCHAR(500), @DescTrabajo NVARCHAR(2000)

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END
	
	--ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	IF @TypeOer = 'JOC'
	BEGIN
		SELECT @MensajeError =  'El nombre de "JOC" no es válido y se coloca para marcar error .'
		GOTO ERROR
	END	

	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT intOperacionXTipoTrabajo FROM tbOperacionXTipoTrabajo WHERE intOperacion = @intOperacion AND intTipoTrabajo = @intTipoTrabajo)
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrada la Operacion para este tipo de trabajo.'
		GOTO ERROR
	END

	--SELECT @NuevaSeq = 1000
	SELECT @Descripcion = strNombre FROM tbOperacion WHERE intOperacion = @intOperacion
	SELECT @DescTrabajo = TRA.strNombre+' // '+MAT.strNombre
	FROM tbTipoTrabajo2024	AS TRA WITH(NOLOCK)
		JOIN tbMaterial2024 AS MAT WITH(NOLOCK) ON MAT.intMaterial = TRA.intMaterial
	WHERE TRA.intTipoTrabajo = @intTipoTrabajo


	IF NOT EXISTS(SELECT intOperacionXTipoTrabajo FROM tbOperacionXTipoTrabajo WHERE intOperacion = 1 AND intTipoTrabajo = @intTipoTrabajo)
	BEGIN
		INSERT tbOperacionXTipoTrabajo(intOperacion,intTipoTrabajo,Seq,TypeOpr,strDescripcion,strDescripcionTrabajo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
		SELECT intOperacion = 1, intTipoTrabajo = @intTipoTrabajo, Seq =  5, TypeOpr = 'TQ', strDescripcion = 'YESOS' ,strDescripcionTrabajo = @DescTrabajo,strUsuarioAlta = @strUsuario, strMaquinaAlta = @strUsuario, datFechaAlta = GETDATE()

		SET @NuevaSeq = 10

		UPDATE tbTipoTrabajo2024
		SET btRevisado = 1
		WHERE intTipoTrabajo = @intTipoTrabajo
	END
	ELSE
	BEGIN
		DECLARE @Registros INT
		SELECT @Registros = COUNT(intOperacionXTipoTrabajo) FROM tbOperacionXTipoTrabajo WHERE intTipoTrabajo = @intTipoTrabajo

		SET @NuevaSeq = 10 * (CASE @Registros WHEN 2 THEN @Registros ELSE (@Registros + 0) END)
	END

	INSERT tbOperacionXTipoTrabajo(intOperacion, intTipoTrabajo, Seq, TypeOpr, strDescripcion, strDescripcionTrabajo,
						strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT @intOperacion, @intTipoTrabajo, @NuevaSeq, @TypeOer, @Descripcion, @DescTrabajo, 
			@strUsuario, @strUsuario, GETDATE()

	UPDATE tbTipoTrabajo2024
	SET btRevisado = 1
	WHERE intTipoTrabajo = @intTipoTrabajo
	
	SET @ID = IDENT_CURRENT('tbOperacionXTipoTrabajo')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Operacion: '+UPPER(@Descripcion)+' y el tipo dee trabajo: '+UPPER(@DescTrabajo)+'.' AS Mensaje;
	END	
	RETURN 0
END
GO


GO
--qry_V2_MoverOperacionXTipoTrabajo_UPD @intOperacion = 13, @intTipoTrabajo = 2, @bitSubirOperacion = 1, @strUsuario = 'MR-JOC'
alter PROCEDURE qry_V2_MoverOperacionXTipoTrabajo_UPD
	@intOperacion		INT, 
	@intTipoTrabajo		INT,  
	@bitSubirOperacion	BIT,
	@strUsuario			NVARCHAR(50)
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

		

	DECLARE @ID INT, @SeqActual INT, @NuevaSeq INT, @SeqAnterior INT, @intOperXTrabajoSube INT, @intOperXTrabajoBaja INT, @intUltimaOperacion INT

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END
	
	SELECT @intUltimaOperacion = MAX(seq) FROM  tbOperacionXTipoTrabajo WHERE intTipoTrabajo = @intTipoTrabajo
	
	SELECT @SeqActual = Seq FROM tbOperacionXTipoTrabajo WHERE intOperacion = @intOperacion AND intTipoTrabajo = @intTipoTrabajo 
	
	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS CON LOS MISMOS NOMBRES
	IF (@SeqActual = 10 AND @bitSubirOperacion = 1)
	BEGIN
		SELECT @MensajeError =  'Esta operación no puede subir más allá de su lugar actual.'
		GOTO ERROR
	END

	
	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS CON LOS MISMOS NOMBRES
	IF (@SeqActual = @intUltimaOperacion AND @bitSubirOperacion = 0)
	BEGIN
		SELECT @MensajeError =  'Esta operación no puede bajar más allá de su lugar actual.'
		GOTO ERROR
	END


	IF @bitSubirOperacion = 1
	BEGIN
		SET @NuevaSeq = (SELECT MAX(Seq) FROM tbOperacionXTipoTrabajo WHERE intTipoTrabajo = @intTipoTrabajo And Seq < @SeqActual)
		SET @intOperXTrabajoSube = (SELECT intOperacionXTipoTrabajo FROM tbOperacionXTipoTrabajo WHERE intOperacion = @intOperacion AND intTipoTrabajo = @intTipoTrabajo)
		SET @intOperXTrabajoBaja = (SELECT intOperacionXTipoTrabajo FROM tbOperacionXTipoTrabajo WHERE intTipoTrabajo = @intTipoTrabajo  And Seq = @NuevaSeq)
		
		UPDATE tbOperacionXTipoTrabajo
		SET Seq = @NuevaSeq
		WHERE intOperacionXTipoTrabajo = @intOperXTrabajoSube
		
		UPDATE tbOperacionXTipoTrabajo
		SET Seq = @SeqActual
		WHERE intOperacionXTipoTrabajo = @intOperXTrabajoBaja


		--SELECT '@SeqActual' = @SeqActual, '@NuevaSeq'= @NuevaSeq, '@intOperXTrabajoSube'=@intOperXTrabajoSube, '@intOperXTrabajoBaja' = @intOperXTrabajoBaja
		SET @ID = @intOperXTrabajoSube
	END
	ELSE
	BEGIN
		SET @NuevaSeq = (SELECT MIN(Seq) FROM tbOperacionXTipoTrabajo WHERE intTipoTrabajo = @intTipoTrabajo And Seq > @SeqActual)
		SET @intOperXTrabajoBaja = (SELECT intOperacionXTipoTrabajo FROM tbOperacionXTipoTrabajo WHERE intOperacion = @intOperacion AND intTipoTrabajo = @intTipoTrabajo)
		SET @intOperXTrabajoSube = (SELECT intOperacionXTipoTrabajo FROM tbOperacionXTipoTrabajo WHERE intTipoTrabajo = @intTipoTrabajo  And Seq = @NuevaSeq)
		
		
		UPDATE tbOperacionXTipoTrabajo
		SET Seq = @SeqActual
		WHERE intOperacionXTipoTrabajo = @intOperXTrabajoSube
		
		UPDATE tbOperacionXTipoTrabajo
		SET Seq = @NuevaSeq
		WHERE intOperacionXTipoTrabajo = @intOperXTrabajoBaja


		--SELECT '@SeqActual' = @SeqActual, '@NuevaSeq' = @NuevaSeq, '@intOperXTrabajoBaja' = @intOperXTrabajoBaja, '@intOperXTrabajoSube' = @intOperXTrabajoSube

		SET @ID = @intOperXTrabajoSube
	END

				
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
		SELECT 
			@ID AS Id, 
			'Se ha modificó el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Operacion.' 
			AS Mensaje;
	END	
	RETURN 0
END
GO


/*
--DROP TABLE tbOperacionXTipoTrabajo_Eliminados

SELECT TOP 2
	intOperacionXTipoTrabajo,intOperacion,intTipoTrabajo,Seq,TypeOpr,
	strDescripcion = strDescripcion+strDescripcion+strDescripcion+strDescripcion,
	strDescripcionTrabajo = strDescripcionTrabajo+strDescripcionTrabajo+strDescripcionTrabajo,
	strUsuarioElimina = strUsuarioAlta+strUsuarioAlta+strUsuarioAlta+strUsuarioAlta+strUsuarioAlta+strUsuarioAlta+strUsuarioAlta+strUsuarioAlta,
	datFechaElimina = CAST(GETDATE() as DATETIME)
	INTO tbOperacionXTipoTrabajo_Eliminados
FROM tbOperacionXTipoTrabajo WHERE intTipoTrabajo = 2

ALTER TABLE tbOperacionXTipoTrabajo_Eliminados ADD intOperacionXTipoTrabajo_Real INT 
UPDATE tbOperacionXTipoTrabajo_Eliminados set intOperacionXTipoTrabajo_Real  = 0 

ALTER TABLE tbOperacionXTipoTrabajo_Eliminados ALTER COLUMN intOperacionXTipoTrabajo_Real INT  NOT NULL


*/


go
--qry_V2_OperacionXTipoTrabajo_Del 7, 'MR-JOC'
alter PROCEDURE qry_V2_OperacionXTipoTrabajo_Del
	@intOperacion		INT,
	@intTipoTrabajoID	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	INSERT tbOperacionXTipoTrabajo_Eliminados(intOperacionXTipoTrabajo_Real,intOperacion,intTipoTrabajo,Seq,TypeOpr,strDescripcion,strDescripcionTrabajo,
		strUsuarioElimina,datFechaElimina)
	SELECT intOperacionXTipoTrabajo,intOperacion,intTipoTrabajo,Seq,TypeOpr,strDescripcion,strDescripcionTrabajo,
		strUsuarioElimina = @strUsuario, datFechaElimina = GETDATE()
	FROM tbOperacionXTipoTrabajo 
	WHERE intOperacion = @intOperacion
		AND intTipoTrabajo = @intTipoTrabajoID 

	DELETE FROM tbOperacionXTipoTrabajo
	WHERE intOperacion = @intOperacion
		AND intTipoTrabajo = @intTipoTrabajoID

	SELECT 
		NewSeq = 10 * (ROW_NUMBER() OVER(ORDER BY Seq)) ,
		intOperacionXTipoTrabajo, intOperacion, Seq, strDescripcion
	INTO #SeqOrdenadas
	FROM tbOperacionXTipoTrabajo
	WHERE intTipoTrabajo = @intTipoTrabajoID
		AND intOperacion <> 1
	ORDER BY Seq

	UPDATE OPER
	SET OPER.Seq = ORDEN.NewSeq
	--SELECT * 
	FROM #SeqOrdenadas					AS ORDEN WITH(NOLOCK)
		JOIN tbOperacionXTipoTrabajo	AS  OPER WITH(NOLOCK) ON ORDEN.intOperacionXTipoTrabajo = OPER.intOperacionXTipoTrabajo

	select @intOperacion as Id;
END
go



 


go
--qry_V2_Material_Sel @intMaterial = 0, @intActivo = 1
alter PROCEDURE qry_V2_Material_Sel
	 @intMaterial INT
	,@intActivo INT = NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	SET @intActivo = ISNULL(@intActivo, 0)

	SELECT
		MAT.intMaterial, MAT.strNombre, MAT.strNombreCorto,
		MAT.IsActivo,MAT.IsBorrado,
		MAT.strUsuarioAlta,MAT.strMaquinaAlta,MAT.datFechaAlta,MAT.strUsuarioMod,MAT.strMaquinaMod,MAT.datFechaMod
		FROM tbMaterial2024 AS MAT WITH(NOLOCK)
	WHERE IsBorrado <> 1
		AND (MAT.intMaterial = @intMaterial OR @intMaterial = 0)
			AND (MAT.isActivo = @intActivo OR @intActivo = 0)
END
go



--qry_V2_OperacionXTipoTrabajo_Del @intOperacion = 3, @intTipoTrabajoID = 2, @strUsuario = 'MR-JOC'
go 


--qry_V2_MoverOperacionXTipoTrabajo_UPD @intOperacion = 16, @intTipoTrabajo = 2, @bitSubirOperacion = 0, @strUsuario = 'MR-JOC'
go

--qry_V2_OperacionXTipoTrabajo_APP @intOperacion = 25, @intTipoTrabajo= 2, @TypeOer = 'BF', @strUsuario = 'MR-JOC'
go

--qry_V2_OperacionXTipoTranajo_Sel @intTipoTrabajo = 2
go


--SELECT * FROM tbOperacionXTipoTrabajo_Eliminados
--DELETE FROM tbOperacionXTipoTrabajo_Eliminados

--delete FROM tbOperacionXTipoTrabajo WHERE intTipoTrabajo = 2
--SELECT * FROM tbOperacionTipoTrabajoMaterial


--qry_V2_Articulo_Sel @intArticulo = 0, @intActivo = 1
                 



--SELECT * FROM tbOperacionXTipoTrabajo WHERE intTipoTrabajo = 7 ORDER BY Seq
--SELECT * FROM tbOperacionTipoTrabajoMaterial WHERE intOperacionXTipoTrabajo IN (5,62,63,64,65,66,67,68,69,70,71,72) Order BY intOperacionXTipoTrabajo



go
--qry_V2_MaterialXOperacionTipoTrabajo_Sel @intOperacionTipoTrabajo = 2
alter PROCEDURE qry_V2_MaterialXOperacionTipoTrabajo_Sel
	 @intOperacionTipoTrabajo INT
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		 OPM.intOperacionTipoTrabajoMaterial
		,OPM.intOperacionXTipoTrabajo
		,OPM.intArticulo
		,strArticulo = ART.PartDesc
		,dblCantidad = CAST(OPM.dblCantidad AS DECIMAL(10, 2))
		,OPM.intUnidadMedida
		,strUMArt = UMM.strNombre
		,IsActivo = CAST(1 AS BIT)
		--intUltimaOperacion = (SELECT MAX(S.Seq) FROM tbOperacionXTipoTrabajo AS S WITH(NOLOCK) WHERE S.intTipoTrabajo = @intTipoTrabajo)
	FROM tbOperacionTipoTrabajoMaterial	AS OPM WITH(NOLOCK)
		JOIN tbArticulo2024				AS ART WITH(NOLOCK) ON ART.intArticulo = OPM.intArticulo
		JOIN tbUnidadMedida2024			AS UMM WITH(NOLOCK) ON UMM.intUnidadMedida = OPM.intUnidadMedida
	WHERE intOperacionXTipoTrabajo = @intOperacionTipoTrabajo
	--ORDER BY OP.Seq
END
go



go
--qry_V2_MaterialXOperacionTipoTrabajo_APP @intOperacionXTipoTrabajo = 325, @intArticulo = 2, @dblCantidad = 20.3, @strUsuario = 'MR-JOC'
alter PROCEDURE qry_V2_MaterialXOperacionTipoTrabajo_APP
	@intOperacionXTipoTrabajo		INT, 
	@intArticulo					INT,  
	@dblCantidad					DECIMAL(10, 4),  
	@strUsuario						NVARCHAR(50)
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

		

	DECLARE @ID INT, @PartDesc NVARCHAR(4000), @intUM INT

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END
	
	--------ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	----IF @TypeOer = 'JOC'
	----BEGIN
	----	SELECT @MensajeError =  'El nombre de "JOC" no es válido y se coloca para marcar error .'
	----	GOTO ERROR
	----END	

	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT intOperacionXTipoTrabajo FROM tbOperacionTipoTrabajoMaterial WHERE intOperacionXTipoTrabajo = @intOperacionXTipoTrabajo AND intArticulo = @intArticulo)
	BEGIN
		SELECT @MensajeError =  'Ya Existe un registro para este material en esta operación.'
		GOTO ERROR
	END

	--SELECT @NuevaSeq = 1000
	SELECT @intUM = intUnidadMedidaVenta
	FROM tbArticulo2024	AS ART WITH(NOLOCK)
	WHERE ART.intArticulo = @intArticulo


	----IF NOT EXISTS(SELECT intOperacionXTipoTrabajo FROM tbOperacionXTipoTrabajo WHERE intOperacion = 1 AND intTipoTrabajo = @intTipoTrabajo)
	----BEGIN
	----	INSERT tbOperacionXTipoTrabajo(intOperacion,intTipoTrabajo,Seq,TypeOpr,strDescripcion,strDescripcionTrabajo,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	----	SELECT intOperacion = 1, intTipoTrabajo = @intTipoTrabajo, Seq =  5, TypeOpr = 'TQ', strDescripcion = 'YESOS' ,strDescripcionTrabajo = @DescTrabajo,strUsuarioAlta = @strUsuario, strMaquinaAlta = @strUsuario, datFechaAlta = GETDATE()

	----	SET @NuevaSeq = 10
	----END
	----ELSE
	----BEGIN
	----	DECLARE @Registros INT
	----	SELECT @Registros = COUNT(intOperacionXTipoTrabajo) FROM tbOperacionXTipoTrabajo WHERE intTipoTrabajo = @intTipoTrabajo

	----	SET @NuevaSeq = 10 * (CASE @Registros WHEN 2 THEN @Registros ELSE (@Registros + 0) END)
	----END

	INSERT tbOperacionTipoTrabajoMaterial(intOperacionXTipoTrabajo, intArticulo, dblCantidad, intUnidadMedida,
						strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT @intOperacionXTipoTrabajo, @intArticulo, @dblCantidad, @intUM, 
			@strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbOperacionTipoTrabajoMaterial')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+'.' AS Mensaje;
	END	
	RETURN 0
END
go



go
--qry_V2_OperacionXTipoTrabajo_Del 7, 'MR-JOC'
alter PROCEDURE qry_V2_MaterialXTipoTrabajo_Del
	@intOperacionXTipoTrabajoID	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	DELETE FROM tbOperacionTipoTrabajoMaterial
	WHERE intOperacionTipoTrabajoMaterial = @intOperacionXTipoTrabajoID

	select @intOperacionXTipoTrabajoID as Id;
END
go


--qry_V2_Operacion_Sel @intOperacion = 0, @intActivo = 1
  
qry_V2_OperacionXTipoTranajo_Sel @intTipoTrabajo = 38
go

qry_V2_MaterialXOperacionTipoTrabajo_Sel @intOperacionTipoTrabajo = 365
go
 
  

 --  SELECT  
 -- OP.intOperacionXTipoTrabajo , A.intArticulo,
 -- 'EXECUTE qry_V2_MaterialXOperacionTipoTrabajo_APP @intOperacionXTipoTrabajo = '+CONVERT(VARCHAR(10), OP.intOperacionXTipoTrabajo)+', @intArticulo = '+CONVERT(VARCHAR(10), A.intArticulo)
 -- +', @dblCantidad = '+CONVERT(VARCHAR(10), ((CASE A.intArticulo WHEN 1 THEN 200 ELSE 125 END)))+', @strUsuario = '+''''+'MR-JOC'+''';'
 --FROM tbOperacionXTipoTrabajo AS OP WITH(NOLOCK),  tbArticulo2024 AS A
 --WHERE OP.intTipoTrabajo IN (63,3,23,18,8,66,59,38,38)
 --AND A.intArticulo IN (1, 16)


 --SELECT * from tbArticulo2024



 /*

                

 */




--qry_V2_MaterialXOperacionTipoTrabajo_APP @intOperacionXTipoTrabajo = 325, @intArticulo = 2, @dblCantidad = 20.3, @strUsuario = 'MR-JOC'



/*
VistaConfiguracionMateriales-Form
MaterialesOpsFull-wrapper
MaterialesOpsXTrabajo-wrapper
*/

