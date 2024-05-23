using System;
using System.Web;
using System.Collections.Generic;
using appWebPrueba.Models;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daOrdenLaboratorio;
using appWebPrueba.DataAccess.daReportes;
using System.Linq;
using System.Web.Mvc;
using System.Security.Claims;
using System.Threading;
using Newtonsoft.Json;

namespace appWebPrueba.Controllers
{
    public class ReportesController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        // GET: Reportes
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult AdeudosXDoctor()
        {
            ReportesVM model = new ReportesVM();
            model.DoctoresR = new DoctoresR();
            model.lDoctoresR = daReportes.GetDoctoresActivos();

            model.Pagado = new Pagado();
            model.lPagado = daReportes.getDataTrabajoPagado();

            return View(model);
        }


        public ActionResult getGridAdeudosDR(int intDoctor, int intPagado)
        {
            string Usuario2 = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();


            ReportesVM adeudosXDr = new ReportesVM();
            adeudosXDr.lGridAdeudosXDr = new List<GridAdeudosXDr>();
            adeudosXDr.lGridAdeudosXDr = daReportes.getGridAdeudosDR(intDoctor, intPagado, Usuario2);
            return PartialView("../Reportes/_listaAdeudosDR", adeudosXDr);
        }


    }
}