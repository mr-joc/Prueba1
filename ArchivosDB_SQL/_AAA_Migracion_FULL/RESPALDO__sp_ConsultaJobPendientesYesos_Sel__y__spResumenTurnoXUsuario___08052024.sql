USE LabAllCeramic
go



go
--sp_ConsultaJobPendientesYesos_Sel 'MR-JOC'
alter PROCEDURE sp_ConsultaJobPendientesYesos_Sel 
@Usuario VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
		 JH.OrderHead								As [OrderNum]
		,JH.OrderDtl								As [OrderLine]
		,1											As [OrderRel]
		,JH.datFechaAlta							As [OrderDate]	
		,CONVERT(VARCHAR(10), JH.OrderHead)
		+'-'+CONVERT(VARCHAR(10), JH.OrderDtl)		As [JobNum]
		,ISNULL(TT.strNombreCorto, '')				AS [JobPartNum]
		,REPLACE(JH.PartDesc, '~', '//')			AS [JobPartDesc]
		,(CASE 
			WHEN ENC.datFechaEntrega <= GETDATE()					THEN 0
			WHEN DATEDIFF(DD, GETDATE(), ENC.datFechaEntrega)>=10	THEN 1
			WHEN DATEDIFF(DD, GETDATE(), ENC.datFechaEntrega)<10	
				AND DATEDIFF(DD, GETDATE(), ENC.datFechaEntrega)>= 4	
																	THEN 2
			WHEN DATEDIFF(DD, GETDATE(), ENC.datFechaEntrega)<4	
				AND DATEDIFF(DD, GETDATE(), ENC.datFechaEntrega)>= 1	
																	THEN 3
		END)
													AS [Status_Entrega]
		,ENC.datFechaEntrega						AS [strFechaEntrega]
		,(JH.OrderDtl%4)+1							AS [intAntiguedadDias]
	FROM tbJobHead					AS	JH WITH(NOLOCK)
		JOIN tbJobOper				AS	JO WITH(NOLOCK) ON JO.JobNum = JH.jobNum
		JOIN tbUsuariosXOperacion	AS	UO WITH(NOLOCK) ON UO.intOperacion = JO.intOperacion
		JOIN tbTipoTrabajo2024		AS	TT WITH(NOLOCK) ON TT.intTipoTrabajo = JH.intTipoTrabajo
		JOIN tbOrdenLaboratorioEnc	AS ENC WITH(NOLOCK) ON ENC.intOrdenLaboratorioEnc = JH.OrderHead
	WHERE UO.strUsuario = @Usuario
		AND JH.isYesosEnd = 0
	GROUP BY JH.OrderHead, JH.OrderDtl, JH.datFechaAlta, TT.strNombreCorto, JH.PartDesc, ENC.datFechaEntrega

END
go

sp_ConsultaJobPendientesYesos_Sel 'MR-JOC'
go



go
--spResumenTurnoXUsuario @datFecha = NULL, @strUsuario = 'MR-JOC', @strDepartamento = 'YESOS'
alter PROCEDURE spResumenTurnoXUsuario
@datFecha			DATE = NULL,
@strDepartamento	NVARCHAR(50),
@strUsuario			NVARCHAR(50)

AS
BEGIN
	DECLARE @TotalSemana NUMERIC(18, 2), @DiasPromediar NUMERIC(18, 2)--, @MesaActual VARCHAR(50)

	SET @datFecha=(SELECT CASE WHEN @datFecha='0001-01-01' THEN GETDATE() ELSE ISNULL(@datFecha, GETDATE()) END)

	CREATE TABLE #Resultado(
		strMesaActual			NVARCHAR(250)
		,intAcumuladoSemanal	INT
		,intPromedio			INT
		,intAcumuladoHoy		INT
		,intPendientes			INT
	)

	IF @strDepartamento = 'YESOS'
	BEGIN
		SELECT JobNum, semana =DATEPART(WW, R.Fecha) ,Dia=DATEPART(DW, R.Fecha),Cantidad=1--,*
		INTO #tmpResumen
		FROM tbRegistroCambioEstatus AS R
		WHERE R.[Status] = 'YESOS' 
			AND R.Fin = 1 
			AND R.Fecha >= DATEADD(DD, -10, GETDATE()) 
			AND DATEPART(WW, R.Fecha) = DATEPART(WW, GETDATE()) 
			AND R.Usuario = @strUsuario
		
		SET @TotalSemana = (SELECT SUM(Cantidad) FROM #tmpResumen)
		SET @DiasPromediar = (CASE DATEPART(DW,GETDATE()) WHEN 7 THEN 6 WHEN 6 THEN 5 WHEN 5 THEN 4  WHEN 4 THEN 3 WHEN 3 THEN 2 WHEN 2 THEN 1  END)


		INSERT #Resultado(strMesaActual, intAcumuladoSemanal, intPromedio, intAcumuladoHoy, intPendientes)
		SELECT strMesaActual=ISNULL('_', 'MESA X Usuario'),
			intAcumuladoSemanal = ISNULL(@TotalSemana, 0),
			intPromedio = ISNULL(ROUND((@TotalSemana/@DiasPromediar), 0), 0),
			intAcumuladoHoy = ISNULL((SELECT SUM(Cantidad) FROM #tmpResumen WHERE Dia=DATEPART(DW,GETDATE())), 0),
			intPendientes = (SELECT COUNT(*)
							FROM tbJobHead					AS	JH WITH(NOLOCK)
								JOIN tbJobOper				AS	JO WITH(NOLOCK) ON JO.JobNum = JH.jobNum
								JOIN tbUsuariosXOperacion	AS	UO WITH(NOLOCK) ON UO.intOperacion = JO.intOperacion
							WHERE UO.strUsuario = @strUsuario
								AND JH.isYesosEnd = 0
								AND JO.intOperacion = 1)
	END

	SELECT 
		strMesaActual, intAcumuladoSemanal, intPromedio, intAcumuladoHoy, intPendientes
	FROM #Resultado

	 PRINT  '@datFecha='+CONVERT(VARCHAR(100), @datFecha, 121)+', @strUsuario='+@strUsuario--, '@LineaEnsambleID'=@LineaEnsambleID
END
go



spResumenTurnoXUsuario @datFecha = NULL, @strDepartamento = 'YESOS', @strUsuario = 'MR-JOC'
go




