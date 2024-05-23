USE LabAllCeramic
go



go
alter PROCEDURE qry_V2_BuscarOrdenLaboratorio_SEL
	 @Empresa				INT = NULL
	,@intSucursal			INT = NULL
	,@Folio					INT = NULL
	,@intDoctor				INT = NULL
	,@intTipoProtesis		INT = NULL
AS
BEGIN

	SET @Empresa = ISNULL(@Empresa, 1)
	SET @intSucursal = ISNULL(@intSucursal, 1)
	SET @Folio = ISNULL(@Folio, 0)
	SET @intDoctor = ISNULL(@intDoctor, 0)
	SET @intTipoProtesis = ISNULL(@intTipoProtesis, 0)

	SELECT 
		Folio=intFolio, 
		Fecha=(Convert(Varchar(10),datFechaEntrega,103)), 
		Folio_OrdenLab=intOrdenLaboratorioEnc, 
		Doctor=ISNULL((SELECT D.strNombre+' '+D.strApPaterno+' '+D.strApMaterno 
						FROM tbDoctor D 
						WHERE D.intDoctor=O.intDoctor),'- - -'), 
		Protesis=( SELECT P.strNombreTipoProtesis 
					FROM tbtipoProtesis P 
					WHERE P.intTipoProtesis = O.intTipoProtesis ) 
		, O.intDoctor, O.intTipoProtesis 
	FROM tbOrdenLaboratorioEnc O 
	WHERE intEmpresa = @Empresa
		AND intSucursal = @intSucursal 
		AND (intOrdenLaboratorioEnc = @Folio OR @Folio = 0)
		AND (intDoctor = @intDoctor OR @intDoctor = 0)
		AND (intTipoProtesis = @intTipoProtesis OR @intTipoProtesis = 0)
	ORDER BY intFolio DESC 
END
go


qry_V2_BuscarOrdenLaboratorio_SEL @Empresa = 1, @intSucursal = 1, @Folio= 0
go



qryOrdenLaboratorioEnc_Sel 1,1,941
go
--
--

--intEmpresa
--intSucursal
--intOrdenLaboratorioEnc
--strEncabezado
--dblCosto
--dblPagado
--dblSaldo
--intFolio
--intDoctor
--strNombrePaciente
--intExpediente
--intFolioPago
--intTipoProtesis
--strTipoProtesis
--intPieza
--intProceso
--strProceso
--intTipoTrabajo
--strColor
--strComentario
--strObservaciones
--intEdad
--intSexo
--intGarantia
--intEstatus
--intColorimetro
--intColor
--intFactura
--dblPrecio
--dblPrecioReal
--datFechaAlta
--datFechaEntrega
--datFechaColocacion
--intUrgente
--intLabExterno
--strUsuarioAlta
--strMaquinaAlta
--datFechaMod
--strUsuarioMod
--strMaquinaMod




 