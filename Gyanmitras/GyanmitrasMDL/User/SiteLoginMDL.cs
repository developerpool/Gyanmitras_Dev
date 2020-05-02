using GyanmitrasLanguages.LocalResources;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL.User
{
   public class SiteLoginMDL
    {
        [Display(Name = "UserName", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "UserNameValidation")]
        public string UserName { get; set; }
        [Display(Name = "Password", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceType = typeof(Resource), ErrorMessageResourceName = "Passwordvalidation")]
        public string Password { get; set; }
        public string Language { get; set; }

        public string ForgetPwdUserName { get; set; }

        public string FullName { get; set; }

        public string EmailID { get; set; }

        public string MobileNo { get; set; }

        public Int64 _UserId { get; set; }
        public bool RememberMe { get; set; }
        
    }
}
