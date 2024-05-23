using Newtonsoft.Json;
using IECHClinic.Clases;
using IECHClinic.DataAccess.daUsuario;
using IECHClinic.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security.Claims;
using System.Threading;
using IECHClinic.DataAccess.daAdministrarMenu;

namespace IECHClinic.Controllers
{
    public class UsuarioController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        // GET: Usuario
        public ActionResult Index()
        {
            return View();
        }
        //Aquí mandamos llamar la vista
        public ActionResult Usuario()
        {
            UsuarioVM model = new UsuarioVM();
            return View(model);
        }
        public ActionResult CambiarPassWord()
        {
            UsuarioVM model = new UsuarioVM();
            return View(model);
        }
        

        //Este método sirve para llenar el listado, en el listado podemos visualizar los datos, además de tener los botones de ELIMINAR y EDITAR
        public ActionResult getGridUsuario(UsuarioVM model)
        {
            //Declaramos la variable "UsuarioID" en 0, este es un truco para traer TODOS o solo un usuario en particular
            int UsuarioID = 0;
            //Instanciamos el modelo 
            model.lGridUsuario = new List<GridUsuario>();
            //Lo llenamos con lo que devuelva "getGridUsuario"
            model.lGridUsuario = daUsuario.getGridUsuario(UsuarioID);
            //y retornamos la vista parcial con su listado
            return PartialView("../Usuario/_ListaUsuarios", model);
        }

        //Podemos eliminar usuarios, esto se hace de manera lógica, de tal modo que solo contamos con una columna que nos dice si está o no "eliminado" y los excluye de cualquier SP
        [HttpPost]
        public string EliminarUsuario(int UsuarioID)
        {
            //Recibimos el Id del usuario
            //Usando los Claim averiguamos quien es el usuario que está logueado en el sistema y lo declararemos para mandarlo al SP, este se inserta en los campos de audotoría
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado
            Resultado res = new Resultado();
            //le asignamos la respuesta que nos devuelva el método "EliminarUsuario"
            res = daUsuario.EliminarUsuario(UsuarioID, user);
            //Devolvemos el JSON a la vista principal
            return JsonConvert.SerializeObject(res);
        }

        //Para crear un nuevo Usuario, lo primero que haremos es llamar a este método
        [HttpPost]
        public ActionResult Create()
        {
            //Instanciamos el modelo
            UsuarioVM usuario = new UsuarioVM();
            //Llenamos el listado de roles y se lo agregamos a la respuesta
            usuario.Perfil = new Perfil();
            //Para ello usamos el método que nos devuelve la lista de Roles ACTIVOS
            usuario.lPerfil = daUsuario.GetListaRoles();
            //Y devolvemos la vista para crear (esta lleva los controles y botones necesarios para operarla
            return PartialView("../Usuario/Create", usuario);
        }

        //Este método es para guardar un usuario nuevo, no necesitamos el ID porque nos lo asigna la BD
        [HttpPost]
        public string GuardarUsuario(string ClaveUsuario, string Nombres, string ApPaterno, string ApMaterno, string Password, int Rol, int Activo)
        {
            //Asignamos el usuario que está logueado
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado
            Resultado res = new Resultado();
            //como tenemos una variable llamada "Activo" y es del tipo INT, la convertimos a boleana con la siguiente línea
            bool Estado = (Activo == 0 ? false : true);
            //Llamamos al siguiente mpetodo y le asignamos la respuesta al resultado
            res = daUsuario.GuardarUsuario(ClaveUsuario, Nombres, ApPaterno, ApMaterno, Password, Rol, Estado, user);
            //Devolvemos el resultado a la vista, en caso de que haya error en la BD se va a mostrar en la pantalla del usuario, por lo cual debemos tener cuidado de usar un lenguaje más amigable
            return JsonConvert.SerializeObject(res);
        }

        //Para editar un usuario, lo primero que haremos es llenar una vista parcial con sus datos
        //Recibimos el ID del usuario
        [HttpPost]
        public ActionResult EditarUsuario(int UsuarioID)
        {
            //Istanciamos el modelo de Usuario
            UsuarioVM usuario = new UsuarioVM();
            //Llamamos al siguiente método para traer los valores que tiene guardados
            usuario = daUsuario.EditarUsuario(UsuarioID);
            //También llenamos la lista de roles para asignarlo al combo
            usuario.lPerfil = daUsuario.GetListaRoles();
            //Devolvemos el modelo de usuario a la vista parcial 
            return PartialView("../Usuario/Edit", usuario);
        }

        //Este método sirve para Editar un usuario, mismo que ya tenemos cargado en la vista, por ser un EDIT, se necesita a fuerza el ID de usuario para editar solo ese en particular
        [HttpPost]
        public string GuardaEditUsuario(int UsuarioID, string ClaveUsuario, string Nombres, string ApPaterno, string ApMaterno, string Password, int Rol, int Activo)
        {
            //Asignamos el usuario que está logueado en el sistema
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Tambien cargamos el Id del usuario.... creo que no lo necesitaba pero ya está ahí y mejor lo dejo
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado
            Resultado res = new Resultado();
            //Asignamos ACTIVO para cambiar por un booleano que mandaremos al siguiente método
            bool Estado = (Activo == 0 ? false : true);
            //Llamamos al método y asignamos la respuesta
            res = daUsuario.GuardaEditUsuario(UsuarioID, ClaveUsuario, Nombres, ApPaterno, ApMaterno, Password, Rol, Estado, user);
            //Devolvemos la respuesta a la vista, en caso de error la misma vista lo mostrará 
            return JsonConvert.SerializeObject(res);
        }

        //Este método sirve para Editar un usuario, mismo que ya tenemos cargado en la vista, por ser un EDIT, se necesita a fuerza el ID de usuario para editar solo ese en particular
        [HttpPost]
        public string ActualizaPass(string strPassActual, string strNewPass1, string strNewPass2)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            string userInternalID = identity.Claims.Where(c => c.Type == ClaimTypes.SerialNumber).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daUsuario.actualizaPass(strPassActual, strNewPass1, strNewPass2, user);
            return JsonConvert.SerializeObject(res);
        }


        //Este método es para guardar un usuario nuevo, no necesitamos el ID porque nos lo asigna la BD
        [HttpPost]
        public string AgregarMenu_X_Usuario(int intMenuReal, string strDesgloseMenu, int intUsuarioAccede)
        {
            //Asignamos el usuario que está logueado
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daUsuario.agregaMenu_X_Usuario(intMenuReal, strDesgloseMenu, intUsuarioAccede, user);
            return JsonConvert.SerializeObject(res);
        }

        //Podemos eliminar usuarios, esto se hace de manera lógica, de tal modo que solo contamos con una columna que nos dice si está o no "eliminado" y los excluye de cualquier SP
        [HttpPost]
        public string RestringirMenu_X_Usuario(int intMenuRestringe, int intUsuarioID)
        {
            //Recibimos el Id del usuario
            //Usando los Claim averiguamos quien es el usuario que está logueado en el sistema y lo declararemos para mandarlo al SP, este se inserta en los campos de audotoría
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            //Instanciamos el resultado
            Resultado res = new Resultado();
            //le asignamos la respuesta que nos devuelva el método "EliminarUsuario"
            res = daUsuario.restringeMenu_X_Usuario(intMenuRestringe, intUsuarioID, user);
            //Devolvemos el JSON a la vista principal
            return JsonConvert.SerializeObject(res);
        }

        [HttpPost]
        public string LimpiarPermisosEspeciales_XUsuario(int intUsuarioID)
        {
            string user = identity.Claims.Where(c => c.Type == ClaimTypes.NameIdentifier).Select(c => c.Value).SingleOrDefault();
            Resultado res = new Resultado();
            res = daUsuario.limpiarPermisosEspeciales_XUsuario(intUsuarioID, user);
            return JsonConvert.SerializeObject(res);
        }

    }
}