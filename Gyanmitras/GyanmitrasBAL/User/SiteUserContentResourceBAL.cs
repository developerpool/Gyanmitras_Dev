using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using GyanmitrasDAL.User;
using GyanmitrasMDL.User;
using GyanmitrasDAL.Common;


namespace GyanmitrasBAL.User
{
    public class SiteUserContentResourceBAL
    {
        #region => Fields 
        SiteUserContentResourceDAL objSiteUserContentResourceDAL = null;
        #endregion

        /// <summary>
        /// Constructor functionality is used to initializes objects.
        /// </summary>
        public SiteUserContentResourceBAL()
        {
            objSiteUserContentResourceDAL = new SiteUserContentResourceDAL();
        }

        /// <summary>
        ///  CREATED DATE : 11 Dec 2019
        ///  PURPOSE : Add and Edit SiteUserContentResource Master Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="SiteUserContentResourceDetails"></param>
        /// <returns></returns>
        public MessageMDL AddEditSiteUserContentResourceDetails(SiteUserContentResourceMDL SiteUserContentResourceDetails)
        {
            MessageMDL objMessages = new MessageMDL();
            try
            {
                if (SiteUserContentResourceDetails.IsActive == false)
                {
                    SiteUserContentResourceDetails.IsDeleted = true;
                }
                else
                {
                    SiteUserContentResourceDetails.IsDeleted = false;
                }
                objMessages = objSiteUserContentResourceDAL.AddEditSiteUserContentResourceDetails(SiteUserContentResourceDetails);

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return objMessages;
        }

        /// <summary>
        /// CREATED DATE : 11 Dec 2019
        /// PURPOSE : Get SiteUserContentResource Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="_SiteUserContentResourceMasterlist"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        public bool GetSiteUserContentResourcesDetails(out List<SiteUserContentResourceMDL> _SiteUserContentResourceMasterlist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, int RowPerpage, int CurrentPage = 1, string SearchBy = "", string SearchValue = "")
        {
            return objSiteUserContentResourceDAL.GetSiteUserContentResourcesDetails(out _SiteUserContentResourceMasterlist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, RowPerpage, CurrentPage, SearchBy, SearchValue);
        }

        /// <summary>
        /// CREATED DATE : 12 Dec 2019
        /// PURPOSE : Delete SiteUserContentResource Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="SiteUserContentResourceID"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public MessageMDL DeleteSiteUserContentResourcesDetails(Int64 SiteUserContentResourceID, Int64 userId)
        {
            MessageMDL objMessages = new MessageMDL();
            try
            {

                objMessages = objSiteUserContentResourceDAL.DeleteSiteUserContentResourcesDetails(SiteUserContentResourceID, userId);

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return objMessages;
        }
    }
}
