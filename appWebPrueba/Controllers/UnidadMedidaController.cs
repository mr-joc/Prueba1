using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daUnidadMedida;
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
    public class UnidadMedidaController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult UnidadMedida()
        {
            UnidadMedidaVM model = new UnidadMedidaVM();
            return View(model);
        }

        public ActionResult getGridUnidadMedida(UnidadMedidaVM model)
        {
            int UnidadMedidaID = 0;
            model.lGridUnidadMedida = new List<GridUnidadMedida>();
            model.lGridUnidadMedida = daUnidadMedida.getGridUnidadMedida(UnidadMedidaID);
            return PartialView("../UnidadMedida/_ListaUnidadMedida", model);
        }

        [HttpPost]
        public string EliminarUnidadMedida(int UnidadMedidaID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daUnidadMedida.EliminarUnidadMedida(UnidadMedidaID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            UnidadMedidaVM tipoGasto = new UnidadMedidaVM();
            return PartialView("../UnidadMedida/Create", tipoGasto);
        }

        [HttpPost]
        public string GuardarUnidadMedida(string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daUnidadMedida.GuardarUnidadMedida(Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarUnidadMedida(int UnidadMedidaID)
        {
            UnidadMedidaVM tipoGasto = new UnidadMedidaVM();
            tipoGasto = daUnidadMedida.EditarUnidadMedida(UnidadMedidaID);
            return PartialView("../UnidadMedida/Edit", tipoGasto);
        }

        [HttpPost]
        public string GuardaEditUnidadMedida(int UnidadMedidaID, string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daUnidadMedida.GuardaEditUnidadMedida(UnidadMedidaID, Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}