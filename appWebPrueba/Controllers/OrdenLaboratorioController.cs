using System;
using System.Web;
using System.Collections.Generic;
using appWebPrueba.Models;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daOrdenLaboratorio;
using System.Linq;
using System.Web.Mvc;
using System.Security.Claims;
using System.Threading;
using Newtonsoft.Json;

namespace appWebPrueba.Controllers
{
    public class OrdenLaboratorioController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        // GET: OrdenLaboratorio
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult OrdenLaboratorio()
        {
            OrdenLaboratorioVM model = new OrdenLaboratorioVM();


            model.Doctores = new Doctores();
            model.lDoctores = daOrdenLaboratorio.GetDoctoresActivos();
            model.Protesis = new Protesis();
            model.lProtesis = daOrdenLaboratorio.GetProtesis();
            model.MaterialesORD = new MaterialesORD();
            model.lMaterialesORD = daOrdenLaboratorio.GetListaMateriales();
            model.TrabXMatORD = new TrabXMatORD();
            model.lTrabXMatORD = new List<TrabXMatORD>();

            model.datFechaElabora = DateTime.Now;
            return View(model);
        }
        public ActionResult adminOrdenLab()
        {
            OrdenLaboratorioVM model = new OrdenLaboratorioVM();
            model.Doctores = new Doctores();
            model.lDoctores = daOrdenLaboratorio.GetDoctoresActivos();
            model.Protesis = new Protesis();
            model.lProtesis = daOrdenLaboratorio.GetProtesis();
            model.ProcesoXProtesis = new ProcesoXProtesis();
            model.lProcesoXProtesis = new List<ProcesoXProtesis>();
            return View(model);
        }
        


        [HttpPost]
        public ActionResult Create()
        {
            OrdenLaboratorioVM ordenLaboratorio = new OrdenLaboratorioVM();
            ordenLaboratorio.datFechaElabora = DateTime.Now;
            ordenLaboratorio.Colorimetros = new Colorimetros();
            ordenLaboratorio.lColorimetros = daOrdenLaboratorio.GetColorimetros();
            ordenLaboratorio.ColoresXCol = new ColoresXCol();
            ordenLaboratorio.lColoresXCol = new List<ColoresXCol>();
            ordenLaboratorio.Doctores = new Doctores();
            ordenLaboratorio.lDoctores = daOrdenLaboratorio.GetDoctoresActivos();
            ordenLaboratorio.Protesis = new Protesis();
            ordenLaboratorio.lProtesis = daOrdenLaboratorio.GetProtesis();
            ordenLaboratorio.ProcesoXProtesis = new ProcesoXProtesis();
            ordenLaboratorio.lProcesoXProtesis = new List<ProcesoXProtesis>();


            ordenLaboratorio.MaterialesORD = new MaterialesORD();
            ordenLaboratorio.lMaterialesORD = daOrdenLaboratorio.GetListaMateriales();
            ordenLaboratorio.TrabXMatORD = new TrabXMatORD();
            ordenLaboratorio.lTrabXMatORD = new List<TrabXMatORD>();

            return PartialView("../OrdenLaboratorio/Create", ordenLaboratorio);
        }        

        [HttpPost]
        public ActionResult EditarOrdenLab(int intOrdenLab)
        {
            OrdenLaboratorioVM ordenLab = new OrdenLaboratorioVM();
            ordenLab = daOrdenLaboratorio.EditarOrdenLab(intOrdenLab);
            ordenLab.lDoctores = daOrdenLaboratorio.GetDoctoresActivos();
            ordenLab.lColorimetros = daOrdenLaboratorio.GetColorimetros();
            ordenLab.lColoresXCol = new List<ColoresXCol>();
            ordenLab.lProtesis = daOrdenLaboratorio.GetProtesis();
            ordenLab.lProcesoXProtesis = new List<ProcesoXProtesis>();
            ordenLab.lMaterialesORD = daOrdenLaboratorio.GetListaMateriales();
            ordenLab.lTrabXMatORD = new List<TrabXMatORD>();

            return PartialView("../OrdenLaboratorio/Edit", ordenLab);
        }


        [HttpPost]
        public ActionResult EditarOrdenLab_SoloVista(int intOrdenLab)
        {
            OrdenLaboratorioVM ordenLab = new OrdenLaboratorioVM();
            ordenLab = daOrdenLaboratorio.EditarOrdenLab(intOrdenLab);
            ordenLab.lDoctores = daOrdenLaboratorio.GetDoctoresActivos();
            ordenLab.lColorimetros = daOrdenLaboratorio.GetColorimetros();
            ordenLab.lColoresXCol = new List<ColoresXCol>();
            ordenLab.lProtesis = daOrdenLaboratorio.GetProtesis();
            ordenLab.lProcesoXProtesis = new List<ProcesoXProtesis>();
            ordenLab.lMaterialesORD = daOrdenLaboratorio.GetListaMateriales();
            ordenLab.lTrabXMatORD = new List<TrabXMatORD>();

            return PartialView("../OrdenLaboratorio/Edit_SoloVista", ordenLab);
        }


        [HttpPost]
        public ActionResult getInfoGeneral_Enc(int intOrdenLab, int intTipoInfo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();

            OrdenLaboratorioVM ordenLab = new OrdenLaboratorioVM();
            ordenLab = daOrdenLaboratorio.getInfoGeneral_Enc(intOrdenLab, intTipoInfo, user);
            ordenLab.intTipoDatoMuestra = intTipoInfo;
            //ordenLab.lDoctores = daOrdenLaboratorio.GetDoctoresActivos();
            //ordenLab.lColorimetros = daOrdenLaboratorio.GetColorimetros();
            //ordenLab.lColoresXCol = new List<ColoresXCol>();
            //ordenLab.lProtesis = daOrdenLaboratorio.GetProtesis();
            //ordenLab.lProcesoXProtesis = new List<ProcesoXProtesis>();
            //ordenLab.lMaterialesORD = daOrdenLaboratorio.GetListaMateriales();
            //ordenLab.lTrabXMatORD = new List<TrabXMatORD>();
            switch (intTipoInfo)
            {
                case 1:
                    return PartialView("../OrdenLaboratorio/_EncabezadoGeneral", ordenLab);
                    break;
                case 2:
                    return PartialView("../OrdenLaboratorio/_EncabezadoGeneral", ordenLab);
                    break;
                default:
                    return PartialView("../OrdenLaboratorio/Edit_SoloVista", ordenLab);
                    break;
            }
        }

        public ActionResult getInfoGeneral_Det(int intOrdenLaboratorioEnc, int intTipoInfo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();

            OrdenLaboratorioVM ordenLaboratorio = new OrdenLaboratorioVM();
            ordenLaboratorio.lGridOrdenLaboratorio = new List<GridOrdenLaboratorio>();
            ordenLaboratorio.lGridOrdenLaboratorio = daOrdenLaboratorio.getInfoGeneralDet(intOrdenLaboratorioEnc, intTipoInfo, user);
            ordenLaboratorio.intTipoDatoMuestra = intTipoInfo;
            switch (intTipoInfo)
            {
                case 1:
                    return PartialView("../OrdenLaboratorio/_DetalleGeneral_OrdenLab", ordenLaboratorio);
                    break;
                case 2:
                    return PartialView("../OrdenLaboratorio/_DetalleGeneral_OrdenLab", ordenLaboratorio);
                    break;
                default:
                    return PartialView("../OrdenLaboratorio/_DetalleOrdenLab_SoloVista", ordenLaboratorio);
                    break;
            }
        }

        
        [HttpPost]
        public string Guarda_EDIT_OrdenLab(int intOrdenLaboratorioEnc, int intDoctor, string strNombrePaciente, int intExpediente, int intFolioPago, decimal dblPrecio, int intTipoProtesis, decimal intPieza, int intProceso, int intTipoTrabajo, string strColor,
            string strComentario, string strObservaciones, int intEdad, int intSexo, int intGarantia, int intColor, int intFactura, DateTime datFechaEntrega, DateTime datFechaColocacion,
            int intColorimetro, int intUrgente, string strUsuario)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();

            bool btGarantia = (intGarantia == 0 ? false : true);
            bool btFactura = (intFactura == 0 ? false : true);
            bool btUrgente = (intUrgente == 0 ? false : true);

            res = daOrdenLaboratorio.Guarda_EDIT_OrdenLab(intOrdenLaboratorioEnc, intDoctor, strNombrePaciente, intExpediente, intFolioPago, dblPrecio, intTipoProtesis, intPieza, intProceso, intTipoTrabajo, strColor,
            strComentario, strObservaciones, intEdad, intSexo, btGarantia, intColor, btFactura, datFechaEntrega, datFechaColocacion,
            intColorimetro, btUrgente, user);

            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public string GuardarOrdenLab(int intDoctor, string strNombrePaciente, int intExpediente, int intFolioPago, decimal dblPrecio, int intTipoProtesis, decimal intPieza, int intProceso, int intTipoTrabajo, string strColor,
            string strComentario, string strObservaciones, int intEdad, int intSexo, int intGarantia, int intColor, int intFactura, DateTime datFechaEntrega, DateTime datFechaColocacion,
            int intColorimetro, int intUrgente, string strUsuario)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();

            bool btGarantia = (intGarantia == 0 ? false : true);
            bool btFactura = (intFactura == 0 ? false : true);
            bool btUrgente = (intUrgente == 0 ? false : true);

            res = daOrdenLaboratorio.GuardarOrdenLab(intDoctor, strNombrePaciente, intExpediente, intFolioPago, dblPrecio, intTipoProtesis, intPieza, intProceso, intTipoTrabajo, strColor,
            strComentario, strObservaciones, intEdad, intSexo, btGarantia, intColor, btFactura, datFechaEntrega, datFechaColocacion,
            intColorimetro, btUrgente, user);

            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public string GenerarOrdenTrabajoXOrdenEnc_APP(int intOrdenLaboratorioEnc)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();


            res = daOrdenLaboratorio.GenerarOrdenTrabajoXOrdenEnc_APP(intOrdenLaboratorioEnc, user);

            return JsonConvert.SerializeObject(res);
        }



        [HttpPost]
        public string AutorizarFabricacionOrden(int intOrdenLaboratorioEnc)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();


            res = daOrdenLaboratorio.AutorizarFabricacionOrden(intOrdenLaboratorioEnc, user);

            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public string AbonoTrabajo_App(int intOrdenLaboratorioEnc, decimal dblMontoPago)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();


            res = daOrdenLaboratorio.AbonoTrabajo_App(intOrdenLaboratorioEnc, dblMontoPago, user);

            return JsonConvert.SerializeObject(res);
        }


        [HttpPost]
        public string EliminarOrdenLaboratorioDet(int OrdenLaboratorioDet)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daOrdenLaboratorio.EliminarOrdenLaboratorioDet(OrdenLaboratorioDet, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public string OrdenLaboratorioDet_V2_App(int intOrdenLaboratorioEnc, string intPieza, int intMaterial, int intTipoTrabajo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
             

            res = daOrdenLaboratorio.OrdenLaboratorioDet_V2_App(intOrdenLaboratorioEnc, intPieza, intMaterial, intTipoTrabajo, user);

            return JsonConvert.SerializeObject(res);
        }

        public ActionResult getGridOrdenLab(string User, int intDoctor, int intProtesis, int intProceso, int intOrden, string strPaciente)
        {
            string Usuario2 = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();

            AdministrarMenuVM model = new AdministrarMenuVM();
            OrdenLaboratorioVM ordenLaboratorio = new OrdenLaboratorioVM();
            ordenLaboratorio.lGridOrdenLaboratorio = new List<GridOrdenLaboratorio>();
            ordenLaboratorio.lGridOrdenLaboratorio = daOrdenLaboratorio.getGridOrdenLab(Usuario2, intDoctor, intProtesis, intProceso, intOrden, strPaciente);
            return PartialView("../OrdenLaboratorio/_listarOrdenesLab", ordenLaboratorio);
        }

        public ActionResult getDetalleOrdenLab(int intOrdenLaboratorioEnc)
        {
            OrdenLaboratorioVM ordenLaboratorio = new OrdenLaboratorioVM();
            ordenLaboratorio.lGridOrdenLaboratorio = new List<GridOrdenLaboratorio>();
            ordenLaboratorio.lGridOrdenLaboratorio = daOrdenLaboratorio.getDetalleOrdenLab(intOrdenLaboratorioEnc);
            return PartialView("../OrdenLaboratorio/_DetalleOrdenLab", ordenLaboratorio);
        }

        public ActionResult getDetalleOrdenLab_SoloVista(int intOrdenLaboratorioEnc)
        {
            OrdenLaboratorioVM ordenLaboratorio = new OrdenLaboratorioVM();
            ordenLaboratorio.lGridOrdenLaboratorio = new List<GridOrdenLaboratorio>();
            ordenLaboratorio.lGridOrdenLaboratorio = daOrdenLaboratorio.getDetalleOrdenLab(intOrdenLaboratorioEnc);
            return PartialView("../OrdenLaboratorio/_DetalleOrdenLab_SoloVista", ordenLaboratorio);
        }

        [HttpPost]
        public string GetcoloresXColorimetro(int colorimetro)
        {
            List<ColoresXCol> coloresXColorimetro = new List<ColoresXCol>();
            coloresXColorimetro = daOrdenLaboratorio.GetcoloresXColorimetro(colorimetro);

            return JsonConvert.SerializeObject(coloresXColorimetro);

        }

        [HttpPost]
        public string GetProcesosXProtesis(int protesis)
        {
            List<ProcesoXProtesis> procesoXProtesis = new List<ProcesoXProtesis>();
            procesoXProtesis = daOrdenLaboratorio.GetProcInicialesXProtesis(protesis);

            return JsonConvert.SerializeObject(procesoXProtesis);

        }

        public ActionResult getAyudaOrdenLab(int FolioBusca, int intDoctor, int intTipoProtesis)
        {
            AdministrarMenuVM model = new AdministrarMenuVM();
            OrdenLaboratorioVM ordenLaboratorio = new OrdenLaboratorioVM();

            ordenLaboratorio.Doctores = new Doctores();
            ordenLaboratorio.lDoctores = daOrdenLaboratorio.GetDoctoresActivos();
            ordenLaboratorio.ProcesoXProtesis = new ProcesoXProtesis();
            ordenLaboratorio.lProcesoXProtesis = new List<ProcesoXProtesis>();

            ordenLaboratorio.lGridOrdenLaboratorio = new List<GridOrdenLaboratorio>();
            ordenLaboratorio.lGridOrdenLaboratorio = daOrdenLaboratorio.getAyudaOrdenLab(FolioBusca, intDoctor, intTipoProtesis);
            return PartialView("../OrdenLaboratorio/_AyudaOrdenesLab", ordenLaboratorio);
        }

        public ActionResult getOrdenLabDet(int OrdenLaboratorioEnc)
        {
            AdministrarMenuVM model = new AdministrarMenuVM();
            OrdenLaboratorioVM ordenLaboratorio = new OrdenLaboratorioVM();

            ordenLaboratorio.MaterialesORD = new MaterialesORD();
            ordenLaboratorio.lMaterialesORD = daOrdenLaboratorio.GetListaMateriales();
            ordenLaboratorio.TrabXMatORD = new TrabXMatORD();
            ordenLaboratorio.lTrabXMatORD = new List<TrabXMatORD>();

            //ordenLaboratorio.lGridOrdenLaboratorio = new List<GridOrdenLaboratorio>();
            //ordenLaboratorio.lGridOrdenLaboratorio = daOrdenLaboratorio.getAyudaOrdenLab(FolioBusca, intDoctor, intTipoProtesis);
            return PartialView("../OrdenLaboratorio/_NuevoDetalleOrdenLab", ordenLaboratorio);
        }


        [HttpPost]
        public string GetTipoTrabajoXMaterial(int intMaterial)
        {
            List<TrabXMatORD> tipoTrabXMaterial = new List<TrabXMatORD>();
            tipoTrabXMaterial = daOrdenLaboratorio.GetTipoTrabajoActivosXMaterial(intMaterial);

            return JsonConvert.SerializeObject(tipoTrabXMaterial);

        }

    }
}