USE LabAllCeramic
go



go
--spJobsOperaciones_UPD @JobNum = '6745-9', @intOperacion = 1, @strUsuario = 'MR-JOC'
alter PROCEDURE spJobsOperaciones_UPD
@JobNum			NVARCHAR(20),
@intOperacion	INT,
@strUsuario		NVARCHAR(50) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON	
	-- -----------------------------------------------------------------------------------------
	-- DECLARACIÓN DE VARIABLES
	-- -----------------------------------------------------------------------------------------
	DECLARE
		 @RESULT			INT
		,@MensajeError		VARCHAR(256)	--	Mensaje de Error
		,@NumError			INT				--	@@ERROR
		,@TranCount			INT				--	@@TRANCOUNT
		,@BitInsert			BIT				--	Usaremos este bit para declarar si se inserta o no, creo que nos sirve en la fase de desarrollo para las pruebas :)

	
	--MANDAMOS LA SEÑAL DE QUE SE INSERTE
	--SET @BitInsert = 0
	SET @BitInsert = 1
	PRINT 'Se asigna @BitInsert = '+CONVERT(VARCHAR(1500), @BitInsert)+' y con ello se declara si se puede insertar o no'



	
	CREATE TABLE #tbJobs(OrderHead BIGINT, OrderDtl INT, OrderRel INT, jobNum NVARCHAR(20), isOperacionEnd BIT)
	DECLARE @InicioFin AS TABLE (InicioFinID INT, NombrePaso NVARCHAR(300), Inicio BIT, Fin BIT)
	DECLARE @Status AS TABLE (EstatusID INT, OrderHead BIGINT, OrderDtl INT, OrderRel INT, jobNum NVARCHAR(20), Operacion INT, NombreOperacion NVARCHAR(100), NombrePaso NVARCHAR(200), [Status] NVARCHAR(200), Inicio BIT, Fin BIT, PuedeMarcar BIT, IsMarcado BIT, IsSiguienteOper BIT, IsDebeMarcar BIT )--

	DECLARE @Orden BIGINT, @Linea INT


	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
	END
	
	
	SET @JobNum = @JobNum+'-0'
	PRINT '@JobNum = '+@JobNum

	
	SELECT 
		@Orden=UPPER(SUBSTRING(@JobNum, 1, (CHARINDEX('-',@JobNum))-1)), 
		@Linea=SUBSTRING((SUBSTRING(@JobNum, (CHARINDEX('-',@JobNum))+1, 600)), 1, (CHARINDEX('-',(SUBSTRING(@JobNum, (CHARINDEX('-',@JobNum))+1, 600))))-1) 

	INSERT #tbJobs(OrderHead, OrderDtl, OrderRel, jobNum, isOperacionEnd)
	SELECT OrderHead, OrderDtl, OrderRel, jobNum, 
		isOperacionEnd = (CASE @intOperacion
								WHEN 1 THEN isYesosEnd
							END
						)
	FROM tbJobHead
	WHERE OrderHead = @Orden
		AND OrderDtl = @Linea

		
	--HACEMOS UNA TABLA CON LOS VALORES INICIO Y FIN, ESTA SE MULTIPLICARÁ POR LA CANTIDAD DE ESTACIONES QUE CORRESPONDAN A LA LÍNEA
	INSERT @InicioFin (InicioFinID, NombrePaso, Inicio, Fin) VALUES (1, 'Inicio', 1, 0), (2, 'Fin', 0, 1)
	PRINT 'TABLA: @InicioFin Llenada'
	--SELECT * FROM @InicioFin

	
	INSERT @Status(EstatusID, OrderHead, OrderDtl, OrderRel, jobNum, Operacion, NombreOperacion, NombrePaso, [Status], Inicio, Fin, PuedeMarcar, IsMarcado)--, IsSiguienteOper, IsDebeMarcar
	SELECT 
			 fila=(ROW_NUMBER() OVER(ORDER BY J.OrderHead, J.OrderDtl, J.OrderRel, OP.intOperacion, IF1.InicioFinID))
			,J.OrderHead, J.OrderDtl, J.OrderRel, J.JobNum
			,Operacion = OP.OprSeq, NombreOperacion = OP.OpDesc, NombrePaso = IF1.NombrePaso, Estatus = OP.OpDesc, IF1.Inicio, IF1.Fin
			,PuedeMarcar = (CASE WHEN ISNULL(UOP.intUsuario, 0) <> 0 THEN 1 ELSE 0 END) 
			,IsMarcado = (CASE ISNULL(RCE.JobNum, '') WHEN '' THEN 0 ELSE 1 END)
		--	, *
	FROM #tbJobs		AS  J WITH(NOLOCK) 
		JOIN tbJobOper	AS OP WITH(NOLOCK) ON OP.JobNum = J.jobNum
		FULL JOIN @InicioFin AS IF1 ON 1 = 1
		LEFT JOIN tbRegistroCambioEstatus AS RCE ON RCE.OrderHead = J.OrderHead AND RCE.OrderDtl = J.OrderDtl AND RCE.OrderRel = J.OrderRel AND RCE.[Status] = OP.OpDesc AND RCE.Inicio = IF1.Inicio AND RCE.Fin = IF1.Fin
		LEFT JOIN tbUsuariosXOperacion		AS UOP ON UOP.intOperacion = OP.intOperacion AND UOP.strUsuario = @strUsuario
	--ORDER BY OP.Operacion, IF1.InicioFinID
	--PRINT 'TABLA: @Status Llenada'
	WHERE OP.intOperacion = @intOperacion
	
	--DECLARAMOS UNA VARIABLE PARA DECIDIR CUAL SERIA LA SIGUIENTE OPERACION A MARCAR DE LAS QUE TENEMOS DISPONIBLES PARA ESTA SESION/USUARIO 
	DECLARE @EstatusIDSiguiente INT, @InicioMarcar BIT
	SELECT TOP 1 
		@EstatusIDSiguiente = EstatusID, @InicioMarcar = Inicio
	FROM @Status 
	WHERE PuedeMarcar = 1 
		AND IsMarcado = 0 
	ORDER BY EstatusID ASC
	PRINT 'Se asigna  @EstatusIDSiguiente = '+CONVERT(VARCHAR(1500), @EstatusIDSiguiente)
	PRINT 'Se asigna  @InicioMarcar = '+CONVERT(VARCHAR(1500), @InicioMarcar)

	--AQUI MISMO DECLARAMOS CUAL ES LA QUE DEBE MARCAR EN SI 
	DECLARE @EstatusIDDebeMarcar INT, @InicioDebeMarcar BIT
	SELECT TOP 1 
		@EstatusIDDebeMarcar = EstatusID , @InicioDebeMarcar = Inicio
	FROM @Status 
	WHERE IsMarcado = 0 
	ORDER BY EstatusID ASC
	PRINT 'Se asigna  @EstatusIDDebeMarcar = '+CONVERT(VARCHAR(1500), @EstatusIDDebeMarcar)
	PRINT 'Se asigna  @InicioDebeMarcar = '+CONVERT(VARCHAR(1500), @InicioDebeMarcar)

	
	--UNA VEZ LLENADA HACEMOS EL UPDATE PARA MARCAR LA SIGUIENTE OPERACIÓN DISPONIBLE
	UPDATE @Status SET IsSiguienteOper = 1 WHERE PuedeMarcar = 1 AND IsMarcado = 0 AND Inicio = @InicioMarcar
	PRINT 'Se hizo el UPDATE de la tabla: @Status PARA LA COLUMNA IsSiguienteOper'

	--UNA VEZ LLENADA HACEMOS EL UPDATE PARA MARCAR LA OPERACIÓN QUE DEBEN MARCAR POR PROCESO
	UPDATE @Status SET IsDebeMarcar = 1 WHERE Inicio = @InicioDebeMarcar
	PRINT 'Se hizo el UPDATE de la tabla: @Status PARA LA COLUMNA IsDebeMarcar'
	
	--SELECT * FROM @Status

	--SELECT intUsuario, intOperacion, strUsuario, strOperacion 
	--FROM tbUsuariosXOperacion 
	--WHERE intOperacion = @intOperacion
	
	--LO PRIMERO QUE VALIDAMOS ES QUE EL JOB ESTÉ DENTRO DE LOS QUE IMPORTAMOS (SOLO LO PROGRAMADO)
	IF NOT EXISTS(SELECT intJobHead FROM tbJobHead   WHERE OrderHead = @Orden)
	BEGIN
		SELECT @MensajeError = 'El trabajo que intentas escanear ('+@JobNum+') no existe o no está listo para ser reportado'
		GOTO ERROR   
	END
	
	--LO PRIMERO QUE VALIDAMOS ES QUE EL JOB ESTÉ DENTRO DE LOS QUE IMPORTAMOS (SOLO LO PROGRAMADO)
	IF ( @JobNum <> '' AND ISNULL(@strUsuario, '') = '' )
	BEGIN
		SELECT @MensajeError = 'Tu tiempo de sesión HA CADUCADO, necesitas volver a escanear tu código (sal y vuelve a entrar al sistema).'
		GOTO ERROR   
	END

	
	
	--AQUI DECLARAMOS QUE EL USUARIO PUEDE ESCANEAR LA SIGUIENTE OPERACION
	IF EXISTS (SELECT EstatusID FROM @Status WHERE PuedeMarcar = 1 AND IsMarcado = 0)
	--IF EXISTS (SELECT OrderHead FROM #tbJobs WHERE isOperacionEnd = 0)
	BEGIN
		--SI TENEMOS ACTIVO EL LLENADO SE INSERTARÍA YA DE UNA VEZ, SI NO SOLO HACEMOS LA SIMULACIÓN
		IF @BitInsert = 1
		BEGIN
			--SELECT * FROm @InicioFin
			--SELECT * FROm @Status


			--INSERTAMOS A LA TABLA "tbRegistroCambioEstatus" LOS REGISTROS GENERADOS EN "@CambiosEstatusInsert"
			PRINT 'HACEMOS EL INSERT A "tbRegistroCambioEstatus"'
			INSERT tbRegistroCambioEstatus(OrderHead,OrderDtl,OrderRel,JobNum,Status,Inicio,Fin,isOcupado,Usuario,Fecha)
			SELECT OrderHead,OrderDtl,OrderRel,JobNum,[Status],Inicio,Fin,isOcupado = 0, Usuario = @strUsuario,Fecha = GETDATE()
			FROM @Status
			WHERE IsDebeMarcar = 1
			--SI MARCA ERROR LO ASIGNAMOS
			IF @@ERROR <> 0
			BEGIN
				SELECT @MensajeError =  'Hubo problemas al INSERTAR el estatus en "tbRegistroCambioEstatus".'
				GOTO ERROR
			END
			PRINT 'Termina el INSERT DE "tbRegistroCambioEstatus"'

			IF EXISTS(SELECT EstatusID FROm @Status WHERE IsSiguienteOper = 1 AND IsDebeMarcar =1 AND Fin = 1)
			BEGIN
				--SELECT 'CERRAMOS OPERACION$ES'
				
				PRINT 'HACEMOS UPDATE A "tbJobHead"'
				UPDATE JH
				SET  JH.isYesosEnd = (CASE @intOperacion WHEN 1 THEN @intOperacion ELSE JH.isYesosEnd END)
					,JH.strUsuarioMod = 'Modificado mediante "spJobsOperaciones_UPD".'
					,JH.strMaquinaMod = @strUsuario
					,JH.datFechaMod = GETDATE()
				--SELECT ST.OrderHead, ST.OrderDtl, ST.OrderRel, ST.jobNum, JH.*
				FROM @Status	AS ST  
					JOIN tbJobHead  AS JH WITH(NOLOCK) ON ST.OrderHead = JH.OrderHead AND ST.OrderDtl = JH.OrderDtl AND ST.OrderRel = JH.OrderRel
				WHERE ST.IsSiguienteOper = 1 
					AND ST.IsDebeMarcar =1 AND ST.Fin = 1
				--SI MARCA ERROR LO ASIGNAMOS
				IF @@ERROR <> 0
				BEGIN
					SELECT @MensajeError =  'Hubo problemas al hacer el UPDATE de "tbJobHead".'
					GOTO ERROR
				END
				PRINT 'Termina el UPDATE de "tbJobHead"'

				
				PRINT 'HACEMOS UPDATE A "tbJobOper"'
				UPDATE OP
				SET  OP.OpComplete = 1
					,OP.LastLaborDate = GETDATE()
					,OP.strUsuarioMod = 'Modificado mediante "spJobsOperaciones_UPD".'
					,OP.strMaquinaMod = @strUsuario
					,OP.datFechaMod = GETDATE()
				--SELECT ST.OrderHead, ST.OrderDtl, ST.OrderRel, ST.jobNum, OP.*
				FROM @Status	AS ST  
					JOIN tbJobOper  AS OP WITH(NOLOCK) ON ST.jobNum = OP.JobNum
				WHERE ST.IsSiguienteOper = 1 
					AND ST.IsDebeMarcar =1 AND ST.Fin = 1
					AND intOperacion = @intOperacion
				--SI MARCA ERROR LO ASIGNAMOS
				IF @@ERROR <> 0
				BEGIN
					SELECT @MensajeError =  'Hubo problemas al hacer el UPDATE de "tbJobOper".'
					GOTO ERROR
				END
				PRINT 'Termina el UPDATE de "tbJobOper"'

				
				PRINT 'HACEMOS UPDATE A "tbJobMTL"'
				UPDATE MTL
				SET  MTL.CantUtilizada = MTL.CantReq
					,MTL.IssuedComplete = 1
					,MTL.strUsuarioMod = 'Modificado mediante "spJobsOperaciones_UPD".'
					,MTL.strMaquinaMod = @strUsuario
					,MTL.datFechaMod = GETDATE()
				--SELECT ST.OrderHead, ST.OrderDtl, ST.OrderRel, ST.jobNum, OP.*, MTL.*
				FROM @Status		AS  ST  
					JOIN tbJobOper  AS  OP WITH(NOLOCK) ON ST.jobNum = OP.JobNum
					JOIN tbJobMTL	AS MTL WITH(NOLOCK) ON MTL.jobNum = OP.JobNum AND OP.OprSeq = MTL.RelatedOperation
				WHERE ST.IsSiguienteOper = 1 
					AND ST.IsDebeMarcar =1 AND ST.Fin = 1
					AND OP.intOperacion = @intOperacion
				--SI MARCA ERROR LO ASIGNAMOS
				IF @@ERROR <> 0
				BEGIN
					SELECT @MensajeError =  'Hubo problemas al hacer el UPDATE de "tbJobMTL".'
					GOTO ERROR
				END
				PRINT 'Termina el UPDATE de "tbJobMTL"'


			END

		END
		ELSE
		--SI EL BIT DE INSERTADO VIENE EN 0 SOLO HACEMOS LA SIMULACIÓN
		BEGIN
			SELECT 'NO INSERTAMOS'
		END
	END
	ELSE
	BEGIN
		--ESTE ERROR SE LANZA DE ÚLTIMO MOMENTO Y SIRVE PARA ENGLOBAR DISTINTOS PROBLEMAS (LOS QUE ACTUALMENTE NO ESTÉN CONSIDERADOS), EN CASO CONTRARIO Y SI EL BIT DE INSERCIÓN ESTÁ PRENDIDO SE HACE LA INCERCIÓN
		SELECT @MensajeError =  'Esta Orden ya fue reportada para esta operación.'
		GOTO ERROR
	END	

	--SUPONIENDO QUE TODO SALIÓ BIEN NOS VAMOS A BRINAR A LA SECCIÓN DE FIN
	GOTO FIN
	-- -----------------------------------------------------------------------------------------
	-- CUALQUIER SP, INSERT, VALIDACIÓN, ETC QUE NO FUNCIONE BIEN HACE QUE NOS VAYAMOS DIRECTO A ESTA SECCIÓN DE ERROR
	-- EN ELLA SOLO TOMAMOS EL TEXTO PREVIAMENTE ASIGNADO AL ERROR PARA MOSTRARLO Y HACEMOS UN ROLLBACK
	ERROR:
	-- -----------------------------------------------------------------------------------------
	IF @TranCount = 0	--	Si hay una transacción, hacer rollback
	BEGIN
		RAISERROR(@MensajeError, 16, 1)
		IF @@TRANCOUNT <>0
		BEGIN
			ROLLBACK TRANSACTION
		END
	END

	-- -----------------------------------------------------------------------------------------
	-- AQUI EN LA SECCIÓN DE FIN HACEMOS EL COMMIT Y DEVOLVEMOS LAS PALABRAS "INICIO" O "FIN" PARA QUE LA VISTA SEPA QUE HACER
	FIN:
	-- -----------------------------------------------------------------------------------------
	IF @TranCount = 0	--	Si hay una transacción, hacer un commit
	BEGIN
		IF @@TRANCOUNT <>0
		BEGIN
			COMMIT TRANSACTION
		END
			SELECT TOP 1
				Id = REPLACE(@JobNum, '-0', ''), 
				Resultado=(CASE 
							WHEN Inicio = 1 AND Fin = 0 THEN 'INICIO' 
							WHEN Inicio = 0 AND Fin = 1 THEN 'FIN' 
							ELSE 'REVISA' 
						END
				)
			FROM @Status
			WHERE IsDebeMarcar = 1

	END
END
go



spJobsOperaciones_UPD @JobNum = '6745-1', @intOperacion = 1, @strUsuario = 'MR-JOC'
go
