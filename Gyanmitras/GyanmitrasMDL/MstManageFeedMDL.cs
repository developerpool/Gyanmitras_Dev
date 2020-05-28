using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace GyanmitrasMDL
{
    public class MstManageFeedMDL
    {
        public Int64 PK_FeedID       {get;set;}
        [Required(ErrorMessage ="User Name Selection Is Required")]
        public Int64 FK_UserID       {get;set;}
        [Required(ErrorMessage = "Category Selection Is Required")]
        public Int64 FK_CategoryID { get; set; }
        [Required(ErrorMessage = "Area Of Interest Selection Is Required")]
        public string[] AreaOfInterestIds { get; set; }
        public string FK_AreaOfInterest { get; set; }
        public string UserName { get; set; }
        public string CategoryName { get; set; }
        [Required(ErrorMessage = "Feed Subject Field Is Required")]
        public string FeedSubject     {get;set;}
        [Required(ErrorMessage = "Feed Description Field Is Required")]
        public string FeedDescription {get;set;}
        public string MediaType       {get;set;}
        public string VideoUrl        {get;set;}
        public HttpPostedFileBase ResourceFile { get;set;}
        public string ResourceFileName { get; set; }
        
        public Int64 CreatedBy       {get;set;}
        public string CreatedDateTime {get;set;}
        public Int64 UpdatedBy       {get;set;}
        public string UpdatedDateTime {get;set;}
        [Required(ErrorMessage = "Status Selection Is Required")]
        public bool IsActive        {get;set;}
        public bool IsDeleted       {get;set;}
        public string DeletedDateTime { get; set; }
    }
}
