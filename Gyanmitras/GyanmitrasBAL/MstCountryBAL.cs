using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
  public   class MstCountryBAL
    {

        MstCountryDAL objCountryMasterDAL = null;
        public MstCountryBAL()
        {
            objCountryMasterDAL = new MstCountryDAL();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-Get details of country
        /// </summary>
        /// <param name="_Countrylist"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="objTotalCountPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="userid"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <param name="CreatedBy"></param>
        /// <param name="FK_CompanyId"></param>
        /// <returns></returns>
        public bool getCountry(out List<MstCountryMDL> _Countrylist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 CreatedBy, int FK_CompanyId)
      
        {
            _Countrylist = new List<MstCountryMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            return objCountryMasterDAL.getCountry(out _Countrylist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, userid, RowPerpage, CurrentPage, SearchBy, SearchValue);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-Insert  details of country
        /// </summary>
        /// <param name="objCountryMasterMDL"></param>
        /// <returns></returns>
        public MessageMDL AddEditCountry(MstCountryMDL objCountryMasterMDL)
        {
            return objCountryMasterDAL.AddEditCountry(objCountryMasterMDL);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-20/12/2019
        /// Purpose-Delete Country Data
        /// </summary>
        /// <param name="PK_CountryId"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public MessageMDL DeleteCountry(Int64 PK_CountryId, Int64 UserId)
        {

            return objCountryMasterDAL.DeleteCountry(PK_CountryId, UserId);
        }

    }
}
