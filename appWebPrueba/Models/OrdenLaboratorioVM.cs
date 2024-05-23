using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace appWebPrueba.Models
{
    public class OrdenLaboratorioVM
    {
        public int intTipoDatoMuestra { get; set; }
        public List<GridOrdenLaboratorio> lGridOrdenLaboratorio { get; set; }
        public List<Colorimetros> lColorimetros { get; set; }
        public Colorimetros Colorimetros { get; set; }
        public List<ColoresXCol> lColoresXCol { get; set; }
        public ColoresXCol ColoresXCol { get; set; }
        public List<ProcesoXProtesis> lProcesoXProtesis { get; set; }
        public ProcesoXProtesis ProcesoXProtesis { get; set; }
        public List<MaterialesORD> lMaterialesORD { get; set; }
        public MaterialesORD MaterialesORD { get; set; }
        public List<TrabXMatORD> lTrabXMatORD { get; set; }
        public TrabXMatORD TrabXMatORD { get; set; }

        public int intEmpresa { get; set; }
        public int intSucursal { get; set; }
        public int intOrdenLaboratorioEnc { get; set; }
        [Display(Name = "Folio")]
        public int intFolio { get; set; }
        [Display(Name = "Doctor")]
        public int intDoctor { get; set; }
        [Display(Name = "Material")]
        public int intMaterial { get; set; }
        [Display(Name = "Paciente")]
        public int intExpediente { get; set; }
        public int intFolioPago { get; set; }
        [Display(Name = "Prótesis")]
        public int intTipoProtesis { get; set; }
        public int intPieza { get; set; }
        public decimal decPieza { get; set; }
        [Display(Name = "Proceso")]
        public int intProceso { get; set; }
        public string strProceso { get; set; }

        [Display(Name = "Trabajo")]
        public int intTipoTrabajo { get; set; }
        [Display(Name ="Edad")]
        public int intEdad { get; set; }
        public int intSexo { get; set; }
        [Display(Name = "Con Garantía?")]
        public int intConGarantia { get; set; }
        [Display(Name = "Color")]
        public int intColor { get; set; }
        [Display(Name = "Facturar")]
        public int intFactura { get; set; }
        public int intEstatus { get; set; }
        public int intLabExterno { get; set; }

        [Display(Name = "Colorímetro")]
        public int intColorimetro { get; set; }
        public string strColorimetro { get; set; }

        public List<Doctores> lDoctores { get; set; }
        public Doctores Doctores { get; set; }
        public List<Protesis> lProtesis { get; set; }
        public Protesis Protesis { get; set; }

        [Display(Name = "Es Urgente?")]
        public int intUrgente { get; set; }

        [Display(Name = "Precio")]
        public decimal dblPrecio { get; set; }
        public decimal dblPrecioReal { get; set; }

        [Display(Name = "Elaborada")]
        public DateTime datFechaElabora { get; set; }

        [Display(Name = "Entrega")]
        public DateTime datFechaEntrega { get; set; }
        [Display(Name = "Colocación")]
        public DateTime datFechaColocacion { get; set; }
        public DateTime datFechaAlta { get; set; }
        public string strFechaAlta { get; set; }

        [Display(Name = "Paciente")]
        public string strNombrePaciente { get; set; }
        public string strColor { get; set; }
        [Display(Name = "Instrucciones para el laboratorio")]
        public string strComentario { get; set; }
        [Display(Name = "Observaciones")]
        public string strObservaciones { get; set; }
        public string strUsuario { get; set; }
        public string strEncabezado { get; set; }
        public string strTipoProtesis { get; set; }
        
        public decimal dblCosto { get; set; }
        public decimal dblPagado { get; set; }
        public decimal dblSaldo { get; set; }


        public int intCaja { get; set; }
        public string strFechaEntrega { get; set; }
        public string strDoctor { get; set; }
        public string strFechaColocacion { get; set; }
        public string strImagenEstatus { get; set; } 
        public string strEncabezadoImg { get; set; }
        public string strEncaRechazo { get; set; }
        public string strEncaHistorial { get; set; } 
        public string strImagenes { get; set; }
        public string strEncabezadoEstatusProceso { get; set; }
        public string strImagenProceso { get; set; }


        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public string strUsuarioAlta { get; set; }



        //@intEmpresa INT,
        //@intSucursal INT,
        //@intOrdenLaboratorioEnc INT,
        //@intFolio INT,
        //@intDoctor INT,
        //@strNombrePaciente VARCHAR(500),
        //@intExpediente INT,
        //@intFolioPago INT,
        //@dblPrecio NUMERIC(18,2),
        //@intTipoProtesis INT,
        //@intPieza NUMERIC(18,2),
        //@intProceso INT,
        //@intTipoTrabajo INT,
        //@strColor VARCHAR(10),
        //@strComentario VARCHAR(500),
        //@strObservaciones VARCHAR(500),
        //@intEdad INT,
        //@intSexo INT,
        //@intConGarantia INT,
        //@intColor INT,
        //@intFactura INT,
        //@intEstatus INT,
        //@datFechaEntrega DATETIME,
        //@datFechaColocacion DATETIME,
        //@intColorimetro INT,
        //@intUrgente INT,
        //@strUsuario VARCHAR(150),
        //@strMaquina VARCHAR(150)

    }



    public class MaterialesORD
    {
        public string MaterialID { get; set; }
        public string Nombre { get; set; }


    }
    public class TrabXMatORD
    {
        public string MaterialID { get; set; }
        public string intTrabajo { get; set; }
        public string strNombre { get; set; }

    }

    public class Colorimetros
    {
        public string ColorimetroID { get; set; }
        public string Nombre { get; set; }


    }
    public class ColoresXCol
    {
        public string ColorimetroID { get; set; }
        public string intColor { get; set; }
        public string strNombre { get; set; }

    }

    public class Protesis
    {
        public string TipoProtesisID { get; set; }
        public string Nombre { get; set; }


    }

    public class Doctores
    {
        public string DoctorID { get; set; }
        public string Nombre { get; set; }


    }
    public class ProcesoXProtesis
    {
        public string TipoProtesisID { get; set; }
        public string ProcesoID { get; set; }
        public string intFolioProceso { get; set; }
        public string strNombre { get; set; }

    }

    //Listado de los TipoGastoes
    public class GridOrdenLaboratorio
    {
        public string intEmpresa { get; set; }
        public string intSucursal { get; set; }
        public string intFolio { get; set; }
        public string intOrdenLaboratorioEnc { get; set; }
        public string intOrdenLaboratorioDet { get; set; }
        public string intPieza { get; set; }
        public string intMaterial { get; set; }
        public string intTipoTrabajo { get; set; }
        public string strColor { get; set; }
        public string intCantidad { get; set; }
        public string strMaterial { get; set; }
        public string strTipoTrabajo { get; set; }
        public string strNombrePaciente { get; set; }
        public string strClinica { get; set; }
        public string strDoctor { get; set; }
        public string intTipoProtesis { get; set; }
        public string strTipoProtesis { get; set; }
        public string strProceso { get; set; }
        public string datEntrega { get; set; }
        public string intDiasRetraso { get; set; }
        public string strComentario { get; set; }
        public string intEstatus { get; set; }
        public string strAccionEstatus { get; set; }
        public string strAccionRechazar { get; set; }
        public string strAccionImagenes { get; set; }
        public string strAccionHistorial { get; set; }
        public string strAbonarTrabajo { get; set; }
        public string strAccionVerDetalle { get; set; }
        public string strEstatusProceso { get; set; }
        public string dblCosto { get; set; }
        public string dblPagado { get; set; }
        public string dblSaldo { get; set; }

        public string strFecha { get; set; }
        public string strFechaEntrega { get; set; }
        public string strFechaColoca { get; set; }
        public string strFecha01 { get; set; }
        public string strFecha02 { get; set; }
        public string strFecha03 { get; set; }
        public string strFechaAlta { get; set; }
        public string strFechaMod { get; set; }



        public string intProcesado { get; set; }
        public string intAutorizado { get; set; }
        public string intAbonoTrabajo { get; set; }
        public string intOrden { get; set; }
        public string intProceso { get; set; } 
        public string intMotivo { get; set; }
        public string strEstatus { get; set; }
        public string strUsuario { get; set; }
        public string strUsuarioCompuesto { get; set; }
        public string strMaquina { get; set; }
        public string strFechaHora { get; set; }
        public string strMotivo { get; set; }
        public string strImagenes { get; set; }

    }

}