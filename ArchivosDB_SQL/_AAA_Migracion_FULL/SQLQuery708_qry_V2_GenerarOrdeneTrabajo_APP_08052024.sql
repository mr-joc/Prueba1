USE LabAllCeramic
go




go
--qry_V2_GenerarOrdeneTrabajo_APP @intOrdenLaboratorioEnc =6658, @strUsuario = 'MR-JOC'
alter PROCEDURE qry_V2_GenerarOrdeneTrabajo_APP
	@intOrdenLaboratorioEnc		INT,
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

		

	DECLARE @ID INT, @FaltaRevision INT, @intExisteOrden INT

	SET @FaltaRevision = 0
	SET @intExisteOrden = 0

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END

	SELECT 
		@FaltaRevision = 1
	FROM tbOrdenLaboratorioDet AS DET WITH(NOLOCK)
		JOIN tbTipoTrabajo2024 AS TT4 WITH(NOLOCK) ON TT4.intTipoTrabajo = DET.intTipoTrabajo
	WHERE DET.intOrdenLaboratorioEnc = @intOrdenLaboratorioEnc
		AND TT4.btRevisado = 0

	SELECT 
		@intExisteOrden = 1 
	FROM tbOrderJob
	WHERE OrderHead = @intOrdenLaboratorioEnc

	IF @FaltaRevision = 1
	BEGIN
		SELECT @MensajeError =  'Al menos uno de los Trabajos que componen esta orden no ha sido revisado, no se puede pasar a producción.'
		GOTO ERROR
	END	

	IF @intExisteOrden = 1
	BEGIN
		SELECT @MensajeError =  'Esta orden ya fue procesada.'
		GOTO ERROR
	END	
	
	--ESTA SOLO ES UNA PRUEBA PARA VER SI FUNCIONA
	IF @strUsuario = 'no es jorge'
	BEGIN
		SELECT @MensajeError =  'El nombre de "JOC" no es válido y se coloca para marcar error .'
		GOTO ERROR
	END	

	
	
	SELECT DET1.intOrdenLaboratorioEnc, DET1.intOrdenLaboratorioDet,
		RowID = (ROW_NUMBER() OVER( ORDER BY DET1.intOrdenLaboratorioDet))
	INTO #tbReleases
	FROM tbOrdenLaboratorioDet AS DET1
	WHERE DET1.intOrdenLaboratorioEnc = @intOrdenLaboratorioEnc 
	ORDER BY intOrdenLaboratorioDet

	INSERT tbOrderJob(OrderHead,intOrdenLaboratorioDet,OrderDtl,OrderRel,jobNum,strPieza,intMaterial,intTipoTrabajo,intTipoProtesis,intProceso,intColorimetro,intColor,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT 
		DET.intOrdenLaboratorioEnc, REL.intOrdenLaboratorioDet, 
		REL.RowID,
		l.indice, 
		jobNum = CONVERT(VARCHAR(10), DET.intOrdenLaboratorioEnc)+'-'+CONVERT(VARCHAR(10), REL.RowID)+'-'+CONVERT(VARCHAR(10), l.indice),
		l.Dato,DET.intMaterial, DET.intTipoTrabajo, /*DET.intCantidad,*/
		ENC.intTipoProtesis, ENC.intProceso, ENC.intColorimetro, ENC.intColor, strUsuarioAlta = @strUsuario, strMaquinaAlta = @strUsuario, datFechaAlta = GETDATE()
		
	FROM tbOrdenLaboratorioDet		AS DET WITH(NOLOCK)
		JOIN tbOrdenLaboratorioEnc	AS ENC WITH(NOLOCK) ON DET.intOrdenLaboratorioEnc = ENC.intOrdenLaboratorioEnc
		JOIN #tbReleases			AS REL WITH(NOLOCK) ON DET.intOrdenLaboratorioEnc = REL.intOrdenLaboratorioEnc AND DET.intOrdenLaboratorioDet = REL.intOrdenLaboratorioDet
		OUTER APPLY (  
						SELECT 
						X.Poscicion	AS Indice,
						X.[Name]	AS [Dato] 
						FROM dbo.splitdashstring_JOC((REPLACE(DET.intPieza, ',', '~'))) X  
		) L  
	WHERE DET.intOrdenLaboratorioEnc = @intOrdenLaboratorioEnc
	ORDER BY ENC.intOrdenLaboratorioEnc, DET.intOrdenLaboratorioDet


	INSERT tbJobHead(OrderHead,OrderDtl,OrderRel,jobNum,PartDesc,intMaterial,strMaterial,intTipoTrabajo,strTipoTrabajo,
		intTipoProtesis,strTipoProtesis,intProceso,strProceso,intColorimetro,strColorimetro,intColor,strColor,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT 
		OJ.OrderHead,OJ.OrderDtl,OJ.OrderRel,OJ.jobNum,
		PartDesc =  MAT.strNombre+'~'+TRA.strNombre+ '~'+PRI.strNombreTipoProtesis+ '~'+PRO.strNombreProceso+ '~'+ CLI.strNombre + '~'+CLO.strNombre,--
		OJ.intMaterial,
		strMaterial = MAT.strNombre,
		OJ.intTipoTrabajo,
		strTipoTrabajo = TRA.strNombre,
		OJ.intTipoProtesis,
		strTipoProtesis = PRI.strNombreTipoProtesis,
		OJ.intProceso,
		strProceso = PRO.strNombreProceso,
		OJ.intColorimetro,
		strColorimetro =  CLI.strNombre,
		OJ.intColor,
		strColor = CLO.strNombre,
		strUsuarioAlta = @strUsuario, strMaquinaAlta = @strUsuario, datFechaAlta = GETDATE()
	FROM tbOrderJob					AS  OJ WITH(NOLOCK)
		JOIN tbMaterial2024			AS MAT WITH(NOLOCK) ON MAT.intMaterial =  OJ.intMaterial
		JOIN tbTipoTrabajo2024		AS TRA WITH(NOLOCK) ON TRA.intTipoTrabajo =  OJ.intTipoTrabajo
		JOIN tbTipoProtesis2024		AS PRI WITH(NOLOCK) ON PRI.intTipoProtesis =  OJ.intTipoProtesis
		JOIN tbProceso2024			AS PRO WITH(NOLOCK) ON PRO.intProceso =  OJ.intProceso
		JOIN tbColorimetro2024		AS CLI WITH(NOLOCK) ON CLI.intColorimetro =  OJ.intColorimetro
		JOIN tbColor2024			AS CLO WITH(NOLOCK) ON CLO.intColor =  OJ.intColor
	WHERE OJ.OrderHead = @intOrdenLaboratorioEnc

	

	SELECT 
		intTipoTrabajo, oprSeqFinal = 10000
	INTO #OperFin
	FROM tbJobHead AS JH WITH(NOLOCK) 
	WHERE JH.OrderHead = @intOrdenLaboratorioEnc
	GROUP BY intTipoTrabajo

	UPDATE OFI 
	SET OFI.oprSeqFinal = (SELECT MAX(OPR.Seq) FROM tbOperacionXTipoTrabajo	AS OPR WITH(NOLOCK) WHERE OPR.intTipoTrabajo = OFI.intTipoTrabajo)
	FROM #OperFin AS OFI

	UPDATE OPR
	SET  OPR.TypeOpr = 'TQ'
		,OPR.strUsuarioMod = 'qry_V2_GenerarOrdeneTrabajo_APP // Está operación pasó de "BF" a "TQ" por ser la última (en AUTOMÁTICO)'
		,OPR.strMaquinaMod = @strUsuario
		,OPR.datFechaMod = GETDATE()
	--SELECT OPP.intTipoTrabajo, OPP.oprSeqFinal, OPR.*
	FROM #OperFin AS OPP
		JOIN tbOperacionXTipoTrabajo	AS OPR WITH(NOLOCK) ON OPP.intTipoTrabajo = OPR.intTipoTrabajo AND OPR.Seq = OPP.oprSeqFinal
	WHERE OPR.TypeOpr = 'BF'

	INSERT tbJobOper(JobNum, OpComplete, intOperacion, OprSeq, OpDesc, LaborEntryMethod, strUsuarioAlta, strMaquinaAlta, datFechaAlta)
	SELECT JH.jobNum, OpComplete = 0, intOperacion = OPR.intOperacion, OprSeq = OPR.Seq, OpDesc = OPR.strDescripcion, LaborEntryMethod = OPR.TypeOpr, strUsuarioAlta = @strUsuario, strMaquinaAlta = @strUsuario, datFechaAlta = GETDATE()
	FROM tbJobHead						AS  JH WITH(NOLOCK)
		JOIN tbOperacionXTipoTrabajo	AS OPR WITH(NOLOCK) ON JH.intTipoTrabajo = OPR.intTipoTrabajo
	WHERE JH.OrderHead = @intOrdenLaboratorioEnc
	ORDER BY JH.jobNum, OPR.Seq

	--SELECT * FROM tbOperacionXTipoTrabajo

	INSERT tbJobMTL(jobNum,PartNum,PartDescription,RelatedOperation,MtlSeq,CantReq,UM,CantUtilizada,IssuedComplete,BackFlush,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
	SELECT JH.jobNum, PartNum = ART.PartNum, PartDescription = ART.PartDesc, RelatedOperation = OPR.Seq, MtlSeq = (((ROW_NUMBER() OVER( ORDER BY JH.jobNum, OPR.Seq, MAT.intOperacionTipoTrabajoMaterial))) * 10),  
			CantReq = MAT.dblCantidad, UM = UMM.strNombreCorto, CantUtilizada = 0, IssuedComplete = 0, BackFlush = 0,
			strUsuarioAlta = @strUsuario, strMaquinaAlta = @strUsuario, datFechaAlta = GETDATE()
	FROM tbJobHead							AS  JH WITH(NOLOCK)
		JOIN tbOperacionXTipoTrabajo		AS OPR WITH(NOLOCK) ON JH.intTipoTrabajo = OPR.intTipoTrabajo
		JOIN tbOperacionTipoTrabajoMaterial	AS MAT WITH(NOLOCK) ON MAT.intOperacionXTipoTrabajo = OPR.intOperacionXTipoTrabajo
		JOIN tbArticulo2024					AS ART WITH(NOLOCK) ON ART.intArticulo = MAT.intArticulo
		JOIN tbUnidadMedida2024				AS UMM WITH(NOLOCK) ON MAT.intUnidadMedida = UMM. intUnidadMedida
	WHERE JH.OrderHead = @intOrdenLaboratorioEnc
	ORDER BY JH.jobNum, OPR.Seq, MAT.intOperacionTipoTrabajoMaterial
	
	
	SET @ID = @intOrdenLaboratorioEnc
				
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
			Id = @ID,
			Mensaje =  'Se generaron los datos de trabajo para la orden: '+CONVERT(VARCHAR(10), @ID)+'.' 
	END	
	RETURN 0
END
go



