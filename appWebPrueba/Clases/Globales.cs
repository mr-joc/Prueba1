using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace appWebPrueba.Clases
{
    public class Globales
    {
        /// <summary>
        /// Variable Enum que Marca si estamos Iniciando o Terminando una tarea
        /// </summary>
        public enum StatusAccion { Inicio, Fin };

        public class Escaneo
        {
            public string JobNum { get; set; }
            public int OrderNum { get; set; }
            public int OrderLine { get; set; }
        }
    }
}