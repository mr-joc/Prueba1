USE LabAllCeramic
go

--

go
alter PROCEDURE Busca      
(      
@Buscar VarChar(4000),  
@strOrden VARCHAR(10) =  NULL    
)      
AS  
BEGIN  
	SET NOCOUNT ON       
	SELECT DISTINCT idObjeto=sc.ID, nomObjeto=OBJECT_NAME(sc.ID)  
	INTO #Result  
	FROM sysComments sc      
	WHERE sc.Text Like '%' + @Buscar + '%'  
  
	IF @strOrden IS NULL  
	BEGIN  
		SELECT O.idObjeto, O.nomObjeto, Creado=SYS.create_date, Modificado=SYS.modify_date  
		FROM #Result AS O, sys.all_objects AS SYS  
		WHERE SYS.object_id=O.idObjeto  
		ORDER BY O.idObjeto ASC  
	END  
	ELSE  
	BEGIN  
		IF @strOrden = 'M'  
		BEGIN  
			SELECT O.idObjeto, O.nomObjeto, Creado=SYS.create_date, Modificado=SYS.modify_date  
			FROM #Result AS O, sys.all_objects AS SYS  
			WHERE SYS.object_id=O.idObjeto  
			ORDER BY SYS.modify_date DESC  
		END  
		IF @strOrden = 'C'  
		BEGIN  
			SELECT O.idObjeto, O.nomObjeto, Creado=SYS.create_date, Modificado=SYS.modify_date  
			FROM #Result AS O, sys.all_objects AS SYS  
			WHERE SYS.object_id=O.idObjeto  
			ORDER BY SYS.create_date DESC  
		END  
		IF @strOrden = 'N'  
		BEGIN  
			SELECT O.idObjeto, O.nomObjeto, Creado=SYS.create_date, Modificado=SYS.modify_date  
			FROM #Result AS O, sys.all_objects AS SYS  
			WHERE SYS.object_id=O.idObjeto  
			ORDER BY O.nomObjeto ASC  
		END  
	END  
END
go



go
--qryOrdenLaboratorioEnc_Sel 1,1,0
alter PROCEDURE qry_V2_OrdenLaboratorioEnc_Sel
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
	strFechaAlta=CONVERT(VARCHAR(10), T.datFechaAlta,103),
	--datFechaEntrega=CONVERT(VARCHAR(10), datFechaEntrega,103), 
	--datFechaColocacion=CONVERT(VARCHAR(10), datFechaColocacion,103), 
	T.intColorimetro,
	strColorimetro = CLI.strNombre,
	T.intColor,T.intFactura,
	dblPrecio=ISNULL(T.dblPrecio,0),
	dblPrecioReal=ISNULL((SELECT SUM(TT.dblPrecio) FROM tbOrdenLaboratorioDet AS D, tbTipoTrabajo AS TT WHERE TT.intTipoTrabajo=D.intTipoTrabajo AND D.intOrdenLaboratorioEnc =  T.intOrdenLaboratorioEnc),0),
	datFechaAlta=T.datFechaAlta,  
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


qryOrdenLaboratorioEnc_Sel @intEmpresa = 1, @intSucursal = 1,@intOrdenLaboratorioEnc = 941
go

