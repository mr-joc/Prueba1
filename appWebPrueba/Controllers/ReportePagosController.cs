using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daReportePagos;
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
    //Este controlador se usa para el rporte de pagos por mes
    public class ReportePagosController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;
        // GET: ReportePagos
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult ReportePagos()
        {
            ReportePagosVM reportePagos = new ReportePagosVM();
            reportePagos.MesP = new MesP();
            reportePagos.lMesP = daReportePagos.GetListaMeses();
            return View(reportePagos);
        }

        public ActionResult getGridPagos(int intMes)
        {
            ReportePagosVM model = new ReportePagosVM();
            int intEmpleado = 0;

            model.lGridPagos = new List<GridPagos>();
            model.lGridPagos = daReportePagos.getGridReportePagos(intMes, intEmpleado);


            return PartialView("../ReportePagos/_ListaPagos", model);
        }
    }
}