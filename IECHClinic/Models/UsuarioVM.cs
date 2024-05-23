using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace IECHClinic.Models
{
    public class UsuarioVM
    {
        //Este sirve para instanciar las columnas de la BD, tanto para guardar como para actualizar
        public List<GridUsuario> lGridUsuario { get; set; }
        [Display(Name = "ID del Usuario")]
        public int intUsuario { get; set; }
        [Display(Name = "Nombres")]
        public string strNombre_Usuario { get; set; }
        [Display(Name = "Clave")]
        public string strUsuario { get; set; }
        [Display(Name = "Apellido Paterno")]
        public string strApPaterno_Usuario { get; set; }
        [Display(Name = "Apellido Materno")]
        public string strApMaterno_Usuario { get; set; }
        [Display(Name = "Perfil")]
        public int intRol { get; set; }
        [Display(Name = "Password")]
        public string strContrasena { get; set; }
        [Display(Name = "Password2")]
        public string strContrasena2 { get; set; }

        public List<Perfil> lPerfil { get; set; }
        public Perfil Perfil { get; set; }

        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public string strUsuarioAlta { get; set; }
    }
    //Lista de Roles
    public class Perfil
    {
        public string PerfilID { get; set; }
        public string NombrePerfil { get; set; }
    }
    //Usuarios
    public class GridUsuario
    {

        public int intUsuarioID { get; set; }
        public string strNombreUsuario { get; set; }
        public string strNombres { get; set; }        
        public string strUsuario { get; set; }        
        public string strApPaterno { get; set; }
        public string strApMaterno { get; set; }
        public int intNumUsuario { get; set; }
        public int intRol { get; set; }
        public string strRol { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }
}