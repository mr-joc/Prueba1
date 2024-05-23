using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daArticulo;
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
    public class ArticuloController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Articulo()
        {
            ArticuloVM model = new ArticuloVM();
            return View(model);
        }

        public ActionResult getGridArticulo(ArticuloVM model)
        {
            int ArticuloID = 0;
            model.lGridArticulo = new List<GridArticulo>();
            model.lGridArticulo = daArticulo.getGridArticulo(ArticuloID);
            return PartialView("../Articulo/_ListaArticulo", model);
        }

        [HttpPost]
        public string EliminarArticulo(int ArticuloID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daArticulo.EliminarArticulo(ArticuloID, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult Create()
        {
            ArticuloVM articulo = new ArticuloVM();

            articulo.UnidadMedida = new UnidadMedida();
            articulo.Proveedor = new Proveedor();
            articulo.lProveedor = daArticulo.GetListaProveedor();
            articulo.lUnidadMedida = daArticulo.GetUnidadesMedida();
            return PartialView("../Articulo/Create", articulo);
        }

        [HttpPost]
        public string GuardarArticulo(string strPartNum, string strPartDesc, int intUnidadMedidaCompra, int intUnidadMedidaAlmacen, int intUnidadMedidaVenta, decimal dblConversion_Comp_Alm, decimal dblConversion_Alm_Vta, int intProveedorBase, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daArticulo.GuardarArticulo(strPartNum, strPartDesc, intUnidadMedidaCompra, intUnidadMedidaAlmacen, intUnidadMedidaVenta, dblConversion_Comp_Alm, dblConversion_Alm_Vta, intProveedorBase, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public ActionResult EditarArticulo(int ArticuloID)
        {
            ArticuloVM articulo = new ArticuloVM();
            articulo = daArticulo.EditarArticulo(ArticuloID);
            articulo.lProveedor = daArticulo.GetListaProveedor();
            articulo.lUnidadMedida = daArticulo.GetUnidadesMedida();
            return PartialView("../Articulo/Edit", articulo);
        }

        [HttpPost]
        public string GuardaEditArticulo(int ArticuloID, string strPartNum, string strPartDesc, int intUnidadMedidaCompra, int intUnidadMedidaAlmacen, int intUnidadMedidaVenta, decimal dblConversion_Comp_Alm, decimal dblConversion_Alm_Vta, int intProveedorBase, int Activo)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            bool Estado = (Activo == 0 ? false : true);
            res = daArticulo.GuardaEditArticulo(ArticuloID, strPartNum, strPartDesc, intUnidadMedidaCompra, intUnidadMedidaAlmacen, intUnidadMedidaVenta, dblConversion_Comp_Alm, dblConversion_Alm_Vta, intProveedorBase, Estado, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}