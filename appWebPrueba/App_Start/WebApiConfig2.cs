using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Mvc;

namespace appWebPrueba.App_Start
{
    public static class WebApiConfig2
    {
        public static void Register(HttpConfiguration config)
        {
            config.MapHttpAttributeRoutes();

        }
    }
}