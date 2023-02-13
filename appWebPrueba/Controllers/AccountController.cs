using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Security.Claims;
using System.Threading;
using System.Data;
using System.Text.RegularExpressions;
using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using Newtonsoft.Json;
using appWebPrueba.Clases;
using appWebPrueba.Models;



namespace appWebPrueba.Controllers
{
    //Este controlador nos sirve principalmente para validar el acceso de los usuarios
    public class AccountController : Controller
    {
        private ClaimsPrincipal identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

        // GET: Account
        public ActionResult Index()
        {
            return View();
        }
        [AllowAnonymous]
        public ActionResult LogOn()
        {
            AccountVM model = new AccountVM();
            return View(model);
        }

        [AllowAnonymous]
        [HttpPost]
        public ActionResult LogOn(AccountVM model)
        {
            //Cuando un usuario coloca sus credenciales hay que hacer 2 pasos, primero revisar que su usuario y contraseña sean válidos
            //colocamos la variable "UserValid" en FALSO y de ahí partimos, ya que cualquier problema o error no permitiran entrar
            bool UserValid = false;
            User Usuario = new User();

            //Primero validamos sus credenciales, si nos devuelve VERDADERO seguimos
            if (!DataAccess.Seguridad.ValidaLogin(model.Base.strUsuario, model.Base.Password))
            {
                return View(model);
            }

            //Ya con el usuario validado, mandamos traer sus datos (hay que ver la forma de hacerlo en un solo paso)
            model.Base = DataAccess.Seguridad.InfoUsuario(model.Base.strUsuario);
            if (model != null)
            {
                Usuario = model.Base;
                UserValid = true;
            }
            if (UserValid)
            {
                //Asignaremos las propiedades de esta clase a "AppUserState"
                AppUserState appUserState = new AppUserState()
                {
                    NombreUsuario = Usuario.NombreUsuario,
                    strUsuario = Usuario.strUsuario,
                    nomRol = Usuario.nomRol,
                    intRol = Usuario.intRol,
                    InternalIDUSER = Usuario.InternalIDUSER
                };
                //Envíamos esto a "IdentitySignin"
                IdentitySignin(appUserState, Usuario.strUsuario, true);
            }
            //Si todo salió bien, redirigimos a INDEX
            return RedirectToAction("Index", "Home", null);
        }


        public ActionResult LogOff()
        {
            return RedirectToAction("LogOn");
        }

        public void IdentitySignin(AppUserState appUserState, string providerKey = null, bool isPersistent = false)
        {
            var claims = new List<Claim>();

            //Asignamos a los Claim los valores que obtuvimos previamente de "AppUserState"
            //de este modo podemos acceder a ellos como si fueran variables de Sesión
            claims.Add(new Claim(ClaimTypes.NameIdentifier, appUserState.strUsuario));
            claims.Add(new Claim(ClaimTypes.Name, appUserState.NombreUsuario));
            claims.Add(new Claim(ClaimTypes.Role, appUserState.nomRol));
            claims.Add(new Claim(ClaimTypes.Gender, appUserState.intRol)); //el IdRol se lo asignamos a esta variable
            claims.Add(new Claim(ClaimTypes.SerialNumber, appUserState.InternalIDUSER));  //este se va a usar para el InternalID
            // custom – my serialized AppUserState object
            claims.Add(new Claim("userState", appUserState.ToString()));

            var identity = new ClaimsIdentity(claims, DefaultAuthenticationTypes.ApplicationCookie);

            AuthenticationManager.SignIn(new AuthenticationProperties()
            {
                AllowRefresh = true,
                IsPersistent = isPersistent,
                ExpiresUtc = DateTime.UtcNow.AddHours(2)
            }, identity);
        }

        public void IdentitySignout()
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie,
                                            DefaultAuthenticationTypes.ExternalCookie);
        }

        private IAuthenticationManager AuthenticationManager
        {
            get { return HttpContext.GetOwinContext().Authentication; }
        }
    }
}