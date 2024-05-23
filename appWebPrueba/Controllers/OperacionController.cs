using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daOperacion;
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
    public class OperacionController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Operacion()
        {
            OperacionVM model = new OperacionVM();
            return View(model);
        }

        public ActionResult getGridOperacion(OperacionVM model)
        {
            int OperacionID = 0;
            model.lGridOperacion = new List<GridOperacion>();
            model.lGridOperacion = daOperacion.getGridOperacion(OperacionID);
            return PartialView("../Operacion/_ListaOperacion", model);
        }

        public ActionResult getGridOperacionesActivasCompleta(OperacionVM model)
        {
            int OperacionID = 0;
            model.lGridOperacion = new List<GridOperacion>();
            model.lGridOperacion = daOperacion.getGridOperacionesActivasCompleta(OperacionID);
            return PartialView("../Operacion/_ListaOpsActivas", model);
        }

        public ActionResult getGridArticulosActivosCompleto(OperacionVM model)
        {
            int MaterialID = 0;
            model.lGridOperacion = new List<GridOperacion>();
            model.lGridOperacion = daOperacion.getGridArticulosActivosCompleto(MaterialID);
            return PartialView("../Operacion/_ListaArtsActivos", model);
        }

        public ActionResult getGridOperacionesXTipoTrabajo(int OperacionIDintTipoTrabajo)
        {
            OperacionVM model = new OperacionVM();

            //int TipoTrabajo = 0;
            model.lGridOperacion = new List<GridOperacion>();
            model.lGridOperacion = daOperacion.getGridOperacionesXTipoTrabajo(OperacionIDintTipoTrabajo);
            return PartialView("../Operacion/_ListaOpsXTipoTrabajo", model);
        }

        public ActionResult getGridMaterialXOperacionTipoTrabajo(int intOperacionTipoTrabajo)
        {
            OperacionVM model = new OperacionVM();

            //int TipoTrabajo = 0;
            model.lGridOperacion = new List<GridOperacion>();
            model.lGridOperacion = daOperacion.getGridMaterialXOperacionTipoTrabajo(intOperacionTipoTrabajo);
            return PartialView("../Operacion/_ListaMaterialXOperacionTipoTrabajo", model);
        }


        [HttpPost]
        public string EliminarOperacion(int OperacionID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daOperacion.EliminarOperacion(OperacionID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public string EliminarOperacionXTipoTrabajo(int intOperacionID, int intTipoTrabajoID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daOperacion.EliminarOperacionXTipoTrabajo(intOperacionID, intTipoTrabajoID, user);
            return JsonConvert.SerializeObject(res);
        }


        [HttpPost]
        public string EliminaMaterialnXTipoTrabajo(int intOperacionXTipoTrabajoID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daOperacion.EliminaMaterialnXTipoTrabajo(intOperacionXTipoTrabajoID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            OperacionVM operacion = new OperacionVM();
            return PartialView("../Operacion/Create", operacion);
        }

        [HttpPost]
        public string GuardarOperacion(string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daOperacion.GuardarOperacion(Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public string AgregaOperacionXTipoTrabajo(int intOperacion, int intTipoTrabajo, string TypeOer)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();

            res = daOperacion.AgregaOperacionXTipoTrabajo(intOperacion, intTipoTrabajo, TypeOer, user);
            return JsonConvert.SerializeObject(res);
        }


        [HttpPost]
        public string AgregaMaterialXOperacionTipoTrabajo(int intOperacionXTipoTrabajo, int intArticulo, decimal dblCantidad)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();

            res = daOperacion.AgregaMaterialXOperacionTipoTrabajo(intOperacionXTipoTrabajo, intArticulo, dblCantidad, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public string MoverOperacionXTipoTrabajo(int intOperacion, int intTipoTrabajo, bool bitSubirOperacion)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();

            res = daOperacion.MoverOperacionXTipoTrabajo(intOperacion, intTipoTrabajo, bitSubirOperacion, user);
            return JsonConvert.SerializeObject(res);
        }


        [HttpPost]
        public ActionResult EditarOperacion(int OperacionID)
        {
            OperacionVM operacion = new OperacionVM();
            operacion = daOperacion.EditarOperacion(OperacionID);
            return PartialView("../Operacion/Edit", operacion);
        }

        [HttpPost]
        public string GuardaEditOperacion(int OperacionID, string Nombre, string NombreCorto, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daOperacion.GuardaEditOperacion(OperacionID, Nombre, NombreCorto, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}