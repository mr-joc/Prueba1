using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.DataAccess.daAdministrarMenu;
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
    public class AdministrarMenuController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        public ActionResult Index()
        {
            return View();
        }

        //Aquí mandamos llamar la vista
        public ActionResult AdministrarMenu()
        {

            //UsuarioVM usuario = new UsuarioVM();
            AdministrarMenuVM model = new AdministrarMenuVM();

            model.PerfilAdmin= new PerfilAdmin();
            //Para ello usamos el método que nos devuelve la lista de Roles ACTIVOS
            model.lPerfilAdmin = daAdministrarMenu.GetListaRoles();
            return View(model);
        }


        //Este método sirve para llenar el listado, en el listado podemos visualizar los datos, además de tener los botones de ELIMINAR y EDITAR
        public ActionResult getGridAdministrarMenu(int InternalID, int intRol)
        {
            AdministrarMenuVM model = new AdministrarMenuVM();
            //Instanciamos el modelo 
            model.lGridAdministrarMenu = new List<GridAdministrarMenu>();
            //Lo llenamos con lo que devuelva "getGridUsuario"
            model.lGridAdministrarMenu = daAdministrarMenu.getGridAdministrarMenu(InternalID, intRol);
            //y retornamos la vista parcial con su listado
            return PartialView("../AdministrarMenu/_ListarMenu1", model);
        }


        //Este método es para guardar un usuario nuevo, no necesitamos el ID porque nos lo asigna la BD
        [HttpPost]
        public string AgregaPermisosPerfil(int intMenuReal, string strDesgloseMenu, int Perfil)
        {
            //Asignamos el usuario que está logueado
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daAdministrarMenu.agregaPermisosPerfil(intMenuReal, strDesgloseMenu, Perfil, user);
            return JsonConvert.SerializeObject(res);
        }

        //Podemos eliminar usuarios, esto se hace de manera lógica, de tal modo que solo contamos con una columna que nos dice si está o no "eliminado" y los excluye de cualquier SP
        [HttpPost]
        public string EliminarMenuUnico(int intMenuElimina, int intPerfil)
        {
            //Recibimos el Id del usuario
            //Usando los Claim averiguamos quien es el usuario que está logueado en el sistema y lo declararemos para mandarlo al SP, este se inserta en los campos de audotoría
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado
            Resultado res = new Resultado();
            //le asignamos la respuesta que nos devuelva el método "EliminarUsuario"
            res = daAdministrarMenu.eliminarMenuUnico(intMenuElimina, intPerfil, user);
            //Devolvemos el JSON a la vista principal
            return JsonConvert.SerializeObject(res);
        }

        //Podemos eliminar usuarios, esto se hace de manera lógica, de tal modo que solo contamos con una columna que nos dice si está o no "eliminado" y los excluye de cualquier SP
        [HttpPost]
        public string LimpiarPermisosEspeciales(int intMenuElimina, int intPerfil)
        {
            //Recibimos el Id del usuario
            //Usando los Claim averiguamos quien es el usuario que está logueado en el sistema y lo declararemos para mandarlo al SP, este se inserta en los campos de audotoría
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado
            Resultado res = new Resultado();
            //le asignamos la respuesta que nos devuelva el método "EliminarUsuario"
            res = daAdministrarMenu.eliminarMenuUnico(intMenuElimina, intPerfil, user);
            //Devolvemos el JSON a la vista principal
            return JsonConvert.SerializeObject(res);
        }

    }
}