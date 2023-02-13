using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daRol;
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

        [HttpPost]
        public string EliminarRol(int RolID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daRol.EliminarRol(RolID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            RolVM rol = new RolVM();
            return PartialView("../Rol/Create", rol);
        }

        [HttpPost]
        public string GuardarRol(string Nombre, int isAdmin, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            bool blAdmin = (isAdmin == 0 ? false : true);

            res = daRol.GuardarRol(Nombre, blAdmin, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarRol(int RolID)
        {
            RolVM rol = new RolVM();
            rol = daRol.EditarRol(RolID);
            return PartialView("../Rol/Edit", rol);
        }

        [HttpPost]
        public string GuardaEditRol(int RolID, string Nombre, int isAdmin, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();

            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            bool blAdmin = (isAdmin == 0 ? false : true);

            res = daRol.GuardaEditRol(RolID, Nombre, blAdmin, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}