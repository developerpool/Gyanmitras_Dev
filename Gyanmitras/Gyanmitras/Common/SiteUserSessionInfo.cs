using GyanmitrasMDL;
using GyanmitrasMDL.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Gyanmitras.Common
{
    public class SiteUserSessionInfo
    {

        public static SiteUserInfoMDL User
        {
            get
            {
                SiteUserInfoMDL _user = null;
                if (HttpContext.Current.Session["SiteUser"] != null)
                {
                    _user = (SiteUserInfoMDL)(HttpContext.Current.Session["SiteUser"]);
                }
                return _user;
            }
            set
            {
                HttpContext.Current.Session["SiteUser"] = value;
            }
        }
        //public static CompanyRightsMDL CompanyRights
        //{
        //    get
        //    {
        //        CompanyRightsMDL _CompanyRightsMDL = null;
        //        if (HttpContext.Current.Session["CompanyRights"] != null)
        //        {
        //            _CompanyRightsMDL = (CompanyRightsMDL)(HttpContext.Current.Session["CompanyRights"]);
        //        }
        //        return _CompanyRightsMDL;
        //    }
        //    set
        //    {
        //        HttpContext.Current.Session["CompanyRights"] = value;
        //    }
        //}

        public static List<FormMDL> formlist
        {
            get
            {
                List<FormMDL> _formlist = null;
                if (HttpContext.Current.Session["SiteUserFormList"] != null)
                {
                    _formlist = (List<FormMDL>)(HttpContext.Current.Session["SiteUserFormList"]);
                }
                return _formlist;
            }
            set
            {
                HttpContext.Current.Session["SiteUserFormList"] = value;
            }
        }
        public static void RemoveSession()
        {
            formlist = null;
            User = null;
        }
    }
}