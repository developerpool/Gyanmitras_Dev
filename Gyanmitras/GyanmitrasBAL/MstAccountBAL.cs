using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
    public class MSTAccountBAL
    {
        MSTAccountDAL objAccountDAL = null;
        public MSTAccountBAL()
        {
            objAccountDAL = new MSTAccountDAL();
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        public bool GetAccountDetails(out List<MSTAccountMDL> _PackageDataList, out BasicPagingMDL objBasicPagingMDL,out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue,Int64 AccountId, Int64 FK_CustomerId, Int64 UserId, string LoginType)
        {
            _PackageDataList = new List<MSTAccountMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            return objAccountDAL.GetAccountDetails(out _PackageDataList, out objBasicPagingMDL, out objTotalCountPagingMDL, id, userid, RowPerpage, CurrentPage, SearchBy, SearchValue, AccountId, FK_CustomerId, UserId, LoginType);

        }
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Add Edit Account Details
        /// </summary>
        public MessageMDL AddEditAccount(MSTAccountMDL objAccountMDL, out Int64 NewCreatedUserId)
        {
            NewCreatedUserId = 0;
            return objAccountDAL.AddEditAccount(objAccountMDL, out NewCreatedUserId);
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Delete Account Details
        /// </summary>
        public MessageMDL DeleteAccount(Int64 id, Int64 CreatedBy, int FK_CompanyId)
        {
            return objAccountDAL.DeleteAccount(id, CreatedBy, FK_CompanyId);
        }
    }
}
