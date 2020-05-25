﻿using GyanmitrasDAL.Common;
using GyanmitrasDAL.DataUtility;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace GyanmitrasDAL
{
    public class MstManageFeedBackDAL
    {

        #region
        static DataFunctions objDataFunctions = null;
        System.Data.DataSet objDataSet = null;
        static string _commandText = string.Empty;
        #endregion
        public MstManageFeedBackDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-Get details of ManageFeedBack
        /// </summary>
        /// <param name="_ManageFeedBacklist"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="objTotalCountPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="userid"></param>
        /// <param name="rowPerpage"></param>
        /// <param name="currentPage"></param>
        /// <param name="searchBy"></param>
        /// <param name="searchValue"></param>
        /// <returns></returns>

        public bool GetFeedBackCriteria(out List<MstFeedBackCriteriaMDL> _ManageFeedBacklist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int rowPerpage, int currentPage, string searchBy, string searchValue)
        {
            bool result = false;
            objBasicPagingMDL = new BasicPagingMDL();
            _ManageFeedBacklist = new List<MstFeedBackCriteriaMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            System.Data.DataSet objDataSet = null;
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@PK_FeedBackCriteriaID",id),
                    new SqlParameter("@iRowperPage",rowPerpage),
                    new SqlParameter("@iCurrentPage",currentPage),
                    new SqlParameter("@cSearchBy",searchBy),
                    new SqlParameter("@cSearchValue",searchValue),
                    new SqlParameter("@iUserId",userid),

                };

                _commandText = "[SiteUsers].[USP_GetManageFeedBackCriteriaDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {

                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _ManageFeedBacklist = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstFeedBackCriteriaMDL()
                        {
                            PK_FeedBackCriteriaID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_FeedBackCriteriaID")),
                            FK_SiteUserCategoryID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_SiteUserCategoryID")),
                            FeedbackCriteria = dr.Field<string>("FeedbackCriteria"),
                            IsActive = dr.Field<bool>("IsActive"),
                            IsDeleted = dr.Field<bool>("IsDeleted"),
                            MarkCriteria_Yes = dr.Field<int>("MarkCriteria_Yes"),
                            MarkCriteria_No = dr.Field<int>("MarkCriteria_No"),
                            Status = dr.Field<string>("Status"),
                            CreatedDateTime = dr.Field<string>("CreatedDateTime"),
                            SiteUserCategory = dr.Field<string>("SiteUserCategory"),

                        }).ToList();


                        objBasicPagingMDL = new BasicPagingMDL()
                        {
                            TotalItem = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalItem")),
                            RowParPage = rowPerpage,
                            CurrentPage = currentPage
                        };
                        objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage;
                        if (objBasicPagingMDL.TotalItem % objBasicPagingMDL.RowParPage == 0)
                        {
                            objBasicPagingMDL.TotalPage++;
                        }
                        objBasicPagingMDL = new BasicPagingMDL()
                        {
                            TotalItem = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalItem")),
                            RowParPage = rowPerpage,
                            CurrentPage = currentPage
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
                    objTotalCountPagingMDL = new TotalCountPagingMDL()
                    {
                        TotalItem = objDataSet.Tables[2].Rows[0].Field<int>("TotalItem"),
                        TotalActive = objDataSet.Tables[2].Rows[0].Field<int>("TotalActive"),
                        TotalInactive = objDataSet.Tables[2].Rows[0].Field<int>("TotalInActive"),
                        ThisMonth = objDataSet.Tables[2].Rows[0].Field<int>("TotalCurrentMonth")
                    };
                }
            }
            catch (Exception e)
            {
                result = false;
            }
            return result;
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-Insert  details of ManageFeedBack
        /// </summary>
        /// <param name="objManageFeedBackMasterMDL"></param>
        /// <returns></returns>
        public MessageMDL AddEditFeedBackCriteria(MstFeedBackCriteriaMDL objManageFeedBackMasterMDL)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[SiteUsers].[USP_AddEditManageFeedBackCriteria]";
            List<SqlParameter> parms = new List<SqlParameter>
               {
                new SqlParameter("@PK_FeedBackCriteriaID" , objManageFeedBackMasterMDL.PK_FeedBackCriteriaID),
                new SqlParameter("@FK_SiteUserCategoryID" , objManageFeedBackMasterMDL.FK_SiteUserCategoryID),
                new SqlParameter("@FeedbackCriteria" , objManageFeedBackMasterMDL.FeedbackCriteria),
                new SqlParameter("@MarkCriteria_Yes" , objManageFeedBackMasterMDL.MarkCriteria_Yes),
                new SqlParameter("@MarkCriteria_No" , objManageFeedBackMasterMDL.MarkCriteria_No),
                new SqlParameter("@IsActive" , objManageFeedBackMasterMDL.IsActive),
                new SqlParameter("@CreatedBy",objManageFeedBackMasterMDL.CreatedBy)
              };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //objMessages.Message = (objMessages.MessageId == 1 ? objMessages.Message = GyanmitrasLanguages.LocalResources.Resource.RecordInserted : objMessages.MessageId == 2 ?
                    //GyanmitrasLanguages.LocalResources.Resource.RecordUpdated :
                    // objMessages.MessageId == 3 ?
                    //GyanmitrasLanguages.LocalResources.Resource.ManageFeedBackInActive : GyanmitrasLanguages.LocalResources.Resource.ManageFeedBackName + " " + GyanmitrasLanguages.LocalResources.Resource.AlreadyExists);

                }
                else
                {
                    objMessages.MessageId = 0;
                    objMessages.Message = "Failed";
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return objMessages;
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-Delete ManageFeedBack Data
        /// </summary>
        /// <param name="PK_ManageFeedBackId"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>

        public MessageMDL DeleteFeedBackCriteria(Int64 PK_FeedBackCriteriaID, Int64 UserId)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@PK_FeedBackCriteriaID", PK_FeedBackCriteriaID),
                new SqlParameter("@iUserId", UserId),
                };
                _commandText = "[SiteUsers].[USP_DeleteFeedBackCriteria]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //msg.Message = (msg.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.Deleted : @GyanmitrasLanguages.LocalResources.Resource.ExistManageFeedBack;

                }
            }
            catch (Exception e)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, e.Message, "ADDITIONAL REMARKS");
            }

            return msg;
        }

    }
}
