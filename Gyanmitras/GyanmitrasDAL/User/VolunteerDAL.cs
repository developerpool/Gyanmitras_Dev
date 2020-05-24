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
    public class VolunteerDAL
    {
        static string CommandText = string.Empty;
        static DataFunctions objDataFunctions = new DataFunctions();

        #region register Volunteer
        public StringBuilder RegisterVolunteer(VolunteerMDL objVolunteerMDL)
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
                dt.Rows.Add(
                  objVolunteerMDL.UID, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value);

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@DistrictAreaOfSearch",objVolunteerMDL.FK_District_AreaOfSearch),
                     new SqlParameter("@StateAreaOfSearch",objVolunteerMDL.FK_State_AreaOfSearch),
                     new SqlParameter("@Email",objVolunteerMDL.EmailID),
                     new SqlParameter("@Name",objVolunteerMDL.Name),
                     new SqlParameter("@Mobile_Number",objVolunteerMDL.MobileNo),
                     new SqlParameter("@Alternate_Mobile_Number",objVolunteerMDL.AlternateMobileNo),
                     new SqlParameter("@Address",objVolunteerMDL.Address),
                     new SqlParameter("@Zipcode",objVolunteerMDL.ZipCode),
                     new SqlParameter("@StateID",objVolunteerMDL.FK_StateId),
                     new SqlParameter("@CityID",objVolunteerMDL.FK_CityId),
                     new SqlParameter("@UserName",objVolunteerMDL.UID),
                     new SqlParameter("@CategoryID",3),
                     new SqlParameter("@RoleID",3),
                     new SqlParameter("@Deleted",false),
                     new SqlParameter("@Password",objVolunteerMDL.Password),
                     new SqlParameter("@IsActive",1),
                     new SqlParameter("@Image",objVolunteerMDL.ImageName),
                      new SqlParameter("@Createddatetime",DateTime.Now),
                   new SqlParameter("@LanguageKnownID",DBNull.Value),
                    new SqlParameter("@AreaOfInterestID",DBNull.Value),
                       new SqlParameter("@HaveSmartPhone",DBNull.Value),
                     new SqlParameter("@HavePC",DBNull.Value),
                     new SqlParameter("@AdoptionWish",DBNull.Value),
                     //new SqlParameter("@Education_Type",DBNull.Value),
                     //new SqlParameter("@Class",DBNull.Value),
                     //new SqlParameter("@BoardID",DBNull.Value),
                     //new SqlParameter("@FK_StreamID",DBNull.Value),
                     //new SqlParameter("@Currentsemester",DBNull.Value),
                     //new SqlParameter("@UniversityName",DBNull.Value),
                     //new SqlParameter("@NatureOFCompletion",DBNull.Value),
                     //new SqlParameter("@Percentage",DBNull.Value),
                     //new SqlParameter("@Previous_Class",DBNull.Value),
                     //new SqlParameter("@FK_Previous_Class_Board",DBNull.Value),
                     //new SqlParameter("@Previous_Class_Percentage",DBNull.Value),
                     // 
                     //   new SqlParameter("@Year_Of_Passing",DBNull.Value),
                     new SqlParameter("@Academicdata",dt),
                       new SqlParameter("@EmployedExpertise",DBNull.Value),
                   new SqlParameter("@RetiredExpertise",DBNull.Value),
                    new SqlParameter("@AreYou",DBNull.Value),
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

        #region get Volunteer profile
        public VolunteerMDL GetVolunteerProfile(string Username)
        {
            CommandText = "[siteusers].[usp_GetStudentProfile]";
            VolunteerMDL objvolunteermdl = new VolunteerMDL();

            SqlParameter param = new SqlParameter()
            {
                ParameterName = "@UserName",
                Value = Username

            };
            DataSet ds = (DataSet)objDataFunctions.getQueryResult(CommandText, DataReturnType.DataSet, param);
            if (ds != null)
            {
                //Fk_AreaOfInterest_State Fk_AreaOfInterest_District
                if (ds.Tables[0].Rows.Count > 0)
                {
                    objvolunteermdl.Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    objvolunteermdl.AlternateMobileNo = ds.Tables[0].Rows[0]["Alternate_Mobile_Number"].ToString(); ;
                    objvolunteermdl.EmailID = ds.Tables[0].Rows[0]["Email"].ToString();
                    objvolunteermdl.ImageName = ds.Tables[0].Rows[0]["Image"].ToString();
                    objvolunteermdl.MobileNo = ds.Tables[0].Rows[0]["Mobile_Number"].ToString();
                    objvolunteermdl.PK_VolunteerId = Convert.ToInt32(ds.Tables[0].Rows[0]["UID"]);
                    objvolunteermdl.UID = ds.Tables[0].Rows[0]["UserName"].ToString();

                }

                else
                {
                    objvolunteermdl = null;
                }
            }
            else
            {
                objvolunteermdl = null;
            }
            return objvolunteermdl;
        }


        #endregion


        #region Update Volunteer profile
        public StringBuilder UpdateVolunteerProfile(VolunteerMDL objvolunteerMDL)
        {

            var jsonResult = new StringBuilder();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@PK_userID",objvolunteerMDL.PK_VolunteerId),
                    new SqlParameter("@CategoryID",3),
                    new SqlParameter("@RoleID",3),
                    new SqlParameter("@Image",objvolunteerMDL.ImageName),
                    new SqlParameter("@HaveSmartPhone",DBNull.Value),
                    new SqlParameter("@HavePC",DBNull.Value),
                    new SqlParameter("@Email",objvolunteerMDL.EmailID),
                    new SqlParameter("@Mobile_Number",objvolunteerMDL.MobileNo),
                    new SqlParameter("@Alternate_Mobile_Number",objvolunteerMDL.AlternateMobileNo),
                    new SqlParameter("@Address",objvolunteerMDL.Address),
                    new SqlParameter("@Updateddatetime",DateTime.Now),
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
