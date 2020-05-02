using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using Gyanmitras.Common;
using GyanmitrasBAL;
using GyanmitrasBAL.Common;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class MstUserController :BaseController
    {
        #region 
        private List<MstUserMDL> _UserDatalist;
        MstUserBAL objUserBal = null;
        BasicPagingMDL objBasicPagingMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;
        public MstUserController()
        {
            objUserBal = new MstUserBAL();
        }
        #endregion

        #region Methods
        // GET: UserMaster
        public ActionResult Index()
        {

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
            GetUsersMst();
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
        public PartialViewResult GetUsersMst(int RowPerpage = 10, int CurrentPage = 1,  string SearchBy = "", string SearchValue = "")
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            MstUserMDL objUserMDL = new MstUserMDL();
           // var accountid = objUserMDL.FK_AccountId;
            objUserBal.GetUserMstDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, 0 ,SessionInfo.User.AccountId,SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId,SessionInfo.User.LoginType, RowPerpage, CurrentPage,  SearchBy, SearchValue);
            ViewBag.userCheck = SessionInfo.User.UserName;
            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            TempData["ExportData"] = _UserDatalist;
            TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            return PartialView("_MstUserGrid", _UserDatalist);
        }
        /// <summary>
        /// Update method Of user master 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditUser(int id = 0)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            ViewBag.cate = SessionInfo.User.CategoryId;
            ViewBag.logintype = SessionInfo.User.LoginType;
            ViewData["countrylist"] = CommonBAL.GetCountryList();
            ViewData["CategoryList"] = MstUserBAL.Category();
            ViewData["CategoryForCust"] = MstUserBAL.Category().AsEnumerable().Where(E => E.CategoryName.ToUpper().Trim() != "CUSTOMER");
            //ViewData["RoleList"] = MstUserBAL.Rolelist(0,0);
            ViewData["Custlist"] = CommonBAL.BindCustomerByAccountCustomerIdLoginType(SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType,"");


            if (id != 0)
            {
                objUserBal.GetUserMstDetails(out _UserDatalist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, SessionInfo.User.LoginType, 10,1);
                return View("AddEditUser", _UserDatalist[0]);
            }
            else
            {
                MstUserMDL obj = new MstUserMDL();
                obj.IsActive = true;
                return View("AddEditUser", obj);
            }
        }
        /// <summary>
        /// Post Method of User master(Insert Data of user master)
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="userMstMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddEditUser(MstUserMDL userMstMDL)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            try
            {
                if(SessionInfo.User.LoginType=="CUSTOMER")
                {
                    userMstMDL.FK_AccountId = SessionInfo.User.AccountId;
                    userMstMDL.FK_CategoryId = SessionInfo.User.CategoryId;
                }
                    userMstMDL.UserId = SessionInfo.User.UserId;
                string text = userMstMDL.UserName;
                string trim = text.Replace(" ", "");
                //var usernametrim=userMstMDL.UserName.Trim();
                userMstMDL.UserName = trim;
                if(userMstMDL.FK_RoleIdforcust>0)
                {
                    var userid = userMstMDL.FK_RoleIdforcust;
                    userMstMDL.FK_RoleId = userid;
                }
                    MessageMDL msg = objUserBal.AddEditUser(userMstMDL);
                TempData["Message"] = msg;
                return RedirectToAction("Index");
               
            }
            catch(Exception ex) {
            }
            return RedirectToAction("AddEditUser");
        }
        /// <summary>
        /// Delete user by ID 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult DeleteUser(int id)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            MessageMDL msg = objUserBal.DeleteUser(id, 1);
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
        /// Get Account Name By Category Id 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="categoryid"></param>
        /// <returns></returns>
        public JsonResult GetAccountName(int categoryid)
        {
            return Json(CommonBAL.GetAllAccountsByCategory(categoryid), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetCustomer(int Accountid=0)
        {
           // if (Accountid==0)
           // {
                return Json(CommonBAL.BindCustomerByAccountCustomerIdLoginType(SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId,SessionInfo.User.LoginType,""), JsonRequestBehavior.AllowGet);
          //  }
           // return Json(CommonBAL.BindCustomerByAccount(Accountid, SessionInfo.User.LoginType), JsonRequestBehavior.AllowGet);
        }
        
        public JsonResult GetRole(int AccountID= 0,int CustomerId= 0)
        {
            return Json(MstUserBAL.Rolelist(AccountID, CustomerId), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetRoles(int categoryid = 0, int CustomerId = 0)
        {
            return Json(MstUserBAL.Rolelist(categoryid, CustomerId), JsonRequestBehavior.AllowGet);
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
        
        //public ActionResult CheckUser(string username)
        //{


        //    MessageMDL msg = CommonBAL.CheckUserName(username);
        //    if (msg.MessageId == 1)
        //    {
        //        msg.Message = msg.Message;
        //        TempData["Message"] = msg;
        //        return RedirectToAction("Index");
        //    }
        //    else
        //    {
        //        msg.Message = msg.Message;
        //        TempData["Message"] = msg;
        //        return RedirectToAction("Index");
        //    }
        //}

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
            List<MstUserMDL> _listForExcel = (List<MstUserMDL>)TempData["ExportData"];
            List<MstUserMDL> _listForExcel_New = new List<MstUserMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.Pk_UserId.ToString() == item));
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
                GetUsersMst(RowPerpage,CurrentPage, SearchBy, SearchValue );
                _listForExcel = (List<MstUserMDL>)TempData["ExportData"];
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
            List<MstUserMDL> _listForExcel = (List<MstUserMDL>)TempData["ExportData_Filtered"];
            _listForExcel.ForEach(e => e.Status = e.IsActive ? "Active" : "Inactive");
            _listForExcel.ForEach(e => e.IsVehicleSpecific = e.VehicleSpecific ? "Yes" : "No");
            _listForExcel.ForEach(e => e.AccountName = (e.CustomerName == null) ? e.AccountName : e.CustomerName);
            string[] columns = {@GyanmitrasLanguages.LocalResources.Resource.AccCategory, @GyanmitrasLanguages.LocalResources.Resource.AccountName, @GyanmitrasLanguages.LocalResources.Resource.UsruserName, @GyanmitrasLanguages.LocalResources.Resource.Role, @GyanmitrasLanguages.LocalResources.Resource.EmailId, @GyanmitrasLanguages.LocalResources.Resource.MobileNo, @GyanmitrasLanguages.LocalResources.Resource.Country, @GyanmitrasLanguages.LocalResources.Resource.State, @GyanmitrasLanguages.LocalResources.Resource.City, @GyanmitrasLanguages.LocalResources.Resource.IsVehicleSpecific, @GyanmitrasLanguages.LocalResources.Resource.Status };
            string MDLAttr = "Categoryname,AccountName,UserName,Rolename,EmailId,MobileNo,CountryName,statename,Cityname,IsVehicleSpecific,Status";
            ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
            return objExcelExportHelper.ExportExcel(_listForExcel, "User Account", FileType, MDLAttr, columns);
        }
        #endregion Methods
    }

}
