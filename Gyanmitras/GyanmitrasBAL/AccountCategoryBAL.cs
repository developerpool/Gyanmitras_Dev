using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GyanmitrasDAL;
using GyanmitrasMDL;

namespace GyanmitrasBAL
{
    public class AccountCategoryBAL
    {
        AccountCategoryDAL objAccountCategoryDAL = null;
        public AccountCategoryBAL()
        {
            objAccountCategoryDAL = new AccountCategoryDAL();
        }
        /// <summary>
        /// Created By: Vinish  
        /// Created Date: 13-12-2019  
        /// Purpose: Add a Account Category
        /// </summary>
        /// <param name="AccountTypeMDL"></param>
        /// <returns></returns>
        public MessageMDL AddEditAccountType(AccountCategoryMDL objAccountTypeMDL)
        {
            return objAccountCategoryDAL.AddEditAccountType(objAccountTypeMDL);
        }

        /// <summary>
        /// Purpose:-Get Account Category  by Id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool GetAccountType(out List<AccountCategoryMDL> _AccountTypelist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, string searchBy, string searchValue, int RowPerpage, int CurrentPage, Int64 FK_AccountId, Int64 FK_CustomerId, Int64 FK_UserId, string LoginType)
        {
            _AccountTypelist = new List<AccountCategoryMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            return objAccountCategoryDAL.GetAccountType(out _AccountTypelist, out objBasicPagingMDL, out objTotalCountPagingMDL ,  id, searchBy, searchValue , RowPerpage, CurrentPage,FK_AccountId,FK_CustomerId,FK_UserId,LoginType);
        }
        /// <summary>
        /// Delete Account Category
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public MessageMDL DeleteAccountCategory(int id, int UserId)
        {
            return objAccountCategoryDAL.DeleteAccountCategory(id, UserId);
        }



    }
}
