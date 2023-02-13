using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daEmpleado;
using appWebPrueba.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security.Claims;
using System.Threading;


namespace appWebPrueba.Controllers
{
    //Este Controlador maneja lo referente al usuario, sirve para dar de alta, baja (de manera lógica), listar o hacer cambios
    public class EmpleadoController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        // GET: Empleado
        public ActionResult Index()
        {
            return View();
        }
        //Aquí mandamos llamar la vista
        public ActionResult Empleado()
        {
            EmpleadoVM model = new EmpleadoVM();
            return View(model);
        }

        //Este método sirve para llenar el listado, en el listado podemos visualizar los datos, además de tener los botones de ELIMINAR y EDITAR
        public ActionResult getGridEmpleado(EmpleadoVM model)
        {
            //Declaramos la variable "EmpleadoID" en 0, este es un truco para traer TODOS o solo un empleado en particular
            int EmpleadoID = 0;
            //Instanciamos el modelo 
            model.lGridEmpleado = new List<GridEmpleado>();
            //Lo llenamos con lo que devuelva "getGridEmpleado"
            model.lGridEmpleado = daEmpleado.getGridEmpleado(EmpleadoID);
            //y retornamos la vista parcial con su listado
            return PartialView("../Empleado/_ListaEmpleados", model);
        }

        //Podemos eliminar empleados, esto se hace de manera lógica, de tal modo que solo contamos con una columna que nos dice si está o no "eliminado" y los excluye de cualquier SP
        [HttpPost]
        public string EliminarEmpleado(int EmpleadoID)
        {
            //Recibimos el Id del empleado
            //Usando los Claim averiguamos quien es el empleado que está logueado en el sistema y lo declararemos para mandarlo al SP, este se inserta en los campos de audotoría
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado
            Resultado res = new Resultado();
            //le asignamos la respuesta que nos devuelva el método "EliminarEmpleado"
            res = daEmpleado.EliminarEmpleado(EmpleadoID, user);
            //Devolvemos el JSON a la vista principal
            return JsonConvert.SerializeObject(res);
        }

        //Para crear un nuevo Empleado, lo primero que haremos es llamar a este método
        [HttpPost]
        public ActionResult Create()
        {
            //Instanciamos el modelo
            EmpleadoVM empleado = new EmpleadoVM();
            //Llenamos el listado de roles y se lo agregamos a la respuesta
            empleado.Rol = new Rol();
            //Para ello usamos el método que nos devuelve la lista de Roles ACTIVOS
            empleado.lRol = daEmpleado.GetListaRoles();
            //Y devolvemos la vista para crear (esta lleva los controles y botones necesarios para operarla
            return PartialView("../Empleado/Create", empleado);
        }

        //Este método es para guardar un empleado nuevo, no necesitamos el ID porque nos lo asigna la BD
        [HttpPost]
        public string GuardarEmpleado(string Nombres, string ApPaterno, string ApMaterno, int NumEmpleado, int Rol, int Activo)
        {
            //Asignamos el usuario que está logueado
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado
            Resultado res = new Resultado();
            //como tenemos una variable llamada "Activo" y es del tipo INT, la convertimos a boleana con la siguiente línea
            bool Estado = (Activo == 0 ? false : true);
            //Llamamos al siguiente mpetodo y le asignamos la respuesta al resultado
            res = daEmpleado.GuardarEmpleado(Nombres, ApPaterno, ApMaterno, NumEmpleado, Rol, Estado, user);
            //Devolvemos el resultado a la vista, en caso de que haya error en la BD se va a mostrar en la pantalla del usuario, por lo cual debemos tener cuidado de usar un lenguaje más amigable
            return JsonConvert.SerializeObject(res);
        }

        //Para editar un empleado, lo primero que haremos es llenar una vista parcial con sus datos
        //Recibimos el ID del empleado
        [HttpPost]
        public ActionResult EditarEmpleado(int EmpleadoID)
        {
            //Istanciamos el modelo de Empleado
            EmpleadoVM empleado = new EmpleadoVM();
            //Llamamos al siguiente método para traer los valores que tiene guardados
            empleado = daEmpleado.EditarEmpleado(EmpleadoID);
            //También llenamos la lista de roles para asignarlo al combo
            empleado.lRol = daEmpleado.GetListaRoles();
            //Devolvemos el modelo de empleado a la vista parcial 
            return PartialView("../Empleado/Edit", empleado);
        }

        //Este método sirve para Editar un empleado, mismo que ya tenemos cargado en la vista, por ser un EDIT, se necesita a fuerza el ID de empleado para editar solo ese en particular
        [HttpPost]
        public string GuardaEditEmpleado(int EmpleadoID, string Nombres, string ApPaterno, string ApMaterno, int NumEmpleado, int Rol, int Activo)
        {
            //Asignamos el usuario que está logueado en el sistema
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Tambien cargamos el Id del usuario.... creo que no lo necesitaba pero ya está ahí y mejor lo dejo
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado
            Resultado res = new Resultado();
            //Asignamos ACTIVO para cambiar por un booleano que mandaremos al siguiente método
            bool Estado = (Activo == 0 ? false : true);
            //Llamamos al método y asignamos la respuesta
            res = daEmpleado.GuardaEditEmpleado(EmpleadoID, Nombres, ApPaterno, ApMaterno, NumEmpleado, Rol, Estado, user);
            //Devolvemos la respuesta a la vista, en caso de error la misma vista lo mostrará 
            return JsonConvert.SerializeObject(res);
        }

    }
}