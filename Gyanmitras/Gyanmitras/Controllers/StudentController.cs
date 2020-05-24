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
using System.Configuration;

namespace Gyanmitras.Controllers
{
    public class StudentController : Controller
    {
        StudentMDL obj= new  StudentMDL();
        BasicPagingMDL objBasicPagingMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;
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
            string controllerName = "";
            string area = "";
            string actionName = "";

            area = "";

            if (student.FormType == "volunteer")
            {
                var uid = Gyanmitras.Common.CommonHelper.RandomString();
                student.UID = "Gyanmitras_"+uid.ToLower();
                var pass = Gyanmitras.Common.CommonHelper.RandomString();
                student.Password = pass.ToCharArray()[0].ToString().ToUpper()+ pass+ "@123";
                controllerName = "Volunteer";
                actionName = "StudentRegistration";
            }
            else
            {
                controllerName = "Home";
                actionName = "Index";
            }
           
            if (student.FormType == "volunteer")
            {
                ModelState.Remove("Password");
                ModelState.Remove("ConfirmPassword");
                ModelState.Remove("AreaOfInterestIds");
                ModelState.Remove("LanguagesIDs");
                ModelState.Remove("TypeOfEducation");
                ModelState.Remove("CompletionNature");
                ModelState.Remove("languages");
            }

            if (ModelState.IsValid)
            {
                if (student.AreaOfInterestIds != null)
                {

                    foreach (var item in student.AreaOfInterestIds)
                    {
                        student.AreaOfInterest += item.ToString() + ",";
                    }
                    student.AreaOfInterest = student.AreaOfInterest.Substring(0, student.AreaOfInterest.LastIndexOf(','));

                }
                else {
                    student.AreaOfInterest = "";
                }

                if (student.LanguagesIDs != null)
                {

                    foreach (var item in student.LanguagesIDs)
                    {
                        student.languages += item.ToString() + ",";
                    }
                    student.languages = student.languages.Substring(0, student.languages.LastIndexOf(','));

                }
                else
                {
                    student.languages = "";
                }

                HttpPostedFileBase Imgfile = student.Image;
                if (Imgfile != null)
                {

                    var filenamemodefied = Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')) +
                            "__" + DateTime.Now.ToString("ddMMyyyhhmmss") +
                            Imgfile.FileName.Substring(Imgfile.FileName.LastIndexOf('.'));

                    if (!Directory.Exists(Server.MapPath(ConfigurationManager.AppSettings["StudentProfilePath"].ToString())))
                        Directory.CreateDirectory(Server.MapPath(ConfigurationManager.AppSettings["StudentProfilePath"].ToString()));

                    CommonHelper.Upload(Imgfile, ConfigurationManager.AppSettings["StudentProfilePath"].ToString(), filenamemodefied);

                    if (!string.IsNullOrEmpty(student.ImageName))
                    {
                        var filePath = Server.MapPath(ConfigurationManager.AppSettings["StudentProfilePath"].ToString() + student.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    student.ImageName = filenamemodefied;
                }
                CommonBAL objCommonBAL = new CommonBAL();
                student.FK_CategoryId = student.FK_CategoryId == 0 ? Convert.ToInt32(SiteUserCategory.Student) : student.FK_CategoryId;
                student.FK_RoleId = student.FK_RoleId == 0 ? Convert.ToInt32(SiteUserRole.Non_Adopted_Student) : student.FK_RoleId;
                student.IsActive = true;
                student.IsDeleted = false;
                student.CreatedBy = SiteUserSessionInfo.User.UserId;

                MessageMDL objMsg = objCommonBAL.AddEditSiteUsers(student, null, null);
                
                if (objMsg.MessageId == 1)
                {

                    TempData["Message"] = objMsg.Message;
                    if (student.FormType == "volunteer")
                    {
                        ViewBag.FormType = "volunteer";
                        if (objMsg.ReturnInfo != null)
                        {
                            //string typereg = obj.FK_CategoryId == (int)SiteUserCategory.Volunteer ? "Volunteer" :
                            //     (obj.FK_CategoryId == (int)SiteUserCategory.Counselor ? "Counselor" :
                            //     (obj.FK_CategoryId == (int)SiteUserCategory.Student ? "Student" : "Student"));
                            #region User mail after registration
                            string verifiynowlink = "<a href='" + ConfigurationManager.AppSettings["SitePath"].ToString() + "Home/Register?registerfor=Student&Pk_UserId=" + objMsg.ReturnInfo + "&Pk_CreatedId=" + SiteUserSessionInfo.User.UserId + "'> Verifiy Now </a>";
                            string mailbody =
                                "Dear <b>" + student.Name + "</b>,<br/>" +
                                "Your are registerd on www.Gyanmitras.com as a student by a volunteer, please verifiy your registration on this link ("+verifiynowlink+"). <br/>" +
                                "<br/>" +

                                "User ID : <b>" + student.UID + "</b><br/>" +
                                "Password : <b>" + student.Password + "</b><br/><br/>" +

                                "<b>Note : Please don't share your User Id & Password to any one, also you can change your credentials after verification.</b><br/><br/>" +

                                "Regards,<br/>" +
                                "Web Master www.gyanmitras.com <br/>";
                            Dictionary<int, string> email_dic = new Dictionary<int, string>();
                            email_dic.Add(1, student.EmailID);
                            bool send = Mail.SendEmail("Gyanmitras Registration", mailbody, email_dic);
                            #endregion
                        }
                    }
                    else {
                        ViewBag.FormType = "";
                    }
                    
                }
                else
                {
                    TempData["Message"] = objMsg.Message;
                }

            }
            else
            {
                string Message = string.Join("\n", ModelState.Values
                                    .SelectMany(x => x.Errors)
                                    .Select(x => x.ErrorMessage));

                TempData["ErrorMessage"] = "Somthing went wrong!";
                
            }
            return View(student);
            //return RedirectToAction(actionName, controllerName, area);
        }


        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile()
        {
            StudentMDL obj = new StudentMDL();
            ViewBag.Title = "User Profile";
            obj.FormType = "User Profile";
            StudentBAL objStudentBAL = new StudentBAL();
            var user = Gyanmitras.Common.SiteUserSessionInfo.User as GyanmitrasMDL.User.SiteUserInfoMDL;
            ViewBag.type = "Edit";
            SiteUserSessionInfo.User.IsProfilePage = true;
            CommonBAL objCommonBAL = new CommonBAL();
            dynamic _UserDatalist = new List<StudentMDL>();
            int RowPerpage = 10;
            int CurrentPage = 1;
            string SearchBy = "";
            string SearchValue = "";
            objCommonBAL.GetSiteUserDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, Convert.ToInt32(SiteUserSessionInfo.User.UserId), RowPerpage, CurrentPage, SearchBy, SearchValue, 0, "student", Convert.ToInt32(SiteUserCategory.Student), 0);
            

            obj = _UserDatalist[0];
            ViewBag.UserProfile = obj;
            return View(obj);
        }
      
        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile(StudentMDL student)
        {

            if (!SiteUserSessionInfo.User.IsUpdatedProfileAlert)
            {
                ModelState.Remove("LanguagesIDs");
                ModelState.Remove("AreaOfInterestIds");
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
            }

            if (ModelState.IsValid)
            {

                

                HttpPostedFileBase Imgfile = student.Image;
                if (Imgfile != null)
                {

                    var filenamemodefied = Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')) +
                            "__" + DateTime.Now.ToString("ddMMyyyhhmmss") +
                            Imgfile.FileName.Substring(Imgfile.FileName.LastIndexOf('.'));

                    if (!Directory.Exists(Server.MapPath(ConfigurationManager.AppSettings["StudentProfilePath"].ToString())))
                        Directory.CreateDirectory(Server.MapPath(ConfigurationManager.AppSettings["StudentProfilePath"].ToString()));

                    CommonHelper.Upload(Imgfile, ConfigurationManager.AppSettings["StudentProfilePath"].ToString(), filenamemodefied);

                    if (!string.IsNullOrEmpty(student.ImageName))
                    {
                        var filePath = Server.MapPath(ConfigurationManager.AppSettings["StudentProfilePath"].ToString() + student.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    student.ImageName = filenamemodefied;
                }
                
                CommonBAL objCommonBAL = new CommonBAL();
                MessageMDL objMsg = new MessageMDL();
                if (!SiteUserSessionInfo.User.IsUpdatedProfileAlert)
                {
                    //Get Profile
                    dynamic _UserDatalist = new List<VolunteerMDL>();
                    int RowPerpage = 10;
                    int CurrentPage = 1;
                    string SearchBy = "";
                    string SearchValue = "";
                    objCommonBAL.GetSiteUserDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, Convert.ToInt32(SiteUserSessionInfo.User.UserId), RowPerpage, CurrentPage, SearchBy, SearchValue, 0, "student", Convert.ToInt32(SiteUserCategory.Student), 0);

                    obj = _UserDatalist[0];
                    //End

                    obj.Name = student.Name;
                    obj.MobileNo = student.MobileNo;
                    obj.AlternateMobileNo = student.AlternateMobileNo;
                    obj.Address = student.Address;
                    obj.ImageName = student.ImageName;
                    obj.Declaration = student.Declaration;
                    obj.HaveSmartPhone = student.HaveSmartPhone;
                    obj.HavePC = student.HavePC;

                    objMsg = objCommonBAL.AddEditSiteUsers(obj, null, null);
                }
                else
                {
                    student.FK_CategoryId = student.FK_CategoryId == 0 ? Convert.ToInt32(SiteUserCategory.Student) : student.FK_CategoryId;
                    student.FK_RoleId = student.FK_RoleId == 0 ? Convert.ToInt32(SiteUserRole.Non_Adopted_Student) : student.FK_RoleId;
                    student.IsActive = true;
                    student.IsDeleted = false;
                    student.UpdatedBy = SiteUserSessionInfo.User.UserId;

                    foreach (var item in student.AreaOfInterestIds)
                    {
                        student.AreaOfInterest += item.ToString() + ",";
                    }
                    student.AreaOfInterest = student.AreaOfInterest.Substring(0, student.AreaOfInterest.LastIndexOf(','));


                    foreach (var item in student.LanguagesIDs)
                    {
                        student.languages += item.ToString() + ",";
                    }
                    student.languages = student.languages.Substring(0, student.languages.LastIndexOf(','));

                    List<SiteUserEducationDetailsMDL> MyEducationDetails = new List<SiteUserEducationDetailsMDL>();

                    if (student.TypeOfEducation == "Secondry")
                    {
                        MyEducationDetails.Add(new SiteUserEducationDetailsMDL() {
                            TypeOfEducation = student.TypeOfEducation,
                            Class = student.Current_Education_subcategory,
                            FK_BoardID = Convert.ToInt32(student.BoardType),
                            NatureOFCompletion = student.CompletionNature,
                            Percentage = Convert.ToDecimal(student.Percentage),
                            FK_Previous_Class_Board = Convert.ToInt32(student.PreviousBoardType),
                            Previous_Class_Percentage = Convert.ToDecimal(student.PreviousclassPercentage),
                        });
                    }
                    else if (student.TypeOfEducation == "Higher Secondry")
                    {
                        MyEducationDetails.Add(new SiteUserEducationDetailsMDL()
                        { 
                            TypeOfEducation = student.TypeOfEducation,
                            Class = student.Current_Education_subcategory,
                            FK_BoardID = Convert.ToInt32(student.BoardType),
                            FK_StreamID = Convert.ToInt32(student.StreamType),
                            NatureOFCompletion = student.CompletionNature,
                            Percentage = Convert.ToDecimal(student.Percentage),
                            FK_Previous_Class_Board = Convert.ToInt32(student.PreviousBoardType),
                            Previous_Class_Percentage = Convert.ToDecimal(student.PreviousclassPercentage),
                        });
                    }
                    else if (student.TypeOfEducation == "Graduation")
                    {
                        MyEducationDetails.Add(new SiteUserEducationDetailsMDL()
                        {
                            TypeOfEducation = student.TypeOfEducation,
                            UniversityName = student.UniversityName,
                            FK_StreamID = Convert.ToInt32(student.StreamType),
                            NatureOFCompletion = student.CompletionNature,
                            Percentage = Convert.ToDecimal(student.Percentage),
                            FK_Previous_Class_Board = Convert.ToInt32(student.PreviousBoardType),
                            Previous_Class_Percentage = Convert.ToDecimal(student.PreviousclassPercentage),
                        });
                    }

                    student.EducationDetails = MyEducationDetails; 
                    objMsg = objCommonBAL.AddEditSiteUsers(student, null, null);
                }


                if (objMsg.MessageId == 1)
                {
                    ViewBag.Message = objMsg.Message;
                    if (SiteUserSessionInfo.User.IsUpdatedProfileAlert)
                    {
                        ViewBag.IsProfileFirstTime = "Yes";
                    }
                    else
                    {
                        ViewBag.Redirect = "Yes";

                    }
                    return View(student);
                }
                else
                {
                    if (!string.IsNullOrEmpty(student.ImageName))
                    {
                        var filePath = Server.MapPath(ConfigurationManager.AppSettings["StudentProfilePath"].ToString() + student.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }
                    ViewBag.Message = objMsg.Message;
                    return View(student);
                }

            }
            else
            {
                string Message = string.Join("\n", ModelState.Values
                                       .SelectMany(x => x.Errors)
                                       .Select(x => x.ErrorMessage));
                StudentMDL student1 = new StudentMDL();
                return View("UserProfile", student1);
            }
        }
        
        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult AdoptionRequest()
        {
            StudentMDL obj = new StudentMDL();
            ViewBag.Title = "Adoption Request";

            return View();
        }


        public JsonResult GetPlannedCommunication(Int64 FK_StudentID)
        {
            StudentBAL obj = new StudentBAL();
            Int64 FK_CounselorID = 0;
            string LoginType = "student";
            return Json(obj.GetPlannedCommunication(FK_CounselorID, FK_StudentID, LoginType), JsonRequestBehavior.AllowGet);
        }



    }
}