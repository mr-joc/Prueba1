USE LabAllCeramic
go



go
--qry_V2_OrdenLaboratorioEnc_Sel 1,1,1002
alter PROCEDURE qry_V2_OrdenLaboratorioEnc_Sel
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



--qry_V2_OrdenLaboratorioEnc_Sel @intEmpresa = 1, @intSucursal =1, @intOrdenLaboratorioEnc = 6616
--go

--qry_V2_OrdenLaboratorioEnc_Sel @intEmpresa = 1, @intSucursal =1, @intOrdenLaboratorioEnc = 1002
--go




go
--qry_V2_AbonoTrabajo_SEL 1, 1, 11
alter PROCEDURE qry_V2_AbonoTrabajo_SEL 
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


qry_V2_AbonoTrabajo_SEL @intEmpresa = 1, @intSucursal = 1, @intOrdenLaboratorioEnc = 6616


--           
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


go
--qry_V2_AbonoTrabajo_App 1,1, 0, 7,2600,'JORGE','10.0.0.65'
alter PROCEDURE qry_V2_AbonoTrabajo_App (
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

/*

qry_V2_AbonoTrabajo_App 
@intEmpresa					= 1
,@intSucursal				= 1
,@intAbonoTrabajo			= 0
,@intOrdenLaboratorioEnc	= 6616
,@dblMonto					= 45
,@strUsuario				= 'MR-JOC'
,@strMaquina				= '127.0.0.1'

*/




