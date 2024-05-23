USE LabAllCeramic
go



go
--qry_ReporteProductividadXHora_SEL  @Usuario='RLCEM', @FechaIni = '2023-07-19', @FechaFin = '2023-07-19', @TipoRegistro= 1, @TipoDato= 1
alter PROCEDURE qry_ReporteProductividadXHora_SEL---_PRUEBAS_JOVIEDO_23012024
@Usuario			NVARCHAR(50),			--Cuando se pide el detalle, este viene filtrado por Usuario
@FechaIni			DATETIME		= NULL,				--Fecha Inicial
@FechaFin			DATETIME		= NULL,				--Fecha Final
@TipoRegistro		INT				= NULL,				--Este sirve para saber si quieremos los Inicios o los Fines de las operaciones
@TipoDato			INT				= NULL,				--Este es para saber si quieren resumen o detalle
@UsuarioConsulta	NVARCHAR(150)	= NULL,	--Agregamos este parámetro para llevar un control del usuario que está realmente consultando los datos
@strLinea			NVARCHAR(150)	= NULL
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Inicio INT = 0, @Fin INT = 0
	
	SELECT @TipoRegistro = ISNULL(@TipoRegistro, 1)
	SELECT @TipoDato = ISNULL(@TipoDato, 1)

	SET @strLinea = ISNULL(@strLinea, '0')

	IF @strLinea = ''
	BEGIN
		SET @strLinea = '0'
		PRINT 'Colo la línea viene vacía (esto porque no se ha agregado en las pantallas de cada usuario) la actualizamos a 0 '
	END

	IF @FechaIni = '01/01/1900' AND @FechaFin = '01/01/1900'
	BEGIN
		PRINT 'como vienen vacías cambiamos las fechas al día de hoy.'
		SET @FechaIni = GETDATE()
		SET @FechaFin = GETDATE()
	END
	
	SET @FechaIni = ISNULL(@FechaIni, GETDATE())
	SET @FechaFin = ISNULL(@FechaIni, GETDATE())
	
	IF @TipoRegistro = 1
	BEGIN
		SET @Fin = 1
	END

	IF @TipoRegistro = 2
	BEGIN
		SET @Inicio = 1
	END
	
	IF @TipoDato = 1 AND @Usuario = ''
	BEGIN
		SET @Usuario = '0'
	END
	
	IF @TipoDato = 3 AND @Usuario = ''
	BEGIN
		SET @Usuario = '0'
	END

	--CREATE TABLE #Estatuss(intEstatus INT, Nombre NVARCHAR(50))

	--INSERT #Estatuss(intEstatus, Nombre)
	--VALUES (1, 'PERFIL'), (2, 'TELA'), (3, 'ENSAMBLE'), (4, UPPER('Empaque'))

	
	/*
	INSERT tbConsultaReportes_Pantallas(strUsuario, strReporte, strQRY, strParametros, datFechaConsulta)
	SELECT strUsuario = ISNULL(@UsuarioConsulta, 'NULO ?'), strReporte = 'Reportes/ProductividadXHora', strQRY = 'qry_ReporteProductividadXHora_SEL', strParametros = '@Usuario = '+''''+@Usuario+''''+', @FechaIni = '
		+''''+CONVERT(VARCHAR(10), @FechaIni, 103)+''''+', @FechaFin = '+''''+CONVERT(VARCHAR(10), @FechaFin, 103)+''''+', @TipoRegistro = '+CONVERT(VARCHAR(10), @TipoRegistro)+', @TipoDato = '+CONVERT(VARCHAR(10), @TipoDato)
		+', @strLinea = '+''''+@strLinea+''''
		, datFechaConsulta =GETDATE()
		
	SELECT JobNum, PasoLineaID = 0, EstatusCorto = UPPER(REPLACE((REPLACE([Status], 'M-TELA', 'TELA')), 'C-Tela', 'TELA')), Inicio, Fin, CodigoEstacion, Estacion = '00000000010000000002000000000300000000040000000005', Usuario, Fecha
	INTO #tmpRegistros01
	FROM tbRegistroCambioEstatus				AS REGC WITH(NOLOCK)
		LEFT JOIN tbProgramacionPerfilesDtl		AS PDTL WITH(NOLOCK) ON PDTL.strJOB = REGC.JobNum
		LEFT JOIN tbProgramacionDtl				AS  DTL WITH(NOLOCK) ON DTL.strJOB = REGC.JobNum
		JOIN tbLineasHead						AS    L WITH(NOLOCK) ON ISNULL(PDTL.intLinea, DTL.intLinea) = L.intLineaEnc
	WHERE CONVERT(DATETIME, (CONVERT(VARCHAR(10), Fecha, 103)), 103) BETWEEN CONVERT(DATETIME, (CONVERT(VARCHAR(10), @FechaIni, 103)), 103)  AND CONVERT(DATETIME, (CONVERT(VARCHAR(10), @FechaFin, 103)), 103)
		AND REGC.Inicio = @Inicio
		AND REGC.Fin = @Fin
		AND (L.strProducto = @strLinea OR @strLinea = '0')


	
	DELETE FROM #tmpRegistros01 WHERE EstatusCorto = 'Armado'
	
	UPDATE REG001
	SET REG001.Estacion = PASOS.Nombre+' ('+REPLACE(EST.Nombre, 'NUEVA ESTACION', 'SHEER NACIONAL 2')+')', REG001.PasoLineaID = EST.PasoXLineaID 
	--SELECT REG001.Estacion, PASOS.Nombre, EST.Nombre 
	FROM #tmpRegistros01				AS REG001
		JOIN tbEstacionesXLineaPersiana AS    EST WITH (NOLOCK) ON REG001.CodigoEstacion = EST.Codigo
		JOIN tbPasosXLineaPersiana		AS  PASOS WITH (NOLOCK) ON PASOS.PasoXLineaID = EST.PasoXLineaID 
		
		
	UPDATE REG002
	SET REG002.Estacion = TELAS.Nombre
	FROM #tmpRegistros01		AS REG002 WITH (NOLOCK) 
		JOIN TbMesaTelaXLinea	AS  TELAS WITH (NOLOCK) ON REG002.CodigoEstacion = TELAS.Codigo

		
	UPDATE REG003
	SET REG003.Estacion = PERFILES.Nombre
	FROM #tmpRegistros01		AS   REG003 WITH (NOLOCK) 
		JOIN TbMesaperfilXLinea	AS PERFILES WITH (NOLOCK) ON REG003.CodigoEstacion = PERFILES.Codigo

	UPDATE #tmpRegistros01 SET Estacion = 'No Aplica' WHERE Estacion = '00000000010000000002000000000300000000040000000005'

	SELECT 
		 TMP1.JobNum 
		,EstatusCorto = REPLACE((REPLACE(TMP1.EstatusCorto, 'Armado@40', 'ENSAMBLE')), 'Armado@10', 'ENSAMBLE')
		,EstatusNoTanCorto = REPLACE((REPLACE(TMP1.EstatusCorto, 'Armado@40', 'ALTURAS')), 'Armado@10', 'EMBOBINADO')
		,TMP1.PasoLineaID
		,TMP1.Inicio 
		,TMP1.Fin 
		,TMP1.CodigoEstacion 
		,TMP1.Estacion
		,ClaveUsr = TMP1.Usuario
		,NomUsuario = USRS.Nombre
		,Usuario = USRS.Nombre+' ('+TMP1.Usuario+')'
		,TMP1.Fecha
		,Hora = DATEPART(HH, TMP1.Fecha)
		,CantidadIni = 1
		,CantidadJobs = 1
	INTO #tmpRegistros02
	FROM #tmpRegistros01			AS TMP1 WITH (NOLOCK)
		JOIN ERPWeb.dbo.TbUsuario	AS USRS WITH (NOLOCK) ON USRS.DcdUserID = TMP1.Usuario
	WHERE (TMP1.Usuario = @Usuario OR  @Usuario = '0')

	UPDATE PREV
	SET PREV.CantidadIni = BORDE.NoLienzo
	--SELECT '#tmpRegistros02', PREV.*, BORDE.NoLienzo, BORDE.* 
	FROM #tmpRegistros02  AS PREV WITH (NOLOCK)
		JOIN tbBackOrder AS BORDE WITH(NOLOCK) ON BORDE.JobNum = REPLACE (PREV.JobNum, 'Y', '-')
	WHERE BORDE.NoLienzo > 1

	--SELECT '#tmpRegistros02_ACTUALIZADA', * FROM  #tmpRegistros02 


	SELECT  RES.intEstatus, TMP03.EstatusCorto, TMP03.PasoLineaID, TMP03.Estacion, TMP03.ClaveUsr, TMP03.Usuario, TMP03.Hora, Cantidad = SUM(TMP03.CantidadIni), CantidadJobs = SUM(TMP03.CantidadJobs)
	INTO #tmpConteo
	FROM #tmpRegistros02	AS TMP03 WITH(NOLOCK) 
		JOIN #Estatuss		AS   RES WITH(NOLOCK) ON RES.Nombre = TMP03.EstatusCorto
	GROUP BY RES.intEstatus, TMP03.EstatusCorto, TMP03.PasoLineaID, TMP03.Estacion, TMP03.ClaveUsr, TMP03.Usuario, TMP03.Hora
	--ORDER BY RES.intEstatus

	 --select * from #tmpConteo
	*/


	IF @TipoDato = 1
	BEGIN
		SELECT 
			Indice = 1--(ROW_NUMBER() OVER( ORDER BY TMP04.intEstatus)),  
		--	 TMP04.EstatusCorto, TMP04.PasoLineaID, TMP04.Estacion, TMP04.ClaveUsr, TMP04.Usuario
		--	,int00 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  0), 0)
		--	,int01 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  1), 0)
		--	,int02 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  2), 0)
		--	,int03 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  3), 0)
		--	,int04 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  4), 0)
		--	,int05 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  5), 0)
		--	,int06 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  6), 0)
		--	,intInicioDia = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora IN (6, 5, 4, 3, 2, 1)), 0)
		--	,int07 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  7), 0)
		--	,int08 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  8), 0)
		--	,int09 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora =  9), 0)
		--	,int10 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 10), 0)
		--	,int11 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 11), 0)
		--	,int12 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 12), 0)
		--	,int13 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 13), 0)
		--	,int14 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 14), 0)
		--	,int15 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 15), 0)
		--	,int16 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 16), 0)
		--	,int17 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 17), 0)
		--	,intFinDia = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora IN (18, 19, 20, 21, 22, 23, 24)), 0)
		--	,int18 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 18), 0)
		--	,int19 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 19), 0)
		--	,int20 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END))
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 20), 0)
		--	,int21 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 21), 0)
		--	,int22 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 22), 0)
		--	,int23 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 23), 0)
		--	,int24 = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario AND CNT.Hora = 24), 0)
		--	,Total = ISNULL((SELECT SUM((CASE WHEN CNT.EstatusCorto = 'EMPAQUE' THEN CNT.CantidadJobs ELSE CNT.CANTIDAD END)) 
		--					FROM #tmpConteo AS CNT WHERE CNT.EstatusCorto = TMP04.EstatusCorto AND CNT.Estacion = TMP04.Estacion AND CNT.Usuario = TMP04.Usuario      ), 0)
		----INTO #tmpResumen
		--FROM #tmpConteo	AS TMP04 WITH(NOLOCK) 
		--GROUP BY TMP04.intEstatus, TMP04.PasoLineaID, TMP04.EstatusCorto, TMP04.Estacion, TMP04.ClaveUsr, TMP04.Usuario
		--ORDER BY TMP04.intEstatus
	END

	IF @TipoDato = 2
	BEGIN
		--SELECT Indice = (ROW_NUMBER() OVER( ORDER BY JobNum, Fecha)),  
		--	TMP02.JobNum, TMP02.EstatusCorto, TMP02.Inicio, TMP02.Fin, TMP02.CodigoEstacion, TMP02.Estacion, TMP02.ClaveUsr, TMP02.NomUsuario, TMP02.Usuario, TMP02.Fecha
		--	, Fecha_Hora = CONVERT(VARCHAR(10), TMP02.Fecha, 103)+' A las: '+CONVERT(VARCHAR(8), TMP02.Fecha, 108)
		--	, TMP02.Hora
		--	, TMP02.CantidadIni
		--FROM #tmpRegistros02 AS TMP02
		--ORDER BY JobNum, Fecha
		SELECT Indice = 1,  JobNum='102030-1'
		--	, EstatusCorto, TMP02.Inicio, TMP02.Fin, TMP02.CodigoEstacion, TMP02.Estacion, TMP02.ClaveUsr, TMP02.NomUsuario, TMP02.Usuario, TMP02.Fecha
		--	, Fecha_Hora = CONVERT(VARCHAR(10), TMP02.Fecha, 103)+' A las: '+CONVERT(VARCHAR(8), TMP02.Fecha, 108)
		--	, TMP02.Hora
		--	, TMP02.CantidadIni
		--FROM #tmpRegistros02 AS TMP02
		--ORDER BY JobNum, Fecha
	END

	IF @TipoDato = 3
	BEGIN

	SELECT   intLinea =  1, Linea = '07:00', Perfiles =  2, Telas = 11, Embobinado = 14, Alturas = 23, Empaque = 5
	UNION SELECT intLinea =  2, Linea = '08:00', Perfiles =  8, Telas = 0, Embobinado = 12, Alturas = 34, Empaque = 11
	UNION SELECT intLinea =  3, Linea = '09:00', Perfiles = 10, Telas = 12, Embobinado = 0, Alturas = 0, Empaque = 3
	UNION SELECT intLinea =  4, Linea = '10:00', Perfiles = 14, Telas = 6, Embobinado = 12, Alturas = 67, Empaque = 8
	UNION SELECT intLinea =  5, Linea = '11:00', Perfiles = 17, Telas = 20, Embobinado = 34, Alturas = 0, Empaque = 12
	UNION SELECT intLinea =  6, Linea = '12:00', Perfiles = 10, Telas = 9, Embobinado = 14, Alturas = 58, Empaque = 3
	UNION SELECT intLinea =  7, Linea = '13:00', Perfiles = 1, Telas =  0, Embobinado = 23, Alturas = 0, Empaque = 11
	UNION SELECT intLinea =  8, Linea = '14:00', Perfiles = 50, Telas = 7, Embobinado = 65, Alturas = 42, Empaque = 9
	UNION SELECT intLinea =  9, Linea = '16:00', Perfiles = 30, Telas = 1, Embobinado = 4, Alturas = 4, Empaque = 7
	UNION SELECT intLinea = 10, Linea = '17:00', Perfiles = 20, Telas = 46, Embobinado = 46, Alturas = 0, Empaque = 6

		/*
		SELECT EstatusNoTanCorto, Hora, CantidadIni=SUM(CantidadIni), CantidadJobs=SUM(CantidadJobs)
		INTO #ResumenGrafica
		FROM   #tmpRegistros02
		GROUP BY EstatusNoTanCorto, Hora

		SELECT EstatusNoTanCorto, Hora, Horario = CONVERT(VARCHAR(5), (DATEADD(HH, Hora, '1982-11-26')), 108), CantidadIni, CantidadJobs
		INTO #tmpFinGrafica
		FROM #ResumenGrafica

		SELECT  intLinea = (ROW_NUMBER() OVER( ORDER BY GRAFICA.Hora))
			,Linea = GRAFICA.Horario
			,Perfiles	= ISNULL((SELECT SUM((CASE WHEN CANT01.EstatusNoTanCorto = 'EMPAQUE' THEN CANT01.CantidadJobs ELSE CANT01.CantidadIni END)) FROM #tmpFinGrafica AS CANT01 WHERE CANT01.EstatusNoTanCorto = 'PERFIL'	AND CANT01.Horario =GRAFICA.Horario), 0)
			,Telas		= ISNULL((SELECT SUM((CASE WHEN CANT01.EstatusNoTanCorto = 'EMPAQUE' THEN CANT01.CantidadJobs ELSE CANT01.CantidadIni END)) FROM #tmpFinGrafica AS CANT01 WHERE CANT01.EstatusNoTanCorto = 'TELA'		AND CANT01.Horario =GRAFICA.Horario), 0)
			,Embobinado	= ISNULL((SELECT SUM((CASE WHEN CANT01.EstatusNoTanCorto = 'EMPAQUE' THEN CANT01.CantidadJobs ELSE CANT01.CantidadIni END)) FROM #tmpFinGrafica AS CANT01 WHERE CANT01.EstatusNoTanCorto = 'EMBOBINADO'	AND CANT01.Horario =GRAFICA.Horario), 0)




			,Alturas	= ISNULL((SELECT SUM((CASE WHEN CANT01.EstatusNoTanCorto = 'EMPAQUE' THEN CANT01.CantidadJobs ELSE CANT01.CantidadIni END)) FROM #tmpFinGrafica AS CANT01 WHERE CANT01.EstatusNoTanCorto = 'ALTURAS'	AND CANT01.Horario =GRAFICA.Horario), 0)
			,Empaque	= ISNULL((SELECT SUM((CASE WHEN CANT01.EstatusNoTanCorto = 'EMPAQUE' THEN CANT01.CantidadJobs ELSE CANT01.CantidadIni END)) FROM #tmpFinGrafica AS CANT01 WHERE CANT01.EstatusNoTanCorto = 'EMPAQUE'	AND CANT01.Horario =GRAFICA.Horario), 0)
		------INTO #tmppGraficaFinal01
		FROM #tmpFinGrafica		AS GRAFICA WITH(NOLOCK)
		GROUP BY GRAFICA.Hora, GRAFICA.Horario
		ORDER BY GRAFICA.Hora
		 
		 */

	END

END
go


qry_ReporteProductividadXHora_SEL  @Usuario='RLCEM', @FechaIni = '2023-07-19', @FechaFin = '2023-07-19', @TipoRegistro= 1, @TipoDato= 3
