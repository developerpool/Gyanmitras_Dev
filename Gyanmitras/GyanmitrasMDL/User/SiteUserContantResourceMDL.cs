using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace GyanmitrasMDL.User
{
    public class SiteUserContantResourceMDL
    {
        public Int64 PK_ContantResourceId { get; set; }
        public Int64 FK_RoleId { get; set; }
        public string RoleName { get; set; }

        public Int64 FK_StateId { get; set; }
        public string StateName { get; set; }

        public Int64 FK_SearchCategoryId { get; set; }
        public string SearchCategoryName { get; set; }

        public Int64 FK_SubSearchCategoryId { get; set; }
        public string SubSearchCategoryName { get; set; }
        public string Heading { get; set; }
        public string Description { get; set; }
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
