using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using GyanmitrasMDL;
using GyanmitrasDAL.DataUtility;
using GyanmitrasDAL.Common;

namespace GyanmitrasDAL
{
    public class AccountCategoryDAL
    {

        static DataFunctions objDataFunctions = null;
        DataSet objDataSet = null;
        static string _commandText = string.Empty;
        MessageMDL objMessages = new MessageMDL();
        //SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

        public AccountCategoryDAL()
        {
            objDataFunctions = new DataFunctions();
        }

        /// <summary>Created By
        /// Created By: Vinish  
        /// Created Date: 13-12-2019  
        /// Purpose: Add a Account Category
        /// </summary>
        /// <param name="AccountTypeMDL"></param>
        /// <returns></returns> 
        public MessageMDL AddEditAccountType(AccountCategoryMDL objNewProjectMDL)
        {

            MessageMDL objMessageMDL = new MessageMDL();
            _commandText = "[dbo].[USP_AddEditCategory]";
            List<SqlParameter> parms = new List<SqlParameter>

            {
                new SqlParameter("@iPK_CategoryId",objNewProjectMDL.PK_CategoryId),
                new SqlParameter("@cCategoryName",objNewProjectMDL.AccountCategory),
                new SqlParameter("@bIsActive",objNewProjectMDL.Isactive),
                new SqlParameter("@iUserId",SqlDbType.Int){Value=objNewProjectMDL.UserId },
              

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
                        @GyanmitrasLanguages.LocalResources.Resource.RecordInserted : (objMessageMDL.Message == "Account Category Name Already Exists.") ?
                        @GyanmitrasLanguages.LocalResources.Resource.AccountCategoryExists : (objMessageMDL.MessageId == 2) ?
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
        /// Purpose:-Get Account Category  by Id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool GetAccountType(out List<AccountCategoryMDL> _AccountTypelist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, string searchBy, string searchValue , int RowPerpage , int CurrentPage,Int64 FK_AccountId, Int64 FK_CustomerId,Int64 FK_UserId,string LoginType)
        {
            bool result = false;
            _AccountTypelist = new List<AccountCategoryMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            objTotalCountPagingMDL = new TotalCountPagingMDL();

            //  System.Data.DataSet objDataSet = null;

            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iPK_CategoryId",id),
                    new SqlParameter("@cSearchBy",searchBy),
                    new SqlParameter("@cSearchValue",searchValue),
                    new SqlParameter("@iRowperPage",RowPerpage),
                    new SqlParameter("@iCurrentPage",CurrentPage),
                    new SqlParameter("@iFK_AccountId",FK_AccountId),
                    new SqlParameter("@iFK_CustomerId ",FK_CustomerId),
                    new SqlParameter("@iFK_UserId",FK_UserId),
                    new SqlParameter("@cLoginType",LoginType)
                };
                _commandText = "[dbo].[USP_GetCategoryDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _AccountTypelist = objDataSet.Tables[1].AsEnumerable().Select(dr => new AccountCategoryMDL()
                        {
                            AccountCategory = dr.Field<string>("CategoryName"),
                            PK_CategoryId = dr.Field<Int64>("PK_CategoryId"),
                            Isactive = dr.Field<bool>("IsActive"),

                            CreatedDate = dr.Field<string>("CreatedDateTime"),
                             Status=dr.Field<string>("Status")

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
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
                result = false;
            }
            return result;
        }


        /// <summary>
        /// Delete Account Category
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public MessageMDL DeleteAccountCategory(int id, int UserId)
         {
            MessageMDL objMessageMDL = new MessageMDL();
            _commandText = "[dbo].[USP_DeleteCategory]";
            List<SqlParameter> parms = new List<SqlParameter>
            {
             new SqlParameter("@iPK_CategoryId",id),
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

                                       : "Category Id Already Mapped With Account";
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
