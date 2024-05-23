using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daColor;
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
    public class ColorController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Color()
        {
            ColorVM model = new ColorVM();
            return View(model);
        }

        public ActionResult getGridColor(ColorVM model)
        {
            int ColorID = 0;
            model.lGridColor = new List<GridColor>();
            model.lGridColor = daColor.getGridColor(ColorID);
            return PartialView("../Color/_ListaColor", model);
        }

        [HttpPost]
        public string EliminarColor(int ColorID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daColor.EliminarColor(ColorID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            ColorVM color = new ColorVM();
            color.Colorimetro = new Colorimetro();
            color.lColorimetro = daColor.GetListaColorimetro();
            return PartialView("../Color/Create", color);
        }

        [HttpPost]
        public string GuardarColor(string Nombre, int intColorimetro, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daColor.GuardarColor(Nombre, intColorimetro, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarColor(int ColorID)
        {
            ColorVM color = new ColorVM();
            color = daColor.EditarColor(ColorID);
            color.lColorimetro = daColor.GetListaColorimetro();
            return PartialView("../Color/Edit", color);
        }

        [HttpPost]
        public string GuardaEditColor(int ColorID, string Nombre, int intColorimetro, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daColor.GuardaEditColor(ColorID, Nombre, intColorimetro, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}