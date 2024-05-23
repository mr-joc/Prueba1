using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class ColorimetroVM
    {
        //Este sirve para instanciar las columnas de la BD, tanto para guardar como para actualizar
        public List<GridColorimetro> lGridColorimetro { get; set; }
        [Display(Name = "Colorímetro")]
        public int intColorimetroID { get; set; }
        [Display(Name = "Nombre")]
        public string strNombre { get; set; }

        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public string strUsuarioAlta { get; set; }
    }

    //Listado de los Colorimetroes
    public class GridColorimetro
    {

        public int intColorimetro { get; set; }
        public string strNombre { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }
}