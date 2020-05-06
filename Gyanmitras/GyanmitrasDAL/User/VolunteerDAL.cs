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

                   new SqlParameter("@LanguageKnownID",DBNull.Value),
                    new SqlParameter("@AreaOfInterestID",DBNull.Value),
                       new SqlParameter("@HaveSmartPhone",DBNull.Value),
                     new SqlParameter("@HavePC",DBNull.Value),
                     new SqlParameter("@AdoptionWish",DBNull.Value),
                     new SqlParameter("@Education_Type",DBNull.Value),
                     new SqlParameter("@Class",DBNull.Value),
                     new SqlParameter("@BoardID",DBNull.Value),
                     new SqlParameter("@FK_StreamID",DBNull.Value),
                     new SqlParameter("@Currentsemester",DBNull.Value),
                     new SqlParameter("@UniversityName",DBNull.Value),
                     new SqlParameter("@NatureOFCompletion",DBNull.Value),
                     new SqlParameter("@Percentage",DBNull.Value),
                     new SqlParameter("@Previous_Class",DBNull.Value),
                     new SqlParameter("@FK_Previous_Class_Board",DBNull.Value),
                     new SqlParameter("@Previous_Class_Percentage",DBNull.Value),
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
    }
}
