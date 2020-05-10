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
    public class SiteUsersController : Controller
    {


        //#region 
        private dynamic _UserDatalist;
        SiteUserMDL objUserMDL = null;
        BasicPagingMDL objBasicPagingMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;
        //public MstUserController()
        //{
        //    objUserBal = new MstUserBAL();
        //}
        //#endregion

        #region Methods
        // GET: UserMaster
        public ActionResult Index()
        {
            ViewBag.Title = "Site User Management";
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
            GetUsersMst();
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
        public PartialViewResult GetUsersMst(int RowPerpage = 10, int CurrentPage = 1, string SearchBy = "", string SearchValue = "")
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            CommonBAL objMDL = new CommonBAL();
            _UserDatalist = new List<SiteUserMDL>();
            objMDL.GetSiteUserDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, RowPerpage, CurrentPage, SearchBy, SearchValue, SessionInfo.User.UserId, "admin", 0, 0);


            //objTotalCountPagingMDL = new TotalCountPagingMDL()
            //{
            //    TotalItem = 0,
            //    ThisMonth = 0,
            //    LastMonth = 0,
            //    TotalActive = 0,
            //    TotalExpiredMonth = 0,
            //    TotalExpiredSoonMonth = 0,
            //    TotalInactive = 0,
            //    RemovedUsers = 0,
            //    //IsTotalItem = true,
            //    //IsTotalActive = true,
            //    //IsTotalInactive = true,
            //    //IsThisMonth = true,
            //    //IsLastMonth = true,
            //    //IsTotalExpiredMonth = true,
            //    //IsTotalExpiredSoonMonth = true,
            //    IsPendingReplyUsers = true,
            //    IsRemovedUsers = true,

            //    IsNotSuperAdmin = true,
            //};
            //objBasicPagingMDL = new BasicPagingMDL() { CurrentPage = 1, RowParPage = 10, TotalItem = 0, TotalPage = 0 };



            ViewBag.userCheck = SessionInfo.User.UserName;
            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;


            TempData["ExportData"] = _UserDatalist;
            TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            return PartialView("_SiteUserGrid", _UserDatalist);
        }
        /// <summary>
        /// Update method Of user master 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditUser(int id = 0)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            ViewBag.cate = SessionInfo.User.CategoryId;
            ViewBag.logintype = SessionInfo.User.LoginType;
            ViewData["countrylist"] = CommonBAL.GetCountryList();

            if (id != 0)
            {
                //objUserBal.GetUserMstDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType, 10, 1);
                return View("AddEditUser", new List<SiteUserMDL>() { new SiteUserMDL() });
            }
            else
            {
                SiteUserMDL obj = new SiteUserMDL();
                obj.IsActive = true;
                return View("AddEditUser", obj);
            }
        }
       
        /// <summary>
        /// Delete user by ID 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult DeleteUser(Int64 id,bool recover)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            CommonBAL objMDL = new CommonBAL();
            MessageMDL msg = objMDL.DeleteSiteUser(id,SessionInfo.User.UserId,recover);
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
            List<SiteUserMDL> _listForExcel = (List<SiteUserMDL>)TempData["ExportData"];
            List<SiteUserMDL> _listForExcel_New = new List<SiteUserMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.Pk_UserId.ToString() == item));
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
                GetUsersMst(RowPerpage, CurrentPage, SearchBy, SearchValue);
                _listForExcel = (List<SiteUserMDL>)TempData["ExportData"];
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
            List<SiteUserMDL> _listForExcel = (List<SiteUserMDL>)TempData["ExportData_Filtered"];
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
        #endregion Methods
    }
}