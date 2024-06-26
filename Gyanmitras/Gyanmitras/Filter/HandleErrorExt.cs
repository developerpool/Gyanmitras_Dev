﻿using GyanmitrasBAL.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Gyanmitras.Filter
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method | AttributeTargets.Constructor, AllowMultiple = false, Inherited = true)]
    public class HandleErrorExt : HandleErrorAttribute
    {
        private bool IsAjax(ExceptionContext filterContext)
        {
            return filterContext.HttpContext.Request.Headers["X-Requested-With"] == "XMLHttpRequest";
        }
        public override void OnException(ExceptionContext filterContext)
        {

            if (filterContext.ExceptionHandled || !filterContext.HttpContext.IsCustomErrorEnabled)
            {
                filterContext.Result = new RedirectToRouteResult(new
                               RouteValueDictionary(new { controller = "Account", action = "Login", area = "Admin" }));
                new RedirectToRouteResult(
                new RouteValueDictionary
                 {
                           { "controller", "Home" },
                           { "action", "Index" },
                 });

                return;
            }

            // if the request is AJAX return JSON else view.
            if (IsAjax(filterContext))
            {
                //Because its a exception raised after ajax invocation
                //Lets return Json
                filterContext.Result = new JsonResult()
                {
                    Data = filterContext.Exception.Message,
                    JsonRequestBehavior = JsonRequestBehavior.AllowGet
                };

                filterContext.ExceptionHandled = true;
                filterContext.HttpContext.Response.Clear();
            }
            else
            {
                //Normal Exception
                //So let it handle by its default ways.
                base.OnException(filterContext);

            }

            // Write error logging code here if you wish.

            //if want to get different of the request
            var currentController = (string)filterContext.RouteData.Values["controller"];
            var currentActionName = (string)filterContext.RouteData.Values["action"];

            var objBase = System.Reflection.MethodBase.GetCurrentMethod();
            ErrorLogBAL.SetError(filterContext.Exception, objBase, currentController, currentActionName, "FleetTrackingSystem WebApp", "Application Level Error");


            filterContext.Result = new RedirectToRouteResult(
           new RouteValueDictionary
            {
                    { "controller", "Home" },
                    { "action", "Index" }
            });

            //Write code to log in data base
        }

    }
}