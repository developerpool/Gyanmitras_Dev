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
using GyanmitrasDAL;
using Newtonsoft.Json;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class ManageFeedController : BaseController
    {
        public BasicPagingMDL objBasicPagingMDL = new BasicPagingMDL();
        private readonly MstManageFeedBAL objMstManageFeedBAL;
        private List<MstManageFeedMDL> _ManageFeedMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;


        public ManageFeedController()
        {
            UserInfoMDL U = SessionInfo.User;
            if (U != null)
            {
                ViewBag.LoginType = U.LoginType;
                ViewBag.Parent_AccountId = U.AccountId;
            }

            objMstManageFeedBAL = new MstManageFeedBAL();
            _ManageFeedMDL = new List<MstManageFeedMDL>();
        }


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
            GetManageFeed();
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
        public PartialViewResult GetManageFeed(int RowPerpage = 10, int CurrentPage = 1, string SearchBy = "", string SearchValue = "")
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            _ManageFeedMDL = new List<MstManageFeedMDL>();
            objMstManageFeedBAL.GetManageFeed(out _ManageFeedMDL, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.UserId, RowPerpage, CurrentPage, SearchBy, SearchValue);

            ViewBag.userCheck = SessionInfo.User.UserName;
            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;


            TempData["ExportData"] = _ManageFeedMDL;
            TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            return PartialView("_ManageFeedGrid", _ManageFeedMDL);
        }


        /// <summary>
        /// Update method Of user master 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditManageFeed(int id = 0)
        {
            ViewBag.Title = "Manage FeedBack";
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            ViewBag.cate = SessionInfo.User.CategoryId;
            ViewBag.logintype = SessionInfo.User.LoginType;
            ViewData["SiteUserCategory"] = CommonBAL.FillSiteUserCategory();
            ViewData["SiteUser"] = CommonBAL.FillSiteUser();

            if (id != 0)
            {
                _ManageFeedMDL = new List<MstManageFeedMDL>();
                objMstManageFeedBAL.GetManageFeed(out _ManageFeedMDL, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.UserId, 10, 1, "", "");

                return View("AddEditManageFeed", _ManageFeedMDL[0]);
            }
            else
            {
                MstManageFeedMDL obj = new MstManageFeedMDL();
                obj.IsActive = true;
                return View("AddEditManageFeed", obj);
            }
        }


        /// <summary>
        /// Post Method of User master(Insert Data of user master)
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="userMstMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddEditManageFeed(MstManageFeedMDL userMstMDL)
        {
            ViewBag.Title = "Feed Management";
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            try
            {
                userMstMDL.CreatedBy = SessionInfo.User.UserId;

                MessageMDL msg = objMstManageFeedBAL.AddEditManageFeed(userMstMDL);
                TempData["Message"] = msg;
                return RedirectToAction("Index");

            }
            catch (Exception ex)
            {
            }
            return RedirectToAction("AddEditManageFeed");
        }
        /// <summary>
        /// Delete user by ID 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult DeleteManageFeed(Int64 id)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            CommonBAL objMDL = new CommonBAL();
            MessageMDL msg = objMstManageFeedBAL.DeleteManageFeed(id, SessionInfo.User.UserId);
            if (msg.MessageId == 1)
            {
                msg.Message = msg.Message;
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


        public JsonResult BindAreaOfInterestList(string type = "")
        {
            return Json(CommonBAL.BindAreaOfInterestList(type), JsonRequestBehavior.AllowGet);
        }


    }
}