using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
  public  class MstRoleBAL
    {
        #region
        MstRoleDAL objMstRoleDAL = null;
        #endregion
        public MstRoleBAL()
        {
            objMstRoleDAL = new MstRoleDAL();
        }
        public MessageMDL AddEditRole(MstRoleMDL ObjMstRoleMDL)
        {
            return objMstRoleDAL.AddEditRole(ObjMstRoleMDL);
        }

        public bool getRole(out List<MstRoleMDL> _RoleDetaillist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPaging, Int64 Id, Int64 FK_CompanyId, Int64 UserId, int RecordsPerPage, string LogInType, int CurrentPage = 1, string SearchBy = "", string SearchValue = "")
        {
            return objMstRoleDAL.getRole(out _RoleDetaillist, out objBasicPagingMDL, out objTotalCountPaging, Id, FK_CompanyId, UserId, RecordsPerPage, LogInType, CurrentPage, SearchBy, SearchValue);
        }
        public bool BindSubMenu(out List<RoleMapping> _FormRoleMappinglist, Int64 FK_RoleId, Int64 FK_FormId, string MappingFor, Int64 FK_AccountId, Int64 FK_CustomerId)
        {
            return objMstRoleDAL.BindSubMenu(out _FormRoleMappinglist, FK_RoleId, FK_FormId, MappingFor, FK_AccountId, FK_CustomerId);
        }
        public MessageMDL SaveRoleMapping(string JsonData, Int64 UserId, string MappingFor)
        {

            return objMstRoleDAL.SaveRoleMapping(JsonData, UserId, MappingFor);
        }
        public MessageMDL DeleteRole(Int64 PK_RoleId, Int64 UserId)
        {

            return objMstRoleDAL.DeleteRole(PK_RoleId, UserId);
        }
    }
}
