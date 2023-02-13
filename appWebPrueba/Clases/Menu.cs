using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace appWebPrueba.Clases
{
    public class Menu
    {
        //CLASE MENU
        public int IdMenu { get; set; }
        public string Descripcion { get; set; }
        public string Parametro { get; set; }
        public string View { get; set; }
        public string Controller { get; set; }
        public byte IDRol { get; set; }
        public byte subMenu { get; set; }
        public byte Orden { get; set; }
        public byte Nivel { get; set; }
        public bool IsNode { get; set; }
        public string Icon { get; set; }
    }

}