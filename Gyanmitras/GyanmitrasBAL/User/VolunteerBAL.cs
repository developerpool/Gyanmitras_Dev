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
    public class VolunteerBAL
    {

        VolunteerDAL objVolunteerDAL = null;
        public VolunteerBAL()
        {
            objVolunteerDAL = new VolunteerDAL();
        }
        #region Register student
        public StringBuilder RegisterVolunteer(VolunteerMDL objVolunteerMDL)
        {
            return objVolunteerDAL.RegisterVolunteer(objVolunteerMDL);
        }
        #endregion
        #region get student profile
        public VolunteerMDL GetVolunteerProfile(string Username)
        {
            return objVolunteerDAL.GetVolunteerProfile(Username);
        }
        #endregion
        #region Update student profile
        public StringBuilder UpdateVolunteerProfile(VolunteerMDL objVolunteerMDL)
        {
            return objVolunteerDAL.UpdateVolunteerProfile(objVolunteerMDL);
        }
        #endregion
    }
}
