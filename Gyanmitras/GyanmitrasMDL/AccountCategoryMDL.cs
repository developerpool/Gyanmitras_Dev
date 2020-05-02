using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
    public class AccountCategoryMDL     
    {
        public Int64 PK_CategoryId { get; set; }
        public string AccountCategory { get; set; }
        public bool Isactive { get; set; }
        public Int64 UserId { get; set; }
        public string CreatedDate { get; set; }
        public string Status { get; set; }
    }
}
