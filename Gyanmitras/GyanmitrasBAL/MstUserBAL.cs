using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
  public class MstUserBAL
    {
        #region constructur
        MstUserDAL objUserMstDal = null;

        public MstUserBAL()
        {
            objUserMstDal = new MstUserDAL();
        }
        #endregion constructur

        #region Methods
        /// <summary>
        /// Get List of User Master 
        /// </summary>
        /// <createdDate>03-Jan-2020</createdDate>
        /// <createdBy>Vinish</createdBy>
        /// <param name="_UserDatalist"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="objTotalCountPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="accountid"></param>
        /// <param name="loginid"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        public bool GetUserMstDetails(out List<MstUserMDL> _UserDatalist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL,int id,Int64 accountid,Int64 loginid, Int64 customerid, string logintype, int RowPerpage, int CurrentPage, string SearchBy = "", string SearchValue = "")
        {
            _UserDatalist = new List<MstUserMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            return objUserMstDal.GetUserDetails(out _UserDatalist, out objBasicPagingMDL,out objTotalCountPagingMDL, id,accountid, loginid, customerid, logintype, RowPerpage, CurrentPage, SearchBy, SearchValue) ;
        }
        /// <summary>
        /// Get List Of UserMaster
        /// </summary>
        /// <param name="userMstMDL"></param>
        /// <createdDate>03-Jan-2020</createdDate>
        /// <createdBy>Vinish</createdBy>
        /// <returns></returns>
        public MessageMDL AddEditUser(MstUserMDL userMstMDL)
        {
            return objUserMstDal.AddEditUser(userMstMDL);
        }
        /// <summary>
        /// Delete User Master By UserId 
        /// </summary>
        /// <createdDate>03-Jan-2020</createdDate>
        /// <createdBy>Vinish</createdBy>
        /// <param name="id"></param>
        /// <param name="loginid"></param>
        /// <returns></returns>
        public MessageMDL DeleteUser(int id, int loginid)
        {
            return objUserMstDal.DeleteUser(id, loginid);
        }
        /// <summary>
        /// Get Category List
        /// </summary>
        /// <createdDate>03-Jan-2020</createdDate>
        /// <createdBy>Vinish</createdBy>
        /// <returns></returns>
        public static List<CategoryMDL> Category()
        {
            return MstUserDAL.CategoryDAL();
        }
        /// <summary>
        /// Get Role List
        /// </summary>
        /// <createdDate>03-Jan-2020</createdDate>
        /// <createdBy>Vinish</createdBy>
        /// <returns></returns>
        public static List<MstRoleMDL> Rolelist(int AccountID, int CustomerId)
        {
            return MstUserDAL.RolelistDAL(AccountID, CustomerId);
        }
        #endregion Methods

    }
}
