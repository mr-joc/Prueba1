USE LabAllCeramic
go



go
--qryOrdenLaboratorioEnc_SelDetalle_PorUsuario @strUsuario = 'JORGE', @intEsVersion2024 = 1
alter PROCEDURE dbo.qryOrdenLaboratorioEnc_SelDetalle_PorUsuario
	 @strUsuario			VARCHAR (100)
	,@intEsVersion2024		INT = NULL
	,@intDoctor				INT = NULL
	,@intProtesis			INT = NULL
	,@intProceso			INT = NULL
	,@intOrden				INT = NULL
	,@strPaciente			NVARCHAR(150) = NULL

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
	SET @strPaciente = ISNULL(@strPaciente, '0') 
	SET @intOrden = ISNULL(@intOrden, 0) 

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
			AND (R.strNombrePaciente LIKE '%'+@strPaciente+'%' OR @strPaciente = '0') 
			AND (R.intOrdenLaboratorioEnc = @intOrden OR @intOrden = 0) 
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
			AND (R.strNombrePaciente LIKE '%'+@strPaciente+'%' OR @strPaciente = '0') 
			AND (R.intOrdenLaboratorioEnc = @intOrden OR @intOrden = 0) 
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
			AND (R.strNombrePaciente LIKE '%'+@strPaciente+'%' OR @strPaciente = '0') 
			AND (R.intOrdenLaboratorioEnc = @intOrden OR @intOrden = 0) 
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
				AND (R.strNombrePaciente LIKE '%'+@strPaciente+'%' OR @strPaciente = '0') 
				AND (R.intOrdenLaboratorioEnc = @intOrden OR @intOrden = 0) 
			AND (R.strNombrePaciente LIKE '%'+@strPaciente+'%' OR @strPaciente = '0') 
			AND (R.intOrdenLaboratorioEnc = @intOrden OR @intOrden = 0) 
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
			AND (R.strNombrePaciente LIKE '%'+@strPaciente+'%' OR @strPaciente = '0') 
			AND (R.intOrdenLaboratorioEnc = @intOrden OR @intOrden = 0) 
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
			AND (R.strNombrePaciente LIKE '%'+@strPaciente+'%' OR @strPaciente = '0') 
			AND (R.intOrdenLaboratorioEnc = @intOrden OR @intOrden = 0) 
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

qryOrdenLaboratorioEnc_SelDetalle_PorUsuario
	 @strUsuario			='mr-joc'
	,@intEsVersion2024		= 1
	,@intDoctor				= 1
	,@intProtesis			= 1
	,@intProceso			= NULL
	,@intOrden				= 9
	,@strPaciente			= NULL
