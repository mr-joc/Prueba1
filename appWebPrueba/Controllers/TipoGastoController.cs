using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daTipoGasto;
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
    public class TipoGastoController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult TipoGasto()
        {
            TipoGastoVM model = new TipoGastoVM();
            return View(model);
        }

        public ActionResult getGridTipoGasto(TipoGastoVM model)
        {
            int TipoGastoID = 0;
            model.lGridTipoGasto = new List<GridTipoGasto>();
            model.lGridTipoGasto = daTipoGasto.getGridTipoGasto(TipoGastoID);
            return PartialView("../TipoGasto/_ListaTipoGasto", model);
        }

        [HttpPost]
        public string EliminarTipoGasto(int TipoGastoID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daTipoGasto.EliminarTipoGasto(TipoGastoID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            TipoGastoVM tipoGasto = new TipoGastoVM();
            return PartialView("../TipoGasto/Create", tipoGasto);
        }

        [HttpPost]
        public string GuardarTipoGasto(string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daTipoGasto.GuardarTipoGasto(Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarTipoGasto(int TipoGastoID)
        {
            TipoGastoVM tipoGasto = new TipoGastoVM();
            tipoGasto = daTipoGasto.EditarTipoGasto(TipoGastoID);
            return PartialView("../TipoGasto/Edit", tipoGasto);
        }

        [HttpPost]
        public string GuardaEditTipoGasto(int TipoGastoID, string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daTipoGasto.GuardaEditTipoGasto(TipoGastoID, Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}