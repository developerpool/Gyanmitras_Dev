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
   public class MapFormRoleDAL
    {
        #region
        DataFunctions objDataFunctions = null;
        DataTable objDataTable = null;
        DataSet objDataSet = null;
        string _commandText = string.Empty;

        #endregion


        public MapFormRoleDAL()
        {
            objDataFunctions = new DataFunctions();
        }


        /// <summary>
        /// To Bind Sub Menu's
        /// </summary>
        /// <param name="_FormRoleMappinglist"></param>
        /// <param name="FK_RoleId"></param>
        /// <param name="FK_FormId"></param>
        /// <returns></returns>
        public bool BindSubMenu(out List<RoleMapping> _FormRoleMappinglist, Int64 FK_RoleId, Int64 FK_FormId, string MappingFor, Int64 FK_CompanyId)
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
                new SqlParameter("@iFK_CompanyId", FK_CompanyId),



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
        public MessageMDL SaveRoleMapping(RoleMapping item, Int64 UserId, string MappingFor)
        {
            MessageMDL msg = new MessageMDL();

            try
            {
                List<SqlParameter> parms = new List<SqlParameter>()
            {
                //new SqlParameter("@jsonFormRoleAddEdit", JsonData),
                 new SqlParameter("@FK_FormId", item.FK_FormId)
                ,new SqlParameter("@FK_RoleId", item.FK_RoleId)
                ,new SqlParameter("@CanAdd", item.CanAdd)
                ,new SqlParameter("@CanEdit", item.CanEdit)
                ,new SqlParameter("@CanDelete", item.CanDelete)
                ,new SqlParameter("@CanView", item.CanView)
                ,new SqlParameter("@IsActive", 1)
                //,new SqlParameter("@IsDeleted", 0)
                ,new SqlParameter("@CreatedBy", UserId)

                //new SqlParameter("@cMappingFor", MappingFor)


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

    }
}
