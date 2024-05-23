using Newtonsoft.Json;
using IECHClinic.Clases;
using IECHClinic.DataAccess.daRol;
using IECHClinic.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security.Claims;
using System.Threading;

namespace IECHClinic.Controllers
{
    //Este controlador lo usamos para el manejo de perfiles:
    //Alta, baja, modificaciones y listado
    public class RolController : Controller
    {
        //Usamos los Claim para cargar las variables de sesión
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        // GET: Rol
        public ActionResult Index()
        {
            return View();
        }

        //Este método lo usamos para traer la vista principal, no lleva carga ni listas, solo el modelo vacío
        public ActionResult Rol()
        {
            RolVM model = new RolVM();
            return View(model);
        }

        //Este método lo usamos para mostrar el listado o grid
        public ActionResult getGridRol(RolVM model)
        {
            //Usamos el ROL = 0 a manera de truco para mandar pedir el listado completo
            int RolID = 0;
            //cargamos el modelocon la lista de los roles
            model.lGridRol = new List<GridRol>();
            //Invocamos al siguiente método para llenar el listado
            model.lGridRol = daRol.getGridRol(RolID);
            //Y el modelo ya cargado lo mandamos a la vista parcial
            return PartialView("../Rol/_ListaRoles", model);
        }

        //Con este método se eliminan los roles que ya no usemos
        //Solo recibimos el ID
        [HttpPost]
        public string EliminarRol(int RolID)
        {
            //Asignamos el usuario que está usando el sistema
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos la clase resultado
            Resultado res = new Resultado();
            //Asignamos al resultado la respuesta del siguiente método
            res = daRol.EliminarRol(RolID, user);
            //Y devolvemos la respuesta
            return JsonConvert.SerializeObject(res);
        }

        //Este método es el primero que usaremos en la vista de Roles
        [HttpPost]
        public ActionResult Create()
        {
            RolVM rol = new RolVM();
            //Solo es para devolver la vista parcial para crear, no lleva listas ni nada
            return PartialView("../Rol/Create", rol);
        }

        //Con el siguiente método 
        [HttpPost]
        public string GuardarRol(string Nombre, int isAdmin, int Activo)
        {
            //Asignamos el usuario que está usando el sistema
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado a la clase que corresponde
            Resultado res = new Resultado();
            //Tanto ESTADO como el valor para saber si es Administrativo son boleanos, entonces hacemos esta evaluación para obenerlos
            bool Estado = (Activo == 0 ? false : true);
            bool blAdmin = (isAdmin == 0 ? false : true);
            //Asignamos al resultado la respuesta que mande este método
            res = daRol.GuardarRol(Nombre, blAdmin, Estado, user);
            //Y devolvemos la respuesta a la vista
            return JsonConvert.SerializeObject(res);
        }

        //Este método nos devuelve la vista para editar alguno de los roles
        [HttpPost]
        //Recibimos el ID del Rol que vamos a Editar
        public ActionResult EditarRol(int RolID)
        {
            //Instanciamos el modelo de Rol
            RolVM rol = new RolVM();
            //Llenamos el modelo con el siguiente método
            rol = daRol.EditarRol(RolID);
            //Y se lo regresamos a la vista que lo cargará en los controles
            return PartialView("../Rol/Edit", rol);
        }

        //Este método guarda los valores que hayamos editado en la vista
        [HttpPost]
        public string GuardaEditRol(int RolID, string Nombre, int isAdmin, int Activo)
        {
            //Asignamos los parámetros de Usuario e ID del usuario que están logueados, el ID en realidad no nos sirve, pero más adelante lo podríamos usar en lugar del nombre, para de esta forma hacerlo más eficiente
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            //Instanciamos la clase de Resultado
            Resultado res = new Resultado();
            //Como las variables Activo y EsAdmin son boleanas entonces hacemos este paso para convertirlas a partir de un entero que puede ser 1 y 0
            bool Estado = (Activo == 0 ? false : true);
            bool blAdmin = (isAdmin == 0 ? false : true);
            //Asignamos al resultado la respuesta que nos de el siguiente método
            //Tanto en caso de éxito como de no tenerlo, se mostrará el mensaje que nos mande en el front
            res = daRol.GuardaEditRol(RolID, Nombre, blAdmin, Estado, user);
            //Devolvemos la respuesta
            return JsonConvert.SerializeObject(res);
        }

    }
}