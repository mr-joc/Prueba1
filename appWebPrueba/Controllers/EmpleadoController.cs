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
    public class EmpleadoController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        // GET: Empleado
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Empleado()
        {
            EmpleadoVM model = new EmpleadoVM();
            return View(model);
        }

        public ActionResult getGridEmpleado(EmpleadoVM model)
        {
            int EmpleadoID = 0;

            model.lGridEmpleado = new List<GridEmpleado>();
            model.lGridEmpleado = daEmpleado.getGridEmpleado(EmpleadoID);


            return PartialView("../Empleado/_ListaEmpleados", model);
        }

        [HttpPost]
        public string EliminarEmpleado(int EmpleadoID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daEmpleado.EliminarEmpleado(EmpleadoID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            EmpleadoVM empleado = new EmpleadoVM();
            empleado.Rol = new Rol();
            empleado.lRol = daEmpleado.GetListaRoles();

            return PartialView("../Empleado/Create", empleado);
        }


        //(string  , string  , bool , bool Activo, string user
        [HttpPost]
        public string GuardarEmpleado(string Nombres, string ApPaterno, string ApMaterno, int NumEmpleado, int Rol, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daEmpleado.GuardarEmpleado(Nombres, ApPaterno, ApMaterno, NumEmpleado, Rol, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarEmpleado(int EmpleadoID)
        {
            EmpleadoVM empleado = new EmpleadoVM();
            empleado = daEmpleado.EditarEmpleado(EmpleadoID);
            empleado.lRol = daEmpleado.GetListaRoles();
            return PartialView("../Empleado/Edit", empleado);
        }

        [HttpPost]
        public string GuardaEditEmpleado(int EmpleadoID, string Nombres, string ApPaterno, string ApMaterno, int NumEmpleado, int Rol, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();

            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);

            res = daEmpleado.GuardaEditEmpleado(EmpleadoID, Nombres, ApPaterno, ApMaterno, NumEmpleado, Rol, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}