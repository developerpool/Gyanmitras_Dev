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
    public class MstCountryController : BaseController
    {
        // GET: CountryMaster

        private List<MstCountryMDL> _Countrylist;
        BasicPagingMDL objBasicPagingMDL = null;
        MstCountryBAL objCountryMasterBAL = null;
        TotalCountPagingMDL objTotalCountPagingMDL = null;

        public MstCountryController()
        {
            objCountryMasterBAL = new MstCountryBAL();
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
            //getCountry();
            //ViewBag.TotalCountPaging = objTotalCountPagingMDL;

            return View();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-To show country  data in the form of grid
        /// </summary>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <param name="RowPerpage"></param>
        /// <returns></returns>

        public PartialViewResult getCountry(int CurrentPage = 1, string SearchBy = "", string SearchValue = "", int RowPerpage = 10)
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            objCountryMasterBAL.getCountry(out _Countrylist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.UserId, RowPerpage, CurrentPage, SearchBy, SearchValue, SessionInfo.User.UserId, SessionInfo.User.fk_companyid);
            TempData["ExportData"] = _Countrylist;
            TempData["TotalItemCount"] = objBasicPagingMDL.TotalItem;
            ViewBag.paging = objBasicPagingMDL;
            return PartialView("_CountryMasterGrid", _Countrylist);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose- Get Country Data
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        [HttpGet]
        public ActionResult AddEditCountry(int id = 0)
        {

            if (id != 0)
            {
                objCountryMasterBAL.getCountry(out _Countrylist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.UserId, Convert.ToInt32(10), 1, "", "", SessionInfo.User.UserId, SessionInfo.User.fk_companyid);
                return View("AddEditCountry", _Countrylist[0]);
            }
            else
            {
                MstCountryMDL obj = new MstCountryMDL();
                obj.IsActive = true;
                return View("AddEditCountry", obj);
            }
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose- Insert  Country Data
        /// </summary>
        /// <param name="objCountryMasterMDL"></param>
        /// <returns></returns>

        [HttpPost]
        public ActionResult AddEditCountry(MstCountryMDL objCountryMasterMDL)
        {

            objCountryMasterMDL.CreatedBy = SessionInfo.User.UserId;
            if (ModelState.IsValid)
            {
                if (objCountryMasterMDL.Status == "Active")
                {
                    objCountryMasterMDL.IsActive = true;

                }
                else
                {
                    objCountryMasterMDL.IsActive = false;
                }


                MessageMDL msg = objCountryMasterBAL.AddEditCountry(objCountryMasterMDL);
                msg.Message = msg.Message;
                TempData["Message"] = msg;

                return RedirectToAction("Index");

            }
            return View("AddEditCountry");
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose- Delete Country Data
        /// </summary>
        /// <param name="PK_CountryId"></param>
        /// <returns></returns>
        public ActionResult DeleteCountry(Int64 PK_CountryId)
        {
            MessageMDL msg = new MessageMDL();
            try
            {
                msg = objCountryMasterBAL.DeleteCountry(PK_CountryId, SessionInfo.User.UserId);
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
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose:-Choose Which Type of Files You Want To  Export(Either Excel Or CSV File)Delete Country Data
        /// </summary>
        /// <param name="FileType"></param>
        /// <returns></returns>

        public JsonResult ChooseFileType(string FileType = "", string choosen_ids = "", string SearchBy = "", string SearchValue = "")
        {

            TempData.Keep();
            List<MstCountryMDL> _listForExcel = (List<MstCountryMDL>)TempData["ExportData"];
            List<MstCountryMDL> _listForExcel_New = new List<MstCountryMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.PK_CountryId.ToString() == item));
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
                getCountry(CurrentPage, SearchBy, SearchValue, RowPerpage);
                _listForExcel = (List<MstCountryMDL>)TempData["ExportData"];
                TempData["ExportData_Filtered"] = _listForExcel;
            }
            TempData["FileType"] = FileType;
            return Json(1, JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose:- Export To Excel Or CSV File
        /// </summary>
        /// <returns></returns>

        public FileResult ExportToExcelOrCSV()
        {
            TempData.Keep();
            string FileType = (string)TempData["FileType"];
            List<MstCountryMDL> _listForExcel = (List<MstCountryMDL>)TempData["ExportData_Filtered"];
            string[] columns = { @GyanmitrasLanguages.LocalResources.Resource.CountryName, @GyanmitrasLanguages.LocalResources.Resource.Status };
            string MDLAttr = "CountryName,Status";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, "Country Master", FileType, MDLAttr, columns);
        }

    }
}