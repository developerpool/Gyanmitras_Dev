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
using GyanmitrasMDL.User;

namespace GyanmitrasDAL.User
{
    public class SiteAccountDAL
    {
        #region
        DataFunctions objDataFunctions = null;
        DataTable objDataTable = null;
        DataSet objDataSet = null;
        string _commandText = string.Empty;

        #endregion

        public SiteAccountDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        public MessageMDL AuthenticateSiteUser(SiteLoginMDL ObjLoginMDL, out SiteUserInfoMDL _User)
        {
            MessageMDL objMessage = new MessageMDL();
            _User = new SiteUserInfoMDL();

            try
            {

                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@cUserName",ObjLoginMDL.UserName),
                new SqlParameter("@cPassword",ObjLoginMDL.Password),
                 new SqlParameter("@cLanguage",ObjLoginMDL.Language)
            };

                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_AuthenticateSiteUsers]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessage.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessage.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");

                    DataRow _dr = objDataSet.Tables[1].Rows[0];

                    _User = new SiteUserInfoMDL()
                    {
                        UserId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("UserId")),
                        UserName = _dr.Field<string>("UserName"),
                        UserPassword = _dr.Field<string>("UserPassword"),
                        Name = _dr.Field<string>("Name"),
                        RoleId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("RoleId")),
                        RoleName = _dr.Field<string>("RoleName"),
                        CategoryId = WrapDbNull.WrapDbNullValue<Int64>(_dr.Field<Int64?>("FK_CategoryId")),
                        LoginType = _dr.Field<string>("CategoryName"),
                        IsAdoptedStudentCounselor = _dr.Field<bool>("IsAdoptedStudentCounselor"),
                        AdoptedCounselor = _dr.Field<Int64>("AdoptedCounselor"),
                        IsUpdatedProfileAlert = _dr.Field<bool>("IsUpdatedProfileAlert"),
                        ProfileImage = _dr.Field<string>("ProfileImage"),
                        IsEmailVerified = _dr.Field<bool>("IsEmailVerified"),
                    };

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
