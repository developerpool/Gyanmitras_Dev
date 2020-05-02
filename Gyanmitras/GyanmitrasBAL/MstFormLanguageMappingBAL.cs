using GyanmitrasDAL;
using GyanmitrasMDL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
    public class MstFormLanguageMappingBAL
    {
        MSTFormLanguageMappingDAL objFormLanguageMappingDAL = null;
        public MstFormLanguageMappingBAL()
        {
            objFormLanguageMappingDAL = new MSTFormLanguageMappingDAL();
        }

        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Get Details
        /// </summary>
        public bool GetFormLanguageMappingDetails(out List<MstFormLanguageMappingMDL> _PackageDataList, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 AccountId, Int64 FK_CustomerId, Int64 UserId, string LoginType)
        {
            _PackageDataList = new List<MstFormLanguageMappingMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            return objFormLanguageMappingDAL.GetFormLanguageMappingDetails(out _PackageDataList, out objBasicPagingMDL,out objTotalCountPagingMDL, id, RowPerpage, CurrentPage, SearchBy, SearchValue, AccountId, FK_CustomerId, UserId, LoginType);

        }
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Add / Edit Form Language Mapping Details
        /// </summary>
        public MessageMDL AddEditFormLanguageMapping(MstFormLanguageMappingMDL objFormLanguageMappingMDL)
        {
            return objFormLanguageMappingDAL.AddEditFormLanguageMapping(objFormLanguageMappingMDL);
        }
        /// <summary>
        /// Created By: Vinish
        /// Created Date:06-01-2020
        /// purpose: Delete Form Language Mapping Details
        /// </summary>
        public MessageMDL DeleteFormLanguageMapping(Int64 id ,Int64 CreatedBy, int FK_CompanyId)
        {
            return objFormLanguageMappingDAL.DeleteFormLanguageMapping(id, CreatedBy, FK_CompanyId);
        }
        
    }
}
