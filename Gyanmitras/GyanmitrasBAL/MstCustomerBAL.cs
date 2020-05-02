using GyanmitrasMDL;
using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
    public class MstCustomerBAL
    {
        #region
        MstCustomerDAL objCustomerDAL = null;
        #endregion
        public MstCustomerBAL()
        {
            objCustomerDAL = new MstCustomerDAL();
        }
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Add Edit Customer Details
        /// </summary>
        public MessageMDL AddEditCustomer(out string PK_CustomerId,out string countryTimeZone, out List<MstCustomerMDL> _CustomerDatalist, MstCustomerMDL ObjMstCustomerMDL, string jsonbulkupload = "")
        {
            return objCustomerDAL.AddEditCustomer(out PK_CustomerId , out countryTimeZone, out _CustomerDatalist, ObjMstCustomerMDL, jsonbulkupload );
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        public bool GetCustomer(out List<MstCustomerMDL> _PackageDataList, out BasicPagingMDL objBasicPagingMDL,out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 AccountId, Int64 FK_CustomerId, Int64 UserId, string LoginType)
        {
            _PackageDataList = new List<MstCustomerMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            return objCustomerDAL.GetCustomer(out _PackageDataList, out objBasicPagingMDL, out objTotalCountPagingMDL, id, userid, RowPerpage, CurrentPage, SearchBy, SearchValue, AccountId, FK_CustomerId, UserId, LoginType);

        }
       

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Delete Customer Details
        /// </summary>
        public MessageMDL DeleteCustomer(Int64 PK_CustomerId, Int64 UserId)
        {

            return objCustomerDAL.DeleteCustomer(PK_CustomerId, UserId);
        }
        /// <summary>
        /// Created By: Vinish
        /// Created Date:13-01-2020
        /// purpose: Sync Customer Details
        /// </summary>
        public MessageMDL SyncMachineAlert(string jsonids)
        {
            return objCustomerDAL.SyncMachineAlert(jsonids);
        }
    }
}
