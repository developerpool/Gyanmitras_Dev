using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
    public class MSTUserAccountMappingBAL
    {
        #region
        MSTUserAccountMappingDAL objMSTUserAccountMappingDAL = null;
        #endregion
        public MSTUserAccountMappingBAL()
        {
            objMSTUserAccountMappingDAL = new MSTUserAccountMappingDAL();
        }
        public bool GetMSTUserAccountMappingDetails(out List<MSTUserAccountMappingMDL> _MapUserAccountList, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPaging, Int64 id, Int64 AccountId, Int64 UserId, Int64 FK_CustomerId, string LoginType, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue)
        {
            return objMSTUserAccountMappingDAL.GetMSTUserAccountMappingDetails(out _MapUserAccountList, out objBasicPagingMDL, out objTotalCountPaging, id, AccountId, UserId, FK_CustomerId, LoginType, RowPerpage, CurrentPage, SearchBy, SearchValue);
        }
        public MessageMDL AddEditMSTUserAccountMapping(MSTUserAccountMappingMDL objMSTUserAccountMappingMDL)
        {
            return objMSTUserAccountMappingDAL.AddEditMSTUserAccountMapping(objMSTUserAccountMappingMDL);
        }
        public MessageMDL DeleteMSTUserAccountMapping(Int64 id, Int64 UserId)
        {
            return objMSTUserAccountMappingDAL.DeleteMSTUserAccountMapping(id, UserId);
        }   
    }
}
