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
    public class MapFormRoleController : BaseController
    {
        List<RoleMapping> _FormRoleMappinglist = null;
        JavaScriptSerializer jss;
        MapFormRoleBAL objMapFormRoleBAL = null;


        public MapFormRoleController()
        {
            jss = new JavaScriptSerializer();
            objMapFormRoleBAL = new MapFormRoleBAL();
        }
        public ActionResult Index()
        {
            ViewBag.CanAdd = UserInfoMDL.GetUserRoleAndRights.CanAdd;
            ViewBag.CanEdit = UserInfoMDL.GetUserRoleAndRights.CanEdit;
            ViewBag.CanDelete = UserInfoMDL.GetUserRoleAndRights.CanDelete;
            ViewData["ParentFormsList"] = CommonBAL.BindParentForms();
            ViewData["CompanyList"] = CommonBAL.BindAllCompany();
            if (TempData["RoleRightsMessage"] != null)
            {
                ViewBag.Msg = (MessageMDL)TempData["RoleRightsMessage"];
                TempData["RoleRightsMessage"] = null;
            }
            return View();
        }


        /// <summary>
        /// To Bind The Sub Menu's
        /// </summary>
        /// <param name="FK_RoleId"></param>
        /// <param name="FK_FormId"></param>
        /// <returns></returns>
        public PartialViewResult BindSubMenu(Int64 FK_RoleId, Int64 FK_FormId, string MappingFor, Int64 FK_CompanyId)
        {
            FormRoleViewMDL objFormRoleViewMDL = new FormRoleViewMDL();
            objMapFormRoleBAL.BindSubMenu(out _FormRoleMappinglist, FK_RoleId, FK_FormId, MappingFor, FK_CompanyId);
            objFormRoleViewMDL.Forms = _FormRoleMappinglist;
            return PartialView("_FormRoleMapping", objFormRoleViewMDL);
        }
        /// <summary>
        /// To Save Form Role Mapping 
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        /// 
        [HttpPost]
        public ActionResult SaveFormRoleMapping(FormRoleViewMDL obj)
        {
            List<RoleMapping> FormroleMappings = obj.Forms;

            if (FormroleMappings.Count > 1 && FormroleMappings.Any(x => x.CanView == true))
            {
                FormroleMappings[0].CanAdd = true;
                FormroleMappings[0].CanEdit = true;
                FormroleMappings[0].CanDelete = true;
                FormroleMappings[0].CanView = true;
            }

            FormroleMappings.ForEach(r =>
            {
                r.FK_RoleId = obj.FK_RoleId;
                    // r.FK_FormId = obj.FK_FormId;
                    r.CreatedBy = SessionInfo.User.UserId;
            });

            string jsondata = jss.Serialize(FormroleMappings);
            
            foreach (var item in FormroleMappings)
            {
                MessageMDL msg = objMapFormRoleBAL.SaveRoleMapping(item, SessionInfo.User.UserId, obj.Mapping);
                
                if (msg != null && msg.MessageId == 1)
                {
                    TempData["roleId"] = obj.FK_RoleId;
                    ViewBag.msg = msg;
                }
                else
                {
                    msg.Message = GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                    ViewBag.msg = msg;
                    return RedirectToAction("Index");
                }
                
            }
            return RedirectToAction("Index");


        }
        /// <summary>
        /// To Bind Roles
        /// </summary>
        /// <param name="FK_CustomerID"></param>
        /// <returns></returns>
        public JsonResult BindRoles(Int64 FK_CompanyId)
        {
            return Json(CommonBAL.BindRolesByCompany(FK_CompanyId), JsonRequestBehavior.AllowGet);
        }
    }
}