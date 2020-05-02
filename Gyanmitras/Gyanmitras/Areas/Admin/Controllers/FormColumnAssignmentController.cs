using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using GyanmitrasMDL;
using GyanmitrasBAL.Common;
using GyanmitrasBAL;
using Gyanmitras.Common;

namespace Gyanmitras.Areas.Admin.Controllers
{
    public class FormColumnAssignmentController : BaseController
    {
        public BasicPagingMDL objBasicPagingMDL = new BasicPagingMDL();
        private List<FormColumnAssignmentMDL> _FormColumnListList;

        public ActionResult Index()
        {
            if (TempData["Message"] != null)
            {
                ViewBag.Msg = (MessageMDL)TempData["Message"];
                TempData["Message"] = null;
            }
            return View();
        }




        /// <summary>
        /// Purpose: To Render partial View 
        /// </summary>
        /// <returns></returns>
        public PartialViewResult GetFormColumn(string searchBy = "", string searchValue = "", int currentPage = 1,int RowPerpage=10)
        {

            FormColunmAssignmentBAL objFormcolumnBAl = new FormColunmAssignmentBAL();
            objFormcolumnBAl.GetFormColumAssignment(out _FormColumnListList, out objBasicPagingMDL, 0, SessionInfo.User.AccountId, SessionInfo.User.UserId, searchBy, searchValue, RowPerpage, currentPage, SessionInfo.User.CategoryId, SessionInfo.User.LoginType);

            ViewBag.paging = objBasicPagingMDL;
            TempData["FileData"] = _FormColumnListList;
            return PartialView("_FormColumnListListGrid", _FormColumnListList);

        }

        /// <summary>
        /// Purpose: To Get column data by Id
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AddFormColumnAssignment(int id = 0, string searchBy = "", string searchValue = "")
        {
            ViewData["Form"] = CommonBAL.BindForms();
            ViewData["Account"] = CommonBAL.BindAccountsByCategory(SessionInfo.User.CategoryId);
            FormColunmAssignmentBAL objFormcolumnBAl = new FormColunmAssignmentBAL();
            AccountCategoryMDL objAccountCategoryMDL = new AccountCategoryMDL();
            if (id != 0)
            {
                objFormcolumnBAl.GetFormColumAssignment(out _FormColumnListList, out objBasicPagingMDL, id,SessionInfo.User.AccountId, SessionInfo.User.UserId, searchBy, searchValue, 10, 1,  SessionInfo.User.CategoryId, SessionInfo.User.LoginType);
                return View("AddFormColumnAssignment", _FormColumnListList[0]);
            }
            else
            {
                return View("AddFormColumnAssignment", _FormColumnListList);
            }


        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date: 02-01-2020 
        /// Purpose: Add a Form Column Assinment
        /// </summary>
        /// <param name="FormColumnAssignmentMDL"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult AddFormColumnAssignment(FormColumnAssignmentMDL objFormColumnMDL)
        {
           FormColunmAssignmentBAL objFormcolumnBAl = new FormColunmAssignmentBAL();
            objFormColumnMDL.UserId = SessionInfo.User.UserId;
           // objFormColumnMDL.AccountId = SessionInfo.User.AccountId;
            MessageMDL msg = objFormcolumnBAl.AddFormColumnAssignment(objFormColumnMDL);
            TempData["Message"] = msg;
            return RedirectToAction("Index");

        }
        /// <summary>
        /// Purpose: To Delete Form Column by Id
        /// </summary>
        /// <returns></returns>
        public ActionResult DeleteFormColumnAssignment(int id)
        {
            FormColunmAssignmentBAL objFormcolumnBAl = new FormColunmAssignmentBAL();
            MessageMDL msg = objFormcolumnBAl.DeleteFormColumnAssignment(id, 1);
            TempData["Message"] = msg;
            return RedirectToAction("Index");
        }
    }
}