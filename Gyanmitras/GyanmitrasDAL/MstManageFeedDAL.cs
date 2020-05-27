using GyanmitrasDAL.Common;
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
    public class MstManageFeedDAL
    {

        #region
        static DataFunctions objDataFunctions = null;
        System.Data.DataSet objDataSet = null;
        static string _commandText = string.Empty;
        #endregion
        public MstManageFeedDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-Get details of ManageFeed
        /// </summary>
        /// <param name="_ManageFeedlist"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="objTotalCountPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="userid"></param>
        /// <param name="rowPerpage"></param>
        /// <param name="currentPage"></param>
        /// <param name="searchBy"></param>
        /// <param name="searchValue"></param>
        /// <returns></returns>

        public bool GetManageFeed(out List<MstManageFeedMDL> _ManageFeedlist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int rowPerpage, int currentPage, string searchBy, string searchValue)
        {
            bool result = false;
            objBasicPagingMDL = new BasicPagingMDL();
            _ManageFeedlist = new List<MstManageFeedMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            System.Data.DataSet objDataSet = null;
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@PK_FeedID",id),
                    new SqlParameter("@iRowperPage",rowPerpage),
                    new SqlParameter("@iCurrentPage",currentPage),
                    new SqlParameter("@cSearchBy",searchBy),
                    new SqlParameter("@cSearchValue",searchValue),
                    new SqlParameter("@UserId",userid),
                    new SqlParameter("@cLoginType",""),

                };

                _commandText = "[SiteUsers].[UST_GetFeedDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {

                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _ManageFeedlist = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstManageFeedMDL()
                        {
                            PK_FeedID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_FeedID")),
                            FK_UserID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_UserID")),
                            FK_CategoryID = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CategoryID")),
                            UserName = dr.Field<string>("UserName"),
                            CategoryName = dr.Field<string>("CategoryName"),
                            FK_AreaOfInterest = dr.Field<string>("FK_AreaOfInterest"),
                            FeedSubject = dr.Field<string>("FeedSubject"),
                            FeedDescription = dr.Field<string>("FeedDescription"),
                            MediaType = dr.Field<string>("MediaType"),
                            VideoUrl = dr.Field<string>("VideoUrl"),
                            ResourceFileName = dr.Field<string>("ResourceFile"),
                            CreatedBy = dr.Field<Int64>("CreatedBy"),
                            CreatedDateTime = dr.Field<string>("CreatedDateTime"),
                            IsActive = dr.Field<bool>("IsActive"),
                            IsDeleted = dr.Field<bool>("IsDeleted"),
                          

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
        /// Purpose-Insert  details of ManageFeed
        /// </summary>
        /// <param name="objManageFeedMasterMDL"></param>
        /// <returns></returns>
        public MessageMDL AddEditManageFeed(MstManageFeedMDL objManageFeedMasterMDL)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[SiteUsers].[USP_AddEditFeed]";
            List<SqlParameter> parms = new List<SqlParameter>
               {
                new SqlParameter("@PK_FeedID" , objManageFeedMasterMDL.PK_FeedID),
                new SqlParameter("@FK_UserID" , objManageFeedMasterMDL.FK_UserID),
                new SqlParameter("@FeedSubject" , objManageFeedMasterMDL.FeedSubject),
                new SqlParameter("@FeedDescription" , objManageFeedMasterMDL.FeedDescription),
                new SqlParameter("@MediaType" , objManageFeedMasterMDL.MediaType),
                new SqlParameter("@VideoUrl" , objManageFeedMasterMDL.VideoUrl),
                new SqlParameter("@ResourceFile" , objManageFeedMasterMDL.ResourceFileName),
                new SqlParameter("@CreatedBy" , objManageFeedMasterMDL.CreatedBy),
                new SqlParameter("@IsActive" , objManageFeedMasterMDL.IsActive),
                new SqlParameter("@IsDeleted",objManageFeedMasterMDL.IsDeleted)
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
                    //GyanmitrasLanguages.LocalResources.Resource.ManageFeedInActive : GyanmitrasLanguages.LocalResources.Resource.ManageFeedName + " " + GyanmitrasLanguages.LocalResources.Resource.AlreadyExists);

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
        /// Purpose-Delete ManageFeed Data
        /// </summary>
        /// <param name="PK_ManageFeedId"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>

        public MessageMDL DeleteManageFeed(Int64 PK_ManageFeedID, Int64 UserId)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@PK_FeedID", PK_ManageFeedID),
                new SqlParameter("@iUserId", UserId),
                };
                _commandText = "[SiteUsers].[USP_DeleteManageFeed]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //msg.Message = (msg.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.Deleted : @GyanmitrasLanguages.LocalResources.Resource.ExistManageFeed;

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
