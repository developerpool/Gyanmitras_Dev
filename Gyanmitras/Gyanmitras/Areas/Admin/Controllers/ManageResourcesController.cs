﻿using Gyanmitras.Common;
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
    public class ManageResourcesController : Controller
    {
        //#region 
        private List<SiteUserContantResourceMDL> _UserDatalist;
        SiteUserContantResourceMDL objUserBal = null;
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
            ViewBag.Title = "Management Site Contant Resources";
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
            GetResources();
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
        public PartialViewResult GetResources(int RowPerpage = 10, int CurrentPage = 1, string SearchBy = "", string SearchValue = "")
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            //SiteUserContantResourceMDL objUserMDL = new SiteUserContantResourceMDL();
            //// var accountid = objUserMDL.FK_AccountId;
            //objUserBal.GetUserMstDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType, RowPerpage, CurrentPage, SearchBy, SearchValue);

            objTotalCountPagingMDL = new TotalCountPagingMDL()
            {
                TotalItem = 0,
                ThisMonth = 0,
                LastMonth = 0,
                TotalActive = 0,
                TotalExpiredMonth = 0,
                TotalExpiredSoonMonth = 0,
                TotalInactive = 0,
                RemovedUsers = 0,
                IsTotalItem = true,
                IsTotalActive = true,
                IsTotalInactive = true,
                IsThisMonth = true,
                //IsApprovedCounselor = true,
                //IsLastMonth = true,
                //IsTotalExpiredMonth = true,
                //IsTotalExpiredSoonMonth = true,
                //IsPendingReplyUsers = true,
                //IsRemovedUsers = true,

                IsNotSuperAdmin = true,
            };
            objBasicPagingMDL = new BasicPagingMDL() { CurrentPage = 1, RowParPage = 10, TotalItem = 0, TotalPage = 0 };



            ViewBag.userCheck = SessionInfo.User.UserName;
            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;


            //TempData["ExportData"] = _UserDatalist;
            //TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            return PartialView("_ManageResourcesGrid", _UserDatalist);
        }
        /// <summary>
        /// Update method Of user master 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditManageResources(int id = 0)
        {
            ViewBag.Title = "Management Site Contant Resources";
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            ViewBag.cate = SessionInfo.User.CategoryId;
            ViewBag.logintype = SessionInfo.User.LoginType;
            ViewData["SiteUserRoleList"] = CommonBAL.FillSiteUserRoles();
            ViewData["StateList"] = CommonBAL.GetStateDetailsByCountryId(1);
            ViewData["SearchCategoryList"] = new List<DropDownMDL>() { new DropDownMDL() { ID = 1,Value = "Test Category" } };
            ViewData["SubSearchCategoryList"] = new List<DropDownMDL>() { new DropDownMDL() { ID = 1, Value = "Test Sub Category" } };

            if (id != 0)
            {
                //objUserBal.GetUserMstDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType, 10, 1);
                return View("AddEditManageResources", new List<SiteUserContantResourceMDL>() { new SiteUserContantResourceMDL() });
            }
            else
            {
                SiteUserContantResourceMDL obj = new SiteUserContantResourceMDL();
                obj.IsActive = true;
                return View("AddEditManageResources", obj);
            }
        }
        /// <summary>
        /// Post Method of User master(Insert Data of user master)
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="userMstMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddEditManageResources(SiteUserContantResourceMDL userMstMDL)
        {
            ViewBag.Title = "Management Site Contant Resources";
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
            return RedirectToAction("AddEditManageResources");
        }
        /// <summary>
        /// Delete user by ID 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult DeleteManageResources(int id)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            MessageMDL msg = new MessageMDL();//objUserBal.DeleteUser(id, 1);
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
            List<SiteUserContantResourceMDL> _listForExcel = (List<SiteUserContantResourceMDL>)TempData["ExportData"];
            List<SiteUserContantResourceMDL> _listForExcel_New = new List<SiteUserContantResourceMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.PK_ContantResourceId.ToString() == item));
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
                GetResources(RowPerpage, CurrentPage, SearchBy, SearchValue);
                _listForExcel = (List<SiteUserContantResourceMDL>)TempData["ExportData"];
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
            List<SiteUserContantResourceMDL> _listForExcel = (List<SiteUserContantResourceMDL>)TempData["ExportData_Filtered"];
            _listForExcel.ForEach(e => e.Status = e.IsActive ? "Active" : "Inactive");
            
            string[] columns = { @GyanmitrasLanguages.LocalResources.Resource.AccCategory, @GyanmitrasLanguages.LocalResources.Resource.AccountName, @GyanmitrasLanguages.LocalResources.Resource.UsruserName, @GyanmitrasLanguages.LocalResources.Resource.Role, @GyanmitrasLanguages.LocalResources.Resource.EmailId, @GyanmitrasLanguages.LocalResources.Resource.MobileNo, @GyanmitrasLanguages.LocalResources.Resource.Country, @GyanmitrasLanguages.LocalResources.Resource.State, @GyanmitrasLanguages.LocalResources.Resource.City, @GyanmitrasLanguages.LocalResources.Resource.IsVehicleSpecific, @GyanmitrasLanguages.LocalResources.Resource.Status };
            string MDLAttr = "Categoryname,AccountName,UserName,Rolename,EmailId,MobileNo,CountryName,statename,Cityname,IsVehicleSpecific,Status";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, "User Account", FileType, MDLAttr, columns);
        }
        #endregion Methods
    }
}