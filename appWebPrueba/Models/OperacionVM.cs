using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class OperacionVM
    {
        //Este sirve para instanciar las columnas de la BD, tanto para guardar como para actualizar
        public List<GridOperacion> lGridOperacion { get; set; }
        [Display(Name = "Operacion")]
        public int intOperacionID { get; set; }
        [Display(Name = "Nombre")]
        public string strNombre { get; set; }
        [Display(Name = "Nombre Corto")]
        public string strNombreCorto { get; set; }

        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public decimal dblCantidadUsada { get; set; }
        public string strUsuarioAlta { get; set; }

    }

    //Listado de los Operaciones
    public class GridOperacion
    {

        public int intOperacionXTipoTrabajo { get; set; }
        public int intOperacion { get; set; }
        public int intTipoTrabajo { get; set; }
        public string strNombre { get; set; }
        public string intUltimaOperacion { get; set; }        
        public string Seq { get; set; }
        public string TypeOper { get; set; }
        public string Desc { get; set; }
        public string DescTrabajo { get; set; }
        public string strNombreCorto { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }

        //Articulos

        public int intOperacionXTipoTrabajoMaterial { get; set; }
        public int intArticulo { get; set; }
        public string PartNum { get; set; }
        public string PartDesc { get; set; }
        public string UMVenta { get; set; }
        public string UnidadMedidaArt { get; set; }
        public decimal dblCantidad { get; set; }


    }
}