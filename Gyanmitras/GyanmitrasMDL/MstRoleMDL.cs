using GyanmitrasLanguages.LocalResources;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
  public  class MstRoleMDL
    {
        public Int64 PK_RoleId { get; set; }
        [Display(Name = "RoleName", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "RoleNameValidation")]
        public string RoleName { get; set; }
        [Display(Name = "LandingPage", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "LandingPageValidation")]
        public Int64 FK_FormId { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public Int64 CreatedBy { get; set; }
        public string CreatedDatetime { get; set; }

        public string Status { get; set; }

        public string FormName { get; set; }
        public Int64 FK_Parent_FormId { get; set; }
        
        public Int64? FK_CustomerId { get; set; }
        public Int64 FK_CategoryId { get; set; }
        public Int64 AccountId { get; set; }
        public Int64 CustomerId { get; set; }
        [Display(Name = "RoleFor", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "RoleForValidation")]

        public Int64 RoleForId { get; set; }
        public Int64 FK_RoleForId { get; set; }
        public string CompanyName { get; set; }
        
        public Int64? FK_CompanyId { get; set; }
        public string RoleFor { get; set; }
        public bool IsVehicleSpecific { get; set; }
        public string VehicleSpecificStatus { get; set; }

    }
}
