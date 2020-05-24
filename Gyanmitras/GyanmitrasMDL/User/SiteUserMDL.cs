using GyanmitrasLanguages.LocalResources;
using GyanmitrasMDL.User;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
    public class SiteUserMDL
    {
        public Int64 Pk_UserId { get; set; }
        public string UID { get; set; }
        public string Password { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string ZipCode { get; set; }
        public Int64 FK_StateId { get; set; }
        public Int64 FK_CityId { get; set; }
        public string CityName { get; set; }
        public string StateName { get; set; }

        public Int64 FK_AreaOfInterestStateId { get; set; }
        public Int64 FK_AreaOfInterestDistrictId { get; set; }
        public string AreaOfInterestDistrictName { get; set; }
        public string AreaOfInterestStateName { get; set; }

        public string EmailID { get; set; }
        public string MobileNo { get; set; }
        public string AlternateMobileNo { get; set; }
        public string AreaOfInterest { get; set; }
        public string ImageName { get; set; }
        [Required(ErrorMessage = "Please Select the Pc Option")]
        public bool HavePC { get; set; }
        [Required(ErrorMessage = "Please Select the Smart Phone Option")]
        public string HaveSmartPhone { get; set; }
        [Required(ErrorMessage = "Please Select the Adoption Wish Option")]
        public string AdoptionWish { get; set; }
        public string TypeOfEducation { get; set; }
        [Display(Name = "Class")]
        public string Current_Education_subcategory { get; set; }
        public string Previous_Education_subcategory { get; set; }
        public string CompletionNature { get; set; }
        public Decimal? Percentage { get; set; }
        public Decimal? PreviousclassPercentage { get; set; }
        public string BoardType { get; set; }
        public string PreviousBoardType { get; set; }
        public string StreamType { get; set; }
        public string UniversityName { get; set; }
        public string Current_semester { get; set; }
        public Decimal? TotalAggregatetillnow { get; set; }

        public bool IsTrue => true;
        public bool Declaration { get; set; }
        public string languages { get; set; }

        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }

        public string Status { get; set; }
        public Int64 FK_RoleId { get; set; }
        public Int64 FK_CategoryId { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
        public Int64 DeletedBy { get; set; }
        public string DeletedDateTime { get; set; }

        public string FormType { get; set; }
        public string CategoryName { get; set; }
        public string RoleName { get; set; }

        public bool IsPendingReplyUsers { get; set; }
        public bool IsManageCreiticalSupport { get; set; }
        public bool IsApprovedCounselor { get; set; }

        public bool IsAdoptedStudent { get; set; }
        public bool MyAdoption { get; set; }





        public bool IsMachingStudentsForCounselor { get; set; }
        public string AreaOfInterestName { get; set; }
        public string LanguageKnownName { get; set; }


        public List<SiteUserEducationDetailsMDL> EducationDetails { get; set; }
        public string JSON_EducationDetails { get; set; }


        public string AreYou { get; set; }
        public string JoinUsDescription { get; set; }
        public bool LikeAdoptStudentLater { get; set; }
        public string Retired_Expertise_Details { get; set; }
        public string Secondry_Education_Board { get; set; }

        public bool IsOTPVerified { get; set; }
        public string OTP { get; set; }
        public string OTPUserInput { get; set; }


    }
}
