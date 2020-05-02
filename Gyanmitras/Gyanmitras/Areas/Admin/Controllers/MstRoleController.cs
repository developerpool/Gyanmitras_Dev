using GyanmitrasMDL;
using Gyanmitras.Common;
using GyanmitrasBAL.Common;
using GyanmitrasBAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class MstRoleController : BaseController
    {
        #region Declarations
        List<RoleMapping> _FormRoleMappinglist = null;
        MstRoleBAL objMstRoleBAL = null;
        List<MstRoleMDL> _RoleDetaillist = null;
        private BasicPagingMDL objBasicPagingMDL = null;
        TotalCountPagingMDL objTotalCountPagingMDL = null;
        public Int64 CurrentUser = 0;//
        JavaScriptSerializer jss;
        #endregion
        public MstRoleController()
        {
            objMstRoleBAL = new MstRoleBAL();
            jss = new JavaScriptSerializer();
            CurrentUser = SessionInfo.User.UserId;
        }
        // GET: Role
        /// <summary>
        /// To Load The Index Page
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            if (TempData["RoleMessage"] != null)
            {
                ViewBag.Msg = (MessageMDL)TempData["RoleMessage"];
                TempData["RoleMessage"] = null;
            }
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            ViewBag.AdminRole = SessionInfo.User.RoleId > 0 ? true:false;
            getRole();
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            return View();
        }
        /// <summary>
        /// To Get Role Details
        /// </summary>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <param name="RecordPerPage"></param>
        /// <returns></returns>
        public ActionResult getRole(int CurrentPage = 1, string SearchBy = "", string SearchValue = "", int RecordPerPage = 10)
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            ViewBag.AdminRole = SessionInfo.User.RoleId > 0 ? true : false;

            objMstRoleBAL.getRole(out _RoleDetaillist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.fk_companyid, SessionInfo.User.UserId, RecordPerPage, SessionInfo.User.LoginType, CurrentPage, SearchBy, SearchValue);
            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            TempData["ExportDataRole"] = _RoleDetaillist;
            TempData["TotalItemCount"] = objBasicPagingMDL.TotalItem;
            TempData.Keep();
            return PartialView("_RoleGrid", _RoleDetaillist);
        }
        /// <summary>
        /// To Load The Addedit View and To Get VAlues For Edit
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditRole(int id = 0)
        {
            ViewData["Formlist"] = CommonBAL.BindForms().OrderBy(e=>e.Value);
            ViewData["CompanyList"] = CommonBAL.BindAllCompany().OrderBy(e => e.Value);
            ViewData["RoleForlist"] = CommonBAL.BindCategory().OrderBy(e => e.Value);
            ViewData["ParentFormsList"] = CommonBAL.BindParentForms().OrderBy(e => e.Value);
            ViewData["Categorylist"] = CommonBAL.BindCategory();
            if (id != 0)
            {
                objMstRoleBAL.getRole(out _RoleDetaillist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.fk_companyid, SessionInfo.User.UserId, 10, SessionInfo.User.LoginType);

                return View("AddEditRole", _RoleDetaillist[0]);
            }
            else
            {
                MstRoleMDL objMstRoleMDL = new MstRoleMDL();
                objMstRoleMDL.FK_CompanyId = SessionInfo.User.fk_companyid;
                objMstRoleMDL.IsVehicleSpecific = true;

                return View("AddEditRole", objMstRoleMDL);

            }
        }
        /// <summary>
        /// To Add New Roles
        /// </summary>
        /// <param name="ObjMstRoleMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddEditRole(MstRoleMDL ObjMstRoleMDL)
        {
            ViewData["Formlist"] = CommonBAL.BindForms().OrderBy(e => e.Value);
            ViewData["CompanyList"] = CommonBAL.BindAllCompany().OrderBy(e => e.Value);
            ViewData["RoleForlist"] = CommonBAL.BindCategory().OrderBy(e => e.Value);
            ViewData["ParentFormsList"] = CommonBAL.BindParentForms().OrderBy(e => e.Value);
            ViewData["Categorylist"] = CommonBAL.BindCategory();
            MessageMDL msg = new MessageMDL();
            ObjMstRoleMDL.CreatedBy = SessionInfo.User.UserId;
            if (ObjMstRoleMDL.Status == "Active")
            {
                ObjMstRoleMDL.IsActive = true;

            }
            else
            {
                ObjMstRoleMDL.IsActive = false;
            }
           
            if (ModelState.IsValid)
            {

                msg = objMstRoleBAL.AddEditRole(ObjMstRoleMDL);
                TempData["RoleMessage"] = msg;
                return RedirectToAction("Index");
            }
            else
            {
                MstRoleMDL objMstRoleMDL = new MstRoleMDL();
                msg.Message = string.Join("\n", ModelState.Values
                                       .SelectMany(x => x.Errors)
                                       .Select(x => x.ErrorMessage));
                return View("AddEditRole", objMstRoleMDL);
                //return Json(msg, JsonRequestBehavior.AllowGet);
            }
           
        }
     
       
        /// <summary>
        /// To Delete Role Details
        /// </summary>
        /// <param name="PK_RoleId"></param>
        /// <returns></returns>
        public ActionResult DeleteRole(Int64 PK_RoleId)
        {
            MessageMDL msg = objMstRoleBAL.DeleteRole(PK_RoleId, SessionInfo.User.UserId);
            msg.Message = msg.Message;
            TempData["RoleMessage"] = msg;
            return RedirectToAction("Index");

        }
        /// <summary>
        /// To Choose the  File Type and Values To Export
        /// </summary>
        /// <param name="FileType"></param>
        /// <param name="choosen_ids"></param>
        /// <returns></returns>
        public JsonResult ChooseFileType(string FileType = "", string choosen_ids = "", string SearchBy = "", string SearchValue = "")
        {
            TempData.Keep();
            List<MstRoleMDL> _listForExcel = (List<MstRoleMDL>)TempData["ExportDataRole"];
            List<MstRoleMDL> _listForExcel_New = new List<MstRoleMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.PK_RoleId.ToString() == item));
                }
            }
            if (_listForExcel_New.Count > 0)
            {
                TempData["RoleExportData_Filtered"] = _listForExcel_New;
            }
            else
            {
                int CurrentPage = 1;
                int RowPerpage = string.IsNullOrEmpty(Convert.ToString(TempData["TotalItemCount"])) ? 0 : Convert.ToInt32(Convert.ToString(TempData["TotalItemCount"]));
                getRole(CurrentPage, SearchBy, SearchValue, RowPerpage);
                _listForExcel = (List<MstRoleMDL>)TempData["ExportDataRole"];
                TempData["RoleExportData_Filtered"] = _listForExcel;
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
            List<MstRoleMDL> _listForExcel = (List<MstRoleMDL>)TempData["RoleExportData_Filtered"];

            string[] columns = { @GyanmitrasLanguages.LocalResources.Resource.CompanyName, @GyanmitrasLanguages.LocalResources.Resource.RoleName, @GyanmitrasLanguages.LocalResources.Resource.LandingPage, @GyanmitrasLanguages.LocalResources.Resource.CreatedDate, @GyanmitrasLanguages.LocalResources.Resource.Status };
            string MDLAttr = "CompanyName,RoleName,FormName,CreatedDatetime,Status";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, "Role", FileType, MDLAttr, columns);
        }


        /// <summary>
        /// To Bind Roles
        /// </summary>
        /// <param name="FK_CustomerID"></param>
        /// <returns></returns>
        public JsonResult BindRoles(Int64 FK_CustomerID = 0, Int64 AccountId = 0)
        {
            return Json(CommonBAL.FillRoles(FK_CustomerID, AccountId), JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// To Bind The Sub Menu's
        /// </summary>
        /// <param name="FK_RoleId"></param>
        /// <param name="FK_FormId"></param>
        /// <returns></returns>
        public PartialViewResult BindSubMenu(Int64 FK_RoleId, Int64 FK_FormId, string MappingFor, Int64 FK_AccountId, Int64 FK_CustomerId = 0)
        {
            FormRoleViewMDL objFormRoleViewMDL = new FormRoleViewMDL();
            objMstRoleBAL.BindSubMenu(out _FormRoleMappinglist, FK_RoleId, FK_FormId, MappingFor, FK_AccountId, FK_CustomerId);
            objFormRoleViewMDL.Forms = _FormRoleMappinglist;
            return PartialView("_FormRoleMapping", objFormRoleViewMDL);
        }


        /// <summary>
        /// Purpose:-Get Account List By Category  
        /// </summary>
        /// <param name="FK_CategoryId"></param>
        /// <returns></returns>
        public JsonResult BindAccountsByCategory(Int64 CategoryId = 0)
        {
            List<DropDownMDL> objddl = CommonBAL.BindAllAccountsByCategory(CategoryId);
            return Json(objddl, JsonRequestBehavior.AllowGet);
        }
    }
}