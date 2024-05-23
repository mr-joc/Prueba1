using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class ProductionVM
    {
        public List<JobDetail> lPendientes { get; set; }
        public List<GridResumenProduccion> lGridResumenProduccion { get; set; }
        public List<GraficaXHora> lGraficaXHora { get; set; }

    }

    public class GridResumenProduccion
    {
        public string strDepartamentoActual { get; set; }
        public int intAcumuladoSemanal { get; set; }
        public int intPromedio { get; set; }
        public int intAcumuladoHoy { get; set; }
        public int intPendientes { get; set; }
    }


    public class GraficaXHora
    {
        public string jSonReport { get; set; }
        public string gLineas { get; set; }
        public string gPerfiles { get; set; }
        public string gTelas { get; set; }
        public string gEnsamble { get; set; }
        public string gEmbobinado { get; set; }
        public string gAlturas { get; set; }
        public string gEmpaque { get; set; }
        public string gPT { get; set; }

    }

    public class JobDetail
    {
        public int OrderNum { get; set; }
        //public int QuoteNum { get; set; }
        public int OrderLine { get; set; }
        public int OrderRel { get; set; }
        public string JobNum { get; set; }
        public string JobPartNum { get; set; }
        public string JobPartDesc { get; set; }
        //public string Reguion { get; set; }
        //public string JobPartDesc { get; set; }
        //public int IsWeb { get; set; }

        //public string frstDescTela { get; set; }
        public string smartString { get; set; }
        //public string MarcaPersiana { get; set; }
        //public string TipoPersiana { get; set; }
        //public string Modelo { get; set; }
        public DateTime OrderDate { get; set; }
        //public bool Impreso { get; set; }

        public int Status_Entrega { get; set; }

        public int intAntiguedadDias { get; set; }

        public string BadgeStatus_Entrega
        {
            get
            {
                string Estado = string.Empty;
                switch (Status_Entrega)
                {
                    case 1:
                        Estado = "OK";
                        break;
                    case 2:
                        Estado = "Entrega Pendiente";
                        break;
                    case 3:
                        Estado = "Entrega próxima";
                        break;
                    case 0:
                        Estado = "ENTREGA VENCIDA";
                        break;
                }
                return Estado;
            }
        }
        public string BadgeStyle_Entrega
        {
            get
            {
                string Estado = string.Empty;
                switch (Status_Entrega)
                {
                    case 1:
                        Estado = "badge-success";
                        break;
                    case 2:
                        Estado = "badge-info";
                        break;
                    case 3:
                        Estado = "badge-purple";
                        break;
                    case 0:
                        Estado = "badge-danger";
                        break;
                }
                return Estado;
            }
        }


        public string BadgeStatus_Antiguedad
        {
            get
            {
                string Estado = string.Empty;
                switch (intAntiguedadDias)
                {
                    case 1:
                        Estado = "Nuevo";
                        break;
                    case 2:
                        Estado = "2 Días";
                        break;
                    case 3:
                        Estado = "7 Días";
                        break;
                    case 4:
                        Estado = "+7 Días";
                        break;
                }
                return Estado;
            }
        }
        public string BadgeStyle_Antiguedad
        {
            get
            {
                string Estado = string.Empty;
                switch (intAntiguedadDias)
                {
                    case 1:
                        Estado = "badge-success";
                        break;
                    case 2:
                        Estado = "badge-primary";
                        break;
                    case 3:
                        Estado = "badge-warning";
                        break;
                    case 4:
                        Estado = "badge-danger";
                        break;
                }
                return Estado;
            }
        }

    }
}