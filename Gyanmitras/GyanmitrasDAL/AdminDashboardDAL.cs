using GyanmitrasDAL.Common;
using GyanmitrasDAL.DataUtility;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasDAL
{
    public class AdminDashboardDAL
    {
        #region
        DataFunctions objDataFunctions = null;
        DataSet objDataSet = null;
        string _commandText = string.Empty;
        #endregion

        public AdminDashboardDAL()
        {
            objDataFunctions = new DataFunctions();
        }

        public bool GetAdminDashboardDetails(out AdminDashboardMDL _objout, AdminDashboardMDL _obj)
        {
            bool result = false;
            _objout = new AdminDashboardMDL();
            System.Data.DataSet objDataSet = null;
            
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                    {
                        new SqlParameter("@FK_StateId",_obj.FK_StateId),
                        new SqlParameter("@year",_obj.Year),
                        new SqlParameter("@month",_obj.Month),
                        

                    };
                _commandText = "[SiteUsers].[USP_GetAdminDashboardDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet != null && objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {


                        _objout = new AdminDashboardMDL()
                        {
                            StudentCount = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[1].Rows[0].Field<int?>("StudentCount")),
                            CounselorCount = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[1].Rows[0].Field<int?>("CounselorCount")),
                            VolunteerCount = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[1].Rows[0].Field<int?>("VolunteerCount")),
                        };
                        
                        
                        objDataSet.Dispose();
                        result = true;
                    }
                    else
                    {
                        result = false;
                    }
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return result;
        }

    }
}
