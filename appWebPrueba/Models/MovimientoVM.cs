using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class MovimientoVM
    {
        [Display(Name = "ID")]
        public int intMovimientoID { get; set; }

        [Display(Name = "Número de Empleado")]
        public int intNumEmpleado { get; set; }

        [Display(Name = "Nombre")]
        public string strNombreEmpleado { get; set; }

        [Display(Name = "Rol")]
        public int intRol { get; set; }
        [Display(Name = "Rol")]
        public string strNombreRol { get; set; }
        public List<Rol_a> lRol_a { get; set; }
        public Rol_a Rol_a { get; set; }

        [Display(Name = "Mes")]
        public int intMes { get; set; }
        public List<Mes> lMes { get; set; }
        public Mes Mes { get; set; }

        [Display(Name = "Cantidad de Entregas")]
        public int intCantidadEntregas { get; set; }
        public int IsBorrado { get; set; }
        public string strUsuarioAlta { get; set; }
    }
    public class Rol_a
    {
        public string RolID_a { get; set; }
        public string Nombre_a { get; set; }
    }
    public class Mes
    {
        public string MesID { get; set; }
        public string Nombre { get; set; }
    }

}