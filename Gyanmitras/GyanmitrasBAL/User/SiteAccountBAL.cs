using GyanmitrasDAL;
using GyanmitrasDAL.User;
using GyanmitrasMDL;
using GyanmitrasMDL.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL.User
{
  public  class SiteAccountBAL
    {

        #region
        SiteAccountDAL objAccountDAL = null;
        #endregion
        public SiteAccountBAL()
        {
            objAccountDAL = new SiteAccountDAL();
        }
        /// <summary>
        /// AUTHENTICATE USER
        /// </summary>
        /// <param name="ObjLoginMDL"></param>
        /// <param name="_User"></param>
        /// <param name="_formlist"></param>
        /// <returns></returns>
        public MessageMDL AuthenticateSiteUser(SiteLoginMDL ObjLoginMDL, out SiteUserInfoMDL _User)
        {
            return objAccountDAL.AuthenticateSiteUser(ObjLoginMDL,out _User);
        }

        public LoginMDL GetUserDetails(string userName)
        {
            return objAccountDAL.GetUserDetails(userName);
        }

    }
}
