
using GyanmitrasMDL;
using GyanmitrasDAL.DataUtility;

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GyanmitrasDAL.Common;
using Utility;
using GyanmitrasMDL.User;

namespace GyanmitrasDAL.User
{
    public class CounselorDAL
    {
        static DataFunctions objDataFunctions = null;
        System.Data.DataSet objDataSet = null;
        static string _commandText = String.Empty;
        public CounselorDAL()
        {
            objDataFunctions = new DataFunctions();
        }

       
    }
}
