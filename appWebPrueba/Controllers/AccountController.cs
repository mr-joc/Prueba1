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

            bool UserValid = false;
            User Usuario = new User();

            if (!DataAccess.Seguridad.ValidaLogin(model.Base.strUsuario, model.Base.Password))
            {
                return View(model);
            }

            model.Base = DataAccess.Seguridad.InfoUsuario(model.Base.strUsuario);
            if (model != null)
            {
                Usuario = model.Base;
                UserValid = true;
            }
            if (UserValid)
            {
                AppUserState appUserState = new AppUserState()
                {
                    NombreUsuario = Usuario.NombreUsuario,
                    strUsuario = Usuario.strUsuario,
                    nomRol = Usuario.nomRol,
                    intRol = Usuario.intRol,
                    InternalIDUSER = Usuario.InternalIDUSER
                };
                IdentitySignin(appUserState, Usuario.strUsuario, true);
            }
            return RedirectToAction("Index", "Home", null);
        }


        public ActionResult LogOff()
        {
            return RedirectToAction("LogOn");
        }

        public void IdentitySignin(AppUserState appUserState, string providerKey = null, bool isPersistent = false)
        {
            var claims = new List<Claim>();
            // create required claims
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