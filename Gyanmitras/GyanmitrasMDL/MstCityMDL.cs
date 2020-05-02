using GyanmitrasLanguages.LocalResources;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
  public   class MstCityMDL
    {
        public Int64 Pk_CityId { get; set; }
        //[Display(Name = "CityName")]
        //[Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "CityValidation1")]

        public string CityName { get; set; }
        //[Display(Name = "StateName")]
        //[Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "SelectStateNameValidation")]
        public Int64 Fk_StateId { get; set; }
       
        public string StateName { get; set; }
        //[Display(Name = "CountryName")]
        //[Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "SelectCountryNameValidation")]
        public Int64 Fk_CountryId { get; set; }
        public string CountryName { get; set; }
        
        public Int64 CreatedBy { get; set; }
        public bool IsActive { get; set; }
        public string Status { get; set; }
      
    }
}
