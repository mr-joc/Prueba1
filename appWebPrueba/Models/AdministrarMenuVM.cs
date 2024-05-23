using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class AdministrarMenuVM
    {
        public List<GridAdministrarMenu> lGridAdministrarMenu { get; set; }
        [Display(Name = "Perfil")]
        public int intRol { get; set; }
        [Display(Name = "ID de Usuario")]
        public int intInternalID { get; set; }


        public List<PerfilAdmin> lPerfilAdmin { get; set; }
        public PerfilAdmin PerfilAdmin { get; set; }

    }
    //Lista de Roles
    public class PerfilAdmin
    {
        public string PerfilID { get; set; }
        public string NombrePerfil { get; set; }
    }

    public class GridAdministrarMenu
    {
        public int intMenuReal { get; set; }
        public int intMenu1 { get; set; }
        public int intMenu2 { get; set; }
        public int intMenu3 { get; set; }
        public int intMenu4 { get; set; }
        public int intPerfil { get; set; }
        public string strDesgloseMenu { get; set; }
        public string strDescripcion1 { get; set; }
        public string strDescripcion2 { get; set; }
        public string strDescripcion3 { get; set; }
        public string strDescripcion4 { get; set; }
        public string strDescripcion5 { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }
}