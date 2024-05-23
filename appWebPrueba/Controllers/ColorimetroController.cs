using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daColorimetro;
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
    public class ColorimetroController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Colorimetro()
        {
            ColorimetroVM model = new ColorimetroVM();
            return View(model);
        }

        public ActionResult getGridColorimetro(ColorimetroVM model)
        {
            int ColorimetroID = 0;
            model.lGridColorimetro = new List<GridColorimetro>();
            model.lGridColorimetro = daColorimetro.getGridColorimetro(ColorimetroID);
            return PartialView("../Colorimetro/_ListaColorimetro", model);
        }

        [HttpPost]
        public string EliminarColorimetro(int ColorimetroID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daColorimetro.EliminarColorimetro(ColorimetroID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            ColorimetroVM colorimetro = new ColorimetroVM();
            return PartialView("../Colorimetro/Create", colorimetro);
        }

        [HttpPost]
        public string GuardarColorimetro(string Nombre, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daColorimetro.GuardarColorimetro(Nombre, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarColorimetro(int ColorimetroID)
        {
            ColorimetroVM colorimetro = new ColorimetroVM();
            colorimetro = daColorimetro.EditarColorimetro(ColorimetroID);
            return PartialView("../Colorimetro/Edit", colorimetro);
        }

        [HttpPost]
        public string GuardaEditColorimetro(int ColorimetroID, string Nombre, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daColorimetro.GuardaEditColorimetro(ColorimetroID, Nombre, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}