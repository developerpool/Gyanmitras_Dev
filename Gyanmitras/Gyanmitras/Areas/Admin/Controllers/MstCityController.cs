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
    public class MstCityController : BaseController
    {
        // GET: MstCity
        private List<MstCityMDL> _Citylist;
        BasicPagingMDL objBasicPagingMDL = null;
        MstCityBAL objCityMasterBAL = null;
        TotalCountPagingMDL objTotalCountPagingMDL = null;
        public MstCityController()
        {
            objCityMasterBAL = new MstCityBAL();
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
            //getCity();
            //ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            return View();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose- To show City  data in the form of grid
        /// </summary>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <param name="RowPerpage"></param>
        /// <returns></returns>
        public PartialViewResult getCity(int CurrentPage = 1, string SearchBy = "", string SearchValue = "", int RowPerpage = 10)
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            objCityMasterBAL.getCity(out _Citylist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.UserId, RowPerpage, CurrentPage, SearchBy, SearchValue, SessionInfo.User.UserId, SessionInfo.User.fk_companyid);
            ViewBag.paging = objBasicPagingMDL;
            TempData["TotalItemCount"] = objBasicPagingMDL.TotalItem;

            TempData["ExportData"] = _Citylist;

            return PartialView("_CityMasterGrid", _Citylist);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose- Get  City Data
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditCity(int id = 0)
        {
            ViewData["Countrylist"] = CommonBAL.GetCountryList();

            if (id != 0)
            {
                objCityMasterBAL.getCity(out _Citylist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.UserId, Convert.ToInt32(10), 1, "", "", SessionInfo.User.UserId, SessionInfo.User.fk_companyid);
                return View("AddEditCity", _Citylist[0]);
            }
            else
            {
                MstCityMDL obj = new MstCityMDL();
                obj.IsActive = true;
                return View("AddEditCity", obj);
            }
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose- Insert  City Data
        /// </summary>
        /// <param name="objCityMasterMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddEditCity(MstCityMDL objCityMasterMDL)
        {


            if (objCityMasterMDL.Status == "Active")
            {
                objCityMasterMDL.IsActive = true;

            }
            else
            {
                objCityMasterMDL.IsActive = false;
            }
            objCityMasterMDL.CreatedBy = SessionInfo.User.UserId;
            if (ModelState.IsValid)
            {
                MessageMDL msg = objCityMasterBAL.AddEditCity(objCityMasterMDL);
                msg.Message = msg.Message;
                TempData["Message"] = msg;
                return RedirectToAction("Index");
            }
            return View("AddEditCity");
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose- Get state Data By Choosing country 
        /// </summary>
        /// <param name="countryid"></param>
        /// <returns></returns>
        public JsonResult getstate(int countryid)
        {
            return Json(CommonBAL.GetStateDetailsByCountryId(countryid), JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose- Delete City Data
        /// </summary>
        /// <param name="PK_CityId"></param>
        /// <returns></returns>
        public ActionResult DeleteCity(Int64 PK_CityId)
        {


            MessageMDL msg = new MessageMDL();
            try
            {
                msg = objCityMasterBAL.DeleteCity(PK_CityId, SessionInfo.User.UserId);
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
        /// Date-22/12/2019
        /// Purpose:-Choose Which Type of Files You Want To  Export(Either Excel Or CSV File)Delete Country Data
        /// </summary>
        /// <param name="FileType"></param>
        /// <returns></returns>

        public JsonResult ChooseFileType(string FileType = "", string choosen_ids = "", string SearchBy = "", string SearchValue = "")
        {

            TempData.Keep();
            List<MstCityMDL> _listForExcel = (List<MstCityMDL>)TempData["ExportData"];
            List<MstCityMDL> _listForExcel_New = new List<MstCityMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.Pk_CityId.ToString() == item));
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
                getCity(CurrentPage, SearchBy, SearchValue, RowPerpage);
                _listForExcel = (List<MstCityMDL>)TempData["ExportData"];
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
            List<MstCityMDL> _listForExcel = (List<MstCityMDL>)TempData["ExportData_Filtered"];
            string[] columns = { @GyanmitrasLanguages.LocalResources.Resource.CountryName, @GyanmitrasLanguages.LocalResources.Resource.StateName, @GyanmitrasLanguages.LocalResources.Resource.CityName, @GyanmitrasLanguages.LocalResources.Resource.Status };
            string MDLAttr = "CountryName,StateName,CityName,Status";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, "State Master", FileType, MDLAttr, columns);
        }
    }
}