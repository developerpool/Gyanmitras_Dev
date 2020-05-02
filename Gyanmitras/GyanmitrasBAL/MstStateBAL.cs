using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
   public   class MstStateBAL
    {
        MstStateDAL objStateMasterDAL = null;
        public MstStateBAL()
        {
            objStateMasterDAL = new MstStateDAL();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose-Get details of State
        /// </summary>
        /// <param name="_Statelist"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="objTotalCountPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="userid"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <param name="CreatedBy"></param>
        /// <param name="FK_CompanyId"></param>
        /// <returns></returns>
        public bool getState(out List<MstStateMDL> _Statelist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 CreatedBy, int FK_CompanyId)
        { 
            _Statelist = new List<MstStateMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            return objStateMasterDAL.getState(out _Statelist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, userid, RowPerpage, CurrentPage, SearchBy, SearchValue);
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
            return objStateMasterDAL.AddEditState(objStateMasterMDL);
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

            return objStateMasterDAL.DeleteState(PK_StateId, UserId);
        }

    }
}
