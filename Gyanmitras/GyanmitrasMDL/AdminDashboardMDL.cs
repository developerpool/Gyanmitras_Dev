using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
    public class AdminDashboardMDL
    {
        public int FK_StateId { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }

        public int StudentCount { get; set; }
        public int CounselorCount { get; set; }
        public int VolunteerCount { get; set; }
    }
}
