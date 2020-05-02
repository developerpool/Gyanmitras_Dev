using Gyanmitras.Common;
using GyanmitrasBAL;
using GyanmitrasBAL.Common;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class MstFormController : BaseController
    {
        #region => Fields 
        MstFormBAL objFormMasterBal = null;
        CommonBAL objCommonBAL = null;
        private List<MstFormMDL> _MstFormlist;
        BasicPagingMDL objBasicPagingMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;
        MessageMDL objMessages = null;
        private static int _TotalItem = 0;
        #endregion

        /// <summary>
        /// Constructor functionality is used to initializes objects.
        /// </summary>
        public MstFormController()
        {
            objFormMasterBal = new MstFormBAL();
            objCommonBAL = new CommonBAL();
        }
        public ActionResult Index()
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            if (TempData["Message"] != null)
            {
                ViewBag.Message = (MessageMDL)TempData["Message"];
            }

            GetForms();
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            return View(ViewBag.TotalCountPaging);
        }

        /// <summary>
        /// CREATED DATE : 11 Dec 2019
        /// PURPOSE : Get Form Master Details.
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        [HttpGet]
        public PartialViewResult GetForms(int CurrentPage = 1, int RowPerpage = 10, string SearchBy = "", string SearchValue = "")
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            // MstFormMDL objMstFormMDL = new MstFormMDL();
            objFormMasterBal.GetFormsDetails(out _MstFormlist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, RowPerpage, CurrentPage, SearchBy, SearchValue.TrimStart().TrimEnd());
            _TotalItem = objBasicPagingMDL.TotalItem;
            ViewBag.paging = objBasicPagingMDL;
            TempData["ExportData"] = _MstFormlist;
            return PartialView("_getFormDetailGrid", _MstFormlist);
        }

        /// <summary>
        /// CREATED DATE : 11 Dec 2019 
        /// PURPOSE : AddEditForm functionality is used for getting form details on behalf of form_Id.
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult AddEditForm(int id = 0)
        {
            dynamic parentDropdownData = GetParentDropdownData();
            ViewData["ParentformSelectList"] = parentDropdownData.FormList;

            //dynamic solutionDropdownData = GetSolutionDropdownData();
            //ViewData["solutionformSelectList"] = solutionDropdownData.FormList;
            if (id != 0)
            {
                objFormMasterBal.GetFormsDetails(out _MstFormlist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, 10);
                // objFormMasterBal.GetFormsDetails(out _MstFormlist, out objBasicPagingMDL, id, SessionInfo.User.fk_companyid);
                return View("AddEditForm", _MstFormlist[0]);
            }
            else
            {
                MstFormMDL obj = new MstFormMDL();
                obj.IsActive = true;
                return View("AddEditForm", obj);
            }
        }

        /// <summary>
        /// CREATED DATE : 11 Dec 2019
        /// PURPOSE : Add and Edit Form Master Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="formDetails"></param>
        /// <returns></returns>

        [HttpPost]
        public ActionResult AddEditForm(MstFormMDL formDetails)
        {
            MessageMDL objMessages = new MessageMDL();
            try
            {

                if (ModelState.IsValid)
                {
                    formDetails.UserId = SessionInfo.User.UserId;
                    objMessages = objFormMasterBal.AddEditFormDetails(formDetails);
                    TempData["Message"] = objMessages;
                    return RedirectToAction("Index");
                }
                else
                {
                    formDetails.IsActive = true;

                    dynamic parentDropdownData = GetParentDropdownData();
                    ViewData["ParentformSelectList"] = parentDropdownData.FormList;

                    //dynamic solutionDropdownData = GetSolutionDropdownData();
                    //ViewData["solutionformSelectList"] = solutionDropdownData.FormList;

                    return View("AddEditForm", formDetails);

                }
            }
            catch (Exception ex)
            {
                objMessages.MessageId = 0;
                objMessages.Message = ex.Message;
            }
            return View("AddEditForm", objMessages);
        }

        /// <summary>
        /// CREATED DATE : 12 Dec 2019
        /// PURPOSE : Get All Parent Form Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <returns></returns>
        [NonAction]
        private dynamic GetParentDropdownData()
        {
            SelectList formSelectList;
            string selectFormId = null;
            List<MstFormMDL> FormList = objFormMasterBal.GetAllParentForm();
            if (FormList != null)
            {
                List<SelectListItem> items = FormList.Select(m => new SelectListItem()
                {
                    Text = m.ParentForm,
                    Value = m.ParentId.ToString()
                }).ToList();

                items[0].Selected = true;
                selectFormId = items[0].Value;

                formSelectList = new SelectList(items, "Value", "Text");
            }
            else
            {
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "Menu Not Found", Value = "0" });
                formSelectList = new SelectList(items, "Value", "Text");
            }
            return new { FormList = formSelectList, SelectFormId = selectFormId };
        }

        /// <summary>
        /// CREATED DATE : 12 Dec 2019
        /// PURPOSE :  Get All Solution Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <returns></returns>
        //[NonAction]
        //private dynamic GetSolutionDropdownData()
        //{
        //    SelectList formSelectList;
        //    string selectFormId = null;
        //    List<SolutionMDL> FormList = CommonBAL.GetAllSolution();
        //    if (FormList != null)
        //    {
        //        List<SelectListItem> items = FormList.Select(m => new SelectListItem()
        //        {
        //            Text = m.SolutionName,
        //            Value = m.PK_SolutionId.ToString()
        //        }).ToList();

        //        items[0].Selected = true;
        //        selectFormId = items[0].Value;
        //        formSelectList = new SelectList(items, "Value", "Text");
        //    }
        //    else
        //    {
        //        List<SelectListItem> items = new List<SelectListItem>();
        //        items.Add(new SelectListItem { Text = "Menu Not Found", Value = "0" });
        //        formSelectList = new SelectList(items, "Value", "Text");
        //    }
        //    return new { FormList = formSelectList, SelectFormId = selectFormId };
        //}

        /// <summary>
        /// CREATED DATE : 12 Dec 2019
        /// PURPOSE : Delete Form Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="formID"></param>
        /// <returns></returns>

        [HttpGet]
        public ActionResult DeleteFormsDetails(Int64 formID)
        {
            try
            {
                objMessages = new MessageMDL();
                objMessages = objFormMasterBal.DeleteFormsDetails(formID, SessionInfo.User.UserId);
                if (objMessages.MessageId == 1)
                {
                    objMessages.Message = objMessages.Message;
                    TempData["Message"] = objMessages;
                    return RedirectToAction("Index");
                }
                else
                {
                    objMessages.Message = objMessages.Message;
                    TempData["Message"] = objMessages;
                    return RedirectToAction("Index");
                }

            }
            catch (Exception ex)
            {
                objMessages.MessageId = 0;
                objMessages.Message = ex.Message;
                TempData["Message"] = objMessages;
                return RedirectToAction("Index");
            }

        }

        /// <summary>
        /// CREATED DATE : 7 jan 2020
        /// PURPOSE : Get File Extension
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="FileType"></param>
        /// <returns></returns>

        [HttpGet]
        public JsonResult ChooseFileType(string FileType = "", string choosen_ids = "", string SearchBy = "", string SearchValue = "")
        {
            TempData.Keep();
            TempData["FileType"] = FileType;
            List<MstFormMDL> _listForExcel = new List<MstFormMDL>();
            List<MstFormMDL> _listForExcel_New = new List<MstFormMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                _listForExcel = (List<MstFormMDL>)TempData["ExportData"];
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.Pk_FormId.ToString() == item));
                }
            }
            if (_listForExcel_New.Count > 0)
            {
                TempData["ExportData_Filtered"] = _listForExcel_New;
            }
            else
            {
                objFormMasterBal.GetFormsDetails(out _MstFormlist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, _TotalItem, 1, SearchBy, SearchValue.TrimEnd().TrimStart());
                TempData["ExportData_Filtered"] = _MstFormlist;
            }

            TempData["FileType"] = FileType;

            return Json(1, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        ///   CREATED DATE : 7 jan 2020
        ///  Purpose:- Export To Excel Or CSV File
        ///   CREATED BY : Vinish
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public FileResult ExportToExcelOrCSV()
        {
            TempData.Keep();
            string FileType = (string)TempData["FileType"];
            if (FileType == ".pdf")
            {
                List<MstFormMDL> _listForExcel = (List<MstFormMDL>)TempData["ExportData_Filtered"];
                //_listForExcel.ForEach(e => e.Status = e.IsActive ? "Active" : "Inactive");
                ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
                string pdfFileName = GyanmitrasLanguages.LocalResources.Resource.FormMaster + GyanmitrasLanguages.LocalResources.Resource.Format + ".pdf";
                string reportName = GyanmitrasLanguages.LocalResources.Resource.FormMaster;
                StringBuilder strhtml_summary = new StringBuilder();
                StringBuilder strhtml_details = new StringBuilder();
                StringBuilder strhtml_header_left = new StringBuilder();
                StringBuilder strhtml_header_right = new StringBuilder();
                #region Details Rows
                strhtml_details.Append("<table width='100%' border='0' cellspacing='0' cellpadding='10'>");
                strhtml_details.Append("<tbody style='font-family:Helvetica,Arial, sans-serif;font-size:5pt;line-height:5pt;'>");
                strhtml_details.Append("<tr>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + GyanmitrasLanguages.LocalResources.Resource.No + "." + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + GyanmitrasLanguages.LocalResources.Resource.FormName + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + GyanmitrasLanguages.LocalResources.Resource.ControllerName + "</strong></td> ");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + GyanmitrasLanguages.LocalResources.Resource.ActionName + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + GyanmitrasLanguages.LocalResources.Resource.ParentForm + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + GyanmitrasLanguages.LocalResources.Resource.Solution + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + GyanmitrasLanguages.LocalResources.Resource.ClassName + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + GyanmitrasLanguages.LocalResources.Resource.AreaName + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + GyanmitrasLanguages.LocalResources.Resource.Status + "</strong></td>");
                strhtml_details.Append("</tr>");

                int i = 1;
                foreach (var item in _listForExcel)
                {

                    strhtml_details.Append("<tr>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + i + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.FormName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.ControllerName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.ActionName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.ParentForm + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.SolutionName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.ClassName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.Area + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.Status + "</td>");
                    strhtml_details.Append("</tr>");
                    i++;
                }

                strhtml_details.Append("</tbody>");
                strhtml_details.Append("</table>");
                #endregion
                return objExcelExportHelper.ExportPDF(strhtml_summary.ToString(), strhtml_details.ToString(), strhtml_header_left.ToString(), strhtml_header_right.ToString(), pdfFileName, reportName);
            }
            else
            {
                List<MstFormMDL> _listForExcel = (List<MstFormMDL>)TempData["ExportData_Filtered"];
                string[] columns =
                    {
                GyanmitrasLanguages.LocalResources.Resource.FormName.Trim(),
                GyanmitrasLanguages.LocalResources.Resource.ControllerName.Trim(),
                GyanmitrasLanguages.LocalResources.Resource.ActionName.Trim(),
                GyanmitrasLanguages.LocalResources.Resource.ParentForm.Trim(),
                GyanmitrasLanguages.LocalResources.Resource.Solution,
                GyanmitrasLanguages.LocalResources.Resource.ClassName.Trim(),
                GyanmitrasLanguages.LocalResources.Resource.AreaName.Trim(),
                GyanmitrasLanguages.LocalResources.Resource.Status
            };
                string MDLAttr = "FormName,ControllerName,ActionName,ParentForm,SolutionName,ClassName,Area,Status";
                ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
                return objExcelExportHelper.ExportExcel(_listForExcel, GyanmitrasLanguages.LocalResources.Resource.FormMaster + GyanmitrasLanguages.LocalResources.Resource.Format + FileType, FileType, MDLAttr, columns);
            }
        }
    }
}