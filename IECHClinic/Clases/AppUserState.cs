using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IECHClinic.Clases
{
    public class AppUserState
    {
        //La clase de "AppUserState" la usamos para guardar los datos del usuario y asignarlos a "Claims"

        //Clave del Usuario
        public string strUsuario { get; set; }
        //Nombre Completo del Usuario
        public string NombreUsuario { get; set; }
        //Nombre del Rol que este tiene
        public string nomRol { get; set; }
        //ID del rol
        public string intRol { get; set; }
        //Este se usa para asignar el ID único con el que se da de alta, servirá para buscar su Clave o directamente integrarlo a los campos de Auditoría
        public string InternalIDUSER { get; set; }
    }
}