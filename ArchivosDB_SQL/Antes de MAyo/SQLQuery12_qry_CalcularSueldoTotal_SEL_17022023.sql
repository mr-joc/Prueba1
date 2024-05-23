USE AllCeramic2024
go

go
-- spRespaldar_Renombrar 'spPruebasParaCambios', 'MR-JOC'
CREATE PROCEDURE spRespaldar_Renombrar
@spName VARCHAR(150),
@Usuario VARCHAR(25) = NULL
AS
BEGIN

	SET NOCOUNT ON
	
	
	SET @Usuario = ISNULL(@Usuario, 'mrJOC')

	DECLARE @spRespName VARCHAR(200)
	SET @spRespName=''+@spName+'___'+@Usuario+'_'+CONVERT(VARCHAR(4), DATEPART(DD, GETDATE()))+CONVERT(VARCHAR(4), DATEPART(MM, GETDATE()))+CONVERT(VARCHAR(4), DATEPART(YY, GETDATE()))
	PRINT 'Declaramos y asignamos el nombre del SP que queda de respaldo @spRespName = '+@spRespName

	--1
	PRINT 'Localizamos el SP real, mínimo tiene que existir, si no nos vamos al final'
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@spName) AND TYPE IN (N'P', N'PC', N'TF', N'FN'))
	BEGIN
		PRINT 'Si Existe, entramos a revisar si existe un respaldo'
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@spRespName) AND TYPE IN (N'P', N'PC', N'TF', N'FN'))
		BEGIN
			PRINT 'Como existe el SP real y también existe un respaldo, vamos a borrar el anterior.'
			DECLARE @InstruccionDropRespaldo NVARCHAR(300)
			SET @InstruccionDropRespaldo = 'DROP PROCEDURE '+@spRespName+''
			
			PRINT 'Esta sería la instrucción que Borra: '+@InstruccionDropRespaldo

			EXECUTE sp_executeSQL @InstruccionDropRespaldo
			PRINT 'YA BORRAMOS: '+@spRespName
		END
		
		PRINT 'Exista o no el SP de Respaldo, ahora solo toca renombrar'
		EXEC sp_rename @spName, @spRespName
		PRINT 'Renombramos "'+@spName+'" con el nombre "'+@spRespName+'"'

		SELECT Resultado = 'Se Renombró el SP "'+@spName+'"'
	END
	ELSE
	BEGIN
		PRINT 'No existe el SP, no se hace nada'
		SELECT Resultado = 'No existe el SP, no se modificó'
	END

END
go



go
CREATE PROCEDURE qry_CalcularSueldoTotal_SEL
@intMes			INT,
@intEmpleado	INT = NULL
AS
BEGIN
	DECLARE @intHorasLaboradasXDia		INT = 8
	DECLARE @dblMontoXEntrega			DECIMAL(10, 4) = 5
	DECLARE @dblISR						DECIMAL(10, 4) = 9
	DECLARE @dblISRAdicional			DECIMAL(10, 4) = 3
	DECLARE @dblSueldoSinISRAdicional	DECIMAL(10, 4) = 10000
	DECLARE @dblFactorVales				DECIMAL(10, 4) = 1.04




	--EN CASO DE NO DEFINIR EL EMPLEADO, ASIGNAREMOS UN 0 PARA TRAER TODOS
	SELECT @intEmpleado = ISNULL(@intEmpleado, 0) 

	SELECT 
		 JOR.intEmpleadoID
		,JOR.intMes
		,intDiasLaborados = SUM(JOR.intDiasLaborados) 
		,JOR.IsBorrado
		,intHorasLaboradas = (SUM(JOR.intDiasLaborados)) * @intHorasLaboradasXDia
	INTO #tmpDiasLaborados
	FROM tbJornadasLaborales AS JOR WITH(NOLOCK)
	WHERE JOR.intMes = @intMes
		AND ISNULL(JOR.IsBorrado, 0) = 0
	GROUP BY JOR.intEmpleadoID, JOR.intMes, JOR.IsBorrado

	SELECT 
		 MOV.intEmpleadoID
		,MOV.intMes
		,intCantidadEntregas = SUM(MOV.intCantidadEntregas)
	INTO #tmpEntregas
	FROM tbMovimientos AS MOV
	WHERE MOV.intMes = @intMes
		AND ISNULL(MOV.IsBorrado, 0) = 0
	GROUP BY MOV.intEmpleadoID, MOV.intMes
	
	--UPDATE tbMovimientos SET intEmpleadoID = 2 WHERE intnumempleado = 2018
	--UPDATE tbMovimientos SET intEmpleadoID = 3 WHERE intnumempleado = 2020
	--UPDATE tbMovimientos SET intEmpleadoID = 4 WHERE intnumempleado = 2023

	SELECT
		 intEmpleadoID = EMP.intEmpleadoID												 
		,strNombreCompleto = EMP.strNombres+' '+EMP.strApPaterno+' '+EMP.strApMaterno		 
		,intNumEmpleado = EMP.intNumEmpleado												 
		,intRol = EMP.intRol														 
		,strRol = ROL.strNombre													 
		,dblSueldoBase = SB.dblSueldoBase												 
		,intDiasLaborados = DL.intDiasLaborados											 
		,intHorasLaboradas = DL.intHorasLaboradas	
		,dblSueldoXHras = (SB.dblSueldoBase * DL.intHorasLaboradas)
		,intCantidadEntregas = IIF(ROl. isAdministrativo = 0, ENT.intCantidadEntregas, 0)		 
		,dblMontoXEntrega = @dblMontoXEntrega		
		,dblSueldoXEntregas = ((IIF(ROl. isAdministrativo = 0, ENT.intCantidadEntregas, 0)) * @dblMontoXEntrega)
		,dblBonoXRol = BR.dblBonoXRol	
		,dblBonoXHoras = (DL.intHorasLaboradas * BR.dblBonoXRol)
		,dblISR = (100 - @dblISR)/100
		,dblISRAdicional = (100 - @dblISRAdicional)/100
	INTO #tmpCalculoBase
	FROM tbEmpleados			AS EMP WITH(NOLOCK)
		JOIN tbRoles			AS ROL WITH(NOLOCK) ON ROl.intRol = EMP.intRol
		JOIN tbSueldoBase		AS  SB WITH(NOLOCK) ON  SB.intEmpleadoID = EMP.intEmpleadoID
		JOIN #tmpDiasLaborados	AS  DL				ON  DL.intEmpleadoID = EMP.intEmpleadoID
		JOIN #tmpEntregas		AS ENT				ON ENT.intEmpleadoID = EMP.intEmpleadoID 
		JOIN tbBonoXRol			AS  BR WITH(NOLOCK) ON BR.intRol = ROL.intRol 

	SELECT 
		 BAS.intEmpleadoID 
		,BAS.strNombreCompleto
		,BAS.intNumEmpleado
		,BAS.intRol
		,BAS.strRol
		,BAS.dblSueldoBase
		,BAS.intDiasLaborados
		,BAS.intHorasLaboradas
		,BAS.dblSueldoXHras
		,BAS.intCantidadEntregas
		,BAS.dblMontoXEntrega
		,BAS.dblSueldoXEntregas
		,BAS.dblBonoXRol
		,BAS.dblBonoXHoras
		,BAS.dblISR
		,BAS.dblISRAdicional
		,dblSueldoIntegrado = (BAS.dblSueldoXHras + BAS.dblSueldoXEntregas + BAS.dblBonoXHoras)
		,dblSueldoMenosISR = ((BAS.dblSueldoXHras + BAS.dblSueldoXEntregas + BAS.dblBonoXHoras) * BAS.dblISR)
		--,dblSueldoMenosISRAdicional = (CASE 
		--								WHEN ((BAS.dblSueldoXHras + BAS.dblSueldoXEntregas + BAS.dblBonoXHoras) * BAS.dblISR) > @dblSueldoSinISRAdicional THEN (((BAS.dblSueldoXHras + BAS.dblSueldoXEntregas + BAS.dblBonoXHoras) * BAS.dblISR) * BAS.dblISRAdicional)
		--								ELSE ((BAS.dblSueldoXHras + BAS.dblSueldoXEntregas + BAS.dblBonoXHoras) * BAS.dblISR)
		--								END)
	INTO #tmpCalculoFinal
	FROM #tmpCalculoBase AS BAS

	SELECT
		 F.intEmpleadoID
		,F.strNombreCompleto
		,F.intNumEmpleado
		,F.intRol
		,F.strRol
		,F.dblSueldoBase
		,F.intDiasLaborados
		,F.intHorasLaboradas
		,F.dblSueldoXHras
		,F.intCantidadEntregas
		,F.dblMontoXEntrega
		,F.dblSueldoXEntregas
		,F.dblBonoXRol
		,F.dblBonoXHoras
		,F.dblISR
		,F.dblISRAdicional
		,F.dblSueldoIntegrado
		,F.dblSueldoMenosISR
		,dblSueldoMenosISRAdicional = (CASE 
										WHEN F.dblSueldoMenosISR > @dblSueldoSinISRAdicional THEN (F.dblSueldoMenosISR * F.dblISRAdicional)
										ELSE F.dblSueldoMenosISR
										END)
		,dblVales = ((CASE 
										WHEN F.dblSueldoMenosISR > @dblSueldoSinISRAdicional THEN (F.dblSueldoMenosISR * F.dblISRAdicional)
										ELSE F.dblSueldoMenosISR
										END) * (@dblFactorVales - 1))
		,dblTotal = ((CASE 
										WHEN F.dblSueldoMenosISR > @dblSueldoSinISRAdicional THEN (F.dblSueldoMenosISR * F.dblISRAdicional)
										ELSE F.dblSueldoMenosISR
										END) * @dblFactorVales)

	FROM #tmpCalculoFinal AS F
END
go

qry_CalcularSueldoTotal_SEL 1, 0
go

