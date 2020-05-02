using GyanmitrasDAL.DataUtility;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GyanmitrasLanguages.LocalResources;

namespace GyanmitrasDAL
{
    public class AccountDAL
    {
        #region
        DataFunctions objDataFunctions = null;
        DataTable objDataTable = null;
        DataSet objDataSet = null;
        string _commandText = string.Empty;

        #endregion

        public AccountDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        public MessageMDL AuthenticateUser(LoginMDL ObjLoginMDL, out UserInfoMDL _User, out List<FormMDL> _formlist)
        {
            MessageMDL objMessage = new MessageMDL();
            _User = new UserInfoMDL();

            _formlist = new List<FormMDL>();
            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@cUserName",ObjLoginMDL.UserName),
                new SqlParameter("@cPassword",ObjLoginMDL.Password),
                 new SqlParameter("@cLanguage",ObjLoginMDL.Language)
            };

                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_AuthenticateUser]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessage.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessage.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");

                    DataRow _dr = objDataSet.Tables[1].Rows[0];

                    _User = new UserInfoMDL()
                    {
                        UserId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("UserId")),
                        UserName = _dr.Field<string>("UserName"),
                        UserPassword = _dr.Field<string>("UserPassword"),
                        Name = _dr.Field<string>("Name"),
                        RoleId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("RoleId")),
                        RoleName = _dr.Field<string>("RoleName"),
                        AccountId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("FK_AccountId")),
                        AccountName = _dr.Field<string>("AccountName"),
                        CategoryId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("FK_CategoryId")),
                        //CategoryName = _dr.Field<string>("CategoryName"),
                        CityId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("CityId")),
                        CityName = _dr.Field<string>("CityName"),
                        StateId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("StateId")),
                        StateName = _dr.Field<string>("StateName"),
                        CountryId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("CountryId")),
                        CountryName = _dr.Field<string>("CountryName"),
                        logoClass = _dr.Field<string>("logoClass"),
                        LoginType = _dr.Field<string>("LoginType"),
                        ResellerId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("FK_ResellerId")),
                        AffiliateId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("FK_AffiliateId")),
                        FK_CustomerId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("FK_CustomerId")),
                        //CustomerName = _dr.Field<string>("CustomerName"),
                        EmailId = _dr.Field<string>("EmailId")
                    };
                    _formlist = objDataSet.Tables[2].AsEnumerable().Select(dr => new FormMDL()
                    {
                        PK_FormId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_FormId")),
                        //FormName = dr.Field<string>("FormName"),
                        FormName = string.IsNullOrEmpty(Resource.ResourceManager.GetString(dr.Field<string>("FormName").Replace(" ","")))
                                    ? dr.Field<string>("FormName") 
                                    : Resource.ResourceManager.GetString(dr.Field<string>("FormName").Replace(" ", "")),

                        ControllerName = dr.Field<string>("ControllerName"),
                        ActionName = dr.Field<string>("ActionName"),
                        FK_ParentId = dr.Field<Int64>("ParentId"),
                        FK_MainId = dr.Field<int>("MainId"),
                        LevelId = dr.Field<int>("LevelId"),
                        SortId = dr.Field<int>("SortId"),
                        Image = dr.Field<string>("Image"),
                        CanAdd = WrapDbNull.WrapDbNullValue<bool>(dr.Field<bool?>("CanAdd")),
                        CanEdit = WrapDbNull.WrapDbNullValue<bool>(dr.Field<bool?>("CanEdit")),
                        CanDelete = WrapDbNull.WrapDbNullValue<bool>(dr.Field<bool?>("CanDelete")),
                        CanView = WrapDbNull.WrapDbNullValue<bool>(dr.Field<bool?>("CanView")),
                        ClassName = dr.Field<string>("ClassName"),
                        HomePage =dr.Field<Int64>("HomePage"),
                        Area = dr.Field<string>("Area"),
                    }).ToList();
                }

            }
            catch (Exception ex)
            {

            }

            return objMessage;
        }

        public LoginMDL GetUserDetails(string userName)
        {
            LoginMDL objlogin = new LoginMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                        new SqlParameter("@cUserName",userName)
                };
                _commandText = "[dbo].[usp_GetUserlists]";

                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        var dr = objDataSet.Tables[1].Rows[0];
                        objlogin = new LoginMDL()
                        {
                            ForgetPwdUserName = dr.Field<string>("UserName"),
                            Password = dr.Field<string>("UserPassword"),
                            EmailID = dr.Field<string>("EmailId"),
                            MobileNo = dr.Field<string>("MobileNo"),
                            _UserId = dr.Field<Int64>("UserId")
                        };

                        objDataSet.Dispose();
                    }
                }
            }
            catch (Exception ex)
            {

            }
            return objlogin;

        }
    }
}
