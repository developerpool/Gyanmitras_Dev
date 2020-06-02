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
using System.Configuration;
using Newtonsoft.Json;

namespace Gyanmitras.Controllers
{
    [HandleErrorExt]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]

    public class HomeController : BaseController
    {
        //Chat Variables
        private dynamic _PatnersDatalist;
        StudentMDL objUserBal = null;
        BasicPagingMDL objBasicPagingMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;
        //End Chat

        public static string ViewBagTitle = "";
        public static bool IsVolunteer = false;
        public static bool IsCounselor = false;
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
        public JsonResult GenerateCriticalSupport()
        {
            
            CommonBAL objCommonBAL = new CommonBAL();
            MessageMDL objMessageMDL = objCommonBAL.SiteUserActionManagementByUser(SiteUserSessionInfo.User.UserId, "critical_support");
            return Json(objMessageMDL, JsonRequestBehavior.AllowGet);
        }

        

        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        [HttpGet]
        public ActionResult Register(string registerfor, Int64 Pk_UserId = 0, Int64 Pk_CreatedId = 0)
        {
            SiteUserMDL obj = new SiteUserMDL();
            registerfor = string.IsNullOrEmpty(registerfor) ? "Student" : registerfor.TrimStart().TrimEnd();
            ViewBag.IsVolunteer = registerfor == "Volunteer" ? true : false;
            ViewBag.IsCounselor = registerfor == "Counselor" ? true : false;
            if (Pk_UserId == 0 && Pk_CreatedId == 0)
            {
                ViewBag.Title = "Your registration for " + registerfor + ".";
                ViewBagTitle = "Your registration for " + registerfor + ".";
            }
            else
            {
                ViewBag.Title = "Your registration for Verification.";
                ViewBagTitle = "Your registration for Verification.";
            }

            IsVolunteer = ViewBag.IsVolunteer;
            IsCounselor = ViewBag.IsCounselor;

            if (Pk_UserId != 0)
            {
                BasicPagingMDL objBasicPagingMDL = null;
                TotalCountPagingMDL objTotalCountPagingMDL = null;
                CommonBAL objCommonBAL = new CommonBAL();
                dynamic _UserDatalist = new List<SiteUserMDL>();
                int RowPerpage = 10;
                int CurrentPage = 1;
                string SearchBy = "";
                string SearchValue = "";
                objCommonBAL.GetSiteUserDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, Convert.ToInt32(Pk_UserId), RowPerpage, CurrentPage, SearchBy, SearchValue, Pk_CreatedId, "", 0, 0);
                obj = _UserDatalist[0];

                ViewBag.IsEmailVerifiedAlert = true;
            }

            return View(obj);
        }

        public static string otp = "";
        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        [HttpPost]
        public ActionResult Register(SiteUserMDL obj)
        {

            ViewBag.Title = ViewBagTitle;
            ViewBag.IsVolunteer = IsVolunteer;
            ViewBag.IsCounselor = IsCounselor;
            if (!string.IsNullOrEmpty(obj.EmailID) && !string.IsNullOrEmpty(obj.UID) && !string.IsNullOrEmpty(obj.Password) && !string.IsNullOrEmpty(obj.Name))
            {

                if (otp != obj.OTPUserInput)
                {
                    if (!string.IsNullOrEmpty(otp) && !string.IsNullOrEmpty(obj.OTPUserInput))
                    {
                        ViewBag.IsOTPVerifiedAlert = false;
                        ViewBag.OTPAlertMessage = "Invalid OTP, please verifiy email!";
                    }
                    else
                    {
                        otp = SendOTP(obj.EmailID);
                        if (string.IsNullOrEmpty(otp))
                        {
                            otp = "";
                            MessageMDL newmessage = new MessageMDL() { Message = "Somthing went wrong!", MessageId = 0 };
                            ViewBag.msg = newmessage;
                        }
                        else
                        {

                            obj.OTP = otp;
                            ViewBag.IsOTPVerifiedAlert = false;
                            ViewBag.OTPAlertMessage = "Email has been send on your email, please verifiy email!";
                        }
                    }
                    return View(obj);
                }
                CommonBAL objCommonBAL = new CommonBAL();
                obj.FK_CategoryId = IsVolunteer ? (int)SiteUserCategory.Volunteer : (IsCounselor ? (int)SiteUserCategory.Counselor : (int)SiteUserCategory.Student);
                obj.FK_RoleId = IsVolunteer ? (int)SiteUserRole.Volunteer : (IsCounselor ? (int)SiteUserRole.Counselor : (int)SiteUserRole.Non_Adopted_Student);
                //if (obj.FK_CategoryId == (int)SiteUserCategory.Volunteer)
                //{
                //    obj.AdoptionWish
                //}
                obj.FormType = obj.Pk_UserId == 0 ? "NewSignUp" : "MailVerification";
                obj.AdoptionWish = string.IsNullOrEmpty(obj.AdoptionWish) ? "" : obj.AdoptionWish;
                MessageMDL message = objCommonBAL.SiteUserSignUp(obj);
                if (message.MessageId == 1)
                {
                    string typereg = obj.FK_CategoryId == (int)SiteUserCategory.Volunteer ? "Volunteer" :
                                    (obj.FK_CategoryId == (int)SiteUserCategory.Counselor ? "Counselor" :
                                    (obj.FK_CategoryId == (int)SiteUserCategory.Student ? "Student" : "Student"));
                    #region User mail after registration
                    string mailbody =
                        "Dear <b>" + obj.Name + "</b>,<br/>" +
                        "Your request for " + typereg + " registration has been received by management." +
                        "<br/><br/>" +
                        "User ID : <b>" + obj.UID + "</b><br/>" +
                        "Password : <b>" + obj.Password + "</b><br/><br/>" +

                        "<b>Note : Please don't share your User Id & Password to any one.</b><br/><br/>" +

                        "Regards,<br/>" +
                        "Web Master www.gyanmitras.com <br/>";
                    Dictionary<int, string> email_dic = new Dictionary<int, string>();
                    email_dic.Add(1, obj.EmailID);
                    bool send = Mail.SendEmail("Gyanmitras " + typereg + " Registration", mailbody, email_dic);
                    #endregion

                    #region Admin mail after registration

                    mailbody =
                        "Dear Sir/Madam<br/>" +
                        "New request for " + typereg + " registration from www.Gyanmitras.com. <br/>" +
                        "Kindly check admin panel.<br/><br/>" +

                        "Name : <b>" + obj.Name + "</b><br/>" +
                        "Email : <b>" + obj.EmailID + "</b><br/>" +
                        "User ID : <b>" + obj.UID + "</b><br/>" +
                        "Password : <b>" + obj.Password + "</b><br/>" +
                        "" + (!IsVolunteer && !IsCounselor ? "Do you want to be adopt." + " : <b>" + obj.AdoptionWish + "</b><br/><br/>" : (IsCounselor ? "Do you want to adopt students in future." + " : <b>" + (obj.AdoptionWish.ToLower() == "true" ? "Yes" : "No") + "</b><br/><br/>" : "")) +


                        "Regards,<br/>" +
                        "Web Master www.gyanmitras.com <br/>";


                    send = Mail.SendEmail("Gyanmitras " + typereg + " Registration", mailbody, null, null, "", "", "", true);
                    #endregion
                    otp = "";
                    obj.OTPUserInput = "";
                    ViewBag.msg = message;

                }
                else
                {
                    otp = "";
                    ViewBag.msg = message;
                    return View(obj);
                }
            }
            else
            {
                otp = "";
                MessageMDL message = new MessageMDL() { Message = "Please fill all the mandatory fields!", MessageId = 0 };
                ViewBag.msg = message;

            }
            return View(obj);
        }


        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public ActionResult CommonChat()
        {
            ViewBag.Title = "Gyanmitras Chat.";
            string PartnerProfileDetails_JSON = SiteUserSessionInfo.User.PartnerProfileDetails;
            List<SiteUserMDL> PartnerProfileDetails_List = new List<SiteUserMDL>();
            // JsonConvert.DeserializeObject<List<SiteUserMDL>>(PartnerProfileDetails_JSON);

            var PartnerProfileImagePath = "";
            if (SiteUserSessionInfo.User.CategoryId == (Int64)GyanmitrasMDL.User.SiteUserCategory.Student)
            {
                SiteUserMDL obj = JsonConvert.DeserializeObject<SiteUserMDL>(PartnerProfileDetails_JSON);
                PartnerProfileDetails_List.Add(obj);
                PartnerProfileImagePath = System.Configuration.ConfigurationManager.AppSettings["CounselorProfilePath"].ToString();
            }
            else if (SiteUserSessionInfo.User.CategoryId == (Int64)GyanmitrasMDL.User.SiteUserCategory.Counselor)
            {
                PartnerProfileDetails_List = JsonConvert.DeserializeObject<List<SiteUserMDL>>(PartnerProfileDetails_JSON);
                PartnerProfileImagePath = System.Configuration.ConfigurationManager.AppSettings["StudentProfilePath"].ToString();

            }
            if (PartnerProfileDetails_List != null)
            {
                PartnerProfileDetails_List[0].IsActive = true;
                PartnerProfileImagePath = PartnerProfileImagePath.Replace("~/", "../");
                PartnerProfileDetails_List.ForEach(e => e.ImageName = PartnerProfileImagePath + e.ImageName);
            }




            ViewBag.ChatPartners = PartnerProfileDetails_List;
            return View();
        }

        [HttpGet]
        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult GetSiteUserChatDetails(Int64 Chat_From, Int64 Chat_To, Int64 PK_ChatID = 0)
        {
            CommonBAL obj = new CommonBAL();
            SiteUserChat objChat = new SiteUserChat();
            objChat.PK_ChatID = PK_ChatID;
            objChat.Chat_From = Chat_From;
            objChat.Chat_To = Chat_To;

            List<SiteUserChat> _dataList = new List<SiteUserChat>();
            MessageMDL message = obj.GetSiteUserChatDetails(out _dataList, objChat);
            return Json(_dataList, JsonRequestBehavior.AllowGet);
        }


        [HttpGet]
        [SkipUserCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult AddEditSiteUserChat(Int64 Chat_From, Int64 Chat_To, string Query = "", Int64 PK_ChatID = 0)
        {
            CommonBAL obj = new CommonBAL();
            SiteUserChat objChat = new SiteUserChat();
            objChat.PK_ChatID = PK_ChatID;
            objChat.Chat_From = Chat_From;
            objChat.Chat_To = Chat_To;
            if (PK_ChatID != 0)
            {
                objChat.IsReplay = true;
                objChat.Query_To = Query;
            }
            else
            {
                objChat.Query_From = Query;
            }
            return Json(obj.AddEditSiteUserChat(objChat), JsonRequestBehavior.AllowGet);
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



        private string SendOTP(string myemailid)
        {
            var finalString = Gyanmitras.Common.CommonHelper.RandomString();
            string mailbody =
                "Dear Sir/Madam,<br/>" +
                "Kindly approve your email account.<br/>" +
                "OTP : <b>" + finalString + "</b><br/><br/>" +
                "Regards,<br/>" +
                "Web Master www.gyanmitras.com <br/>";
            Dictionary<int, string> email_dic = new Dictionary<int, string>();
            email_dic.Add(1, myemailid);
            bool send = Mail.SendEmail("GYANMITRAS OTP Verification", mailbody, email_dic);
            return send ? finalString : "";
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
            var testpass = ClsCrypto.Decrypt("gZGigBbONXlnfgvR2665dw==");
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
                    var mypath = _User.CategoryId == Convert.ToInt32(SiteUserCategory.Student) ?
                                 ConfigurationManager.AppSettings["StudentProfilePath"].ToString()
                                 : (
                                    _User.CategoryId == Convert.ToInt32(SiteUserCategory.Counselor) ?
                                    ConfigurationManager.AppSettings["CounselorProfilePath"].ToString()
                                    : (
                                        _User.CategoryId == Convert.ToInt32(SiteUserCategory.Volunteer) ?
                                        ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString()
                                        : ""
                                    )
                                 );
                    mypath = mypath.Replace("~/", "../");
                    _User.ProfileImage = mypath + _User.ProfileImage;
                    SiteUserSessionInfo.User = _User;
                    ;
                    string actionName = "";
                    string controllerName = "";
                    string area = "";


                    area = "";
                    actionName = "Index";
                    controllerName = _User.CategoryId == 1 ? "Student" : (_User.CategoryId == 2 ? "Counselor" : (_User.CategoryId == 3 ? "Volunteer" : ""));



                    SiteUserSessionInfo.User.LandingPageURL = (!string.IsNullOrEmpty(area) ? area + "/" : "") + controllerName + "/" + actionName;
                    return RedirectToAction(actionName, controllerName, area);
                }
                else
                {
                    ViewBag.msg = objMsg;
                    return View(ObjLoginMDL);
                }

            }
            else
            {
                ViewBag.msg = new MessageMDL()
                {
                    Message = "UserId & Password Did Not Match!",
                    MessageId = 0
                };
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






        /// <summary>
        /// Get Details Of User Master in List
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        [HttpGet]
        [SkipCustomAuthenticationAttribute]
        [AllowAnonymous]
        public JsonResult GetSiteUserContentResourcesDetails(Int64 FK_StateId, Int64 FK_AcademicGroupId, Int64 FK_BenifitTypeId)
        {
            
            List<SiteUserContentResourceMDL> _SiteUserContentResourceDataList = new List<SiteUserContentResourceMDL>();
            SiteUserContentResourceBAL objSiteUserContentResourceBAL = new SiteUserContentResourceBAL();
            objBasicPagingMDL = new BasicPagingMDL();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            objSiteUserContentResourceBAL.GetSiteUserContentResourcesDetails(out _SiteUserContentResourceDataList, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, 1000, 1, (SiteUserSessionInfo.User == null ? "AnonymousUser" : "SiteUserResource"), (SiteUserSessionInfo.User == null ? "" : SiteUserSessionInfo.User.RoleId.ToString()), FK_StateId, FK_AcademicGroupId, FK_BenifitTypeId);
            return Json(_SiteUserContentResourceDataList, JsonRequestBehavior.AllowGet);
        }





    }
}
