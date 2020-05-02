using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL
{
   public class FormMDL
    {
        public Int64 PK_FormId { get; set; }
        public string FormName { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public Int64 FK_ParentId { get; set; }
        public int FK_MainId { get; set; }
        public int LevelId { get; set; }
        public int SortId { get; set; }
        public string Image { get; set; }
        public bool CanAdd { get; set; }
        public bool CanEdit { get; set; }
        public bool CanView { get; set; }
        public bool CanDelete { get; set; }
        public List<SubForms> SubForms { get; set; }
        public string ClassName { get; set; }
        public Int64 HomePage { get; set; }
        public string Area { get; set; }
    }
    public class SubForms
    {

        public Int64 PK_FormId { get; set; }
        public string FormName { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public Int64 FK_ParentId { get; set; }
        public Int64 FK_MainId { get; set; }
        public Int64 LevelId { get; set; }
        public Int64 SortId { get; set; }
        public string Image { get; set; }
        public bool CanAdd { get; set; }
        public bool CanEdit { get; set; }
        public bool CanView { get; set; }
        public bool CanDelete { get; set; }
        public string Area { get; set; }
    }
    public class FormCompanyMappingModel
    {
        public Int64 PK_FormCompanyId { get; set; }
        // public int FK_RoleId { get; set; }
        public Int64 FK_FormId { get; set; }
        public Int64 FK_CompanyID { get; set; }
        public Int64 CreatedBy { get; set; }
        //added  (for adding whether the mapping is for mobile app or web app) **start
        public string MappingFor { get; set; }
        public string Mapping { get; set; }
        // ** end
        public List<CompanyMappingMDL> Forms { get; set; }

    }
    public class FormMappingViewModel
    {
        public Int64 PK_FormRoleId { get; set; }
        public Int64 FK_RoleId { get; set; }
        public Int64 FK_FormId { get; set; }
        public Int64 FK_CompanyID { get; set; }
        public Int64 CreatedBy { get; set; }
        //added  (for adding whether the mapping is for mobile app or web app) **start
        public string MappingFor { get; set; }
        public string Mapping { get; set; }
        // ** end
        public List<RoleMapping> Forms { get; set; }

    }
}
