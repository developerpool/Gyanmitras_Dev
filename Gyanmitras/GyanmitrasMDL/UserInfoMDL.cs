using System;
using System.Web;

namespace GyanmitrasMDL
{
    public class UserInfoMDL
    {
        public Int64 UserId { get; set; }
        public string UserName { get; set; }
        public string UserPassword { get; set; }
        public string Name { get; set; }
        public Int64 RoleId { get; set; }
        public string RoleName { get; set; }
        public Int64 AccountId { get; set; }
        public string AccountName { get; set; }
        public Int64 CategoryId { get; set; }
        public string CategoryName { get; set; }
        public Int64 CityId { get; set; }
        public string CityName { get; set; }
        public Int64 StateId { get; set; }
        public string StateName { get; set; }
        public Int64 CountryId { get; set; }
        public string CountryName { get; set; }
        public string logoClass { get; set; }
        public string LoginType { get; set; }
        public Int64 ResellerId { get; set; }
        public Int64 AffiliateId { get; set; }

        public int fk_companyid { get; set; }
        public Int64 FK_CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string EmailId { get; set; }
        public string LandingPageURL { get; set; }
        public static UserRoleAndRightsMDL GetUserRoleAndRights
        {
            get
            {
                return (UserRoleAndRightsMDL)HttpContext.Current.Items["UserRoleAndRights"];
            }
        }

    }
}
