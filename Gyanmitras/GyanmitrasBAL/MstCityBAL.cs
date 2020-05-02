using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
   public  class MstCityBAL
    {
        MstCityDAL objCityMasterDAL = null;
        public MstCityBAL()
        {
            objCityMasterDAL = new MstCityDAL();
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose-Get details of City
        /// </summary>
        /// <param name="_Citylist"></param>
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
        public bool getCity(out List<MstCityMDL> _Citylist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, Int64 userid, int RowPerpage, int CurrentPage, string SearchBy, string SearchValue, Int64 CreatedBy, int FK_CompanyId)
        {
            _Citylist = new List<MstCityMDL>();
            //objBasicPagingMDL = new BasicPagingMDL();
            return objCityMasterDAL.getCity(out _Citylist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, userid, RowPerpage, CurrentPage, SearchBy, SearchValue);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose-Insert  details of City 
        /// </summary>
        /// <param name="objCityMasterMDL"></param>
        /// <returns></returns>
        public MessageMDL AddEditCity(MstCityMDL objCityMasterMDL)
        {
            return objCityMasterDAL.AddEditCity(objCityMasterMDL);
        }
        /// <summary>
        /// Created By-Vinish
        /// Date-22/12/2019
        /// Purpose-Delete City Data 
        /// </summary>
        /// <param name="PK_CityId"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>

        public MessageMDL DeleteCity(Int64 PK_CityId, Int64 UserId)
        {

            return objCityMasterDAL.DeleteCity(PK_CityId, UserId);
        }


    }
}
