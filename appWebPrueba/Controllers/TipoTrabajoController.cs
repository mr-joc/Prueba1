using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daTipoTrabajo;
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
    public class TipoTrabajoController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult TipoTrabajo()
        {
            TipoTrabajoVM model = new TipoTrabajoVM();
            return View(model);
        }

        public ActionResult getGridTipoTrabajo(TipoTrabajoVM model)
        {
            int TipoTrabajoID = 0;
            model.lGridTipoTrabajo = new List<GridTipoTrabajo>();
            model.lGridTipoTrabajo = daTipoTrabajo.getGridTipoTrabajo(TipoTrabajoID);
            return PartialView("../TipoTrabajo/_ListaTipoTrabajo", model);
        }

        [HttpPost]
        public string EliminarTipoTrabajo(int TipoTrabajoID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daTipoTrabajo.EliminarTipoTrabajo(TipoTrabajoID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            TipoTrabajoVM tipoTrabajo = new TipoTrabajoVM();
            tipoTrabajo.Material = new Material();
            tipoTrabajo.lMaterial = daTipoTrabajo.GetListaMateriales();
            return PartialView("../TipoTrabajo/Create", tipoTrabajo);
        }

        [HttpPost]
        public string GuardarTipoTrabajo(string Nombre, string NombreCorto, int intMaterial, decimal dblPrecio, decimal dblPrecioUrgencia, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true); 
            res = daTipoTrabajo.GuardarTipoTrabajo(Nombre, NombreCorto, intMaterial, dblPrecio, dblPrecioUrgencia, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarTipoTrabajo(int TipoTrabajoID)
        {
            TipoTrabajoVM tipoTrabajo = new TipoTrabajoVM();
            tipoTrabajo = daTipoTrabajo.EditarTipoTrabajo(TipoTrabajoID);
            //También llenamos la lista de roles para asignarlo al combo
            tipoTrabajo.lMaterial = daTipoTrabajo.GetListaMateriales();
            return PartialView("../TipoTrabajo/Edit", tipoTrabajo);
        }

        [HttpPost]
        public string GuardaEditTipoTrabajo(int TipoTrabajoID, string Nombre, string NombreCorto, int intMaterial, decimal dblPrecio, decimal dblPrecioUrgencia, int Activo)
        {
           string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daTipoTrabajo.GuardaEditTipoTrabajo(TipoTrabajoID, Nombre, NombreCorto, intMaterial, dblPrecio, dblPrecioUrgencia, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}