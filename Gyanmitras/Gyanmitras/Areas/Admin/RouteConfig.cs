using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Gyanmitras.Areas.Admin
{
    internal static class RouteConfig
    {
        internal static void RegisterRoutes(AreaRegistrationContext context)
        {
            //add routes
            //Default Route
            context.MapRoute(
               "Admin_default",
               "Admin",
               new { action = "Index", controller = "Default", id = UrlParameter.Optional }
           );


            context.MapRoute(
                "Admin",
                "Admin/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );

        }
    }
}