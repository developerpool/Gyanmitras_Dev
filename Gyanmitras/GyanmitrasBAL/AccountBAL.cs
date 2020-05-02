using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
  public  class AccountBAL
    {

        #region
        AccountDAL objAccountDAL = null;
        #endregion
        public AccountBAL()
        {
            objAccountDAL = new AccountDAL();
        }
        /// <summary>
        /// AUTHENTICATE USER
        /// </summary>
        /// <param name="ObjLoginMDL"></param>
        /// <param name="_User"></param>
        /// <param name="_formlist"></param>
        /// <returns></returns>
        public MessageMDL AuthenticateUser(LoginMDL ObjLoginMDL, out UserInfoMDL _User, out List<FormMDL> _formlist)
        {
            return objAccountDAL.AuthenticateUser(ObjLoginMDL,out _User,out _formlist);
        }

        public LoginMDL GetUserDetails(string userName)
        {
            return objAccountDAL.GetUserDetails(userName);
        }

    }
}
