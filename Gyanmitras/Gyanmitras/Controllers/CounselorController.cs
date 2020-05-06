using Gyanmitras.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using GyanmitrasMDL.User;
using GyanmitrasBAL.Common;

namespace Gyanmitras.Controllers
{


    //[Authorize]
    [HandleErrorExt]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
    public class CounselorController : BaseController
    {
        CounselorMDL obj = new CounselorMDL();

        [HttpGet]
        [AllowAnonymous]
        [SkipUserCustomAuthenticationAttribute]
        // GET: Counselor
        public ActionResult AdoptedStudentIndex()
        {
            ViewBag.Title = "Counselor : Adopted Student";
            return View();
        }

        [HttpGet]
        [AllowAnonymous]
        [SkipUserCustomAuthenticationAttribute]
        // GET: Counselor
        public ActionResult NonAdoptedStudentIndex()
        {
            ViewBag.Title = "Counselor : Non-Adopted Student";
            return View();
        }

        [HttpGet]
        [AllowAnonymous]
        [SkipUserCustomAuthenticationAttribute]
        // GET: Counselor
        public ActionResult ProduceCounselingMaterials()
        {
            ViewBag.Title = "Produce Counseling Materials";
            return View();
        }
        


        // GET: Counselor
        [HttpGet]
        [SkipUserCustomAuthenticationAttribute]
        public ActionResult Registration()
        {
            ViewBag.Title = "Counselor Registration";
            ViewData["RetiredExpertiseDetailsList"] = CommonBAL.BindRetiredExpertiseDetailsList();
            ViewData["EmployedExpertiseDetailsList"] = CommonBAL.BindEmployedExpertiseDetailsList();

            ViewData["StreamList"] = CommonBAL.BindStreamDetailsList();
            ViewData["BoardList"] = CommonBAL.BindBoardDetailsList();
            ViewData["UniversityList"] = CommonBAL.BindBoardDetailsList();
            ViewData["YearList"] = CommonBAL.BindYearOfPassingList();


            return View(obj);
        }
        [SkipUserCustomAuthenticationAttribute]
        public ActionResult CounselorIndex()
        {
            ViewBag.Title = "Counselor Registration";
            ViewData["RetiredExpertiseDetailsList"] = CommonBAL.BindRetiredExpertiseDetailsList();
            ViewData["EmployedExpertiseDetailsList"] = CommonBAL.BindEmployedExpertiseDetailsList();

            ViewData["StreamList"] = CommonBAL.BindStreamDetailsList();
            ViewData["BoardList"] = CommonBAL.BindBoardDetailsList();
            ViewData["UniversityList"] = CommonBAL.BindBoardDetailsList();
            ViewData["YearList"] = CommonBAL.BindYearOfPassingList();
            return View();
        }



        public JsonResult BindAreaOfInterestList(string type = "")
        {
            return Json(CommonBAL.BindAreaOfInterestList(type), JsonRequestBehavior.AllowGet);
        }


        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult LatestNews()
        {

            ViewBag.Title = "Counselor Latest News";

            return View();
        }
        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult AdoptAStudent()
        {

            ViewBag.Title = "Counselor Student Adoption";

            return View();
        }


        [HttpGet]
        [SkipUserCustomAuthenticationAttribute]
        public ActionResult UserProfile()
        {
            ViewBag.Title = "User Prifile";
            ViewData["RetiredExpertiseDetailsList"] = CommonBAL.BindRetiredExpertiseDetailsList();
            ViewData["EmployedExpertiseDetailsList"] = CommonBAL.BindEmployedExpertiseDetailsList();

            ViewData["StreamList"] = CommonBAL.BindStreamDetailsList();
            ViewData["BoardList"] = CommonBAL.BindBoardDetailsList();
            ViewData["UniversityList"] = CommonBAL.BindBoardDetailsList();
            ViewData["YearList"] = CommonBAL.BindYearOfPassingList();


            return View(obj);
        }
    }
}