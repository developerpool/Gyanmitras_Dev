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
using GyanmitrasDAL.Common;

namespace GyanmitrasDAL.User
{
    public class CounselorDAL
    {
        static string CommandText = string.Empty;
        static DataFunctions objDataFunctions = new DataFunctions();
        #region register counselor
        public StringBuilder RegisterCounselor(CounselorMDL objCounselorMDL)
        {

            var jsonResult = new StringBuilder();
            try
            {

                DataTable dt = new DataTable();
                dt.Columns.Add("FK_UserName");
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
                dt.Rows.Add(objCounselorMDL.UID, Convert.ToString("Secondry"), Convert.ToString("10"), objCounselorMDL.Secondry_Education_Board, DBNull.Value, DBNull.Value, DBNull.Value, Convert.ToString("Completed"),
                   objCounselorMDL.Secondry_Percentage, DBNull.Value, DBNull.Value, DBNull.Value, objCounselorMDL.Secondry_Year_of_Passing, DBNull.Value, DBNull.Value, DBNull.Value);

                dt.Rows.Add(objCounselorMDL.UID, Convert.ToString("HigherSecondry"), Convert.ToString("12"), objCounselorMDL.HigherSecondry_Education_Board, objCounselorMDL.HigherSecondry_StreamType, DBNull.Value, DBNull.Value, Convert.ToString("Completed"),
                   objCounselorMDL.HigherSecondry_Percentage, DBNull.Value, DBNull.Value, DBNull.Value, objCounselorMDL.HigherSecondry_Year_of_Passing, DBNull.Value, DBNull.Value, DBNull.Value);

                dt.Rows.Add(objCounselorMDL.UID, Convert.ToString("Graduation"), DBNull.Value, DBNull.Value, objCounselorMDL.Graduation_StreamType, objCounselorMDL.Graduation_UniversityName, DBNull.Value, Convert.ToString("Completed"),
                   objCounselorMDL.Graduation_Percentage, DBNull.Value, DBNull.Value, DBNull.Value, objCounselorMDL.Graduation_Year_of_Passing, DBNull.Value, DBNull.Value, objCounselorMDL.Graduation_CourseName);

                dt.Rows.Add(objCounselorMDL.UID, Convert.ToString("PostGraduation"), DBNull.Value, DBNull.Value, String.IsNullOrEmpty(objCounselorMDL.PostGraduation_StreamType) ? DBNull.Value : (object)(int.Parse(objCounselorMDL.PostGraduation_StreamType)), String.IsNullOrEmpty(objCounselorMDL.PostGraduation_UniversityName) ? DBNull.Value : (object)(objCounselorMDL.PostGraduation_UniversityName), DBNull.Value, DBNull.Value,
                 Convert.ToDecimal(objCounselorMDL.PostGraduation_Percentage), DBNull.Value, DBNull.Value, DBNull.Value, String.IsNullOrEmpty(objCounselorMDL.PostGraduation_Year_of_Passing) ? DBNull.Value : (object)(objCounselorMDL.PostGraduation_Year_of_Passing), DBNull.Value, DBNull.Value,
                 String.IsNullOrEmpty(objCounselorMDL.PostGraduation_CourseName) ? DBNull.Value : (object)(objCounselorMDL.PostGraduation_CourseName));

                dt.Rows.Add(objCounselorMDL.UID, Convert.ToString("Docterate"), DBNull.Value, DBNull.Value, DBNull.Value, String.IsNullOrEmpty(objCounselorMDL.Docterate_UniversityName) ? DBNull.Value : (object)(objCounselorMDL.Docterate_UniversityName), DBNull.Value, DBNull.Value,
                   Convert.ToDecimal(objCounselorMDL.NET_JRF_Percentage), DBNull.Value, DBNull.Value, DBNull.Value, String.IsNullOrEmpty(objCounselorMDL.Docterate_Year_of_Passing) ? DBNull.Value : (object)(objCounselorMDL.Docterate_Year_of_Passing), String.IsNullOrEmpty(objCounselorMDL.Specification) ? DBNull.Value : (object)(objCounselorMDL.Specification), String.IsNullOrEmpty(objCounselorMDL.Extra_work) ? DBNull.Value : (object)(objCounselorMDL.Extra_work), DBNull.Value);

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@DistrictAreaOfSearch",DBNull.Value),
                     new SqlParameter("@StateAreaOfSearch",DBNull.Value),
                     new SqlParameter("@Email",objCounselorMDL.EmailID),
                     new SqlParameter("@Name",objCounselorMDL.Name),
                     new SqlParameter("@Mobile_Number",objCounselorMDL.MobileNo),
                     new SqlParameter("@Alternate_Mobile_Number",objCounselorMDL.AlternateMobileNo),
                       new SqlParameter("@Address",objCounselorMDL.Address),
                     new SqlParameter("@Zipcode",objCounselorMDL.ZipCode),
                     new SqlParameter("@StateID",objCounselorMDL.FK_StateId),
                     new SqlParameter("@CityID",objCounselorMDL.FK_CityId),
                     new SqlParameter("@LanguageKnownID",String.IsNullOrEmpty(objCounselorMDL.languages)  ? DBNull.Value : (object)(int.Parse(objCounselorMDL.languages))),
                     new SqlParameter("@AreaOfInterestID",String.IsNullOrEmpty(objCounselorMDL.AreaOfInterest)  ? DBNull.Value : (object)(int.Parse(objCounselorMDL.AreaOfInterest))),
                     new SqlParameter("@UserName",objCounselorMDL.UID),
                     new SqlParameter("@CategoryID",2),
                     new SqlParameter("@RoleID",2),
                     new SqlParameter("@Deleted",false),
                     new SqlParameter("@Password",objCounselorMDL.Password),
                        new SqlParameter("@IsActive",1),
                     new SqlParameter("@Image",objCounselorMDL.ImageName),
                          new SqlParameter("@Createddatetime",DateTime.Now),
                    new SqlParameter("@HaveSmartPhone",DBNull.Value),
                     new SqlParameter("@HavePC",objCounselorMDL.HavePC),
                        new SqlParameter("@AdoptionWish",objCounselorMDL.LikeAdoptStudentLater),
                          new SqlParameter("@Academicdata",dt),

                    new SqlParameter("@Createddatetime",DateTime.Now),

                      new SqlParameter("@EmployedExpertise",objCounselorMDL.Expertise_Details),
                   new SqlParameter("@RetiredExpertise",objCounselorMDL.Retired_Expertise_Details),
                    new SqlParameter("@AreYou",objCounselorMDL.AreYou),
                };
                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[siteusers].[sp_SubmitRegistration]";
                DataSet ds = new DataSet();
                ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
                jsonResult.Append(ds.Tables[0].Rows[0]["Column1"].ToString());

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");

                jsonResult.Append("Failled");
            }
            return jsonResult;
        }
        #endregion

        #region get student profile
        public CounselorMDL GetCounselorProfile(string Username)
        {
            CommandText = "[siteusers].[usp_GetStudentProfile]";
            CounselorMDL counmdl = new CounselorMDL();

            SqlParameter param = new SqlParameter()
            {
                ParameterName = "@UserName",
                Value = Username

            };
            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, param);
            if (ds != null)
            {

                if (ds.Tables[0].Rows.Count > 0)
                {
                    counmdl.AlternateMobileNo = ds.Tables[0].Rows[0]["Alternate_Mobile_Number"].ToString();
                    counmdl.Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    counmdl.EmailID = ds.Tables[0].Rows[0]["Email"].ToString();
                    counmdl.HavePC = Convert.ToBoolean(ds.Tables[0].Rows[0]["HavePC"]);
                    counmdl.ImageName = ds.Tables[0].Rows[0]["Image"].ToString();
                    counmdl.MobileNo = ds.Tables[0].Rows[0]["Mobile_Number"].ToString();
                    counmdl.PK_CounselorID = Convert.ToInt32(ds.Tables[0].Rows[0]["UID"]);
                    counmdl.UID = ds.Tables[0].Rows[0]["UserName"].ToString();
                }
                else
                {
                    counmdl = null;
                }
            }
            else
            {
                counmdl = null;
            }
            return counmdl;
        }


        #endregion


        #region Update Counselor profile
        public StringBuilder UpdateCounselorProfile(CounselorMDL objcounselorMDL)
        {

            var jsonResult = new StringBuilder();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                      new SqlParameter("@PK_userID",objcounselorMDL.PK_CounselorID),
                       new SqlParameter("@CategoryID",2),
                     new SqlParameter("@RoleID",2),
                     new SqlParameter("@Image",objcounselorMDL.ImageName),
                     new SqlParameter("@HavePC",objcounselorMDL.HavePC),
                      new SqlParameter("@Email",objcounselorMDL.EmailID),
                       new SqlParameter("@Mobile_Number",objcounselorMDL.MobileNo),
                     new SqlParameter("@Alternate_Mobile_Number",objcounselorMDL.AlternateMobileNo),
                       new SqlParameter("@Address",objcounselorMDL.Address),
                        new SqlParameter("@Updateddatetime",DateTime.Now),
                         new SqlParameter("@HaveSmartPhone",DBNull.Value),

                };
                CheckParameters.ConvertNullToDBNull(parms);
                CommandText = "[siteusers].[sp_UpdateRegistration]";
                DataSet ds = new DataSet();
                ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, parms);
                jsonResult.Append(ds.Tables[0].Rows[0]["Column1"].ToString());

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");

                jsonResult.Append("Failled");
            }
            return jsonResult;
        }
        #endregion

    }
}
