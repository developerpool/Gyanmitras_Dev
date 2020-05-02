using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
   public class MstStateMDL
    {
        public Int64 Pk_StateId { get; set; }
        //[Required(ErrorMessage = "Please Select State Name")]
        public string StateName { get; set; }
        //[Required(ErrorMessage = "Please Select Country Name")]

        public Int64 Fk_CountryId { get; set; }
        public string CountryName { get; set; }

        public Int64 CreatedBy { get; set; }
        public bool IsActive { get; set; }
        public string Status { get; set; }
    }
}
