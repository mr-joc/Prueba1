using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace appWebPrueba.Clases
{
    /// <summary>
    /// Clase generica para enlistarlos parametros para consumir un Stored Procedure
    /// </summary>
    public class Parametros
    {
        public string Nombre { get; set; }
        public SqlDbType Tipo { get; set; }
        public object Valor { get; set; }
        public string Fecha { get; set; }

    }
}