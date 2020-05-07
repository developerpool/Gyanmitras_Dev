using Gyanmitras.Common;
using GyanmitrasBAL;
using GyanmitrasBAL.Common;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
namespace Gyanmitras.Areas.Admin.Controllers
{
    public class AdminDashboardController : Controller
    {
        AdminDashboardBAL objAdminDashboardBAL = null;
        AdminDashboardMDL objAdminDashboardMDL = null;
        MessageMDL Msg = null;
        // GET: Admin/AdminDashboard
        public AdminDashboardController() {
            objAdminDashboardBAL = new AdminDashboardBAL();
            objAdminDashboardMDL = new AdminDashboardMDL();
        }
        public ActionResult Index(AdminDashboardMDL obj = null)
        {
            ViewData["StateList"] = CommonBAL.GetStateDetailsByCountryId(1);
            ViewData["Month"] = CommonBAL.FillMonth();
            var year = Enumerable.Range(DateTime.Today.Year - 1, 2).ToList().OrderByDescending(x => x);
            List<DropDownMDL> objYear = new List<DropDownMDL>();
            foreach (var item in year)
            {
                objYear.Add(new DropDownMDL()
                {
                    ID = item,
                    Value = item.ToString()
                });
            }


            ViewData["Year"] = objYear;
            if (obj.Year == 0 && obj.Month == 0)
            {
                obj.Year = DateTime.Today.Year;
                obj.Month = DateTime.Today.Month;
            }

            AdminDashboardMDL outobj = new AdminDashboardMDL();
            objAdminDashboardBAL.GetAdminDashboardDetails(out outobj, obj);

            outobj.FK_StateId = obj.FK_StateId;
            outobj.Year = obj.Year;
            outobj.Month = obj.Month;

            ViewBag.Title = "Gyanmitras Admin Dashboard";
            return View(outobj);
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