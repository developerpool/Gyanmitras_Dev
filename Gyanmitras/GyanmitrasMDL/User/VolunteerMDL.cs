using GyanmitrasLanguages.LocalResources;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace GyanmitrasMDL.User
{
    public class VolunteerMDL
    {
        public Int64 PK_VolunteerId { get; set; }
        public string UID { get; set; }
        public string Password { get; set; }
        public string Name { get; set; }
        #region Address Part
        public string Address { get; set; }
        [StringLength(10, ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "ExceedCharacters")]
        [RegularExpression(@"^[a-zA-Z0-9]*$", ErrorMessageResourceName = "InvalidZipCode", ErrorMessageResourceType = typeof(Resource))]
        public string ZipCode { get; set; }
        public string StateName { get; set; }
        public string CityName { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "StateValidation")]
        public Int64? FK_StateId { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CityValidation")]
        public Int64? FK_CityId { get; set; }
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

        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "EmailValidation")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessageResourceName = "EmailIdFormat", ErrorMessageResourceType = typeof(Resource))]
        public string EmailID { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "MobileNoValidation")]
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string MobileNo { get; set; }
        [RegularExpression(@"^[0-9]+$", ErrorMessageResourceName = "MobileNoIsValid", ErrorMessageResourceType = typeof(Resource))]
        public string AlternateMobileNo { get; set; }

        public string AreaOfSearch { get; set; }//State, District
        public Int64 FK_State_AreaOfSearch { get; set; }
        public Int64 FK_District_AreaOfSearch { get; set; }

        public HttpPostedFile Image { get; set; }
        public string ImageName { get; set; }
        public bool Declaration { get; set; }


        public bool IsActive { get; set; }
        public string Status { get; set; }
        public Int64 FK_RoleId { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public HttpPostedFileBase BulkUpload { get; set; }



    }
}
