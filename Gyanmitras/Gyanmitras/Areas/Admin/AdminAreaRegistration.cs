using System.Web.Mvc;
using System.Web.Optimization;

namespace Gyanmitras.Areas.Admin
{
    public class AdminAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "Admin";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            RegisterRoutes(context);
            RegisterBundles();
        }
        private void RegisterRoutes(AreaRegistrationContext context)
        {
            RouteConfig.RegisterRoutes(context);
        }

        private void RegisterBundles()
        {
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}