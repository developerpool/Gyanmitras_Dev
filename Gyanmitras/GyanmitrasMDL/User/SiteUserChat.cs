using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL.User
{
    public class SiteUserChat
    {
        public Int64 PK_ChatID { get; set; }
        public Int64 Chat_From { get; set; }
        public Int64 Chat_To { get; set; }
        public string Query_From  { get; set; }
        public string  Query_To { get; set; } 
        public string QueryDateTime_From { get; set; }
        public string  QueryDateTime_To { get; set; }   
        public bool IsDeleted { get; set; } 
        public Int64 DeletedBy  { get; set; }          
        public bool IsSeen_From { get; set; } 
        public bool IsSeen_To { get; set; }
        public bool IsReplay { get; set; }
        
    }
}
