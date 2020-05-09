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
            ViewBag.Title = "Student Registration";
            return View(obj);
        }
        public JsonResult BindAreaOfInterestList(string type = "")
        {
            return Json(CommonBAL.BindAreaOfInterestList(type), JsonRequestBehavior.AllowGet);
        }
       
        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult LatestNews()
        {
            var user = Gyanmitras.Common.SiteUserSessionInfo.User as GyanmitrasMDL.User.SiteUserInfoMDL;
            ViewBag.Title = user.RoleName +" Latest News";

            return View();
        }
        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult Registration(StudentMDL student)
        {
            student.Password = ClsCrypto.Encrypt(student.Password);

            if (ModelState.IsValid)
            {
                HttpPostedFileBase Imgfile = student.Image;
                if (Imgfile != null)
                {


                    if (!Directory.Exists(Server.MapPath("~/SiteUserContents/Registration/StudentImages/")))
                        Directory.CreateDirectory(Server.MapPath("~/SiteUserContents/Registration/StudentImages/"));

                    CommonHelper.Upload(Imgfile, "~/SiteUserContents/Registration/StudentImages/", Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')));

                    if (!string.IsNullOrEmpty(student.ImageName))
                    {
                        var filePath = Server.MapPath("~/SiteUserContents/Registration/StudentImages/" + student.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    student.ImageName = Imgfile.FileName;
                }
                StudentBAL objStudentBAL = new StudentBAL();
                string Msg = "";
                StringBuilder objMsg = objStudentBAL.RegisterStudent(student);
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
                    return View(student);
                    //  return RedirectToAction(actionName, controllerName, area);
                }
                else
                {
                    ViewBag.Message = "Submitting Form Went Wrong";
                    return View(student);
                }

            }
            else
            {
                return View(student);
            }
        }


        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile()
        {
            StudentMDL obj = new StudentMDL();
            ViewBag.Title = "User Profile";
            obj.FormType = "User Profile";
            ViewBag.VolunteerRegistration = obj;
            StudentBAL objStudentBAL = new StudentBAL();
            var user = Gyanmitras.Common.SiteUserSessionInfo.User as GyanmitrasMDL.User.SiteUserInfoMDL;
            ViewBag.type = "Edit";
            obj = objStudentBAL.GetStudentProfile(user.UserName);
            return View(obj);
        }
        #region post of userprofile
        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile(StudentMDL student)
        {
            ModelState.Remove("ZipCode");
            ModelState.Remove("Password");
            ModelState.Remove("FK_StateId");
            ModelState.Remove("FK_CityId");
            ModelState.Remove("AreaOfInterest");
            ModelState.Remove("AdoptionWish");
            ModelState.Remove("TypeOfEducation");
            ModelState.Remove("CompletionNature");
            ModelState.Remove("UID");
            ModelState.Remove("ConfirmPassword");
            ModelState.Remove("Name");
            ModelState.Remove("languages");
            

            if (ModelState.IsValid)
            {
                HttpPostedFileBase Imgfile = student.Image;
                if (Imgfile != null)
                {


                    if (!Directory.Exists(Server.MapPath("~/SiteUserContents/Registration/StudentImages/")))
                        Directory.CreateDirectory(Server.MapPath("~/SiteUserContents/Registration/StudentImages/"));

                    CommonHelper.Upload(Imgfile, "~/SiteUserContents/Registration/StudentImages/", Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')));

                    if (!string.IsNullOrEmpty(student.ImageName))
                    {
                        var filePath = Server.MapPath("~/SiteUserContents/Registration/StudentImages/" + student.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    student.ImageName = Imgfile.FileName;
                }
                StudentBAL objStudentBAL = new StudentBAL();
                string Msg = "";
                StringBuilder objMsg = objStudentBAL.UpdateStudentProfile(student);
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
                    return View(student);
                    //  return RedirectToAction(actionName, controllerName, area);
                }
                else
                {
                    ViewBag.Message = "Submitting Form Went Wrong";
                    return View(student);
                }

            }
            else
            {
                string Message = string.Join("\n", ModelState.Values
                                       .SelectMany(x => x.Errors)
                                       .Select(x => x.ErrorMessage));
                StudentMDL student1 = new StudentMDL();
               // student1.UID = SessionInfo.User.UserName;
              //  student1.IsActive = true;
                return View("UserProfile", student1);
                // return View(student);
            }
        }
        #endregion

        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult AdoptionRequest()
        {
            StudentMDL obj = new StudentMDL();
            ViewBag.Title = "Adoption Request";

            return View();
        }



        
    }
}