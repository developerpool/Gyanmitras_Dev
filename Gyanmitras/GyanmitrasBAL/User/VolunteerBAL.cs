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
    }
}
