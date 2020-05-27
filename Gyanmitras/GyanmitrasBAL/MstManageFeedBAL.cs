using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
    public class MstManageFeedBAL
    {
        MstManageFeedDAL objManageFeedMasterDAL = null;
        public MstManageFeedBAL()
        {
            objManageFeedMasterDAL = new MstManageFeedDAL();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-Get details of ManageFeed
        /// </summary>
        /// <returns></returns>
        public bool GetManageFeed(out List<MstManageFeedMDL> _ManageFeedlist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue)

        {
            return objManageFeedMasterDAL.GetManageFeed(out _ManageFeedlist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, userid, RowPerpage, CurrentPage, SearchBy, SearchValue);
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
            return objManageFeedMasterDAL.AddEditManageFeed(objManageFeedMasterMDL);
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

            return objManageFeedMasterDAL.DeleteManageFeed(PK_ManageFeedID, UserId);
        }

    }
}
