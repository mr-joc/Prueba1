USE LabAllCeramic
go

 
 
go
alter PROCEDURE qry_V2_EstatusOrdenLaboratorioEnc
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










 








--qry_V2_OrdenLaboratorioEnc_SelHistorial @intOrdenLaboratorioEnc = 6727, @strUsuario = 'JORGE'
alter PROCEDURE qry_V2_OrdenLaboratorioEnc_SelHistorial
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




qry_V2_EstatusOrdenLaboratorioEnc @intEmpresa = 1,@intOrdenLaboratorioEnc  = 6731
go



qry_V2_OrdenLaboratorioEnc_SelHistorial @intOrdenLaboratorioEnc = 6731, @strUsuario = 'JORGE'
go



