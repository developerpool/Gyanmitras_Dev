using GyanmitrasDAL;
using GyanmitrasDAL.Common;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;

namespace GyanmitrasBAL
{
    public class MstFormBAL
    {
        #region => Fields 
        MstFormDAL objMstFormDAL = null;       
        #endregion

        /// <summary>
        /// Constructor functionality is used to initializes objects.
        /// </summary>
        public MstFormBAL()
        {
            objMstFormDAL = new MstFormDAL();
        }

        /// <summary>
        ///  CREATED DATE : 11 Dec 2019
        ///  PURPOSE : Add and Edit Form Master Details
        ///  CREATED BY : Vinish
        /// </summary>
        /// <param name="formDetails"></param>
        /// <returns></returns>
        public MessageMDL AddEditFormDetails(MstFormMDL formDetails)
        {
            MessageMDL objMessages = new MessageMDL();
            try
            {
                if (formDetails.IsActive == false)
                {
                    formDetails.IsDeleted = true;
                }
                else
                {
                    formDetails.IsDeleted = false;
                }
                objMessages = objMstFormDAL.AddEditFormDetails(formDetails);

            }
            catch (Exception ex)
            {
                var objBase = System.Reflection.MethodBase.GetCurrentMethod();
                ErrorLogDAL.SetError("Gyanmitras", objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, "", objBase.Name, ex.Message, "ADDITIONAL REMARKS");
            }
            return objMessages;
        }

        /// <summary>
        /// CREATED DATE : 12 Dec 2019
        /// PURPOSE : Get All Parent Form Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <returns></returns>
        public List<MstFormMDL> GetAllParentForm()
        {            
            return objMstFormDAL.GetAllParentForm(); 
        }
        /// <summary>
        /// CREATED DATE : 11 Dec 2019
        /// PURPOSE : Get Form Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="_FormMasterlist"></param>
        /// <param name="objBasicPagingMDL"></param>
        /// <param name="id"></param>
        /// <param name="RowPerpage"></param>
        /// <param name="CurrentPage"></param>
        /// <param name="SearchBy"></param>
        /// <param name="SearchValue"></param>
        /// <returns></returns>
        public bool GetFormsDetails(out List<MstFormMDL> _FormMasterlist, out BasicPagingMDL objBasicPagingMDL, out TotalCountPagingMDL objTotalCountPagingMDL, int id, int RowPerpage, int CurrentPage = 1, string SearchBy = "", string SearchValue = "")
        {
            return objMstFormDAL.GetFormsDetails(out _FormMasterlist, out objBasicPagingMDL, out objTotalCountPagingMDL, id, RowPerpage, CurrentPage, SearchBy, SearchValue);
        }

        /// <summary>
        /// CREATED DATE : 12 Dec 2019
        /// PURPOSE : Delete Form Details
        /// CREATED BY : Vinish
        /// </summary>
        /// <param name="formID"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public MessageMDL DeleteFormsDetails(Int64 formID, Int64 userId)
        {
            MessageMDL objMessages = new MessageMDL();
            try
            {
                
                objMessages = objMstFormDAL.DeleteFormsDetails(formID, userId);
               
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
