using Gyanmitras.Common;
using GyanmitrasBAL;
using GyanmitrasBAL.Common;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class MstStateController : BaseController
    {
        // GET: MstState
        private List<MstStateMDL> _Statelist;
        BasicPagingMDL objBasicPagingMDL = null;
        MstStateBAL objStateMasterBAL = null;
        TotalCountPagingMDL objTotalCountPagingMDL = null;

        public MstStateController()
        {
            objStateMasterBAL = new MstStateBAL();
        }
        public ActionResult Index()
        {


            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            TempData.Keep();
            if (TempData["Message"] != null)
            {
                ViewBag.Msg = (MessageMDL)TempData["Message"];
                TempData["Message"] = null;
            }
           // getState();
            //ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            return View();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose-To show state  data in the form of grid 
        /// </summary>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <param name="RowPerpage"></param>
        /// <returns></returns>

        public PartialViewResult getState(int CurrentPage = 1, string SearchBy = "", string SearchValue = "", int RowPerpage = 10)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            objStateMasterBAL.getState(out _Statelist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.UserId, RowPerpage, CurrentPage, SearchBy, SearchValue, SessionInfo.User.UserId, SessionInfo.User.fk_companyid);
            TempData["TotalItemCount"] = objBasicPagingMDL.TotalItem;
            ViewBag.paging = objBasicPagingMDL;
            TempData["ExportData"] = _Statelist;
            return PartialView("_StateMasterGrid", _Statelist);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose- Get State Data
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditState(int id = 0)
        {
            ViewData["Countrylist"] = CommonBAL.GetCountryList();

            if (id != 0)
            {
                objStateMasterBAL.getState(out _Statelist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.UserId, Convert.ToInt32(10), 1, "", "", SessionInfo.User.UserId, SessionInfo.User.fk_companyid);
                return View("AddEditState", _Statelist[0]);
            }
            else
            {
                MstStateMDL obj = new MstStateMDL();
                obj.IsActive = true;
                return View("AddEditState", obj);
            }       
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose- Insert  State Data
        /// </summary>
        /// <param name="objStateMasterMDL"></param>
        /// <returns></returns>

        [HttpPost]
        public ActionResult AddEditState(MstStateMDL objStateMasterMDL)
        {

            objStateMasterMDL.CreatedBy = SessionInfo.User.UserId;

            if (objStateMasterMDL.Status == "Active")
            {
                objStateMasterMDL.IsActive = true;

            }
            else
            {
                objStateMasterMDL.IsActive = false;
            }
            if (ModelState.IsValid)
            {
                MessageMDL msg = objStateMasterBAL.AddEditState(objStateMasterMDL);
              
                msg.Message = msg.Message;
                TempData["Message"] = msg;
                return RedirectToAction("Index");
            }
            return View("AddEditState");
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose- Delete State Data
        /// </summary>
        /// <param name="PK_StateId"></param>
        /// <returns></returns>
        public ActionResult DeleteState(Int64 PK_StateId)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                msg = objStateMasterBAL.DeleteState(PK_StateId, SessionInfo.User.UserId);
                msg.Message = msg.Message;
                TempData["Message"] = msg;
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                msg.MessageId = 0;
                msg.Message = ex.Message;
                TempData["Message"] = msg;
                return RedirectToAction("Index");
            }
            //MessageMDL msg = objStateMasterBAL.DeleteState(PK_StateId, 1);
            //return Json(msg, JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose:-Choose Which Type of Files You Want To  Export(Either Excel Or CSV File)Delete Country Data
        /// </summary>
        /// <param name="FileType"></param>
        /// <returns></returns>
        public JsonResult ChooseFileType(string FileType = "", string choosen_ids = "", string SearchBy = "", string SearchValue = "")
        {
            TempData.Keep();
            List<MstStateMDL> _listForExcel = (List<MstStateMDL>)TempData["ExportData"];
            List<MstStateMDL> _listForExcel_New = new List<MstStateMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.Pk_StateId.ToString() == item));
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
                getState(CurrentPage, SearchBy, SearchValue, RowPerpage);
                _listForExcel = (List<MstStateMDL>)TempData["ExportData"];
                TempData["ExportData_Filtered"] = _listForExcel;
            }
            TempData["FileType"] = FileType;
            return Json(1, JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose:- Export To Excel Or CSV File
        /// </summary>
        /// <returns></returns>

        public FileResult ExportToExcelOrCSV()
        {
            TempData.Keep();
            string FileType = (string)TempData["FileType"];
            List<MstStateMDL> _listForExcel = (List<MstStateMDL>)TempData["ExportData_Filtered"];
            string[] columns = { @GyanmitrasLanguages.LocalResources.Resource.CountryName, @GyanmitrasLanguages.LocalResources.Resource.StateName, @GyanmitrasLanguages.LocalResources.Resource.Status };
            string MDLAttr = "CountryName,StateName,Status";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, "State Master", FileType, MDLAttr, columns);
        }

    }
}