using GyanmitrasDAL.Common;
using GyanmitrasDAL.User;
using GyanmitrasMDL;
using GyanmitrasMDL.User;
using System;
using System.Collections.Generic;

namespace GyanmitrasBAL.Common
{
    public class CommonBAL
    {
        #region BIND CUSTOMERS
        public static List<DropDownMDL> BindCustomer()
        {
            return CommonDAL.BindCustomer();
        }
        public static List<DropDownMDL> BindCustomerByAccount(Int64 AccountId = 0, Int64 CustomerId = 0, Int64 ParentCustomerId = 0, Int64 CategoryId = 0, Int64 RoleId = 0, string LoginType = "", string CustomerName = "", string MobileNo = "", string EmailId = "",
            string ZipCode = "", Int64 UserId = 0)
        {
            return CommonDAL.BindCustomerByAccount(AccountId, CustomerId, ParentCustomerId, CategoryId, RoleId, LoginType, CustomerName, MobileNo, EmailId, ZipCode, UserId);
        }
        public static List<DropDownMDL> BindCustomerByAccountCustomerIdLoginType(Int64 AccountId, Int64 UserId, Int64 CustomerId, string LoginType, string CustomerName)
        {
            return CommonDAL.BindCustomerByAccountCustomerIdLoginType(AccountId, UserId, CustomerId, LoginType, CustomerName);
        }

        #endregion
        public static List<DropDownMDL> GetAccountListByCategoryIdLoginType(Int64 AccountId, Int64 UserId, Int64 CustomerId, string LoginType, Int64 CategoryId)
        {
            return CommonDAL.GetAccountListByCategoryIdLoginType(AccountId, UserId, CustomerId, LoginType, CategoryId);
        }

        #region CountryStateCity
        public static List<DropDownMDL> GetCountryList()
        {
            return CommonDAL.GetCountryList();
        }
        public static List<DropDownMDL> BindCustomerType()
        {
            return CommonDAL.BindCustomerType();
        }


        public static List<DropDownMDL> GetStateDetailsByCountryId(int countryId)
        {
            return CommonDAL.GetStateDetailsByCountryId(countryId);
        }
        public static List<DropDownMDL> GetCityDetailsByStateId(Int64 stateId)
        {
            return CommonDAL.GetCityDetailsByStateId(stateId);
        }
        #endregion CountryStateCity

        #region Forms
        public static List<DropDownMDL> FillForms()
        {
            return CommonDAL.FillForms();
        }
        public static List<DropDownMDL> BindForms()
        {
            return CommonDAL.BindForms();
        }
        public static List<DropDownMDL> BindParentForms()
        {
            return CommonDAL.BindParentForms();
        }
        #endregion Forms

        #region CustomerAccountCategory
        public static List<DropDownMDL> GetAllAccountsByCategory(int categoryId)
        {
            return CommonDAL.GetAllAccountsByCategory(categoryId);
        }
        public static List<CompanyMDL> FillCompany(int companyID, int userId)
        {
            return CommonDAL.FillCompany(companyID, userId);
        }
        public static List<DropDownMDL> BindCategory()
        {
            return CommonDAL.BindCategory();
        }
        public static List<DropDownMDL> BindAccountsByCategory(Int64 CategoryId)
        {
            return CommonDAL.BindAccountsByCategory(CategoryId);
        }


        public static List<DropDownMDL> BindAllAccountsByCategory(Int64 CategoryId)
        {
            return CommonDAL.BindAllAccountsByCategory(CategoryId);
        }

        public static List<DropDownMDL> FillTagNameWithAccountId(int AccountId, string TagType)
        {
            return CommonDAL.FillTagNameWithAccountId(AccountId, TagType);
        }
        #endregion CustomerAccountCategory
        public static List<DropDownMDL> FillLanguages()
        {
            return CommonDAL.FillLanguages();
        }

        ///  Created By:Vinish 
        /// Created Date:10 Jan 2019
        /// PURPOSE:-Fill Role List
        public static List<DropDownMDL> FillRoles(Int64 FK_CustomerId = 0, Int64 AccoutnId = 0)
        {
            return CommonDAL.FillRoles(FK_CustomerId, AccoutnId);
        }

        public static List<DropDownMDL> BindUsers(Int64 FK_AccountId, Int64 UserId)
        {
            return CommonDAL.BindUsers(FK_AccountId, UserId);
        }
        public static List<DropDownMDL> GetSimTelco()
        {
            return CommonDAL.GetSimTelco();
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
        //    return CommonDAL.GetAllSolution(solutionId);
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
        //    return CommonDAL.GetAllAlertMessage(alertId);
        //}
        public static List<DropDownMDL> BindDeviceType()
        {
            return CommonDAL.BindDeviceType();
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
            return CommonDAL.GetFormColumnConfigList(ControllerName, ActionName, AccountId, CustomerId);
        }
        public static List<DropDownMDL> BindMappedFormColumn()
        {
            return CommonDAL.BindMappedFormColumn();
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
            return CommonDAL.GetColumnsByFormId(FK_FormId, FK_AccountId, FK_CustomerId);
        }
        public static List<DropDownMDL> BindDriver(Int64 FK_CustomerId = 0)
        {
            return CommonDAL.BindDriver(FK_CustomerId);
        }

        public static List<DropDownMDL> BindAccountsByCategoryWithAlreadyExist(Int64 FK_CategoryId, Int64 Fk_UserId)
        {
            return CommonDAL.BindAccountsByCategoryWithAlreadyExist(FK_CategoryId, Fk_UserId);
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
            return CommonDAL.GetVehicleGroupsByCustomerIdAccountId(AccountId, UserId, CustomerId, GroupName);
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
        public static List<DropDownMDL> BindMappedvehiclesByCustomer(Int64 FK_CustomerId, string GroupName = "")
        {
            return CommonDAL.BindMappedvehiclesByCustomer(FK_CustomerId, GroupName);
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
            return CommonDAL.GetVehicleByLoginType(AccountId, UserId, CustomerId, LoginType, VehicleNo);
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
            return CommonDAL.GetAllTitle(Title, TitleType);
        }

        /// <summary>
        /// Created By:Vinish
        /// Created Date:29-01-2020
        /// Purpose:To Get Email By Customer Id 
        /// </summary>
        /// <param name="FK_CustomerId"></param>
        /// <returns></returns>
        public static List<DropDownMDL> GetEmailByCustomerId(Int64 FK_CustomerId, string LoginType = "")
        {
            return CommonDAL.GetEmailByCustomerId(FK_CustomerId, LoginType);
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
            return CommonDAL.BindInstaller(customerId, installerName, accountId, mobileNo, emailId, zipCode, loginType, userId);
        }

        /// <summary>
        ///  Created By:Vinish
        /// Created Date:10 Jan 2019
        /// PURPOSE:- Bind Installer  Type List 
        /// </summary>
        /// <returns></returns>
        public static List<DropDownMDL> BindInstallerTypes()
        {
            return CommonDAL.BindInstallerTypes();
        }


        public static List<DropDownMDL> BindInstallerByAccount(int AccountId)
        {
            return CommonDAL.BindInstallerByAccount(AccountId);
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
            return CommonDAL.BindGetAllPackage(accountId, userId, packageName, plateFormType);
        }



        public static List<DropDownMDL> FillMonth()
        {
            return CommonDAL.FillMonth();
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
        //    return CommonDAL.BindGetAllDevice(accountId, categoryId, deviceTypeId, supplier, deviceId, iMEINO);
        //}

        /// <summary>
        ///  CREATED DATE : 11 Jan 2020
        /// PURPOSE :  Get All Sim Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="accountId"></param>
        /// <param name="categoryId"></param>
        /// <param name="deviceTypeId"></param>
        /// <returns></returns>
        //public static List<MstSimMDL> BindGetAllSimDetails(Int64 accountId = 0, Int64 categoryId = 0, string deviceTypeId = "")
        //{
        //    return CommonDAL.BindGetAllSimDetails(accountId, categoryId, deviceTypeId);
        //}

        /// <summary>
        ///  CREATED DATE : 11 Jan 2020
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
            return CommonDAL.BindGetAllInstaller(customerId, installerName, accountId, mobileNo, emailId, zipCode, loginType, userId);
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
            return CommonDAL.BindGetAllVehicleBrand(vehicleBrandName);
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
            return CommonDAL.BindGetAllVehicleType(vehicleType);
        }
        /// <summary>
        /// Check Duplicate user Name In User Master table
        /// </summary>
        /// <param name="username"></param>
        /// CREATED DATE : 15 Jan 2020 
        ///  CREATED BY : Vinish
        /// <returns></returns>
        public static MessageMDL CheckUserName(string username)
        {
            return CommonDAL.CheckUserNameDAL(username);
        }
        /// <summary>
        /// Check Duplicate Email ID In UserMaster Table
        /// </summary>
        /// CreatedBY :Vinish
        /// <param name="EmailId"></param>
        /// <returns></returns>
        public static MessageMDL CheckEmailId(string EmailId)
        {
            return CommonDAL.CheckEmailId(EmailId);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="SimNo"></param>
        /// <returns></returns>
        public static MessageMDL CheckSimNO(string SimNo)
        {
            return CommonDAL.CheckSimNO(SimNo);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="simsn"></param>
        /// <returns></returns>
        public static MessageMDL CheckSimSN(string simsn)
        {
            return CommonDAL.CheckSimSN(simsn);
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
        //    return CommonDAL.GetAllAccessory(accessoryId);
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
            return CommonDAL.BindGetAllPaymentMode(paymentModeId);
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
            return CommonDAL.BindCategoryByLoginType(LoginType);
        }

        /// <summary>
        /// CREATED DATE : 30 Jan 2020
        /// PURPOSE :  Get All User Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="accountId"></param>
        /// <param name="mobileNo"></param>
        /// <param name="userName"></param>
        /// <param name="emailId"></param>
        /// <param name="zipCode"></param>
        /// <param name="loginType"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static List<MstUserMDL> BindGetUserDetails(Int64 customerId = 0, Int64 accountId = 0, string mobileNo = "", string userName = "", string emailId = "", string zipCode = "", string loginType = "", Int64 userId = 0)
        {
            return CommonDAL.BindGetUserDetails(customerId, accountId, mobileNo, userName, emailId, zipCode, loginType, userId);
        }
        /// <summary>
        /// CREATED DATE : 30 Jan 2020
        /// PURPOSE :  Get Packet Type
        ///  CREATED BY : Vinish
        /// </summary>
        /// <returns></returns>
        public static List<DropDownMDL> getPacketType()
        {
            return CommonDAL.GetPacketType();
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
            return CommonDAL.BindPortByAccountId(PK_Map_VehiclePortId, AccountId, UserId, CustomerId, LoginType);
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
            return CommonDAL.CheckNameOrCodePresentInsystem(JSON);
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
        //    return CommonDAL.SyncingPortData(PortId);
        //}


        /// <summary>
        /// CREATED BY : Vinish
        /// CREATED DATE : 05-02-2020
        /// PURPOSE :  Get Port List For Sync Mongo
        /// </summary>
        /// <param name="_PortList"></param>
        /// <returns></returns>
        //public static List<VehiclePortMappingMDL> GetPortList(out List<VehiclePortMappingMDL> _PortList, Int64 PK_Map_VehiclePortId, Int64 AccountId, Int64 UserId, Int64 CustomerId, string LoginType)
        //{
        //    return CommonDAL.GetPortList(out _PortList,PK_Map_VehiclePortId, AccountId, UserId,CustomerId,LoginType);
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
            return CommonDAL.GetUserCredentialsByUserId(UserID, out Username, out Password, out UserEmail);
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
            return CommonDAL.GetAllLoginTypeUser(loginType);
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
            return CommonDAL.GetGroupNameList(customerId);
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
        //    return CommonDAL.GetGroupVehicleListGroupName(customerID, groupName);
        //}


        /// <summary>
        /// CREATED BY Vinish :: 12 FEB 2020
        /// PURPOSE: LOCK IN TABLE : SHARE DATA
        /// </summary>      
        /// <returns>URL & TOKEN NO.</returns>
        //public static bool AddSharedRide(ShareFromWebMDL _SharedMDL, out List<TokenDetailForWebMDL> _TokenDetailList, out string Message, out int status)
        //{
        //    _TokenDetailList = new List<TokenDetailForWebMDL>();
        //    Message = string.Empty;
        //    return CommonDAL.AddSharedRide(_SharedMDL, out _TokenDetailList, out Message, out status);
        //}


        /// <summary>
        /// CREATED BY : Vinish
        /// CREATED DATE : 24-Feb-2020
        /// PURPOSE :  Get Account Details
        /// </summary>
        /// <returns></returns>
        public static List<DropDownMDL> BindAccountTypeDetails()
        {
            return CommonDAL.BindAccountTypeDetails();
        }

        /// <summary>
        /// CREATED BY : Vinish
        /// CREATED DATE : 26-Feb-2020
        /// PURPOSE :  Get ALL GEO IDs
        /// </summary>
        /// <returns></returns>
        public static List<DropDownMDL> GetCustomerPOI_IDs_ByCustomerID(Int64 CustomerId)
        {
            return CommonDAL.GetCustomerPOI_IDs_ByCustomerID(CustomerId);
        }

        public static List<DropDownMDL> BindAllCompany()
        {
            return CommonDAL.BindAllCompany();
        } //Created By : Vinish
        //Created Datetime : 2020-04-24 13:39:56.427
        public static List<DropDownMDL> BindRolesByCompany(Int64 CompanyId)
        {
            return CommonDAL.BindRolesByCompany(CompanyId);
        }

        #region User Panel Common Functions

        public static List<DropDownMDL> FillSiteUserRoles()
        {
            return CommonDAL.FillSiteUserRoles();
        }

        public static List<DropDownMDL> BindAreaOfInterestList(string type = "")
        {
            return CommonDAL.BindAreaOfInterestList(type);
        }



        public static List<DropDownMDL> BindRetiredExpertiseDetailsList()
        {
            return CommonDAL.BindRetiredExpertiseDetailsList();
        }
        public static List<DropDownMDL> BindEmployedExpertiseDetailsList()
        {
            return CommonDAL.BindEmployedExpertiseDetailsList();
        }


        public static List<DropDownMDL> BindAllStreamsList(Int64 FK_StreamType = 0)
        {
            return CommonDAL.BindAllStreamsList(FK_StreamType);
        }
        public static List<DropDownMDL> BindAllStateWiseBoardList(Int64 FK_StateUT = 0)
        {
            return CommonDAL.BindAllStateWiseBoardList(FK_StateUT);
        }


        public static List<DropDownMDL> BindStreamDetailsList()
        {
            return CommonDAL.BindStreamDetailsList();
        }


        public static List<DropDownMDL> BindBoardDetailsList()
        {
            return CommonDAL.BindBoardDetailsList();
        }
        public static List<DropDownMDL> BindYearOfPassingList()
        {
            return CommonDAL.BindYearOfPassingList();
        }
        #region GetLanguage dropdown
        public static List<DropDownMDL> GetLanguage()
        {
            return CommonDAL.GetLanguage();
        }
        #endregion
        #region GetStream Dropdown
        public static List<DropDownMDL> GetStream(string educationtype)
        {
            return CommonDAL.GetStream(educationtype);
        }
        #endregion
        #region GetBoardType Dropdown
        public static List<DropDownMDL> GetBoardType()
        {
            return CommonDAL.GetBoardType();
        }
        #endregion
        #region Check userID
        public static bool CheckUserId(string UserID)
        {
            return CommonDAL.CheckUserId(UserID);
        }



        #endregion




        public static List<DropDownMDL> GetAcademicGroupList()
        {
            return CommonDAL.GetAcademicGroupList();
        }
        public static List<DropDownMDL> GetBenifitTypeList()
        {
            return CommonDAL.GetBenifitTypeList();
        }
        #endregion

        #region Admin Panel Common Function
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Delete
        /// </summary>
        public MessageMDL DeleteSiteUser(Int64 id, Int64 UserId,bool recover = false)
        {
            CommonDAL objDAL = new CommonDAL();
            return objDAL.DeleteSiteUser(id, UserId, recover);
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        public bool GetSiteUserDetails(out dynamic _DataList, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 UserId, string LoginType, int FK_CategoryId, int FK_RoleId)
        {
            CommonDAL objDAL = new CommonDAL();
            _DataList = new List<CounselorMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            return objDAL.GetSiteUserDetails(out _DataList, out objBasicPagingMDL, out objTotalCountPagingMDL, id, RowPerpage, CurrentPage, SearchBy, SearchValue, UserId, LoginType, FK_CategoryId, FK_RoleId);

        }


        #endregion

    }
}
