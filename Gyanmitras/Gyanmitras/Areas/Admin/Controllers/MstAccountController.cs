

using GyanmitrasMDL;
using Gyanmitras;
using Gyanmitras.Common;
using GyanmitrasBAL.Common;

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Text;
using System.Configuration;
using Utility;
using GyanmitrasBAL;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class MSTAccountController : BaseController
    {
        public BasicPagingMDL objBasicPagingMDL = new BasicPagingMDL();
        private readonly MSTAccountBAL objAccountBDL;
        private List<MSTAccountMDL> _AccountMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;
        public MSTAccountController()
        {
            UserInfoMDL U = SessionInfo.User;
            if (U != null)
            {
                ViewBag.LoginType = U.LoginType;
                ViewBag.Parent_AccountId = U.AccountId;
            }

            objAccountBDL = new MSTAccountBAL();
            _AccountMDL = new List<MSTAccountMDL>();
        }

        // GET: Account
        public ActionResult Index()
        {



            //ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            //ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            //ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            //ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            ViewBag.CanAdd = true;
            ViewBag.CanEdit = true;
            ViewBag.CanView = true;
            ViewBag.CanDelete = true;

            if (TempData["Message"] != null)
            {
                ViewBag.Msg = (MessageMDL)TempData["Message"];
                TempData["Message"] = null;
            }
            string cate_id = SessionInfo.User.CategoryId.ToString();
            GetAccounts();
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            return View();
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        [HttpGet]
        public PartialViewResult GetAccounts(int CurrentPage = 1, string SearchBy = "", string SearchValue = "", int RowPerpage = 10)
        {
            //ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            //ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            //ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            //ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            ViewBag.CanAdd = true;
            ViewBag.CanEdit = true;
            ViewBag.CanView = true;
            ViewBag.CanDelete = true;
            UserInfoMDL objUserMDL = new UserInfoMDL();

            objAccountBDL.GetAccountDetails(out _AccountMDL, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.UserId, RowPerpage, CurrentPage, SearchBy, SearchValue, SessionInfo.User.AccountId, SessionInfo.User.FK_CustomerId, SessionInfo.User.UserId, SessionInfo.User.LoginType);

            TempData["ExportData"] = _AccountMDL;
            TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;
            ViewBag.paging = objBasicPagingMDL;
            return PartialView("_Account", _AccountMDL);
        }
        public JsonResult ChooseFileType(string FileType = "", string choosen_ids = "", string SearchBy = "", string SearchValue = "")
        {
            TempData.Keep();
            List<MSTAccountMDL> _listForExcel = (List<MSTAccountMDL>)TempData["ExportData"];
            List<MSTAccountMDL> _listForExcel_New = new List<MSTAccountMDL>();
            if (!string.IsNullOrEmpty(choosen_ids))
            {
                string[] ids = choosen_ids.Split(',');
                foreach (var item in ids)
                {
                    if (!string.IsNullOrEmpty(item))
                        _listForExcel_New.Add(_listForExcel.FirstOrDefault(x => x.PK_AccountId.ToString() == item));
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
                GetAccounts(CurrentPage, SearchBy, SearchValue, RowPerpage);
                _listForExcel = (List<MSTAccountMDL>)TempData["ExportData"];
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

            if (FileType == ".pdf")
            {
                List<MSTAccountMDL> _listForExcel = (List<MSTAccountMDL>)TempData["ExportData_Filtered"];
                _listForExcel.ForEach(e => e.Status = e.IsActive ? "Active" : "Inactive");
                ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
                string SummaryHtml = "";
                string DetailsHtml = "";
                string customername = "M5 CARE SDN BHD";
                string vehicle_no = "PNJ5432";
                string startdatetime = "22 APR 2019 | 09:13:08 ";
                string enddatetime = "22 APR 2019 | 18:02:30 ";
                string pdfFileName = @GyanmitrasLanguages.LocalResources.Resource.AccountData + ".pdf";
                string reportName = @GyanmitrasLanguages.LocalResources.Resource.AccountData;
                StringBuilder strhtml_summary = new StringBuilder();
                StringBuilder strhtml_details = new StringBuilder();
                StringBuilder strhtml_header_left = new StringBuilder();
                StringBuilder strhtml_header_right = new StringBuilder();


                #region Summary Rows
                //strhtml_summary.Append("<table width='100%' border='0' cellspacing='0' cellpadding='3'> ");
                //strhtml_summary.Append("<tbody style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:5pt;'>");
                //strhtml_summary.Append("<tr>");
                //strhtml_summary.Append("<td width='120'>Total AC</td>");
                //strhtml_summary.Append("<td width='20'>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("<td width='120'>Total Ignition ON</td>");
                //strhtml_summary.Append("<td width='20'>:</td>");
                //strhtml_summary.Append("<td><strong>1</strong></td>");
                //strhtml_summary.Append("<td width='120'>Total Ignition OFF</td>");
                //strhtml_summary.Append("<td width='20'>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("<td width='120'>Total Moving ON</td>");
                //strhtml_summary.Append("<td width='20'>:</td>");
                //strhtml_summary.Append("<td><strong>1</strong></td>");
                //strhtml_summary.Append("</tr>");
                //strhtml_summary.Append("<tr>");
                //strhtml_summary.Append("<td>Total Moving OFF</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>1</strong></td>");
                //strhtml_summary.Append("<td>Total Idling ON</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>1</strong></td>");
                //strhtml_summary.Append("<td>Total Idling OFF</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("<td>Total Standing ON</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("</tr>");
                //strhtml_summary.Append("<tr>");
                //strhtml_summary.Append("<td>Total Standing OFF</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>1</strong></td>");
                //strhtml_summary.Append("<td>Total Overspeed ON</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>1</strong></td>");
                //strhtml_summary.Append("<td>Total Overspeed OFF</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("<td>Total Panic ON</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("</tr>");
                //strhtml_summary.Append("<tr>");
                //strhtml_summary.Append("<td>Total Panic OFF</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("<td>Total Power Cut Off</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("<td>Total Battery Low</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("<td>Total Fuel Level Low</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>0</strong></td>");
                //strhtml_summary.Append("</tr>");
                //strhtml_summary.Append("<tr>");
                //strhtml_summary.Append("<td>Not Polling</td>");
                //strhtml_summary.Append("<td>:</td>");
                //strhtml_summary.Append("<td><strong>1</strong></td>");
                //strhtml_summary.Append("<td>&nbsp;</td>");
                //strhtml_summary.Append("<td>&nbsp;</td>");
                //strhtml_summary.Append("<td>&nbsp;</td>");
                //strhtml_summary.Append("<td>&nbsp;</td>");
                //strhtml_summary.Append("<td>&nbsp;</td>");
                //strhtml_summary.Append("<td>&nbsp;</td>");
                //strhtml_summary.Append("<td>&nbsp;</td>");
                //strhtml_summary.Append("<td>&nbsp;</td>");
                //strhtml_summary.Append("<td>&nbsp;</td>");
                //strhtml_summary.Append("</tr>");
                //strhtml_summary.Append("</tbody>");
                //strhtml_summary.Append("</table>");
                #endregion


                #region Details Rows
                strhtml_details.Append("<table width='100%' border='0' cellspacing='0' cellpadding='10'>");
                strhtml_details.Append("<tbody style='font-family:Helvetica,Arial, sans-serif;font-size:5pt;line-height:5pt;'>");
                strhtml_details.Append("<tr>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.No + "." + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.AccCategory + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.AccountName + "</strong></td> ");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.ParentAccountName + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.Email + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.MobileNo + "." + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.Country + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.State + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.City + "</strong></td>");
                strhtml_details.Append("<td align='center' class='borBottomB'><strong>" + @GyanmitrasLanguages.LocalResources.Resource.Status + "</strong></td>");
                strhtml_details.Append("</tr>");
                int i = 1;
                foreach (var item in _listForExcel)
                {

                    strhtml_details.Append("<tr>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + i + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.AccountCategoryName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.AccountName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.AccountParentName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.EmailId + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.MobileNo + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.CountryName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.StateName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.CityName + "</td>");
                    strhtml_details.Append("<td align='center' class='borBottom'>" + item.Status + "</td>");
                    strhtml_details.Append("</tr>");
                    i++;
                }




                strhtml_details.Append("</tbody>");
                strhtml_details.Append("</table>");
                #endregion

                //#region Header Rows

                //strhtml_header_left.Append("<tr > <td  >CUSTOMER NAME </td> <td>:</td> <td align='left'><strong>" + customername + "</strong></td> </tr>");
                //strhtml_header_left.Append("<tr> <td>VEHICLE NO.</td> <td>:</td> <td align='left'><strong>" + vehicle_no + "</strong></td> </tr>");


                //strhtml_header_right.Append("<tr> <td align='right'>START DATE &amp; TIME</td> <td >:</td> <td  align='left'><strong>22 APR 2019 | 09:13:08 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></td> </tr>");
                //strhtml_header_right.Append("<tr> <td align='right'>END DATE &amp; TIME </td> <td align='left'>:</td> <td align='left'><strong>22 APR 2019 | 18:02:30 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></td> </tr>");
                //#endregion




                return objExcelExportHelper.ExportPDF(strhtml_summary.ToString(), strhtml_details.ToString(), strhtml_header_left.ToString(), strhtml_header_right.ToString(), pdfFileName, reportName);
            }
            else
            {
                List<MSTAccountMDL> _listForExcel = (List<MSTAccountMDL>)TempData["ExportData_Filtered"];
                _listForExcel.ForEach(e => e.Status = e.IsActive ? "Active" : "Inactive");
                string[] columns = {
                @GyanmitrasLanguages.LocalResources.Resource.AccCategory,
                @GyanmitrasLanguages.LocalResources.Resource.AccountName,
                @GyanmitrasLanguages.LocalResources.Resource.ParentAccountName,
                @GyanmitrasLanguages.LocalResources.Resource.Email,
                @GyanmitrasLanguages.LocalResources.Resource.MobileNo+".",
                @GyanmitrasLanguages.LocalResources.Resource.Country,
                @GyanmitrasLanguages.LocalResources.Resource.State,
                @GyanmitrasLanguages.LocalResources.Resource.City,
                @GyanmitrasLanguages.LocalResources.Resource.Status
            };
                string MDLAttr = "AccountCategoryName,AccountName,AccountParentName,EmailId,MobileNo,CountryName,StateName,CityName,Status";
                ExcelExportHelper objExcelExportHelper = new ExcelExportHelper();
                return objExcelExportHelper.ExportExcel(_listForExcel, @GyanmitrasLanguages.LocalResources.Resource.AccountData, FileType, MDLAttr, columns);
            }
        }

        [HttpGet]

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Account Details By Id
        /// </summary>
        public ActionResult AddEditAccount(int id = 0)
        {
            ViewData["accountcategorylist"] = CommonBAL.BindCategory();
            ViewData["userrolelist"] = CommonBAL.FillRoles();
            ViewData["countrylist"] = CommonBAL.GetCountryList();

            if (id != 0)
            {
                objAccountBDL.GetAccountDetails(out _AccountMDL, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.UserId, Convert.ToInt32(10), 1, "", "", SessionInfo.User.AccountId, SessionInfo.User.FK_CustomerId, SessionInfo.User.UserId, SessionInfo.User.LoginType);
                return View("AddEditAccount", _AccountMDL[0]);
            }
            else
            {
                MSTAccountMDL obj = new MSTAccountMDL();
                obj.FK_CompanyId = SessionInfo.User.fk_companyid;
                obj.IsActive = true;
                return View("AddEditAccount", obj);
            }
        }
        #region Ajax Functions



        public JsonResult GetAllReferrerAccountsByCategory(int categoryId)
        {
            return Json(CommonBAL.GetAllAccountsByCategory(categoryId), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetAllAccountsByCategory(int categoryId)
        {
            return Json(CommonBAL.GetAccountListByCategoryIdLoginType(SessionInfo.User.AccountId, SessionInfo.User.UserId, SessionInfo.User.FK_CustomerId, "", categoryId), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetCountryList()
        {
            return Json(CommonBAL.GetCountryList(), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetStateDetailsByCountryId(int countryId)
        {
            return Json(CommonBAL.GetStateDetailsByCountryId(countryId), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetCityDetailsByStateId(Int64 stateId)
        {
            return Json(CommonBAL.GetCityDetailsByStateId(stateId), JsonRequestBehavior.AllowGet);
        }
        #endregion
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Delete Account Details
        /// </summary>

        public ActionResult DeleteAccount(Int64 id)
        {
            MessageMDL msg = new MessageMDL();
            msg = objAccountBDL.DeleteAccount(id, SessionInfo.User.UserId, SessionInfo.User.fk_companyid);
            TempData["Message"] = msg;
            return RedirectToAction("Index");
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Add Edit Account Details
        /// </summary>

        public ActionResult AddEditAccount(MSTAccountMDL objAccountMDL)
        {
            Int64 NewCreatedUserId = 0;

            ViewData["accountcategorylist"] = CommonBAL.BindCategory();
            ViewData["userrolelist"] = CommonBAL.FillRoles();
            ViewData["countrylist"] = CommonBAL.GetCountryList();
            if (objAccountMDL.PK_AccountId > 0)
            {
                ModelState.Remove("Username");
                ModelState.Remove("Password");

            }

            ModelState.Remove("FK_CategoryId_Referrer");
            ModelState.Remove("FK_AccountId_Referrer");
            ModelState.Remove("FK_RoleId");
            ModelState.Remove("UserLimit");
            ModelState.Remove("Parent_FK_CategoryId");
            ModelState.Remove("ParentAccountId");
            ModelState.Remove("FK_CountryId_Billing");
            ModelState.Remove("FK_StateId_Billing");
            ModelState.Remove("FK_CityId_Billing");
            ModelState.Remove("AccountAddress");



            objAccountMDL.Parent_FK_CategoryId = objAccountMDL.Parent_FK_CategoryId <= 0 ? SessionInfo.User.CategoryId : objAccountMDL.Parent_FK_CategoryId;
            objAccountMDL.ParentAccountId = objAccountMDL.ParentAccountId <= 0 ? SessionInfo.User.AccountId : objAccountMDL.ParentAccountId;

            if (ModelState.IsValid)
            {
                objAccountMDL.CreatedBy = SessionInfo.User.UserId;
                objAccountMDL.FK_CompanyId = SessionInfo.User.AccountId;
                objAccountMDL.FK_ResellerId = objAccountMDL.FK_CategoryId == 2 ? objAccountMDL.FK_CategoryId : 0;
                objAccountMDL.FK_AffiliateId = objAccountMDL.FK_CategoryId == 3 ? objAccountMDL.FK_CategoryId : 0;
                //objAccountMDL.Password= ClsCrypto.Encrypt(objAccountMDL.Password);
                objAccountMDL.UnEncryptedPassword = objAccountMDL.Password;

                HttpPostedFileBase UploadLogo = objAccountMDL.AccountLogo;
                //Convert into the filestream
                if (UploadLogo != null)
                {
                    //Convert Image File into BASE64 and save into database
                    //Stream ms = UploadLogo.InputStream;
                    //byte[] arr = new byte[ms.Length];
                    //ms.Read(arr, 0, Convert.ToInt32(ms.Length));
                    //string base64ImageRepresentation = Convert.ToBase64String(arr);
                    //End

                    if (!Directory.Exists(Server.MapPath("~/AccountLogoImages/")))
                        Directory.CreateDirectory(Server.MapPath("~/AccountLogoImages/"));

                    CommonHelper.Upload(UploadLogo, "~/AccountLogoImages/", UploadLogo.FileName.Substring(0, UploadLogo.FileName.LastIndexOf('.')));

                    if (!string.IsNullOrEmpty(objAccountMDL.AccountLogoStream))
                    {
                        var filePath = Server.MapPath("~/AccountLogoImages/" + objAccountMDL.AccountLogoStream);
                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                    }

                    objAccountMDL.AccountLogoStream = UploadLogo.FileName;
                }
                MessageMDL msg = new MessageMDL();
                msg = objAccountBDL.AddEditAccount(objAccountMDL, out NewCreatedUserId);

                if (objAccountMDL.PK_AccountId == 0 && msg.MessageId > 0)
                {
                    if (NewCreatedUserId != 0)
                    {
                        //ShareUserCredential(NewCreatedUserId);
                    }

                }

                TempData["Message"] = msg;
                return RedirectToAction("Index");
            }
            else
            {

                string Message = string.Join("\n", ModelState.Values
                                       .SelectMany(x => x.Errors)
                                       .Select(x => x.ErrorMessage));
                MSTAccountMDL obj = new MSTAccountMDL();
                obj.FK_CompanyId = SessionInfo.User.fk_companyid;
                obj.IsActive = true;
                return View("AddEditAccount", obj);
            }

        }


        public JsonResult CheckUser(string username)
        {
            return Json(CommonBAL.CheckUserName(username), JsonRequestBehavior.AllowGet);
        }

        //public string ShareUserCredential(Int64 UserId)
        //{
        //    string ccEmail = string.Empty;
        //    string UrlToShare = Convert.ToString(ConfigurationManager.AppSettings["VseenWebUrl"]);
        //    string MailerTemplateKey = Convert.ToString(ConfigurationManager.AppSettings["ShareUserCredentialMailerKey"]);

        //    return new ShareOnSocialMedia().ShareUserCredentialsViaEmail(Convert.ToString(UserId), ccEmail, UrlToShare, MailerTemplateKey);
        //}
    }
}