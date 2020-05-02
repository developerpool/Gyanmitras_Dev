using GyanmitrasDAL.DataUtility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasDAL.Common
{
    public class ErrorLogDAL
    {
        /// <summary>
        /// LOG ERROR DETAILS IN DB
        /// CREATED BY Vinish
        /// CREATED DATE 06 JAN 2020
        /// </summary>       
        public static void SetError(string name, string controller, string action, string Source, string message, string type, string Remarks)
        {
            
            try
            {
                string commandText = "[dbo].[usp_LogApplicationError]";
                List<SqlParameter> paramList = new List<SqlParameter>();

                SqlParameter objSqlParameter = new SqlParameter("@cAssemblyName", SqlDbType.VarChar);
                objSqlParameter.Value = name;
                paramList.Add(objSqlParameter);

                objSqlParameter = new SqlParameter("@cClassName", SqlDbType.VarChar);
                objSqlParameter.Value = controller;
                paramList.Add(objSqlParameter);

                objSqlParameter = new SqlParameter("@cMethodName", SqlDbType.VarChar);
                objSqlParameter.Value = action;
                paramList.Add(objSqlParameter);

                objSqlParameter = new SqlParameter("@cSource", SqlDbType.VarChar);
                objSqlParameter.Value = Source;
                paramList.Add(objSqlParameter);

                

                

                

                objSqlParameter = new SqlParameter("@cErrorMessage", SqlDbType.VarChar);
                objSqlParameter.Value = message;
                paramList.Add(objSqlParameter);

                objSqlParameter = new SqlParameter("@cErrorType", SqlDbType.VarChar);
                objSqlParameter.Value = type;
                paramList.Add(objSqlParameter);


                objSqlParameter = new SqlParameter("@cRemarks", SqlDbType.VarChar);
                objSqlParameter.Value = Remarks;
                paramList.Add(objSqlParameter);

                new DataFunctions().executeCommand(commandText, paramList);
            }
            catch { }
            // throw new NotImplementedException();
        }

        /// <summary>
        /// LOG SERVICE ERROR DETAILS IN DB
        /// CREATED BY Vinish
        /// CREATED DATE 14 JAN 2020
        /// </summary> 
        public static void SetErrorService(string Source, string AssemblyName, string ClassName, string MethodName, string ErrorMessage, string Remarks)
        {
            try
            {
                string commandText = "[dbo].[usp_LogServiceError]";
                List<SqlParameter> paramList = new List<SqlParameter>();

                SqlParameter objSqlParameter = new SqlParameter("@cSource", SqlDbType.VarChar);
                objSqlParameter.Value = Source;
                paramList.Add(objSqlParameter);

                objSqlParameter = new SqlParameter("@cAssemblyName", SqlDbType.VarChar);
                objSqlParameter.Value = AssemblyName;
                paramList.Add(objSqlParameter);

                objSqlParameter = new SqlParameter("@cClassName", SqlDbType.VarChar);
                objSqlParameter.Value = ClassName;
                paramList.Add(objSqlParameter);

                objSqlParameter = new SqlParameter("@cMethodName", SqlDbType.VarChar);
                objSqlParameter.Value = MethodName;
                paramList.Add(objSqlParameter);

                objSqlParameter = new SqlParameter("@cErrorMessage", SqlDbType.VarChar);
                objSqlParameter.Value = ErrorMessage;
                paramList.Add(objSqlParameter);


                objSqlParameter = new SqlParameter("@cRemarks", SqlDbType.VarChar);
                objSqlParameter.Value = Remarks;
                paramList.Add(objSqlParameter);

                new DataFunctions().executeCommand(commandText, paramList);


            }
            catch { }

        }
    }
}
