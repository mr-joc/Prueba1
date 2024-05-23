USE LabAllCeramic
go
--


go
--qry_OrdenLaboratorioEnc_App 1,1,5,5,2,'WQ',2,2,124,1,1.1,6,1,'a1','222',1,'26/04/2018','10/10/2018',1,0,'JORGE','::1'
CREATE PROCEDURE dbo.qry_OrdenLaboratorioEnc_App
@intEmpresa INT,
@intSucursal INT,
@intOrdenLaboratorioEnc INT,
@intFolio INT,
--@intClinica INT,
@intDoctor INT,
@strNombrePaciente VARCHAR(500),
@intExpediente INT,
@intFolioPago INT,
@dblPrecio NUMERIC(18,2),
@intTipoProtesis INT,
@intPieza NUMERIC(18,2),
@intProceso INT,
@intTipoTrabajo INT,
@strColor VARCHAR(10),
@strComentario VARCHAR(500),
@strObservaciones VARCHAR(500),
@intEdad INT,
@intSexo INT,
@intConGarantia INT,
@intColor INT,
@intFactura INT,
@intEstatus INT,
@datFechaEntrega DATETIME,
@datFechaColocacion DATETIME,
@intColorimetro INT,
@intUrgente INT,
@strUsuario VARCHAR(150),
@strMaquina VARCHAR(150)

AS      
BEGIN
	DECLARE @TMP INT, @RESULT INT

	DECLARE @strError VARCHAR (500),@intPiezaNoExiste NUMERIC(18,1), @intEstatusActual INT
	SET @intPiezaNoExiste=@intPieza      
	IF @intPieza >4.9 OR @intPieza <1.1      
	BEGIN
		SET @strError=('NO ES POSIBLE INSERTAR ESTE VALOR '+convert(varchar(8),@intPiezaNoExiste)+'. FAVOR DE INSERTAR UNA PIEZA VALIDA.')      
		RAISERROR (@strError, 16, 1)      
		RETURN      
	END
	
/*
	SET @intEstatusActual=(SELECT intEstatus FROM tbOrdenLaboratorioEnc WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal AND intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc)
	IF @intEstatusActual<>1
	BEGIN
		SET @strError=('EL ESTATUS ACTUAL DE LA ORDEN NO PERMITE HACER MODIFICACIONES.')      
		RAISERROR (@strError, 16, 1)      
		RETURN    
	END
*/

/*
	--Revisamos que el usuario que actualiza, sea el mismo que dio de alta
	DECLARE @strUsuarioAlta VARCHAR(50)
	SET @strUsuarioAlta=(SELECT strUsuarioAlta FROM tbOrdenLaboratorioEnc 
		WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal AND intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc)

	IF(@strUsuarioAlta<>@strUsuario)
	BEGIN
		RAISERROR('Solo el Usuario %s puede realizar actualizaciones a la requisición.', 16, 1)
		RETURN 
	END
*/

	IF (@datFechaEntrega <= GETDATE() )
	BEGIN
		RAISERROR('La fecha de entrega debe ser mayor a la actual.', 16, 1)
		RETURN 
	END

/*
	IF ((@datFechaColocacion <= @datFechaEntrega) OR (@datFechaColocacion <= GETDATE()) )
	BEGIN
		RAISERROR('La fecha de Colocación debe ser mayor a la fecha de captura y de entrega.', 16, 1)
		RETURN 
	END
*/

	SET @RESULT=0
	BEGIN TRANSACTION qry_OrdenLaboratorioEnc_App
	SAVE TRANSACTION qry_OrdenLaboratorioEnc_App
       
	IF @intOrdenLaboratorioEnc=0       
	BEGIN
		--Asignamos el Folio 
		--SE COMENTO ESTA LINEA QUE TRAE EL FOLIO DESDE LA FUNCION
		--SET @intFolio=dbo.fn_ObtenerFolio(@intEmpresa, @intSucursal, 8, 'ODE')
	--SElect intFolio=ISNULL((SELECT TOP 1(ISNULL(intOrdenLaboratorioEnc,0))+1 FROM tbOrdenLaboratorioEnc ORDER BY intOrdenLaboratorioEnc DESC),1)
		SET @intFolio=ISNULL((SELECT TOP 1(ISNULL(intOrdenLaboratorioEnc,0))+1 FROM tbOrdenLaboratorioEnc ORDER BY intOrdenLaboratorioEnc DESC),1)

		INSERT tbOrdenLaboratorioEnc(intEmpresa,intSucursal,intFolio,intDoctor,strNombrePaciente,intExpediente,intFolioPago,dblPrecio,intTipoProtesis,
			intPieza,intProceso,intTipoTrabajo,strColor,strComentario,strObservaciones,intEdad,intSexo,intConGarantia,intColor,intFactura,
			intEstatus,datFechaEntrega,datFechaColocacion,datFechaAlta,intColorimetro,intUrgente,strUsuarioAlta,strMaquinaAlta)      
		VALUES (@intEmpresa,@intSucursal,@intFolio,@intDoctor,@strNombrePaciente,@intExpediente,@intFolioPago,@dblPrecio,@intTipoProtesis,
			@intPieza,@intProceso,@intTipoTrabajo,@strColor,@strComentario,@strObservaciones,@intEdad,@intSexo,@intConGarantia,@intColor,@intFactura,
			0,@datFechaEntrega,@datFechaColocacion,getdate(),@intColorimetro,@intUrgente,@strUsuario,@strMaquina)      
     		SET @TMP=@@ERROR IF(@TMP<>0) SET @RESULT=@TMP
		
		SET @intOrdenLaboratorioEnc=IDENT_CURRENT('tbOrdenLaboratorioEnc')
		
		--Actualizamos el Folio por si acaso los tomo repetidos
		UPDATE tbOrdenLaboratorioEnc
		SET intFolio=@intOrdenLaboratorioEnc
		WHERE intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc

		--Cambiamos Estatus
		EXEC qryTipoDocumento_CambiarEstatus @intEmpresa, @intSucursal, 8, 8,  'ODE', @intOrdenLaboratorioEnc, 1, @strUsuario, @strMaquina,'ALTA ORDEN DENTAL', @TMP OUT 
		--Incrementamos el Folio
		EXEC qry_IncrementarFolio @intEmpresa, @intSucursal, 8, 'ODE'
		--DEVUELVE 1 EN CASO DE CORRECTO
		SET @TMP=@TMP-1
		IF(@TMP<>0) SET @RESULT=@TMP
	END
	ELSE
	BEGIN

		UPDATE tbOrdenLaboratorioEnc
		SET
		intEmpresa=@intEmpresa,
		intSucursal=@intSucursal,
		--intFolio=@intFolio,
		--intClinica=@intClinica,
		intDoctor=@intDoctor,
		strNombrePaciente=@strNombrePaciente,
		intExpediente=@intExpediente,
		intFolioPago=@intFolioPago,
		dblPrecio=@dblPrecio,
		intTipoProtesis=@intTipoProtesis,
		intPieza=@intPieza,
		intProceso=@intProceso,
		intTipoTrabajo=@intTipoTrabajo,
		strColor=@strColor,
		strComentario=@strComentario,

		strObservaciones=@strObservaciones,
		intEdad=@intEdad,
		intSexo=@intSexo,
		intConGarantia =@intConGarantia,
		intColor=@intColor,
		intFactura=@intFactura,

		intEstatus=@intEstatus,
		datFechaEntrega=@datFechaEntrega,
		datFechaColocacion=@datFechaColocacion,
		intColorimetro=@intColorimetro,
		intUrgente=@intUrgente,
		datFechaMod=getdate(),
		strUsuarioMod=@strUsuario,
		strMaquinaMod=@strMaquina
		WHERE intEmpresa=@intEmpresa
			AND intSucursal=@intSucursal
		--	AND intClinica=@intClinica
			AND intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc

		SET @TMP=@@ERROR IF(@TMP<>0) SET @RESULT=@TMP
   
		--EXEC qry_OrdenLaboratorioDet_App @intEmpresa,@intSucursal,@intOrdenLaboratorioEnc,@intClinica,@intPieza,@intProceso,@intTipoTrabajo,@strColor,@strUsuario,@strMaquina 
	END

	IF(@RESULT<>0)
	BEGIN		
		ROLLBACK TRANSACTION qry_OrdenLaboratorioEnc_App
	--	ROLLBACK TRANSACTION
		RAISERROR('©Ocurrio el siguiente error:%d Cambios rechazados.©',16,1,@RESULT)		
		RETURN 
	END            
	ELSE
	BEGIN
		COMMIT TRANSACTION  qry_OrdenLaboratorioEnc_App
		SELECT result=ISNULL(@intOrdenLaboratorioEnc,0)
		RETURN 
	END
END
go

  
go 
--qry_V2_GenerarOrdeneTrabajo_APP @intOrdenLaboratorioEnc =6658, @strUsuario = 'MR-JOC'
CREATE PROCEDURE qry_V2_GenerarOrdeneTrabajo_APP
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

		

	DECLARE @ID INT

	SET @TranCount = @@TRANCOUNT
	IF @TranCount = 0	--	Si no hay una transacción, inciar una
	BEGIN
		BEGIN TRANSACTION
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


go
--qry_V2_AbonoTrabajo_App 1,1, 0, 7,2600,'JORGE','10.0.0.65'
CREATE PROCEDURE qry_V2_AbonoTrabajo_App (
@intEmpresa INT,
@intSucursal INT,
@intAbonoTrabajo INT,
@intOrdenLaboratorioEnc INT,
@dblMonto NUMERIC (18,2),
@strUsuario VARCHAR (50),
@strMaquina VARCHAR(50) 
)
AS
BEGIN
	SET @strUsuario = UPPER (@strUsuario)
	SET @strMaquina = UPPER (@strMaquina)

	DECLARE @dblMontoFactura NUMERIC (18,2), @dblAbonoTotal NUMERIC(18,2), @intResult INT, @intFolio INT

	DECLARE @TMP INT, @RESULT INT, @strError VARCHAR (4000)
	DECLARE @dlbAbonado NUMERIC (18,2)
		

	SET @dblMontoFactura =(SELECT ISNULL(dblPrecio,0) FROM tbOrdenLaboratorioEnc WHERE intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc)
	SET @dblAbonoTotal = (SELECT ISNULL ( (SUM (dblMonto)) ,0 ) FROM tbAbonoTrabajo WHERE  intOrdenLAboratorioEnc = @intOrdenLaboratorioEnc)

IF (@dblAbonoTotal+@dblMonto)>@dblMontoFactura
	BEGIN 
		SET @strError=('EL MONTO ACTUAL DEL TRABAJO ES DE $'+convert(varchar(20),@dblMontoFactura)+' POR ESO NO PUEDES ABONAR LA CANTIDAD DE $'+ convert(varchar(20),@dblMonto) )
		RAISERROR (@strError, 16, 1)      
		RETURN    
	END

	DECLARE @intEstatusActual INT
	SET @intEstatusActual=(SELECT intPagado FROM tbOrdenLaboratorioEnc WHERE intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc)
	IF  ((@intEstatusActual = 1))-- OR (@intEstatusActual = 1))
	BEGIN
		SET @strError=('Este trabajo ya está completamente pagado')
		RAISERROR (@strError, 16, 1)  
		RETURN    
	END

	SET @RESULT=0
	BEGIN TRANSACTION TRANSACCIONABONO
	SAVE TRANSACTION TRANSACCIONABONO

	IF @intAbonoTrabajo = 0 
	BEGIN
		INSERT INTO tbAbonoTrabajo(intEmpresa,intSucursal,intOrdenLAboratorioEnc,dblMonto,datFechaAlta,strUsuarioAlta,strMaquinaAlta)
		VALUES(@intEmpresa,@intSucursal,@intOrdenLaboratorioEnc,@dblMonto,GETDATE(),@strUsuario,@strMaquina)
		SET @intResult=1
		SET @intFolio=IDENT_CURRENT( 'tbAbonoTrabajo' )

		SET @dlbAbonado = (SELECT SUM (dblMonto) FROM tbAbonoTrabajo WHERE intOrdenLAboratorioEnc = @intOrdenLaboratorioEnc)
		IF @dlbAbonado=@dblMontoFactura
		BEGIN
			UPDATE tbOrdenLaboratorioEnc SET intPagado = 1 WHERE intOrdenLAboratorioEnc = @intOrdenLaboratorioEnc

		END
	END

	SET @TMP=@@ERROR IF(@TMP<>0) SET @RESULT=@TMP


	IF(@RESULT<>0)
	BEGIN		
		ROLLBACK TRANSACTION TRANSACCIONABONO
		ROLLBACK TRANSACTION
		RAISERROR('©Ocurrio el siguiente error:%d Abonos rechazados.©',16,1,@RESULT)		
		RETURN 
	END            
	ELSE
	BEGIN
		COMMIT TRANSACTION  TRANSACCIONABONO
		SELECT result=ISNULL(@intOrdenLaboratorioEnc,0)--,intAccion=@intResult ,dblMontoFactura=@dblMontoFactura,dblAbonoTotal=@dblAbonoTotal
		RETURN 
	END
END
go


go
CREATE PROCEDURE qry_V2_EstatusOrdenLaboratorioEnc
@intEmpresa INT,
@intOrdenLaboratorioEnc INT
AS
BEGIN
		DECLARE @strRutaImagenes VARCHAR(500)

		SET @strRutaImagenes='http://localhost/LabAllCeramic/LabAllCeramicUI/Imagenes/Articulos/'
	SELECT 
		R.intOrdenLaboratorioEnc,
		R.intEstatus, intCaja=ISNULL(R.intCajaAlmacenamiento,0), datFechaEntrega=(CONVERT(VARCHAR(10),R.datFechaEntrega,101)),
		  strDoctor =(SELECT D.strNombre+' '+D.strApPaterno+' '+D.strApMaterno FROM tbDoctor AS D WHERE D.intDoctor = R.intDoctor),  
		datFechaColocacion=(CONVERT(VARCHAR(10),R.datFechaColocacion,101)),
		strImagenEstatus=(SELECT '<IMG src=''../../Imagenes/'+E.strImagen+''' width=16 height=16 alt='''+E.strNombre+'''/>'+E.strNombre  
			FROM tbEstatus AS E Where E.intEstatus=R.intEstatus AND intEmpresa = R.intEmpresa),
		strEncabezado=(CASE @intEmpresa
		WHEN 1 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Cambiar Estatus del Trabajo #'+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		WHEN 2 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Cambiar Estatus del Trabajo #'+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		WHEN 3 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Cambiar Estatus del Trabajo #'+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		ELSE '' END),
		strEncabezadoImg=(CASE @intEmpresa
		WHEN 1 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Imágenes del Trabajo #'+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		WHEN 2 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Imágenes del Trabajo #'+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		WHEN 3 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Imágenes del Trabajo #'+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		ELSE '' END),
		strEncaRechazo=(CASE @intEmpresa
		WHEN 1 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Rechazar Trabajo</p>'
		WHEN 2 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Rechazar Trabajo</p>'
		WHEN 3 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Rechazar Trabajo</p>'
		ELSE '' END),
		strEncaHistorial=(CASE @intEmpresa
		WHEN 1 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Historial del Trabajo '+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'--
		WHEN 2 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Historial del Trabajo '+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		WHEN 3 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Historial del Trabajo '+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		ELSE '' END),
		strTipoProtesis=(SELECT P.strNombreTipoProtesis FROM tbTipoProtesis AS P WHERE P.intTipoProtesis=R.intTipoProtesis),
		strProceso=(SELECT PRO.strNombreProceso FROM tbProceso PRO WHERE PRO.intProceso=R.intProceso),
				strImagenes=(CASE strImagen01 WHEN '' THEN '' ELSE '<a href=javascript:VerImg('''+@strRutaImagenes+strImagen01+''');>Img_01</a>' END )+
							(CASE strImagen02 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen02+''');>Img_02</a>' END )+
							(CASE strImagen03 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen03+''');>Img_03</a>' END )+
							(CASE strImagen04 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen04+''');>Img_04</a>' END )+
							(CASE strImagen05 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen05+''');>Img_05</a>' END )+
							(CASE strImagen06 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen06+''');>Img_06</a>' END )+
							(CASE strImagen07 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen07+''');>Img_07</a>' END )+
							(CASE strImagen08 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen08+''');>Img_08</a>' END )+
							(CASE strImagen09 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen09+''');>Img_09</a>' END )+
							(CASE strImagen10 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen10+''');>Img_10</a>' END )+
							(CASE strImagen11 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen11+''');>Img_11</a>' END )+
							(CASE strImagen12 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen12+''');>Img_12</a>' END )+
							(CASE strImagen13 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen13+''');>Img_13</a>' END )+
							(CASE strImagen14 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen14+''');>Img_14</a>' END )+
							(CASE strImagen15 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen15+''');>Img_15</a>' END )+
							(CASE strImagen16 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen16+''');>Img_16</a>' END )+
							(CASE strImagen17 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen17+''');>Img_17</a>' END )+
							(CASE strImagen18 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen18+''');>Img_18</a>' END )+
							(CASE strImagen19 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen19+''');>Img_19</a>' END )+
							(CASE strImagen20 WHEN '' THEN '' ELSE ', <a href=javascript:VerImg('''+@strRutaImagenes+strImagen20+''');>Img_20</a>' END ),
		strEncabezadoEstatusProceso=(CASE @intEmpresa
		WHEN 1 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Cambiar Estatus de Proceso, Trabajo #'+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		WHEN 2 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Cambiar Estatus de Proceso, Trabajo #'+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		WHEN 3 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color: #000000; border-width: 1px;">Cambiar Estatus de Proceso, Trabajo #'+CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+'</p>'
		ELSE '' END),
		strImagenProceso=(SELECT '<IMG src=''../../Imagenes/'+EP.strImagen+''' width=16 height=16 alt='''+EP.strNombre+'''/>'+EP.strNombre  
			FROM tbEstatusProceso AS EP Where EP.intEstatusProceso=R.intEstatusProceso AND EP.intEmpresa = R.intEmpresa)

	FROM tbOrdenLaboratorioEnc R WHERE (R.intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc OR @intOrdenLaboratorioEnc= 0)

END
go

go
--qry_V2_OrdenLaboratorioEnc_Sel 1,1,1002
CREATE PROCEDURE qry_V2_OrdenLaboratorioEnc_Sel
(@intEmpresa INT, 
@intSucursal INT, 
@intOrdenLaboratorioEnc INT)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT T.intEmpresa, T.intSucursal, T.intOrdenLaboratorioEnc, 
	strEncabezado=(CASE @intEmpresa 
					WHEN 1 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px;'+
								' background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: '+
								'solid; border-top-style: solid; border-color:#000000; border-width: 1px;">'+
								'Abonar al Trabajo: '+CONVERT(VARCHAR(9),T.intOrdenLaboratorioEnc)+'</p>'
					WHEN 2 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px;'+
								' background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: '+
								'solid; border-top-style: solid; border-color:#000000; border-width: 1px;">'+
								'Abonar al Trabajo: '+CONVERT(VARCHAR(9),T.intOrdenLaboratorioEnc)+'</p>'
					WHEN 3 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px;'+
								' background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: '+
								'solid; border-top-style: solid; border-color:#000000; border-width: 1px;">'+
								'Abonar al Trabajo: '+CONVERT(VARCHAR(9),T.intOrdenLaboratorioEnc)+'</p>'
					ELSE '' END),
	dblCosto=ISNULL(T.dblPrecio,0),
	dblPagado=ISNULL((SELECT SUM(dblMonto) FROM tbAbonoTrabajo AS A WHERE A.intOrdenLaboratorioEnc = T.intOrdenLaboratorioEnc),0),
	dblSaldo = ISNULL(((ISNULL(T.dblPrecio,0)) -ISNULL((((SELECT SUM(dblMonto) FROM tbAbonoTrabajo AS A WHERE A.intOrdenLaboratorioEnc = T.intOrdenLaboratorioEnc))),0) ),0),


	T.intFolio, 
	T.intDoctor, 
	strDoctor = DRE.strNombre+' '+DRE.strApPaterno+' '+DRE.strApPaterno,
	T.strNombrePaciente, T.intExpediente, 
	intFolioPago=ISNULL(T.intFolioPago,0),
	T.intTipoProtesis,  
	strTipoProtesis = TP.strNombreTipoProtesis,
	T.intPieza, 
	T.intProceso,   
	strProceso = PRO.strNombreProceso,
	T.intTipoTrabajo, 
	strColor = CLO.strNombre,
	T.strComentario,
	T.strObservaciones,T.intEdad,T.intSexo, intGarantia = T.intConGarantia,
	T.intEstatus, 
	T.intColorimetro,
	strColorimetro = CLI.strNombre,
	T.intColor,T.intFactura,
	dblPrecio=ISNULL(T.dblPrecio,0),
	dblPrecioReal=ISNULL((SELECT SUM(TT.dblPrecio) FROM tbOrdenLaboratorioDet AS D, tbTipoTrabajo AS TT WHERE TT.intTipoTrabajo=D.intTipoTrabajo AND D.intOrdenLaboratorioEnc =  T.intOrdenLaboratorioEnc),0),
	datFechaAlta      =T.datFechaAlta,  
	datFechaEntrega   =T.datFechaEntrega,  
	datFechaColocacion=T.datFechaColocacion, 
	strFechaAlta      = CONVERT(VARCHAR(10), T.datFechaAlta, 103),
	strFechaEntrega   = CONVERT(VARCHAR(10), T.datFechaEntrega, 103), 
	strFechaColocacion= CONVERT(VARCHAR(10), T.datFechaColocacion, 103),
	intUrgente =ISNULL(T.intUrgente,0),intLabExterno=ISNULL(T.intLabExterno,0),
	T.strUsuarioAlta, T.strMaquinaAlta, T.datFechaMod, T.strUsuarioMod, T.strMaquinaMod
	FROM tbOrdenLaboratorioEnc	AS   T WITH(NOLOCK)
		JOIN tbColorimetro		AS CLI WITH(NOLOCK) ON CLI.intColorimetro = T.intColorimetro
		JOIN tbColor			AS CLO WITH(NOLOCK) ON CLO.intColor = T.intColor
		JOIN tbDoctor			AS DRE WITH(NOLOCK) ON DRE.intDoctor = T.intDoctor
		JOIN tbProceso			AS PRO WITH(NOLOCK) ON PRO.intProceso=T.intProceso
		JOIN tbTipoProtesis		AS  TP WITH(NOLOCK) ON TP.intTipoProtesis=T.intTipoProtesis
	WHERE T.intEmpresa=@intEmpresa 
		AND T.intSucursal=@intSucursal
		AND (T.intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc OR @intOrdenLaboratorioEnc=0)
END
go


go
--qry_V2_OrdenLaboratorioEnc_SelHistorial @intOrdenLaboratorioEnc = 6727, @strUsuario = 'JORGE'
CREATE PROCEDURE qry_V2_OrdenLaboratorioEnc_SelHistorial
@intOrdenLaboratorioEnc INT,
@strUsuario VARCHAR (100)

AS	
BEGIN
		--DECLARE @strRutaImagenes VARCHAR(500)

		--SET @strRutaImagenes='http://10.0.0.178/Laboratorio/LaboratorioUI/Imagenes/Articulos/'

	SET @strUsuario = (CASE @strUsuario WHEN 'JORGE' THEN 'MR-JOC' ELSE @strUsuario END)

	--select*from segusuarios Where strUsuario = 'JORGE'
	--select*from tbperfilesenc
	DECLARE @intEmpresa INT, @intSucursal INT, @intPerfil INT
	SET @intEmpresa =(Select intEmpresaConsulta From segUsuarios Where strUsuario = @strUsuario)
	SET @intSucursal =(Select intSucursalConsulta From segUsuarios Where strUsuario = @strUsuario)
	SET @intPerfil =(Select intRol From segUsuarios2024 Where strUsuario = @strUsuario)
	--SELECT * FROM tbPerfilesEnc
	--
	IF (@intPerfil=1 OR @intPerfil=2 OR @intPerfil=3 OR @intPerfil=4 OR @intPerfil=5 OR @intPerfil=6 OR @intPerfil=7)
	BEGIN
		SELECT
			intOrdenLaboratorioEnc,intProceso,intEstatus,strEstatus = (SELECT strNombre FROM tbEstatus AS E WHERE E.intEstatus = R1.intEstatus),
			strUsuario,strComentario,strMaquina,datFecha,intMotivo=0,strImagenes=''
		INTO #tmpResultado1
		FROM tbCambioEstatusOrdenDental AS R1 
		WHERE intOrdenLaboratorioEnc = @intOrdenLaboratorioEnc 

		SELECT  intOrden=ROW_NUMBER() OVER(ORDER BY intProceso, intEstatus, datFecha),
			intOrdenLaboratorioEnc,intProceso,intEstatus,strEstatus,strUsuario,strComentario,strMaquina,datFecha,intMotivo,strImagenes
		INTO #tmpResult2
		FROM #tmpResultado1
		--ORDER BY intProceso, intEstatus, datFecha

		SELECT
			intOrden,intOrdenLaboratorioEnc,intProceso,strProceso = (SELECT P.strNombreProceso FROM tbProceso AS P WHERE P.intProceso = R.intProceso),
			intEstatus,strEstatus,-- = (SELECT strNombre FROM tbEstatus AS E WHERE E.intEstatus = R.intEstatus),
			strUsuario,strUsuarioCompuesto=(SELECT U.strNombreCompleto+' - ('+U.strUsuario+')' FROM segUsuarios AS U WHERE U.strUsuario = R.strUsuario),
			strComentario,strMaquina,strFecha=CONVERT(VARCHAR(10),datFecha,103),
			strFechaHora=(CONVERT(VARCHAR(10),datFecha,103)+' A las: '+CONVERT(VARCHAR(5),datFecha,108)),
			intMotivo,
			strMotivo=(SELECT M.strNombre FROM tbMotivoRechazo AS M WHERE M.intMotivoRechazo = R.intMotivo),
			strImagenes
		FROM #tmpResult2 AS R
		ORDER BY intOrden

--qryOrdenLaboratorioEnc_SelHistorial 9129, 'JORGE'



	END
END
go


go
--qry_V2_AbonoTrabajo_SEL 1, 1, 11
CREATE PROCEDURE qry_V2_AbonoTrabajo_SEL 
(
	@intEmpresa INT, 
	@intSucursal INT, 
	@intOrdenLaboratorioEnc INT
)
AS
BEGIN
	SELECT intAbonoTrabajo,intOrdenLaboratorioEnc,dblMonto,
	datFechaAlta=CONVERT(VARCHAR(10), datFechaAlta, 103),
	strUsuarioAlta,strMaquinaAlta
	FROM tbAbonoTrabajo
	WHERE 
		intEmpresa = @intEmpresa AND 
		intSucursal = @intSucursal AND 
		intOrdenLaboratorioEnc = @intOrdenLaboratorioEnc
	ORDER BY intAbonoTrabajo DESC
END
go


go
--qryOrdenLaboratorioDet_SelXOrdenLaboratorio 1, 1, 6
CREATE PROCEDURE qryOrdenLaboratorioDet_SelXOrdenLaboratorio
(
	@intEmpresa INT, 
	@intSucursal INT, 
	@intOrdenLaboratorioEnc INT
)
AS
BEGIN
	SELECT 
		intEmpresa, intSucursal, intOrdenLaboratorioEnc, intOrdenLaboratorioDet, intPieza, intMaterial, intTipoTrabajo, strColor=intCantidad,intCantidad,
		--strMaterial y strTrabajo no hacen nada, solo es para pasar los parametros en el grid de Detalle de OrdenLaboratorio
		material=(SELECT M.strNombre FROM tbMaterial M WHERE M.intMaterial=OD.intMaterial),
		trabajo=(SELECT T.strNombre FROM tbTipoTrabajo T WHERE T.intTipoTrabajo=OD.intTipoTrabajo)
		------------------------------------------------------------------------------------------------
	FROM 
		tbOrdenLaboratorioDet AS OD
	WHERE 
		intEmpresa = @intEmpresa AND 
		intSucursal = @intSucursal AND 
		intOrdenLaboratorioEnc = @intOrdenLaboratorioEnc
	ORDER BY intOrdenLaboratorioDet
END
go


go
--qry_TipoGasto_Del 5, 'MR-JOC'
CREATE PROCEDURE qry_V2_OrdenLaboratorioDet_Del
	@intOrdenLaboratorioDet	INT,
	@strUsuario				NVARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ID INT 

	INSERT tbOrdenesDetEliminadas(intOrdenLaboratorioEnc,intOrdenLaboratorioDet,intPieza,intMaterial,intTipoTrabajo,strUsuarioElimina,strMaquinaElimina,datFechaElimina,intCantidad)
	SELECT intOrdenLaboratorioEnc,intOrdenLaboratorioDet,intPieza,intMaterial,intTipoTrabajo,strUsuarioElimina=@strUsuario,strMaquinaElimina=@strUsuario,datFechaElimina=GETDATE(),intCantidad
	FROM tbOrdenLaboratorioDet WHERE intOrdenLaboratorioDet = @intOrdenLaboratorioDet

	DELETE FROM tbOrdenLaboratorioDet 
	WHERE intOrdenLaboratorioDet = @intOrdenLaboratorioDet;

	select @intOrdenLaboratorioDet as Id;
END
go

go
--qryOrdenLaboratorioEnc_SelDetalle_PorUsuario @strUsuario = 'JORGE', @intEsVersion2024 = 1
CREATE PROCEDURE dbo.qryOrdenLaboratorioEnc_SelDetalle_PorUsuario
	 @strUsuario			VARCHAR (100)
	,@intEsVersion2024		INT = NULL
	,@intDoctor				INT = NULL
	,@intProtesis			INT = NULL
	,@intProceso			INT = NULL

AS	
BEGIN

	CREATE TABLE #tmpResultado(		
		 intEmpresa						INT
		,intSucursal					INT
		,intOrdenLaboratorioEnc			INT
		,strNombrePaciente				NVARCHAR(550)
		,strClinica						NVARCHAR(550)
		,strDoctor						NVARCHAR(550)
		,intFolio						INT
		,intTipoProtesis				INT
		,strTipoProtesis				NVARCHAR(550)
		,intProceso						INT
		,strProceso						NVARCHAR(550)
		,datEntrega						NVARCHAR(15)
		,intDiasRetraso					INT	
		,strComentario					NVARCHAR(4000)
		,intEstatus						INT
		,intPagado						INT
		,strUsuarioAlta					NVARCHAR(150)
		,strMaquinaAlta					NVARCHAR(150)
		,datFechaAlta					DATETIME
		,dblCosto						NUMERIC(18, 2)
		,dblPagado						NUMERIC(18, 2)
		,intEstatusProceso				INT	
		,strTieneImagen					NVARCHAR(4000)
	)
	
	SET @strUsuario = (CASE @strUsuario WHEN 'MR-JOC' THEN 'JORGE' ELSE @strUsuario END)
	SET @intDoctor = ISNULL(@intDoctor, 0)
	SET @intProtesis = ISNULL(@intProtesis, 0)
	SET @intProceso = ISNULL(@intProceso, 0) 

	DECLARE @intEmpresa INT, @intSucursal INT, @intPerfil INT, @PrefijoImagenes NVARCHAR(50)

	SET @intEmpresa =(Select intEmpresaConsulta From segUsuarios Where strUsuario = @strUsuario)
	SET @intSucursal =(Select intSucursalConsulta From segUsuarios Where strUsuario = @strUsuario)
	SET @intPerfil =(Select intPerfil From segUsuarios Where strUsuario = @strUsuario)
	SET @intEsVersion2024 = ISNULL(@intEsVersion2024, 0)

	SET @PrefijoImagenes = (CASE @intEsVersion2024 WHEN 0 THEN '../..' ELSE '' END)


	IF (@intPerfil=1 OR @intPerfil=2 OR @intPerfil=3)
	BEGIN
		IF (@intDoctor = 0 AND @intProtesis = 0 AND @intProceso = 0)
		BEGIN
			INSERT #tmpResultado(intEmpresa,intSucursal,intOrdenLaboratorioEnc,strNombrePaciente,strClinica,strDoctor,intFolio,intTipoProtesis,strTipoProtesis,
								intProceso,strProceso,datEntrega,intDiasRetraso,strComentario,intEstatus,intPagado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,
								dblCosto,dblPagado,intEstatusProceso,strTieneImagen)
			SELECT TOP 150
			R.intEmpresa, R.intSucursal, R.intOrdenLaboratorioEnc,R.strNombrePaciente,
			strClinica='VACIA',--(Select C.strNombre From tbClinicas C Where C.intClinica=R.intClinica),
			strDoctor =(SELECT D.strNombre+' '+D.strApPaterno+' '+D.strApMaterno FROM tbDoctor AS D WHERE D.intDoctor = R.intDoctor),
			R.intFolio, R.intTipoProtesis, 
			strTipoProtesis=(SELECT P.strNombreTipoProtesis FROM tbTipoProtesis AS P WHERE P.intTipoProtesis=R.intTipoProtesis),
			R.intProceso, strProceso=(SELECT PRO.strNombreProceso FROM tbProceso PRO WHERE PRO.intProceso=R.intProceso),
			datEntrega=(CONVERT(VARCHAR(10),R.datFechaEntrega,103)),
			intDiasRetraso=(CASE  WHEN ((DATEDIFF(DD, R.datFechaEntrega, GETDATE())) <=0 ) THEN 0 ELSE (DATEDIFF(DD, R.datFechaEntrega, GETDATE())) END),
			R.strComentario, R.intEstatus,intPagado=ISNULL(R.intPagado, 0),
			R.strUsuarioAlta,R.strMaquinaAlta,R.datFechaAlta,
			dblCosto=ISNULL(R.dblPrecio,0),  
			dblPagado=ISNULL((SELECT SUM(dblMonto) FROM tbAbonoTrabajo AS A WHERE A.intOrdenLaboratorioEnc = R.intOrdenLaboratorioEnc),0),
			R.intEstatusProceso,
			strTieneImagen=(CASE ISNULL(strImagen01,'') WHEN '' THEN '' ELSE 'SI' END )+  
		   (CASE ISNULL(strImagen02,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen03,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen04,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen05,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen06,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen07,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen08,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen09,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen10,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen11,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen12,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen13,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen14,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen15,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen16,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen17,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen18,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen19,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen20,'') WHEN '' THEN '' ELSE 'SI' END )
	 		FROM tbOrdenLaboratorioEnc R WITH(NOLOCK)
			WHERE (R.intDoctor = @intDoctor OR @intDoctor = 0)
				AND (R.intProceso = @intProceso OR @intProceso = 0)
				AND (R.intTipoProtesis = @intProtesis OR @intProtesis = 0)
			ORDER BY R.intOrdenLaboratorioEnc DESC
		END
		ELSE
		BEGIN
			INSERT #tmpResultado(intEmpresa,intSucursal,intOrdenLaboratorioEnc,strNombrePaciente,strClinica,strDoctor,intFolio,intTipoProtesis,strTipoProtesis,
								intProceso,strProceso,datEntrega,intDiasRetraso,strComentario,intEstatus,intPagado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,
								dblCosto,dblPagado,intEstatusProceso,strTieneImagen)
			SELECT
			R.intEmpresa, R.intSucursal, R.intOrdenLaboratorioEnc,R.strNombrePaciente,
			strClinica='VACIA',--(Select C.strNombre From tbClinicas C Where C.intClinica=R.intClinica),
			strDoctor =(SELECT D.strNombre+' '+D.strApPaterno+' '+D.strApMaterno FROM tbDoctor AS D WHERE D.intDoctor = R.intDoctor),
			R.intFolio, R.intTipoProtesis, 
			strTipoProtesis=(SELECT P.strNombreTipoProtesis FROM tbTipoProtesis AS P WHERE P.intTipoProtesis=R.intTipoProtesis),
			R.intProceso, strProceso=(SELECT PRO.strNombreProceso FROM tbProceso PRO WHERE PRO.intProceso=R.intProceso),
			datEntrega=(CONVERT(VARCHAR(10),R.datFechaEntrega,103)),
			intDiasRetraso=(CASE  WHEN ((DATEDIFF(DD, R.datFechaEntrega, GETDATE())) <=0 ) THEN 0 ELSE (DATEDIFF(DD, R.datFechaEntrega, GETDATE())) END),
			R.strComentario, R.intEstatus,intPagado=ISNULL(R.intPagado, 0),
			R.strUsuarioAlta,R.strMaquinaAlta,R.datFechaAlta,
			dblCosto=ISNULL(R.dblPrecio,0),  
			dblPagado=ISNULL((SELECT SUM(dblMonto) FROM tbAbonoTrabajo AS A WHERE A.intOrdenLaboratorioEnc = R.intOrdenLaboratorioEnc),0),
			R.intEstatusProceso,
			strTieneImagen=(CASE ISNULL(strImagen01,'') WHEN '' THEN '' ELSE 'SI' END )+  
		   (CASE ISNULL(strImagen02,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen03,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen04,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen05,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen06,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen07,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen08,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen09,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen10,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen11,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen12,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen13,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen14,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen15,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen16,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen17,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen18,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen19,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen20,'') WHEN '' THEN '' ELSE 'SI' END )
	 		FROM tbOrdenLaboratorioEnc R WITH(NOLOCK)
			WHERE (R.intDoctor = @intDoctor OR @intDoctor = 0)
				AND (R.intTipoProtesis = @intProtesis OR @intProtesis = 0)
				AND (R.intProceso = @intProceso OR @intProceso = 0)
			ORDER BY R.intOrdenLaboratorioEnc DESC
		END

		SELECT R.intEmpresa, R.intSucursal, 
			--R.intOrdenLaboratorioEnc, strTieneImagen,
			intOrdenLaboratorioEnc=CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+' '+(CASE strTieneImagen WHEN '' THEN '' ELSE '&nbsp;<img  ALT=''Tiene Imagenes, ver en el Historial.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Imagen.png'' />' END),
			R.strNombrePaciente,
			strClinica,strDoctor,
			R.intFolio,
			R.intTipoProtesis, strTipoProtesis, strProceso,datEntrega,
			intDiasRetraso =( CASE WHEN R.intEstatus>=5 THEN 0 ELSE R.intDiasRetraso END),
			R.strComentario, R.intEstatus,
			strAccionEstatus=(ES.strNombre+'<a href=javascript:CambiarEstatusODental('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+
			');><img  ALT=''Fecha: '+(Convert(VarChar(10),E.datFecha,103))+'.  Usuario: '+E.strUsuario+
			'.  Comentario: '+E.strComentario+''' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/'+ES.strImagen+''' /></a>'),
			strAccionRechazar=('<a href=javascript:RechazoTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');>Rechazo</a>'),
			strAccionImagenes=('<a href=javascript:CargarImg('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');>Cargar</a>'),
			strAccionHistorial=('<a href=javascript:HistoriaTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');><img  ALT=''Ver Historial.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Info.png'' /></a>'),
			strAbonarTrabajo=(''+(CASE WHEN R.dblCosto - R.dblPagado = 0 THEN 'P<a href=javascript:fnAbonarTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+',' + CONVERT(VARCHAR(9),R.intPagado) 
							+');><img  ALT=''Abonar a este Trabajo.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Abonar.png'' />&nbsp;<img  ALT=''Pagado.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Verde.png'' />'
							WHEN R.dblPagado > 0 AND (R.dblCosto - R.dblPagado > 0) THEN 'A<a href=javascript:fnAbonarTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+',' + CONVERT(VARCHAR(9),R.intPagado) 
								+');><img  ALT=''Abonar a este Trabajo.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Abonar.png'' />&nbsp;<img  ALT=''Con Saldo.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Amarillo.png'' />'
							WHEN R.dblCosto >= 0 AND R.dblPagado = 0 THEN 'S<a href=javascript:fnAbonarTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+',' + CONVERT(VARCHAR(9),R.intPagado) 
								+');><img  ALT=''Abonar a este Trabajo.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Abonar.png'' />&nbsp;<img  ALT=''Sin Pago.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Rojo.png'' />' 
							ELSE '' END)+'</a>' ),
			strAccionVerDetalle=('<a href=javascript:DetalleTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');><img  ALT=''Ver Detalle.'' border=''0'' height=''32'' width=''32'' src='''+@PrefijoImagenes+'/Imagenes/Detalle.png'' /></a>'),
			strEstatusProceso = ((CASE R.intEstatus 
						WHEN 3 THEN (SELECT '<a href=javascript:EstatusProceso('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');><img  ALT='''+EP.strNombre+''' border=''0'' height=''32'' width=''32''	src='''+@PrefijoImagenes+'/Imagenes/'
							+EP.strImagen+''' /></a>' FROM tbEstatusProceso AS EP WHERE EP.intEstatusProceso = R.intEstatusProceso)
						ELSE '<img cursor=''hand'' ALT=''No Aplica.'' border=''0'' height=''32'' width=''32'' src='''+@PrefijoImagenes+'/Imagenes/Proceso1.png'' />' END) ), 

			R.strUsuarioAlta,R.strMaquinaAlta,R.datFechaAlta,
			R.dblCosto,R.dblPagado,dblSaldo=R.dblCosto - R.dblPagado
		FROM #tmpResultado AS R WITH(NOLOCK), tbCambioEstatusOrdenDental AS E WITH(NOLOCK), tbEstatus AS ES WITH(NOLOCK)
		WHERE E.intEmpresa=R.intEmpresa AND E.intSucursal=R.intSucursal
			AND ES.intEstatus=R.intEstatus AND ES.intEmpresa=R.intEmpresa AND ES.intSucursal=R.intSucursal
			AND E.intOrdenLaboratorioEnc=R.intOrdenLaboratorioEnc AND E.intEstatus=R.intEstatus AND E.intProceso=R.intProceso
		ORDER BY intDiasRetraso DESC, R.intOrdenLaboratorioEnc DESC

			
	END
	
	IF (@intPerfil=5)
	BEGIN
		IF (@intDoctor = 0 AND @intProtesis = 0 AND @intProceso = 0)
		BEGIN
			INSERT #tmpResultado(intEmpresa,intSucursal,intOrdenLaboratorioEnc,strNombrePaciente,strClinica,strDoctor,intFolio,intTipoProtesis,strTipoProtesis,
								intProceso,strProceso,datEntrega,intDiasRetraso,strComentario,intEstatus,intPagado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,
								dblCosto,dblPagado,intEstatusProceso,strTieneImagen)
			SELECT TOP 150
			R.intEmpresa, R.intSucursal, R.intOrdenLaboratorioEnc,--R.intClinica,
			R.strNombrePaciente,
			strClinica='VACIA',--(Select C.strNombre From tbClinicas C Where C.intClinica=R.intClinica), 
			strDoctor =(SELECT D.strNombre+' '+D.strApPaterno+' '+D.strApMaterno FROM tbDoctor AS D WHERE D.intDoctor = R.intDoctor),
			R.intFolio, R.intTipoProtesis, 
			strTipoProtesis=(SELECT P.strNombreTipoProtesis FROM tbTipoProtesis AS P WHERE P.intTipoProtesis=R.intTipoProtesis),
			R.intProceso, strProceso=(SELECT PRO.strNombreProceso FROM tbProceso PRO WHERE PRO.intProceso=R.intProceso),
			datEntrega=(CONVERT(VARCHAR(10),R.datFechaEntrega,103)),
			intDiasRetraso=(CASE  WHEN ((DATEDIFF(DD, R.datFechaEntrega, GETDATE())) <=0 ) THEN 0 ELSE (DATEDIFF(DD, R.datFechaEntrega, GETDATE())) END),
			R.strComentario, R.intEstatus,intPagado=0,
			R.strUsuarioAlta,R.strMaquinaAlta,R.datFechaAlta,
			dblCosto=ISNULL(R.dblPrecio,0),  
			dblPagado=ISNULL((SELECT SUM(dblMonto) FROM tbAbonoTrabajo AS A WHERE A.intOrdenLaboratorioEnc = R.intOrdenLaboratorioEnc),0),
			intEstatusProceso=0,
			strTieneImagen=(CASE ISNULL(strImagen01,'') WHEN '' THEN '' ELSE 'SI' END )+  
		   (CASE ISNULL(strImagen02,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen03,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen04,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen05,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen06,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen07,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen08,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen09,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen10,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen11,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen12,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen13,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen14,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen15,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen16,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen17,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen18,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen19,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen20,'') WHEN '' THEN '' ELSE 'SI' END )
	 		FROM tbOrdenLaboratorioEnc R WITH(NOLOCK)
			WHERE R.datFechaAlta>'01/01/2015' AND R.intOrdenLaboratorioEnc>=9025
				AND (R.intDoctor = @intDoctor OR @intDoctor = 0)
				AND (R.intTipoProtesis = @intProtesis OR @intProtesis = 0)
				AND (R.intProceso = @intProceso OR @intProceso = 0)
			ORDER BY R.intOrdenLaboratorioEnc DESC
		END
		ELSE
		BEGIN
			INSERT #tmpResultado(intEmpresa,intSucursal,intOrdenLaboratorioEnc,strNombrePaciente,strClinica,strDoctor,intFolio,intTipoProtesis,strTipoProtesis,
								intProceso,strProceso,datEntrega,intDiasRetraso,strComentario,intEstatus,intPagado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,
								dblCosto,dblPagado,intEstatusProceso,strTieneImagen)
			SELECT
			R.intEmpresa, R.intSucursal, R.intOrdenLaboratorioEnc,--R.intClinica,
			R.strNombrePaciente,
			strClinica='VACIA',--(Select C.strNombre From tbClinicas C Where C.intClinica=R.intClinica), 
			strDoctor =(SELECT D.strNombre+' '+D.strApPaterno+' '+D.strApMaterno FROM tbDoctor AS D WHERE D.intDoctor = R.intDoctor),
			R.intFolio, R.intTipoProtesis, 
			strTipoProtesis=(SELECT P.strNombreTipoProtesis FROM tbTipoProtesis AS P WHERE P.intTipoProtesis=R.intTipoProtesis),
			R.intProceso, strProceso=(SELECT PRO.strNombreProceso FROM tbProceso PRO WHERE PRO.intProceso=R.intProceso),
			datEntrega=(CONVERT(VARCHAR(10),R.datFechaEntrega,103)),
			intDiasRetraso=(CASE  WHEN ((DATEDIFF(DD, R.datFechaEntrega, GETDATE())) <=0 ) THEN 0 ELSE (DATEDIFF(DD, R.datFechaEntrega, GETDATE())) END),
			R.strComentario, R.intEstatus,intPagado=0,
			R.strUsuarioAlta,R.strMaquinaAlta,R.datFechaAlta,
			dblCosto=ISNULL(R.dblPrecio,0),  
			dblPagado=ISNULL((SELECT SUM(dblMonto) FROM tbAbonoTrabajo AS A WHERE A.intOrdenLaboratorioEnc = R.intOrdenLaboratorioEnc),0),
			intEstatusProceso=0,
			strTieneImagen=(CASE ISNULL(strImagen01,'') WHEN '' THEN '' ELSE 'SI' END )+  
		   (CASE ISNULL(strImagen02,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen03,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen04,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen05,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen06,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen07,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen08,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen09,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen10,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen11,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen12,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen13,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen14,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen15,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen16,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen17,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen18,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen19,'') WHEN '' THEN '' ELSE 'SI' END )+
		   (CASE ISNULL(strImagen20,'') WHEN '' THEN '' ELSE 'SI' END )
	 		FROM tbOrdenLaboratorioEnc R WITH(NOLOCK)
			WHERE R.datFechaAlta>'01/01/2015' AND R.intOrdenLaboratorioEnc>=9025
				AND (R.intDoctor = @intDoctor OR @intDoctor = 0)
				AND (R.intTipoProtesis = @intProtesis OR @intProtesis = 0)
				AND (R.intProceso = @intProceso OR @intProceso = 0)
			ORDER BY R.intOrdenLaboratorioEnc DESC
		END

		SELECT R.intEmpresa, R.intSucursal, 
			--R.intOrdenLaboratorioEnc, strTieneImagen,
			intOrdenLaboratorioEnc=CONVERT(VARCHAR(10),R.intOrdenLaboratorioEnc)+' '+(CASE strTieneImagen WHEN '' THEN '' ELSE '&nbsp;<img  ALT=''Tiene Imagenes, ver en el Historial.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Imagen.png'' />' END),
			R.strNombrePaciente,strClinica,R.strDoctor, R.intFolio, R.intTipoProtesis, 
			strTipoProtesis, strProceso,datEntrega,R.intDiasRetraso,R.strComentario, R.intEstatus,R.intClinica,
			strAccionEstatus=(ES.strNombre+'<a href=javascript:CambiarEstatusODental('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+
			');><img  ALT=''Fecha: '+(Convert(VarChar(10),E.datFecha,103))+'.  Usuario: '+E.strUsuario+
			'.  Comentario: '+E.strComentario+''' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/'+ES.strImagen+''' /></a>'),
			strAccionRechazar=('<a href=javascript:RechazoTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');>Rechazo</a>'),
			strAccionImagenes=('<a href=javascript:CargarImg('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');>Cargar</a>'),
			strAccionHistorial=('<a href=javascript:HistoriaTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');><img  ALT=''Ver Historial.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Info.png'' /></a>'),
			strAbonarTrabajo=('.'),
			strAccionVerDetalle=('.'),			
			strEstatusProceso=('.'),
			R.strUsuarioAlta,R.strMaquinaAlta,R.datFechaAlta,R.strUsuarioMod,R.strMaquinaMod,R.datFechaMod
		FROM #tmpResultado AS R WITH(NOLOCK), tbCambioEstatusOrdenDental AS E WITH(NOLOCK), tbEstatus AS ES WITH(NOLOCK)
		WHERE E.intEmpresa=R.intEmpresa AND E.intSucursal=R.intSucursal
			AND ES.intEstatus=R.intEstatus AND ES.intEmpresa=R.intEmpresa AND ES.intSucursal=R.intSucursal
			AND E.intOrdenLaboratorioEnc=R.intOrdenLaboratorioEnc AND E.intEstatus=R.intEstatus AND E.intProceso=R.intProceso
			AND R.intEmpresa=@intEmpresa AND R.intClinica=@intSucursal
		ORDER BY intDiasRetraso DESC, R.intOrdenLaboratorioEnc DESC

			
	END
	
	
	IF (@intPerfil=4)
	BEGIN
		IF (@intDoctor = 0 AND @intProtesis = 0 AND @intProceso = 0)
		BEGIN
			INSERT #tmpResultado(intEmpresa,intSucursal,intOrdenLaboratorioEnc,strNombrePaciente,strClinica,strDoctor,intFolio,intTipoProtesis,strTipoProtesis,
								intProceso,strProceso,datEntrega,intDiasRetraso,strComentario,intEstatus,intPagado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,
								dblCosto,dblPagado,intEstatusProceso,strTieneImagen)
			SELECT TOP 150
			R.intEmpresa, R.intSucursal, R.intOrdenLaboratorioEnc,R.strNombrePaciente,
			strClinica=(Select C.strNombre From tbClinicas C Where C.intClinica=R.intClinica), 
			strDoctor='',
			R.intFolio, R.intTipoProtesis, 
			strTipoProtesis=(SELECT P.strNombreTipoProtesis FROM tbTipoProtesis AS P WHERE P.intTipoProtesis=R.intTipoProtesis),
			R.intProceso, 
			strProceso=(SELECT PRO.strNombreProceso FROM tbProceso PRO WHERE PRO.intProceso=R.intProceso),
			datEntrega=(CONVERT(VARCHAR(10),R.datFechaEntrega,103)),
			intDiasRetraso=(CASE  WHEN ((DATEDIFF(DD, R.datFechaEntrega, GETDATE())) <=0 ) THEN 0 ELSE (DATEDIFF(DD, R.datFechaEntrega, GETDATE())) END),
			R.strComentario, R.intEstatus,intPagado=0,
			R.strUsuarioAlta,R.strMaquinaAlta,R.datFechaAlta,
			dblCosto=0,dblPagado=0,intEstatusProceso=0,strTieneImagen=''
	 		FROM tbOrdenLaboratorioEnc R WITH(NOLOCK)
			WHERE R.datFechaAlta>'01/01/2015' AND R.intOrdenLaboratorioEnc>=9025
				AND (R.intDoctor = @intDoctor OR @intDoctor = 0)
				AND (R.intTipoProtesis = @intProtesis OR @intProtesis = 0)
				AND (R.intProceso = @intProceso OR @intProceso = 0)
			ORDER BY R.intOrdenLaboratorioEnc DESC
		END
		ELSE
		BEGIN
			INSERT #tmpResultado(intEmpresa,intSucursal,intOrdenLaboratorioEnc,strNombrePaciente,strClinica,strDoctor,intFolio,intTipoProtesis,strTipoProtesis,
								intProceso,strProceso,datEntrega,intDiasRetraso,strComentario,intEstatus,intPagado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,
								dblCosto,dblPagado,intEstatusProceso,strTieneImagen)
			SELECT 
			R.intEmpresa, R.intSucursal, R.intOrdenLaboratorioEnc,R.strNombrePaciente,
			strClinica=(Select C.strNombre From tbClinicas C Where C.intClinica=R.intClinica), 
			strDoctor='',
			R.intFolio, R.intTipoProtesis, 
			strTipoProtesis=(SELECT P.strNombreTipoProtesis FROM tbTipoProtesis AS P WHERE P.intTipoProtesis=R.intTipoProtesis),
			R.intProceso, 
			strProceso=(SELECT PRO.strNombreProceso FROM tbProceso PRO WHERE PRO.intProceso=R.intProceso),
			datEntrega=(CONVERT(VARCHAR(10),R.datFechaEntrega,103)),
			intDiasRetraso=(CASE  WHEN ((DATEDIFF(DD, R.datFechaEntrega, GETDATE())) <=0 ) THEN 0 ELSE (DATEDIFF(DD, R.datFechaEntrega, GETDATE())) END),
			R.strComentario, R.intEstatus,intPagado=0,
			R.strUsuarioAlta,R.strMaquinaAlta,R.datFechaAlta,
			dblCosto=0,dblPagado=0,intEstatusProceso=0,strTieneImagen=''
	 		FROM tbOrdenLaboratorioEnc R WITH(NOLOCK)
			WHERE R.datFechaAlta>'01/01/2015' AND R.intOrdenLaboratorioEnc>=9025
				AND (R.intDoctor = @intDoctor OR @intDoctor = 0)
				AND (R.intTipoProtesis = @intProtesis OR @intProtesis = 0)
				AND (R.intProceso = @intProceso OR @intProceso = 0)
			ORDER BY R.intOrdenLaboratorioEnc DESC
		END

		SELECT R.intEmpresa, R.intSucursal, R.intOrdenLaboratorioEnc, R.strNombrePaciente,strClinica,R.intFolio, R.intTipoProtesis, 
			strTipoProtesis, strProceso,datEntrega,R.intDiasRetraso,R.strComentario, R.intEstatus,
			strAccionEstatus=(ES.strNombre+'<a href=javascript:CambiarEstatusODental('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+
			');><img  ALT=''Fecha: '+(Convert(VarChar(10),E.datFecha,103))+'.  Usuario: '+E.strUsuario+
			'.  Comentario: '+E.strComentario+''' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/'+ES.strImagen+''' /></a>'),
			strAccionRechazar=('<a href=javascript:RechazoTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');>Rechazo</a>'),
			strAccionImagenes=('<a href=javascript:CargarImg('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');>Cargar</a>'),
			strAccionHistorial=('<a href=javascript:HistoriaTrabajo('+CONVERT(VARCHAR(9),R.intOrdenLaboratorioEnc)+');><img  ALT=''Ver Historial.'' border=''0''  src='''+@PrefijoImagenes+'/Imagenes/Info.png'' /></a>'),
			strAbonarTrabajo=('.'),
			strAccionVerDetalle=('.'),			
			strEstatusProceso=('.'),
			R.strUsuarioAlta,R.strMaquinaAlta,R.datFechaAlta,R.strUsuarioMod,R.strMaquinaMod,R.datFechaMod
		FROM #tmpResultado AS R WITH(NOLOCK), tbCambioEstatusOrdenDental AS E WITH(NOLOCK), tbEstatus AS ES WITH(NOLOCK)
		WHERE E.intEmpresa=R.intEmpresa AND E.intSucursal=R.intSucursal
			AND ES.intEstatus=R.intEstatus AND ES.intEmpresa=R.intEmpresa AND ES.intSucursal=R.intSucursal
			AND E.intOrdenLaboratorioEnc=R.intOrdenLaboratorioEnc AND E.intEstatus=R.intEstatus AND E.intProceso=R.intProceso
			AND R.strUsuarioAlta=@strUsuario
		ORDER BY intDiasRetraso DESC, R.intOrdenLaboratorioEnc DESC
	END
END
go


go
--qry_V2_OrdenLaboratorioDet_SelXOrdenLaboratorio 1, 1, 6
CREATE PROCEDURE qry_V2_OrdenLaboratorioDet_SelXOrdenLaboratorio
(
	@intEmpresa INT, 
	@intSucursal INT, 
	@intOrdenLaboratorioEnc INT
)
AS
BEGIN
	SELECT 
		intEmpresa, intSucursal, intOrdenLaboratorioEnc, intOrdenLaboratorioDet, intPieza, intMaterial, intTipoTrabajo, strColor=intCantidad,intCantidad,
		--strMaterial y strTrabajo no hacen nada, solo es para pasar los parametros en el grid de Detalle de OrdenLaboratorio
		material=(SELECT M.strNombre FROM tbMaterial2024 M WHERE M.intMaterial=OD.intMaterial),
		trabajo=(SELECT T.strNombre FROM tbTipoTrabajo2024 T WHERE T.intTipoTrabajo=OD.intTipoTrabajo)
		------------------------------------------------------------------------------------------------
	FROM 
		tbOrdenLaboratorioDet AS OD
	WHERE 
		intEmpresa = @intEmpresa AND 
		intSucursal = @intSucursal AND 
		intOrdenLaboratorioEnc = @intOrdenLaboratorioEnc
	ORDER BY intOrdenLaboratorioDet
END
go


go
--qryColorPorColorimetro_Sel 1,1,1,0
CREATE PROCEDURE qry_V2_ColorPorColorimetro_Sel
	@intEmpresa INT, 
	@intSucursal INT, 
	@intColorimetro INT, 
	@intColor INT
AS
BEGIN
	SET NOCOUNT ON
	SELECT intColorimetro, intColor, strNombre
	FROM tbColor2024 AS C WHERE 
		(C.intColor = @intColor OR @intColor=0)
		--AND intEmpresa=@intEmpresa
		--AND intSucursal=@intSucursal
		AND intColorimetro=@intColorimetro
	SET NOCOUNT OFF
END
go


go
--qryTipoProtesis_Sel @intEmpresa = 1, @intSucursal = 1, @intTipoProtesis = 0 , @intActivas= 1
CREATE PROCEDURE qry_V2_TipoProtesis_Sel(
	 @intEmpresa		INT     
	,@intSucursal		INT     
	,@intTipoProtesis	INT   
	,@intActivas		INT = NULL
)    
AS    
BEGIN    

	SET @intActivas = ISNULL(@intActivas, 0)


	SET NOCOUNT ON;    
	SELECT intEmpresa,intSucursal,intTipoProtesis,strNombreTipoProtesis,intProcesoLaboratorio   
	FROM tbTipoProtesis2024(NOLOCK)    
	WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal 
		AND (intTipoProtesis=@intTipoProtesis OR @intTipoProtesis=0)    
		AND (isActivo = @intActivas OR @intActivas=0)    
END
go

go
--qry_Doctor_Sel 0
CREATE PROCEDURE qry_V2_Doctor_Sel
	 @intDoctor INT
	,@intActivo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET @intActivo = ISNULL(@intActivo, 0)

	IF @intActivo = 1
	BEGIN
		SELECT
			DR.intDoctor, DR.strNombre, DR.strApPaterno, DR.strApMaterno, strNombreCompleto = DR.strNombre+' '+DR.strApPaterno+' '+DR.strApMaterno, 
			DR.strDireccion, DR.strEMail, DR.strColonia,
			DR.strRFC, DR.strNombreFiscal, DR.intCP, DR.strTelefono, DR.strCelular, DR.strDireccionFiscal, 	
			DR.isActivo, DR.IsBorrado, 
			DR.strUsuarioAlta, DR.strMaquinaAlta, DR.datFechaAlta, DR.strUsuarioMod, DR.strMaquinaMod, DR.datFechaMod
		FROM  tbDoctor2024 AS DR WITH(NOLOCK)
		WHERE DR.IsBorrado <> 1
			AND (DR.intDoctor = @intDoctor OR @intDoctor = 0)
			AND (DR.isActivo = @intActivo OR @intActivo = 0)
		ORDER BY DR.strNombre+' '+DR.strApPaterno+' '+DR.strApMaterno
	END
	ELSE
	BEGIN
		SELECT
			DR.intDoctor, DR.strNombre, DR.strApPaterno, DR.strApMaterno, strNombreCompleto = DR.strNombre+' '+DR.strApPaterno+' '+DR.strApMaterno, 
			DR.strDireccion, DR.strEMail, DR.strColonia,
			DR.strRFC, DR.strNombreFiscal, DR.intCP, DR.strTelefono, DR.strCelular, DR.strDireccionFiscal, 	
			DR.isActivo, DR.IsBorrado, 
			DR.strUsuarioAlta, DR.strMaquinaAlta, DR.datFechaAlta, DR.strUsuarioMod, DR.strMaquinaMod, DR.datFechaMod
		FROM  tbDoctor2024 AS DR WITH(NOLOCK)
		WHERE DR.IsBorrado <> 1
			AND (DR.intDoctor = @intDoctor OR @intDoctor = 0)
			AND (DR.isActivo = @intActivo OR @intActivo = 0)
		ORDER BY DR.intDoctor
	END
END
go


go
--qryProcesosIniciales_Sel @intEmpresa = 1, @intSucursal = 1, @intProtesis = 2, @intProceso = 0, @intActivos = 1
CREATE PROCEDURE qry_V2_ProcesosIniciales_Sel
	 @intEmpresa	INT 
	,@intSucursal	INT 
	,@intProtesis	INT 
	,@intProceso	INT
	,@intActivos	INT = NULL
AS
BEGIN
	SET NOCOUNT ON

	SET @intActivos = ISNULL(@intActivos, 0)


	SELECT 
		intProceso, intLaboratorio, intFolioProceso, strNombreProceso
	FROM tbProceso2024 P WHERE 
		(intProceso = @intProceso OR @intProceso=0)
		AND intEmpresa=@intEmpresa
		AND intSucursal=@intSucursal 
		AND intLaboratorio=@intProtesis 
		AND (isActivo = @intActivos OR @intActivos=0)    
	SET NOCOUNT OFF
END
go


go
CREATE PROCEDURE qry_V2_BuscarOrdenLaboratorio_SEL
	 @Empresa				INT = NULL
	,@intSucursal			INT = NULL
	,@Folio					INT = NULL
	,@intDoctor				INT = NULL
	,@intTipoProtesis		INT = NULL
AS
BEGIN

	SET @Empresa = ISNULL(@Empresa, 1)
	SET @intSucursal = ISNULL(@intSucursal, 1)
	SET @Folio = ISNULL(@Folio, 0)
	SET @intDoctor = ISNULL(@intDoctor, 0)
	SET @intTipoProtesis = ISNULL(@intTipoProtesis, 0)

	SELECT 
		Folio=intFolio, 
		Fecha=(Convert(Varchar(10),datFechaEntrega,103)), 
		Folio_OrdenLab=intOrdenLaboratorioEnc, 
		Doctor=ISNULL((SELECT D.strNombre+' '+D.strApPaterno+' '+D.strApMaterno 
						FROM tbDoctor D 
						WHERE D.intDoctor=O.intDoctor),'- - -'), 
		Protesis=( SELECT P.strNombreTipoProtesis 
					FROM tbtipoProtesis P 
					WHERE P.intTipoProtesis = O.intTipoProtesis ) 
		, O.intDoctor, O.intTipoProtesis 
	FROM tbOrdenLaboratorioEnc O 
	WHERE intEmpresa = @Empresa
		AND intSucursal = @intSucursal 
		AND (intOrdenLaboratorioEnc = @Folio OR @Folio = 0)
		AND (intDoctor = @intDoctor OR @intDoctor = 0)
		AND (intTipoProtesis = @intTipoProtesis OR @intTipoProtesis = 0)
	ORDER BY intFolio DESC 
END
go


go
--qry_V2_ListarMaterialesActivos_SEL 0
CREATE  PROCEDURE qry_V2_ListarMaterialesActivos_SEL  
    @intMaterial INT = NULL
AS   
BEGIN
	SET @intMaterial = ISNULL(@intMaterial, 0) 

	SET NOCOUNT ON;
    SELECT intMaterial, strNombreMaterial=strNombre, isActivo, strUsuarioAlta, strMaquinaAlta, datFechaAlta, strUsuarioMod, strMaquinaMod, datFechaMod
	FROM tbMaterial2024 WITH(NOLOCK)
    WHERE isActivo = 1
		AND (intMaterial = @intMaterial or @intMaterial = 0)
END
go


go
--qry_V2_TipoTrabajoXMaterial_Sel 1, 1, 7, 0
CREATE PROCEDURE qry_V2_TipoTrabajoXMaterial_Sel
(
	 @intEmpresa		INT 
	,@intSucursal		INT 
	,@intMaterial		INT 
	,@intTipoTrabajo	INT 
	,@intActivos		INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @intActivos = ISNULL(@intActivos, 0)


	SELECT intTipoTrabajo,strNombre,strNombreCorto,intMaterial,
		strMaterial = (SELECT M.strNombre FROM tbMaterial AS M WHERE M.intMAterial = T.intMAterial),
		dblPrecio,dblPrecioUrgencia,isActivo,
		strActivo =(CASE isActivo WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' ELSE '.' END )
	FROM tbTipoTrabajo2024(NOLOCK) AS T
	WHERE intMaterial=@intMaterial
		AND (isActivo = @intActivos OR @intActivos=0) 
END
go


go
--qry_V2_tbOrdenLaboratorioDet_App 1,1,0,1,3.2,1,1,'A1.5','material varchar','tipotrabajo varchar','JORGE','10.0.0.65'
CREATE PROCEDURE qry_V2_tbOrdenLaboratorioDet_App
@intEmpresa INT,  
@intSucursal INT,  
@intOrdenLaboratorioDet INT,  
@intOrdenLaboratorioEnc INT,  
@intPieza VARCHAR (1000),
@intMaterial INT,  
@intTipoTrabajo INT,  
--@intCantidad INT,
@strColor INT,
--@strColor VARCHAR(7), --CAMBIAMOS POR CANTIDAD
@material varchar (1000),
@trabajo varchar (1000),
@strUsuario VARCHAR(50),  
@strMaquina VARCHAR(50)  

AS  
BEGIN


	DECLARE @ID INT, @Posicion2 INT, @idPieza VARCHAR(150), @ListadoPiezas VARCHAR(1000)	 
	DECLARE @tbPiezas TABLE (idPieza INT IDENTITY(1, 1), strPiezaIndividual NVARCHAR(20))
	
	SET @ListadoPiezas = REPLACE(@intPieza, '~1', ',1')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, '~2', ',2')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, '~3', ',3')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, '~4', ',4')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, '~', '')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, ' ', '')

	IF @intPieza is null
	BEGIN  
		RAISERROR('Se debe indicar la pieza. No se insertaron datos.', 16, 1)  
		RETURN  
	END

	IF @intMaterial is null
	BEGIN  
		RAISERROR('Se debe indicar el material. No se insertaron datos.', 16, 1)  
		RETURN  
	END  

	IF @intTipoTrabajo is null
	BEGIN  
		RAISERROR('Se debe indicar el tipo de trabajo. No se insertaron datos.', 16, 1)  
		RETURN  
	END  


	DECLARE @strError VARCHAR (500),@intPiezaNoExiste VARCHAR (30)


	DECLARE @intPiezaCapturada NUMERIC(18,1)
	IF EXISTS (SELECT * FROM tbOrdenLaboratorioDet WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal 
			AND intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc AND @intOrdenLaboratorioDet = 0 AND intPieza = @intPieza)
	BEGIN
	SET @intPiezaCapturada=@intPieza
		SET @strError=('LA PIEZA "'+convert(varchar(8),@intPiezaCapturada)+'" YA FUE REGISTRADA EN ESTA ORDEN. INGRESE OTRA PIEZA.')      
		RAISERROR (@strError, 16, 1)      
		RETURN      
	END

	
	SET @intPieza = REPLACE(@intPieza, ' ', '')

	SET @intPieza = @intPieza + '~'
	WHILE patindex('%~%' , @intPieza) <> 0
	BEGIN
		SELECT @Posicion2 =  patindex('%~%' , @intPieza)
		SELECT @idPieza = left(@intPieza, @Posicion2 - 1)
		IF NOT EXISTS (SELECT strPiezaIndividual FROM @tbPiezas WHERE strPiezaIndividual = @idPieza)
		BEGIN 
			INSERT @tbPiezas (strPiezaIndividual)
			SELECT
				strPiezaIndividual = @idPieza
				WHERE @idPieza <> '' 
		END

		SELECT @intPieza = stuff(@intPieza, 1, @Posicion2, '')
	END

	SELECT @strColor = COUNT(idPieza) FROM @tbPiezas


	IF NOT EXISTS(SELECT * FROM tbOrdenLaboratorioDet WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal AND intOrdenLaboratorioDet=@intOrdenLaboratorioDet) OR @intOrdenLaboratorioDet=0
	BEGIN
		INSERT tbOrdenLaboratorioDet(intEmpresa,intSucursal,intOrdenLaboratorioEnc,intPieza,intMaterial,intTipoTrabajo,
			strColor,intCantidad,strUsuarioAlta,strMaquinaAlta,datFechaAlta)  
		SELECT intEmpresa = @intEmpresa,intSucursal=@intSucursal,intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc,intPieza=UPPER(@ListadoPiezas),intMaterial=@intMaterial,
			intTipoTrabajo=@intTipoTrabajo,
			strColor=@strColor,intCantidad=@strColor,strUsuarioAlta=@strUsuario,strMaquinaAlta=@strMaquina,datFechaAlta=GETDATE()

		SET @ID = IDENT_CURRENT('tbOrdenLaboratorioDet')
	END
	ELSE  
	BEGIN  
		UPDATE tbOrdenLaboratorioDet  
		SET
			intEmpresa=@intEmpresa,
			intSucursal=@intSucursal,
			intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc,
			intPieza=UPPER(@ListadoPiezas),
			intMaterial=@intMaterial,
			intTipoTrabajo=@intTipoTrabajo,
			strColor=@strColor,
			intCantidad=@strColor,
			strUsuarioMod=@strUsuario,
			strMaquinaMod=@strMaquina,
			datFechaMod=GETDATE()
		WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal AND intOrdenLaboratorioDet=@intOrdenLaboratorioDet

		SET @ID = @intOrdenLaboratorioDet
	END

	SELECT result = @ID, Mensaje = 'Se agregó detalle a la orden '+CONVERT(VARCHAR(10), @intOrdenLaboratorioEnc)
END
go

 
