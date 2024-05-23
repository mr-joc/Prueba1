USE LabAllCeramic
go



go
--qry_V2_TipoTrabajoXMaterial_Sel 1, 1, 7, 0
alter PROCEDURE qry_V2_TipoTrabajoXMaterial_Sel
(
	 @intEmpresa		INT 
	,@intSucursal		INT 
	,@intMaterial		INT 
	,@intTipoTrabajo	INT 
	,@intActivos		INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @intActivos = ISNULL(@intActivos, 0)


	SELECT intTipoTrabajo,strNombre,strNombreCorto,intMaterial,
		strMaterial = (SELECT M.strNombre FROM tbMaterial AS M WHERE M.intMAterial = T.intMAterial),
		dblPrecio,dblPrecioUrgencia,isActivo,
		strActivo =(CASE isActivo WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' ELSE '.' END )
	FROM tbTipoTrabajo2024(NOLOCK) AS T
	WHERE intMaterial=@intMaterial
		AND (isActivo = @intActivos OR @intActivos=0) 
END
go

qry_V2_TipoTrabajoXMaterial_Sel @intEmpresa = 1, @intSucursal = 1, @intMaterial = 2, @intTipoTrabajo = 0,@intActivos = 1
