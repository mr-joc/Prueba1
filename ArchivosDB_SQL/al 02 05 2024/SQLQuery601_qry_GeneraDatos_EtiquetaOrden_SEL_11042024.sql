USE LabAllCeramic
go

/*
select * FROM tbOrderJob
go
select * FROM tbJobHead
go



qry_V2_GenerarOrdeneTrabajo_APP




select * FROM tbOperacion
go
select * FROM tbOperacionXTipoTrabajo
go

SELECT * FROM tbOrdenLaboratorioEnc WHERE  intOrdenLaboratorioEnc = 6747
SELECT * FROM tbOrdenLaboratorioDet WHERE  intOrdenLaboratorioEnc = 6747

*/

----ALTER TABLE tbOrdenLaboratorioEnc ADD isPendienteImpresion BIT DEFAULT(0)

--UPDATE tbOrdenLaboratorioEnc SET isPendienteImpresion = 0
--UPDATE tbOrdenLaboratorioEnc SET isPendienteImpresion = 1 WHERE  intOrdenLaboratorioEnc = 6747



	UPDATE tbOrdenLaboratorioEnc 
	SET isPendienteImpresion = 1
	WHERE intOrdenLaboratorioEnc = 6747
go



go
alter PROCEDURE qry_GeneraDatos_EtiquetaOrden_SEL
@intOrdenLaboratorioEnc INT = NULL
AS
BEGIN
	SELECT 
		ENC.intOrdenLaboratorioEnc, ENC.intDoctor, ENC.strNombrePaciente, 
		strDoctor = DR.strNombre+' '+DR.strApPaterno+' '+DR.strApMaterno
	INTO #Enca
	FROM tbOrdenLaboratorioEnc			AS ENC WITH(NOLOCK)
		JOIN tbDoctor2024				AS  DR WITH(NOLOCK) ON DR.intDoctor = ENC.intDoctor
	WHERE ENC.isPendienteImpresion = 1 

	
	SELECT ENC1.intOrdenLaboratorioEnc, ENC1.intDoctor, ENC1.strNombrePaciente,  ENC1.strDoctor, intMaterial = 0, intTipoTrabajo = 0, intCantidad = 0, strTrabajo = ''
		,Codigo = CONVERT(VARCHAR(10), 102030)+'-'+CONVERT(VARCHAR(10), 1)
	FROM #Enca AS ENC1
	--ORDER BY DET.intMaterial
	UNION
	SELECT 
		ENC.intOrdenLaboratorioEnc, ENC.intDoctor, strNombrePaciente = '', 
		strDoctor = '',
		DET.intMaterial, DET.intTipoTrabajo, DET.intCantidad
		,strTrabajo = CONVERT(VARCHAR(4), DET.intCantidad)+' '+TRA.strNombre+' // '+MAT.strNombre
		,Codigo = CONVERT(VARCHAR(10), ENC.intOrdenLaboratorioEnc)+'-'+CONVERT(VARCHAR(10), ENC.intDoctor)
	FROM #Enca							AS ENC WITH(NOLOCK)
		JOIN tbDoctor2024				AS  DR WITH(NOLOCK) ON DR.intDoctor = ENC.intDoctor
		JOIN tbOrdenLaboratorioDet		AS DET WITH(NOLOCK) ON DET.intOrdenLaboratorioEnc = ENC.intOrdenLaboratorioEnc
		JOIN tbMaterial2024				AS MAT WITH(NOLOCK) ON DET.intMaterial = MAT.intMaterial
		JOIN tbTipoTrabajo2024			AS TRA WITH(NOLOCK) ON DET.intTipoTrabajo = TRA.intTipoTrabajo
	ORDER BY intMaterial


	UPDATE tbOrdenLaboratorioEnc 
	SET isPendienteImpresion = 0
	WHERE isPendienteImpresion = 1  

END
go



qry_GeneraDatos_EtiquetaOrden_SEL  
go


