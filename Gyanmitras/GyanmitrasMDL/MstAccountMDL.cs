using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Web;
using GyanmitrasLanguages.LocalResources;
using System.ComponentModel;

namespace GyanmitrasMDL
{
    public class MSTAccountMDL
    {

        public Int64 PK_AccountId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "AccountNameValidation")]
        //[RegularExpression(@"^[a-zA-Z .()0-9]+[ a-zA-Z-_]*$", ErrorMessageResourceName = "NameIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string AccountName { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "AccountCategoryValidation")]
        public Int64 FK_CategoryId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "UserNameValidation")]
        public string Username { get; set; }//New Added
        //[Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "UserRoleValidation")]
        public Int64 FK_RoleId { get; set; }//New Added
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "Passwordvalidation")]
        [StringLength(14, ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "Pswvalidation", MinimumLength = 4)]
        public string Password { get; set; }//New Added
        //Only For Display
        public string RoleName { get; set; }
        public string AccountCategoryName { get; set; }
        public string AccountParentName { get; set; }

        public string CountryName { get; set; }

        public string StateName { get; set; }

        public string CityName { get; set; }
        public string UnEncryptedPassword { get; set; }


        public string CountryId_Billing_Name { get; set; }

        public string StateId_Billing_Name { get; set; }

        public string CityId_Billing_Name { get; set; }
        //End
        public Int64 FK_CompanyId { get; set; }
        public Int64 FK_ResellerId { get; set; }
        public Int64 FK_AffiliateId { get; set; }
        public Int64 Parent_FK_CategoryId { get; set; }
        public Int64 ParentAccountId { get; set; }
        //[Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "AddressValidation")]
        public string AccountAddress { get; set; }

        [StringLength(10, ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ExceedCharacters")]
        [RegularExpression(@"^[a-zA-Z0-9]*$", ErrorMessageResourceName = "InvalidZipCode", ErrorMessageResourceType = typeof(Resource))]
        public string ZipCode { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CountryValidation")]
        public Int64 FK_CountryId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "StateValidation")]
        public Int64 FK_StateId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CityValidation")]
        public Int64 FK_CityId { get; set; }

        [StringLength(10, ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ExceedCharacters")]
        [RegularExpression(@"^[a-zA-Z0-9]*$", ErrorMessageResourceName = "InvalidZipCode", ErrorMessageResourceType = typeof(Resource))]
        public string ZipCode_Billing { get; set; }//New Added
                                                   //[Required(ErrorMessage = "Please Enter Country.")]
        public Int64 FK_CountryId_Billing { get; set; }//New Added
                                                       //[Required(ErrorMessage = "Please Enter State.")]
        public Int64 FK_StateId_Billing { get; set; }//New Added
                                                     //[Required(ErrorMessage = "Please Enter City.")]
        public Int64 FK_CityId_Billing { get; set; }//New Added


        public string BillingAddress { get; set; }
        public string ContactPerson { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "MobileNoValidation")]
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string MobileNo { get; set; }
        
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string AlternateMobileNo { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "EmailValidation")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessageResourceName = "EmailIdFormat", ErrorMessageResourceType = typeof(Resource))]
        public string EmailId { get; set; }
        //[Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "UserlimitValidation")]
        public int UserLimit { get; set; }//New Added
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessageResourceName = "EmailIdFormat", ErrorMessageResourceType = typeof(Resource))]
        public string AlternateEmailId { get; set; }
        public HttpPostedFileBase AccountLogo { get; set; }
        public string AccountLogoStream { get; set; }
        //[Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CmpRegistrationNoValidation")]
        //[Required(ErrorMessage = "Please Enter Company Registration No.")]
        public string AccountRegistrationNo { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public Int64 CreatedBy { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Int64 UpdatedBy { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public Int64 DeletedBy { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public string Status { get; set; }
        public string ShareVia { get; set; }
        public Int64 FK_AccountId_Referrer { get; set; }
        public string AccountName_Referrer { get; set; }
        public Int64 FK_CategoryId_Referrer { get; set; }
        public string CategoryName_Referrer { get; set; }
    }
}
