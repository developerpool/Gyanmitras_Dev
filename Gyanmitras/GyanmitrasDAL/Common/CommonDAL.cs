﻿using GyanmitrasDAL.DataUtility;
using GyanmitrasMDL;
using GyanmitrasMDL.User;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utility;

namespace GyanmitrasDAL.Common
{
    public class CommonDAL
    {
        #region
        static DataFunctions objDataFunctions = new DataFunctions();
        static DataTable objDataTable = null;
        static DataSet objDataSet = null;
        static string _commandText = string.Empty;

        #endregion

        static string CommandText = string.Empty;

        #region BIND CUSTOMERS
        public static List<DropDownMDL> BindCustomer()
        {
            List<DropDownMDL> CustomerList = new List<DropDownMDL>();
            try
            {

                DataSet objDataSet = new DataSet();
                List<SqlParameter> parms = new List<SqlParameter>();
                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_GetAllCustomer]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    CustomerList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_CustomerId"),
                        Value = dr.Field<string>("CustomerName"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }


            return CustomerList;
        }
        public static List<DropDownMDL> BindCustomerByAccount(Int64 AccountId = 0, Int64 CustomerId = 0, Int64 ParentCustomerId = 0, Int64 CategoryId = 0, Int64 RoleId = 0, string LoginType = "", string CustomerName = "", string MobileNo = "", string EmailId = "",
            string ZipCode = "", Int64 UserId = 0)
        {
            List<DropDownMDL> CustomerList = new List<DropDownMDL>();
            try
            {

                DataSet objDataSet = new DataSet();
                List<SqlParameter> parms = new List<SqlParameter> {
                    new SqlParameter("@iFK_AccountId",AccountId),
                    new SqlParameter("@iPK_CustomerId",CustomerId),
                    new SqlParameter("@iFK_ParentCustomerId",ParentCustomerId),
                    new SqlParameter("@iFK_CategoryId",CategoryId),
                    new SqlParameter("@iFK_RoleId",RoleId),
                    new SqlParameter("@cLoginType",LoginType),
                    new SqlParameter("@cCustomerName ",CustomerName),
                    new SqlParameter("@cEmailId",EmailId),
                    new SqlParameter("@cZipCode",ZipCode),
                    new SqlParameter("@cMobileNo",MobileNo),
                    new SqlParameter("@iUserId",UserId)
                };

                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_GetAllCustomer]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    CustomerList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_CustomerId"),
                        Value = dr.Field<string>("CustomerName"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }


            return CustomerList;
        }
        public static List<DropDownMDL> BindCustomerByAccountCustomerIdLoginType(Int64 AccountId, Int64 UserId, Int64 CustomerId, string LoginType, string CustomerName)
        {
            List<DropDownMDL> CustomerList = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@iAccountId",AccountId),
                    new SqlParameter("@iUserId",UserId),
                    new SqlParameter("@iCustomerId",CustomerId),
                    new SqlParameter("@cLoginType",LoginType),
                    new SqlParameter("@cCustomerName",CustomerName),
                };

                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_GetCustomerByAccountCustomerIdLoginType]";

                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    CustomerList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_CustomerId"),
                        Value = dr.Field<string>("CustomerName"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }


            return CustomerList;
        }

        #endregion
        public static List<DropDownMDL> GetAccountListByCategoryIdLoginType(Int64 AccountId, Int64 UserId, Int64 CustomerId, string LoginType, Int64 CategoryId)
        {
            List<DropDownMDL> CustomerList = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@iAccountId",AccountId),
                    new SqlParameter("@iUserId",UserId),
                    new SqlParameter("@iCustomerId",CustomerId),
                    new SqlParameter("@cLoginType",LoginType),
                    new SqlParameter("@iFK_CategoryId",CategoryId),
                };

                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_GetAccountListByCategoryIdLoginType]";

                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    CustomerList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_AccountId"),
                        Value = dr.Field<string>("AccountName"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }


            return CustomerList;
        }


        public static List<CompanyMDL> FillCompany(int companyID, int userId)
        {
            CommandText = "usp_GetComapnylist";

            var para = new SqlParameter[2];
            para[0] = new SqlParameter("@iCompanyId", SqlDbType.Int) { Value = Convert.ToInt32(companyID) };
            para[1] = new SqlParameter("@iUserId", SqlDbType.Int) { Value = Convert.ToInt32(userId) };


            DataSet company = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, para.ToList());
            List<CompanyMDL> CompanyList = new List<CompanyMDL>();
            CompanyList = company.Tables[0].AsEnumerable().Select(dr => new CompanyMDL()
            {
                CompanyId = WrapDbNull.WrapDbNullValue<int>(dr.Field<int?>("PK_CompanyId")),
                CompanyName = dr.Field<string>("CompanyName"),


            }).ToList();
            return CompanyList;
        }
        public static List<DropDownMDL> FillLanguages()
        {
            CommandText = "[dbo].[usp_getLanguages]";

            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = WrapDbNull.WrapDbNullValue<int>(dr.Field<int?>("PK_LanguageId")),
                Value = dr.Field<string>("LanguageFullName"),
                //Detail = dr.Field<string>("LanguageCultureName,LanguageIcon")
            }).ToList();
            return _dropdownlist;
        }
        /// <summary>
        ///  Created By:Vinish 
        /// Created Date:10 Jan 2019
        /// PURPOSE:-Fill Role List
        /// </summary>
        /// <param name="FK_CustomerId"></param>
        /// <returns></returns>

        public static List<DropDownMDL> FillRoles(Int64 FK_CustomerId, Int64 AccountId)
        {
            CommandText = "[dbo].[USP_GetAllRoles]";
            List<SqlParameter> parms = new List<SqlParameter> {
                new SqlParameter("@iFK_CustomerId",FK_CustomerId),
                new SqlParameter("@iFK_AccountId",AccountId)
            };
            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_RoleId")),
                Value = dr.Field<string>("RoleName"),
                //Detail = dr.Field<string>("LanguageCultureName,LanguageIcon")
            }).ToList();
            return _dropdownlist;
        }

        #region Country - State - City
        public static List<DropDownMDL> GetCountryList()
        {
            CommandText = "[dbo].[usp_GetCountryList]";

            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_CountryId")),
                Value = dr.Field<string>("CountryName"),
                //Detail = dr.Field<string>("LanguageCultureName,LanguageIcon")
            }).ToList();
            return _dropdownlist;
        }
        public static List<DropDownMDL> BindCustomerType()
        {
            CommandText = "[dbo].[USP_GetAllCustomerType]";

            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_CustomerTypeId")),
                Value = dr.Field<string>("CustomerTypeName"),
                //Detail = dr.Field<string>("LanguageCultureName,LanguageIcon")
            }).ToList();
            return _dropdownlist;
        }



        public static List<DropDownMDL> GetStateDetailsByCountryId(int countryId)
        {
            CommandText = "[dbo].[usp_GetStateDetailsByCountryId]";
            SqlParameter param = new SqlParameter() { ParameterName = "@iFK_CountryId", Value = countryId };
            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, param);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_StateId")),
                Value = dr.Field<string>("StateName"),
                AlreadyExist = dr.Field<string>("TimeZone"),
            }).ToList();
            return _dropdownlist;
        }
        public static List<DropDownMDL> GetCityDetailsByStateId(Int64 stateId)
        {
            CommandText = "[dbo].[usp_GetCityDetailsByStateId]";
            SqlParameter param = new SqlParameter() { ParameterName = "@iFK_StateId", Value = stateId };
            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, param);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_CityId")),
                Value = dr.Field<string>("CityName"),

            }).ToList();
            return _dropdownlist;
        }
        #endregion CountryStateCity

        #region Forms
        public static List<DropDownMDL> FillForms()
        {
            CommandText = "[dbo].[usp_getForms]";

            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_FormId")),
                Value = dr.Field<string>("FormName"),
                //Detail = dr.Field<string>("LanguageCultureName,LanguageIcon")
            }).ToList();
            return _dropdownlist;
        }
        public static List<DropDownMDL> BindForms()
        {
            List<DropDownMDL> FormList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>();
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "usp_GetAllForms ";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    FormList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("ID"),
                        Value = dr.Field<string>("Value"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }


            return FormList;
        }
        public static List<DropDownMDL> BindParentForms()
        {
            List<DropDownMDL> FormList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>();
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "USP_GetParentForms ";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    FormList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("Pk_FormId"),
                        Value = dr.Field<string>("FormName"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }


            return FormList;
        }
        #endregion forms

        #region Customer - Account&Category
        public static List<DropDownMDL> FillTagNameWithAccountId(int AccountId, string TagType)
        {
            _commandText = "[dbo].[USP_GetTagNameList]";
            var para = new SqlParameter[2];
            para[0] = new SqlParameter("@iFK_AccountId", SqlDbType.Int) { Value = Convert.ToInt32(AccountId) };
            para[1] = new SqlParameter("@cTagType", SqlDbType.VarChar) { Value = TagType };

            DataSet ds = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, para.ToList());
            List<DropDownMDL> TypeList = new List<DropDownMDL>();
            TypeList = ds.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_AccountId")),
                Value = dr.Field<string>("TagName")
            }).ToList();
            return TypeList;
        }
        public static List<DropDownMDL> GetAllAccountsByCategory(int categoryId)
        {
            CommandText = "USP_GetAccountListByCategoryId";
            SqlParameter param = new SqlParameter() { ParameterName = "@iFK_CategoryId", Value = categoryId };
            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, param);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_AccountId")),
                Value = dr.Field<string>("AccountName"),
                //Detail = dr.Field<string>("LanguageCultureName,LanguageIcon")
            }).ToList();
            return _dropdownlist;
        }
        public static List<DropDownMDL> BindCategory()
        {
            List<DropDownMDL> CategoryList = new List<DropDownMDL>();
            try
            {


                List<SqlParameter> parms = new List<SqlParameter>();
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "USP_GetAllCategoryList ";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    CategoryList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_CategoryId"),
                        Value = dr.Field<string>("CategoryName"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }


            return CategoryList;
        }
        #endregion CustomerAccountCategory

        #region AccountID&Name
        public static List<DropDownMDL> BindAccountsByCategory(Int64 CategoryId)
        {
            List<DropDownMDL> AccountList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_CategoryId",CategoryId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllParentAccounts]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    AccountList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_AccountId"),
                        Value = dr.Field<string>("AccountName"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }
            return AccountList;
        }




        public static List<DropDownMDL> BindAllAccountsByCategory(Int64 CategoryId)
        {
            List<DropDownMDL> AccountList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_CategoryId",CategoryId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[BindAllAccountsByCategory]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    AccountList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_AccountId"),
                        Value = dr.Field<string>("AccountName"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }
            return AccountList;
        }
        #endregion AccountID&Name
        public static List<DropDownMDL> BindUsers(Int64 FK_AccountId, Int64 UserId)
        {
            List<DropDownMDL> UserList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_AccountId",FK_AccountId),
                      new SqlParameter("@iLoggedIn_UserId",UserId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetUserList]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    UserList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_UserId")),
                        Value = dr.Field<string>("UserName")

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }
            return UserList;
        }

        /// <summary>
        /// get List of Sim Telecom For MSTSim
        /// </summary>
        /// <returns></returns>
        public static List<DropDownMDL> GetSimTelco()
        {
            List<DropDownMDL> SimTelcoList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>();
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "USP_GetAllSimTelco";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    SimTelcoList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("ID"),
                        Value = dr.Field<string>("Value"),

                    }).ToList();
                }
            }
            catch (Exception ex)
            {

            }
            return SimTelcoList;
        }
        /// <summary>
        /// CREATED DATE : 12 Dec 2019
        /// PURPOSE :  Get All Solution Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="solutionId"></param>
        /// <returns></returns>
        //public static List<SolutionMDL> GetAllSolution(int solutionId = 0)
        //{
        //    List<SolutionMDL> solutionList = new List<SolutionMDL>();
        //    _commandText = "[dbo].[Usp_GetSolutionDetails]";
        //    try
        //    {
        //        List<SqlParameter> parms = new List<SqlParameter>()
        //        {
        //            new SqlParameter("@PK_SolutionId",solutionId)
        //        };
        //        objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
        //        if (objDataSet != null)
        //        {
        //            solutionList = objDataSet.Tables[1].AsEnumerable().Select(r => new SolutionMDL()
        //            {
        //                PK_SolutionId = r.Field<Int64>("PK_SolutionId"),
        //                SolutionName = r.Field<string>("SolutionName")

        //            }).ToList();
        //            objDataSet.Dispose();
        //        }
        //    }
        //    catch (Exception)
        //    {
        //    }
        //    return solutionList;
        //}

        /// <summary>
        ///  CREATED DATE : 16 Dec 2019
        /// PURPOSE : Get all alert message details.
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="alertId"></param>
        /// <returns></returns>
        //public static List<AlertMDL> GetAllAlertMessage(int alertId = 0)
        //{
        //    List<AlertMDL> alertMsgList = new List<AlertMDL>();
        //    _commandText = "[dbo].[USP_GetPackageAlert]";
        //    try
        //    {
        //        List<SqlParameter> parms = new List<SqlParameter>()
        //        {
        //            new SqlParameter("@iPK_AlertId",alertId)
        //        };
        //        objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
        //        if (objDataSet != null)
        //        {
        //            alertMsgList = objDataSet.Tables[1].AsEnumerable().Select(r => new AlertMDL()
        //            {
        //                PK_AlertId = r.Field<Int64>("PK_AlertId"),
        //                AlertType = r.Field<string>("AlertType"),
        //                AlertValue = r.Field<string>("AlertValue")
        //            }).ToList();
        //            objDataSet.Dispose();
        //        }
        //    }
        //    catch (Exception)
        //    {
        //    }
        //    return alertMsgList;
        //}

        /// <summary>
        /// Get all country.
        /// </summary>
        /// <param name=""></param>
        /// created by : Vinish (Vinish code)
        /// <returns></returns>

        /// <summary>
        /// Get all country.
        /// </summary>
        /// <param name=""></param>
        /// created by : Vinish (Vinish code)
        /// <returns></returns>
        public static List<DropDownMDL> BindDeviceType()
        {
            List<DropDownMDL> DeviceTypeList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>();
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllDeviceType]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    DeviceTypeList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("ID"),
                        Value = dr.Field<string>("Value"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }
            return DeviceTypeList;
        }

        /// <summary>
        /// CREATED BY Vinish :: 03 JAN 2020
        /// PURPOSE: TO GET COLUMN LIST WHICH IS CONFIGURED FOR A FORM FOR A COMPANY
        /// </summary>
        /// <param name="ControllerName">CAALING CONTROLLER</param>
        /// <param name="ActionName">ACTION NAME: MAINLY INDEX</param>
        /// <param name="AccountId">LOGGED IN ACCOUNT ID FROM SESSION</param>
        /// <returns>LIST OF COLUMN NAME</returns>
        public static List<FormColumnAssignmentMDL> GetFormColumnConfigList(string ControllerName, string ActionName, Int64 AccountId, Int64 CustomerId)
        {
            List<FormColumnAssignmentMDL> _FormColumnConfigList = new List<FormColumnAssignmentMDL>();

            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@cControllerName",ControllerName),
                    new SqlParameter("@cActionName",ActionName),
                    new SqlParameter("@iAccountId",AccountId),
                     new SqlParameter("@iCustomerId",CustomerId)
                };
                _commandText = "[dbo].[Usp_GetFormColumnConfigList]";

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
                    }
                }
            }

            catch (Exception ex)
            {

            }
            return _FormColumnConfigList;
        }
        public static List<DropDownMDL> BindMappedFormColumn()
        {
            List<DropDownMDL> MappedFormColumnlist = new List<DropDownMDL>();
            try
            {


                List<SqlParameter> parms = new List<SqlParameter>();
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllMappedFormColumn]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    MappedFormColumnlist = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("ID"),
                        Value = dr.Field<string>("Value"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }
            return MappedFormColumnlist;
        }
        /// <summary>
        /// To Get the Columns For Mapping
        /// </summary>
        /// <param name="FK_FormId"></param>
        /// <param name="FK_AccountId"></param>
        /// <param name="FK_CustomerId"></param>
        /// <returns></returns>
        public static List<FormColumnAssignmentMDL> GetColumnsByFormId(Int64 FK_FormId, Int64 FK_AccountId, Int64 FK_CustomerId)
        {
            List<FormColumnAssignmentMDL> MappedFormColumnlist = new List<FormColumnAssignmentMDL>();
            try
            {


                List<SqlParameter> parms = new List<SqlParameter>{

                    new SqlParameter("@iFK_FormId",FK_FormId),
                    new SqlParameter("@iFK_AccountId",FK_AccountId),
                    new SqlParameter("@iFK_CustomerId",FK_CustomerId),
                };
                _commandText = "[dbo].[USP_GetPageColumnConfigDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    MappedFormColumnlist = objDataSet.Tables[1].AsEnumerable().Select(dr => new FormColumnAssignmentMDL()
                    {
                        Fk_FormId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64>("FK_FormId")),
                        PK_FormColumnConfigId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64>("PK_PageColumnConfigId")),
                        PK_FormColumnId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64>("FK_FormColumnId")),
                        //    AccountId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64>("FK_AccountId")),
                        FormName = dr.Field<string>("FormName"),
                        ColumnName = dr.Field<string>("Column_Name"),
                        IsActive = WrapDbNull.WrapDbNullValue<bool>(dr.Field<bool>("IsActive")),
                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }
            return MappedFormColumnlist;
        }
        public static List<DropDownMDL> BindDriver(Int64 FK_CustomerId)
        {
            List<DropDownMDL> DriverList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_CustomerId",FK_CustomerId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllDriver]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    DriverList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_DriverId"),
                        Value = dr.Field<string>("DriverName"),

                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return DriverList;
        }
        /// <summary>
        /// /// Created By:Vinish
        /// Created Date:06-01-2019
        /// PURPOSE:- To Get Already Mapped Account With User For User Account Mapping(Multiple Accounts)
        /// </summary>
        /// <param name="CategoryId"></param>
        /// <param name="Fk_UserId"></param>
        /// <returns></returns>
        public static List<DropDownMDL> BindAccountsByCategoryWithAlreadyExist(Int64 FK_CategoryId, Int64 Fk_UserId)
        {
            List<DropDownMDL> AccountList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_CategoryId",FK_CategoryId),
                     new SqlParameter("@iFK_UserId",Fk_UserId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllParentAccounts]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    AccountList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_AccountId"),
                        Value = dr.Field<string>("AccountName"),
                        AlreadyExist = dr.Field<string>("AlreadyExist")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return AccountList;
        }

        #region VEHICLE RELATED FUNCTIONS
        /// <summary>
        /// THIS FUNCTIONS GET ALL VEHICLE GROUPS BASED ON CONDITIONS MENTIONED BELOW
        /// </summary>
        /// <param name="AccountId">LOGGED IN OR SELECTED ACCOUNT ID</param>
        /// <param name="UserId">LOGGED IN USER ID</param>
        /// <param name="CustomerId">LOGGED IN OR SELECTED CUSTOMER ID</param>
        /// <param name="GroupName">ENTERED/SEARCHED GROUP NAME</param>
        /// <returns>LIST OF VEHICLE GROUPS</returns>
        public static List<DropDownMDL> GetVehicleGroupsByCustomerIdAccountId(Int64 AccountId, Int64 UserId, Int64 CustomerId, string GroupName)
        {
            List<DropDownMDL> VehicleGrpList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iAccountId",AccountId),
                    new SqlParameter("@iUserId",UserId),
                    new SqlParameter("@iCustomerId",CustomerId),
                    new SqlParameter("@cGroupName",GroupName)
                };

                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[Usp_GetVehicleGroupsByCustomerIdAccountId]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    VehicleGrpList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        Value = dr.Field<string>("GroupName"),
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return VehicleGrpList;
        }


        /// <summary>
        /// Created By:Vinish
        /// Created Date:06-01-2019
        /// Purpose:To Get All Customer Wise  Mapped vehicles  
        /// & Get All Existing Mapped Vehicle Group With Customer
        /// </summary>
        /// <param name="FK_CustomerId"></param>
        ///   /// <param name="GroupName"></param>
        /// <returns></returns>
        public static List<DropDownMDL> BindMappedvehiclesByCustomer(Int64 FK_CustomerId, string GroupName)
        {
            List<DropDownMDL> VehicleList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_CustomerId",FK_CustomerId),
                     new SqlParameter("@cGroupName",GroupName)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetMappedVehicleWithCustomer]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    VehicleList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_VehicleId"),
                        Value = dr.Field<string>("RegistrationNo"),
                        AlreadyExist = dr.Field<string>("AlreadyExist")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return VehicleList;
        }

        /// <summary>
        /// Created By:Vinish
        /// Created Date:18-01-2020
        /// Purpose:To Get All Vehicles By Login Type(Either Customer Log in or Other Account Login)
        /// </summary>
        /// <param name="AccountId"></param>
        /// <param name="UserId"></param>
        /// <param name="CustomerId"></param>
        /// <param name="LoginType"></param>
        /// <returns></returns>
        public static List<DropDownMDL> GetVehicleByLoginType(Int64 AccountId, Int64 UserId, Int64 CustomerId, string LoginType, string VehicleNo)
        {
            List<DropDownMDL> VehicleList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()

                     {
                     new SqlParameter("@iFK_AccountId",AccountId),
                     new SqlParameter("@iUserId",UserId),
                     new SqlParameter("@iFK_CustomerId",CustomerId),
                     new SqlParameter("@cLoginType",LoginType),
                     new SqlParameter("@cVehicleNo",VehicleNo)
                     };

                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetVehiclesByLoginType]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    VehicleList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_VehicleId"),
                        Value = dr.Field<string>("RegistrationNo")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return VehicleList;
        }



        #endregion

        #region FMS

        /// <summary>
        /// Created By:Vinish
        /// Created Date:29-01-2020
        /// Purpose:To Get All Title For Expenses 
        /// </summary>
        /// <param name="Title"></param>
        /// <returns></returns>
        public static List<DropDownMDL> GetAllTitle(string Title, string TitleType)
        {
            List<DropDownMDL> TitleList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                     {

                     new SqlParameter("@cTitle",Title),
                     new SqlParameter("@cTitleType",TitleType)
                     };

                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[FMS].[USP_GetAllTitles]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    TitleList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("ID"),
                        Value = dr.Field<string>("Title")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {

            }
            return TitleList;
        }

        /// <summary>
        /// Created By:Vinish
        /// Created Date:29-01-2020
        /// Purpose:To Get Email By Customer Id 
        /// </summary>
        /// <param name="FK_CustomerId"></param>
        /// <returns></returns>
        public static List<DropDownMDL> GetEmailByCustomerId(Int64 FK_CustomerId, string LoginType)
        {
            List<DropDownMDL> EmailList = new List<DropDownMDL>();
            try
            {

                DataSet objDataSet = new DataSet();
                List<SqlParameter> parms = new List<SqlParameter> {
                    new SqlParameter("@iPK_CustomerId",FK_CustomerId),
                    new SqlParameter("@cLoginType",LoginType)
                };

                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_GetAllCustomer]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    EmailList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_CustomerId"),
                        Value = dr.Field<string>("EmailId"),
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }


            return EmailList;
        }
        #endregion


        /// <summary>
        ///  Created By:Vinish
        /// Created Date:10 Jan 2019
        /// PURPOSE:- Bind Installer List
        /// </summary>
        /// <returns></returns>

        public static List<DropDownMDL> BindInstaller(Int64 customerId = 0, string installerName = "", Int64 accountId = 0, string mobileNo = "", string emailId = "", string zipCode = "", string loginType = "", Int64 userId = 0)
        {

            List<DropDownMDL> InstallerList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_CustomerId",customerId),
                     new SqlParameter("@cInstallerName",installerName),
                     new SqlParameter("@iFK_AccountId",accountId),
                     new SqlParameter("@cMobileNo",mobileNo),
                     new SqlParameter("@cEmailId",emailId),
                     new SqlParameter("@cZipCode",zipCode),
                     new SqlParameter("@cLoginType",loginType),
                     new SqlParameter("@@iFK_UserId",userId)

                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllInstaller]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    InstallerList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_InstallerId"),
                        Value = dr.Field<string>("InstallerName"),
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return InstallerList;


        }


        /// <summary>
        ///  Created By:Vinish
        /// Created Date:10 Jan 2019
        /// PURPOSE:- Bind Installer Type List
        /// </summary>
        /// <returns></returns>
        public static List<DropDownMDL> BindInstallerTypes()
        {

            List<DropDownMDL> InstallerList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllInstallerType]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    InstallerList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_InstallerTypeId"),
                        Value = dr.Field<string>("InstallerTypeName"),
                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }
            return InstallerList;


        }
        public static List<DropDownMDL> BindInstallerByAccount(int AccountId)
        {

            List<DropDownMDL> InstallerList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_AccountId",AccountId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllInstaller]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    InstallerList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_InstallerId"),
                        Value = dr.Field<string>("InstallerName"),
                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }
            return InstallerList;


        }

        /// <summary>
        /// CREATED DATE : 10 Jan 2020
        /// PURPOSE :  Get All Package Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="accountId"></param>
        /// <param name="userId"></param>
        /// <param name="packageName"></param>
        /// <param name="plateFormType"></param>
        /// <returns></returns>
        public static List<DropDownMDL> BindGetAllPackage(Int64 accountId = 0, Int64 userId = 0, string packageName = "", string plateFormType = "")
        {
            List<DropDownMDL> packageList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_AccountId",accountId),
                     new SqlParameter("@iFK_UserId",userId),
                     new SqlParameter("@cPackageName",packageName),
                     new SqlParameter("@cPlateFormType",plateFormType)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllPackage]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    packageList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_PackageId"),
                        Value = dr.Field<string>("PackageName")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return packageList;
        }

        /// <summary>
        /// CREATED DATE : 10 Jan 2020
        /// PURPOSE :  Get All Device Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="accountId"></param>
        /// <param name="categoryId"></param>
        /// <param name="deviceTypeId"></param>
        /// <param name="supplier"></param>
        /// <param name="deviceId"></param>
        /// <param name="iMEINO"></param>
        /// <returns></returns>
        //public static List<MstDeviceMDL> BindGetAllDevice(Int64 accountId = 0, Int64 categoryId = 0, Int64 deviceTypeId = 0, string supplier = "", string deviceId = "", string iMEINO = "")
        //{
        //    List<MstDeviceMDL> deviceList = new List<MstDeviceMDL>();
        //    _commandText = "[dbo].[USP_GetAllDevice]";
        //    try
        //    {
        //        List<SqlParameter> parms = new List<SqlParameter>()
        //        {
        //            new SqlParameter("@iFK_AccountId",accountId),
        //            new SqlParameter("@iFK_CategoryId",categoryId),
        //            new SqlParameter("@iFK_DeviceTypeId",deviceTypeId),
        //            new SqlParameter("@cSupplier",supplier),
        //            new SqlParameter("@cDeviceID",deviceId),
        //            new SqlParameter("@cIMEINO",iMEINO)
        //        };
        //        objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
        //        if (objDataSet != null)
        //        {
        //            deviceList = objDataSet.Tables[0].AsEnumerable().Select(r => new MstDeviceMDL()
        //            {
        //                PK_DeviceId = r.Field<Int64>("PK_DeviceId"),
        //                DeviceNo = r.Field<string>("DeviceID"),
        //                IMEINo = r.Field<string>("IMEINo"),
        //                DeviceTypeName = r.Field<string>("DeviceTypeName")
        //            }).ToList();
        //            objDataSet.Dispose();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        var objBase = System.Reflection.MethodBase.GetCurrentMethod();
        //        ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
        //    }
        //    return deviceList;
        //}



        /// <summary>
        /// CREATED DATE : 11 Jan 2020
        /// PURPOSE :  Get All Sim Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="accountId"></param>
        /// <param name="categoryId"></param>
        /// <param name="deviceTypeId"></param>
        /// <returns></returns>
        //public static List<MstSimMDL> BindGetAllSimDetails(Int64 accountId = 0, Int64 categoryId = 0, string deviceTypeId = "")
        //{
        //    List<MstSimMDL> simList = new List<MstSimMDL>();
        //    _commandText = "[dbo].[USP_GetAllSIM]";
        //    try
        //    {
        //        List<SqlParameter> parms = new List<SqlParameter>()
        //        {
        //            new SqlParameter("@iFK_AccountId",accountId),
        //            new SqlParameter("@iFK_SimTelcoId",categoryId),
        //            new SqlParameter("@cSIMSN",deviceTypeId)
        //        };
        //        objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
        //        if (objDataSet != null)
        //        {
        //            simList = objDataSet.Tables[0].AsEnumerable().Select(r => new MstSimMDL()
        //            {
        //                SimId = r.Field<Int64>("PK_SimId"),
        //                SIMMobileNo = r.Field<string>("SIMMObileNo"),
        //                SIMActivationDate = r.Field<string>("SIMActivationDate"),
        //                SIMExpiryDate = r.Field<string>("SIMExpiryDate"),
        //                SimTelcoType = r.Field<string>("SimTelcoName"),
        //                SIMSN = r.Field<string>("SIMSN")
        //            }).ToList();
        //            objDataSet.Dispose();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        var objBase = System.Reflection.MethodBase.GetCurrentMethod();
        //        ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
        //    }
        //    return simList;
        //}



        /// <summary>
        /// CREATED DATE : 11 Jan 2020
        /// PURPOSE :  Get All Installer Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="accountId"></param>
        /// <param name="installerName"></param>
        /// <param name="mobileNo"></param>
        /// <param name="emailId"></param>
        /// <param name="zipCode"></param>
        /// <returns></returns>
        public static List<DropDownMDL> BindGetAllInstaller(Int64 customerId = 0, string installerName = "", Int64 accountId = 0, string mobileNo = "", string emailId = "", string zipCode = "", string loginType = "", Int64 userId = 0)
        {
            List<DropDownMDL> installerList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_CustomerId",customerId),
                     new SqlParameter("@cInstallerName",installerName),
                     new SqlParameter("@iFK_AccountId",accountId),
                     new SqlParameter("@cMobileNo",mobileNo),
                     new SqlParameter("@cEmailId",emailId),
                     new SqlParameter("@cZipCode",zipCode),
                     new SqlParameter("@cLoginType",loginType),
                     new SqlParameter("@iFK_UserId",userId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllInstaller]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    installerList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_InstallerId"),
                        Value = dr.Field<string>("InstallerName")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return installerList;
        }

        /// <summary>
        /// CREATED DATE : 11 Jan 2020
        /// PURPOSE :  Get All Vehicle Brand Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="vehicleBrandName"></param>
        /// <returns></returns>
        public static List<DropDownMDL> BindGetAllVehicleBrand(string vehicleBrandName = "")
        {
            List<DropDownMDL> vehicleBrandList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@cVehicleBrandName",vehicleBrandName)

                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllVehicleBrand]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    vehicleBrandList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_VehicleBrandId"),
                        Value = dr.Field<string>("VehicleBrandName")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return vehicleBrandList;
        }



        /// <summary>
        /// CREATED DATE : 11 Jan 2020
        /// PURPOSE :  Get All Vehicle Type Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="vehicleBrandName"></param>
        /// <returns></returns>
        public static List<DropDownMDL> BindGetAllVehicleType(string vehicleType = "")
        {
            List<DropDownMDL> vehicleTypeList = new List<DropDownMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@cVehicleType",vehicleType)

                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllVehicleType]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    vehicleTypeList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("ID"),
                        Value = dr.Field<string>("Value")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return vehicleTypeList;
        }

        /// <summary>
        /// CREATED DATE : 11 Jan 2020
        /// PURPOSE :  Get All Accessory Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="accessoryId"></param>
        /// <returns></returns>
        //public static List<AccessoryMDL> GetAllAccessory(int accessoryId = 0)
        //{
        //    List<AccessoryMDL> accessoryList = new List<AccessoryMDL>();
        //    _commandText = "[USP_GetAllAccessory]";
        //    try
        //    {
        //        List<SqlParameter> parms = new List<SqlParameter>()
        //        {
        //            new SqlParameter("@iPK_AccessoryId",accessoryId)
        //        };
        //        objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
        //        if (objDataSet != null)
        //        {
        //            accessoryList = objDataSet.Tables[0].AsEnumerable().Select(r => new AccessoryMDL()
        //            {
        //                PK_AccessoryId = r.Field<Int64>("PK_AccessoryId"),
        //                AccessoryName = r.Field<string>("AccessoryName")

        //            }).ToList();
        //            objDataSet.Dispose();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        var objBase = System.Reflection.MethodBase.GetCurrentMethod();
        //        ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
        //    }
        //    return accessoryList;
        //}

        /// <summary>
        /// CREATED DATE : 11 Jan 2020
        /// PURPOSE :  Get All PaymentMode
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="paymentModeId"></param>
        /// <returns></returns>
        public static List<DropDownMDL> BindGetAllPaymentMode(Int64 paymentModeId = 0)
        {
            List<DropDownMDL> paymentModeList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iPK_PaymentModeId",paymentModeId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllPaymentMode]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    paymentModeList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("ID"),
                        Value = dr.Field<string>("Value")

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }
            return paymentModeList;
        }
        /// <summary>
        /// CREATED BY : Vinish
        /// CREATED DATE : 13 Jan 2020
        /// PURPOSE :  Get Category List By Login Type
        /// </summary>
        /// <param name="LoginType"></param>
        /// <returns></returns>



        public static List<DropDownMDL> BindCategoryByLoginType(string LoginType = "")
        {
            List<DropDownMDL> CategoryList = new List<DropDownMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@LoginType",LoginType)
                };


                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetALLCategoryByLoginType]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    CategoryList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_CategoryId"),
                        Value = dr.Field<string>("CategoryName"),

                    }).ToList();
                }
            }
            catch (Exception e)
            {

            }


            return CategoryList;
        }

        public static MessageMDL CheckUserNameDAL(string username)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "USP_CheckUserName";
            List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@cUserName",username),
                };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    objMessages.Message = (objMessages.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.UserNameExists : @GyanmitrasLanguages.LocalResources.Resource.UserNameValidation;
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
                ErrorLogDAL.SetError("Gyanmitras", "CommonDal", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, ex.Message, ex.Source, "EXCEPTION IN: CheckUserName METHOD");
            }
            return objMessages;
        }
        public static MessageMDL CheckEmailId(string EmailId)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "USP_CheckEmailId";
            List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@cEmailId",EmailId),
                };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    objMessages.Message = (objMessages.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.EmailExists : @GyanmitrasLanguages.LocalResources.Resource.EmailValidation;
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
                ErrorLogDAL.SetError("Gyanmitras", "CommonDal", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, ex.Message, ex.Source, "EXCEPTION IN: CheckEmailId METHOD");
            }
            return objMessages;
        }
        /// <summary>
        /// Check duplicate Sim Sn
        /// created by Vinish
        /// created date 12/02/2020
        /// </summary>
        /// <param name="SimSn"></param>
        /// <returns></returns>
        public static MessageMDL CheckSimSN(string SimSn)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[USP_CheckDuplicateSimSn]";
            List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@cSimSn",SimSn),
                };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    objMessages.Message = (objMessages.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.EmailExists : @GyanmitrasLanguages.LocalResources.Resource.EmailValidation;
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
                ErrorLogDAL.SetError("Gyanmitras", "CommonDal", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, ex.Message, ex.Source, "EXCEPTION IN: CheckEmailId METHOD");
            }
            return objMessages;
        }
        /// <summary>
        /// Check duplicate Sim no 
        /// created by Vinish
        /// created date 12/02/2020
        /// </summary>
        /// <param name="SimNo"></param>
        /// <returns></returns>
        public static MessageMDL CheckSimNO(string SimNo)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[USP_CheckDuplicateSimNo]";
            List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@cSimNo",SimNo),
                };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    objMessages.Message = (objMessages.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.EmailExists : @GyanmitrasLanguages.LocalResources.Resource.EmailValidation;
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
                ErrorLogDAL.SetError("Gyanmitras", "CommonDal", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, ex.Message, ex.Source, "EXCEPTION IN: CheckEmailId METHOD");
            }
            return objMessages;
        }


        /// <summary>
        /// CREATED DATE : 30 Jan 2020
        /// PURPOSE :  Get All User Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="paymentModeId"></param>
        /// <returns></returns>
        public static List<MstUserMDL> BindGetUserDetails(Int64 customerId = 0, Int64 accountId = 0, string mobileNo = "", string userName = "", string emailId = "", string zipCode = "", string loginType = "", Int64 userId = 0)
        {
            List<MstUserMDL> userList = new List<MstUserMDL>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_CustomerId",customerId),
                     new SqlParameter("@iFK_AccountId",accountId),
                     new SqlParameter("@cMobileNo",mobileNo),
                     new SqlParameter("@cUserName",userName),
                     new SqlParameter("@cEmailId",emailId),
                     new SqlParameter("@cZipCode",zipCode),
                     new SqlParameter("@cLoginType",loginType),
                     new SqlParameter("@iFK_UserId",userId),
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllUserForOptionalCondition]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    userList = objDataSet.Tables[0].AsEnumerable().Select(dr => new MstUserMDL()
                    {
                        UserId = dr.Field<Int64>("PK_UserId"),
                        UserName = dr.Field<string>("UserName"),
                        EmailId = dr.Field<string>("EmailId")

                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return userList;
        }
        /// <summary>
        /// CREATED DATE : 30 Jan 2020
        /// PURPOSE :  Get Packet Type
        ///  CREATED BY : Vinish
        /// </summary>
        /// <returns></returns>


        public static List<DropDownMDL> GetPacketType()
        {
            CommandText = "dbo.usp_getpacketType";
            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet);

            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
            {
                Value = dr.Field<string>("Item"),
            }).ToList();
            return _dropdownlist;
        }

        /// <summary>
        /// CREATED BY : Vinish
        /// CREATED DATE : 31-01-2020
        /// PURPOSE :  Get All User Port  By Accounts
        /// </summary>
        /// <param name="AccountId"></param>
        /// <param name="UserId"></param>
        /// <param name="CustomerId"></param>
        /// <param name="LoginType"></param>
        /// <returns></returns>
        public static List<DropDownMDL> BindPortByAccountId(Int64 PK_Map_VehiclePortId, Int64 AccountId, Int64 UserId, Int64 CustomerId, string LoginType)
        {
            List<DropDownMDL> PortList = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>
                {

                    new SqlParameter("@iPK_Map_VehiclePortId",PK_Map_VehiclePortId),
                    new SqlParameter("@iFK_AccountId",AccountId),
                    new SqlParameter("@iFK_UserId",UserId),
                    new SqlParameter("@iFK_CustomerId",CustomerId),
                    new SqlParameter("@cLoginType",LoginType)
                };

                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_GetportsByAccountId]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    PortList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_PortId"),
                        Value = dr.Field<string>("PortName"),
                        AlreadyExist = dr.Field<string>("AlreadyExist")

                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return PortList;
        }


        /// <summary>
        /// CREATED BY : Vinish
        /// CREATED DATE : 04-02-2020
        /// PURPOSE :  Get All User Port  By Accounts
        /// </summary>
        /// <param name="@JSON"></param>

        /// <returns>@ReturnJson</returns>
        public static MessageMDL CheckNameOrCodePresentInsystem(string JSON)
        {
            MessageMDL message = new MessageMDL();
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>
                {

                    new SqlParameter("@JSON",JSON)
                };

                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_CheckNameOrCodePresentInsystem]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    message.Message = objDataSet.Tables[0].Rows[0][0].ToString();
                    message.MessageId = 1;
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return message;
        }



        /// <summary>
        /// CREATED BY : Vinish
        /// CREATED DATE : 05-02-2020
        /// PURPOSE :  Get Port Geo Info List By Port Id For Sync Mongo
        /// </summary>
        /// <param name="PortId"></param>
        /// <returns></returns>
        //public static List<SyncMongoGeoDataMDL> SyncingPortData(int PortId)
        //{
        //    List<SyncMongoGeoDataMDL> _SyncMongoPortDataList = new List<SyncMongoGeoDataMDL>();
        //    try
        //    {
        //        DataSet objDataSet = new DataSet();
        //        List<SqlParameter> parms = new List<SqlParameter>
        //        {
        //            new SqlParameter("@iPortId",PortId) 
        //        };

        //        CheckParameters.ConvertNullToDBNull(parms);
        //        CommandText = "[dbo].[USP_GetPortDetail]";
        //        objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
        //        _SyncMongoPortDataList = objDataSet.Tables[0].AsEnumerable().Select(dr => new SyncMongoGeoDataMDL()

        //        {
        //            latitude = Convert.ToDouble(dr.Field<string>("Lat")),
        //            longitude = Convert.ToDouble(dr.Field<string>("Lon")),
        //            radius = Convert.ToDouble(dr.Field<string>("Radius")),
        //            centerLat = Convert.ToDouble(dr.Field<string>("CentreLat")),
        //            centerLong = Convert.ToDouble(dr.Field<string>("CentreLon"))
        //        }).ToList();
        //    }
        //    catch (Exception ex)
        //    {
        //        var objBase = System.Reflection.MethodBase.GetCurrentMethod();
        //        ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
        //    }
        //    return _SyncMongoPortDataList;
        //}

        /// <summary>
        /// CREATED BY : Sandeep Kumar.
        /// </summary>
        /// <returns></returns>
        public static List<DropDownMDL> FillMonth()
        {
            List<MonthMDL> MonthList = new List<MonthMDL>();

            var months = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames;
            for (int i = 0; i < months.Length - 1; i++)
            {
                MonthMDL objMonthMDL = new MonthMDL();
                objMonthMDL.MonthId = i + 1;
                objMonthMDL.MonthName = months[i];
                MonthList.Add(objMonthMDL);
            }

            List<DropDownMDL> obj = new List<DropDownMDL>();

            foreach (var item in MonthList)
            {
                obj.Add(new DropDownMDL()
                {
                    ID = item.MonthId,
                    Value = item.MonthName
                });
            }
            return obj;
        }

        /// <summary>
        /// CREATED BY : Vinish
        /// CREATED DATE : 05-02-2020
        /// PURPOSE :  Get Port List For Sync Mongo
        /// </summary>
        /// <param name="_PortList"></param>
        /// <returns></returns>
        //public static List<VehiclePortMappingMDL> GetPortList(out List<VehiclePortMappingMDL> _PortList, Int64 PK_Map_VehiclePortId, Int64 AccountId, Int64 UserId, Int64 CustomerId, string LoginType)
        //{
        //    _PortList = new List<VehiclePortMappingMDL>();

        //    try
        //    {
        //        DataSet objDataSet = new DataSet();

        //        List<SqlParameter> parms = new List<SqlParameter>
        //        {

        //            new SqlParameter("@iPK_Map_VehiclePortId",PK_Map_VehiclePortId),
        //            new SqlParameter("@iFK_AccountId",AccountId),
        //            new SqlParameter("@iFK_UserId",UserId),
        //            new SqlParameter("@iFK_CustomerId",CustomerId),
        //            new SqlParameter("@cLoginType",LoginType)
        //        };

        //        CheckParameters.ConvertNullToDBNull(parms);
        //        CommandText = "[dbo].[USP_GetportsByAccountId]";
        //        objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
        //        if (objDataSet.Tables[1].Rows.Count > 0)
        //        {
        //            _PortList = objDataSet.Tables[1].AsEnumerable().Select(dr => new VehiclePortMappingMDL()
        //            {
        //                PKPortId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_PortId")),
        //                PortName = dr.Field<string>("PortName"),
        //                PortIP = dr.Field<string>("PortIP"),
        //                PacketType = dr.Field<string>("PacketType"),
        //                Port = dr.Field<string>("Port"),

        //            }).ToList();
        //        }
        //    }

        //    catch (Exception ex)
        //    {
        //        var objBase = System.Reflection.MethodBase.GetCurrentMethod();
        //        ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
        //    }
        //    return _PortList;
        //}



        /// <summary>
        /// CREATED BY Vinish :: 10 FEB 2020
        /// PURPOSE: TO GET USERNAME & PASSWORD BY USER ID
        /// </summary>
        /// <param name="UserID">USER ID TO GET IT's USERNAME & PASSWORD</param>
        /// <param name="Username">OUT PUT PARAMETER FOR USERNAME</param>
        /// <param name="Password">OUT PUT PARAMETER FOR PASSWORD</param>
        /// <param name="UserEmail">OUT PUT PARAMETER FOR User Email</param>
        /// <returns>SUCCESS IF FOUND & ERROR IF NOT FOUND OR EXCEPTION RAISED</returns>
        public static string GetUserCredentialsByUserId(Int64 UserID, out string Username, out string Password, out string UserEmail)
        {
            Username = string.Empty;
            Password = string.Empty;
            UserEmail = string.Empty;

            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@iUserID",UserID),
                };

                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[Usp_GetUserCredentialsByUserId]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables != null && objDataSet.Tables.Count > 1 && objDataSet.Tables[1].Rows.Count > 0)
                {
                    DataRow dr = objDataSet.Tables[1].Rows[0];

                    Username = dr.Field<string>("Username");
                    Password = Utility.ClsCrypto.Decrypt(dr.Field<string>("Password"));
                    UserEmail = dr.Field<string>("UserEmail");

                    return "SUCCESS";
                }
                else
                {
                    return "ERROR";
                }
            }

            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
                return "ERROR";
            }
        }


        /// <summary>
        /// CREATED BY : Vinish 
        /// CREATED DATE : 11 Feb 2020
        /// PURPOSE :   Get All User List 
        /// </summary>
        /// <param name="loginType"></param>
        /// <returns></returns>
        public static List<MstUserMDL> GetAllLoginTypeUser(string loginType = "")
        {
            List<MstUserMDL> userList = new List<MstUserMDL>();
            try
            {
                DataSet objDataSet = new DataSet();
                List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@cLoginType",loginType)
                };

                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_GetAllLoginTypeUser]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    userList = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstUserMDL()
                    {
                        Pk_UserId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_UserId")),
                        UserName = dr.Field<string>("UserName"),
                        FK_CustomerId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CustomerId")),
                    }).ToList();
                }
            }

            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return userList;
        }

        /// <summary>
        /// CREATED BY : Vinish 
        /// CREATED DATE : 11 Feb 2020
        /// PURPOSE :   Get Group Name List
        /// </summary>
        /// <param name="customerId"></param>
        /// <returns></returns>

        public static List<DropDownMDL> GetGroupNameList(Int64 customerId = 0)
        {
            List<DropDownMDL> groupList = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();
                List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@iFk_CustomerID",customerId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_GetGroupName]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    groupList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        Value = dr.Field<string>("GroupName")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return groupList;
        }


        /// <summary>
        /// CREATED BY : Vinish 
        /// CREATED DATE : 11 Feb 2020
        /// PURPOSE :   Get All  Vechile List 
        /// </summary>
        /// <param name="customerID"></param>
        /// <param name="groupName"></param>
        /// <returns></returns>
        //public static List<VehicleGroupSettingMDL> GetGroupVehicleListGroupName(Int64 customerID = 0, string groupName = "")
        //{
        //    List<VehicleGroupSettingMDL> vehicleGroupSettingList = new List<VehicleGroupSettingMDL>();
        //    try
        //    {
        //        DataSet objDataSet = new DataSet();
        //        List<SqlParameter> parms = new List<SqlParameter>
        //        {
        //            new SqlParameter("@iFk_CustomerID",customerID),
        //            new SqlParameter("@cGroupName",groupName),
        //        };

        //        CheckParameters.ConvertNullToDBNull(parms);
        //        CommandText = "[dbo].[USP_GetGroupVehicleListGroupName]";
        //        objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
        //        if (objDataSet.Tables[1].Rows.Count > 0)
        //        {
        //            vehicleGroupSettingList = objDataSet.Tables[1].AsEnumerable().Select(dr => new VehicleGroupSettingMDL()
        //            {
        //                FK_MachineId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_VehicleId")),
        //                RegistrationNo = dr.Field<string>("RegistrationNo"),
        //                GroupName = dr.Field<string>("GroupName")
        //            }).ToList();
        //        }
        //    }

        //    catch (Exception ex)
        //    {
        //        var objBase = System.Reflection.MethodBase.GetCurrentMethod();
        //        ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
        //    }
        //    return vehicleGroupSettingList;
        //}



        /// <summary>
        /// CREATED BY Vinish :: 12 FEB 2020
        /// PURPOSE: LOCK IN TABLE : SHARE DATA
        /// </summary>      
        /// <returns>URL & TOKEN NO.</returns>
        //public static bool AddSharedRide(ShareFromWebMDL _SharedMDL, out List<TokenDetailForWebMDL> _TokenDetailList, out string Message, out int status)
        //{
        //    bool result = false;
        //    Message = string.Empty;
        //    status = 0;
        //    int Min = Convert.ToInt32((_SharedMDL.Hours * 60) + (_SharedMDL.Minutes));
        //    _TokenDetailList = new List<TokenDetailForWebMDL>();
        //    _commandText = "[dbo].[USP_SaveAndGenerateTokenForWeb]";
        //    List<SqlParameter> parms = new List<SqlParameter>
        //        {

        //            new SqlParameter("@iVehicleId",_SharedMDL.VehicleId),
        //            new SqlParameter("@cRegNo",_SharedMDL.VehicleNo),
        //            new SqlParameter("@iMinutes",Min),
        //             new SqlParameter("@iUserId",_SharedMDL.userid)
        //        };
        //    try
        //    {
        //        CheckParameters.ConvertNullToDBNull(parms);
        //        objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
        //        if (objDataSet.Tables[0].Rows.Count > 0)
        //        {
        //            if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
        //            {
        //                Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
        //                result = true;
        //                status = objDataSet.Tables[0].Rows[0].Field<int>("status");

        //                _TokenDetailList = objDataSet.Tables[1].AsEnumerable().Select(dr => new TokenDetailForWebMDL()
        //                {
        //                    TokenNo = dr.Field<string>("TokenNo"),
        //                    Url = dr.Field<string>("URL")
        //                }).ToList();
        //            }
        //            else
        //            {
        //                Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
        //                status = objDataSet.Tables[0].Rows[0].Field<int>("status");
        //                result = false;
        //            }
        //        }
        //        else
        //        {
        //            Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
        //            status = objDataSet.Tables[0].Rows[0].Field<int>("status");
        //            result = false;
        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        Message = "Failed";
        //        result = false;
        //    }
        //    return result;
        //}

        /// <summary>
        /// CREATED BY : Vinish
        /// CREATED DATE : 24-Feb-2020
        /// PURPOSE :  Get Account Details
        /// </summary>
        /// <returns></returns>
        public static List<DropDownMDL> BindAccountTypeDetails()
        {
            List<DropDownMDL> AccountList = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>
                //{

                //    new SqlParameter("@iPK_Map_VehiclePortId",PK_Map_VehiclePortId),
                //    new SqlParameter("@iFK_AccountId",AccountId),
                //    new SqlParameter("@iFK_UserId",UserId),
                //    new SqlParameter("@iFK_CustomerId",CustomerId),
                //    new SqlParameter("@cLoginType",LoginType)
                //};
                // CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[dbo].[USP_GetAccountTypeDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet);
                if (objDataSet.Tables[1].Rows.Count > 0)
                {
                    AccountList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_CategoryId"),
                        Value = dr.Field<string>("CategoryName")
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return AccountList;
        }

        /// <summary>
        /// CREATED BY : Vinishue
        /// CREATED DATE : 26-Feb-2020
        /// PURPOSE :  Get ALL GEO IDs
        /// </summary>
        /// <returns></returns>
        public static List<DropDownMDL> GetCustomerPOI_IDs_ByCustomerID(Int64 CustomerId)
        {
            List<DropDownMDL> GeoIdList = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iCustomerId",CustomerId)

                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[Usp_GetCustomerPOI_IDs_ByCustomerID]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    GeoIdList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("Pk_GFenceID")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return GeoIdList;
        }

        public static List<DropDownMDL> BindAllCompany(Int64 companyID = 0)
        {
            List<DropDownMDL> CompanyList = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();
                _commandText = "[dbo].[usp_GetAllCompany]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    CompanyList = objDataSet.Tables[1].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_CompanyId"),
                        Value = dr.Field<string>("CompanyName")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return CompanyList;
        }


        //Created By : Vinish
        //Created Datetime : 2020-04-24 13:39:56.427
        public static List<DropDownMDL> BindRolesByCompany(Int64 CompanyId)
        {
            List<DropDownMDL> RoleList = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iFK_CompanyId",CompanyId)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetAllRolesByCompany]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    RoleList = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_RoleId"),
                        Value = dr.Field<string>("RoleName")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return RoleList;
        }


        #region User Panel Common Functions



        public static List<DropDownMDL> FillSiteUserRoles()
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>()
                //{
                //     new SqlParameter("@type",type)

                //};
                //CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetSiteUserRoles]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_RoleId"),
                        Value = dr.Field<string>("RoleName")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }

        public static List<DropDownMDL> FillSiteUserCategory()
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>()
                //{
                //     new SqlParameter("@type",type)

                //};
                //CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetSiteUserCategory]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_CategoryId"),
                        Value = dr.Field<string>("CategoryName")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }

        public static List<DropDownMDL> FillSiteUser()
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>()
                //{
                //     new SqlParameter("@type",type)

                //};
                //CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetSiteUser]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_UserId"),
                        Value = dr.Field<string>("UserName")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }


        public static List<DropDownMDL> GetAcademicGroupList()
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>()
                //{
                //     new SqlParameter("@type",type)

                //};
                //CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetAcademicGroupList]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_AcademicGroupId"),
                        Value = dr.Field<string>("AcademicGroupName")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }


        public static List<DropDownMDL> GetBenifitTypeList()
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>()
                //{
                //     new SqlParameter("@type",type)

                //};
                //CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetBenifitTypeList]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_BenifitTypeId"),
                        Value = dr.Field<string>("BenifitTypeName")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }

        public static List<DropDownMDL> BindAreaOfInterestList(string type = "")
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@type",type)

                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetAllAreaOfInterest]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_AreaOfInterest"),
                        Value = dr.Field<string>("AreaOfInterest")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }


        public static List<DropDownMDL> BindEmployedExpertiseDetailsList(string type = "")
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>()
                //{
                //     new SqlParameter("@type",type)

                //};
                //CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetAllEmployedExpertiseDetailsList]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_EmployedExpertise"),
                        Value = dr.Field<string>("EmployedExpertise")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }



        public static List<DropDownMDL> BindRetiredExpertiseDetailsList(string type = "")
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>()
                //{
                //     new SqlParameter("@type",type)

                //};
                //CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetAllRetiredExpertiseDetailsList]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_RetiredExpertise"),
                        Value = dr.Field<string>("RetiredExpertise")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }


        public static List<DropDownMDL> BindAllStreamsList(Int64 FK_StreamType = 0)
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@FK_StreamType",FK_StreamType)

                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetAllStreams]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_DET_Stream"),
                        Value = dr.Field<string>("StreamCourses")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }

        public static List<DropDownMDL> BindAllStateWiseBoardList(Int64 FK_StateUT = 0)
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@FK_StateUT",FK_StateUT)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetAllStateWiseBoard]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_StateUTBoard"),
                        Value = dr.Field<string>("StateUTBoard")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }


        public static List<DropDownMDL> BindStreamDetailsList()
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>()
                //{
                //     new SqlParameter("@type",type)

                //};
                //CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetAllStreams]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_DET_Stream"),
                        Value = dr.Field<string>("StreamCourses")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }



        public static List<DropDownMDL> BindBoardDetailsList()
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                //List<SqlParameter> parms = new List<SqlParameter>()
                //{
                //     new SqlParameter("@type",type)

                //};
                //CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetAllStateWiseBoard]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<Int64>("PK_StateUTBoard"),
                        Value = dr.Field<string>("StateUTBoard")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }

        public static List<DropDownMDL> BindYearOfPassingList()
        {
            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                int currentyear = DateTime.Now.Year;
                int lessyear = currentyear - 25;
                for (int i = 1; lessyear != currentyear; i++)
                {
                    List.Add(new DropDownMDL()
                    {
                        ID = i,
                        Value = lessyear.ToString()
                    });
                    lessyear++;
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }





        #region GetLanguage Dropdown


        public static List<DropDownMDL> GetLanguage()
        {
            CommandText = "[siteusers].[usp_GetLanguage]";
            SqlParameter param = new SqlParameter();
            param = null;
            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, param);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = dr.Field<int>("ID"),
                Value = dr.Field<string>("LanguageName"),

            }).ToList();
            return _dropdownlist;
        }
        #endregion
        #region GetStream Dropdown


        public static List<DropDownMDL> GetStream(string EducationType)
        {
            CommandText = "[siteusers].[usp_GetStream]";
            SqlParameter param = new SqlParameter()
            {
                ParameterName = "@EducationLevel",
                Value = EducationType

            };
            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, param);
            List<DropDownMDL> _dropdownlist = new List<DropDownMDL>();
            _dropdownlist = ds.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
            {
                ID = dr.Field<int>("ID"),
                Value = dr.Field<string>("StreamName"),

            }).ToList();
            return _dropdownlist;
        }
        #endregion
        #region GetBoardType Dropdown


        public static List<DropDownMDL> GetBoardType()
        {

            List<DropDownMDL> List = new List<DropDownMDL>();
            try
            {
                DataSet objDataSet = new DataSet();

                _commandText = "[SiteUsers].[usp_GetBoardType]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new DropDownMDL()
                    {
                        ID = dr.Field<int>("ID"),
                        Value = dr.Field<string>("BoardName")
                    }).ToList();
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return List;
        }
        #endregion

        #region CheckUserID
        public static bool CheckUserId(string UserID)
        {
            int msg;
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@UserID",UserID),
                };

                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[siteusers].[sp_CheckUserID]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = objDataSet.Tables[0].Rows[0];

                    msg = dr.Field<int>("Message");
                    //return msg;
                    if (msg == 2000)
                    {
                        // return "";
                        return true;
                    }
                    else if (msg == -2000)
                    {
                        // return "UserID already exists";
                        return false;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    return false;
                }
            }

            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
                return false;
            }
        }
        #endregion


        public MessageMDL SiteUserSignUp(SiteUserMDL obj)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@Name", obj.Name),
                    new SqlParameter("@EmailID", obj.EmailID),
                    new SqlParameter("@UserName", obj.UID),
                    new SqlParameter("@UserPassword", ClsCrypto.Encrypt(obj.Password)),
                    new SqlParameter("@AdoptionWish", obj.AdoptionWish),
                    new SqlParameter("@FK_CategoryId", obj.FK_CategoryId),
                    new SqlParameter("@FK_RoleId", obj.FK_RoleId),
                    new SqlParameter("@type", obj.FormType),
                    new SqlParameter("@PK_UserId", obj.Pk_UserId),
                };
                _commandText = "[SiteUsers].[SiteUserSignUp]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //msg.Message = (msg.MessageId == 1)
                    //                   ? @GyanmitrasLanguages.LocalResources.Resource.Deleted
                    //                   : (msg.MessageId == -1)
                    //                     ? @GyanmitrasLanguages.LocalResources.Resource.CustomerData + " " + @GyanmitrasLanguages.LocalResources.Resource.CanNotDelete
                    //                   : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
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


        public MessageMDL GetSiteUserChatDetails(out List<SiteUserChat> _dataList, SiteUserChat obj)
        {
            _dataList = new List<SiteUserChat>();
            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@PK_ChatID", obj.PK_ChatID),
                    new SqlParameter("@Chat_From", obj.Chat_From),
                    new SqlParameter("@Chat_To", obj.Chat_To),
                };
                _commandText = "[SiteUsers].[USP_GetSiteUserChatDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    _dataList = objDataSet.Tables[1].AsEnumerable().Select(dr => new SiteUserChat()
                    {

                        PK_ChatID = dr.Field<Int64>("PK_ChatID"),
                        Chat_From = dr.Field<Int64>("Chat_From"),
                        Chat_To = dr.Field<Int64>("Chat_To"),
                        Query_From  = dr.Field<string>("Query_From"),
                        Query_To  = dr.Field<string>("Query_To"),
                        QueryDateTime_From = dr.Field<string>("QueryDateTime_From"),
                        QueryDateTime_To = dr.Field<string>("QueryDateTime_To"),
                        IsDeleted = dr.Field<bool>("IsDeleted"),
                        DeletedBy = dr.Field<Int64>("DeletedBy"),
                        IsSeen_From = dr.Field<bool>("IsSeen_From"),
                        IsSeen_To = dr.Field<bool>("IsSeen_To"),

                    }).ToList();
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


        public MessageMDL AddEditSiteUserChat(SiteUserChat obj)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@PK_ChatID", obj.PK_ChatID),
                    new SqlParameter("@Chat_From", obj.Chat_From),
                    new SqlParameter("@Chat_To", obj.Chat_To),
                    new SqlParameter("@Query_From", obj.Query_From),
                    new SqlParameter("@Query_To", obj.Query_To),
                    new SqlParameter("@IsDeleted", obj.IsDeleted),
                    new SqlParameter("@DeletedBy", obj.DeletedBy),
                    new SqlParameter("@IsSeen_From", obj.IsSeen_From),
                    new SqlParameter("@IsSeen_To", obj.IsSeen_From),
                    new SqlParameter("@IsReplay", obj.IsReplay),

                };
                _commandText = "[SiteUsers].[USP_AddEditSiteUserChat]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //msg.Message = (msg.MessageId == 1)
                    //                   ? @GyanmitrasLanguages.LocalResources.Resource.Deleted
                    //                   : (msg.MessageId == -1)
                    //                     ? @GyanmitrasLanguages.LocalResources.Resource.CustomerData + " " + @GyanmitrasLanguages.LocalResources.Resource.CanNotDelete
                    //                   : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
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
        /// purpose: Delete Customer Details
        /// </summary>
        public MessageMDL SiteUserActionManagementByUser(Int64 PK_UserId, string type)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@PK_UserId", PK_UserId),
                    new SqlParameter("@type", type)
                };
                _commandText = "[SiteUsers].[SiteUserActionManagementByUser]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //msg.Message = (msg.MessageId == 1)
                    //                   ? @GyanmitrasLanguages.LocalResources.Resource.Deleted
                    //                   : (msg.MessageId == -1)
                    //                     ? @GyanmitrasLanguages.LocalResources.Resource.CustomerData + " " + @GyanmitrasLanguages.LocalResources.Resource.CanNotDelete
                    //                   : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
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


        #endregion



        #region Admin Panel Common Function



        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        public bool GetSiteUserDetails(out dynamic _Datalist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 UserId, string LoginType, int FK_CategoryId, int FK_RoleId, string type = "")
        {
            bool result = false;
            FK_CategoryId = type == "counselor" ? 1 : FK_CategoryId;
            objBasicPagingMDL = new BasicPagingMDL();
            _Datalist = new List<CounselorMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@iPK_Id",id),
                     new SqlParameter("@iPK_UserId",UserId),
                     new SqlParameter("@iRowPerpage",RowPerpage),
                     new SqlParameter("@iCurrentPage",CurrentPage),
                     new SqlParameter("@cSearchBy",SearchBy),
                     new SqlParameter("@cSearchValue",SearchValue),
                     new SqlParameter("@cLoginType",LoginType),
                     new SqlParameter("@iFK_CategoryId",FK_CategoryId),
                     new SqlParameter("@iFK_RoleId",FK_RoleId),

                };
                _commandText = "[SiteUsers].[USP_GetSiteUserDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                FK_CategoryId = type == "counselor" ? 0 : FK_CategoryId;
                if (objDataSet.Tables[0].Rows.Count > 0)
                {

                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        if (FK_CategoryId == 1 || type == "studentGetByVolunteer" || type == "studentGetByCounselor")
                        {
                            #region Student List ...
                            _Datalist = objDataSet.Tables[1].AsEnumerable().Select(dr => new StudentMDL()
                            {
                                PK_StudentID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_ID")),
                                UID = dr.Field<string>("UserName"),
                                Password = ClsCrypto.Decrypt(dr.Field<string>("UserPassword")),
                                Name = dr.Field<string>("Name"),
                                Address = dr.Field<string>("Address"),
                                ZipCode = dr.Field<string>("ZipCode"),
                                EmailID = dr.Field<string>("Email"),
                                MobileNo = dr.Field<string>("Mobile_Number"),
                                AlternateMobileNo = dr.Field<string>("Alternate_Mobile_Number"),
                                AreaOfInterest = dr.Field<string>("FK_AreaOfInterest"),

                                //AreYou = dr.Field<string>("AreYou"),
                                //JoinUsDescription = dr.Field<string>("JoinUsDescription"),
                                HavePC = dr.Field<bool>("HavePC"),
                                Declaration = dr.Field<bool>("Declaration"),

                                languages = dr.Field<string>("FK_LanguageKnown"),
                                IsActive = dr.Field<bool>("IsActive"),
                                IsDeleted = dr.Field<bool>("IsDeleted"),
                                FK_RoleId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_RoleId")),
                                FK_CategoryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CategoryId")),
                                FK_StateId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_StateId")),
                                FK_CityId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CityId")),
                                StateName = dr.Field<string>("StateName"),
                                CityName = dr.Field<string>("CityName"),
                                ImageName = dr.Field<string>("Image"),
                                CreatedDateTime = dr.Field<string>("CreatedDateTime"),
                                CategoryName = dr.Field<string>("CategoryName"),
                                RoleName = dr.Field<string>("RoleName"),
                                IsPendingReplyUsers = dr.Field<bool>("IsPendingReplyUsers"),
                                IsManageCreiticalSupport = dr.Field<bool>("IsManageCreiticalSupport"),
                                IsApprovedCounselor = dr.Field<bool>("IsApprovedCounselor"),
                                IsAdoptedStudent = dr.Field<bool>("IsAdoptedStudent"),
                                MyAdoption = dr.Field<bool>("MyAdoption"),
                                IsMachingStudentsForCounselor = dr.Field<bool>("IsMachingStudentsForCounselor"),
                                AreaOfInterestName = dr.Field<string>("AreaOfInterest"),
                                LanguageKnownName = dr.Field<string>("LanguageKnown"),
                                AdoptionWish = dr.Field<bool>("AdoptionWish"),
                                HaveSmartPhone = dr.Field<bool>("HaveSmartPhone"),
                                EducationDetails = objDataSet.Tables[3].AsEnumerable().Select(e_dr => new SiteUserEducationDetailsMDL()
                                {
                                    ID = e_dr.Field<int>("ID"),
                                    TypeOfEducation = e_dr.Field<string>("Education_Type"),
                                    Class = e_dr.Field<string>("Class"),
                                    FK_BoardID = e_dr.Field<int>("FK_BoardID"),
                                    FK_StreamID = e_dr.Field<int>("FK_BoardID"),
                                    Currentsemester = e_dr.Field<string>("Currentsemester"),
                                    UniversityName = e_dr.Field<string>("UniversityName"),
                                    NatureOFCompletion = e_dr.Field<string>("NatureOFCompletion"),
                                    Percentage = e_dr.Field<decimal>("Percentage"),
                                    Previous_Class = e_dr.Field<string>("Previous_Class"),
                                    FK_Previous_Class_Board = e_dr.Field<int>("FK_Previous_Class_Board"),
                                    Previous_Class_Percentage = e_dr.Field<decimal>("Previous_Class_Percentage"),
                                    Year_of_Passing = e_dr.Field<string>("Year_of_Passing"),
                                    Fk_UserName = e_dr.Field<string>("Fk_UserName"),
                                    CourseName = e_dr.Field<string>("CourseName"),
                                    Specification = e_dr.Field<string>("Specification"),
                                    OtherWork = e_dr.Field<string>("OtherWork"),
                                    BoardName = e_dr.Field<string>("BoardType"),
                                    PreviousClassBoardName = e_dr.Field<string>("PreviousClassBoard"),
                                    StreamName = e_dr.Field<string>("Stream"),
                                }).ToList()

                            }).ToList();
                            #endregion
                        }
                        else if (FK_CategoryId == 2)
                        {
                            #region Counselor List ...
                            _Datalist = objDataSet.Tables[1].AsEnumerable().Select(dr => new CounselorMDL()
                            {
                                PK_CounselorID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_ID")),
                                UID = dr.Field<string>("UserName"),
                                Password = ClsCrypto.Decrypt(dr.Field<string>("UserPassword")),
                                Name = dr.Field<string>("Name"),
                                Address = dr.Field<string>("Address"),
                                ZipCode = Convert.ToString(dr.Field<string>("ZipCode")),
                                EmailID = dr.Field<string>("Email"),
                                MobileNo = dr.Field<string>("Mobile_Number"),
                                AlternateMobileNo = dr.Field<string>("Alternate_Mobile_Number"),
                                AreaOfInterest = dr.Field<string>("FK_AreaOfInterest"),
                                languages = Convert.ToString(dr.Field<string>("FK_LanguageKnown")),
                                AreYou = dr.Field<string>("AreYou"),
                                JoinUsDescription = dr.Field<string>("JoinUsDescription"),
                                HavePC = dr.Field<bool>("HavePC"),
                                Declaration = dr.Field<bool>("Declaration"),
                                //
                                LikeAdoptStudentLater = dr.Field<bool>("LikeAdoptStudentLater"),
                                IsActive = dr.Field<bool>("IsActive"),
                                IsDeleted = dr.Field<bool>("IsDeleted"),
                                FK_CategoryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CategoryId")),
                                FK_RoleId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_RoleId")),
                                FK_StateId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_StateId")),
                                FK_CityId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CityId")),
                                StateName = dr.Field<string>("StateName"),
                                CityName = dr.Field<string>("CityName"),
                                ImageName = dr.Field<string>("Image"),
                                CreatedDateTime = dr.Field<string>("CreatedDateTime"),

                                CategoryName = dr.Field<string>("CategoryName"),
                                RoleName = dr.Field<string>("RoleName"),
                                IsPendingReplyUsers = dr.Field<bool>("IsPendingReplyUsers"),
                                IsManageCreiticalSupport = dr.Field<bool>("IsManageCreiticalSupport"),
                                IsApprovedCounselor = dr.Field<bool>("IsApprovedCounselor"),
                                IsAdoptedStudent = dr.Field<bool>("IsAdoptedStudent"),
                                MyAdoption = dr.Field<bool>("MyAdoption"),
                                AdoptionWish = dr.Field<bool>("AdoptionWish"),
                                HaveSmartPhone = dr.Field<bool>("HaveSmartPhone"),
                                IsMachingStudentsForCounselor = dr.Field<bool>("IsMachingStudentsForCounselor"),
                                AreaOfInterestName = dr.Field<string>("AreaOfInterest"),
                                LanguageKnownName = dr.Field<string>("LanguageKnown"),
                                EducationDetails = objDataSet.Tables[3].AsEnumerable().Select(e_dr => new SiteUserEducationDetailsMDL()
                                {
                                    ID = e_dr.Field<int>("ID"),
                                    TypeOfEducation = e_dr.Field<string>("Education_Type"),
                                    Class = e_dr.Field<string>("Class"),
                                    FK_BoardID = e_dr.Field<int>("FK_BoardID"),
                                    FK_StreamID = e_dr.Field<int>("FK_BoardID"),
                                    Currentsemester = e_dr.Field<string>("Currentsemester"),
                                    UniversityName = e_dr.Field<string>("UniversityName"),
                                    NatureOFCompletion = e_dr.Field<string>("NatureOFCompletion"),
                                    Percentage = e_dr.Field<decimal>("Percentage"),
                                    Previous_Class = e_dr.Field<string>("Previous_Class"),
                                    FK_Previous_Class_Board = e_dr.Field<int>("FK_Previous_Class_Board"),
                                    Previous_Class_Percentage = e_dr.Field<decimal>("Previous_Class_Percentage"),
                                    Year_of_Passing = e_dr.Field<string>("Year_of_Passing"),
                                    Fk_UserName = e_dr.Field<string>("Fk_UserName"),
                                    CourseName = e_dr.Field<string>("CourseName"),
                                    Specification = e_dr.Field<string>("Specification"),
                                    OtherWork = e_dr.Field<string>("OtherWork"),
                                    BoardName = e_dr.Field<string>("BoardType"),
                                    PreviousClassBoardName = e_dr.Field<string>("PreviousClassBoard"),
                                    StreamName = e_dr.Field<string>("Stream"),
                                }).ToList()


                            }).ToList();
                            #endregion
                        }

                        else if (FK_CategoryId == 3)
                        {
                            #region Volunteer List ...
                            _Datalist = objDataSet.Tables[1].AsEnumerable().Select(dr => new VolunteerMDL()
                            {
                                PK_VolunteerId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_ID")),
                                UID = dr.Field<string>("UserName"),
                                Password = ClsCrypto.Decrypt(dr.Field<string>("UserPassword")),
                                Name = dr.Field<string>("Name"),
                                Address = dr.Field<string>("Address"),
                                ZipCode = dr.Field<string>("ZipCode"),
                                EmailID = dr.Field<string>("Email"),
                                MobileNo = dr.Field<string>("Mobile_Number"),
                                AlternateMobileNo = dr.Field<string>("Alternate_Mobile_Number"),
                                //AreaOfInterest = dr.Field<string>("FK_AreaOfInterest"),
                                //AreYou = dr.Field<string>("AreYou"),
                                //JoinUsDescription = dr.Field<string>("JoinUsDescription"),
                                //HavePC = dr.Field<bool>("HavePC"),
                                Declaration = dr.Field<bool>("Declaration"),
                                //
                                //LikeAdoptStudentLater = dr.Field<bool>("LikeAdoptStudentLater"),
                                IsActive = dr.Field<bool>("IsActive"),
                                IsDeleted = dr.Field<bool>("IsDeleted"),
                                FK_CategoryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CategoryId")),
                                FK_RoleId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_RoleId")),
                                FK_StateId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_StateId")),
                                FK_CityId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CityId")),
                                FK_State_AreaOfSearch = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_AreaOfInterestStateId")),
                                FK_District_AreaOfSearch = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_AreaOfInterestDistrictId")),
                                StateName = dr.Field<string>("StateName"),
                                CityName = dr.Field<string>("CityName"),
                                ImageName = dr.Field<string>("Image"),
                                CreatedDateTime = dr.Field<string>("CreatedDateTime"),
                                CategoryName = dr.Field<string>("CategoryName"),
                                RoleName = dr.Field<string>("RoleName"),

                                IsPendingReplyUsers = dr.Field<bool>("IsPendingReplyUsers"),
                                IsManageCreiticalSupport = dr.Field<bool>("IsManageCreiticalSupport"),
                                IsAdoptedStudent = dr.Field<bool>("IsAdoptedStudent"),
                                IsApprovedCounselor = dr.Field<bool>("IsApprovedCounselor"),
                                MyAdoption = dr.Field<bool>("MyAdoption"),
                                AdoptionWish = dr.Field<bool>("AdoptionWish"),
                                HaveSmartPhone = dr.Field<bool>("HaveSmartPhone"),
                                IsMachingStudentsForCounselor = dr.Field<bool>("IsMachingStudentsForCounselor"),
                                AreaOfInterestName = dr.Field<string>("AreaOfInterest"),
                                LanguageKnownName = dr.Field<string>("LanguageKnown"),
                                EducationDetails = objDataSet.Tables[3].AsEnumerable().Select(e_dr => new SiteUserEducationDetailsMDL()
                                {
                                    ID = e_dr.Field<int>("ID"),
                                    TypeOfEducation = e_dr.Field<string>("Education_Type"),
                                    Class = e_dr.Field<string>("Class"),
                                    FK_BoardID = e_dr.Field<int>("FK_BoardID"),
                                    FK_StreamID = e_dr.Field<int>("FK_BoardID"),
                                    Currentsemester = e_dr.Field<string>("Currentsemester"),
                                    UniversityName = e_dr.Field<string>("UniversityName"),
                                    NatureOFCompletion = e_dr.Field<string>("NatureOFCompletion"),
                                    Percentage = e_dr.Field<decimal>("Percentage"),
                                    Previous_Class = e_dr.Field<string>("Previous_Class"),
                                    FK_Previous_Class_Board = e_dr.Field<int>("FK_Previous_Class_Board"),
                                    Previous_Class_Percentage = e_dr.Field<decimal>("Previous_Class_Percentage"),
                                    Year_of_Passing = e_dr.Field<string>("Year_of_Passing"),
                                    Fk_UserName = e_dr.Field<string>("Fk_UserName"),
                                    CourseName = e_dr.Field<string>("CourseName"),
                                    Specification = e_dr.Field<string>("Specification"),
                                    OtherWork = e_dr.Field<string>("OtherWork"),
                                    BoardName = e_dr.Field<string>("BoardType"),
                                    PreviousClassBoardName = e_dr.Field<string>("PreviousClassBoard"),
                                    StreamName = e_dr.Field<string>("Stream"),
                                }).ToList()

                            }).ToList();
                            #endregion
                        }
                        else
                        {
                            #region SiteUser List ...
                            _Datalist = objDataSet.Tables[1].AsEnumerable().Select(dr => new SiteUserMDL()
                            {
                                Pk_UserId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_ID")),
                                UID = dr.Field<string>("UserName"),
                                Password = ClsCrypto.Decrypt(dr.Field<string>("UserPassword")),
                                Name = dr.Field<string>("Name"),
                                Address = dr.Field<string>("Address"),
                                ZipCode = dr.Field<string>("ZipCode"),
                                EmailID = dr.Field<string>("Email"),
                                MobileNo = dr.Field<string>("Mobile_Number"),
                                AlternateMobileNo = dr.Field<string>("Alternate_Mobile_Number"),
                                AreaOfInterest = dr.Field<string>("FK_AreaOfInterest"),
                                languages = dr.Field<string>("FK_LanguageKnown"),
                                //AreYou = dr.Field<string>("AreYou"),
                                //JoinUsDescription = dr.Field<string>("JoinUsDescription"),
                                HavePC = dr.Field<bool>("HavePC"),
                                Declaration = dr.Field<bool>("Declaration"),
                                //
                                //LikeAdoptStudentLater = dr.Field<bool>("LikeAdoptStudentLater"),
                                IsActive = dr.Field<bool>("IsActive"),
                                IsDeleted = dr.Field<bool>("IsDeleted"),
                                FK_CategoryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CategoryId")),
                                FK_RoleId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_RoleId")),
                                FK_StateId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_StateId")),
                                FK_CityId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CityId")),
                                FK_AreaOfInterestStateId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_AreaOfInterestStateId")),
                                FK_AreaOfInterestDistrictId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_AreaOfInterestDistrictId")),
                                StateName = dr.Field<string>("StateName"),
                                CityName = dr.Field<string>("CityName"),
                                ImageName = dr.Field<string>("Image"),
                                CreatedDateTime = dr.Field<string>("CreatedDateTime"),
                                CategoryName = dr.Field<string>("CategoryName"),
                                RoleName = dr.Field<string>("RoleName"),
                                IsPendingReplyUsers = dr.Field<bool>("IsPendingReplyUsers"),
                                IsManageCreiticalSupport = dr.Field<bool>("IsManageCreiticalSupport"),
                                IsApprovedCounselor = dr.Field<bool>("IsApprovedCounselor"),
                                IsAdoptedStudent = dr.Field<bool>("IsAdoptedStudent"),
                                MyAdoption = dr.Field<bool>("MyAdoption"),
                                AdoptionWish = dr.Field<bool>("AdoptionWish") ? "True" : "False",
                                HaveSmartPhone = dr.Field<bool>("HaveSmartPhone") ? "True" : "False",
                                IsMachingStudentsForCounselor = dr.Field<bool>("IsMachingStudentsForCounselor"),
                                AreaOfInterestName = dr.Field<string>("AreaOfInterest"),
                                LanguageKnownName = dr.Field<string>("LanguageKnown"),
                                EducationDetails = objDataSet.Tables[3].AsEnumerable().Select(e_dr => new SiteUserEducationDetailsMDL()
                                {
                                    ID = e_dr.Field<int>("ID"),
                                    TypeOfEducation = e_dr.Field<string>("Education_Type"),
                                    Class = e_dr.Field<string>("Class"),
                                    FK_BoardID = e_dr.Field<int>("FK_BoardID"),
                                    FK_StreamID = e_dr.Field<int>("FK_BoardID"),
                                    Currentsemester = e_dr.Field<string>("Currentsemester"),
                                    UniversityName = e_dr.Field<string>("UniversityName"),
                                    NatureOFCompletion = e_dr.Field<string>("NatureOFCompletion"),
                                    Percentage = e_dr.Field<decimal>("Percentage"),
                                    Previous_Class = e_dr.Field<string>("Previous_Class"),
                                    FK_Previous_Class_Board = e_dr.Field<int>("FK_Previous_Class_Board"),
                                    Previous_Class_Percentage = e_dr.Field<decimal>("Previous_Class_Percentage"),
                                    Year_of_Passing = e_dr.Field<string>("Year_of_Passing"),
                                    Fk_UserName = e_dr.Field<string>("Fk_UserName"),
                                    CourseName = e_dr.Field<string>("CourseName"),
                                    Specification = e_dr.Field<string>("Specification"),
                                    OtherWork = e_dr.Field<string>("OtherWork"),
                                    BoardName = e_dr.Field<string>("BoardType"),
                                    PreviousClassBoardName = e_dr.Field<string>("PreviousClassBoard"),
                                    StreamName = e_dr.Field<string>("Stream"),
                                }).ToList()


                            }).ToList();
                            #endregion
                        }



                        objBasicPagingMDL = new BasicPagingMDL() { CurrentPage = 1, RowParPage = 10, TotalItem = 0, TotalPage = 0 };


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
                    #region User Total...
                    objTotalCountPagingMDL = new TotalCountPagingMDL()
                    {
                        TotalItem = objDataSet.Tables[2].Rows[0].Field<int>("TotalItem"),
                        TotalActive = objDataSet.Tables[2].Rows[0].Field<int>("TotalActive"),
                        TotalInactive = objDataSet.Tables[2].Rows[0].Field<int>("TotalInActive"),
                        ThisMonth = objDataSet.Tables[2].Rows[0].Field<int>("TotalCurrentMonth"),
                        ApprovedCounselor = objDataSet.Tables[2].Rows[0].Field<int>("ApprovedCounselor"),
                        LastMonth = objDataSet.Tables[2].Rows[0].Field<int>("LastMonth"),
                        TotalExpiredMonth = objDataSet.Tables[2].Rows[0].Field<int>("TotalExpiredMonth"),
                        RemovedUsers = objDataSet.Tables[2].Rows[0].Field<int>("RemovedUsers"),
                        PendingReplyUsers = objDataSet.Tables[2].Rows[0].Field<int>("PendingReplyUsers"),
                        ManageCreiticalSupport = objDataSet.Tables[2].Rows[0].Field<int>("ManageCreiticalSupport"),
                        AdoptedStudent = objDataSet.Tables[2].Rows[0].Field<int>("AdoptedStudent"),
                        PendingAdoptedStudent = objDataSet.Tables[2].Rows[0].Field<int>("PendingAdoptedStudent"),
                        TotalAdoptedStudentByCounselor = objDataSet.Tables[2].Rows[0].Field<int>("TotalAdoptedStudentByCounselor"),


                        //Display Cards
                        IsTotalItem = objDataSet.Tables[2].Rows[0].Field<bool>("IsTotalItem"),
                        IsTotalActive = objDataSet.Tables[2].Rows[0].Field<bool>("IsTotalActive"),
                        IsTotalInactive = objDataSet.Tables[2].Rows[0].Field<bool>("IsTotalInactive"),
                        IsThisMonth = objDataSet.Tables[2].Rows[0].Field<bool>("IsThisMonth"),
                        IsApprovedCounselor = objDataSet.Tables[2].Rows[0].Field<bool>("IsApprovedCounselor"),
                        IsLastMonth = objDataSet.Tables[2].Rows[0].Field<bool>("IsLastMonth"),
                        IsTotalExpiredMonth = objDataSet.Tables[2].Rows[0].Field<bool>("IsTotalExpiredMonth"),
                        IsManageFeedBack = objDataSet.Tables[2].Rows[0].Field<bool>("IsManageFeedBack"),
                        IsNotSuperAdmin = objDataSet.Tables[2].Rows[0].Field<bool>("IsNotSuperAdmin"),
                        IsManageCreiticalSupport = objDataSet.Tables[2].Rows[0].Field<bool>("IsManageCreiticalSupport"),
                        IsPendingReplyUsers = objDataSet.Tables[2].Rows[0].Field<bool>("IsPendingReplyUsers"),
                        IsRemovedUsers = objDataSet.Tables[2].Rows[0].Field<bool>("IsRemovedUsers"),

                    };
                    #endregion
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
        /// purpose: Delete Customer Details
        /// </summary>
        public MessageMDL DeleteSiteUser(Int64 PK_CustomerId, Int64 UserId, bool recover = false)

        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@iPK_Id", PK_CustomerId),
                new SqlParameter("@iUserId", UserId),
                new SqlParameter("@recover", recover),

                };
                _commandText = "[SiteUsers].[USP_SiteUserDeleteUser]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //msg.Message = (msg.MessageId == 1)
                    //                   ? @GyanmitrasLanguages.LocalResources.Resource.Deleted
                    //                   : (msg.MessageId == -1)
                    //                     ? @GyanmitrasLanguages.LocalResources.Resource.CustomerData + " " + @GyanmitrasLanguages.LocalResources.Resource.CanNotDelete
                    //                   : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
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
        /// purpose: Delete Customer Details
        /// </summary>
        public MessageMDL SiteUserActionManagementByAdmin(Int64 PK_Id, Int64 UserId, string type)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iPK_Id", PK_Id),
                    new SqlParameter("@iUserId", UserId),
                    new SqlParameter("@type", type)
                };
                _commandText = "[SiteUsers].[SiteUserActionManagementByAdmin]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //msg.Message = (msg.MessageId == 1)
                    //                   ? @GyanmitrasLanguages.LocalResources.Resource.Deleted
                    //                   : (msg.MessageId == -1)
                    //                     ? @GyanmitrasLanguages.LocalResources.Resource.CustomerData + " " + @GyanmitrasLanguages.LocalResources.Resource.CanNotDelete
                    //                   : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
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
        /// purpose: Delete Customer Details
        /// </summary>
        /// 
        public MessageMDL AddEditSiteUsers(StudentMDL objStudent = null, CounselorMDL objCounselor = null, VolunteerMDL objVolunteer = null)
        {

            MessageMDL msg = new MessageMDL();
            #region Education Details...
            DataTable dt = new DataTable();
            dt.Columns.Add("FK_UserID");
            dt.Columns.Add("Education_Type");
            dt.Columns.Add("Class");
            dt.Columns.Add("FK_BoardID");
            dt.Columns.Add("FK_StreamID");
            dt.Columns.Add("Currentsemester");
            dt.Columns.Add("UniversityName");
            dt.Columns.Add("NatureOFCompletion");
            dt.Columns.Add("Percentage");
            dt.Columns.Add("Previous_Class");
            dt.Columns.Add("FK_Previous_Class_Board");
            dt.Columns.Add("Previous_Class_Percentage");
            dt.Columns.Add("Year_of_Passing");
            dt.Columns.Add("OtherWork");
            dt.Columns.Add("Specification");
            dt.Columns.Add("CourseName");
            if (objStudent != null || objCounselor != null)
            {
                List<SiteUserEducationDetailsMDL> objStudentEducationDetails = objStudent != null ? objStudent.EducationDetails :
                                                                                (objCounselor != null ? objCounselor.EducationDetails : null);

                if (objStudentEducationDetails == null)
                {
                    dt.Rows.Add(
                   0,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value,
                   DBNull.Value
                   );
                }
                else
                {
                    for (int i = 0; i < objStudentEducationDetails.Count; i++)
                    {
                        dt.Rows.Add(
                               objStudent == null ? objCounselor.PK_CounselorID : objStudent.PK_StudentID,
                               objStudentEducationDetails[i].TypeOfEducation,
                               objStudentEducationDetails[i].Class,
                               objStudentEducationDetails[i].FK_BoardID,
                               objStudentEducationDetails[i].FK_StreamID,
                               objStudentEducationDetails[i].Currentsemester,
                               objStudentEducationDetails[i].UniversityName,
                               objStudentEducationDetails[i].UniversityName,
                               objStudentEducationDetails[i].Percentage,
                               objStudentEducationDetails[i].Previous_Class,
                               objStudentEducationDetails[i].FK_Previous_Class_Board,
                               objStudentEducationDetails[i].Previous_Class_Percentage,
                               objStudentEducationDetails[i].Year_of_Passing,
                               objStudentEducationDetails[i].OtherWork,
                               objStudentEducationDetails[i].Specification,
                               objStudentEducationDetails[i].CourseName
                               );
                    }
                }
            }
            else if (objVolunteer != null)
            {
                dt.Rows.Add(
                      objVolunteer.PK_VolunteerId,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value,
                      DBNull.Value
                      );
            }
            #endregion
            try
            {
                List<SqlParameter> parms = null;
                if (objStudent != null)
                {
                    #region objStudent Parameters...
                    parms = new List<SqlParameter>(){
                    new SqlParameter("@PK_UserId                         ", objStudent.PK_StudentID                         ),
                    new SqlParameter("@UserName                          ", objStudent.UID                               ),
                    new SqlParameter("@FK_CategoryId                     ", objStudent.FK_CategoryId                     ),
                    new SqlParameter("@FK_RoleId                         ", objStudent.FK_RoleId                         ),
                    new SqlParameter("@UserPassword                      ", ClsCrypto.Encrypt(objStudent.Password)       ),
                    new SqlParameter("@IsActive                          ", objStudent.IsActive                          ),
                    new SqlParameter("@IsDeleted                         ", objStudent.IsDeleted                         ),
                    new SqlParameter("@CreatedBy                         ", objStudent.CreatedBy                         ),
                    new SqlParameter("@UpdatedBy                         ", objStudent.UpdatedBy                         ),
                    new SqlParameter("@Name                              ", objStudent.Name                              ),
                    new SqlParameter("@Mobile_Number                     ", objStudent.MobileNo),
                    new SqlParameter("@Alternate_Mobile_Number           ", objStudent.AlternateMobileNo          ),
                    new SqlParameter("@Address                           ", objStudent.Address                           ),
                    new SqlParameter("@Zipcode                           ", objStudent.ZipCode                           ),
                    new SqlParameter("@FK_StateID                        ", objStudent.FK_StateId                        ),
                    new SqlParameter("@FK_CityID                         ", objStudent.FK_CityId                         ),
                    new SqlParameter("@FK_LanguageKnown                  ", objStudent.languages                  ),
                    new SqlParameter("@FK_AreaOfInterest                 ", objStudent.AreaOfInterest                 ),
                    new SqlParameter("@Image                             ", objStudent.ImageName                             ),
                    new SqlParameter("@HaveSmartPhone                    ", objStudent.HaveSmartPhone                    ),
                    new SqlParameter("@HavePC                            ", objStudent.HavePC                            ),
                    new SqlParameter("@AdoptionWish                      ", objStudent.AdoptionWish                      ),
                    new SqlParameter("@Email                             ", objStudent.EmailID                             ),
                    new SqlParameter("@Fk_AreaOfInterest_State           ", objStudent.FK_AreaOfInterestStateId           ),
                    new SqlParameter("@Fk_AreaOfInterest_District        ", objStudent.FK_AreaOfInterestDistrictId        ),
                    //new SqlParameter("@AreYou                            ", objStudent.AreYou                            ),
                    //new SqlParameter("@JoinUsDescription                 ", objStudent.JoinUsDescription                 ),
                    new SqlParameter("@Declaration                       ", objStudent.Declaration                       ),
                    //new SqlParameter("@LikeAdoptStudentLater             ", objStudent.LikeAdoptStudentLater             ),
                    //new SqlParameter("@Retired_expertise                 ", objStudent.Retired_Expertise_Details                 ),
                    //new SqlParameter("@Employed_expertise                ", objStudent.Secondry_Education_Board                ),

                    new SqlParameter("@AcademicDetails",dt),
                    };
                    #endregion
                }
                else if (objVolunteer != null)
                {
                    #region objVolunteer Parameters...
                    parms = new List<SqlParameter>(){
                    new SqlParameter("@PK_UserId                         ", objVolunteer.PK_VolunteerId                         ),
                    new SqlParameter("@UserName                          ", objVolunteer.UID                               ),
                    new SqlParameter("@FK_CategoryId                     ", objVolunteer.FK_CategoryId                     ),
                    new SqlParameter("@FK_RoleId                         ", objVolunteer.FK_RoleId                         ),
                    new SqlParameter("@UserPassword                      ", ClsCrypto.Encrypt(objVolunteer.Password)       ),
                    new SqlParameter("@IsActive                          ", objVolunteer.IsActive                          ),
                    new SqlParameter("@IsDeleted                         ", objVolunteer.IsDeleted                         ),
                    new SqlParameter("@CreatedBy                         ", objVolunteer.CreatedBy                         ),
                    new SqlParameter("@UpdatedBy                         ", objVolunteer.UpdatedBy                         ),
                    new SqlParameter("@Name                              ", objVolunteer.Name                              ),
                    new SqlParameter("@Mobile_Number                     ", objVolunteer.MobileNo),
                    new SqlParameter("@Alternate_Mobile_Number           ", objVolunteer.AlternateMobileNo          ),
                    new SqlParameter("@Address                           ", objVolunteer.Address                           ),
                    new SqlParameter("@Zipcode                           ", objVolunteer.ZipCode                           ),
                    new SqlParameter("@FK_StateID                        ", objVolunteer.FK_StateId                        ),
                    new SqlParameter("@FK_CityID                         ", objVolunteer.FK_CityId                         ),
                    //new SqlParameter("@FK_LanguageKnown                  ", objVolunteer.languages                  ),
                    //new SqlParameter("@FK_AreaOfInterest                 ", objVolunteer.AreaOfInterest                 ),
                    new SqlParameter("@Image                             ", objVolunteer.ImageName                             ),
                    new SqlParameter("@HaveSmartPhone                    ", objVolunteer.HaveSmartPhone                    ),
                    //new SqlParameter("@HavePC                            ", objVolunteer.HavePC                            ),
                    new SqlParameter("@AdoptionWish                      ", objVolunteer.AdoptionWish                      ),
                    new SqlParameter("@Email                             ", objVolunteer.EmailID                             ),
                    new SqlParameter("@Fk_AreaOfInterest_State           ", objVolunteer.FK_State_AreaOfSearch           ),
                    new SqlParameter("@Fk_AreaOfInterest_District        ", objVolunteer.FK_District_AreaOfSearch        ),
                    //new SqlParameter("@AreYou                            ", objVolunteer.AreYou                            ),
                    //new SqlParameter("@JoinUsDescription                 ", objVolunteer.JoinUsDescription                 ),
                    new SqlParameter("@Declaration                       ", objVolunteer.Declaration                       ),
                    //new SqlParameter("@LikeAdoptStudentLater             ", objVolunteer.LikeAdoptStudentLater             ),
                    //new SqlParameter("@Retired_expertise                 ", objVolunteer.Retired_Expertise_Details                 ),
                    //new SqlParameter("@Employed_expertise                ", objVolunteer.Secondry_Education_Board                ),

                    new SqlParameter("@AcademicDetails",dt),
                    };
                    #endregion
                }
                else if (objCounselor != null)
                {
                    #region objCounselor Parameters...
                    parms = new List<SqlParameter>(){
                    new SqlParameter("@PK_UserId                         ", objCounselor.PK_CounselorID                         ),
                    new SqlParameter("@UserName                          ", objCounselor.UID                               ),
                    new SqlParameter("@FK_CategoryId                     ", objCounselor.FK_CategoryId                     ),
                    new SqlParameter("@FK_RoleId                         ", objCounselor.FK_RoleId                         ),
                    new SqlParameter("@UserPassword                      ", ClsCrypto.Encrypt(objCounselor.Password)       ),
                    new SqlParameter("@IsActive                          ", objCounselor.IsActive                          ),
                    new SqlParameter("@IsDeleted                         ", objCounselor.IsDeleted                         ),
                    new SqlParameter("@CreatedBy                         ", objCounselor.CreatedBy                         ),
                    new SqlParameter("@Name                              ", objCounselor.Name                              ),
                    new SqlParameter("@Mobile_Number                     ", objCounselor.MobileNo),
                    new SqlParameter("@Alternate_Mobile_Number           ", objCounselor.AlternateMobileNo          ),
                    new SqlParameter("@Address                           ", objCounselor.Address                           ),
                    new SqlParameter("@Zipcode                           ", objCounselor.ZipCode                           ),
                    new SqlParameter("@FK_StateID                        ", objCounselor.FK_StateId                        ),
                    new SqlParameter("@FK_CityID                         ", objCounselor.FK_CityId                         ),
                    new SqlParameter("@FK_LanguageKnown                  ", objCounselor.languages                  ),
                    new SqlParameter("@FK_AreaOfInterest                 ", objCounselor.AreaOfInterest                 ),
                    new SqlParameter("@Image                             ", objCounselor.ImageName                             ),
                    new SqlParameter("@HaveSmartPhone                    ", objCounselor.HaveSmartPhone                    ),
                    new SqlParameter("@HavePC                            ", objCounselor.HavePC                            ),
                    new SqlParameter("@AdoptionWish                      ", objCounselor.AdoptionWish                      ),
                    new SqlParameter("@Email                             ", objCounselor.EmailID                             ),
                    new SqlParameter("@Fk_AreaOfInterest_State           ", objCounselor.FK_AreaOfInterestStateId           ),
                    new SqlParameter("@Fk_AreaOfInterest_District        ", objCounselor.FK_AreaOfInterestDistrictId        ),
                    new SqlParameter("@AreYou                            ", objCounselor.AreYou                            ),
                    new SqlParameter("@JoinUsDescription                 ", objCounselor.JoinUsDescription                 ),
                    new SqlParameter("@Declaration                       ", objCounselor.Declaration                       ),
                    new SqlParameter("@LikeAdoptStudentLater             ", objCounselor.LikeAdoptStudentLater             ),
                    new SqlParameter("@Retired_expertise                 ", objCounselor.Retired_Expertise_Details                 ),
                    new SqlParameter("@Employed_expertise                ", objCounselor.Secondry_Education_Board                ),

                    new SqlParameter("@AcademicDetails",dt),
                    };
                    #endregion
                }
                _commandText = "[SiteUsers].[USP_AddEditSiteUser]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    if (objDataSet.Tables.Count > 1)
                    {
                        msg.ReturnInfo = objDataSet.Tables[1].Rows[0].Field<Int64>("NewlyAddedUserId");
                    }
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



        #endregion
    }

}
