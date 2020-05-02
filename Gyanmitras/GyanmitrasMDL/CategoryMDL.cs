using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
   public class CategoryMDL
    {
        public Int64 FK_CategoryId { get; set; }
        public string CategoryName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }
}
