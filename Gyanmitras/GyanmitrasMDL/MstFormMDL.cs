using GyanmitrasLanguages.LocalResources;
using System;
using System.ComponentModel.DataAnnotations;

namespace GyanmitrasMDL
{
    public class MstFormMDL
    {
        #region => Fields 
        public Int64? Pk_FormId { get; set; }

        [Display(Name = "Solution", ResourceType = typeof(Resource))]
        public Int64? SolutionId { get; set; }        
        [Display(Name = "FormName", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "FormNameValidation")]
        public string FormName { get; set; }
        [Display(Name = "ControllerName", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "FormControllerValidation")]
        public string ControllerName { get; set; }
        [Display(Name = "ActionName", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "FormActionValidation")]
        public string ActionName { get; set; }
        [Display(Name = "ParentForm", ResourceType = typeof(Resource))]
        public Int64? ParentId { get; set; }
        [Display(Name = "WebMobile", ResourceType = typeof(Resource))]
        public string PlatFormType { get; set; }

        public int MainId { get; set; }
        public int LevelId { get; set; }
        public int SortId { get; set; }
        public string Image { get; set; }
        [Display(Name = "Status", ResourceType = typeof(Resource))]
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public Int64? UserId { get; set; }
        public string CreatedDate { get; set; }
        [Display(Name = "ClassName", ResourceType = typeof(Resource))]
        public string ClassName { get; set; }
        [Display(Name = "AreaName", ResourceType = typeof(Resource))]
        public string Area { get; set; }
        public Int64? CompanyId { get; set; }
        public Int64? CategoryId { get; set; }
        public Int64? RoleId { get; set; }
        public string ParentForm { get; set; }
        public string SolutionName { get; set; }
        public string Status { get; set; }
        #endregion
    }
}
