using Utility;
using Gyanmitras.Common;
using Gyanmitras.Filter;
using GyanmitrasBAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Configuration;
using System.Web;

namespace Gyanmitras.Areas.Admin.Controllers
{
    [HandleErrorExt]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]

    public class AccountController : BaseController
    {
        private List<FormMDL> _formlist;
        UserInfoMDL _User;
        // GET: Account
        //public ActionResult Index()
        //{
        //    return View();
        //}
        /// <summary>
        /// login Details
        /// </summary>
        /// <returns></returns>
        [SkipCustomAuthenticationAttribute]
        public ActionResult Login()
        {
            LoginMDL model = new LoginMDL();
            if (Request.Cookies["Login"] != null)
            {
                model.UserName = Request.Cookies["Login"].Values["UserName"];
                model.Password = ClsCrypto.Decrypt(Request.Cookies["Login"].Values["Password"]);
            }
            return View(model);

        }
        [HttpPost]
        //login

        [SkipCustomAuthenticationAttribute]
        public ActionResult Login(LoginMDL ObjLoginMDL)
        {
            ObjLoginMDL.Language = "English";
            ObjLoginMDL.Password = ClsCrypto.Encrypt(ObjLoginMDL.Password);
            //ObjLoginMDL.UserName = "dadmin";
            // ObjLoginMDL.Password = "bsl@321";
            if (ModelState.IsValid)
            {
                AccountBAL objAccountBAL = new AccountBAL();

                MessageMDL objMsg = objAccountBAL.AuthenticateUser(ObjLoginMDL, out _User, out _formlist);
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
                    SessionInfo.User = _User;
                    SessionInfo.formlist = _formlist;
                    string actionName = SessionInfo.formlist.FirstOrDefault(x => x.PK_FormId == Convert.ToInt32(x.HomePage)).ActionName;
                    string controllerName = SessionInfo.formlist.FirstOrDefault(x => x.PK_FormId == Convert.ToInt32(x.HomePage)).ControllerName;
                    string area = SessionInfo.formlist.FirstOrDefault(x => x.PK_FormId == Convert.ToInt32(x.HomePage)).Area;

                    if (string.IsNullOrWhiteSpace(actionName) || string.IsNullOrWhiteSpace(actionName))
                    {
                        area = "Admin";
                        actionName = "Index";
                        controllerName = "MstAccount";

                    }


                    SessionInfo.User.LandingPageURL = (!string.IsNullOrEmpty(area) ? area + "/" : "") + controllerName + "/" + actionName;
                    return RedirectToAction(actionName, controllerName,area);
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
            return RedirectToAction("Login", "Account");
        }
        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult LogOff()
        {
            SessionInfo.RemoveSession();
            return RedirectToAction("Login", "Account");
        }


        [HttpPost]
        [SkipCustomAuthenticationAttribute]
        public ActionResult SendMail(String UserName)
        {
            string Msg = string.Empty;
            AccountBAL objAccountBAL = new AccountBAL();
            LoginMDL obj = objAccountBAL.GetUserDetails(UserName);

            if (obj._UserId != 0)
            {
                //Msg = ShareUserCredential(obj._UserId);
            }
            else
            {
                Msg = @GyanmitrasLanguages.LocalResources.Resource.Invalid + " " + @GyanmitrasLanguages.LocalResources.Resource.UsruserName + ".";
            }
            if (Msg == "")
            {
                Msg = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed + ".";
            }

            return Json(Msg, JsonRequestBehavior.AllowGet);
        }

        //public string ShareUserCredential(Int64 UserId)
        //{
        //    string ccEmail = string.Empty;
        //    string UrlToShare = Convert.ToString(ConfigurationManager.AppSettings["VseenWebUrl"]);
        //    string MailerTemplateKey = Convert.ToString(ConfigurationManager.AppSettings["ShareUserCredentialMailerKey"]);

        //    return new ShareOnSocialMedia().ShareUserCredentialsViaEmail(Convert.ToString(UserId), ccEmail, UrlToShare, MailerTemplateKey);
        //}

    }
}