using Gyanmitras.Filter;
using GyanmitrasMDL.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Gyanmitras.Controllers
{
    //[Authorize]
    [HandleErrorExt]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
    public class VolunteerController : Controller
    {
        VolunteerMDL obj = new VolunteerMDL();
        [HttpGet]
        [AllowAnonymous]
        [SkipUserCustomAuthenticationAttribute]
        // GET: Counselor
        public ActionResult Index()
        {
            return View();
        }

        

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Account Details By Id
        /// </summary>
        /// 
        [HttpGet]
        [SkipUserCustomAuthenticationAttribute]
        public ActionResult StudentRegistration(int id = 0)
        {
            ViewBag.Title = "Student Registration";
            if (id != 0)
            {
                //objAccountBDL.GetAccountDetails(out _AccountMDL, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.UserId, Convert.ToInt32(10), 1, "", "", SessionInfo.User.AccountId, SessionInfo.User.FK_CustomerId, SessionInfo.User.UserId, SessionInfo.User.LoginType);
                //return View("AddEditAccount", _AccountMDL[0]);
            }
            else
            {
                //MSTAccountMDL obj = new MSTAccountMDL();
                //obj.FK_CompanyId = SessionInfo.User.fk_companyid;
                //obj.IsActive = true;
                //return View("AddEditAccount", obj);
            }
            return View("StudentRegistration");
        }

        // GET: Counselor
        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult Registration()
        {
            ViewBag.Title = "Volunteer Registration";
            obj.FormType = "Volunteer Registration";
            ViewBag.VolunteerRegistration = obj;

            return View(obj);
        }

        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult LatestNews()
        {
            ViewBag.Title = "Volunteer Latest News";

            return View();
        }

        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult HowToWork()
        {
            ViewBag.Title = "How To Work";
            return View();
        }
        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile()
        {
            VolunteerMDL obj = new VolunteerMDL();
            ViewBag.Title = "User Profile";
            obj.FormType = "User Profile";
            ViewBag.VolunteerRegistration = obj;

            return View(obj);
        }

        



        //public JsonResult BindAreaOfInterestList(string type = "")
        //{
        //    return Json(CommonBAL.BindAreaOfInterestList(type), JsonRequestBehavior.AllowGet);
        //}
    }
}