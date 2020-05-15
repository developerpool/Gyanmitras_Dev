using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using GyanmitrasLanguages.LocalResources;
using System.Web.Mvc;

namespace GyanmitrasMDL.User
{
    public class CounselorMDL
    {
        public Int64 PK_CounselorID { get; set; }
        [Required(ErrorMessage = "Please Enter UserID")]
        [Remote("CheckUserId", "Home", ErrorMessage = "UserID already exists")]
        public string UID { get; set; }
        [Required(ErrorMessage = "Please Enter Password")]
        public string Password { get; set; }
        [System.ComponentModel.DataAnnotations.CompareAttribute("Password", ErrorMessage = "Password doesn't match.")]
        public string ConfirmPassword { get; set; }
        [Display(Name = "Name", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "NameValidation")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Please Enter Address")]
        public string Address { get; set; }
        [Required(ErrorMessage = "Please Enter ZipCode")]
        public string ZipCode { get; set; }
        [Required(ErrorMessage = "Please Select State")]
        public Int64 FK_StateId { get; set; }
        [Required(ErrorMessage = "Please Select City")]
        public Int64 FK_CityId { get; set; }
        [Required(ErrorMessage = "Please Select the  Language Known")]
        public string languages { get; set; }
        public string CityName { get; set; }
        [Required(ErrorMessage = "Please Enter Email ID")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessageResourceName = "EmailIdFormat", ErrorMessageResourceType = typeof(Resource))]

        public string EmailID { get; set; }
        [Required(ErrorMessage = "Please Enter MobileNo")]
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string MobileNo { get; set; }
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string AlternateMobileNo { get; set; }
        
        [Required(ErrorMessage = "Please Select Area Of Interest")]
        public string[] AreaOfInterestIds { get; set; }
        public string AreaOfInterest { get; set; }

        [Required(ErrorMessage = "Please Select Your Type")]
        public string AreYou { get; set; }
        public HttpPostedFileBase Image { get; set; }
        public string ImageName { get; set; }
        public bool HavePC { get; set; }
        public bool LikeAdoptStudentLater { get; set; }
        [Required(ErrorMessage = "Please write why you want to join us")]
        public string JoinUsDescription { get; set; }

        [Required(ErrorMessage = "Acceptation Required!")]
        public bool Declaration { get; set; }

        
        public string Expertise_Details { get; set; }
        
        public string Retired_Expertise_Details { get; set; }

        public string Secondry_Education_Board { get; set; }

        public string HigherSecondry_Education_Board { get; set; }

        public Decimal? Secondry_Percentage { get; set; }

        public Decimal? HigherSecondry_Percentage { get; set; }

        public Decimal? Graduation_Percentage { get; set; }
        public Decimal? PostGraduation_Percentage { get; set; }
        public Decimal? NET_JRF_Percentage { get; set; }

        public string Secondry_Year_of_Passing { get; set; }

        public string HigherSecondry_Year_of_Passing { get; set; }

        public string Graduation_Year_of_Passing { get; set; }
        public string PostGraduation_Year_of_Passing { get; set; }
        public string Docterate_Year_of_Passing { get; set; }

        public string HigherSecondry_StreamType { get; set; }

        public string Graduation_StreamType { get; set; }
        public string PostGraduation_StreamType { get; set; }
        public string Docterate_UniversityName { get; set; }
        public string PostGraduation_UniversityName { get; set; }

        public string Graduation_UniversityName { get; set; }

        public string Graduation_CourseName { get; set; }
        public string PostGraduation_CourseName { get; set; }
        public string Specification { get; set; }
        public string Extra_work { get; set; }

        public bool IsActive { get; set; }
        public string StateName { get; set; }
        public bool IsDeleted { get; set; }
        public string Status { get; set; }
        public Int64 FK_RoleId { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public HttpPostedFileBase BulkUpload { get; set; }

        public string FormType { get; set; }
        public string CategoryName { get; set; }
        public string RoleName { get; set; }


        public bool IsPendingReplyUsers { get; set; }
        public bool IsManageCreiticalSupport { get; set; }
        public bool IsApprovedCounselor { get; set; }
        public bool IsAdoptedStudent { get; set; }
        public bool MyAdoption { get; set; }
        public bool AdoptionWish { get; set; }
        public bool HaveSmartPhone { get; set; }


        public bool IsMachingStudentsForCounselor { get; set; }

        
        public bool IsAdoptedStudentCounselor { get; set; }

        public List<SiteUserEducationDetailsMDL> EducationDetails { get; set; }

    }
}
