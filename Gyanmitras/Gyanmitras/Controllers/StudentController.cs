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


                    if (!Directory.Exists(Server.MapPath("~/App_Doc/User/StudentImages/")))
                        Directory.CreateDirectory(Server.MapPath("~/App_Doc/User/StudentImages/"));

                    CommonHelper.Upload(Imgfile, "~/App_Doc/User/StudentImages/", Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')));

                    if (!string.IsNullOrEmpty(student.ImageName))
                    {
                        var filePath = Server.MapPath("~/App_Doc/User/StudentImages/" + student.ImageName);
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

                    string controllerName = "";
                    string area = "";
                    string actionName = "";

                    area = "";
                    actionName = "Index";
                    controllerName = "Student";



                    //SiteUserSessionInfo.User.LandingPageURL = (!string.IsNullOrEmpty(area) ? area + "/" : "") + controllerName + "/" + actionName;
                    return RedirectToAction(actionName, controllerName, area);
                }
                else
                {
                    ViewBag.Message = "Submitting Form Went Wrong";
                    return View(student);
                }

            }
            else
            {

                ////ViewBag.Message = objMsg.Message;
                return View(student);
            }
        }
    }
}