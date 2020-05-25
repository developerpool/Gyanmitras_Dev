using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
    public class MstManageFeedBackBAL
    {
        MstManageFeedBackDAL objManageFeedBackMasterDAL = null;
        public MstManageFeedBackBAL()
        {
            objManageFeedBackMasterDAL = new MstManageFeedBackDAL();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-Get details of ManageFeedBack
        /// </summary>
        /// <returns></returns>
        public bool GetFeedBackCriteria(out List<MstFeedBackCriteriaMDL> _ManageFeedBacklist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue)

        {
            return objManageFeedBackMasterDAL.GetFeedBackCriteria(out _ManageFeedBacklist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, userid, RowPerpage, CurrentPage, SearchBy, SearchValue);
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
            return objManageFeedBackMasterDAL.AddEditFeedBackCriteria(objManageFeedBackMasterMDL);
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

            return objManageFeedBackMasterDAL.DeleteFeedBackCriteria(PK_FeedBackCriteriaID, UserId);
        }

    }
}
