using GyanmitrasLanguages.LocalResources;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
   public  class MstCountryMDL
    {
        public Int64 PK_CountryId { get; set; }
        //[Display(Name = "CountryName")]
        //[Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CountryNameValidation")]

        public string CountryName { get; set; }
        public bool IsActive { get; set; }
        public Int64 CreatedBy { get; set; }
        public string Status { get; set; }
    }
}
