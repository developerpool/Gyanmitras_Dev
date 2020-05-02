using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using GyanmitrasBAL.Common;
using GyanmitrasMDL;
using GyanmitrasMDL.User;
using Gyanmitras.Filter;
namespace Gyanmitras.Controllers
{
    public class StudentController : Controller
    {
        StudentMDL obj= new  StudentMDL();

        [HttpGet]
        [AllowAnonymous]
        [SkipUserCustomAuthenticationAttribute]
        // GET: Counselor
        public ActionResult Index()
        {
            var user = Gyanmitras.Common.SiteUserSessionInfo.User as GyanmitrasMDL.User.SiteUserInfoMDL;
            ViewBag.Title = user.RoleName;
            ViewBag.RoleId = user.RoleId;
            return View();
        }

        // GET: Student
        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult Registration()
        {
            return View(obj);
        }
        public JsonResult BindAreaOfInterestList(string type = "")
        {
            return Json(CommonBAL.BindAreaOfInterestList(type), JsonRequestBehavior.AllowGet);
        }
        [UserCustomAuthenticationAttribute]
        public ActionResult StudentIndex()
        {
           
            return View();
        }

        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult LatestNews()
        {
            var user = Gyanmitras.Common.SiteUserSessionInfo.User as GyanmitrasMDL.User.SiteUserInfoMDL;
            ViewBag.Title = user.RoleName +" Latest News";

            return View();
        }
    }
}