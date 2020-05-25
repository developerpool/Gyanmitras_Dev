using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace GyanmitrasMDL
{
    public class MstFeedBackCriteriaMDL
    {
        public Int64 PK_FeedBackCriteriaID { get; set; }
        [Required(ErrorMessage = "FeedBack For Field Is Selection Required!")]
        public Int64 FK_SiteUserCategoryID { get; set; }
        public string SiteUserCategory { get; set; }
        [Required(ErrorMessage = "FeedBack Criteria Field Is Required!")]
        public string FeedbackCriteria { get; set; }
        [Required(ErrorMessage = "'Mark Criteria If Yes' Field Is Required!")]
        public Int64 MarkCriteria_Yes { get; set; }
        [Required(ErrorMessage = "'Mark Criteria If No' Field Is Required!")]
        public Int64 MarkCriteria_No { get; set; }
        public bool IsActive { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
        public Int64 DeletedBy { get; set; }
        public string DeletedDateTime { get; set; }
    }
}
