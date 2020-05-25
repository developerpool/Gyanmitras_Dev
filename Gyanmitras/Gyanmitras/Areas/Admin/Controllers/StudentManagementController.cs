using Gyanmitras.Common;
using GyanmitrasBAL.Common;
using GyanmitrasMDL;
using GyanmitrasMDL.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace Gyanmitras.Areas.Admin.Controllers
{
    public class StudentManagementController : Controller
    {
       
        //#region 
        private dynamic _StudentDatalist;
        StudentMDL objUserBal = null;
        BasicPagingMDL objBasicPagingMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;
        //public MstUserController()
        //{
        //    objUserBal = new MstUserBAL();
        //}
        //#endregion

       
        // GET: UserMaster
        public ActionResult Index()
        {
            ViewBag.Title = "Student Management";
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            var a = SessionInfo.User;
            if (TempData["Message"] != null)
            {
                ViewBag.Msg = (MessageMDL)TempData["Message"];
                TempData["Message"] = null;
            }
            GetStudents();
            ViewBag.totalcount = objTotalCountPagingMDL;
            return View();
        }
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
        public PartialViewResult GetStudents(int RowPerpage = 10, int CurrentPage = 1, string SearchBy = "", string SearchValue = "")
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            CommonBAL objMDL = new CommonBAL();
            _StudentDatalist = new List<StudentMDL>();
            objMDL.GetSiteUserDetails( out _StudentDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, RowPerpage, CurrentPage, SearchBy, SearchValue, SessionInfo.User.UserId, "", 1, 0);

            //objTotalCountPagingMDL = new TotalCountPagingMDL()
            //{
            //    TotalItem = 0,
            //    ThisMonth = 0,
            //    LastMonth = 0,
            //    TotalActive = 0,
            //    TotalExpiredMonth = 0,
            //    TotalExpiredSoonMonth = 0,
            //    TotalInactive = 0,
            //    ManageFeedBack = 0,
            //    ManageCreiticalSupport = 0,
            //    IsManageFeedBack = true,
            //    IsManageCreiticalSupport = true,
            //    IsTotalItem = true,
            //    IsTotalActive = true,
            //    //IsTotalInactive = true,
            //    //IsThisMonth = true,
            //    //IsApprovedCounselor = true,
            //    //IsLastMonth = true,
            //    //IsTotalExpiredMonth = true,
            //    //IsTotalExpiredSoonMonth = true,
            //    //IsPendingReplyUsers = true,
            //    //IsRemovedUsers = true,

            //    IsNotSuperAdmin = true,
            //};
            //objBasicPagingMDL = new BasicPagingMDL() { CurrentPage = 1, RowParPage = 10, TotalItem = 0, TotalPage = 0 };



            ViewBag.userCheck = SessionInfo.User.UserName;
            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;


            TempData["ExportData"] = _StudentDatalist;
            TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            return PartialView("_StudentManagementGrid", _StudentDatalist);
        }
        /// <summary>
        /// Update method Of user master 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditStudentManagement(int id = 0)
        {
            ViewBag.Title = "Student Management";
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            ViewBag.cate = SessionInfo.User.CategoryId;
            ViewBag.logintype = SessionInfo.User.LoginType;
            ViewData["SiteUserRoleList"] = CommonBAL.FillSiteUserRoles();
            ViewData["StateList"] = CommonBAL.GetStateDetailsByCountryId(1);
            ViewData["SearchCategoryList"] = new List<DropDownMDL>() { new DropDownMDL() { ID = 1, Value = "Test Category" } };
            ViewData["SubSearchCategoryList"] = new List<DropDownMDL>() { new DropDownMDL() { ID = 1, Value = "Test Sub Category" } };

            if (id != 0)
            {
                ViewBag.RoleId = "Admin";
                //objUserBal.GetUserMstDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType, 10, 1);
                return View("AddEditStudentManagement", new List<StudentMDL>() { new StudentMDL() });
            }
            else
            {
                ViewBag.RoleId = "Admin";
                StudentMDL obj = new StudentMDL();
                obj.IsActive = true;
                return View("AddEditStudentManagement", obj);
            }
        }
        /// <summary>
        /// Post Method of User master(Insert Data of user master)
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="userMstMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddEditStudentManagement(StudentMDL userMstMDL)
        {
            ViewBag.Title = "Student Management";
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            try
            {

                userMstMDL.FK_RoleId = SessionInfo.User.RoleId;
                userMstMDL.CreatedBy = SessionInfo.User.UserId;

                //MessageMDL msg = objUserBal.AddEditUser(userMstMDL);
                TempData["Message"] = new MessageMDL();
                return RedirectToAction("Index");

            }
            catch (Exception ex)
            {
            }
            return RedirectToAction("AddEditStudentManagement");
        }
        /// <summary>
        /// Delete user by ID 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult DeleteStudentManagement(Int64 id)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            CommonBAL objMDL = new CommonBAL();
            MessageMDL msg = objMDL.DeleteSiteUser(id, SessionInfo.User.UserId);
            if (msg.MessageId == 1)
            {
                msg.Message = msg.Message;
                //msg.MessageId = 3;
                TempData["Message"] = msg;
                return RedirectToAction("Index");
            }
            else
            {
                msg.Message = msg.Message;
                TempData["Message"] = msg;
                return RedirectToAction("Index");
            }
        }

        /// <summary>
        /// Get State By Country ID using of Common Bal 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="countryid"></param>
        /// <returns></returns>
        public JsonResult getstate(int countryid)
        {
            return Json(CommonBAL.GetStateDetailsByCountryId(countryid), JsonRequestBehavior.AllowGet);
        }
        public JsonResult CheckUser(string username)
        {
            return Json(CommonBAL.CheckUserName(username), JsonRequestBehavior.AllowGet);
        }
        public JsonResult CheckEmailId(string EmailID)
        {
            return Json(CommonBAL.CheckEmailId(EmailID), JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// Get City By StateID Using of Common Bal 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="stateid"></param>
        /// <returns></returns>
        public JsonResult getcity(int stateid)
        {
            return Json(CommonBAL.GetCityDetailsByStateId(stateid), JsonRequestBehavior.AllowGet);
        }
        public JsonResult ChooseFileType(string FileType = "", string choosen_ids = "", string SearchBy = "", string SearchValue = "")
        {
            TempData.Keep();
            List<StudentMDL> _listForExcel = (List<StudentMDL>)TempData["ExportData"];
            List<StudentMDL> _listForExcel_New = new List<StudentMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.PK_StudentID.ToString() == item));
                }
            }
            if (_listForExcel_New.Count > 0)
            {
                TempData["ExportData_Filtered"] = _listForExcel_New;
            }
            else
            {
                int CurrentPage = 1;
                int RowPerpage = string.IsNullOrEmpty(Convert.ToString(TempData["TotalItemCount"])) ? 0 : Convert.ToInt32(Convert.ToString(TempData["TotalItemCount"]));
                GetStudents(RowPerpage, CurrentPage, SearchBy, SearchValue);
                _listForExcel = (List<StudentMDL>)TempData["ExportData"];
                TempData["ExportData_Filtered"] = _listForExcel;
            }

            TempData["FileType"] = FileType;
            return Json(1, JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        ///Purpose:- Export To Excel Or CSV File
        /// </summary>
        /// <returns></returns>
        public FileResult ExportToExcelOrCSV()
        {
            TempData.Keep();
            string FileType = (string)TempData["FileType"];
            List<StudentMDL> _listForExcel = (List<StudentMDL>)TempData["ExportData_Filtered"];
            _listForExcel.ForEach(e => e.Status = e.IsActive ? "Active" : "Inactive");

            string[] columns = {
                "Name",
                "Category Name",
                "Role Name",
                "UID",
                "Password",
                "Address",
                "State Name",
                "City Name",
                "Zip Code",
                "Email ID",
                "Mobile No.",
                "Alternate Mobile No",
                "Created Date Time",
                "Status",
            };
            string MDLAttr =
               "Name,CategoryName,RoleName,UID,Password,Address,StateName,CityName,ZipCode,EmailID,MobileNo,AlternateMobileNo,CreatedDateTime,Status";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, "User Account", FileType, MDLAttr, columns);
        }
        
    }
}