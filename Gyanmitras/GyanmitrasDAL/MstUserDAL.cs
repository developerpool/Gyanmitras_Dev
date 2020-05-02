
using Utility;
using GyanmitrasDAL.Common;
using GyanmitrasDAL.DataUtility;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasDAL
{
    public class MstUserDAL
    {
        #region
        static DataFunctions objDataFunctions = null;
        DataSet objDataSet = null;
        static string _commandText = string.Empty;
        #endregion

        #region constructor
        public MstUserDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        #endregion constructor

        #region Methods

        /// <summary>
        /// Get list of User
        /// </summary>
        /// <createBy>NitinGupta</createBy>
        /// <param name="_UserDatalist"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="objTotalCountPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="accountid"></param>
        /// <param name="loginid"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        public bool GetUserDetails(out List<MstUserMDL> _UserDatalist, out BasicPagingMDL objBasicPagingMDL,out TotalCountPagingMDL objTotalCountPagingMDL, int id,Int64 accountid,Int64 loginid,Int64 customerid,string logintype, int RowPerpage, int CurrentPage, string SearchBy = "", string SearchValue = "")
        {
            bool result = false;
            objBasicPagingMDL = new BasicPagingMDL();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            _UserDatalist = new List<MstUserMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iPK_UserId",id),
                    new SqlParameter("@iFK_AccountId",accountid),
                    new SqlParameter("@iUserId",loginid),
                    new SqlParameter("@iFK_CustomerId",customerid),
                    new SqlParameter("@cLoginType",logintype),
                    new SqlParameter("@iRowperPage",RowPerpage),
                    new SqlParameter("@iCurrentPage",CurrentPage),
                    new SqlParameter("@cSearchBy",SearchBy),
                    new SqlParameter("@cSearchValue",SearchValue)

                };
                _commandText = "[dbo].[USP_GetUserDetails]";

                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _UserDatalist = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstUserMDL()
                        {
                            Pk_UserId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_UserId")),
                            Name = dr.Field<string>("FullName"),
                            //LastName = dr.Field<string>("LastName"),
                            Categoryname = dr.Field<string>("CategoryName"),
                            AccountName = dr.Field<string>("AccountName"),
                            FK_AccountId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_AccountId")),
                            FK_CategoryIdForCust = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CategoryIdForCust")),
                            FK_CustomerId = WrapDbNull.WrapDbNullValue<int>(dr.Field<int?>("FK_CustomerId")),
                            FK_CategoryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CategoryId")),
                            CityId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CityId")),
                            CountryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CountryId")),
                            StateId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_StateId")),
                            UserName =dr.Field<string>("UserName"),
                            Rolename = dr.Field<string>("RoleName"),
                            UserPassword = ClsCrypto.Decrypt(dr.Field<string>("UserPassword")),
                           // DateOfBirth = WrapDbNull.WrapDbNullValue<DateTime>(dr.Field<DateTime?>("DateOfBirth")).ToString("dd/MM/yyyy"),
                            DateOfBirth = WrapDbNull.WrapDbNullValue<string>(dr.Field<string>("DateOfBirth")),
                            Gender = dr.Field<string>("Gender"),
                            EmailId = dr.Field<string>("EmailId"),
                            MobileNo = dr.Field<string>("MobileNo"),
                            UserAddress = dr.Field<string>("UserAddress"),
                            AlternateMobileNo = WrapDbNull.WrapDbNullValue<string>(dr.Field<string>("AlternateMobileNo")),
                            AlternateEmailId = WrapDbNull.WrapDbNullValue<string>(dr.Field<string>("AlternateEmailId")),
                            ZipCode = WrapDbNull.WrapDbNullValue<string>(dr.Field<string>("ZipCode")),
                            CountryName = WrapDbNull.WrapDbNullValue<string>(dr.Field<string>("CountryName")),
                            Share = WrapDbNull.WrapDbNullValue<string>(dr.Field<string>("ShareBy")),
                            statename = dr.Field<string>("StateName"),
                            CustomerName = WrapDbNull.WrapDbNullValue<string>(dr.Field<string>("CustomerName")),
                            Cityname = dr.Field<string>("CityName"),
                            IsActive = dr.Field<bool>("IsActive"),
                            FK_RoleId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_RoleId")),
                            FK_RoleIdforcust= WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_RoleId")),
                            VehicleSpecific = dr.Field<bool>("IsVehicleSpecific"),
                            CreatedDateTime = WrapDbNull.WrapDbNullValue<string>(dr.Field<string>("CreatedDateTime")),
                            
                        }).ToList();

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
                            ThisMonth = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalCurrentMonth"))
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
                result = false;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", "MstUserDAL", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, ex.Message, ex.Source, "EXCEPTION IN: GetUserDetails METHOD");
            }
            return result;
        }
        /// <summary>
        /// Insert and update User Master 
        /// </summary>
        /// <createBy>NitinGupta</createBy>
        /// <param name="userMstMDL"></param>
        /// <returns></returns>      
        public MessageMDL AddEditUser(MstUserMDL userMstMDL)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[dbo].[USP_AddEditUser]";
            //DateTime Birthdate = Convert.ToDateTime(userMstMDL.DateOfBirth);
            //var birth=Birthdate.ToString("yyyy/MM/dd");
            // DateTime BirthDate = string.IsNullOrEmpty(userMstMDL.DateOfBirth) ? System.Data.SqlTypes.SqlDateTime.MinValue.Value : DateTime.ParseExact(userMstMDL.DateOfBirth, "yyyy/mm/dd", CultureInfo.InvariantCulture);
            List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@iPK_UserId",SqlDbType.Int){Value = userMstMDL.Pk_UserId},
                    new SqlParameter("@iUserId",SqlDbType.Int){Value = userMstMDL.UserId},
                new SqlParameter("@cUserName", userMstMDL.UserName),
                //new SqlParameter("@iFK_CompanyId",SqlDbType.Int){Value = userMstMDL.FK_CompanyId},
                new SqlParameter("@iFK_CategoryId",SqlDbType.Int){Value = userMstMDL.FK_CategoryId},
                new SqlParameter("@iFK_RoleId", SqlDbType.Int) { Value = userMstMDL.FK_RoleId },
                new SqlParameter("@iFK_AccountId",SqlDbType.Int){Value = userMstMDL.FK_AccountId},
                new SqlParameter("@cUserPassword", ClsCrypto.Encrypt(userMstMDL.UserPassword)),
                new SqlParameter("@cUnEncryptedPassword", userMstMDL.UserPassword),//USED TO SHARE PASSWORD VIA EMAIL, FOR THAT UNECRYPTED PASSWORD IS NEEDED. :: BY Vinish : 28th FEB 20
                new SqlParameter("@cMobileNo", userMstMDL.MobileNo),
                new SqlParameter("@iAlternateMobileNo", userMstMDL.AlternateMobileNo),
                new SqlParameter("@cEmailId", userMstMDL.EmailId),
                new SqlParameter("@cAlternateEmailId", userMstMDL.AlternateEmailId),
                new SqlParameter("@bGender", userMstMDL.Gender),
                new SqlParameter("@cDateOfBirth", userMstMDL.DateOfBirth ),
                new SqlParameter("@cUserAddress", userMstMDL.UserAddress),
                new SqlParameter("@iZipCode", userMstMDL.ZipCode),
                new SqlParameter("@iFK_CountryId", SqlDbType.Int){Value= userMstMDL.CountryId},
                new SqlParameter("@iFK_StateId", SqlDbType.Int){Value= userMstMDL.StateId},
                new SqlParameter("@iFK_CityId", SqlDbType.Int){Value= userMstMDL.CityId},
                new SqlParameter("@bIsActive", userMstMDL.IsActive),
                  new SqlParameter("@iFK_CustomerId", userMstMDL.FK_CustomerId),
                //new SqlParameter("@bIsDeleted", userMstMDL.IsDeleted),
                new SqlParameter("@cFullName", userMstMDL.Name),
                new SqlParameter("@cShareBy", userMstMDL.Share),
                new SqlParameter("@bIsVehicleSpecific", userMstMDL.VehicleSpecific),
                
                    //new SqlParameter("@cLastName", userMstMDL.LastName)
                };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    objMessages.Message = (objMessages.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.RecordInserted : (objMessages.Message == "Same User EmailId Already Exists.") ? @GyanmitrasLanguages.LocalResources.Resource.EmailExists : (objMessages.Message == "Mobile No. Already Exists.") ? @GyanmitrasLanguages.LocalResources.Resource.MobileNoExist : (objMessages.Message == "Same User Name already Exists For The Company.") ? @GyanmitrasLanguages.LocalResources.Resource.UserNameExists : (objMessages.MessageId==2)? @GyanmitrasLanguages.LocalResources.Resource.RecordUpdated:@GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
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
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", "MstUserDAL", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, ex.Message, ex.Source, "EXCEPTION IN: AddEditUser METHOD");

            }
            return objMessages;
        }
        /// <summary>
        /// Get List Of category
        /// </summary>
        /// <createBy>NitinGupta</createBy>
        /// <returns></returns>
        public static List<CategoryMDL> CategoryDAL()
        {
            _commandText = "USP_GetAllCategoryList";
            var para = new SqlParameter[1];
            DataSet Category = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);
            List<CategoryMDL> CategoryList = new List<CategoryMDL>();
            CategoryList = Category.Tables[0].AsEnumerable().Select(dr => new CategoryMDL()
            {
                FK_CategoryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_CategoryId")),
                CategoryName = dr.Field<string>("CategoryName"),

            }).ToList();
            return CategoryList;

        }
        /// <summary>
        /// Get List Of Role
        /// </summary>
        /// <createBy>NitinGupta</createBy>
        /// <returns></returns>
        public static List<MstRoleMDL> RolelistDAL(int AccountID, int CustomerId)
        {
            _commandText = "USP_GetAllRoles";
            List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@iFK_AccountId",AccountID),
                    new SqlParameter("@iFK_CustomerId",CustomerId)
            };
            var para = new SqlParameter[1];
            DataSet Category = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
            List<MstRoleMDL> CategoryList = new List<MstRoleMDL>();
            CategoryList = Category.Tables[0].AsEnumerable().Select(dr => new MstRoleMDL()
            {
                PK_RoleId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_RoleId")),
                RoleName = dr.Field<string>("RoleName"),

            }).ToList();
            return CategoryList;

        }
        /// <summary>
        /// Delete User Master 
        /// </summary>
        /// <createBy>NitinGupta</createBy>
        /// <param name="id"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public MessageMDL DeleteUser(int id, int UserId)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "USP_DeleteUser";
            List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iPK_UserId",id),
                   new SqlParameter("@iUserId",UserId)
                };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    objMessages.Message = (objMessages.MessageId ==1) ? @GyanmitrasLanguages.LocalResources.Resource.Deleted : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
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
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", "MstUserDAL", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, ex.Message, ex.Source, "EXCEPTION IN: DeleteUser METHOD");
            }
            return objMessages;
        }
        #endregion Methods
    }
}
