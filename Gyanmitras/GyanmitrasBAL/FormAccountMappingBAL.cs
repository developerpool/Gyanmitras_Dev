using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
   public class FormAccountMappingBAL
    {
        #region
        FormAccountMappingDAL objFormAccountMappingDAL = null;
        #endregion
        public FormAccountMappingBAL()
        {
            objFormAccountMappingDAL = new FormAccountMappingDAL();
        }

        public MessageMDL AddEditFormAccountMapping(FormAccountMappingMDL objFormAccountMappingMDL)
        {
            return objFormAccountMappingDAL.AddEditFormAccountMapping(objFormAccountMappingMDL);
        }
        public bool GetFormAccountMappingDetails(out List<FormAccountMappingMDL> _MapFormAccountList, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPaging, Int64 id, Int64 AccountId, Int64 UserId, Int64 FK_CustomerId,string LoginType, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue)
        {
            return objFormAccountMappingDAL.GetFormAccountMappingDetails(out _MapFormAccountList, out objBasicPagingMDL, out objTotalCountPaging, id, AccountId, UserId,FK_CustomerId,LoginType, RowPerpage, CurrentPage, SearchBy, SearchValue);
        }
        public MessageMDL DeleteFormAccountMapping(Int64 id, Int64 UserId)
        {
            return objFormAccountMappingDAL.DeleteFormAccountMapping(id, UserId);
        }
    }
}
