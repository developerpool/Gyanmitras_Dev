using GyanmitrasMDL;
using GyanmitrasDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GyanmitrasDAL.User;
using GyanmitrasMDL.User;

namespace GyanmitrasBAL.User
{
    public class CounselorBAL
    {
        CounselorDAL objcounselorDAL = null;
        public CounselorBAL()
        {
            objcounselorDAL = new CounselorDAL();
        }
        #region Register counselor
        public StringBuilder RegisterCounselor(CounselorMDL objcounselorMDL)
        {
            return objcounselorDAL.RegisterCounselor(objcounselorMDL);
        }
        #endregion

        #region get counselor profile
        public CounselorMDL GetCounselorProfile(string Username)
        {
            return objcounselorDAL.GetCounselorProfile(Username);
        }
        #endregion
        #region Update counselor profile
        public StringBuilder UpdateCounselorProfile(CounselorMDL objcounselorMDL)
        {
            return objcounselorDAL.UpdateCounselorProfile(objcounselorMDL);
        }
        #endregion

    }
}
