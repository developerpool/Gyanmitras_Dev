using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
   public class RoleMapping
    {
        public Int64 PK_FormRoleId { get; set; }
        public Int64 FK_FormId { get; set; }
        public Int64 FK_RoleId { get; set; }
        public int PK_MenuId { get; set; }
        public string FormName { get; set; }
        public bool All { get; set; }
        public bool CanAdd { get; set; }
        public bool CanEdit { get; set; }
        public bool CanView { get; set; }
        public bool CanDelete { get; set; }
        public Int64 CreatedBy { get; set; }
        public int FK_Sort_Id { get; set; }
        public Int64 FK_ParentId { get; set; }
        public bool CanAll { get; set; }
    }
}
