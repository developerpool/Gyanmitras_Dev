using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using @GyanmitrasLanguages.LocalResources;

namespace GyanmitrasMDL
{
    public class MstFormLanguageMappingMDL
    {
        public Int64 PK_FormLanguageId { get; set; }
        
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "FormNameValidation")]
        //[Required(ErrorMessage = "Please Select Form.")]
        public Int64 FK_FormId { get; set; }
        
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "SelectlngName")]
        //[Required(ErrorMessage = "Please Select Language.")]
        public Int64 FK_LanguageId { get; set; }
        public string LanguageName { get; set; }
        public string FormName { get; set; }
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "SelectTranslatedlng")]
        //[Required(ErrorMessage = "Translated Form Name Required.")]
        public string TranslatedFormName { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public Int64 CreatedBy { get; set; }

        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd/MM/yyyy}")]
        public DateTime CreatedDate { get; set; }
        public Int64 UpdatedBy { get; set; }
        public Int64 DeletedBy { get; set; }

        public Int64 FK_AccountID { get; set; }
        public Int64 FK_CustomerID { get; set; }
    }
}
