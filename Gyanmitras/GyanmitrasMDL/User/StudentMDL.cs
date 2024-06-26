﻿using System;
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

    public class StudentMDL
    {

        public Int64 PK_StudentID { get; set; }
        public Int64 FK_CategoryId { get; set; }

        [Required(ErrorMessage = "Please Enter UserID")]
        [Remote("CheckUserId", "Home", ErrorMessage = "UserID already exists")]
        public string UID { get; set; }
        [Required(ErrorMessage = "Please Enter Password")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Confirm Password required")]
        [System.ComponentModel.DataAnnotations.CompareAttribute("Password", ErrorMessage = "Password doesn't match.")]
        public string ConfirmPassword { get; set; }
        [Display(Name = "Name", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "NameValidation")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Please Enter Address")]
        public string Address { get; set; }
        [Required(ErrorMessage = "Please Enter ZipCode")]
        [RegularExpression(@"^[0-9]*$", ErrorMessageResourceName = "InvalidZipCode", ErrorMessageResourceType = typeof(Resource))]
        public string ZipCode { get; set; }
        [Required(ErrorMessage = "Please Select State")]
        public Int64 FK_StateId { get; set; }
        [Required(ErrorMessage = "Please Select City")]
        public Int64 FK_CityId { get; set; }
        public string CityName{ get; set; }
        public string StateName { get; set; }

        public Int64 FK_AreaOfInterestStateId { get; set; }
        public Int64 FK_AreaOfInterestDistrictId { get; set; }
        public string AreaOfInterestDistrictName { get; set; }
        public string AreaOfInterestStateName { get; set; }

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
        public HttpPostedFileBase Image { get; set; }
        public string ImageName { get; set; }
        [Required(ErrorMessage = "Please Select the Pc Option")]
        public bool HavePC { get; set; }
        [Required(ErrorMessage = "Please Select the Smart Phone Option")]
        public bool HaveSmartPhone { get; set; }
        [Required(ErrorMessage = "Please Select the Adoption Wish Option")]
        public bool AdoptionWish { get; set; }
        [Required(ErrorMessage = "Please Select the  Type Of Education")]
        public string TypeOfEducation { get; set; }
        [Display(Name = "Class")]
        public string Current_Education_subcategory { get; set; }
        public string Previous_Education_subcategory { get; set; }
        [Required(ErrorMessage = "Please Select the  Completion Nature")]
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
        //[Range(typeof(bool), "false", "true", ErrorMessage = "Please check Terms and Conditions")]
        [Required]
        [System.ComponentModel.DataAnnotations.Compare("IsTrue", ErrorMessage = "Please agree to Terms and Conditions")]
        public bool Declaration { get; set; }
        
        public string languages { get; set; }
        [Required(ErrorMessage = "Please Select the  Language Known")]
        public string[] LanguagesIDs { get; set; }

        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public string Status { get; set; }
        public Int64 FK_RoleId { get; set; }
        public Int64 CreatedBy { get; set; }
        public Int64 UpdatedBy { get; set; }
        
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
        public bool IsMachingStudentsForCounselor { get; set; }
        public string AreaOfInterestName { get; set; }
        public string LanguageKnownName { get; set; }
        public List<SiteUserEducationDetailsMDL> EducationDetails { get; set; }

        public string JSON_EducationDetails { get; set; }
    }
}


