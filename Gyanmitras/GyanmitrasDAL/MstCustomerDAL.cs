
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
using Utility;

namespace GyanmitrasDAL
{
    public class MstCustomerDAL
    {

        #region
        DataFunctions objDataFunctions = null;
        DataTable objDataTable = null;
        DataSet objDataSet = null;
        string _commandText = string.Empty;

        #endregion

        public MstCustomerDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Add Edit Customer Details
        /// </summary>
        public MessageMDL AddEditCustomer(out string PK_CustomerId, out string countryTimeZone,out List<MstCustomerMDL> _CustomerDatalist, MstCustomerMDL ObjMstCustomerMDL, string jsonbulkupload = "")
        {
            PK_CustomerId = ObjMstCustomerMDL.PK_CustomerId.ToString();
            _CustomerDatalist = new List<MstCustomerMDL>();
            countryTimeZone = "";
            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@iPK_CustomerId", ObjMstCustomerMDL.PK_CustomerId),
                new SqlParameter("@cCustomerName", ObjMstCustomerMDL.CustomerName),
                new SqlParameter("@iFK_CategoryId", ObjMstCustomerMDL.FK_CategoryId),
                new SqlParameter("@iFK_AccountId", ObjMstCustomerMDL.FK_AccountId),
                new SqlParameter("@iFK_ParentCustomerId", ObjMstCustomerMDL.FK_ParentCustomerId),
                new SqlParameter("@cParentCustomerName", ObjMstCustomerMDL.ParentCustomerName),
                new SqlParameter("@cCustomerTypeName", ObjMstCustomerMDL.FK_CustomerTypeId),
                new SqlParameter("@cUserName", ObjMstCustomerMDL.UserName),
                new SqlParameter("@cPassword",  ClsCrypto.Encrypt(ObjMstCustomerMDL.Password)),
                new SqlParameter("@cShareVia", ObjMstCustomerMDL.ShareVia),
                new SqlParameter("@cAddress", ObjMstCustomerMDL.Address),
                new SqlParameter("@cZipCode", ObjMstCustomerMDL.ZipCode),
                new SqlParameter("@iFK_CountryId", ObjMstCustomerMDL.FK_CountryId),
                new SqlParameter("@iFK_StateId", ObjMstCustomerMDL.FK_StateId),
                new SqlParameter("@iFK_CityId", ObjMstCustomerMDL.FK_CityId),
                new SqlParameter("@cBillingAddress", ObjMstCustomerMDL.BillingAddress),
                new SqlParameter("@cContactPerson", ObjMstCustomerMDL.ContactPerson),
                new SqlParameter("@cMobileNo", ObjMstCustomerMDL.MobileNo),
                new SqlParameter("@cAlternateMobileNo", ObjMstCustomerMDL.AlternateMobileNo),
                new SqlParameter("@cEmailId", ObjMstCustomerMDL.EmailId),
                new SqlParameter("@cAlternateEmailId", ObjMstCustomerMDL.AlternateEmailId),
                new SqlParameter("@cAccountLogo", ObjMstCustomerMDL.AccountLogo),
                new SqlParameter("@cAccountRegistrationNo", ObjMstCustomerMDL.AccountRegistrationNo),
                new SqlParameter("@bIsActive", ObjMstCustomerMDL.IsActive),
                new SqlParameter("@cZipCode_Billing", ObjMstCustomerMDL.ZipCode_Billing),
                new SqlParameter("@iFK_CountryId_Billing", ObjMstCustomerMDL.FK_CountryId_Billing),
                new SqlParameter("@iFK_StateId_Billing", ObjMstCustomerMDL.FK_StateId_Billing),
                new SqlParameter("@iFK_CityId_Billing", ObjMstCustomerMDL.FK_CityId_Billing),
                new SqlParameter("@iFK_CompanyId", ObjMstCustomerMDL.FK_CompanyId),
                new SqlParameter("@iUserId", ObjMstCustomerMDL.CreatedBy),
                new SqlParameter("@jsonbulkupload", jsonbulkupload),
                new SqlParameter("@cUnEncryptedPassword",ObjMstCustomerMDL.UnEncryptedPassword)

            };

                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "USP_AddEditCustomer ";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (ObjMstCustomerMDL.PK_CustomerId <= 0)
                {
                    if (objDataSet.Tables.Count > 1)
                    {
                        PK_CustomerId = Convert.ToString(objDataSet.Tables[1].Rows[0]["PK_CustomerId"]);
                    }

                    if (objDataSet.Tables.Count > 1)
                    {
                        countryTimeZone = Convert.ToString(objDataSet.Tables[2].Rows[0]["CountryTimeZone"]);
                    }
                }

                if (objDataSet.Tables[1].Columns.Count == 3)
                {
                    _CustomerDatalist = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstCustomerMDL()
                    {
                        PK_CustomerId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_CustomerId")),
                        CustomerName = dr.Field<string>("CustomerName"),
                        TimeZoneHours = Convert.ToInt32((dr.Field<string>("TimeZone")).Split(':')[0]),
                        TimeZoneMinutes = Convert.ToInt32((dr.Field<string>("TimeZone")).Split(':')[1]),

                    }).ToList();

                }
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    msg.Message = (msg.MessageId == 1)
                                        ? @GyanmitrasLanguages.LocalResources.Resource.RecordInserted
                                        : (msg.MessageId == 2)
                                        ? @GyanmitrasLanguages.LocalResources.Resource.RecordUpdated
                                        : (msg.MessageId == 3)
                                        ? @GyanmitrasLanguages.LocalResources.Resource.EmailExists
                                        : (msg.MessageId == 4)
                                        ? @GyanmitrasLanguages.LocalResources.Resource.MobileNoExist
                                        : (msg.MessageId == 5)
                                        ? @GyanmitrasLanguages.LocalResources.Resource.CustomerAlreadyExists
                                        : (msg.MessageId == 6)
                                        ? @GyanmitrasLanguages.LocalResources.Resource.UserAlreadyExist

                                        : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
                else
                {
                    msg.MessageId = 0;
                    msg.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
            }
            catch (Exception e)
            {
                msg.MessageId = 0;
                msg.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, e.Message, "");
            }

            return msg;
        }


        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        public bool GetCustomer(out List<MstCustomerMDL> _PackageDatalist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 AccountId, Int64 FK_CustomerId, Int64 UserId, string LoginType)
        {
            bool result = false;
            objBasicPagingMDL = new BasicPagingMDL();
            _PackageDatalist = new List<MstCustomerMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                      new SqlParameter("@iPK_CustomerId", id),
                new SqlParameter("@iRowperPage", RowPerpage),
                new SqlParameter("@iCurrentPage", CurrentPage),
                new SqlParameter("@cSearchBy", SearchBy),
                new SqlParameter("@cSearchValue", SearchValue),
                new SqlParameter("@iPK_UserId", userid),

                new SqlParameter("@iFK_AccountId",AccountId),
                new SqlParameter("@iFK_CustomerId",FK_CustomerId),
                new SqlParameter("@iUserId",userid),
                new SqlParameter("@cLoginType",LoginType),

                };
                _commandText = "USP_GetCustomerDetails";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {

                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _PackageDatalist = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstCustomerMDL()
                        {
                            PK_CustomerId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_CustomerId")),
                            CustomerTypeName = dr.Field<string>("CustomerTypeName"),
                            FK_CustomerTypeId = dr.Field<Int64>("PK_CustomerTypeId"),
                            CustomerName = dr.Field<string>("CustomerName"),
                            ReferredByName = dr.Field<string>("CategoryName"),
                            ReferredByAccountName = dr.Field<string>("AccountName"),
                            ParentCustomerName = dr.Field<string>("ParentCustomerName"),
                            FK_ParentCustomerId = dr.Field<Int64>("FK_ParentCustomerId"),
                            EmailId = dr.Field<string>("EmailId"),
                            MobileNo = dr.Field<string>("MobileNo"),
                            IsActive = dr.Field<bool>("IsActive"),
                            FK_AccountId = dr.Field<Int64>("FK_AccountId"),
                            CountryName = dr.Field<string>("CountryName"),
                            StateName = dr.Field<string>("StateName"),
                            CityName = dr.Field<string>("CityName"),
                            AccountLogo = dr.Field<string>("AccountLogo"),
                            FK_CategoryId = dr.Field<Int64>("FK_CategoryId"),
                            ShareVia = dr.Field<string>("ShareVia"),

                            Address = dr.Field<string>("Address")
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
                            UserName = dr.Field<string>("UserName"),
                            Password = ClsCrypto.Decrypt(dr.Field<string>("UserPassword")),


                            CountryName_Billing = dr.Field<string>("CountryId_Billing_Name"),
                            StateName_Billing = dr.Field<string>("State_Billing_Name"),
                            CityName_Billing = dr.Field<string>("City_Billing_Name"),
                            IsSync = dr.Field<bool>("IsSync"),




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
        /// purpose: Delete Customer Details
        /// </summary>
        public MessageMDL DeleteCustomer(Int64 PK_CustomerId, Int64 UserId)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@iPK_CustomerId", PK_CustomerId),
                new SqlParameter("@iUserId", UserId),
                };
                _commandText = "[dbo].[USP_DeleteCustomer]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    msg.Message = (msg.MessageId == 1)
                                       ? @GyanmitrasLanguages.LocalResources.Resource.Deleted
                                       : (msg.MessageId == -1)
                                         ? @GyanmitrasLanguages.LocalResources.Resource.CustomerData + " " + @GyanmitrasLanguages.LocalResources.Resource.CanNotDelete
                                       : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
                else
                {
                    msg.MessageId = 0;
                    msg.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
            }
            catch (Exception e)
            {
                msg.MessageId = 0;
                msg.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, e.Message, "");
            }

            return msg;
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:13-01-2020
        /// purpose: Sync Customer Details
        /// </summary>
        public MessageMDL SyncMachineAlert(string jsonids)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[DBO].[USP_UpdateSyncCustomer]";
            List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@jsonSyncCustomerId", jsonids)
                };

            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = @GyanmitrasLanguages.LocalResources.Resource.SyncSuccess;
                }
                else
                {
                    objMessages.MessageId = 0;
                    objMessages.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
            }
            catch (Exception ex)
            {
                objMessages.MessageId = 0;
                objMessages.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
            }
            return objMessages;
        }
    }
}
