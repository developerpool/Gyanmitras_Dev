using System;
using System.Web;

namespace GyanmitrasMDL.User
{
    public class SiteUserInfoMDL
    {
        public Int64 UserId { get; set; }
        public string UserName { get; set; }
        public string UserPassword { get; set; }
        public string Name { get; set; }
        public Int64 RoleId { get; set; }
        public string RoleName { get; set; }
        public Int64 CategoryId { get; set; }
        public string CategoryName { get; set; }
        public string LoginType { get; set; }
        public string LandingPageURL { get; set; }
        public bool IsAdoptedStudentCounselor { get; set; }
        public bool IsUpdatedProfileAlert { get; set; }

        public bool IsProfilePage { get; set; }

        public string ProfileImage { get; set; }
        public bool IsEmailVerified { get; set; }


        public static SiteUserRoleAndRightsMDL GetUserRoleAndRights
        {
            get
            {
                return (SiteUserRoleAndRightsMDL)HttpContext.Current.Items["SiteUserRoleAndRights"];
            }
        }
    }
}
