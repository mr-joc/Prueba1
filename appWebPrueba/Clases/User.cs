using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Clases
{
    public class User
    {
        public string strUsuario { get; set; }
        public string NombreUsuario { get; set; }
        [DataType(DataType.Password)]
        public string Password { get; set; }
        public string nomRol { get; set; }
        public string intRol { get; set; }
        public string InternalIDUSER { get; set; }

    }
}