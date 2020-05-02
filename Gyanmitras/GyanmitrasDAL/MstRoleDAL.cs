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
    public class MstRoleDAL
    {
        #region
        DataFunctions objDataFunctions = null;
        DataTable objDataTable = null;
        DataSet objDataSet = null;
        string _commandText = string.Empty;

        #endregion

        public MstRoleDAL()
        {
            objDataFunctions = new DataFunctions();
        }
        /// <summary>
        /// To Add Edit Role Details
        /// </summary>
        /// <param name="ObjMstRoleMDL"></param>
        /// <returns></returns>
        public MessageMDL AddEditRole(MstRoleMDL ObjMstRoleMDL)
        {
            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {

                 new SqlParameter("@iPK_RoleId", ObjMstRoleMDL.PK_RoleId),
                 new SqlParameter("@cRoleName", ObjMstRoleMDL.RoleName),
                 //new SqlParameter("@cRoleFor", ObjMstRoleMDL.RoleFor),
                 new SqlParameter("@iFK_AccountId", ObjMstRoleMDL.AccountId),
                 new SqlParameter("@iFK_CategoryId", ObjMstRoleMDL.FK_CategoryId),
                 new SqlParameter("@iHomePage", ObjMstRoleMDL.FK_FormId),
                 new SqlParameter("@bIsActive", ObjMstRoleMDL.IsActive),
                new SqlParameter("@iUserId", ObjMstRoleMDL.CreatedBy),

            };

                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "USP_AddEditRole";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = (msg.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.RoleAdded : (msg.MessageId == 2) ? @GyanmitrasLanguages.LocalResources.Resource.RoleUpdated : @GyanmitrasLanguages.LocalResources.Resource.RoleAlreadyExist;
                }
            }
            catch (Exception e)
            {
                msg.MessageId = 0;
                msg.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, objBase.Name, e.Message, "", "");
            }

            return msg;
        }
        /// <summary>
        /// To Get Role Details
        /// </summary>
        /// <param name="_RoleDetaillist"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="objTotalCountPagingMDL"></param>
        /// <param name="Id"></param>
        /// <param name="FK_AccountId"></param>
        /// <param name="UserId"></param>
        /// <param name="RecordsPerPage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        public bool getRole(out List<MstRoleMDL> _RoleDetaillist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, Int64 Id, Int64 FK_CompanyId, Int64 UserId, int RecordsPerPage, string LogInType, int CurrentPage, string SearchBy, string SearchValue)
        {
            bool result = false;
            _RoleDetaillist = new List<MstRoleMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            objTotalCountPagingMDL = new TotalCountPagingMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@iPK_RoleId", Id),
                new SqlParameter("@iRowperPage", RecordsPerPage),
                new SqlParameter("@iCurrentPage", CurrentPage),
                new SqlParameter("@cSearchBy", SearchBy),
                new SqlParameter("@cSearchValue", SearchValue),
                new SqlParameter("@iFK_CompanyId", FK_CompanyId),
                new SqlParameter("@iUserId", UserId),
                new SqlParameter("@cLogInType",LogInType),

            };

                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "USP_GetRoleDetails";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);


                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    if (objDataSet.Tables[0].Rows[0].Field<int>("Message_Id") == 1)
                    {
                        _RoleDetaillist = objDataSet.Tables[1].AsEnumerable().Select(dr => new MstRoleMDL()
                        {
                            PK_RoleId = dr.Field<Int64>("PK_Roleid"),
                            RoleName = dr.Field<string>("RoleName"),
                            RoleFor = dr.Field<string>("RoleFor"),
                            FK_CompanyId = dr.Field<Int64>("FK_CompanyId"),
                            CompanyName = dr.Field<string>("CompanyName"),
                            FormName = dr.Field<string>("FormName"),
                            IsActive = dr.Field<bool>("IsActive"),
                            Status = dr.Field<string>("Status"),
                            CreatedDatetime = dr.Field<string>("CreatedDateTime"),
                            FK_FormId = dr.Field<Int64>("HomePage"),
                            AccountId = dr.Field<Int64>("FK_AccountId"),
                            RoleForId = dr.Field<Int64>("PK_Roleid"),
                            FK_CategoryId = dr.Field<Int64>("FK_CategoryId")
                            //VehicleSpecificStatus = dr.Field<string>("VehSpecificStatus"),
                            //IsVehicleSpecific = WrapDbNull.WrapDbNullValue<bool>(dr.Field<bool>("IsMachineSpecific"))
                        }).ToList();

                        objBasicPagingMDL = new BasicPagingMDL()
                        {
                            TotalItem = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalItem")),
                            RowParPage = RecordsPerPage,
                            CurrentPage = CurrentPage
                        };
                        if (objBasicPagingMDL.TotalItem % objBasicPagingMDL.RowParPage == 0)
                        {
                            objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage;
                        }
                        else
                        {
                            objBasicPagingMDL.TotalPage = objBasicPagingMDL.TotalItem / objBasicPagingMDL.RowParPage + 1;
                        }

                        objTotalCountPagingMDL = new TotalCountPagingMDL()
                        {
                            TotalItem = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalItem")),
                            TotalActive = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalActive")),
                            TotalInactive = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalInactive")),
                            ThisMonth = WrapDbNull.WrapDbNullValue<int>(objDataSet.Tables[2].Rows[0].Field<int?>("TotalCurrentMonth"))
                        };

                        objDataSet.Dispose();
                        result = true;
                    }
                    else
                    {
                        result = false;
                    }
                }
            }
            catch (Exception e)
            {
                // msg.Message = EBuddeeLanguages.LocalResources.Resource.ProcessFailed;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, objBase.Name, e.Message, "", "");

            }

            return result;
        }
        /// <summary>
        /// To Bind Sub Menu's
        /// </summary>
        /// <param name="_FormRoleMappinglist"></param>
        /// <param name="FK_RoleId"></param>
        /// <param name="FK_FormId"></param>
        /// <returns></returns>
        public bool BindSubMenu(out List<RoleMapping> _FormRoleMappinglist, Int64 FK_RoleId, Int64 FK_FormId, string MappingFor, Int64 FK_AccountId, Int64 FK_CustomerId)
        {
            bool result = false;
            _FormRoleMappinglist = new List<RoleMapping>();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {

                new SqlParameter("@iPK_RoleId", FK_RoleId),
                new SqlParameter("@iPK_FormId", FK_FormId),
                new SqlParameter("@cMappingFor", MappingFor),
                new SqlParameter("@iAccountId", FK_AccountId),
                new SqlParameter("@iCustomerId", FK_CustomerId),



            };
                CheckParameters.ConvertNullToDBNull(parms);
                _commandText = "[dbo].[USP_GetRoleFormMappingWithFormId]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    _FormRoleMappinglist = objDataSet.Tables[0].AsEnumerable().Select(dr => new RoleMapping()
                    {
                        FK_FormId = dr.Field<Int64>("FK_FormId"),
                        FormName = dr.Field<string>("FormName"),
                        CanAdd = dr.Field<bool>("CanAdd"),
                        CanEdit = dr.Field<bool>("CanEdit"),
                        CanView = dr.Field<bool>("CanView"),
                        CanDelete = dr.Field<bool>("CanDelete"),
                        FK_Sort_Id = dr.Field<int>("SortId"),
                        FK_ParentId = dr.Field<Int64>("FK_ParentId"),
                        FK_RoleId = dr.Field<Int64>("FK_RoleId"),
                        PK_FormRoleId = dr.Field<Int64>("PK_FormRoleId"),

                    }).ToList();
                    _FormRoleMappinglist.ForEach(m =>
                    {
                        m.CanAll = (m.CanAdd == true && m.CanEdit == true && m.CanDelete == true && m.CanView == true) ? true : false;
                    });
                }
            }
            catch (Exception e)
            {

                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, objBase.Name, e.Message, "", "");
            }

            return result;

        }
        /// <summary>
        /// To Save Form Role Mapping
        /// </summary>
        /// <param name="JsonData"></param>
        /// <param name="UserId"></param>
        /// <param name="MappingFor"></param>
        /// <returns></returns>
        public MessageMDL SaveRoleMapping(string JsonData, Int64 UserId, string MappingFor)
        {
            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@jsonFormRoleAddEdit", JsonData),
                new SqlParameter("@cMappingFor", MappingFor)


            };
                _commandText = "[dbo].[USP_MapFormRoleAddEdit]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);

                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = (msg.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.FormRoleUpdated : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                }
            }
            catch (Exception e)
            {
                msg.MessageId = 0;
                msg.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, objBase.Name, e.Message, "", "");

            }
            return msg;
        }
        /// <summary>
        /// To Delete Role Details
        /// </summary>
        /// <param name="PK_RoleId"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public MessageMDL DeleteRole(Int64 PK_RoleId, Int64 UserId)
        {

            MessageMDL msg = new MessageMDL();
            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                new SqlParameter("@iPK_RoleId", PK_RoleId),
                new SqlParameter("@iUserId", UserId),
                };
                _commandText = "[dbo].[USP_DeleteRoleName]";
                objDataSet = (DataSet)objDataFunctions.getQueryResult(_commandText, DataReturnType.DataSet, parms);
                if (objDataSet.Tables[0].Rows.Count > 0)
                {
                    msg.MessageId = objDataSet.Tables[0].Rows[0].Field<int>("Message_Id");
                    msg.Message = (msg.MessageId == 1) ? @GyanmitrasLanguages.LocalResources.Resource.RoleDeleted : (msg.MessageId == 2) ? @GyanmitrasLanguages.LocalResources.Resource.DeleteAdminRole : @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;

                }
            }
            catch (Exception e)
            {
                msg.MessageId = 0;
                msg.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, objBase.Name, e.Message, "", "");

            }

            return msg;
        }
    }
}
