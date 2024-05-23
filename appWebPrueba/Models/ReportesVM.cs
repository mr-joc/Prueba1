using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class ReportesVM
    {
        public List<GridAdeudosXDr> lGridAdeudosXDr { get; set; }

        public List<DoctoresR> lDoctoresR { get; set; }
        public DoctoresR DoctoresR { get; set; }
        public List<Pagado> lPagado { get; set; }
        public Pagado Pagado { get; set; }
        [Display(Name = "Doctor")]
        public int intDoctor { get; set; }

        [Display(Name = "Pagado")]
        public int intPagado { get; set; }

    }

    public class DoctoresR
    {
        public string DoctorID { get; set; }
        public string Nombre { get; set; }


    }

    public class Pagado
    {
        public string intTipo { get; set; }
        public string strNombre { get; set; }


    }

    public class GridAdeudosXDr
    {
        public string intOrdenLaboratorioEnc { get; set; }
        public string strNombrePaciente { get; set; }
        public string strDoctor { get; set; }
        public string strTipoProtesis { get; set; }
        public string strProceso { get; set; }
        public string strDetalle { get; set; }
        public string datEntrega { get; set; }
        public string datEntregaReal { get; set; }
        public string intDiasRetraso { get; set; }
        public decimal dblCosto { get; set; }
        public decimal dblPagado { get; set; }
        public decimal dblSaldo { get; set; }
        public string strComentario { get; set; }
        public string strObservaciones { get; set; }
        public string intEstatus { get; set; }
        public string strEstatus { get; set; }
        public string strEstatus2 { get; set; }
        public string strImagenes { get; set; }

    }

}