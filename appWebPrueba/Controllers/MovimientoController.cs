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
    //Este controlador nos sirve para cargar los movimientos mensuales, aquí debemos mandar el empleado y las entregas que está realizando por mes
    public class MovimientoController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        // GET: Movimiento
        public ActionResult Index()
        {
            return View();
        }
        //Devolvemos la vista de Movimiento
        public ActionResult Movimiento()
        {
            MovimientoVM model = new MovimientoVM();
            return View(model);
        }
        //Al cargar la vista, inmediatamente manda llamar a este mpetodo
        [HttpPost]
        public ActionResult Create()
        {
            //Instanciamos el modelo de MovimientoVM
            MovimientoVM movimiento = new MovimientoVM();
            //Instanciamos el modelo Rol_a (tiene una lista de ROLES
            movimiento.Rol_a = new Rol_a();
            //Llenamos el modelo con lo que te devuelva el siguiente método
            movimiento.lRol_a = daMovimiento.GetListaRoles();
            //Instanciamos el modelo de Mes
            movimiento.Mes = new Mes();
            //Lo llenamos con el siguiente método
            movimiento.lMes = daMovimiento.GetListaMeses();
            //El modelo ya cargado lo devolvemos en una vista Parcial
            return PartialView("../Movimiento/Create", movimiento);
        }

        //Este método guarda los movimiento por mes del empleado, 
        [HttpPost]
        public string GuardarMovimientoXMes(int intNumEmpleado, int intMes, int intCantidadEntregas)
        {
            //Asignamos el usuario que está logueado en el sistema
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos la clase de resultado
            Resultado res = new Resultado();
            //Llanamos el resultado usando el siguiente método
            res = daMovimiento.GuardarMovimientoXMes(intNumEmpleado, intMes, intCantidadEntregas, user);
            //Devolvemos la respuesta:
            //en caso de que haya error vamos a aprovechar para mostrarlo en pantalla, si no hay error, entonces mostramos el ID y un mensaje bastante genérico de lo que respondió l aBD
            return JsonConvert.SerializeObject(res);
        }

        //En la pantalla de Movimientos, necesitamos guardar los datos de entregas, mes y Empleado
        //Para hacer más amigable este movimiento solo colocaremos el número de Empleado y el sistema buscará los datos
        [HttpPost]
        public ActionResult BuscarDatosEmpleado(int intNumEmpleado)
        {
            //Instanciamos el modelo de Movimiento
            MovimientoVM movimiento = new MovimientoVM();
            //Buscamos los datos del empleado con el siguiente método
            movimiento = daMovimiento.BuscaEmpleado(intNumEmpleado);
            //Adjuntamos al modelo los roles
            movimiento.Rol_a = new Rol_a();
            //que obtenemos del siguoiente método
            movimiento.lRol_a = daMovimiento.GetListaRoles();
            //Adjuntamos al modelo la lista de meses para mostrarlo en su combo
            movimiento.Mes = new Mes();
            //Y lo obtenemos del siguiente método
            movimiento.lMes = daMovimiento.GetListaMeses();
            //Devolvemos el modelo a la vista para que se llenen los campos
            return PartialView("../Movimiento/Create", movimiento);
        }
    }
}