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

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class ManageFeedBackController : BaseController
    {
        public BasicPagingMDL objBasicPagingMDL = new BasicPagingMDL();
        private readonly MstManageFeedBackBAL objMstManageFeedBackBAL;
        private List<MstFeedBackCriteriaMDL> _FeedbackCriteriaMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;
        // GET: Admin/ManageFeedBack

        public ManageFeedBackController()
        {
            UserInfoMDL U = SessionInfo.User;
            if (U != null)
            {
                ViewBag.LoginType = U.LoginType;
                ViewBag.Parent_AccountId = U.AccountId;
            }

            objMstManageFeedBackBAL = new MstManageFeedBackBAL();
            _FeedbackCriteriaMDL = new List<MstFeedBackCriteriaMDL>();
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
            GetFeedBackCriteria();
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
        public PartialViewResult GetFeedBackCriteria(int RowPerpage = 10, int CurrentPage = 1, string SearchBy = "", string SearchValue = "")
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            _FeedbackCriteriaMDL = new List<MstFeedBackCriteriaMDL>();
            objMstManageFeedBackBAL.GetFeedBackCriteria(out _FeedbackCriteriaMDL, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, SessionInfo.User.UserId, RowPerpage, CurrentPage, SearchBy, SearchValue);

            ViewBag.userCheck = SessionInfo.User.UserName;
            ViewBag.paging = objBasicPagingMDL;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL;


            TempData["ExportData"] = _FeedbackCriteriaMDL;
            TempData["TotalItemCount"] = objTotalCountPagingMDL.TotalItem;
            return PartialView("_ManageFeedBackCriteriaGrid", _FeedbackCriteriaMDL);
        }


        /// <summary>
        /// Update method Of user master 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddEditFeedBackCriteria(int id = 0)
        {
            ViewBag.Title = "Manage FeedBack Criteria";
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            ViewBag.cate = SessionInfo.User.CategoryId;
            ViewBag.logintype = SessionInfo.User.LoginType;
            ViewData["SiteUserCategory"] = CommonBAL.FillSiteUserCategory();

            if (id != 0)
            {
                _FeedbackCriteriaMDL = new List<MstFeedBackCriteriaMDL>();
                objMstManageFeedBackBAL.GetFeedBackCriteria(out _FeedbackCriteriaMDL, out objBasicPagingMDL, out objTotalCountPagingMDL, id, SessionInfo.User.UserId, 10, 1, "", "");

                return View("AddEditFeedBackCriteria", _FeedbackCriteriaMDL[0]);
            }
            else
            {
                MstFeedBackCriteriaMDL obj = new MstFeedBackCriteriaMDL();
                obj.IsActive = true;
                return View("AddEditFeedBackCriteria", obj);
            }
        }
        /// <summary>
        /// Post Method of User master(Insert Data of user master)
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="userMstMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddEditFeedBackCriteria(MstFeedBackCriteriaMDL userMstMDL)
        {
            ViewBag.Title = "FeedBackCriteria Management";
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            try
            {
                userMstMDL.CreatedBy = SessionInfo.User.UserId;

                MessageMDL msg = objMstManageFeedBackBAL.AddEditFeedBackCriteria(userMstMDL);
                TempData["Message"] = msg;
                return RedirectToAction("Index");

            }
            catch (Exception ex)
            {
            }
            return RedirectToAction("AddEditFeedBackCriteria");
        }
        /// <summary>
        /// Delete user by ID 
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult DeleteFeedBackCriteria(Int64 id)
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            CommonBAL objMDL = new CommonBAL();
            MessageMDL msg = objMstManageFeedBackBAL.DeleteFeedBackCriteria(id, SessionInfo.User.UserId);
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
    }
}