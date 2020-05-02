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
    public class MstStateDAL
    {

        #region
        static DataFunctions objDataFunctions = null;
        System.Data.DataSet objDataSet = null;
        static string _commandText = string.Empty;
        #endregion
        public MstStateDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose-Get details of State
        /// </summary>
        /// <param name="_StateList"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="objTotalCountPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <param name="rowPerpage"></param>
        /// <param name="currentPage"></param>
        /// <param name="searchBy"></param>
        /// <param name="searchValue"></param>
        /// <returns></returns>
        public bool getState(out List<MstStateMDL> _StateList, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userId, int rowPerpage, int currentPage, string searchBy, string searchValue)
        {
            bool result = false;
            objBasicPagingMDL = new BasicPagingMDL();
            _StateList = new List<MstStateMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            System.Data.DataSet objDataSet = null;
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iPK_StateId",id),
                    new SqlParameter("@iRowperPage",rowPerpage),
                    new SqlParameter("@iCurrentPage",currentPage),
                    new SqlParameter("@cSearchBy",searchBy),
                    new SqlParameter("@cSearchValue",searchValue),
                    new SqlParameter("@iUserID",userId),

                };

                _commandText = "[dbo].[USP_GetStateDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {

                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _StateList = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstStateMDL()
                        {
                            Pk_StateId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_StateId")),
                            Fk_CountryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CountryId")),
                            StateName = dr.Field<string>("StateName"),
                            CountryName = dr.Field<string>("CountryName"),
                            IsActive = dr.Field<bool>("IsActive"),
                            Status = dr.Field<string>("Status"),
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
                //if (objDataSet.Tables[2].Rows.Count > 0)
                //{
                //    objTotalCountPagingMDL = new TotalCountPagingMDL()
                //    {
                //        TotalItem = objDataSet.Tables[2].Rows[0].Field<int>("TotalItem"),
                //        TotalActive = objDataSet.Tables[2].Rows[0].Field<int>("TotalActive"),
                //        TotalInactive = objDataSet.Tables[2].Rows[0].Field<int>("TotalInActive"),
                //        ThisMonth = objDataSet.Tables[2].Rows[0].Field<int>("TotalCurrentMonth")
                //    };
                //}
            }
            catch (Exception e)
            {
                result = false;
            }
            return result;
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose-Insert  details of State
        /// </summary>
        /// <param name="objStateMasterMDL"></param>
        /// <returns></returns>
        public MessageMDL AddEditState(MstStateMDL objStateMasterMDL)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[dbo].[USP_AddEditState]";
            List<SqlParameter> parms = new List<SqlParameter>
               {
                new SqlParameter("@iPK_StateId" , objStateMasterMDL.Pk_StateId),
                new SqlParameter("@iFK_CountryId" , objStateMasterMDL.Fk_CountryId),
                new SqlParameter("@cStateName" , objStateMasterMDL.StateName),
                new SqlParameter("@bIsActive" , objStateMasterMDL.IsActive),
                new SqlParameter("@iUserId",objStateMasterMDL.CreatedBy)
              };
            try
            {
                CheckParameters.ConvertNullToDBNull(parms);
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    objMessages.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    objMessages.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    objMessages.Message = (objMessages.MessageId == 1 ? objMessages.Message = GyanmitrasLanguages.LocalResources.Resource.RecordInserted : objMessages.MessageId == 2 ?
                    GyanmitrasLanguages.LocalResources.Resource.RecordUpdated:
                      objMessages.MessageId == 3 ?
                    GyanmitrasLanguages.LocalResources.Resource.StateInActive : GyanmitrasLanguages.LocalResources.Resource.StateExists);
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
        /// Date-22/12/2019
        /// Purpose-Delete State Data
        /// </summary>
        /// <param name="PK_StateId"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>


        public MessageMDL DeleteState(Int64 PK_StateId, Int64 UserId)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@iPK_StateId", PK_StateId),
                new SqlParameter("@iUserId", UserId),
                };
                _commandText = "[dbo].[USP_DeleteState]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    msg.Message = (msg.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.Deleted : @GyanmitrasLanguages.LocalResources.Resource.ExistState;
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
