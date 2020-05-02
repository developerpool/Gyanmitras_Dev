using Gyanmitras.Common;
using GyanmitrasBAL;
using GyanmitrasBAL.Common;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class MSTUserAccountMappingController : BaseController
    {
        private BasicPagingMDL objBasicPagingMDL = null;
        private List<MSTUserAccountMappingMDL> _UserAccountMappinglist;
        public MSTUserAccountMappingBAL objMSTUserAccountMappingBAL = null;
        TotalCountPagingMDL objTotalCountPagingMDL = null;
        MSTUserAccountMappingMDL objMSTUserAccountMappingMDL = null;
        MessageMDL Msg = null;
        public MSTUserAccountMappingController()
        {
            objMSTUserAccountMappingBAL = new MSTUserAccountMappingBAL();
        }
        // GET: MSTUserAccountMapping
        public ActionResult Index()
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            if (TempData["Message"] != null)
            {
                ViewBag.Msg = (MessageMDL)TempData["Message"];
            }
            TempData["Message"] = null;
            GetMSTUserAccountMappingDetails();
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            return View();
        }


        /// <summary>
        ///  Purpose:-Get User Account Mapping Details For Paging 
        /// </summary>
        /// <param name="CurrentPage"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        [HttpGet]
        public PartialViewResult GetMSTUserAccountMappingDetails(int CurrentPage = 1, int RowPerpage = 10, string SearchBy = "", string SearchValue = "")
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            objMSTUserAccountMappingBAL.GetMSTUserAccountMappingDetails(out _UserAccountMappinglist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType, RowPerpage, CurrentPage, SearchBy, SearchValue);
            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            TempData["ExportUserAccountMappingData"] = _UserAccountMappinglist;
            return PartialView("_MapMSTUserAccountGrid", _UserAccountMappinglist);
        }

        /// <summary>
        /// Purpose:-Get User Account Mapping Details by Id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditMSTUserAccountMapping(Int64 id = 0)
        {
            ViewData["UserList"] = CommonBAL.BindUsers(SessionInfo.User.AccountId, SessionInfo.User.UserId);
            ViewData["Category"] = CommonBAL.BindCategory();
            if (id != 0)
            {
                objMSTUserAccountMappingBAL.GetMSTUserAccountMappingDetails(out _UserAccountMappinglist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType, 10, 1, "", "");
                return View("AddEditMSTUserAccountMapping", _UserAccountMappinglist[0]);
            }
            else
            {
                objMSTUserAccountMappingMDL = new MSTUserAccountMappingMDL();
                objMSTUserAccountMappingMDL.FK_UserId = SessionInfo.User.UserId;
                return View("AddEditMSTUserAccountMapping", objMSTUserAccountMappingMDL);
            }
        }

        /// <summary>
        /// Purpose:-Edit/Insert User Account Mapping
        /// </summary>
        /// <param name="objUserAccountMappingMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddEditMSTUserAccountMapping(MSTUserAccountMappingMDL objMSTUserAccountMappingMDL)
        {
            Msg = new MessageMDL();
            string StrAccountIds = string.Empty;
            StrAccountIds = string.Join(",", objMSTUserAccountMappingMDL.FK_AccountIDs);
            objMSTUserAccountMappingMDL.AllAcountIDs = StrAccountIds;
            objMSTUserAccountMappingMDL.UserId = SessionInfo.User.UserId;
            objMSTUserAccountMappingMDL.CustomerId = SessionInfo.User.FK_CustomerId;
            objMSTUserAccountMappingMDL.LoginType = SessionInfo.User.LoginType;
            Msg = objMSTUserAccountMappingBAL.AddEditMSTUserAccountMapping(objMSTUserAccountMappingMDL);
            TempData["Message"] = Msg;
            return RedirectToAction("Index");
        }

        /// <summary>
        /// Purpose:-Get Account By Category  List
        /// </summary>
        /// <param name="FK_CategoryId"></param>
        /// <returns></returns>
        public JsonResult GetAccountListByCategory(Int64 FK_CategoryId = 0, Int64 Fk_UserId = 0)
        {
            List<DropDownMDL> objddl = CommonBAL.BindAccountsByCategoryWithAlreadyExist(FK_CategoryId, Fk_UserId); 

            return Json(objddl, JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// Delete User Account Mapping
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public ActionResult DeleteMSTUserAccountMapping(Int64 id = 0)
        {
            TempData["Message"] = null;
            Msg = new MessageMDL();
            objMSTUserAccountMappingMDL = new MSTUserAccountMappingMDL();
            objMSTUserAccountMappingMDL.UserId = SessionInfo.User.UserId;
            Msg = objMSTUserAccountMappingBAL.DeleteMSTUserAccountMapping(id, objMSTUserAccountMappingMDL.UserId);
            TempData["Message"] = Msg;
            return RedirectToAction("Index");
        }

        /// <summary>
        /// Purpose:-Choose Which Type of Files You Want To  Export(Either Excel Or CSV File)
        /// </summary>
        /// <param name="FileType"></param>
        /// <returns></returns>
        public JsonResult ChooseFileType(string FileType = "",string choosen_ids="", string SearchBy = "", string SearchValue="")
        {
            TempData.Keep();
            List<MSTUserAccountMappingMDL> _listForExcel = (List<MSTUserAccountMappingMDL>)TempData["ExportUserAccountMappingData"];
            List<MSTUserAccountMappingMDL> _listForExcel_New = new List<MSTUserAccountMappingMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.PK_Map_UserAccountId.ToString() == item));
                }
            }
            if (_listForExcel_New.Count > 0)
            {
                TempData["ExportUserAccountMappingData_Filtered"] = _listForExcel_New;
            }
            else
            {
                int CurrentPage = 1;
                int RowPerpage = string.IsNullOrEmpty(Convert.ToString(TempData["TotalItemCount"])) ? 0 : Convert.ToInt32(Convert.ToString(TempData["TotalItemCount"]));
                GetMSTUserAccountMappingDetails(CurrentPage, RowPerpage, SearchBy, SearchValue);
                _listForExcel = (List<MSTUserAccountMappingMDL>)TempData["ExportUserAccountMappingData"];
                TempData["ExportUserAccountMappingData_Filtered"] = _listForExcel;
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
            List<MSTUserAccountMappingMDL> _listForExcel = (List<MSTUserAccountMappingMDL>)TempData["ExportUserAccountMappingData_Filtered"];
            string[] columns = { @GyanmitrasLanguages.LocalResources.Resource.AccCategory, @GyanmitrasLanguages.LocalResources.Resource.AccountName, @GyanmitrasLanguages.LocalResources.Resource.UsruserName, @GyanmitrasLanguages.LocalResources.Resource.RoleName, @GyanmitrasLanguages.LocalResources.Resource.Status};
            string MDLAttr = "AccountCategory,AccountName,UserName,RoleName,Status";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, "User Account Mapping", FileType, MDLAttr, columns);
        }
       
    }
}



