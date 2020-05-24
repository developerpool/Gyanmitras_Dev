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
using System.Configuration;

namespace Gyanmitras.Controllers
{
    //[Authorize]
    [HandleErrorExt]
    [OutputCache(NoStore = true, Duration = 0, VaryByParam = "*")]
    public class VolunteerController : Controller
    {
        //#region 
        private dynamic _StudentDatalist;
        StudentMDL objUserBal = null;
        BasicPagingMDL objBasicPagingMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;
        VolunteerMDL obj = new VolunteerMDL();
        [HttpGet]
        [AllowAnonymous]
        [SkipUserCustomAuthenticationAttribute]
        // GET: Counselor
        public ActionResult Index()
        {
            return View();
        }


        [HttpGet]
        [AllowAnonymous]
        [SkipUserCustomAuthenticationAttribute]
        public JsonResult GetStudents(int RowPerpage = 100, int CurrentPage = 1, string SearchBy = "", string SearchValue = "", int PK_ID = 0)
        {

            ViewBag.CanAdd = true;
            ViewBag.CanEdit = true;
            ViewBag.CanView = true;
            ViewBag.CanDelete = true;
            //SearchBy = string.IsNullOrEmpty(SearchBy) ? "volunteer" : "suggestedVolunteer";
            CommonBAL objMDL = new CommonBAL();
            _StudentDatalist = new List<StudentMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            objMDL.GetSiteUserDetails(out _StudentDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, PK_ID, RowPerpage, CurrentPage, SearchBy, SearchValue, SiteUserSessionInfo.User.UserId, "volunteer", 0, 0);

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
                CommonBAL objMDL = new CommonBAL();
                _StudentDatalist = new List<StudentMDL>();
                objBasicPagingMDL = new BasicPagingMDL();
                objTotalCountPagingMDL = new TotalCountPagingMDL();
                objMDL.GetSiteUserDetails(out _StudentDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, 10, 1, "", "", SiteUserSessionInfo.User.UserId, "volunteer", 0, 0, "studentGetByVolunteer");
                ViewBag.Registration = _StudentDatalist[0];
                return View("StudentRegistration", _StudentDatalist[0]);
            }
            else
            {
                //MSTAccountMDL obj = new MSTAccountMDL();
                //obj.FK_CompanyId = SessionInfo.User.fk_companyid;
                //obj.IsActive = true;
                //return View("AddEditAccount", obj);
            }
            StudentMDL obj = new StudentMDL();
            ViewBag.FormType = "volunteer";
            ViewBag.Registration = obj;
            return View("StudentRegistration");
        }

        // GET: Counselor
        [HttpGet]
        [UserCustomAuthenticationAttribute]
        public ActionResult Registration()
        {
            ViewBag.Title = "Volunteer Registration";
            ViewBag.FormType = "Volunteer Registration";
            ViewBag.VolunteerRegistration = obj;

            return View(obj);
        }


        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult Registration(VolunteerMDL objVolunteer)
        {
            if (ModelState.IsValid)
            {
                objVolunteer.Password = string.IsNullOrEmpty(objVolunteer.Password) ? "" : ClsCrypto.Encrypt(objVolunteer.Password);

                HttpPostedFileBase Imgfile = objVolunteer.Image;
                if (Imgfile != null)
                {
                    var filenamemodefied = Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')) +
                                            "__" + DateTime.Now.ToString("ddMMyyyhhmmss") +
                                            Imgfile.FileName.Substring(Imgfile.FileName.LastIndexOf('.'));


                    if (!Directory.Exists(Server.MapPath(ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString())))
                        Directory.CreateDirectory(Server.MapPath(ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString()));

                    CommonHelper.Upload(Imgfile, ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString(), Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')));

                    if (!string.IsNullOrEmpty(objVolunteer.ImageName))
                    {
                        var filePath = Server.MapPath(ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString() + objVolunteer.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    objVolunteer.ImageName = filenamemodefied;
                }

                CommonBAL objCommonBAL = new CommonBAL();

                string Msg = "";
                MessageMDL objMsg = objCommonBAL.AddEditSiteUsers(null, null, objVolunteer);
                Msg = objMsg.ToString();

                if (objMsg.MessageId == 1)
                {
                    ViewBag.Message = objMsg.Message;
                    return View(objVolunteer);
                }
                else
                {
                    ViewBag.Message = "Somthing went wrong!";
                    return View(objVolunteer);
                }

            }
            else
            {
                return View(objVolunteer);
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
            ViewBag.FormTypeFormType = "User Profile";
            
            var user = SiteUserSessionInfo.User as GyanmitrasMDL.User.SiteUserInfoMDL;
            ViewBag.type = "Edit";
            SiteUserSessionInfo.User.IsProfilePage = true;
            CommonBAL objCommonBAL = new CommonBAL();
            dynamic _UserDatalist = new List<VolunteerMDL>();
            int RowPerpage = 10;
            int CurrentPage = 1;
            string SearchBy = "";
            string SearchValue = "";
            objCommonBAL.GetSiteUserDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, Convert.ToInt32(SiteUserSessionInfo.User.UserId), RowPerpage, CurrentPage, SearchBy, SearchValue, 0, "volunteer", Convert.ToInt32(SiteUserCategory.Volunteer), 0);
            ViewBag.VolunteerRegistration = obj;

            obj = _UserDatalist[0];
            return View(obj);
        }


        [HttpPost]
        [UserCustomAuthenticationAttribute]
        public ActionResult UserProfile(VolunteerMDL volunteer)
        {

            if (!SiteUserSessionInfo.User.IsUpdatedProfileAlert)
            {
                ModelState.Remove("ZipCode");
                ModelState.Remove("EmailId");
                ModelState.Remove("Password");
                ModelState.Remove("FK_StateId");
                ModelState.Remove("FK_CityId");
                ModelState.Remove("FK_State_AreaOfSearch");
                ModelState.Remove("FK_District_AreaOfSearch");
                ModelState.Remove("UID");
                ModelState.Remove("ConfirmPassword");
                //ModelState.Remove("Name");
                ModelState.Remove("languages");
            }

            if (ModelState.IsValid)
            {
                HttpPostedFileBase Imgfile = volunteer.Image;

                volunteer.FK_CategoryId = volunteer.FK_CategoryId == 0 ? Convert.ToInt32(SiteUserCategory.Volunteer) : volunteer.FK_CategoryId;
                volunteer.FK_RoleId = volunteer.FK_RoleId == 0 ? Convert.ToInt32(SiteUserRole.Volunteer) : volunteer.FK_RoleId;
                volunteer.IsActive = true;
                volunteer.IsDeleted = false;
                volunteer.UpdatedBy = SiteUserSessionInfo.User.UserId;


                if (Imgfile != null)
                {


                    var filenamemodefied = Imgfile.FileName.Substring(0, Imgfile.FileName.LastIndexOf('.')) +
                                                "__" + DateTime.Now.ToString("ddMMyyyhhmmss") +
                                                Imgfile.FileName.Substring(Imgfile.FileName.LastIndexOf('.'));
                    if (!Directory.Exists(Server.MapPath(ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString())))
                        Directory.CreateDirectory(Server.MapPath(ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString()));

                    CommonHelper.Upload(Imgfile, ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString(), filenamemodefied);

                    if (!string.IsNullOrEmpty(volunteer.ImageName))
                    {
                        var filePath = Server.MapPath(ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString() + volunteer.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    volunteer.ImageName = filenamemodefied;
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
                    objCommonBAL.GetSiteUserDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, Convert.ToInt32(SiteUserSessionInfo.User.UserId), RowPerpage, CurrentPage, SearchBy, SearchValue, 0, "volunteer", Convert.ToInt32(SiteUserCategory.Volunteer), 0);
                    obj = _UserDatalist[0];
                    //End

                    obj.Name = volunteer.Name;
                    obj.MobileNo = volunteer.MobileNo;
                    obj.AlternateMobileNo = volunteer.AlternateMobileNo;
                    obj.Address = volunteer.Address;
                    obj.ImageName = volunteer.ImageName;
                    obj.Declaration = volunteer.Declaration;

                    objMsg = objCommonBAL.AddEditSiteUsers(null, null, obj);
                }
                else {
                    objMsg = objCommonBAL.AddEditSiteUsers(null, null, volunteer);
                }

                if (objMsg.MessageId == 1)
                {
                    ViewBag.Message = objMsg.Message;
                    if (SiteUserSessionInfo.User.IsUpdatedProfileAlert)
                    {
                        ViewBag.IsProfileFirstTime = "Yes";
                    }
                    else {
                        ViewBag.Redirect = "Yes";

                    }

                    return View(volunteer);

                }
                else
                {
                    if (!string.IsNullOrEmpty(volunteer.ImageName))
                    {
                        var filePath = Server.MapPath(ConfigurationManager.AppSettings["VolunteerProfilePath"].ToString() + volunteer.ImageName);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }
                    ViewBag.Message = objMsg.Message;
                    return View(volunteer);
                }

            }
            else
            {
                string Message = string.Join("\n", ModelState.Values
                                       .SelectMany(x => x.Errors)
                                       .Select(x => x.ErrorMessage));
                VolunteerMDL volunteer1 = new VolunteerMDL();

                return View("UserProfile", volunteer1);

            }
        }

        
    }
}