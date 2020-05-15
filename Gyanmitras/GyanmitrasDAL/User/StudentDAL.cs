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
using System.Data.SqlTypes;

namespace GyanmitrasDAL.User
{
    public class StudentDAL
    {

        static string CommandText = string.Empty;
        static DataFunctions objDataFunctions = new DataFunctions();
        static string _commandText = string.Empty;
        #region register student
        public StringBuilder RegisterStudent(StudentMDL objstudentMDL)
        {
            decimal? percent = null;
            var jsonResult = new StringBuilder();
            try
            {
                decimal c = Convert.ToDecimal(objstudentMDL.PreviousclassPercentage);
                if (objstudentMDL.Percentage != 0 && objstudentMDL.Percentage != null)
                {
                    percent = objstudentMDL.Percentage;
                }
                else if (objstudentMDL.TotalAggregatetillnow != 0 || objstudentMDL.TotalAggregatetillnow != null)
                {
                    percent = objstudentMDL.TotalAggregatetillnow;
                }
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
                if (objstudentMDL.FormType != "volunteer")
                {
                    dt.Rows.Add(objstudentMDL.UID, objstudentMDL.TypeOfEducation, objstudentMDL.Current_Education_subcategory, String.IsNullOrEmpty(objstudentMDL.BoardType) ? DBNull.Value : (object)(int.Parse(objstudentMDL.BoardType)),
                        String.IsNullOrEmpty(objstudentMDL.StreamType) ? DBNull.Value : (object)(int.Parse(objstudentMDL.StreamType)),
                        objstudentMDL.Current_semester, objstudentMDL.UniversityName, objstudentMDL.CompletionNature, Convert.ToDecimal(percent), objstudentMDL.Previous_Education_subcategory,
                        String.IsNullOrEmpty(objstudentMDL.PreviousBoardType) ? DBNull.Value : (object)(int.Parse(objstudentMDL.PreviousBoardType)),
                                Convert.ToDecimal(objstudentMDL.PreviousclassPercentage), DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value);
                }

                List<SqlParameter> parms = new List<SqlParameter>()
                {

                    new SqlParameter("@DistrictAreaOfSearch",DBNull.Value),
                     new SqlParameter("@StateAreaOfSearch",DBNull.Value),
                     new SqlParameter("@Email",objstudentMDL.EmailID),
                     new SqlParameter("@Name",objstudentMDL.Name),
                     new SqlParameter("@Mobile_Number",objstudentMDL.MobileNo),
                     new SqlParameter("@Alternate_Mobile_Number",objstudentMDL.AlternateMobileNo),
                       new SqlParameter("@Address",objstudentMDL.Address),
                     new SqlParameter("@Zipcode",objstudentMDL.ZipCode),
                     new SqlParameter("@StateID",objstudentMDL.FK_StateId),
                     new SqlParameter("@CityID",objstudentMDL.FK_CityId),
                     new SqlParameter("@LanguageKnownID",String.IsNullOrEmpty(objstudentMDL.languages)  ? DBNull.Value : (object)(int.Parse(objstudentMDL.languages))),
                     new SqlParameter("@AreaOfInterestID",objstudentMDL.AreaOfInterest),
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
                          new SqlParameter("@Academicdata",dt),

                    new SqlParameter("@Createddatetime",DateTime.Now),
                    new SqlParameter("@CreatedBy",objstudentMDL.CreatedBy),

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

        #region get student profile
        public StudentMDL GetStudentProfile(string Username)
        {
            CommandText = "[siteusers].[usp_GetStudentProfile]";
            StudentMDL stdmdl = new StudentMDL();

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
                    stdmdl.AlternateMobileNo = ds.Tables[0].Rows[0]["Alternate_Mobile_Number"].ToString();
                    stdmdl.Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    stdmdl.HavePC = Convert.ToBoolean(ds.Tables[0].Rows[0]["HavePC"]);
                    stdmdl.HaveSmartPhone = Convert.ToBoolean(ds.Tables[0].Rows[0]["HaveSmartPhone"]);
                    stdmdl.ImageName = ds.Tables[0].Rows[0]["Image"].ToString();
                    stdmdl.EmailID = ds.Tables[0].Rows[0]["Email"].ToString();
                    stdmdl.MobileNo = ds.Tables[0].Rows[0]["Mobile_Number"].ToString();
                    stdmdl.PK_StudentID = Convert.ToInt32(ds.Tables[0].Rows[0]["UID"]);
                    stdmdl.UID = ds.Tables[0].Rows[0]["UserName"].ToString();

                }

                else
                {
                    stdmdl = null;
                }
            }
            else
            {
                stdmdl = null;
            }
            return stdmdl;
        }


        #endregion


        #region Update student profile
        public StringBuilder UpdateStudentProfile(StudentMDL objstudentMDL)
        {

            var jsonResult = new StringBuilder();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                      new SqlParameter("@PK_userID",objstudentMDL.PK_StudentID),
                       new SqlParameter("@CategoryID",1),
                     new SqlParameter("@RoleID",1),
                     new SqlParameter("@Image",objstudentMDL.ImageName),
                     new SqlParameter("@HaveSmartPhone",objstudentMDL.HaveSmartPhone),
                     new SqlParameter("@HavePC",objstudentMDL.HavePC),
                      new SqlParameter("@Email",objstudentMDL.EmailID),
                       new SqlParameter("@Mobile_Number",objstudentMDL.MobileNo),
                     new SqlParameter("@Alternate_Mobile_Number",objstudentMDL.AlternateMobileNo),
                       new SqlParameter("@Address",objstudentMDL.Address),
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


        public List<SiteUserPlannedCommunication> GetPlannedCommunication(Int64 FK_CounselorID, Int64 FK_StudentID,string LoginType = "")
        {

            List<SiteUserPlannedCommunication> List = new List<SiteUserPlannedCommunication>();
            try
            {
                DataSet objDataSet = new DataSet();

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@FK_CounselorID",FK_CounselorID),
                     new SqlParameter("@FK_StudentID",FK_StudentID),
                     new SqlParameter("@LoginType",LoginType),
                     
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_GetPlannedCommunication]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    List = objDataSet.Tables[0].AsEnumerable().Select(dr => new SiteUserPlannedCommunication()
                    {
                        PK_PlannedCommunicationID = dr.Field<Int64>("PK_PlannedCommunicationID"),
                        FK_CounselorID            = dr.Field<Int64>("FK_CounselorID"),
                        FK_StudentID              = dr.Field<Int64>("FK_StudentID"),
                        DateTimeFrom              = dr.Field<string>("DateTimeFrom"),
                        DateTimeTo                = dr.Field<string>("DateTimeTo"),
                        CommunicationPlan         = dr.Field<string>("CommunicationPlan"),
                        IsActive                  = dr.Field<bool>("IsActive"),
                        IsDeleted                 = dr.Field<bool>("IsDeleted")

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




        public MessageMDL AddPlannedCommunication(List<SiteUserPlannedCommunication> objPlannedCommunication,string IsAdopt)
        {
            MessageMDL objMessageMDL = new MessageMDL();
            List<SiteUserPlannedCommunication> List = new List<SiteUserPlannedCommunication>();
            try
            {
                DataSet objDataSet = new DataSet();
                DataTable objDataTable = new DataTable();
                objDataTable.Columns.Add("FK_CounselorID",typeof(Int64));
                objDataTable.Columns.Add("FK_StudentID", typeof(Int64));
                objDataTable.Columns.Add("DateTimeFrom", typeof(string));
                objDataTable.Columns.Add("DateTimeTo", typeof(string));
                objDataTable.Columns.Add("CommunicationPlan", typeof(string));
                objDataTable.Columns.Add("IsActive", typeof(bool));
                objDataTable.Columns.Add("IsDeleted", typeof(bool));

                
                foreach (var item in objPlannedCommunication)
                {
                    DataRow dr = objDataTable.NewRow();
                    dr["FK_CounselorID"] = item.FK_CounselorID;
                    dr["FK_StudentID"] = item.FK_StudentID;
                    dr["DateTimeFrom"] = item.DateTimeFrom;
                    dr["DateTimeTo"] = item.DateTimeTo;
                    dr["CommunicationPlan"] = item.CommunicationPlan;
                    dr["IsActive"] = true;
                    dr["IsDeleted"] = false;
                    objDataTable.Rows.Add(dr);
                }

                List<SqlParameter> parms = new List<SqlParameter>()
                {
                     new SqlParameter("@PlannedCommunicationData",objDataTable),
                     new SqlParameter("@IsAdoptStudent",IsAdopt == "true" ? true:false),
                     
                };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[SiteUsers].[USP_AddEditPlannedCommunication]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessageMDL.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessageMDL.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //objMessageMDL.Message = (objMessageMDL.MessageId == 1)
                    //                      ? @GyanmitrasLanguages.LocalResources.Resource.RecordInserted
                    //                      : (objMessageMDL.MessageId == 2)
                    //                      ? @GyanmitrasLanguages.LocalResources.Resource.RecordUpdated
                    //                      : (objMessageMDL.MessageId == 3)
                    //                      ? @GyanmitrasLanguages.LocalResources.Resource.EmailExists
                    //                      : (objMessageMDL.MessageId == 4)
                    //                      ? @GyanmitrasLanguages.LocalResources.Resource.MobileNoExist
                    //                      : (objMessageMDL.MessageId == 5)
                    //                      ? @GyanmitrasLanguages.LocalResources.Resource.AccountAlreadyExist
                    //                      : (objMessageMDL.MessageId == 6)
                    //                      ? @GyanmitrasLanguages.LocalResources.Resource.UserAlreadyExist

                    //                      : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "");
            }
            return objMessageMDL;
        }

    }
}
