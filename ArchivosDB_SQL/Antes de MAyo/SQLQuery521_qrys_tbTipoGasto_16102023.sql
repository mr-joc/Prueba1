USE AllCeramic2024
go


--UPDATE tbMenu SET Vista = 'TipoGasto', Controlador='TipoGasto' WHERE intMenu = 48

go
--qry_TipoGasto_Sel 0
alter PROCEDURE qry_TipoGasto_Sel
@intTipoGasto INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		TG.intTipoGasto, TG.strNombre, TG.strNombreCorto,
		TG.IsActivo,TG.IsBorrado,
		TG.strUsuarioAlta,TG.strMaquinaAlta,TG.datFechaAlta,TG.strUsuarioMod,TG.strMaquinaMod,TG.datFechaMod
		FROM tbTipoGasto AS TG WITH(NOLOCK)
	WHERE IsBorrado <> 1
		AND (TG.intTipoGasto = @intTipoGasto OR @intTipoGasto = 0)
END
go



go
--qry_TipoGasto_Del 5, 'MR-JOC'
alter PROCEDURE qry_TipoGasto_Del
	@intTipoGasto	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE tbTipoGasto 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intTipoGasto = @intTipoGasto;

	select @intTipoGasto as Id;
END
go




go
--qry_TipoGasto_APP 'otro ROL', 1, 1, 'MR-JOC'
alter PROCEDURE qry_TipoGasto_APP
	@strNombre				NVARCHAR(200), 
	@strNombreCorto			NVARCHAR(200),  
	@IsActivo				BIT,
	@strUsuario				NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- -----------------------------------------------------------------------------------------
	-- DECLARACI�N DE VARIABLES
	-- -----------------------------------------------------------------------------------------
	DECLARE
		 @RESULT			INT
		,@MensajeError		VARCHAR(256)	--	Mensaje de Error
		,@TranCount			INT				--	@@TRANCOUNT
		,@BitInsert			BIT				--	Usaremos este bit para declarar si se inserta o no, creo que nos sirve en la fase de desarrollo para las pruebas :)
		,@MensajeResultado	VARCHAR(256)	--	Mensaje de Resultado

		

	DECLARE @ID INT

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacci�n, inciar una
	BEGIN
		BEGIN TRANSACTION
	END
	
	--ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	IF @strNombre = 'JOC'
	BEGIN
		SELECT @MensajeError =  'El nombre de "JOC" no es v�lido y se coloca para marcar error .'
		GOTO ERROR
	END	
	--EN CASO DE QUE QUERAMOS DE REGISTRAR DOS ROLES CON LOS MISMOS NOMBRES
	IF EXISTS(SELECT * FROM tbTipoGasto WHERE strNombre = @strNombre AND IsBorrado = 0 )
	BEGIN
		SELECT @MensajeError =  'Ya tienes registrado un TipoGasto con estes nombre.'
		GOTO ERROR
	END

	INSERT tbTipoGasto(strNombre,strNombreCorto,IsActivo,IsBorrado,
						strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT UPPER(@strNombre), UPPER(@strNombreCorto), @IsActivo, 0, 
			@strUsuario, @strUsuario, GETDATE()
	
	SET @ID = IDENT_CURRENT('tbTipoGasto')
				
	--SUPONIENDO QUE TODO SALI� BIEN NOS VAMOS A BRINCAR A LA SECCI�N DE FIN
	GOTO FIN
	-- -----------------------------------------------------------------------------------------
	-- CUALQUIER SP, INSERT, VALIDACI�N, ETC QUE NO FUNCIONE BIEN HACE QUE NOS VAYAMOS DIRECTO A ESTA SECCI�N DE ERROR
	-- EN ELLA SOLO TOMAMOS EL TEXTO PREVIAMENTE ASIGNADO AL ERROR PARA MOSTRARLO Y HACEMOS UN ROLLBACK
	ERROR:
	-- -----------------------------------------------------------------------------------------
	IF @TranCount = 0	--	Si hay una transacci�n, hacer rollback
	BEGIN		
		IF @@TRANCOUNT <> 0
		BEGIN
			ROLLBACK TRANSACTION
		END
	END
	RAISERROR(@MensajeError, 16, 1)
	RETURN 1

	-- -----------------------------------------------------------------------------------------
	-- AQUI EN LA SECCI�N DE FIN HACEMOS EL COMMIT Y DEVOLVEMOS LAS PALABRAS "INICIO" O "FIN" PARA QUE LA VISTA SEPA QUE HACER
	FIN:
	-- -----------------------------------------------------------------------------------------
	IF @TranCount = 0	--	Si hay una transacci�n, hacer un commit
	BEGIN
		IF @@TRANCOUNT <> 0
		BEGIN
			COMMIT TRANSACTION
		END
		SELECT @ID AS Id, 
		'Se ha generado el ID: '+CONVERT(VARCHAR(10), @ID)+', para el TipoGasto: '+UPPER(@strNombre)+'.' AS Mensaje;
	END	
	RETURN 0
END 
go


go
--qry_getTipoGasto_Sel 1
alter PROCEDURE qry_getTipoGasto_Sel
@intTipoGasto INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TG.intTipoGasto, TG.strNombre, TG.strNombreCorto, TG.isActivo, TG.IsBorrado, 
		TG.strUsuarioAlta, TG.strMaquinaAlta, TG.datFechaAlta, TG.strUsuarioMod, TG.strMaquinaMod, TG.datFechaMod
	FROM  tbTipoGasto AS TG WITH(NOLOCK)
	WHERE TG.IsBorrado <> 1
		AND TG.intTipoGasto= @intTipoGasto
END
go




go
--qry_TipoGasto_Upd 1, 'sistemas', 1, 1, 'MR-JOC'
alter PROCEDURE qry_TipoGasto_Upd
	@intTipoGasto		INT, 
	@strNombre			NVARCHAR(200), 
	@strNombreCorto		NVARCHAR(200), 
	@IsActivo			BIT,
	@strUsuario			NVARCHAR(50)

AS
BEGIN
	DECLARE @ID INT

	UPDATE tbTipoGasto 
	SET 
		strNombre			= UPPER(@strNombre),
		strNombreCorto		= UPPER(@strNombreCorto),
		IsActivo			= @IsActivo,
		strUsuarioMod		= @strUsuario,
		strMaquinaMod		= @strUsuario,
		datFechaMod			= GETDATE()
	WHERE intTipoGasto = @intTipoGasto

	SELECT @intTipoGasto AS Id, 'Datos actualizados, ID: '+CONVERT(VARCHAR(10), @intTipoGasto)+'.' AS Mensaje;

END
go

