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
   public class FormAccountMappingDAL
    {
        #region
        DataFunctions objDataFunctions = null;
        DataSet objDataSet = null;
        string _commandText = string.Empty;
        #endregion

        public FormAccountMappingDAL()
        {
            objDataFunctions = new DataFunctions();
        }

        public bool GetFormAccountMappingDetails(out List<FormAccountMappingMDL> _MapFormAccountList, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, Int64 id, Int64 AccountId, Int64 UserId, Int64 FK_CustomerId, string LoginType, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue)
        {
            bool result = false;
            _MapFormAccountList = new List<FormAccountMappingMDL>();
            System.Data.DataSet objDataSet = null;
            objBasicPagingMDL = new BasicPagingMDL();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                    {
                        new SqlParameter("@iPK_FormAccountId",id),
                        new SqlParameter("@iFK_AccountID",AccountId),
                        new SqlParameter("@iUserId",UserId),
                        new SqlParameter("@iRowperPage",RowPerpage),
                        new SqlParameter("@iCurrentPage",CurrentPage),
                        new SqlParameter("@cSearchBy",SearchBy),
                        new SqlParameter("@cSearchValue",SearchValue),
                        new SqlParameter("@iFK_CustomerId",FK_CustomerId),
                        new SqlParameter("@cLoginType ",LoginType)

                    };
                _commandText = "[dbo].[usp_GetMapFormAccountDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet != null && objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _MapFormAccountList = objDataSet.Tables[1].AsEnumerable().Select(dr => new FormAccountMappingMDL()
                        {
                            PK_Map_FormAccountId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_FormAccountId")),
                            FK_AccountId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_AccountId")),
                            AccountName = dr.Field<string>("AccountName"),
                            FK_FormId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_FormId")),
                            FormName = dr.Field<string>("FormName"),
                            FK_CategoryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CategoryId")),
                            AccountCategory = dr.Field<string>("CategoryName"),
                            IsActive = dr.Field<bool>("IsActive"),
                            Status = dr.Field<string>("Status"),
                            CreatedDatetime = dr.Field<string>("CreatedDateTime"),
                            IsCustomerAccount = dr.Field<bool>("IsCustomerAccount")
                        }).ToList();

                        if (objDataSet.Tables.Count > 1)
                        {
                            objBasicPagingMDL = new BasicPagingMDL()
                            {
                                TotalItem = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalItem")),
                                RowParPage = RowPerpage,
                                CurrentPage = CurrentPage
                            };
                            if (objBasicPagingMDL.TotalItem % objBasicPagingMDL.RowParPage == 0)
                            {
                                objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage;
                            }
                            else
                            {
                                objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage + 1;
                            }

                            objTotalCountPagingMDL = new TotalCountPagingMDL()
                            {
                                TotalItem = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalItem")),
                                TotalActive = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalActive")),
                                TotalInactive = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalInactive")),
                                ThisMonth = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalCurrentMonth")),
                            };
                        }
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

        public MessageMDL AddEditFormAccountMapping(FormAccountMappingMDL ObjFormAccountMappingMDL)
        {
            MessageMDL objMessageMDL = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {

                new SqlParameter("@iPK_FormAccountId", ObjFormAccountMappingMDL.PK_Map_FormAccountId),
                new SqlParameter("@iFK_FormId", ObjFormAccountMappingMDL.FK_FormId),
                new SqlParameter("@iFK_AccountId", ObjFormAccountMappingMDL.FK_AccountId),
                new SqlParameter("@iFK_CategoryId", ObjFormAccountMappingMDL.FK_CategoryId),
                new SqlParameter("@bIsActive", ObjFormAccountMappingMDL.IsActive),
                new SqlParameter("@bIsCustomerAccount", ObjFormAccountMappingMDL.IsCustomerAccount),
                new SqlParameter("@iUserId", ObjFormAccountMappingMDL.UserId),
                new SqlParameter("@iFK_CustomerId", ObjFormAccountMappingMDL.CustomerId),
                new SqlParameter("@cLoginType", ObjFormAccountMappingMDL.LoginType)



            };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_SaveFormAccountMapping]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                   objMessageMDL.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                   objMessageMDL.Message = (objMessageMDL.MessageId == 1 ? objMessageMDL.Message = GyanmitrasLanguages.LocalResources.Resource.FormAccountMappingAdded : objMessageMDL.MessageId == 2 ?
                   GyanmitrasLanguages.LocalResources.Resource.FormAccountMappingUpdated : GyanmitrasLanguages.LocalResources.Resource.FormAccountMappingExists);
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }

            return objMessageMDL;
        }

        public MessageMDL DeleteFormAccountMapping(Int64 Id, Int64 UserId)
        {
            MessageMDL objMessageMDL = new MessageMDL();
            _commandText = "[dbo].[usp_DeleteFormAccountMapping]";
            List<SqlParameter> parms = new List<SqlParameter>
            {
                new SqlParameter("@iPK_FormAccountId", Id),
                new SqlParameter("@iUserId", UserId)
            };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessageMDL.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessageMDL.Message = GyanmitrasLanguages.LocalResources.Resource.Deleted;
                }
                else
                {
                    objMessageMDL.MessageId = 0;
                    objMessageMDL.Message =GyanmitrasLanguages.LocalResources.Resource.ProcessFailed; ;
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return objMessageMDL;
        }
    }
}
