﻿using System;
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
            //ViewData["StreamList"] = CommonBAL.BindStreamDetailsList();
            ViewData["StreamListgraduation"] = CommonBAL.GetStream("Graduation");
            ViewData["StreamListpostgraduation"] = CommonBAL.GetStream("PostGraduation");
            ViewData["BoardList"] = CommonBAL.GetBoardType();
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


        //[HttpGet]
        //[SkipUserCustomAuthenticationAttribute]
        //public ActionResult UserProfile()
        //{
        //    ViewBag.Title = "User Prifile";
        //    ViewData["RetiredExpertiseDetailsList"] = CommonBAL.BindRetiredExpertiseDetailsList();
        //    ViewData["EmployedExpertiseDetailsList"] = CommonBAL.BindEmployedExpertiseDetailsList();

        //    ViewData["StreamList"] = CommonBAL.BindStreamDetailsList();
        //    ViewData["BoardList"] = CommonBAL.BindBoardDetailsList();
        //    ViewData["UniversityList"] = CommonBAL.BindBoardDetailsList();
        //    ViewData["YearList"] = CommonBAL.BindYearOfPassingList();


        //    return View(obj);
        //}
        #region registration post
        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult Registration(CounselorMDL counselor)
        {
            counselor.Password = ClsCrypto.Encrypt(counselor.Password);

            if (ModelState.IsValid)
            {
                HttpPostedFileBase Imgfile = counselor.Image;
                if (Imgfile != null)
                {


                    if (!Directory.Exists(Server.MapPath("~/SiteUserContents/Registration/StudentImages/")))
                        Directory.CreateDirectory(Server.MapPath("~/SiteUserContents/Registration/CounselorImages/"));

                    CommonHelper.Upload(Imgfile, "~/SiteUserContents/Registration/CounselorImages/", Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')));

                    if (!string.IsNullOrEmpty(counselor.ImageName))
                    {
                        var filePath = Server.MapPath("~/SiteUserContents/Registration/CounselorImages/" + counselor.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    counselor.ImageName = Imgfile.FileName;
                }
                CounselorBAL objCounselorBAL = new CounselorBAL();
                string Msg = "";
                StringBuilder objMsg = objCounselorBAL.RegisterCounselor(counselor);
                Msg = objMsg.ToString();

                if (Msg.Equals("Success"))
                {

                    //string controllerName = "";
                    //string area = "";
                    //string actionName = "";

                    //area = "";
                    //actionName = "Index";
                    //controllerName = "Home";
                    ViewBag.Message = "Registration Sucessfull.Please Login to Contineu.";
                    return View(counselor);
                    //  return RedirectToAction(actionName, controllerName, area);
                }
                else
                {
                    ViewBag.Message = "Submitting Form Went Wrong";
                    return View(counselor);
                }

            }
            else
            {
                return View(counselor);
            }
        }
        #endregion
        #region userprofile get
        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile()
        {
            CounselorMDL obj = new CounselorMDL();
            ViewBag.Title = "User Profile";
            obj.FormType = "User Profile";
            ViewBag.VolunteerRegistration = obj;
            CounselorBAL objCounselorBAL = new CounselorBAL();
            var user = Gyanmitras.Common.SiteUserSessionInfo.User as GyanmitrasMDL.User.SiteUserInfoMDL;
            ViewBag.type = "Edit";
             obj = objCounselorBAL.GetCounselorProfile(user.UserName);
            return View(obj);
        }
        #endregion
        #region post of userprofile
        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile(CounselorMDL counselor)
        {
         
            ModelState.Remove("ZipCode");
            ModelState.Remove("Password");
            ModelState.Remove("FK_StateId");
            ModelState.Remove("FK_CityId");
            ModelState.Remove("AreaOfInterest");
            ModelState.Remove("AdoptionWish");
            ModelState.Remove("UID");
            ModelState.Remove("ConfirmPassword");
            ModelState.Remove("Name");
            ModelState.Remove("languages");
            ModelState.Remove("AreYou");
            ModelState.Remove("LikeAdoptStudentLater");
            ModelState.Remove("Declaration");
            ModelState.Remove("JoinUsDescription");
            ModelState.Remove("Retired_Expertise_Details");
            ModelState.Remove("Expertise_Details");
            ModelState.Remove("Graduation_CourseName");
            ModelState.Remove("Graduation_UniversityName");
            ModelState.Remove("Graduation_StreamType");
            ModelState.Remove("HigherSecondry_StreamType");
            ModelState.Remove("Graduation_Year_of_Passing");
            ModelState.Remove("HigherSecondry_Year_of_Passing");
            ModelState.Remove("Secondry_Year_of_Passing");
            ModelState.Remove("Graduation_Percentage");
            ModelState.Remove("HigherSecondry_Percentage");
            ModelState.Remove("Secondry_Percentage");
            ModelState.Remove("HigherSecondry_Education_Board");
            ModelState.Remove("Secondry_Education_Board");
          
            if (ModelState.IsValid)
            {
                HttpPostedFileBase Imgfile = counselor.Image;
                if (Imgfile != null)
                {


                    if (!Directory.Exists(Server.MapPath("~/SiteUserContents/Registration/StudentImages/")))
                        Directory.CreateDirectory(Server.MapPath("~/SiteUserContents/Registration/StudentImages/"));

                    CommonHelper.Upload(Imgfile, "~/SiteUserContents/Registration/StudentImages/", Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')));

                    if (!string.IsNullOrEmpty(counselor.ImageName))
                    {
                        var filePath = Server.MapPath("~/SiteUserContents/Registration/StudentImages/" + counselor.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    counselor.ImageName = Imgfile.FileName;
                }
                CounselorBAL objCounselorBAL = new CounselorBAL();
                string Msg = "";
                StringBuilder objMsg = objCounselorBAL.UpdateCounselorProfile(counselor);
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
                    return View(counselor);
                    //  return RedirectToAction(actionName, controllerName, area);
                }
                else
                {
                    ViewBag.Message = "Submitting Form Went Wrong";
                    return View(counselor);
                }

            }
            else
            {
                string Message = string.Join("\n", ModelState.Values
                                       .SelectMany(x => x.Errors)
                                       .Select(x => x.ErrorMessage));
                CounselorMDL counselor1 = new  CounselorMDL();
                // student1.UID = SessionInfo.User.UserName;
                //  student1.IsActive = true;
                return View("UserProfile", counselor1);
               
            }
        }
        #endregion


    }
}