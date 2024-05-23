using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daProduction;
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
    public class ProductionController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }



        [HttpGet]
        public ActionResult YesoOperacion()
        {
            return View();
        }

        [HttpGet]
        public ActionResult FabricacionXOperacion()
        {
            return View();
        }

        public ActionResult getReporteProductividadXHora_Grafico(string Usuario, DateTime FechaIni, DateTime FechaFin, int TipoRegistro, int TipoDato, string strLinea)
        {
            if (Usuario == "BUSCAR_Actual")
            {
                Usuario = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            }


            string UsuarioConsulta = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();

            ProductionVM model = new ProductionVM();

            model.lGraficaXHora = new List<GraficaXHora>();
            model.lGraficaXHora = daProduction.getReporteProductividadXHora_Grafico(Usuario, FechaIni, FechaFin, TipoRegistro, TipoDato, UsuarioConsulta, strLinea);

            return PartialView("../Reportes/_GraficoReportesXHora", model);
        }

        public ActionResult LlenarTotales_Yesos(string strDepartamento)
        {
            ProductionVM model = new ProductionVM();

            string Usuario = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();

            DateTime datFecha = DateTime.Now;

            model.lGridResumenProduccion = new List<GridResumenProduccion>();
            model.lGridResumenProduccion = daProduction.getResumenUsuarioXTurno(datFecha, Usuario, strDepartamento);

            return PartialView("../Shared/Production/_TotalesXUsuario", model);
        }

        [HttpGet]
        public ActionResult CargarPendientesYesos()
        {
            string UsuarioId = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();

            ProductionVM model = new ProductionVM();
            model.lPendientes = new List<JobDetail>();
            model.lPendientes = daProduction.getJobsPendientesYesos(UsuarioId);
            return PartialView("../Shared/Production/_ListaPendientes_Yesos", model);
        }


        [HttpPost]
        public string RegistraOperacionJOB(string JobNum, int Operacion)
        {
            string UsuarioId = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string Job = JobNum;

            Resultado res = new Resultado();
            res = daProduction.RegistraOperacionJOB(JobNum, Operacion, UsuarioId);
            return JsonConvert.SerializeObject(res);
        }


    }
}