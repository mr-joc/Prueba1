using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daMaterial;
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
    public class MaterialController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Material()
        {
            MaterialVM model = new MaterialVM();
            return View(model);
        }

        public ActionResult getGridMaterial(MaterialVM model)
        {
            int MaterialID = 0;
            model.lGridMaterial = new List<GridMaterial>();
            model.lGridMaterial = daMaterial.getGridMaterial(MaterialID);
            return PartialView("../Material/_ListaMaterial", model);
        }

        [HttpPost]
        public string EliminarMaterial(int MaterialID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daMaterial.EliminarMaterial(MaterialID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            MaterialVM material = new MaterialVM();
            return PartialView("../Material/Create", material);
        }

        [HttpPost]
        public string GuardarMaterial(string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daMaterial.GuardarMaterial(Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarMaterial(int MaterialID)
        {
            MaterialVM material = new MaterialVM();
            material = daMaterial.EditarMaterial(MaterialID);
            return PartialView("../Material/Edit", material);
        }

        [HttpPost]
        public string GuardaEditMaterial(int MaterialID, string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daMaterial.GuardaEditMaterial(MaterialID, Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}