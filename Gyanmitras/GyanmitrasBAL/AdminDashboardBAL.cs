using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
    public class AdminDashboardBAL
    {
        AdminDashboardDAL objAdminDashboardDAL = new AdminDashboardDAL();
        public AdminDashboardBAL() {
            objAdminDashboardDAL = new AdminDashboardDAL();
        } 
        public bool GetAdminDashboardDetails(out AdminDashboardMDL _objout, AdminDashboardMDL _obj)
        {
            return objAdminDashboardDAL.GetAdminDashboardDetails(out _objout, _obj);
        }
    }
}
