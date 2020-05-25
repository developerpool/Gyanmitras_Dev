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
    public class ManageFeedBackController : BaseController
    {
        public BasicPagingMDL objBasicPagingMDL = new BasicPagingMDL();
        private readonly MstManageFeedBackBAL objMstManageFeedBackBAL;
        private List<MstFeedBackCriteriaMDL> _FeedbackCriteriaMDL = null;
        static TotalCountPagingMDL objTotalCountPagingMDL = null;


        public BasicPagingMDL objBasicPagingMDL1 = new BasicPagingMDL();
        private readonly MstManageFeedBackBAL objMstManageFeedBackBAL1;
        private List<FeedBackMDL> _FeedbackCriteriaMDL1 = null;
        static TotalCountPagingMDL objTotalCountPagingMDL1 = null;
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


        public ActionResult IndexRating()
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
            GetFeedBack();
            ViewBag.totalcount = objTotalCountPagingMDL1;
            return View();
        }

        [HttpGet]
        public ActionResult AddEditFeedBack(int id = 0)
        {
            ViewBag.Title = "Manage FeedBack Rating";
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            ViewBag.cate = SessionInfo.User.CategoryId;
            ViewBag.logintype = SessionInfo.User.LoginType;

            if (id != 0)
            {
                _FeedbackCriteriaMDL1 = new List<FeedBackMDL>();
                objMstManageFeedBackBAL.GetFeedBack(out _FeedbackCriteriaMDL1, out objBasicPagingMDL1, out objTotalCountPagingMDL1, id, SessionInfo.User.UserId, 10, 1, "", "","admin");
                ViewBag.SearchValue = _FeedbackCriteriaMDL1[0].FeedBackByCategory;
                return View("AddEditFeedBack", _FeedbackCriteriaMDL1[0]);
            }
            else
            {
                FeedBackMDL obj = new FeedBackMDL();
                obj.IsActive = true;
                return View("AddEditFeedBack", obj);
            }
        }


        [HttpGet]
        public JsonResult GetManageFeedBackCriteriaDetails(string SearchBy ,string SearchValue)
        {
            MstManageFeedBackBAL objMstManageFeedBackBAL = new MstManageFeedBackBAL();
            List<MstFeedBackCriteriaMDL> _DataList = new List<MstFeedBackCriteriaMDL>();
            BasicPagingMDL objBasicPagingMDL = new BasicPagingMDL();
            TotalCountPagingMDL objTotalCountPagingMDL = new TotalCountPagingMDL();
            objMstManageFeedBackBAL.GetFeedBackCriteria(out _DataList, out objBasicPagingMDL, out objTotalCountPagingMDL, 0, 0, 1000, 1, SearchBy, SearchValue);

            return Json(_DataList, JsonRequestBehavior.AllowGet);
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
        /// Get Details Of User Master in List
        /// </summary>
        /// <createdBy>Vinish</createdBy>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        [HttpGet]
        public PartialViewResult GetFeedBack(int RowPerpage = 10, int CurrentPage = 1, string SearchBy = "", string SearchValue = "")
        {

            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanView = UserInfoMDL.GetUserRoleAndRights.CanView;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;

            _FeedbackCriteriaMDL1 = new List<FeedBackMDL>();
            objMstManageFeedBackBAL.GetFeedBack(out _FeedbackCriteriaMDL1, out objBasicPagingMDL1, out objTotalCountPagingMDL1, 0, SessionInfo.User.UserId, RowPerpage, CurrentPage, SearchBy, SearchValue,"admin");

            ViewBag.paging = objBasicPagingMDL1;
            ViewBag.TotalCountPaging = objTotalCountPagingMDL1;
            

            TempData["ExportData"] = _FeedbackCriteriaMDL1;
            TempData["TotalItemCount"] = objTotalCountPagingMDL1.TotalItem;
            return PartialView("_ManageFeedBackGrid", _FeedbackCriteriaMDL1);
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
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose:
        /// </summary>
        /// 
        [HttpGet]
        public JsonResult AddEditFeedBackPost(int myRateFeedBack,Int64 PK_FeedBackID)
        {
            MstManageFeedBackBAL obj = new MstManageFeedBackBAL();
            Int64 FK_CounselorID = SessionInfo.User.UserId;
            List<FeedBackMDL> objFeedBackMDL = new List<FeedBackMDL>();
            objFeedBackMDL.Add(new FeedBackMDL()
            {
                RateFeedBack = myRateFeedBack,
                CreatedBy = SessionInfo.User.UserId
            });
            return Json(obj.AddEditFeedBack(objFeedBackMDL, PK_FeedBackID), JsonRequestBehavior.AllowGet);
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