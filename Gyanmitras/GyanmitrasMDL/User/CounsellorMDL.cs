using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace GyanmitrasMDL.User
{
    public class CounselorMDL
    {
        public Int64 PK_CounselorID { get; set; }
        public string UID { get; set; }
        public string Password { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string ZipCode { get; set; }
        public Int64 FK_StateId { get; set; }
        public Int64 FK_CityId { get; set; }

        public string EmailID { get; set; }
        public string MobileNo { get; set; }
        public string AlternateMobileNo { get; set; }
        public string AreaOfInterest { get; set; }
        public string AreYou { get; set; }
        public HttpPostedFile Image { get; set; }
        public string ImageName { get; set; }
        public bool HavePC { get; set; }
        public bool LikeAdoptStudentLater { get; set; }
        public string JoinUsDescription { get; set; }
        public bool Declaration { get; set; }

        public bool IsActive { get; set; }
        public string Status { get; set; }
        public Int64 FK_RoleId { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public HttpPostedFileBase BulkUpload { get; set; }


    }
}
