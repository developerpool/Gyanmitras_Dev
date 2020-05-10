using GyanmitrasLanguages.LocalResources;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
namespace GyanmitrasMDL.User
{
    public class VolunteerMDL
    {
        public Int64 PK_VolunteerId { get; set; }
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
        #region Address Part
        [Required(ErrorMessage = "Please Enter Address")]
        public string Address { get; set; }
        //[StringLength(10, ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ExceedCharacters")]
        //[RegularExpression(@"^[a-zA-Z0-9]*$", ErrorMessageResourceName = "InvalidZipCode", ErrorMessageResourceType = typeof(Resource))]
        [Required(ErrorMessage = "Please Enter ZipCode")]
        public string ZipCode { get; set; }
        public string StateName { get; set; }
        public string CityName { get; set; }
        [Required(ErrorMessage = "Please Select State")]
        public Int64 FK_StateId { get; set; }
        [Required(ErrorMessage = "Please Select City")]
        public Int64 FK_CityId { get; set; }
        //Required If Billing Address is Yes
        public string BillingAddress { get; set; }
        [StringLength(10, ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ExceedCharacters")]
        [RegularExpression(@"^[a-zA-Z0-9]*$", ErrorMessageResourceName = "InvalidZipCode", ErrorMessageResourceType = typeof(Resource))]
        public string ZipCode_Billing { get; set; }
        public Int64? FK_StateId_Billing { get; set; }
        public Int64? FK_CityId_Billing { get; set; }
        public string StateName_Billing { get; set; }
        public string CityName_Billing { get; set; }
        #endregion

        [Required(ErrorMessage = "Please Enter Email ID")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessageResourceName = "EmailIdFormat", ErrorMessageResourceType = typeof(Resource))]
        public string EmailID { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "MobileNoValidation")]
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string MobileNo { get; set; }
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string AlternateMobileNo { get; set; }
        //[Required(ErrorMessage = "Please Select Area Of Interest to search")]
        //public string AreaOfInterest { get; set; }//State, District
        [Required(ErrorMessage = "Please Select Area Of Interest in State")]
        public Int64 FK_State_AreaOfSearch { get; set; }
        [Required(ErrorMessage = "Please Select Area Of Interest in District")]
        public Int64 FK_District_AreaOfSearch { get; set; }

        public HttpPostedFileBase Image { get; set; }
        public string ImageName { get; set; }
        public bool IsTrue => true;
        //[Range(typeof(bool), "false", "true", ErrorMessage = "Please check Terms and Conditions")]
        [Required]
        [System.ComponentModel.DataAnnotations.Compare("IsTrue", ErrorMessage = "Please agree to Terms and Conditions")]
        public bool Declaration { get; set; }


        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public string Status { get; set; }
        public Int64 FK_RoleId { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public HttpPostedFileBase BulkUpload { get; set; }

        public string FormType { get; set; }
        public string UrlHome { get; set; }
        public string CategoryName { get; set; }
        public string RoleName { get; set; }

        public bool IsPendingReplyUsers { get; set; }
        public bool IsManageCreiticalSupport { get; set; }
        public bool IsApprovedCounselor { get; set; }


    }
}
