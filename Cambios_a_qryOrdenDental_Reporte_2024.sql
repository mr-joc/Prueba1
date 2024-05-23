use laballceramic
go


--select * from tbColorimetro2024 where intcolorimetro=3
--select * from tbColor2024 where intcolor=3


go
--qryOrdenDental_Reporte 1, 1, 10
alter PROCEDURE dbo.qryOrdenDental_Reporte
@intEmpresa INT,     
@intSucursal INT,     
@intOrdenEnc INT    
AS

BEGIN

	SELECT Folio=E.intOrdenLaboratorioEnc,
		E.intDoctor, 
		strDoctor=(SELECT DR.strNombre+' '+DR.strApPaterno+' '+DR.strApMaterno FROM tbDoctor2024 DR WHERE DR.intDoctor=E.intDoctor AND E.intEmpresa = 1 AND E.intSucursal = 1),
		E.strNombrePaciente,E.intEdad,
		E.intTipoProtesis, strTipoProtesis=(SELECT P.strNombreTipoProtesis FROM tbTipoProtesis2024 P WHERE P.intTipoProtesis=E.intTipoProtesis AND P.intEmpresa=E.intEmpresa AND P.intSucursal=E.intSucursal),
		E.intProceso, strProceso=(SELECT PR.strNombreProceso FROM tbProceso2024 PR WHERE PR.intProceso=E.intProceso AND PR.intEmpresa=E.intEmpresa AND PR.intSucursal=E.intSucursal),
		E.strComentario,
		E.intEstatus, strEstatus=(SELECT ES.STRNOMBRE FROM tbEstatus ES WHERE ES.intEstatus=E.intEstatus AND ES.intEmpresa=E.intEmpresa AND ES.intSucursal=E.intSucursal),
		intCajaAlmacenamiento=ISNULL(E.intCajaAlmacenamiento,0),
		datFechaAlta=CONVERT(VARCHAR(10),E.datFechaAlta,103),datFechaEntrega=CONVERT(VARCHAR(10),E.datFechaEntrega,103),
		datFechaColocacion=CONVERT(VARCHAR(10),E.datFechaColocacion,103),D.intPieza,
		D.intMaterial, strMaterial=(SELECT M.strNombre FROM tbMaterial2024 M WHERE M.intMaterial=D.intMaterial AND D.intEmpresa = 1 AND D.intSucursal = 1 ),
		D.intTipoTrabajo, strTipoTrabajo=(SELECT TT.strNombre FROM tbTipoTrabajo2024 TT WHERE TT.intTipoTrabajo=D.intTipoTrabajo AND D.intEmpresa = 1 AND D.intSucursal = 1),
		E.intColor, strColor=(SELECT Col.strNombre FROM tbColor2024 AS COL WHERE COL.intColor = E.intColor),
		D.intCantidad,
		strUrgente=(CASE ISNULL(E.intUrgente,0) WHEN 0 THEN ' ' WHEN 1 THEN 'TRABAJO URGENTE' ELSE '*' END),
		strObservaciones

--select TOP 1000* from tbOrdenLaboratorioEnc WHERE isnull(intUrgente,0) <>0

	FROM tbOrdenLaboratorioEnc E, tbOrdenLaboratorioDet D
	WHERE E.intEmpresa=@intEmpresa    
	AND E.intSucursal=@intSucursal    
	AND E.intOrdenLaboratorioEnc=@intOrdenEnc  
	AND E.intEmpresa=D.intEmpresa    
	AND E.intSucursal=D.intSucursal    
	AND E.intOrdenLaboratorioEnc=D.intOrdenLaboratorioEnc
	ORDER BY D.intOrdenLaboratorioDet
END
go

qryOrdenDental_Reporte 1, 1, 6746
go


