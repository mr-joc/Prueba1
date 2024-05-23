



go
--qry_V2_AutorizarFabricacionOrden_APP @intOrdenLaboratorioEnc =6658, @strUsuario = 'MR-JOC'
alter PROCEDURE qry_V2_AutorizarFabricacionOrden_APP
	@intOrdenLaboratorioEnc		INT,
	@strUsuario					NVARCHAR(50)
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

		

	DECLARE @ID INT		--, @FaltaRevision INT
		,@intExisteOrdenAutorizada INT

	--SET @FaltaRevision = 0
	SET @intExisteOrdenAutorizada = 0

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacci�n, inciar una
	BEGIN
		BEGIN TRANSACTION
	END

	--SELECT 
	--	@FaltaRevision = 1
	--FROM tbOrdenLaboratorioDet AS DET WITH(NOLOCK)
	--	JOIN tbTipoTrabajo2024 AS TT4 WITH(NOLOCK) ON TT4.intTipoTrabajo = DET.intTipoTrabajo
	--WHERE DET.intOrdenLaboratorioEnc = @intOrdenLaboratorioEnc
	--	AND TT4.btRevisado = 0

	SELECT 
		@intExisteOrdenAutorizada = 1 
	FROM tbJobHead
	WHERE OrderHead = @intOrdenLaboratorioEnc
		AND isAutorizadoEnd = 1

	----IF @FaltaRevision = 1
	----BEGIN
	----	SELECT @MensajeError =  'Al menos uno de los Trabajos que componen esta orden no ha sido revisado, no se puede pasar a producci�n.'
	----	GOTO ERROR
	----END	

	IF @intExisteOrdenAutorizada = 1
	BEGIN
		SELECT @MensajeError =  'Esta orden ya se autoriz� para ser fabricada.'
		GOTO ERROR
	END	
	
	--ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	IF @strUsuario = 'no es jorge'
	BEGIN
		SELECT @MensajeError =  'El nombre de "JOC" no es v�lido y se coloca para marcar error .'
		GOTO ERROR
	END
	
	PRINT 'HACEMOS UPDATE A "tbJobHead"'
	UPDATE tbJobHead
	SET isAutorizadoEnd = 1
	WHERE OrderHead = @intOrdenLaboratorioEnc
	--SI MARCA ERROR LO ASIGNAMOS
	IF @@ERROR <> 0
	BEGIN
		SELECT @MensajeError =  'Hubo problemas al hacer el UPDATE de "tbJobHead".'
		GOTO ERROR
	END
	PRINT 'Termina el UPDATE de "tbJobHead"'

	
	
	SET @ID = @intOrdenLaboratorioEnc
				
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
		SELECT 
			Id = @ID,
			Mensaje =  'Se autoriz� la fabricaci�n de la orden: '+CONVERT(VARCHAR(10), @ID)+'.' 
	END	
	RETURN 0
END
go


--qry_V2_AutorizarFabricacionOrden_APP @intOrdenLaboratorioEnc =6745, @strUsuario = 'MR-JOC'
go



/*
	UPDATE tbJobHead
	SET isAutorizadoEnd = 0
	WHERE OrderHead = 6745

*/
