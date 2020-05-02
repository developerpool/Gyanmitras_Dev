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
    public class MapFormColumnConfigurationController : BaseController
    {
        MapFormColumnConfigurationBAL objMapFormColumnConfigurationBAL = null;
        JavaScriptSerializer jss;

        public MapFormColumnConfigurationController()
        {
            objMapFormColumnConfigurationBAL = new MapFormColumnConfigurationBAL();
            jss = new JavaScriptSerializer();
        }
        // GET: MapFormColumnConfiguration
        /// <summary>
        /// Index
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            ViewData["Categorylist"] = CommonBAL.BindCategory();
            ViewData["MappedFormColumnlist"] = CommonBAL.BindMappedFormColumn();
            if (TempData["ConfigMessage"] != null)
            {
                ViewBag.Msg = (MessageMDL)TempData["ConfigMessage"];
                TempData["ConfigMessage"] = null;
            }

            return View();
        }

        #region Get Columns 
        /// <summary>
        /// To Get the Columns For Mapping
        /// </summary>
        /// <param name="FK_CategoryID"></param>
        /// <param name="FK_FormId"></param>
        /// <param name="FK_AccountID"></param>
        /// <param name="FK_CustomerID"></param>
        /// <returns></returns>
        public PartialViewResult GetColumnsByFormId(Int64 FK_CategoryID, Int64 FK_FormId, Int64 FK_AccountID=0,Int64 FK_CustomerID=0) {
            MapFormColumnConfigurationMDL objMapFormColumnConfigurationMDL = new MapFormColumnConfigurationMDL();
            objMapFormColumnConfigurationMDL.FormColumns = CommonBAL.GetColumnsByFormId(FK_FormId,FK_AccountID,FK_CustomerID);
            objMapFormColumnConfigurationMDL.FK_CustomerId = FK_CustomerID;
            objMapFormColumnConfigurationMDL.FK_AccountId = FK_AccountID;
            objMapFormColumnConfigurationMDL.FK_CategoryId = FK_CategoryID;


            return PartialView("_FormColumnGrid", objMapFormColumnConfigurationMDL);
        }
        #endregion

        #region Update Form Column Config
        /// <summary>
        /// To Update the form Column Configuration
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult UpdateFormColumnConfig(MapFormColumnConfigurationMDL obj)
        {
            string jsondata = jss.Serialize(obj.FormColumns);

            MessageMDL msg = objMapFormColumnConfigurationBAL.UpdateFormColumnConfig(jsondata, SessionInfo.User.UserId, obj.FK_AccountId, obj.FK_CategoryId, obj.FK_CustomerId);
            TempData["ConfigMessage"] = msg;
            return RedirectToAction("Index");
        }
        #endregion

        #region DropDown Bind Functions
        /// <summary>
        /// To Bind the Accounts On Category Basis
        /// </summary>
        /// <param name="CategoryId"></param>
        /// <returns></returns>
        public JsonResult BindAccountsByCategory(Int64 CategoryId)
        {
            return Json(CommonBAL.BindAccountsByCategory(CategoryId), JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// To Bind the Customers
        /// </summary>
        /// <returns></returns>
        public JsonResult BindCustomer() {
            return Json(CommonBAL.BindCustomer(), JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}