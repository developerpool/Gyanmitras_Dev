using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL.User
{
    public class FeedBackMDL
    {
        public Int64 PK_FeedId  {get;set;}
        public string FeedSubject{get;set;}
        public string FeedDescription {get;set;}
        
        public string CreatedBy  {get;set;}
        public string CreatedDateTime{get;set;}
        public string UpdatedBy  {get;set;}
        public string UpdatedDateTime { get;set;}
        public string IsActive   {get;set;}
        public string IsDeleted { get;set;}
        public string DeletedDateTime { get; set; }
    }
}
