using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;
using GyanmitrasBAL.Common;
using GyanmitrasMDL.User;
using GyanmitrasMDL;
using Gyanmitras.Filter;
using Utility;
using Gyanmitras.Common;
using GyanmitrasBAL.User;

namespace Gyanmitras.Controllers
{
    [HandleErrorExt]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]

    public class HomeController : BaseController
    {
        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult Index()
        {

            List<DropDownMDL> Listobj = CommonBAL.GetStateDetailsByCountryId(1);
            ViewData["StateList"] = Listobj;
            return View();
        }

        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

      
        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult CommonChat()
        {
            ViewBag.Title = "Gyanmitras Chat.";

            return View();
        }

        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        
        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult Resource()
        {
            return View();
        }


        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult LatestNews()
        {

            ViewBag.Title = "Latest News";

            return View();
        }


        #region User Account


        public HomeController() { }




        //private List<FormMDL> _formlist;
        SiteUserInfoMDL _User;
        // GET: Account
        //public ActionResult Index()
        //{
        //    return View();
        //}
        /// <summary>
        /// login Details
        /// </summary>
        /// <returns></returns>
        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult Login()
        {
            SiteLoginMDL model = new SiteLoginMDL();
            if (Request.Cookies["Login"] != null)
            {
                model.UserName = Request.Cookies["Login"].Values["UserName"];
                model.Password = ClsCrypto.Decrypt(Request.Cookies["Login"].Values["Password"]);
            }
            return View(model);

        }
        [HttpPost]
        //login

        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult Login(SiteLoginMDL ObjLoginMDL)
        {
            ObjLoginMDL.Language = "English";
            ObjLoginMDL.Password = ClsCrypto.Encrypt(ObjLoginMDL.Password);
            //ObjLoginMDL.UserName = "dadmin";
            // ObjLoginMDL.Password = "bsl@321";
            if (ModelState.IsValid)
            {
                SiteAccountBAL objAccountBAL = new SiteAccountBAL();

                MessageMDL objMsg = objAccountBAL.AuthenticateSiteUser(ObjLoginMDL, out _User);
                if (objMsg.MessageId == 1)
                {
                    if (ObjLoginMDL.RememberMe)
                    {
                        HttpCookie cookie = new HttpCookie("Login");
                        cookie.Values.Add("UserName", ObjLoginMDL.UserName);
                        cookie.Values.Add("Password", ObjLoginMDL.Password);
                        cookie.Expires = DateTime.Now.AddDays(15);
                        Response.Cookies.Add(cookie);
                    }
                    SiteUserSessionInfo.User = _User;

                    string actionName = "";
                    string controllerName = "";
                    string area = "";


                    area = "";
                    actionName = "Index" ;
                    controllerName = _User.CategoryId == 1 ? "Student" : (_User.CategoryId == 2 ? "Counselor" : (_User.CategoryId == 3 ? "Volunteer" : ""));



                    SiteUserSessionInfo.User.LandingPageURL = (!string.IsNullOrEmpty(area) ? area + "/" : "") + controllerName + "/" + actionName;
                    return RedirectToAction(actionName, controllerName, area);
                }
                else
                {
                    ViewBag.Message = objMsg.Message;
                    return View(ObjLoginMDL);
                }

            }
            else
            {
                ////ViewBag.Message = objMsg.Message;
                return View(ObjLoginMDL);
            }
        }
        [SkipCustomAuthenticationAttribute]
        public ActionResult ChangeLanguage(string lang)
        {
            new LanguageMang().SetLanguage(lang);
            return RedirectToAction("Login", "Home");
        }
        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult LogOff()
        {
            SiteUserSessionInfo.RemoveSession();
            return RedirectToAction("Login", "Home");
        }



        #endregion

        #region Ajax Calling Methods
        #region Languages
        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult GetLanguages()

        {
            return Json(CommonBAL.GetLanguage(), JsonRequestBehavior.AllowGet);
        }

        #endregion
        #region Get StreamDropdown
        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult GetStream(string EducationType)
        {
            return Json(CommonBAL.GetStream(EducationType), JsonRequestBehavior.AllowGet);
        }
        #endregion
        #region Get BoardType
        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult GetBoardType()
        {
            return Json(CommonBAL.GetBoardType(), JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region check UserID

        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult CheckUserId(string UID)
        {
            return Json(CommonBAL.CheckUserId(UID), JsonRequestBehavior.AllowGet);
        }


        #endregion



        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult GetAcademicGroupList()
        {
            return Json(CommonBAL.GetAcademicGroupList(), JsonRequestBehavior.AllowGet);
        }
        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult GetBenifitTypeList()
        {
            return Json(CommonBAL.GetBenifitTypeList(), JsonRequestBehavior.AllowGet);
        }

        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult GetDropsForResource()
        {
            List<Dictionary<string, object>> myList = new List<Dictionary<string, object>>();

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("state", CommonBAL.GetStateDetailsByCountryId(1));
            myList.Add(obj);

            obj = new Dictionary<string, object>();
            obj.Add("academicgroup", CommonBAL.GetAcademicGroupList());
            myList.Add(obj);

            obj = new Dictionary<string, object>();
            obj.Add("benifittype", CommonBAL.GetBenifitTypeList());
            myList.Add(obj);

            return Json(myList, JsonRequestBehavior.AllowGet);

        }
        #endregion

    }
}