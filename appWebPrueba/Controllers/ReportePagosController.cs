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
        //Instanciamos al Claim que tiene las ariables de sesión
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;
        // GET: ReportePagos
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult ReportePagos()
        {
            //Este método nos trae la lista de meses y carga la vista principal
            //Instanciamos el modelo de Reporte de PAgos
            ReportePagosVM reportePagos = new ReportePagosVM();
            //Instanciamos el mes
            reportePagos.MesP = new MesP();
            //Llenamos la lista de meses con el siguiente método
            reportePagos.lMesP = daReportePagos.GetListaMeses();
            //Con este modelo lleno mandamos mostrar la vista
            return View(reportePagos);
        }

        //Este método lo usamos para llenar el listado de pagos por mes, solo necesitamos el mes para mostrarlo
        public ActionResult getGridPagos(int intMes)
        {
            //Instanciamos el modelo de ReportePagos
            ReportePagosVM model = new ReportePagosVM();
            //El empleado se manda en valor "0"
            int intEmpleado = 0;
            //Cargamos los pagos  instanciando al Grid
            model.lGridPagos = new List<GridPagos>();
            //Lo llenamos con el siguiente método
            model.lGridPagos = daReportePagos.getGridReportePagos(intMes, intEmpleado);
            //el modelo una vez llenado se lo pasamos a la vista, la cual lo mostrará en pantalla
            return PartialView("../ReportePagos/_ListaPagos", model);
        }
    }
}