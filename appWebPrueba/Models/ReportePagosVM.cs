using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class ReportePagosVM
    {
        public List<GridPagos> lGridPagos { get; set; }

        [Display(Name = "Mes")]
        public int intMes { get; set; }
        public List<MesP> lMesP { get; set; }
        public MesP MesP { get; set; }
    }
    public class MesP
    {
        public string MesID { get; set; }
        public string Nombre { get; set; }
    }
    public class GridPagos
    {


        public int intEmpleadoID { get; set; }
        public string strNombreCompleto { get; set; }
        public int intNumEmpleado { get; set; }
        public int intRol { get; set; }
        public string strRol { get; set; }

        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}", ApplyFormatInEditMode = true)]
        public Nullable<float> dblSueldoBase { get; set; }
        public int intDiasLaborados { get; set; }
        public int intHorasLaboradas { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}", ApplyFormatInEditMode = true)]
        public Nullable<float> dblSueldoXHras { get; set; }
        public int intCantidadEntregas { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}", ApplyFormatInEditMode = true)]
        public Nullable<float> dblMontoXEntrega { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}", ApplyFormatInEditMode = true)]
        public Nullable<float> dblSueldoXEntregas { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public Nullable<float> dblBonoXRol { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public Nullable<float> dblBonoXHoras { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public Nullable<float> dblISR { get; set; }

        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}", ApplyFormatInEditMode = true)]
        public Nullable<float> dblISRAdicional { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}", ApplyFormatInEditMode = true)]
        public Nullable<float> dblSueldoIntegrado { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}", ApplyFormatInEditMode = true)]
        public Nullable<float> dblSueldoMenosISR { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}", ApplyFormatInEditMode = true)]
        public Nullable<float> dblSueldoMenosISRAdicional { get; set; }
        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}", ApplyFormatInEditMode = true)]
        public Nullable<float> dblVales { get; set; }


        [DataType(DataType.Currency)]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public Nullable<float> dblTotal { get; set; }

        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }

}