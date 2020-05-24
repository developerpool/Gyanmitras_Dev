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
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using System.Configuration;

namespace Gyanmitras.Controllers
{


    //[Authorize]
    [HandleErrorExt]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
    public class CounselorController : BaseController
    {
        CounselorMDL obj = new CounselorMDL();
        BasicPagingMDL objBasicPagingMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;

        [HttpGet]
        [AllowAnonymous]
        [SkipUserCustomAuthenticationAttribute]
        // GET: Counselor
        public ActionResult Index()
        {
            ViewBag.IsAdoptedStudentCounselor = SiteUserSessionInfo.User.IsAdoptedStudentCounselor;
            ViewBag.Title = SiteUserSessionInfo.User.IsAdoptedStudentCounselor ? "Counselor : Adopted Student" : "Counselor : Non-Adopted Student";
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



        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Account Details By Id
        /// </summary>
        /// 
        [HttpPost]
        [SkipUserCustomAuthenticationAttribute]
        public ActionResult StudentAdoption(string PlannedCommunication)
        {

            return View();
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Planned Communication
        /// </summary>
        /// 
        [HttpGet]
        [SkipUserCustomAuthenticationAttribute]
        public JsonResult GetPlannedCommunication(Int64 FK_StudentID)
        {
            StudentBAL obj = new StudentBAL();
            Int64 FK_CounselorID = SiteUserSessionInfo.User.UserId;
            return Json(obj.GetPlannedCommunication(FK_CounselorID, FK_StudentID), JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Add Planned Communication
        /// </summary>
        /// 
        [HttpGet]
        [SkipUserCustomAuthenticationAttribute]
        public JsonResult AddPlannedCommunication(string json_PlanCommunication,string IsAdopt = "false")
        {
            StudentBAL obj = new StudentBAL();
            Int64 FK_CounselorID = SiteUserSessionInfo.User.UserId;

            var objPlannedCommunication = JsonConvert.DeserializeObject<List<SiteUserPlannedCommunication>>(json_PlanCommunication);
            
            return Json(obj.AddPlannedCommunication(objPlannedCommunication, IsAdopt), JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Account Details By Id
        /// </summary>
        /// 
        [HttpGet]
        [SkipUserCustomAuthenticationAttribute]
        public ActionResult StudentAdoption(int id = 0)
        {
            ViewBag.Title = "Counselor Student Adoption";
            if (id != 0)
            {
                
                CommonBAL objMDL = new CommonBAL();
                dynamic _StudentDatalist = new List<StudentMDL>();
                BasicPagingMDL objBasicPagingMDL = new BasicPagingMDL();
                TotalCountPagingMDL objTotalCountPagingMDL = new TotalCountPagingMDL();
                objMDL.GetSiteUserDetails(out _StudentDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, 10, 1, "", "", SiteUserSessionInfo.User.UserId, "counselor", 0, 0, "studentGetByCounselor");
                ViewBag.Registration = _StudentDatalist[0];
                _StudentDatalist[0].FormType = "counselor";
                ViewBag.FormType = "counselor";
                _StudentDatalist[0].JSON_EducationDetails = new JavaScriptSerializer().Serialize(_StudentDatalist[0].EducationDetails);
                _StudentDatalist[0].Declaration = true;
                return View("StudentAdoption", _StudentDatalist[0]);
            }
            else
            {
                //MSTAccountMDL obj = new MSTAccountMDL();
                //obj.FK_CompanyId = SessionInfo.User.fk_companyid;
                //obj.IsActive = true;
                //return View("AddEditAccount", obj);
            }
            StudentMDL obj = new StudentMDL();
            obj.FormType = "counselor";
            ViewBag.FormType = "counselor";
            ViewBag.Registration = obj;
            return View("StudentAdoption");
        }


        public JsonResult GetStudents(int RowPerpage = 100, int CurrentPage = 1, string SearchBy = "", string SearchValue = "", int PK_ID = 0)
        {

            ViewBag.CanAdd = true;
            ViewBag.CanEdit = true;
            ViewBag.CanView = true;
            ViewBag.CanDelete = true;
            //SearchBy = string.IsNullOrEmpty(SearchBy) ? "counselor" : "";
            CommonBAL objMDL = new CommonBAL();
            dynamic _StudentDatalist = new List<StudentMDL>();
            BasicPagingMDL objBasicPagingMDL = new BasicPagingMDL();
            TotalCountPagingMDL objTotalCountPagingMDL = new TotalCountPagingMDL();
            objMDL.GetSiteUserDetails(out _StudentDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, PK_ID, RowPerpage, CurrentPage, SearchBy, SearchValue, SiteUserSessionInfo.User.UserId, "counselor", 0, 0,"counselor");

            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            TempData["ExportData"] = _StudentDatalist;

            Dictionary<string, dynamic> myobj = new Dictionary<string, dynamic>();
            //List<dynamic> myobj = new List<dynamic>();
            myobj.Add("objBasicPagingMDL", objBasicPagingMDL);
            myobj.Add("objTotalCountPagingMDL", objTotalCountPagingMDL);
            myobj.Add("_Datalist", _StudentDatalist);

            return Json(myobj, JsonRequestBehavior.AllowGet);
        }
       
       
        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult Registration(CounselorMDL counselor)
        {
            counselor.Password = ClsCrypto.Encrypt(counselor.Password);

            ViewBag.Title = "Counselor Registration";
            ViewData["RetiredExpertiseDetailsList"] = CommonBAL.BindRetiredExpertiseDetailsList();
            ViewData["EmployedExpertiseDetailsList"] = CommonBAL.BindEmployedExpertiseDetailsList();
            //ViewData["StreamList"] = CommonBAL.BindStreamDetailsList();
            ViewData["StreamListgraduation"] = CommonBAL.GetStream("Graduation");
            ViewData["StreamListpostgraduation"] = CommonBAL.GetStream("PostGraduation");
            ViewData["BoardList"] = CommonBAL.GetBoardType();
            ViewData["YearList"] = CommonBAL.BindYearOfPassingList();


            if (ModelState.IsValid)
            {

                foreach (var item in counselor.AreaOfInterestIds)
                {
                    counselor.AreaOfInterest += item.ToString() + ",";
                }
                counselor.AreaOfInterest = counselor.AreaOfInterest.Substring(0, counselor.AreaOfInterest.LastIndexOf(','));


                HttpPostedFileBase Imgfile = counselor.Image;
                if (Imgfile != null)
                {

                    var filenamemodefied = Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')) +
                                                "__" + DateTime.Now.ToString("ddMMyyyhhmmss") +
                                                Imgfile.FileName.Substring(Imgfile.FileName.LastIndexOf('.'));


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

                    counselor.ImageName = filenamemodefied;
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
                string Message = string.Join("\n", ModelState.Values
                                   .SelectMany(x => x.Errors)
                                   .Select(x => x.ErrorMessage));

                TempData["ErrorMessage"] = "Somthing went wrong!";

                return View(counselor);
            }
        }
        
       
        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile()
        {
            ViewData["RetiredExpertiseDetailsList"] = CommonBAL.BindRetiredExpertiseDetailsList();
            ViewData["EmployedExpertiseDetailsList"] = CommonBAL.BindEmployedExpertiseDetailsList();
            //ViewData["StreamList"] = CommonBAL.BindStreamDetailsList();
            ViewData["StreamListgraduation"] = CommonBAL.GetStream("Graduation");
            ViewData["StreamListpostgraduation"] = CommonBAL.GetStream("PostGraduation");
            ViewData["BoardList"] = CommonBAL.GetBoardType();
            ViewData["YearList"] = CommonBAL.BindYearOfPassingList();
            CounselorMDL obj = new CounselorMDL();
            ViewBag.Title = "User Profile";
            obj.FormType = "User Profile";
            ViewBag.type = "Edit";
            SiteUserSessionInfo.User.IsUpdatedProfileAlert = false;
            CommonBAL objCommonBAL = new CommonBAL();
            dynamic _UserDatalist = new List<CounselorMDL>();
            int RowPerpage = 10;
            int CurrentPage = 1;
            string SearchBy = "";
            string SearchValue = "";
            objCommonBAL.GetSiteUserDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, Convert.ToInt32(SiteUserSessionInfo.User.UserId), RowPerpage, CurrentPage, SearchBy, SearchValue, 0, "counselor", Convert.ToInt32(SiteUserCategory.Counselor), 0);
            obj = _UserDatalist[0];
            obj.ConfirmPassword = obj.Password;
            ViewBag.UserProfile = obj;
            return View(obj);
        }
       
      
        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile(CounselorMDL counselor)
        {
            if (!SiteUserSessionInfo.User.IsUpdatedProfileAlert)
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
                ModelState.Remove("AreaOfInterestIds");
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
            }
            if (ModelState.IsValid)
            {
                counselor.FK_CategoryId = counselor.FK_CategoryId == 0 ? Convert.ToInt32(SiteUserCategory.Counselor) : counselor.FK_CategoryId;
                counselor.FK_RoleId = counselor.FK_RoleId == 0 ? Convert.ToInt32(SiteUserRole.Counselor) : counselor.FK_RoleId;
                counselor.IsActive = true;
                counselor.IsDeleted = false;
                counselor.UpdatedBy = SiteUserSessionInfo.User.UserId;

                HttpPostedFileBase Imgfile = counselor.Image;
                if (Imgfile != null)
                {


                    var filenamemodefied = Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')) +
                                                "__" + DateTime.Now.ToString("ddMMyyyhhmmss") +
                                                Imgfile.FileName.Substring(Imgfile.FileName.LastIndexOf('.'));
                    if (!Directory.Exists(Server.MapPath(ConfigurationManager.AppSettings["CounselorProfilePath"].ToString())))
                        Directory.CreateDirectory(Server.MapPath(ConfigurationManager.AppSettings["CounselorProfilePath"].ToString()));

                    CommonHelper.Upload(Imgfile, ConfigurationManager.AppSettings["CounselorProfilePath"].ToString(), filenamemodefied);

                    if (!string.IsNullOrEmpty(counselor.ImageName))
                    {
                        var filePath = Server.MapPath(ConfigurationManager.AppSettings["CounselorProfilePath"].ToString() + counselor.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    counselor.ImageName = filenamemodefied;
                }

                MessageMDL objMsg = new MessageMDL();
                CommonBAL objCommonBAL = new CommonBAL();
                if (!SiteUserSessionInfo.User.IsUpdatedProfileAlert)
                {
                    //Get Profile
                    dynamic _UserDatalist = new List<VolunteerMDL>();
                    int RowPerpage = 10;
                    int CurrentPage = 1;
                    string SearchBy = "";
                    string SearchValue = "";
                    objCommonBAL.GetSiteUserDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, Convert.ToInt32(SiteUserSessionInfo.User.UserId), RowPerpage, CurrentPage, SearchBy, SearchValue, 0, "counselor", Convert.ToInt32(SiteUserCategory.Counselor), 0);
                    obj = _UserDatalist[0];
                    //End

                    obj.Name = counselor.Name;
                    obj.MobileNo = counselor.MobileNo;
                    obj.AlternateMobileNo = counselor.AlternateMobileNo;
                    obj.Address = counselor.Address;
                    obj.ImageName = counselor.ImageName;
                    obj.Declaration = counselor.Declaration;
                    obj.HavePC = counselor.HavePC;
                    objMsg = objCommonBAL.AddEditSiteUsers(null,obj, null);
                }
                else
                {
                    objMsg = objCommonBAL.AddEditSiteUsers(null, counselor, null);
                }

                if (objMsg.MessageId == 1)
                {
                    ViewData["RetiredExpertiseDetailsList"] = CommonBAL.BindRetiredExpertiseDetailsList();
                    ViewData["EmployedExpertiseDetailsList"] = CommonBAL.BindEmployedExpertiseDetailsList();
                    ViewData["StreamListgraduation"] = CommonBAL.GetStream("Graduation");
                    ViewData["StreamListpostgraduation"] = CommonBAL.GetStream("PostGraduation");
                    ViewData["BoardList"] = CommonBAL.GetBoardType();
                    ViewData["YearList"] = CommonBAL.BindYearOfPassingList();
                    ViewBag.Message = objMsg.Message;

                    if (SiteUserSessionInfo.User.IsUpdatedProfileAlert)
                    {
                        ViewBag.IsProfileFirstTime = true;
                    }
                    else
                    {
                        ViewBag.Redirect = "Yes";

                    }

                    return View(counselor);
                }
                else
                {
                    if (!string.IsNullOrEmpty(counselor.ImageName))
                    {
                        var filePath = Server.MapPath(ConfigurationManager.AppSettings["CounselorProfilePath"].ToString() + counselor.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }
                    ViewBag.Message = objMsg.Message;
                    return View(counselor);
                }

            }
            else
            {
                string Message = string.Join("\n", ModelState.Values
                                       .SelectMany(x => x.Errors)
                                       .Select(x => x.ErrorMessage));
                CounselorMDL counselor1 = new  CounselorMDL();
               
                return View("UserProfile", counselor1);
               
            }
        }
        


    }
}