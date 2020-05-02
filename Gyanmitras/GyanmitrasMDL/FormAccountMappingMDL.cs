using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
   public class FormAccountMappingMDL
    {
        public Int64 PK_Map_FormAccountId { get; set; }
        public Int64 FK_FormId { get; set; }
        public Int64 UserId { get; set; }
        public String FormName { get; set; }
        public Int64 FK_AccountId { get; set; }
        public Int64 FK_CategoryId { get; set; }
        public String AccountName { get; set; }
        public String AccountCategory { get; set; }
        public String UserName { get; set; }
        public String RoleName { get; set; }
        public bool IsActive { get; set; }
        public String CreatedDatetime { get; set; }
        public String Status { get; set; }
        public bool IsCustomerAccount { get; set; }
        public Int64 CustomerId { get; set; }
        public string LoginType { get; set; }
    }
}
