using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace GyanmitrasMDL.User
{
    public class SiteUserContentResourceMDL
    {
        public Int64 PK_ContantResourceId { get; set; }
        [Required(ErrorMessage ="Role Selection Is Required!")]
        public Int64 FK_RoleId { get; set; }
        public string RoleName { get; set; }
        [Required(ErrorMessage = "State Selection Is Required!")]
        public Int64 FK_StateId { get; set; }
        public string StateName { get; set; }
        [Required(ErrorMessage = "Search Category Selection Is Required!")]
        public Int64 FK_SearchCategoryId { get; set; }
        public string SearchCategoryName { get; set; }
        [Required(ErrorMessage = "Sub Search Category Selection Is Required!")]
        public Int64 FK_SubSearchCategoryId { get; set; }
        public string SubSearchCategoryName { get; set; }
        [Required(ErrorMessage = "Heading Field Is Required!")]
        public string Heading { get; set; }
        [Required(ErrorMessage = "Description Field Is Required!")]
        public string Description { get; set; }
        [Required(ErrorMessage = "Resource Type Field Selection Is Required!")]
        public string ResourceType { get; set; }
        public HttpPostedFileBase ResourceFile { get; set; }
        public HttpPostedFileBase BulkUpload { get; set; }
        public string ResourceFileName { get; set; }



        public string Status { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }



    }
}
