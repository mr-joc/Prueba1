using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daDoctor;
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
    public class DoctorController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Doctor()
        {
            DoctorVM model = new DoctorVM();
            return View(model);
        }

        public ActionResult getGridDoctor(DoctorVM model)
        {
            int DoctorID = 0;
            model.lGridDoctor = new List<GridDoctor>();
            model.lGridDoctor = daDoctor.getGridDoctor(DoctorID);
            return PartialView("../Doctor/_ListaDoctor", model);
        }

        [HttpPost]
        public string EliminarDoctor(int DoctorID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daDoctor.EliminarDoctor(DoctorID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            DoctorVM doctor = new DoctorVM();
            return PartialView("../Doctor/Create", doctor);
        }

        [HttpPost]
        public string GuardarDoctor(string strNombre, string strApPaterno, string strApMaterno, string strDireccion, string strEMail, string strColonia, string strRFC, string strNombreFiscal, int intCP, string strTelefono, string strCelular, string strDireccionFiscal, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daDoctor.GuardarDoctor(strNombre, strApPaterno, strApMaterno, strDireccion, strEMail, strColonia, strRFC, strNombreFiscal, intCP, strTelefono, strCelular, strDireccionFiscal, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarDoctor(int DoctorID)
        {
            DoctorVM doctor = new DoctorVM();
            doctor = daDoctor.EditarDoctor(DoctorID);
            return PartialView("../Doctor/Edit", doctor);
        }

        [HttpPost]
        public string GuardaEditDoctor(int DoctorID, string strNombre, string strApPaterno, string strApMaterno, string strDireccion, string strEMail, string strColonia, string strRFC, string strNombreFiscal, int intCP, string strTelefono, string strCelular, string strDireccionFiscal, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daDoctor.GuardaEditDoctor(DoctorID, strNombre, strApPaterno, strApMaterno, strDireccion, strEMail, strColonia, strRFC, strNombreFiscal, intCP, strTelefono, strCelular, strDireccionFiscal, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}