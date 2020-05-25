using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
    public class FeedBackMDL
    {
        public Int64 PK_FeedBackID { get; set; }
        public Int64 FK_CounselorID { get; set; }
        public Int64 FK_StudentID { get; set; }
        public Int64 FK_FeedBackCriteriaID { get; set; }
        public string FeedBackBy { get; set; }
        public string CounselorName { get; set; }
        public string FeedbackCriteria { get; set; }
        public string StudentName { get; set; }
        public string FeedBackByCategory { get; set; }
        public int FeedOneTimeNumber { get; set; }


        public int AutoRateFeedBack { get; set; }
        public int RateFeedBack { get; set; }
        public Int64 RatedBy { get; set; }
        public bool IsLikeThisClass { get; set; }
        public string FeedBackSuggesstion { get; set; }

        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public string DeletedDateTime { get; set; }
    }
}
