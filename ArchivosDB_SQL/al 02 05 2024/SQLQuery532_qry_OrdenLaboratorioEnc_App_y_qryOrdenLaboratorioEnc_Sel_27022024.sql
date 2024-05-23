USE LabAllCeramic
go

--


go
--qryOrdenLaboratorioEnc_Sel 1,1,0
alter PROCEDURE qryOrdenLaboratorioEnc_Sel
(@intEmpresa INT, 
@intSucursal INT, 
@intOrdenLaboratorioEnc INT)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT T.intEmpresa, T.intSucursal, T.intOrdenLaboratorioEnc, 
	strEncabezado=(CASE @intEmpresa 
					WHEN 1 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color:#000000; border-width: 1px;">Abonar al Trabajo: '+CONVERT(VARCHAR(9),T.intOrdenLaboratorioEnc)+'</p>'
					WHEN 2 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color:#000000; border-width: 1px;">Abonar al Trabajo: '+CONVERT(VARCHAR(9),T.intOrdenLaboratorioEnc)+'</p>'
					WHEN 3 THEN '<p style="padding-bottom: 10px; padding-top: 10px; font-weight: bold; font-size: 20px; background-color: #00A2E8; color: #004664; padding-left: 10px; font-family: TAHOMA; border-bottom-style: solid; border-top-style: solid; border-color:#000000; border-width: 1px;">Abonar al Trabajo: '+CONVERT(VARCHAR(9),T.intOrdenLaboratorioEnc)+'</p>'
					ELSE '' END),
	dblCosto=ISNULL(T.dblPrecio,0),
	dblPagado=ISNULL((SELECT SUM(dblMonto) FROM tbAbonoTrabajo AS A WHERE A.intOrdenLaboratorioEnc = T.intOrdenLaboratorioEnc),0),
	dblSaldo = ISNULL(((ISNULL(T.dblPrecio,0)) -((SELECT SUM(dblMonto) FROM tbAbonoTrabajo AS A WHERE A.intOrdenLaboratorioEnc = T.intOrdenLaboratorioEnc)) ),0),

--qryOrdenLaboratorioEnc_Sel 1,1,0


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
	--T.strColor, 
	strColor = CLO.strNombre,
	T.strComentario,
	T.strObservaciones,T.intEdad,T.intSexo, intGarantia = T.intConGarantia,
	T.intEstatus, 
	--datFechaAlta=CONVERT(VARCHAR(10), datFechaAlta,103),
	--datFechaEntrega=CONVERT(VARCHAR(10), datFechaEntrega,103), 
	--datFechaColocacion=CONVERT(VARCHAR(10), datFechaColocacion,103), 
	T.intColorimetro,
	strColorimetro = CLI.strNombre,
	T.intColor,T.intFactura,
	dblPrecio=ISNULL(T.dblPrecio,0),
	dblPrecioReal=ISNULL((SELECT SUM(TT.dblPrecio) FROM tbOrdenLaboratorioDet AS D, tbTipoTrabajo AS TT WHERE TT.intTipoTrabajo=D.intTipoTrabajo AND D.intOrdenLaboratorioEnc =  T.intOrdenLaboratorioEnc),0),
	datFechaAlta=T.datFechaAlta,  
	strFechaAlta=CONVERT(VARCHAR(10), T.datFechaAlta, 103),
	datFechaEntrega=T.datFechaEntrega,  
	datFechaColocacion=T.datFechaColocacion, intUrgente =ISNULL(T.intUrgente,0),intLabExterno=ISNULL(T.intLabExterno,0),
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
--qry_OrdenLaboratorioEnc_App 1,1,5,5,2,'WQ',2,2,124,1,1.1,6,1,'a1','222',1,'26/04/2018','10/10/2018',1,0,'JORGE','::1'
alter PROCEDURE dbo.qry_OrdenLaboratorioEnc_App
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
