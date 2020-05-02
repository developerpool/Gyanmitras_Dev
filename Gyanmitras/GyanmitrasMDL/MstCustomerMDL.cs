//using GyanmitrasLanguages.LocalResources;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using @GyanmitrasLanguages.LocalResources;

namespace GyanmitrasMDL
{
    public class MstCustomerMDL
    {
        public Int64 PK_CustomerId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "EnterCustomerName")]
        //[RegularExpression(@"^[a-zA-Z .()0-9]+[ a-zA-Z-_]*$", ErrorMessageResourceName = "NameIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string CustomerName { get; set; }
        //[Required(ErrorMessage = "Please select Parent Customer!")]
        public Int64 FK_ParentCustomerId { get; set; }
        public string ParentCustomerName { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ReferredBy")]
        //[Required(ErrorMessage = "Please select Referred By!")]
        public Int64 FK_CategoryId { get; set; }//Reffered By
        public string ReferredByName { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ParentCustomerValidation")]
        public Int64 FK_AccountId { get; set; }//Reffered Account Name
        public string ReferredByAccountName { get; set; }
       
        //[Required(ErrorMessage = "Please select Customer Category!")]
        public string CustomerTypeName { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CustomerTypeValidation")]
        public Int64 FK_CustomerTypeId { get; set; }

        public Int64 FK_UserId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "UserNameValidation")]
        //[Required(ErrorMessage = "User Name field is required!")]
        public string UserName { get; set; }

        public string UnEncryptedPassword { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "Passwordvalidation")]
        //[Required(ErrorMessage = "Password field is required!")]
        [StringLength(14, ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "Pswvalidation", MinimumLength = 4)]
        public string Password { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ShareViaValidation")]
        //[Required(ErrorMessage = "Share Via field is required!")]
        public string ShareVia { get; set; }
        //[Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "AddressValidation")]
        //[Required(ErrorMessage = "Address field is required!")]
        public string Address { get; set; }
        [StringLength(10, ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ExceedCharacters")]
        [RegularExpression(@"^[a-zA-Z0-9]*$", ErrorMessageResourceName = "InvalidZipCode", ErrorMessageResourceType = typeof(Resource))]
        public string ZipCode { get; set; }

        public string CountryName { get; set; }

        public string StateName { get; set; }

        public string CityName { get; set; }

        public string CountryName_Billing { get; set; }
        public string StateName_Billing { get; set; }
        public string CityName_Billing { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CountryValidation")]
        //[Required(ErrorMessage = "Please select Country!")]
        public Int64 FK_CountryId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "StateValidation")]
        //[Required(ErrorMessage = "Please select State!")]
        public Int64 FK_StateId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CityValidation")]
        //[Required(ErrorMessage = "Please select City!")]
        public Int64 FK_CityId { get; set; }
        //Required If Billing Address is Yes
        public string BillingAddress { get; set; }
        //Required If Billing Address is Yes
        [StringLength(10, ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ExceedCharacters")]
        [RegularExpression(@"^[a-zA-Z0-9]*$", ErrorMessageResourceName = "InvalidZipCode", ErrorMessageResourceType = typeof(Resource))]
        public string ZipCode_Billing { get; set; }
        //Required If Billing Address is Yes
        public Int64 FK_CountryId_Billing { get; set; }
        //Required If Billing Address is Yes
        public Int64 FK_StateId_Billing { get; set; }
        //Required If Billing Address is Yes
        public Int64 FK_CityId_Billing { get; set; }
        //Required If Billing Address is Yes
        public string ContactPerson { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "MobileNoValidation")]
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        //[Required(ErrorMessage = "Mobile No. field is required!")]
        public string MobileNo { get; set; }
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string AlternateMobileNo { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "EmailValidation")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessageResourceName = "EmailIdFormat", ErrorMessageResourceType = typeof(Resource))]
        //[Required(ErrorMessage = "Email field is required!")]
        public string EmailId { get; set; }
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessageResourceName = "EmailIdFormat", ErrorMessageResourceType = typeof(Resource))]
        public string AlternateEmailId { get; set; }
        public string AccountLogo { get; set; }
        public HttpPostedFileBase AccountLogoUpload { get; set; }
        public string AccountRegistrationNo { get; set; }
        public bool IsActive { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
        public Int64 DeletedBy { get; set; }
        public string DeletedDateTime { get; set; }

        public Int64 FK_CompanyId { get; set; }
        
        public int TimeZoneHours { get; set; }
        public int TimeZoneMinutes { get; set; }
        public bool IsSync { get; set; }
        public string Remarks { get; set; }
        
        public HttpPostedFileBase BulkUpload { get; set; }
    }
}
