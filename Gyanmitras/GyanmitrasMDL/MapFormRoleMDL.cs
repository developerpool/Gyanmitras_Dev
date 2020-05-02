using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
    public class MapFormRoleMDL
    {
        public Int64 FK_CompanyId { get; set; }
        public Int64 FK_RoleId { get; set; }
        public Int64 FK_Parent_FormId { get; set; }

    }
}
