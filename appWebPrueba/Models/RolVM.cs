using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class RolVM
    {
        public List<GridRol> lGridRol { get; set; }
        [Display(Name = "ID")]
        public int intRolID { get; set; }
        [Display(Name = "Nombre")]
        public string strNombre { get; set; }

        public bool IsAdministrativo { get; set; }
        public bool IsOperativo { get; set; }
        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public string strUsuarioAlta { get; set; }
    }

    public class GridRol
    {

        public int intRol { get; set; }
        public string strNombre { get; set; }
        public bool isAdministrativo { get; set; }
        public bool isOperativo { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }
}