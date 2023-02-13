using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daMovimiento;
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
    public class MovimientoController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        // GET: Movimiento
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Movimiento()
        {
            MovimientoVM model = new MovimientoVM();
            return View(model);
        }

        //////public ActionResult getGridMovimiento(MovimientoVM model)
        //////{
        //////    int MovimientoID = 0;

        //////    model.lGridMovimiento = new List<GridMovimiento>();
        //////    model.lGridMovimiento = daMovimiento.getGridMovimiento(MovimientoID);


        //////    return PartialView("../Movimiento/_ListaMovimientos", model);
        //////}

        //////[HttpPost]
        //////public string EliminarMovimiento(int MovimientoID)
        //////{
        //////    string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
        //////    Resultado res = new Resultado();
        //////    res = daMovimiento.EliminarMovimiento(MovimientoID, user);
        //////    return JsonConvert.SerializeObject(res);
        //////}

        [HttpPost]
        public ActionResult Create()
        {
            MovimientoVM movimiento = new MovimientoVM();
            movimiento.Rol_a = new Rol_a();
            movimiento.lRol_a = daMovimiento.GetListaRoles();
            movimiento.Mes = new Mes();
            movimiento.lMes = daMovimiento.GetListaMeses();

            return PartialView("../Movimiento/Create", movimiento);
        }

        [HttpPost]
        public string GuardarMovimientoXMes(int intNumEmpleado, int intMes, int intCantidadEntregas)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daMovimiento.GuardarMovimientoXMes(intNumEmpleado, intMes, intCantidadEntregas, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult BuscarDatosEmpleado(int intNumEmpleado)
        {
            MovimientoVM movimiento = new MovimientoVM();
            movimiento = daMovimiento.BuscaEmpleado(intNumEmpleado);
            movimiento.Rol_a = new Rol_a();
            movimiento.lRol_a = daMovimiento.GetListaRoles();
            movimiento.Mes = new Mes();
            movimiento.lMes = daMovimiento.GetListaMeses();
            return PartialView("../Movimiento/Create", movimiento);
        }

        ////[HttpPost]
        ////public ActionResult EditarMovimiento(int MovimientoID)
        ////{
        ////    MovimientoVM movimiento = new MovimientoVM();
        ////    movimiento = daMovimiento.EditarMovimiento(MovimientoID);
        ////    movimiento.lRol = daMovimiento.GetListaRoles();
        ////    return PartialView("../Movimiento/Edit", movimiento);
        ////}

        ////[HttpPost]
        ////public string GuardaEditMovimiento(int MovimientoID, string Nombres, string ApPaterno, string ApMaterno, int NumMovimiento, int Rol, int Activo)
        ////{
        ////    string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
        ////    string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();

        ////    Resultado res = new Resultado();
        ////    bool Estado = (Activo == 0 ? false : true);

        ////    res = daMovimiento.GuardaEditMovimiento(MovimientoID, Nombres, ApPaterno, ApMaterno, NumMovimiento, Rol, Estado, user);
        ////    return JsonConvert.SerializeObject(res);
        ////}

    }
}