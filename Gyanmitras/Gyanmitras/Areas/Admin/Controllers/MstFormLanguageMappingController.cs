
using GyanmitrasMDL;
using Gyanmitras.Common;
using GyanmitrasBAL.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using GyanmitrasBAL;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class MstFormLanguageMappingController : BaseController
    {
        public BasicPagingMDL objBasicPagingMDL = new BasicPagingMDL();
        private readonly MstFormLanguageMappingBAL objFormLanguageMappingBDL;
        private List<MstFormLanguageMappingMDL> _FormLanguageMappingMDL = null;
        TotalCountPagingMDL objTotalCountPagingMDL = null;
        public MstFormLanguageMappingController()
        {
            
            objFormLanguageMappingBDL = new MstFormLanguageMappingBAL();
            _FormLanguageMappingMDL = new List<MstFormLanguageMappingMDL>();
        }

        // GET: FormLanguageMapping
        public ActionResult Index()
        {
            ViewBag.CanAdd  = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            if (TempData["Message"] != null)
            {
                ViewBag.Msg = (MessageMDL)TempData["Message"];
                TempData["Message"] = null;
            }
            GetFormLanguageMappings();
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            return View();
        }


        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        [HttpGet]
        public PartialViewResult GetFormLanguageMappings(int CurrentPage = 1, string SearchBy = "", string SearchValue = "", int RowPerpage = 10)
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            UserInfoMDL objUserInfoMDL = new UserInfoMDL();

            objFormLanguageMappingBDL.GetFormLanguageMappingDetails(out _FormLanguageMappingMDL, out objBasicPagingMDL,out objTotalCountPagingMDL , 0, RowPerpage , CurrentPage, SearchBy, SearchValue, SessionInfo.User.AccountId, SessionInfo.User.FK_CustomerId, SessionInfo.User.UserId, SessionInfo.User.LoginType);
            TempData["ExportData"] = _FormLanguageMappingMDL;
            TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            ViewBag.paging = objBasicPagingMDL;
            return PartialView("_FormLanguageMapping", _FormLanguageMappingMDL);
        }
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Form Language Mapping Details By Id
        /// </summary>
        [HttpGet]
        public ActionResult AddEditFormLanguageMapping(int id = 0)
        {
            ViewData["languagelist"] = CommonBAL.FillLanguages();
            ViewData["formlist"] = CommonBAL.FillForms();
            if (id != 0)
            {
                objFormLanguageMappingBDL.GetFormLanguageMappingDetails(out _FormLanguageMappingMDL, out objBasicPagingMDL,out objTotalCountPagingMDL, id, Convert.ToInt32(10), 1, "", "", SessionInfo.User.AccountId, SessionInfo.User.FK_CustomerId, SessionInfo.User.UserId, SessionInfo.User.LoginType);
                return View("AddEditFormLanguageMapping", _FormLanguageMappingMDL[0]);
            }
            else
            {
                MstFormLanguageMappingMDL obj = new MstFormLanguageMappingMDL();
                obj.FK_AccountID = SessionInfo.User.AccountId;
                obj.FK_CustomerID = SessionInfo.User.FK_CustomerId;
                obj.IsActive = true;
                return View("AddEditFormLanguageMapping", obj);
            }
        }


        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Delete Form Language Mapping Details
        /// </summary>
        public ActionResult DeleteFormLanguageMapping(Int64 id)
        {
            MessageMDL msg = new MessageMDL();
            msg = objFormLanguageMappingBDL.DeleteFormLanguageMapping(id, SessionInfo.User.UserId, SessionInfo.User.fk_companyid);
            TempData["Message"] = msg;
            return RedirectToAction("Index");
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Add / Edit Form Language Mapping Details
        /// </summary>
        public ActionResult AddEditFormLanguageMapping(MstFormLanguageMappingMDL objFormLanguageMappingMDL)
        {
            ViewData["languagelist"] = CommonBAL.FillLanguages();
            ViewData["formlist"] = CommonBAL.FillForms();
            if (ModelState.IsValid)
            {
                objFormLanguageMappingMDL.CreatedBy = SessionInfo.User.UserId;
                objFormLanguageMappingMDL.FK_AccountID = SessionInfo.User.AccountId;
                objFormLanguageMappingMDL.FK_CustomerID = SessionInfo.User.FK_CustomerId;
                MessageMDL msg = new MessageMDL();
                msg = objFormLanguageMappingBDL.AddEditFormLanguageMapping(objFormLanguageMappingMDL);
                TempData["Message"] = msg;
                return RedirectToAction("Index");
            }
            else
            {
                return View();
            }
        }



        public JsonResult ChooseFileType(string FileType = "", string choosen_ids = "", string SearchBy = "", string SearchValue = "")
        {
            TempData.Keep();
            List<MstFormLanguageMappingMDL> _listForExcel = (List<MstFormLanguageMappingMDL>)TempData["ExportData"];
            List<MstFormLanguageMappingMDL> _listForExcel_New = new List<MstFormLanguageMappingMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.PK_FormLanguageId.ToString() == item));
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
                GetFormLanguageMappings(CurrentPage, SearchBy, SearchValue, RowPerpage);
                _listForExcel = (List<MstFormLanguageMappingMDL>)TempData["ExportData"];
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
            List<MstFormLanguageMappingMDL> _listForExcel = (List<MstFormLanguageMappingMDL>)TempData["ExportData_Filtered"];
            string[] columns = {
                @GyanmitrasLanguages.LocalResources.Resource.FormName,
                @GyanmitrasLanguages.LocalResources.Resource.LanguageName,
                @GyanmitrasLanguages.LocalResources.Resource.TranslatedLanguageName,
                @GyanmitrasLanguages.LocalResources.Resource.Status,
                @GyanmitrasLanguages.LocalResources.Resource.CreatedDate
            };
            string MDLAttr = "FormName,LanguageName,TranslatedFormName,IsActive,CreatedDate";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, @GyanmitrasLanguages.LocalResources.Resource.FormLanguageMappingData, FileType, MDLAttr, columns);
        }


    }
}