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
    public class FormColumnAssignmentDAL
    {
        static DataFunctions objDataFunctions = null;
        DataSet objDataSet = null;
        static string _commandText = string.Empty;
        //SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        public FormColumnAssignmentDAL()
        {
            objDataFunctions = new DataFunctions();
        }

        public MessageMDL AddFormColumnAssignment(FormColumnAssignmentMDL objFormColumnMDL)
        {

            MessageMDL objMessageMDL = new MessageMDL();
            _commandText = "[dbo].[USP_AddEditFormColumn]";
            List<SqlParameter> parms = new List<SqlParameter>

            {
                new SqlParameter("@iPK_FormColumnId",objFormColumnMDL.PK_FormColumnId),
                new SqlParameter("@iFK_FormId",objFormColumnMDL.Fk_FormId),
                new SqlParameter("@cFormName",objFormColumnMDL.FormName),
                new SqlParameter("@cColumnName",objFormColumnMDL.ColumnName),
                new SqlParameter("@iUserId",SqlDbType.Int){Value=objFormColumnMDL.UserId },
                new SqlParameter("@iFK_AccountId",objFormColumnMDL.AccountId),

            };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessageMDL.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessageMDL.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    objMessageMDL.Message = (objMessageMDL.MessageId == 1) ?
                        @GyanmitrasLanguages.LocalResources.Resource.RecordInserted : (objMessageMDL.Message== "Same Form Column Already Exists.") ?
                        @GyanmitrasLanguages.LocalResources.Resource.FormColumn : (objMessageMDL.MessageId == 2) ?
                        @GyanmitrasLanguages.LocalResources.Resource.RecordUpdated : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
                else
                {
                    objMessageMDL.MessageId = 0;
                    objMessageMDL.Message = "Failed";
                }
            }
            catch (Exception ex)
            {
                objMessageMDL.MessageId = 0;
                objMessageMDL.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return objMessageMDL;

        }


        /// <summary>
        /// Purpose: To Get column data by Id
        /// </summary>
        /// <returns></returns>
        public bool GetFormColumAssignment(out List<FormColumnAssignmentMDL> _FormColumnListList, out BasicPagingMDL objBasicPagingMDL, int id, Int64 FK_AccountId,Int64 UserId, string searchBy, string searchValue, int RowPerpage, int CurrentPage,Int64 FK_CustomerId, string LoginType)
        {
            bool result = false;
            _FormColumnListList = new List<FormColumnAssignmentMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            //  System.Data.DataSet objDataSet = null;

            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iPK_FormColumnId",id),
                    new SqlParameter("@cSearchBy",searchBy),
                    new SqlParameter("@cSearchValue",searchValue),
                    new SqlParameter("@iRowperPage",RowPerpage),
                    new SqlParameter("@iCurrentPage",CurrentPage),
                    new SqlParameter("@iFK_AccountId",FK_AccountId),
                    new SqlParameter("@iUserId",UserId),
                    //new SqlParameter("@iFK_AccountId",FK_AccountId),
                    new SqlParameter("@iFK_CustomerId ",FK_CustomerId),
                    //new SqlParameter("@iFK_UserId",FK_UserId),
                    new SqlParameter("@cLoginType",LoginType)
                };
                _commandText = "[dbo].[USP_GetFormColumnDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _FormColumnListList = objDataSet.Tables[1].AsEnumerable().Select(dr => new FormColumnAssignmentMDL()
                        {
                            PK_FormColumnId = dr.Field<Int64>("PK_FormColumnId"),
                            Fk_FormId = dr.Field<Int64>("FK_FormId"),
                            FormName = dr.Field<string>("FormName"),
                            ColumnName = dr.Field<string>("Column_Name"),
                            AccountName = dr.Field<string>("AccountName"),
                            AccountId = dr.Field<Int64>("FK_AccountId"),

                        }).ToList();

                        objBasicPagingMDL = new BasicPagingMDL()
                        {
                            TotalItem = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalItem")),
                            RowParPage = RowPerpage,
                            CurrentPage = CurrentPage
                        };
                        objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage;
                        if (objBasicPagingMDL.TotalItem % objBasicPagingMDL.RowParPage == 0)
                        {
                            objBasicPagingMDL.TotalPage++;
                        }

                        if (objBasicPagingMDL.TotalItem % objBasicPagingMDL.RowParPage == 0)
                        {
                            objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage;
                        }
                        else
                            objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage + 1;

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
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");

                result = false;
            }
            return result;
        }

        /// <summary>
        /// Purpose: To Delete Form Column by Id
        /// </summary>
        /// <returns></returns>
        public MessageMDL DeleteFormColumnAssignment(int id, int UserId)
        {
            MessageMDL objMessageMDL = new MessageMDL();
            _commandText = "[dbo].[USP_DeleteFormColumn]";
            List<SqlParameter> parms = new List<SqlParameter>
            {
             new SqlParameter("@iPK_FormColumnId",id),
              new SqlParameter("@iUserId",UserId),
            };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessageMDL.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessageMDL.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    objMessageMDL.Message = (objMessageMDL.MessageId == 1)
                                       ? @GyanmitrasLanguages.LocalResources.Resource.Deleted

                                       : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
                else
                {
                    objMessageMDL.MessageId = 0;
                    objMessageMDL.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
            }
            catch (Exception ex)
            {
                objMessageMDL.MessageId = 0;
                objMessageMDL.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return objMessageMDL;

        }


    }
 
}
