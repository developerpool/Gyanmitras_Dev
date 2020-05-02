﻿using Gyanmitras.Filter;
using System.Web;
using System.Web.Mvc;

namespace Gyanmitras
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());


            filters.Add(new CustomAuthenticationAttribute());
            filters.Add(new HandleErrorExt());
            //filters.Add(new NoDirectAccessAttribute());
        }
    }
}
