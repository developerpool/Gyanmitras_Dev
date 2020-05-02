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
  public class MapFormColumnConfigurationDAL
    {
        #region
        DataFunctions objDataFunctions = null;
        DataTable objDataTable = null;
        DataSet objDataSet = null;
        string _commandText = string.Empty;

        #endregion

        public MapFormColumnConfigurationDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        #region Update Form Column Config
        /// <summary>
        /// To Update the form Column Configuration
        /// </summary>
        /// <param name="jsonData"></param>
        /// <param name="UserId"></param>
        /// <param name="FK_AccountID"></param>
        /// <param name="FK_CategoryID"></param>
        /// <param name="FK_CustomerID"></param>
        /// <returns></returns>
        public MessageMDL UpdateFormColumnConfig(string jsonData, Int64 UserId, Int64 FK_AccountID, Int64 FK_CategoryID, Int64 FK_CustomerID) {
            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                 new SqlParameter("@jsonFormColumnAddEdit", jsonData),
                 new SqlParameter("@iFK_AccountID", FK_AccountID),
                 new SqlParameter("@iFK_CategoryID", FK_CategoryID),
                 new SqlParameter("@iFK_CustomerID", FK_CustomerID),
                new SqlParameter("@iUserId", UserId)

            };

                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_MapFormColumnAddEdit]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    msg.Message = (msg.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.RecordUpdated : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
            }
            catch (Exception e)
            {
                msg.MessageId = 0;
                msg.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", "", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, objBase.Name, e.Message, "");

            }

            return msg;
        }
        #endregion
        public bool getFormColumnConfigList(out List<FormColumnAssignmentMDL> _FormColumnConfigList, string ControllerName, string ActionName, int CustomerId)
        {
            bool result = false;
            _FormColumnConfigList = new List<FormColumnAssignmentMDL>();

            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@ControllerName",ControllerName),
                    new SqlParameter("@ActionName",ActionName),
                    new SqlParameter("@iCustomerId",CustomerId)
                };
                _commandText = "USP_GetcolumnConfigList";

                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _FormColumnConfigList = objDataSet.Tables[1].AsEnumerable().Select(dr => new FormColumnAssignmentMDL()
                        {
                            ColumnName = dr.Field<string>("Column_Name"),
                            IsActive = dr.Field<bool>("IsActive")

                        }).ToList();

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
                result = false;
            }
            return result;
        }
    }
}
