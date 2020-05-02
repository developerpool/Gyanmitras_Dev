using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
   public class FormRoleViewMDL
    {
        public Int64 FK_RoleId { get; set; }
        public string MappingFor { get; set; }
        public string Mapping { get; set; }
        public Int64 FK_FormId { get; set; }
        public List<RoleMapping> Forms { get; set; }
    }
}
