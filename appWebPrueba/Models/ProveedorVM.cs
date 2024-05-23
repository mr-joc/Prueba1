using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class ProveedorVM
    {
        //Este sirve para instanciar las columnas de la BD, tanto para guardar como para actualizar
        public List<GridProveedor> lGridProveedor { get; set; }
        [Display(Name = "Proveedor")]
        public int intProveedorID { get; set; }
        [Display(Name = "Nombre")]
        public string strNombre { get; set; }
        [Display(Name = "Nombre Corto")]
        public string strNombreCorto { get; set; }

        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public string strUsuarioAlta { get; set; }
    }

    //Listado de los Proveedores
    public class GridProveedor
    {

        public int intProveedor { get; set; }
        public string strNombre { get; set; }
        public string strNombreCorto { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }
}