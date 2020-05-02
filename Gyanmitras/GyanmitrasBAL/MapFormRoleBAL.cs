using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
   public class MapFormRoleBAL
    {
        #region
        MapFormRoleDAL objMapFormRoleDAL = null;
        #endregion
        public MapFormRoleBAL()
        {
            objMapFormRoleDAL = new MapFormRoleDAL();
        }
       
        public bool BindSubMenu(out List<RoleMapping> _FormRoleMappinglist, Int64 FK_RoleId, Int64 FK_FormId, string MappingFor, Int64 FK_CompanyId)
        {
            return objMapFormRoleDAL.BindSubMenu(out _FormRoleMappinglist, FK_RoleId, FK_FormId, MappingFor, FK_CompanyId);
        }
        public MessageMDL SaveRoleMapping(RoleMapping item, Int64 UserId, string MappingFor)
        {

            return objMapFormRoleDAL.SaveRoleMapping(item, UserId, MappingFor);
        }
       
    }
}
