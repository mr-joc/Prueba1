USE LabAllCeramic
go



/*
ALTER TABLE tbJobHead ADD isProcesadoEnd INT DEFAULT(1)
go
UPDATE tbJobHead SET isProcesadoEnd = 1
go
ALTER TABLE tbJobHead ADD isYesosEnd INT DEFAULT(0)
go
UPDATE tbJobHead SET isYesosEnd = 0
go
ALTER TABLE tbJobHead ADD isAutorizadoEnd INT DEFAULT(0)
go
UPDATE tbJobHead SET isAutorizadoEnd = 0
go
ALTER TABLE tbJobHead ADD isFabricadoEnd INT DEFAULT(0)
go
UPDATE tbJobHead SET isFabricadoEnd = 0
go
ALTER TABLE tbJobHead ADD isEnviadoEnd INT DEFAULT(0)
go
UPDATE tbJobHead SET isEnviadoEnd = 0
go
ALTER TABLE tbJobHead ADD isEntregadoEnd INT DEFAULT(0)
go
UPDATE tbJobHead SET isEntregadoEnd = 0
go
ALTER TABLE tbJobHead ADD isCerradoEnd INT DEFAULT(0)
go
UPDATE tbJobHead SET isCerradoEnd = 0
go

*/

--SELECT TOP 100 * FROM tbOrdenLaboratorioEnc	ORDER BY intOrdenLaboratorioEnc DESC
--SELECT TOP 100 * FROM tbOrdenLaboratorioDet ORDER BY intOrdenLaboratorioEnc DESC

/*

UPDATE tbMenu2024 SET Vista = 'YesoOperacion' WHERE intMenu = 6657
SELECT * FROM tbMenu2024 WHERE intMenu = 6657

SELECT TOP 1000 * FROM tbOrderJob WHERE OrderHead = 6616
SELECT TOP 1000 * FROM tbJobHead  WHERE OrderHead = 6616
SELECT TOP 1000 * FROM tbJobOper  WHERE JobNum IN ('6616-1-1','6616-1-2','6616-1-3','6616-1-4','6616-1-5','6616-1-6','6616-1-7','6616-1-8')
SELECT TOP 1000 * FROM tbJobMTL	  WHERE JobNum IN ('6616-1-1','6616-1-2','6616-1-3','6616-1-4','6616-1-5','6616-1-6','6616-1-7','6616-1-8')


--
*/


--UPDATE tbJobOper set intOperacion = 55, OpDesc ='Samblastear' where OpDesc IS NULL



/*


ALTER TABLE tbJobOper ADD intOperacion INT



delete FROM tbOrderJob 
delete FROM tbJobHead  
delete FROM tbJobOper  
delete FROM tbJobMTL	  



qry_V2_GenerarOrdeneTrabajo_APP @intOrdenLaboratorioEnc =6658, @strUsuario = 'MR-JOC'
go
qry_V2_GenerarOrdeneTrabajo_APP @intOrdenLaboratorioEnc =6616, @strUsuario = 'MR-JOC'
go
 


*/

--UPDATE tbOrdenLaboratorioEnc SET datFechaEntrega = '2024-05-06' WHERE intOrdenLaboratorioEnc =  6616






go
--sp_ConsultaJobPendientesYesos_Sel 'MR-JOC'
alter PROCEDURE sp_ConsultaJobPendientesYesos_Sel 
@Usuario VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
		 JH.OrderHead															AS [OrderNum]
		,1																		AS [OrderLine]
		,1																		AS [OrderRel]
		,JH.datFechaAlta														AS [OrderDate]	
		,CONVERT(VARCHAR(10), JH.OrderHead)										AS [JobNum]
		--select * from tbOrdenLaboratorioEnc
		,'Paciente: '+ISNULL(ENC.strNombrePaciente, '')
		+' // Doctor: '
		+DRR.strNombre+' '+DRR.strApPaterno+' '+DRR.strApMaterno
																				AS [JobPartNum]
		,P24.strNombreTipoProtesis									AS [JobPartDesc]
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
		,ENC.datFechaEntrega													AS [strFechaEntrega]
		,DATEDIFF(DD, GETDATE(), ENC.datFechaAlta)								AS [intAntiguedadDias]
	FROM tbJobHead					AS	JH WITH(NOLOCK)
		JOIN tbJobOper				AS	JO WITH(NOLOCK) ON JO.JobNum = JH.jobNum
		JOIN tbUsuariosXOperacion	AS	UO WITH(NOLOCK) ON UO.intOperacion = JO.intOperacion
		JOIN tbTipoTrabajo2024		AS	TT WITH(NOLOCK) ON TT.intTipoTrabajo = JH.intTipoTrabajo
		JOIN tbOrdenLaboratorioEnc	AS ENC WITH(NOLOCK) ON ENC.intOrdenLaboratorioEnc = JH.OrderHead
		JOIN tbDoctor2024			AS DRR WITH(NOLOCK) ON ENC.intDoctor = DRR.intDoctor
		JOIN tbTipoProtesis2024		AS P24 WITH(NOLOCK) ON ENC.intTipoProtesis = P24.intTipoProtesis
	WHERE UO.strUsuario = @Usuario
		AND JH.isYesosEnd = 0
	GROUP BY JH.OrderHead, ENC.strNombrePaciente,JH.datFechaAlta, ENC.datFechaEntrega, ENC.datFechaAlta, DRR.strNombre, DRR.strApPaterno, DRR.strApMaterno, P24.strNombreTipoProtesis	

END
go

sp_ConsultaJobPendientesYesos_Sel 'MR-JOC'
go

--

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
		SELECT JobNum = UPPER(SUBSTRING(JobNum, 1, (CHARINDEX('-',JobNum))-1)), 
			semana =DATEPART(WW, R.Fecha) ,Dia=DATEPART(DW, R.Fecha),Cantidad=1--,*
		INTO #tmpResumen
		FROM tbRegistroCambioEstatus AS R
		WHERE R.[Status] = 'YESOS' 
			AND R.Fin = 1 
			AND R.Fecha >= DATEADD(DD, -10, GETDATE()) 
			AND DATEPART(WW, R.Fecha) = DATEPART(WW, GETDATE()) 
			AND R.Usuario = @strUsuario
		GROUP BY UPPER(SUBSTRING(JobNum, 1, (CHARINDEX('-',JobNum))-1)), R.Fecha

		
		SELECT Cantidad = 1
		INTO #Pendientes
		FROM tbJobHead					AS	JH WITH(NOLOCK)
			JOIN tbJobOper				AS	JO WITH(NOLOCK) ON JO.JobNum = JH.jobNum
			JOIN tbUsuariosXOperacion	AS	UO WITH(NOLOCK) ON UO.intOperacion = JO.intOperacion
		WHERE UO.strUsuario = @strUsuario
			AND JH.isYesosEnd = 0
			AND JO.intOperacion = 1
		GROUP BY JH.OrderHead

		
		SET @TotalSemana = (SELECT SUM(Cantidad) FROM #tmpResumen)
		SET @DiasPromediar = (CASE DATEPART(DW,GETDATE()) WHEN 7 THEN 6 WHEN 6 THEN 5 WHEN 5 THEN 4  WHEN 4 THEN 3 WHEN 3 THEN 2 WHEN 2 THEN 1  END)


		INSERT #Resultado(strMesaActual, intAcumuladoSemanal, intPromedio, intAcumuladoHoy, intPendientes)
		SELECT strMesaActual=ISNULL('_', 'MESA X Usuario'),
			intAcumuladoSemanal = ISNULL(@TotalSemana, 0),
			intPromedio = ISNULL(ROUND((@TotalSemana/@DiasPromediar), 0), 0),
			intAcumuladoHoy = ISNULL((SELECT SUM(Cantidad) FROM #tmpResumen WHERE Dia=DATEPART(DW,GETDATE())), 0),
			intPendientes = ISNULL((SELECT SUM(Cantidad) FROM #Pendientes), 0)


	END

	SELECT 
		strMesaActual, intAcumuladoSemanal, intPromedio, intAcumuladoHoy, intPendientes
	FROM #Resultado

	 PRINT  '@datFecha='+CONVERT(VARCHAR(100), @datFecha, 121)+', @strUsuario='+@strUsuario--, '@LineaEnsambleID'=@LineaEnsambleID
END
go



spResumenTurnoXUsuario @datFecha = NULL, @strDepartamento = 'YESOS', @strUsuario = 'MR-JOC'
go




