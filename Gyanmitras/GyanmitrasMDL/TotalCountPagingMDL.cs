using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
    public class TotalCountPagingMDL
    {
        /*Start properties For Display upper Div*/
        public int TotalItem { get; set; }
        public bool IsTotalItem { get; set; }
        public int TotalActive { get; set; }
        public bool IsTotalActive { get; set; }
        public int TotalInactive { get; set; }
        public bool IsTotalInactive { get; set; }
        public int ThisMonth { get; set; }
        public bool IsThisMonth { get; set; }
        public int LastMonth { get; set; }
        public bool IsLastMonth { get; set; }
        public int TotalExpiredMonth { get; set; }
        public bool IsTotalExpiredMonth { get; set; }
        public int TotalExpiredSoonMonth { get; set; }
        public bool IsTotalExpiredSoonMonth { get; set; }
        public int PendingReplyUsers { get; set; }
        public bool IsPendingReplyUsers { get; set; }
        public int RemovedUsers { get; set; }
        public bool IsRemovedUsers { get; set; }
        public int ApprovedCounselor { get; set; }
        public bool IsApprovedCounselor { get; set; }
        public int ManageFeedBack { get; set; }
        public bool IsManageFeedBack { get; set; }
        public int ManageCreiticalSupport { get; set; }
        public bool IsManageCreiticalSupport { get; set; }
        public int AdoptedStudent { get; set; }
        public int PendingAdoptedStudent { get; set; }
        



        public bool IsNotSuperAdmin { get; set; }

    }
}
