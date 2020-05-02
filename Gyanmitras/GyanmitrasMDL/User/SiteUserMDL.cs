using GyanmitrasLanguages.LocalResources;
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
        public Int64 UserId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "AccountCategoryValidation")]
        public Int64 FK_CategoryId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "AccountCategoryValidation")]
        public Int64 FK_CategoryIdForCust { get; set; }
        public string Categoryname { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "selectRoleValidation")]
        public Int64 FK_RoleId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "selectRoleValidation")]
        public Int64 FK_RoleIdforcust { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "selectRoleValidation")]
        public string Rolename { get; set; }
        public Int64 FK_CompanyId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "AccountNameValidation")]
        public Int64 FK_AccountId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "SelectCustomerName")]
        public Int64 FK_CustomerId { get; set; }
        public string CustomerName { get; set;}
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "AccountNameValidation")]
        public string AccountName { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "UserNameValidation")]
        public string UserName { get; set; }
        public string Share { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "Passwordvalidation")]
        [StringLength(14, ErrorMessage = "Password Must be between 4 and 14 characters", MinimumLength = 4)]
        [DataType(DataType.Password)]
        public string UserPassword { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "NameValidation")]
        //[RegularExpression(@"^[a-zA-Z\s]*$", ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "NameFormat")]
        public string Name { get; set; }


        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "MobileNoValidation")]
        //[StringLength(13, MinimumLength = 10)]
        
        //[RegularExpression(@"^[0-9]+$", ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "MobileNoFormat")]
        public string MobileNo { get; set; }

        //[StringLength(13, MinimumLength = 10)]
        //[RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoFormat", ErrorMessageResourceType = typeof(Resource))]
        //[RegularExpression(@"^([7-9]{1})([0-9]{9})$", ErrorMessage = "Entered Mobile No format is not valid.")]
        public string AlternateMobileNo { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "EmailValidation")]
        //[DataType(DataType.EmailAddress, ErrorMessage = "Please Enter Valid Email Id.")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessageResourceName = "EmailIdIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string EmailId { get; set; }

        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessageResourceName = "EmailIdIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string AlternateEmailId { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "GenderValidation")]
        
        public string Gender { get; set; }
        public string DateOfBirth { get; set; }

        [DataType(DataType.MultilineText)]
        [StringLength(100), Display(Name = "Address")]
        public string UserAddress { get; set; }
        public string ZipCode { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CountryValidation")]
        public Int64 CountryId { get; set; }
        public string CountryName { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CountryValidation")]

        public Int64 StateId { get; set; }
        public string statename { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "StateValidation")]

        public Int64 CityId { get; set; }

        public string Cityname { get; set; }
        public bool IsActive { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
        public Int64 DeletedBy { get; set; }
        public string DeletedDateTime { get; set; }
        public bool VehicleSpecific { get; set; }
       public string IsVehicleSpecific { get; set; }
    }
}
