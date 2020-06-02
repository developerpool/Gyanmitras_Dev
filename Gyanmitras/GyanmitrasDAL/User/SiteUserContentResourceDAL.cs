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
    public class SiteUserContentResourceDAL
    {

        #region => Fields 
        static DataFunctions objDataFunctions = null;
        DataSet objDataSet = null;
        static string _commandText = string.Empty;
        #endregion

        /// <summary>
        /// Constructor functionality is used to initializes objects.
        /// </summary>
        public SiteUserContentResourceDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        /// <summary>
        /// CREATED DATE : 11 Dec 2019
        /// PURPOSE : Add and Edit SiteUserContentResource Master Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="SiteUserContentResourceDetails"></param>
        /// <returns></returns>
        public MessageMDL AddEditSiteUserContentResourceDetails(SiteUserContentResourceMDL SiteUserContentResourceDetails)
        {
            MessageMDL objMessages = new MessageMDL();
            try
            {
                _commandText = "[SiteUsers].[USP_AddEditContentResourcePage]";
                List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@PK_ContantResourceId",SiteUserContentResourceDetails.PK_ContantResourceId),
                    new SqlParameter("@FK_RoleId",SiteUserContentResourceDetails.FK_RoleId),
                    new SqlParameter("@FK_StateId",SiteUserContentResourceDetails.FK_StateId),
                    new SqlParameter("@FK_SearchCategoryId",SiteUserContentResourceDetails.FK_SearchCategoryId),
                    new SqlParameter("@FK_SubSearchCategoryId",SiteUserContentResourceDetails.FK_SubSearchCategoryId),
                    new SqlParameter("@Heading",SiteUserContentResourceDetails.Heading),
                    new SqlParameter("@Description", SiteUserContentResourceDetails.Description),
                    new SqlParameter("@ResourceType",SiteUserContentResourceDetails.ResourceType),
                    new SqlParameter("@ResourceFileName",SiteUserContentResourceDetails.ResourceFileName),
                    new SqlParameter("@IsActive",SiteUserContentResourceDetails.IsActive),
                    new SqlParameter("@IsDeleted",SiteUserContentResourceDetails.IsDeleted),
                    new SqlParameter("@CreatedBy",SiteUserContentResourceDetails.CreatedBy),
                    new SqlParameter("@ResourceBy",SiteUserContentResourceDetails.ResourceAddedBy)
                    
                };
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    //objMessages.Message = (objMessages.MessageId == 1 ? objMessages.Message = GyanmitrasLanguages.LocalResources.Resource.RecordInserted : objMessages.MessageId == 2 ?
                    //GyanmitrasLanguages.LocalResources.Resource.RecordUpdated : GyanmitrasLanguages.LocalResources.Resource.SiteUserContentResourceName + " " + GyanmitrasLanguages.LocalResources.Resource.AlreadyExists);

                }
                else
                {
                    objMessages.MessageId = 0;
                    objMessages.Message = GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
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
        /// CREATED DATE : 11 Dec 2019
        /// PURPOSE : Get SiteUserContentResource Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="id"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        public bool GetSiteUserContentResourcesDetails(out List<SiteUserContentResourceMDL> _SiteUserContentResourceMasterlist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 FK_StateId = 0, Int64 FK_AcademicGroupId = 0, Int64 FK_BenifitTypeId = 0)
        {
            bool result = false;
            objBasicPagingMDL = new BasicPagingMDL();
            _SiteUserContentResourceMasterlist = new List<SiteUserContentResourceMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            _commandText = "[SiteUsers].[USP_GetContentResourcePageDetails]";
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@PK_ContantResourceId",id),
                    new SqlParameter("@iRowperPage",RowPerpage),
                    new SqlParameter("@iCurrentPage",CurrentPage),
                    new SqlParameter("@cSearchBy",SearchBy),
                    new SqlParameter("@cSearchValue",SearchValue),
                    new SqlParameter("@FK_StateId",FK_StateId),
                    new SqlParameter("@FK_AcademicGroupId",FK_AcademicGroupId),
                    new SqlParameter("@FK_BenifitTypeId",FK_BenifitTypeId),
                };
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {

                        _SiteUserContentResourceMasterlist = objDataSet.Tables[1].AsEnumerable().Select(dr => new SiteUserContentResourceMDL()
                        {
                            PK_ContantResourceId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_ContantResourceId")),
                            FK_RoleId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_RoleId")),
                            FK_StateId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_StateId")),
                            FK_SearchCategoryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_SearchCategoryId")),
                            FK_SubSearchCategoryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_SubSearchCategoryId")),

                            RoleName = dr.Field<string>("RoleName"),
                            StateName = dr.Field<string>("StateName"),
                            SearchCategoryName = dr.Field<string>("AcademicGroupName"),
                            SubSearchCategoryName = dr.Field<string>("BenifitTypeName"),

                            Heading = dr.Field<string>("Heading"),
                            Description = dr.Field<string>("Description"),
                            ResourceType = dr.Field<string>("ResourceType"),
                            ResourceFileName = dr.Field<string>("ResourceFileName"),
                            CreatedDateTime = dr.Field<string>("CreatedDateTime"),


                            IsActive = dr.Field<bool>("IsActive"),
                            Status = (dr.Field<bool>("IsActive") == true ? GyanmitrasLanguages.LocalResources.Resource.Active : GyanmitrasLanguages.LocalResources.Resource.Inactive)
                        }).ToList();

                        objBasicPagingMDL = new BasicPagingMDL()
                        {
                            TotalItem = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalItem")),
                            RowParPage = RowPerpage,
                            CurrentPage = CurrentPage
                        };
                        if (objBasicPagingMDL.TotalItem % objBasicPagingMDL.RowParPage == 0)
                        {
                            objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage;
                        }
                        else
                            objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage + 1;

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


                        objDataSet.Dispose();
                        result = true;
                    }
                    else
                    {
                        result = false;
                    }
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return result;
        }

        /// <summary>
        /// CREATED DATE : 12 Dec 2019
        /// PURPOSE : Delete SiteUserContentResource Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="SiteUserContentResourceID"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public MessageMDL DeleteSiteUserContentResourcesDetails(Int64 SiteUserContentResourceID, Int64 userId)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[SiteUsers].[USP_DeleteContantResourcePage]";
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@PK_ContantResourceId",SiteUserContentResourceID),
                    new SqlParameter ("@iUserId",userId),

                };
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objMessages.Message = (objMessages.MessageId == 1 ? GyanmitrasLanguages.LocalResources.Resource.Deleted : string.Empty);
                }
                else
                {
                    objMessages.MessageId = 0;
                    objMessages.Message = GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }

            return objMessages;
        }
    }
}
