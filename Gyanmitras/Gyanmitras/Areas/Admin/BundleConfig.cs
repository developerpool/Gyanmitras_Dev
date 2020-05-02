using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;

namespace Gyanmitras.Areas.Admin
{
    internal static class BundleConfig
    {
        internal static void RegisterBundles(BundleCollection bundles)
        {
            #region Admin Bundles

            //add bundles
            bundles.Add(new ScriptBundle("~/Admin/bundles/jquery").Include(
                          //"~/Scripts/jquery-{version}.js"
                          "~/app-assets/vendors/js/vendors.min.js",
                          "~/app-assets/js/core/app-menu.js",
                          "~/app-assets/js/core/app.js",
                          "~/assets/js/freeze-table.js",
                          "~/assets/js/scripts.js"

                          ));

            bundles.Add(new ScriptBundle("~/Admin/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/Admin/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/Admin/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Admin/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/site.css"));
            #endregion
        }
    }
}