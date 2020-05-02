
using GyanmitrasMDL;
using GyanmitrasDAL.DataUtility;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GyanmitrasDAL.Common;

namespace GyanmitrasDAL
{
    public class MSTFormLanguageMappingDAL
    {
        static DataFunctions objDataFunctions = null;
        System.Data.DataSet objDataSet = null;
        static string _commandText = String.Empty;
        public MSTFormLanguageMappingDAL()
        {
            objDataFunctions = new DataFunctions();
        }

        /// <summary>
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        public bool GetFormLanguageMappingDetails(out List<MstFormLanguageMappingMDL> _PackageDatalist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 AccountId, Int64 FK_CustomerId, Int64 UserId, string LoginType)
        {
            bool result = false;
            objBasicPagingMDL = new BasicPagingMDL();
            _PackageDatalist = new List<MstFormLanguageMappingMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iPK_FormLanguageId",id),
                     new SqlParameter("@iRowPerpage",RowPerpage),
                     new SqlParameter("@iCurrentPage",CurrentPage),
                     new SqlParameter("@cSearchBy",SearchBy),
                     new SqlParameter("@cSearchValue",SearchValue),


                       new SqlParameter("@iFK_AccountId",AccountId),
                new SqlParameter("@iFK_CustomerId",FK_CustomerId),
                new SqlParameter("@iUserId",UserId),
                new SqlParameter("@cLoginType",LoginType),

                };
                _commandText = "[dbo].[usp_GetFormLanguageMappingList]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _PackageDatalist = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstFormLanguageMappingMDL()
                        {
                            PK_FormLanguageId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_FormLanguageId")),
                            FK_FormId = dr.Field<Int64>("FK_FormId"),
                            FK_LanguageId = dr.Field<Int64>("FK_LanguageId"),
                            LanguageName = dr.Field<string>("LanguageName"),
                            FormName = dr.Field<string>("FormName"),
                            TranslatedFormName = dr.Field<string>("TranslatedFormName"),
                            IsActive = dr.Field<bool>("IsActive"),
                            IsDeleted = dr.Field<bool>("IsDeleted"),
                            CreatedDate = dr.Field<DateTime>("CreatedDateTime")

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
                            objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage + 1;

                        objDataSet.Dispose();
                        result = true;
                    }
                    else
                    {
                        result = false;
                    }

                }

                if (objDataSet.Tables[2].Rows.Count > 0)
                {
                    objTotalCountPagingMDL = new TotalCountPagingMDL()
                    {
                        TotalItem = objDataSet.Tables[2].Rows[0].Field<int>("TotalItem"),
                        TotalActive = objDataSet.Tables[2].Rows[0].Field<int>("TotalActive"),
                        TotalInactive = objDataSet.Tables[2].Rows[0].Field<int>("TotalInActive"),
                        ThisMonth = objDataSet.Tables[2].Rows[0].Field<int>("TotalCurrentMonth")
                    };
                }
            }
            catch (Exception e)
            {
                result = false;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, e.Message, "");
            }
            return result;
        }
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Add / Edit Form Language Mapping Details
        /// </summary>
        public MessageMDL AddEditFormLanguageMapping(MstFormLanguageMappingMDL obj)
        {
            MessageMDL objMessageMDL = new MessageMDL();
            _commandText = "[dbo].[USP_AddEditMapFormLanguage]";
            List<SqlParameter> parms = new List<SqlParameter>
               {
                new SqlParameter("@iPK_FormLanguageId",obj.PK_FormLanguageId),
                new SqlParameter("@iFK_FormId",obj.FK_FormId),
                new SqlParameter("@cTranslatedFormName",obj.TranslatedFormName),
                new SqlParameter("@iFK_LanguageId",obj.FK_LanguageId),
               new SqlParameter("@bIsActive",obj.IsActive),
               //new SqlParameter("@bIsDeleted",obj.IsDeleted),
               new SqlParameter("@iUserId",obj.CreatedBy),
               new SqlParameter("@iFK_AccountID",obj.FK_AccountID),
               new SqlParameter("@iFK_CustomerID",obj.FK_CustomerID),
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
                                       ? @GyanmitrasLanguages.LocalResources.Resource.RecordInserted
                                       : (objMessageMDL.MessageId == 2)
                                       ? @GyanmitrasLanguages.LocalResources.Resource.RecordUpdated
                                       : (objMessageMDL.MessageId == 3)
                                       ? @GyanmitrasLanguages.LocalResources.Resource.FormLngAlreadyExist

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
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Delete Form Language Mapping Details
        /// </summary>
        public MessageMDL DeleteFormLanguageMapping(Int64 id, Int64 CreatedBy, int FK_CompanyId)
        {
            MessageMDL objMessageMDL = new MessageMDL();
            _commandText = "[dbo].[USP_DeleteMapFormLanguage]";
            List<SqlParameter> parms = new List<SqlParameter>
               {
                new SqlParameter("@iPK_FormLanguageId",id),
               new SqlParameter("@iUserId",CreatedBy),
              // new SqlParameter("@iFK_CompanyID",FK_CompanyId),
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
