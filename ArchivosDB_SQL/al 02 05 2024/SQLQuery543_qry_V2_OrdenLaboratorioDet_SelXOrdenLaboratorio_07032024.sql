USE LabAllCeramic
go


--select * from tbOrdenLaboratorioEnc where intOrdenLaboratorioEnc = 6745
--select * from tbOrdenLaboratoriodet where intOrdenLaboratorioEnc = 6745 ORDER BY intordenLaboratorioDet


go
--qry_V2_OrdenLaboratorioDet_SelXOrdenLaboratorio 1, 1, 6745
CREATE PROCEDURE qry_V2_OrdenLaboratorioDet_SelXOrdenLaboratorio
(
	@intEmpresa INT, 
	@intSucursal INT, 
	@intOrdenLaboratorioEnc INT
)
AS
BEGIN
	SELECT 
		intEmpresa, intSucursal, intOrdenLaboratorioEnc, intOrdenLaboratorioDet, intPieza, intMaterial, intTipoTrabajo, strColor=intCantidad,intCantidad,
		--strMaterial y strTrabajo no hacen nada, solo es para pasar los parametros en el grid de Detalle de OrdenLaboratorio
		material=(SELECT M.strNombre FROM tbMaterial2024 M WHERE M.intMaterial=OD.intMaterial),
		trabajo=(SELECT T.strNombre FROM tbTipoTrabajo2024 T WHERE T.intTipoTrabajo=OD.intTipoTrabajo)
		------------------------------------------------------------------------------------------------
	FROM 
		tbOrdenLaboratorioDet AS OD
	WHERE 
		intEmpresa = @intEmpresa AND 
		intSucursal = @intSucursal AND 
		intOrdenLaboratorioEnc = @intOrdenLaboratorioEnc
	ORDER BY intOrdenLaboratorioDet
END
go




--qrySegUsuarios_Sel 'jorge'

--https://192.168.1.226/VetecReportes/Reportes/OrdenDentalPrint.aspx?orden=6745&Folio=6745&empresa=1&sucursal=1&emailorigen=x&bd=laballceramic&nombreempresa=lab




