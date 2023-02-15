using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;


namespace appWebPrueba.Models
{
    //Queda pendiente comentar todos los modelos, pero básicamente cada variable corresponde a una columna o dato que nos entrega la BD
    public class EmpleadoVM
    {
        //Este sirve para instanciar las columnas de la BD, tanto para guardar como para actualizar
        public List<GridEmpleado> lGridEmpleado { get; set; }
        [Display(Name = "ID de Empleado")]
        public int intEmpleadoID { get; set; }
        [Display(Name = "Nombre")]
        public string strNombres { get; set; }
        [Display(Name = "Apellido Paterno")]
        public string strApPaterno { get; set; }
        [Display(Name = "Apellido Materno")]
        public string strApMaterno { get; set; }
        [Display(Name = "Número de Empleado")]
        public int intNumEmpleado { get; set; }
        [Display(Name = "Rol")]
        public int intRol { get; set; }

        public List<Rol> lRol { get; set; }
        public Rol Rol { get; set; }

        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public string strUsuarioAlta { get; set; }
    }
    //Lista de Roles
    public class Rol
    {
        public string RolID { get; set; }
        public string Nombre { get; set; }
    }
    //Lista de Empleados
    public class GridEmpleado
    {

        public int intEmpleadoID { get; set; }
        public string strNombres { get; set; }
        public string strApPaterno { get; set; }
        public string strApMaterno { get; set; }
        public int intNumEmpleado { get; set; }
        public int intRol { get; set; }
        public string strRol { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }
}