using Gyanmitras.Common;
using GyanmitrasBAL.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class AdminDashboardController : Controller
    {
        // GET: Admin/AdminDashboard
        public ActionResult Index()
        {

            ViewData["Month"] = CommonBAL.FillMonth();
            var year = Enumerable.Range(DateTime.Today.Year - 1, 2).ToList().OrderByDescending(x => x);
            ViewData["Year"] = year;
            
            ViewBag.Title = "Gyanmitras Admin Dashboard";
            return View();
        }

        // GET: Admin/AdminDashboard
        public ActionResult IndexBak()
        {
            ViewBag.Title = "Gyanmitras Admin Dashboard";
            return View();
        }

        // GET: Admin/AdminDashboard
        public ActionResult StudentsDetails()
        {
            ViewBag.Title = "Gyanmitras Students Details";
            return View();
        }


        // GET: Admin/AdminDashboard
        public ActionResult VolunteerDetails()
        {
            ViewBag.Title = "Gyanmitras Volunteer Details";
            return View();
        }


        // GET: Admin/AdminDashboard
        public ActionResult CounselorDetails()
        {
            ViewBag.Title = "Gyanmitras Counselor Details";
            return View();
        }




    }
}