using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daProveedor;
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
    public class ProveedorController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Proveedor()
        {
            ProveedorVM model = new ProveedorVM();
            return View(model);
        }

        public ActionResult getGridProveedor(ProveedorVM model)
        {
            int ProveedorID = 0;
            model.lGridProveedor = new List<GridProveedor>();
            model.lGridProveedor = daProveedor.getGridProveedor(ProveedorID);
            return PartialView("../Proveedor/_ListaProveedor", model);
        }

        [HttpPost]
        public string EliminarProveedor(int ProveedorID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daProveedor.EliminarProveedor(ProveedorID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            ProveedorVM proveedor = new ProveedorVM();
            return PartialView("../Proveedor/Create", proveedor);
        }

        [HttpPost]
        public string GuardarProveedor(string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daProveedor.GuardarProveedor(Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarProveedor(int ProveedorID)
        {
            ProveedorVM proveedor = new ProveedorVM();
            proveedor = daProveedor.EditarProveedor(ProveedorID);
            return PartialView("../Proveedor/Edit", proveedor);
        }

        [HttpPost]
        public string GuardaEditProveedor(int ProveedorID, string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daProveedor.GuardaEditProveedor(ProveedorID, Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}