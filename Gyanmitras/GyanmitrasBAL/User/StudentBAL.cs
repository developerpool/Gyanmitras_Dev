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
    public class StudentBAL
    {
        StudentDAL objstudentDAL = null;
        public StudentBAL()
        {
            objstudentDAL = new StudentDAL();
        }
        #region Register student
        public StringBuilder RegisterStudent(StudentMDL objstudentMDL)
        {
            return objstudentDAL.RegisterStudent(objstudentMDL);
        }
        #endregion

        #region get student profile
        public StudentMDL GetStudentProfile(string Username)
        {
            return objstudentDAL.GetStudentProfile(Username);
        }
        #endregion
        #region Update student profile
        public StringBuilder UpdateStudentProfile(StudentMDL objstudentMDL)
        {
            return objstudentDAL.UpdateStudentProfile(objstudentMDL);
        }
        #endregion



        public List<SiteUserPlannedCommunication> GetPlannedCommunication(Int64 FK_CounselorID, Int64 FK_StudentID, string LoginType = "")
        {
            return objstudentDAL.GetPlannedCommunication(FK_CounselorID, FK_StudentID, LoginType);
        }


        public MessageMDL AddPlannedCommunication(List<SiteUserPlannedCommunication>  objPlannedCommunication,string IsAdopt)
        {
            return objstudentDAL.AddPlannedCommunication(objPlannedCommunication, IsAdopt);
        }
        
    }
}
