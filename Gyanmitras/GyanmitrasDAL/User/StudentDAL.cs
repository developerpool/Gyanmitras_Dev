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
    public class StudentDAL
    {
        static string CommandText = string.Empty;
        static DataFunctions objDataFunctions = new DataFunctions();
        #region register student
        public StringBuilder RegisterStudent(StudentMDL objstudentMDL)
        {
            decimal? percent = null;
            var jsonResult = new StringBuilder();
            try
            {
                decimal c = Convert.ToDecimal(objstudentMDL.PreviousclassPercentage);
                if (objstudentMDL.Percentage != 0 || objstudentMDL.Percentage != null)
                {
                    percent = objstudentMDL.Percentage;
                }
                else if (objstudentMDL.TotalAggregatetillnow != 0 || objstudentMDL.TotalAggregatetillnow != null)
                {
                    percent = objstudentMDL.TotalAggregatetillnow;
                }


                List<SqlParameter> parms = new List<SqlParameter>()
                {

                     new SqlParameter("@Name",objstudentMDL.Name),
                     new SqlParameter("@Mobile_Number",objstudentMDL.MobileNo),
                     new SqlParameter("@Alternate_Mobile_Number",objstudentMDL.AlternateMobileNo),
                       new SqlParameter("@Address",objstudentMDL.Address),
                     new SqlParameter("@Zipcode",objstudentMDL.ZipCode),
                     new SqlParameter("@StateID",objstudentMDL.FK_StateId),
                     new SqlParameter("@CityID",objstudentMDL.FK_CityId),
                     new SqlParameter("@LanguageKnownID",String.IsNullOrEmpty(objstudentMDL.languages)  ? DBNull.Value : (object)(int.Parse(objstudentMDL.languages))),
                     new SqlParameter("@AreaOfInterestID",String.IsNullOrEmpty(objstudentMDL.AreaOfInterest)  ? DBNull.Value : (object)(int.Parse(objstudentMDL.AreaOfInterest))),
                     new SqlParameter("@UserName",objstudentMDL.UID),
                     new SqlParameter("@CategoryID",1),
                     new SqlParameter("@RoleID",1),
                     new SqlParameter("@Deleted",false),
                     new SqlParameter("@Password",objstudentMDL.Password),
                        new SqlParameter("@IsActive",1),
                     new SqlParameter("@Image",objstudentMDL.ImageName),
                     new SqlParameter("@HaveSmartPhone",objstudentMDL.HaveSmartPhone),
                     new SqlParameter("@HavePC",objstudentMDL.HavePC),
                        new SqlParameter("@AdoptionWish",objstudentMDL.AdoptionWish),
                     new SqlParameter("@Education_Type",objstudentMDL.TypeOfEducation),
                     new SqlParameter("@Class",objstudentMDL.Current_Education_subcategory),
                     new SqlParameter("@BoardID",String.IsNullOrEmpty(objstudentMDL.BoardType)  ? DBNull.Value : (object)(int.Parse(objstudentMDL.BoardType))),
                        new SqlParameter("@FK_StreamID",String.IsNullOrEmpty(objstudentMDL.StreamType)  ? DBNull.Value : (object)(int.Parse(objstudentMDL.StreamType))),
                     new SqlParameter("@Currentsemester",objstudentMDL.Current_semester),
                     new SqlParameter("@UniversityName",objstudentMDL.UniversityName),
                     new SqlParameter("@NatureOFCompletion",objstudentMDL.CompletionNature),
                      //  new SqlParameter("@Percentage",(objstudentMDL.Percentage).HasValue  ? Convert.ToDecimal(objstudentMDL.Percentage) : (Convert.ToDecimal(objstudentMDL.TotalAggregatetillnow))),
                    
                  new SqlParameter("@Percentage",Convert.ToDecimal(percent)),
                     new SqlParameter("@Previous_Class",objstudentMDL.Previous_Education_subcategory),
                     new SqlParameter("@FK_Previous_Class_Board",String.IsNullOrEmpty(objstudentMDL.PreviousBoardType)  ? DBNull.Value : (object)(int.Parse(objstudentMDL.PreviousBoardType))),
                     new SqlParameter("@Previous_Class_Percentage",Convert.ToDecimal(objstudentMDL.PreviousclassPercentage)),
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
