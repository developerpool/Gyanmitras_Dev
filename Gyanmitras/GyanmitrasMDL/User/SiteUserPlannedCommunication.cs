using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL.User
{
    public class SiteUserPlannedCommunication
    {
        public Int64 PK_PlannedCommunicationID { get; set; }

        public Int64 FK_CounselorID { get; set; }
        public Int64 FK_StudentID { get; set; }

        public string DateTimeFrom { get; set; }
        public string DateTimeTo { get; set; }
        public string CommunicationPlan { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public string Status { get; set; }
        public string CreatedDateTime { get; set; }
    }
}
