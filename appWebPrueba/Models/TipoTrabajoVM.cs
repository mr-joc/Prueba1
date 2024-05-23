using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class TipoTrabajoVM
    {
        //Este sirve para instanciar las columnas de la BD, tanto para guardar como para actualizar
        public List<GridTipoTrabajo> lGridTipoTrabajo { get; set; }
        [Display(Name = "Trabajo")]
        public int intTipoTrabajoID { get; set; }
        [Display(Name = "Nombre")]
        public string strNombre { get; set; }
        [Display(Name = "Nombre Corto")]
        public string strNombreCorto { get; set; }
        public int intMaterial { get; set; }

        public List<Material> lMaterial { get; set; }
        public Material Material { get; set; }
        [Display(Name = "Precio")]
        public decimal dblPrecio { get; set; }
        [Display(Name = "Precio Urgencia")]
        public decimal dblPrecioUrgente { get; set; }
        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public string strUsuarioAlta { get; set; }
    }
    //Lista de Materiales
    public class Material
    {
        public string MaterialID { get; set; }
        public string NombreMaterial { get; set; }
    }

    //Listado de los TipoTrabajoes
    public class GridTipoTrabajo
    {

        public int intTipoTrabajo { get; set; }
        public string strNombre { get; set; }
        public string strNombreCorto { get; set; }
        public string strMaterial { get; set; }
        public decimal dblPrecio { get; set; }
        public decimal dblPrecioUrgente { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }
}