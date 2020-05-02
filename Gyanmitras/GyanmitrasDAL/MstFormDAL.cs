using GyanmitrasDAL.DataUtility;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using GyanmitrasLanguages;
using GyanmitrasDAL.Common;

namespace GyanmitrasDAL
{
    public class MstFormDAL
    {
        #region => Fields 
        static DataFunctions objDataFunctions = null;
        DataSet objDataSet = null;
        static string _commandText = string.Empty;
        #endregion

        /// <summary>
        /// Constructor functionality is used to initializes objects.
        /// </summary>
        public MstFormDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        /// <summary>
        /// CREATED DATE : 11 Dec 2019
        /// PURPOSE : Add and Edit Form Master Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="formDetails"></param>
        /// <returns></returns>
        public MessageMDL AddEditFormDetails(MstFormMDL formDetails)
        {
            MessageMDL objMessages = new MessageMDL();
            try
            {
                _commandText = "[dbo].[USP_AddEditForm]";
                List<SqlParameter> parms = new List<SqlParameter>
                {
                    new SqlParameter("@iPK_FormId",formDetails.Pk_FormId),
                    new SqlParameter("@cFormName",formDetails.FormName),
                    new SqlParameter("@cControllerName",formDetails.ControllerName==null?"":formDetails.ControllerName.Trim()),
                    new SqlParameter("@cActionName",formDetails.ActionName==null?"":formDetails.ActionName.Trim()),
                    new SqlParameter("@iFK_ParentId",formDetails.ParentId),
                    new SqlParameter("@iFK_SolutionId",formDetails.SolutionId),
                    new SqlParameter("@cClassName", formDetails.ClassName==null?"":formDetails.ClassName.Trim()),
                    new SqlParameter("@cArea",formDetails.Area==null?"":formDetails.Area.Trim()),
                    new SqlParameter("@bIsActive",formDetails.IsActive),
                    new SqlParameter("@iUserId",formDetails.UserId),
                    new SqlParameter("@cImageName",formDetails.Image),
                    new SqlParameter("@cPlatFormType",formDetails.PlatFormType)
                };
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message =(objMessages.MessageId==1? objMessages.Message = GyanmitrasLanguages.LocalResources.Resource.RecordInserted: objMessages.MessageId == 2 ? 
                    GyanmitrasLanguages.LocalResources.Resource.RecordUpdated: GyanmitrasLanguages.LocalResources.Resource.FormName + " " + GyanmitrasLanguages.LocalResources.Resource.AlreadyExists) ;
                    
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
        /// CREATED DATE : 12 Dec 2019
        /// PURPOSE : Get All Parent Form Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <returns></returns>
        public List<MstFormMDL> GetAllParentForm()
        {
            List<MstFormMDL> parentForm = new List<MstFormMDL>();
            _commandText = "[dbo].[USP_GetParentForms]";
            try
            {
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet);
                if (objDataSet != null)
                {
                    parentForm = objDataSet.Tables[1].AsEnumerable().Select(r => new MstFormMDL()
                    {
                        ParentId = r.Field<Int64>("Pk_FormId"),
                        ParentForm = r.Field<string>("FormName")

                    }).ToList();
                    objDataSet.Dispose();
                }
            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return parentForm;
        }

        /// <summary>
        /// CREATED DATE : 11 Dec 2019
        /// PURPOSE : Get Form Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="id"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        public bool GetFormsDetails(out List<MstFormMDL> _FormMasterlist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue)
        {
            bool result = false;
            objBasicPagingMDL = new BasicPagingMDL();
            _FormMasterlist = new List<MstFormMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            _commandText = "[dbo].[USP_GetFormDetails]";
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iPK_FormId",id),
                    new SqlParameter("@iRowperPage",RowPerpage),
                    new SqlParameter("@iCurrentPage",CurrentPage),
                    new SqlParameter("@cSearchBy",SearchBy),
                    new SqlParameter("@cSearchValue",SearchValue)
                };
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {

                        _FormMasterlist = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstFormMDL()
                        {
                            Pk_FormId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_FormId")),
                            FormName = dr.Field<string>("FormName"),
                            ControllerName = dr.Field<string>("ControllerName"),
                            ActionName = dr.Field<string>("ActionName"),
                            ParentId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_ParentId")),
                            ParentForm = dr.Field<string>("parentform"),
                            SolutionId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_SolutionId")),
                            SolutionName = dr.Field<string>("SolutionName"),
                            ClassName = dr.Field<string>("ClassName"),
                            Area = dr.Field<string>("Area"),
                            IsActive = dr.Field<bool>("IsActive"),
                            Status = (dr.Field<bool>("IsActive") == true ? GyanmitrasLanguages.LocalResources.Resource.Active : GyanmitrasLanguages.LocalResources.Resource.Inactive),
                            PlatFormType=dr.Field<string>("FormFor")
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
        /// PURPOSE : Delete Form Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="formID"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public MessageMDL DeleteFormsDetails(Int64 formID, Int64 userId)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[dbo].[USP_DeleteForm]";
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iPK_FormId",formID),
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
