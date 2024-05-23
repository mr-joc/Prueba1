using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace IECHClinic.Clases
{
    public class User
    {//Cuando el usuario se valida, tomamos esta clase para asignar los valores que corresponden 

        //Usuario es lo que tecleamos para entrar, en mi caso MR-JOC
        public string strUsuario { get; set; }
        //El nombre completo
        public string NombreUsuario { get; set; }
        //Password encriptado, en este caso lo usamos en STRING por la premura del tiempo
        [DataType(DataType.Password)]
        //Password en formato STRING, este no es seguro pero lo dejamos así para facilitar el acceso
        public string Password { get; set; }
        //El nombre del rol
        public string nomRol { get; set; }
        //Identificador del Rol
        public string intRol { get; set; }
        //número de Usuario (IDENTITY) asignado por la BD
        public string InternalIDUSER { get; set; }

    }
}