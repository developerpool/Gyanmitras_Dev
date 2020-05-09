using Gyanmitras.Filter;
using GyanmitrasMDL.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using GyanmitrasBAL.Common;
using GyanmitrasMDL;
using GyanmitrasMDL.User;
using Gyanmitras.Filter;
using Utility;
using GyanmitrasBAL.User;
using System.Text;
using System.IO;
using Gyanmitras.Common;
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


        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult Registration(VolunteerMDL Voluntee)
        {
            Voluntee.Password = ClsCrypto.Encrypt(Voluntee.Password);




            if (ModelState.IsValid)
            {
                HttpPostedFileBase Imgfile = Voluntee.Image;
                if (Imgfile != null)
                {


                    if (!Directory.Exists(Server.MapPath("~/SiteUserContents/Registration/VolunteerImages/")))
                        Directory.CreateDirectory(Server.MapPath("~/SiteUserContents/Registration/VolunteerImages/"));

                    CommonHelper.Upload(Imgfile, "~/SiteUserContents/Registration/VolunteerImages/", Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')));

                    if (!string.IsNullOrEmpty(Voluntee.ImageName))
                    {
                        var filePath = Server.MapPath("~/SiteUserContents/Registration/VolunteerImages/" + Voluntee.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    Voluntee.ImageName = Imgfile.FileName;
                }
                VolunteerBAL objVolunteerBAL = new VolunteerBAL();
                string Msg = "";
                StringBuilder objMsg = objVolunteerBAL.RegisterVolunteer(Voluntee);
                Msg = objMsg.ToString();

                if (Msg.Equals("Success"))
                {

                    //string controllerName = "";
                    //string area = "";
                    //string actionName = "";
                    //area = "";
                    //actionName = "Index";
                    //controllerName = "Home";
                    // return RedirectToAction(actionName, controllerName, area);
                    ViewBag.Message = "Registration Sucessfull.Please Login to Contineu.";
                    return View(Voluntee);
                }
                else
                {
                    ViewBag.Message = "Submitting Form Went Wrong";
                    return View(Voluntee);
                }

            }
            else
            {

                ////ViewBag.Message = objMsg.Message;
                return View(Voluntee);
            }
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
            VolunteerBAL objVolunteerBAL = new VolunteerBAL();
            var user = Gyanmitras.Common.SiteUserSessionInfo.User as GyanmitrasMDL.User.SiteUserInfoMDL;
            ViewBag.type = "Edit";
            obj = objVolunteerBAL.GetVolunteerProfile(user.UserName);
            return View(obj);
        }

        #region post of userprofile
        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile(VolunteerMDL volunteer)
        {
             
            ModelState.Remove("ZipCode");
            ModelState.Remove("Password");
            ModelState.Remove("FK_StateId");
            ModelState.Remove("FK_CityId");
            ModelState.Remove("FK_State_AreaOfSearch");
            ModelState.Remove("FK_District_AreaOfSearch");
            ModelState.Remove("UID");
            ModelState.Remove("ConfirmPassword");
            ModelState.Remove("Name");
            ModelState.Remove("languages");


            if (ModelState.IsValid)
            {
                HttpPostedFileBase Imgfile = volunteer.Image;
                if (Imgfile != null)
                {


                    if (!Directory.Exists(Server.MapPath("~/SiteUserContents/Registration/VolunteerImages/")))
                        Directory.CreateDirectory(Server.MapPath("~/SiteUserContents/Registration/VolunteerImages/"));

                    CommonHelper.Upload(Imgfile, "~/SiteUserContents/Registration/VolunteerImages/", Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')));

                    if (!string.IsNullOrEmpty(volunteer.ImageName))
                    {
                        var filePath = Server.MapPath("~/SiteUserContents/Registration/VolunteerImages/" + volunteer.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    volunteer.ImageName = Imgfile.FileName;
                }
                VolunteerBAL objStudentBAL = new  VolunteerBAL();
                string Msg = "";
                StringBuilder objMsg = objStudentBAL.UpdateVolunteerProfile(volunteer);
                Msg = objMsg.ToString();

                if (Msg.Equals("Success"))
                {

                    //string controllerName = "";
                    //string area = "";
                    //string actionName = "";

                    //area = "";
                    //actionName = "Index";
                    //controllerName = "Home";
                    ViewBag.Message = "Profile Updated Sucessfully.";
                    ViewBag.Redirect = "Yes";
                    return View(volunteer);
                    //  return RedirectToAction(actionName, controllerName, area);
                }
                else
                {
                    ViewBag.Message = "Submitting Form Went Wrong";
                    return View(volunteer);
                }

            }
            else
            {
                string Message = string.Join("\n", ModelState.Values
                                       .SelectMany(x => x.Errors)
                                       .Select(x => x.ErrorMessage));
                VolunteerMDL volunteer1 = new  VolunteerMDL();
                // student1.UID = SessionInfo.User.UserName;
                //  student1.IsActive = true;
                return View("UserProfile", volunteer1);
                // return View(student);
            }
        }
        #endregion



        //public JsonResult BindAreaOfInterestList(string type = "")
        //{
        //    return Json(CommonBAL.BindAreaOfInterestList(type), JsonRequestBehavior.AllowGet);
        //}
    }
}