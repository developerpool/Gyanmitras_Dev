﻿using GyanmitrasMDL;
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
    }
}
