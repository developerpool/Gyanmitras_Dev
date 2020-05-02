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
    public class FormAccountMappingController : BaseController
    {
        private BasicPagingMDL objBasicPagingMDL = null;
        private List<FormAccountMappingMDL> _FormAccountMappinglist;
        FormAccountMappingBAL objFormAccountMappingBAL = null;
        TotalCountPagingMDL objTotalCountPagingMDL = null;
        FormAccountMappingMDL objFormAccountMappingMDL = null;
        MessageMDL Msg = null;
        public FormAccountMappingController()
        {
            objFormAccountMappingBAL = new FormAccountMappingBAL();
        }
        // GET: FormAccountMapping

        /// <summary>
        ///  Purpose:-Return Index View  
        /// </summary>
        /// <returns></returns>
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
            GetFormAccountMappingDetails();
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            return View();
        }

        /// <summary>
        ///  Purpose:-Get Form Account mapping Details For Paging 
        /// </summary>
        /// <param name="CurrentPage"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        [HttpGet]
        public PartialViewResult GetFormAccountMappingDetails(int CurrentPage = 1, int RowPerpage = 10, string SearchBy = "", string SearchValue = "")
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            objFormAccountMappingBAL.GetFormAccountMappingDetails(out _FormAccountMappinglist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType, RowPerpage, CurrentPage, SearchBy, SearchValue);
            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            TempData["ExportFormAccountMappingData"] = _FormAccountMappinglist;
            TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            return PartialView("_MapFormAccountGrid", _FormAccountMappinglist);
        }

        /// <summary>
        /// Purpose:-Get Form Account Mapping Details by Id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditFormAccountMapping(Int64 id = 0)
        {
            ViewData["Form"] = CommonBAL.BindForms();
            ViewData["Category"] = CommonBAL.BindCategory();
            if (id != 0)
            {
                objFormAccountMappingBAL.GetFormAccountMappingDetails(out _FormAccountMappinglist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType, 10, 1, "", "");
                return View("AddEditFormAccountMapping", _FormAccountMappinglist[0]);
            }
            else
            {
                objFormAccountMappingMDL = new FormAccountMappingMDL();
                return View("AddEditFormAccountMapping", objFormAccountMappingMDL);
            }
        }

        /// <summary>
        /// Purpose:-Edit/Insert Form Account Mapping
        /// </summary>
        /// <param name="objUserAccountMappingMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddEditFormAccountMapping(FormAccountMappingMDL objFormAccountMappingMDL)
        {
            Msg = new MessageMDL();
            objFormAccountMappingMDL.UserId = SessionInfo.User.UserId;
            objFormAccountMappingMDL.CustomerId = SessionInfo.User.FK_CustomerId;
            objFormAccountMappingMDL.LoginType = SessionInfo.User.LoginType;
            Msg = objFormAccountMappingBAL.AddEditFormAccountMapping(objFormAccountMappingMDL);
            TempData["Message"] = Msg;
            return RedirectToAction("Index");
        }

        /// <summary>
        /// Purpose:-Get Account List By Category  
        /// </summary>
        /// <param name="FK_CategoryId"></param>
        /// <returns></returns>
        public JsonResult GetAccountListByCategory(Int64 FK_CategoryId = 0)
        {
            List<DropDownMDL> objddl = CommonBAL.BindAccountsByCategory(FK_CategoryId);
            return Json(objddl, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Delete Form Account Mapping
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public ActionResult DeleteFormAccountMapping(Int64 Id = 0)
        {
            TempData["Message"] = null;
            Msg = new MessageMDL();
            objFormAccountMappingMDL = new FormAccountMappingMDL();
            objFormAccountMappingMDL = new FormAccountMappingMDL();
            objFormAccountMappingMDL.UserId = SessionInfo.User.UserId;
            Msg = objFormAccountMappingBAL.DeleteFormAccountMapping(Id, objFormAccountMappingMDL.UserId);
            TempData["Message"] = Msg;
            return RedirectToAction("Index");
        }

        /// <summary>
        /// Purpose:-Choose Which Type of Files You Want To  Export(Either Excel Or CSV File)
        /// </summary>
        /// <param name="FileType"></param>
        /// <returns></returns>
        public JsonResult ChooseFileType(string FileType = "", string choosen_ids = "",string SearchBy="",string SearchValue="")
        {
            TempData.Keep();
            List<FormAccountMappingMDL> _listForExcel = (List<FormAccountMappingMDL>)TempData["ExportFormAccountMappingData"];
            List<FormAccountMappingMDL> _listForExcel_New = new List<FormAccountMappingMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.PK_Map_FormAccountId.ToString() == item));
                }
            }
            if (_listForExcel_New.Count > 0)
            {
                TempData["ExportFormAccountMappingData_Filtered"] = _listForExcel_New;
            }
            else
            {
                int CurrentPage = 1;
                int RowPerpage = string.IsNullOrEmpty(Convert.ToString(TempData["TotalItemCount"])) ? 0 : Convert.ToInt32(Convert.ToString(TempData["TotalItemCount"]));
                GetFormAccountMappingDetails(CurrentPage, RowPerpage, SearchBy, SearchValue);
                _listForExcel = (List<FormAccountMappingMDL>)TempData["ExportFormAccountMappingData"];
                TempData["ExportFormAccountMappingData_Filtered"] = _listForExcel;
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
            List<FormAccountMappingMDL> _listForExcel = (List<FormAccountMappingMDL>)TempData["ExportFormAccountMappingData_Filtered"];
            string[] columns = {@GyanmitrasLanguages.LocalResources.Resource.FormName, @GyanmitrasLanguages.LocalResources.Resource.AccCategory, @GyanmitrasLanguages.LocalResources.Resource.AccountName, @GyanmitrasLanguages.LocalResources.Resource.Status};
            string MDLAttr = "FormName,AccountCategory,AccountName,Status";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, "Form Account Mapping", FileType, MDLAttr, columns);
        }   
    }
}