using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
   public class MapFormColumnConfigurationMDL
    {
        public Int64 FK_CategoryId { get; set; }
        public Int64 FK_CustomerId { get; set; }
        public Int64 FK_AccountId { get; set; }
        public Int64 Fk_FormId { get; set; }

        public List<FormColumnAssignmentMDL> FormColumns { get; set; }
    }
}
