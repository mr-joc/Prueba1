USE AllCeramic2024
go


--UPDATE tbMenu SET Vista = 'Material', Controlador = 'Material' where intmenu = 27



go
--qry_Material_Sel 0
alter PROCEDURE qry_Material_Sel
@intMaterial INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		MAT.intMaterial, MAT.strNombre, MAT.strNombreCorto,
		MAT.IsActivo,MAT.IsBorrado,
		MAT.strUsuarioAlta,MAT.strMaquinaAlta,MAT.datFechaAlta,MAT.strUsuarioMod,MAT.strMaquinaMod,MAT.datFechaMod
		FROM tbMaterial AS MAT WITH(NOLOCK)
	WHERE IsBorrado <> 1
		AND (MAT.intMaterial = @intMaterial OR @intMaterial = 0)
END
go



go
--qry_Material_Del 5, 'MR-JOC'
alter PROCEDURE qry_Material_Del
	@intMaterial	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbMaterial 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intMaterial = @intMaterial;

	select @intMaterial as Id;
END
go




go
--qry_Material_APP 'otro ROL', 1, 1, 'MR-JOC'
alter PROCEDURE qry_Material_APP
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
	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS ROLES CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT * FROM tbMaterial WHERE strNombre = @strNombre AND IsBorrado = 0 )
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrado un Material con estes nombre.'
		GOTO ERROR
	END

	INSERT tbMaterial(strNombre,strNombreCorto,IsActivo,IsBorrado,
						strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT UPPER(@strNombre), UPPER(@strNombreCorto), @IsActivo, 0, 
			@strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbMaterial')
				
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
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el Material: '+UPPER(@strNombre)+'.' AS Mensaje;
	END	
	RETURN 0
END 
go


go
--qry_getMaterial_Sel 1
alter PROCEDURE qry_getMaterial_Sel
@intMaterial INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT MAT.intMaterial, MAT.strNombre, MAT.strNombreCorto, MAT.isActivo, MAT.IsBorrado, 
		MAT.strUsuarioAlta, MAT.strMaquinaAlta, MAT.datFechaAlta, MAT.strUsuarioMod, MAT.strMaquinaMod, MAT.datFechaMod
	FROM  tbMaterial AS MAT WITH(NOLOCK)
	WHERE MAT.IsBorrado <> 1
		AND MAT.intMaterial= @intMaterial
END
go




go
--qry_Material_Upd 1, 'sistemas', 1, 1, 'MR-JOC'
alter PROCEDURE qry_Material_Upd
	@intMaterial		INT, 
	@strNombre			NVARCHAR(200), 
	@strNombreCorto		NVARCHAR(200), 
	@IsActivo			BIT,
	@strUsuario			NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT

	UPDATE tbMaterial 
	SET 
		strNombre			= UPPER(@strNombre),
		strNombreCorto		= UPPER(@strNombreCorto),
		IsActivo			= @IsActivo,
		strUsuarioMod		= @strUsuario,
		strMaquinaMod		= @strUsuario,
		datFechaMod			= GETDATE()
	WHERE intMaterial = @intMaterial

	SELECT @intMaterial AS Id, 'Datos actualizados, ID: '+CONVERT(VARCHAR(10), @intMaterial)+'.' AS Mensaje;

END
go

