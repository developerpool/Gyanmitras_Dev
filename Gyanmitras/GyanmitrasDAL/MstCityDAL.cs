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
    public class MstCityDAL
    {

        #region
        static DataFunctions objDataFunctions = null;
        System.Data.DataSet objDataSet = null;
        static string _commandText = string.Empty;
        #endregion
        public MstCityDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose- Get details of City 
        /// </summary>
        /// <param name="_CityList"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="objTotalCountPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="userid"></param>
        /// <param name="rowPerpage"></param>
        /// <param name="currentPage"></param>
        /// <param name="searchBy"></param>
        /// <param name="searchValue"></param>
        /// <returns></returns>
        public bool getCity(out List<MstCityMDL> _CityList, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int rowPerpage, int currentPage, string searchBy, string searchValue)
        {
            bool result = false;
            _CityList = new List<MstCityMDL>();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            System.Data.DataSet objDataSet = null;
            objBasicPagingMDL = new BasicPagingMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
                {
                    new SqlParameter("@iPK_CityId",id),
                    new SqlParameter("@iRowperPage",rowPerpage),
                    new SqlParameter("@iCurrentPage",currentPage),
                    new SqlParameter("@cSearchBy",searchBy),
                    new SqlParameter("@cSearchValue",searchValue),
                    new SqlParameter("@iUserId",userid),

                };

                _commandText = "[dbo].[USP_GetCityDetails]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {

                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _CityList = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstCityMDL()
                    {
                        Pk_CityId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("PK_CityId")),
                        Fk_CountryId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_CountryId")),
                        Fk_StateId = WrapDbNull.WrapDbNullValue<Int64>(dr.Field<Int64?>("FK_StateId")),
                        StateName = dr.Field<string>("StateName"),
                        CountryName = dr.Field<string>("CountryName"),
                        IsActive = dr.Field<bool>("IsActive"),
                        CityName= dr.Field<string>("CityName"),
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
        /// Purpose-Insert  details of City 
        /// </summary>
        /// <param name="objCityMasterMDL"></param>
        /// <returns></returns>
        public MessageMDL AddEditCity(MstCityMDL objCityMasterMDL)
        {
            MessageMDL objMessages = new MessageMDL();
            _commandText = "[dbo].[USP_AddEditCity]";
            List<SqlParameter> parms = new List<SqlParameter>
               {
                new SqlParameter("@iPK_CityId" , objCityMasterMDL.Pk_CityId),
                new SqlParameter("@iFK_CountryId" , objCityMasterMDL.Fk_CountryId),
                new SqlParameter("@iFK_StateId" , objCityMasterMDL.Fk_StateId),
                new SqlParameter("@cCityName" , objCityMasterMDL.CityName),
                new SqlParameter("@bIsActive" , objCityMasterMDL.IsActive),
                new SqlParameter("@iUserId",objCityMasterMDL.CreatedBy)
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
                     GyanmitrasLanguages.LocalResources.Resource.RecordUpdated : GyanmitrasLanguages.LocalResources.Resource.CityName + " " + GyanmitrasLanguages.LocalResources.Resource.AlreadyExists);
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
        /// Purpose-Delete City Data 
        /// </summary>
        /// <param name="PK_CityId"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>

        public MessageMDL DeleteCity(Int64 PK_CityId, Int64 UserId)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@iPK_CityId", PK_CityId),
                new SqlParameter("@iUserId", UserId),
                };
                _commandText = "[dbo].[USP_DeleteCity]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = objDataSet.Tables[0].Rows[0].Field<string>("Message");
                    msg.Message = (msg.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.Deleted : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;

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
