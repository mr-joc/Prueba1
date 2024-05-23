using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class ColorVM
    {
        //Este sirve para instanciar las columnas de la BD, tanto para guardar como para actualizar
        public List<GridColor> lGridColor { get; set; }
        [Display(Name = "Folio")]
        public int intColorID { get; set; }
        [Display(Name = "Nombre")]
        public string strNombre { get; set; }
        [Display(Name = "Colorímetro")]
        public int intColorimetro { get; set; }

        public List<Colorimetro> lColorimetro { get; set; }
        public Colorimetro Colorimetro { get; set; }
        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public string strUsuarioAlta { get; set; }
    }
    //Lista de Materiales
    public class Colorimetro
    {
        public string ColorimetroID { get; set; }
        public string NombreColorimetro { get; set; }
    }

    //Listado de los Colores
    public class GridColor
    {

        public int intColor { get; set; }
        public string strNombre { get; set; } 
        public string strColorimetro { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }
}