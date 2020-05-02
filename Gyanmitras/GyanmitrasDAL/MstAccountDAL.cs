
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

namespace GyanmitrasDAL
{
    public class MSTAccountDAL
    {
        static DataFunctions objDataFunctions = null;
        System.Data.DataSet objDataSet = null;
        static string _commandText = String.Empty;
        public MSTAccountDAL()
        {
            objDataFunctions = new DataFunctions();
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        public bool GetAccountDetails(out List<MSTAccountMDL> _PackageDatalist, out BasicPagingMDL objBasicPagingMDL,out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 AccountId, Int64 FK_CustomerId, Int64 UserId, string LoginType)
        {
            bool result = false;
            objBasicPagingMDL = new BasicPagingMDL();
            _PackageDatalist = new List<MSTAccountMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iPK_AccountId",id),
                     new SqlParameter("@iPK_UserId",userid),
                     new SqlParameter("@iRowPerpage",RowPerpage),
                     new SqlParameter("@iCurrentPage",CurrentPage),
                     new SqlParameter("@cSearchBy",SearchBy),
                     new SqlParameter("@cSearchValue",SearchValue),

                     new SqlParameter("@iFK_AccountId",AccountId),
                     new SqlParameter("@iFK_CustomerId",FK_CustomerId),
                     new SqlParameter("@iUserId",userid),
                     new SqlParameter("@cLoginType",LoginType),

                };
                _commandText = "[dbo].[USP_GetAccountDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {

                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _PackageDatalist = objDataSet.Tables[1].AsEnumerable().Select(dr => new MSTAccountMDL()
                        {
                            PK_AccountId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_AccountId")),
                            AccountCategoryName = dr.Field<string>("CategoryName"),
                            AccountName = dr.Field<string>("AccountName"),
                            AccountParentName = dr.Field<string>("ParentAccountName"),
                            EmailId = dr.Field<string>("EmailId"),
                            MobileNo = dr.Field<string>("MobileNo"),
                            IsActive = dr.Field<bool>("IsActive"),
                            //IsDeleted = dr.Field<bool>("IsDeleted"),

                            CountryName = dr.Field<string>("CountryName"),
                            StateName = dr.Field<string>("StateName"),
                            CityName = dr.Field<string>("CityName"),
                            AccountLogoStream = dr.Field<string>("AccountLogo")

                            ,
                            FK_CategoryId = dr.Field<Int64>("FK_CategoryId")
                            //,
                            //fk_companyid = dr.field<int64>("fk_companyid")
                            //,
                            //FK_ResellerId = dr.Field<Int64>("FK_ResellerId")
                            //,
                            //FK_AffiliateId = dr.Field<Int64>("FK_AffiliateId")
                            ,
                            ParentAccountId = dr.Field<Int64>("ParentAccountId")
                            ,
                            AccountAddress = dr.Field<string>("AccountAddress")
                            ,
                            ZipCode = dr.Field<string>("ZipCode")
                            ,
                            FK_CountryId = dr.Field<Int64>("FK_CountryId")
                            ,
                            FK_StateId = dr.Field<Int64>("FK_StateId")
                            ,
                            FK_CityId = dr.Field<Int64>("FK_CityId")
                            ,
                            BillingAddress = dr.Field<string>("BillingAddress")
                            ,
                            ContactPerson = dr.Field<string>("ContactPerson")
                            ,
                            AlternateMobileNo = dr.Field<string>("AlternateMobileNo")
                            ,
                            AlternateEmailId = dr.Field<string>("AlternateEmailId")

                            ,
                            AccountRegistrationNo = dr.Field<string>("AccountRegistrationNo")

                            ,
                            ZipCode_Billing = dr.Field<string>("ZipCode_Billing")
                            ,
                            FK_CountryId_Billing = dr.Field<Int64>("FK_CountryId_Billing")
                            ,
                            FK_StateId_Billing = dr.Field<Int64>("FK_StateId_Billing")
                            ,
                            FK_CityId_Billing = dr.Field<Int64>("FK_CityId_Billing")
                            ,
                            UserLimit = dr.Field<int>("UserLimit")
                            ,
                            Username = dr.Field<string>("UserName"),
                            FK_RoleId = dr.Field<Int64>("FK_RoleId"),
                            Parent_FK_CategoryId = dr.Field<Int64>("Parent_FK_CategoryId"),
                           
                            Password = ClsCrypto.Decrypt(dr.Field<string>("Password")),
                            CountryId_Billing_Name = dr.Field<string>("CountryId_Billing_Name"),
                            StateId_Billing_Name = dr.Field<string>("State_Billing_Name"),
                            CityId_Billing_Name =  dr.Field<string>("City_Billing_Name"),

                            AccountName_Referrer = dr.Field<string>("AccountName_Referrer"),
                            FK_AccountId_Referrer = dr.Field<Int64>("FK_AccountId_Referrer"),
                            CategoryName_Referrer = dr.Field<string>("CategoryName_Referrer"),
                            FK_CategoryId_Referrer = dr.Field<Int64>("FK_CategoryId_Referrer"),
                            ShareVia = dr.Field<string>("ShareVia"),



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
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, e.Message, "");

                result = false;
            }
            return result;
        }
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Add Edit Account Details
        /// </summary>
        public MessageMDL AddEditAccount(MSTAccountMDL obj, out Int64 NewCreatedUserId)
        {
            MessageMDL objMessageMDL = new MessageMDL();
            NewCreatedUserId = 0;
            _commandText = "[dbo].[USP_AddEditAccount]";
            List<SqlParameter> parms = new List<SqlParameter>
               {
                new SqlParameter("@iPK_AccountId",obj.PK_AccountId),
                new SqlParameter("@cAccountName",obj.AccountName),
                new SqlParameter("@iFK_CategoryId",obj.FK_CategoryId),
                //new SqlParameter("@iFK_CompanyId",obj.FK_CompanyId),
                //new SqlParameter("@iFK_ResellerId",obj.FK_ResellerId),
                //new SqlParameter("@iFK_AffiliateId",obj.FK_AffiliateId),
                new SqlParameter("@iParentCategoryID",obj.Parent_FK_CategoryId),
                new SqlParameter("@iParentAccountId",obj.ParentAccountId),
                new SqlParameter("@cAccountAddress",obj.AccountAddress),
                new SqlParameter("@cZipCode",obj.ZipCode),
                new SqlParameter("@iFK_CountryId",obj.FK_CountryId),
                new SqlParameter("@iFK_StateId",obj.FK_StateId),
                new SqlParameter("@iFK_CityId",obj.FK_CityId),
                new SqlParameter("@cBillingAddress",obj.BillingAddress),
                new SqlParameter("@cContactPerson",obj.ContactPerson),
                new SqlParameter("@cMobileNo",obj.MobileNo),
                new SqlParameter("@cAlternateMobileNo",obj.AlternateMobileNo),
                new SqlParameter("@cEmailId",obj.EmailId),
                new SqlParameter("@cAlternateEmailId",obj.AlternateMobileNo),
                new SqlParameter("@cAccountRegistrationNo",obj.AccountRegistrationNo),
                new SqlParameter("@cAccountLogo",obj.AccountLogoStream),
                new SqlParameter("@bIsActive",obj.IsActive),
                new SqlParameter("@CreatedBy",obj.CreatedBy),
                new SqlParameter("@Username",obj.Username),
                new SqlParameter("@Password",ClsCrypto.Encrypt(obj.Password)),
                new SqlParameter("@FK_RoleId",obj.FK_RoleId),
                new SqlParameter("@ZipCode_Billing",obj.ZipCode_Billing),
                new SqlParameter("@FK_CountryId_Billing",obj.FK_CountryId_Billing),
                new SqlParameter("@FK_StateId_Billing",obj.FK_StateId_Billing),
                new SqlParameter("@FK_CityId_Billing",obj.FK_CityId_Billing),
                new SqlParameter("@UserLimit",obj.UserLimit),
                new SqlParameter("@FK_AccountId_Referrer",obj.FK_AccountId_Referrer),
                new SqlParameter("@FK_CategoryId_Referrer",obj.FK_CategoryId_Referrer),
                new SqlParameter("@ShareVia",obj.ShareVia),
                new SqlParameter("@cUnEncryptedPassword",obj.UnEncryptedPassword)

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
                                          ? @GyanmitrasLanguages.LocalResources.Resource.EmailExists
                                          : (objMessageMDL.MessageId == 4)
                                          ? @GyanmitrasLanguages.LocalResources.Resource.MobileNoExist
                                          : (objMessageMDL.MessageId == 5)
                                          ? @GyanmitrasLanguages.LocalResources.Resource.AccountAlreadyExist
                                          : (objMessageMDL.MessageId == 6)
                                          ? @GyanmitrasLanguages.LocalResources.Resource.UserAlreadyExist

                                          : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;

                    if (objDataSet.Tables.Count > 1 && objDataSet.Tables[1].Rows.Count > 0)
                    {
                        NewCreatedUserId = objDataSet.Tables[1].Rows[0].Field<Int64>("NewlyAddedUserId");
                    }

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
        /// purpose: Delete Account Details
        /// </summary>
        public MessageMDL DeleteAccount(Int64 id, Int64 CreatedBy, int FK_CompanyId)
        {
            MessageMDL objMessageMDL = new MessageMDL();
            _commandText = "[dbo].[USP_DeleteAccount]";
            List<SqlParameter> parms = new List<SqlParameter>
               {
                new SqlParameter("@iPK_AccountId",id),
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
                                        : (objMessageMDL.MessageId == -1)
                                         ? @GyanmitrasLanguages.LocalResources.Resource.AccountData + " " + @GyanmitrasLanguages.LocalResources.Resource.CanNotDelete
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
