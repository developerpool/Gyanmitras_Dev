using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
    public class FormColumnAssignmentMDL
    {
        public Int64 Fk_FormId { get; set; }
        public string FormName { get; set; }
        public string ColumnName { get; set; }
        public Int64 PK_FormColumnId { get; set; }
        public Int64 PK_FormColumnConfigId { get; set; }
        public Int64 UserId { get; set; }
        public Int64 CategoryId { get; set; }
        public Int64 AccountId { get; set; }
        public bool IsActive { get; set; }
        public string AccountName { get; set; }
    }
}
