using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IECHClinic.Controllers
{
    public class HomeController : Controller
    {
        //En este controlador solo usaremos el método de Contact, realmente no teníamos porque, pero como lo dejamos en una opción para que no se viera el menú tan vacío pues hay que llenarlo con algo :)
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        //El método CONTACT devuelve la vista, esta la llenamos con texto solo para mostrar
        public ActionResult Contact()
        {
            ViewBag.Message = "Pagina Vacía.";

            return View();
        }
    }
}