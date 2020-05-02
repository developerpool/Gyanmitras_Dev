using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GyanmitrasDAL;


namespace GyanmitrasBAL
{
    public class FormColunmAssignmentBAL
    {
        FormColumnAssignmentDAL objFormColumnDAL = new FormColumnAssignmentDAL();

        /// <summary>
        /// Created By: Vinish  
        /// Created Date: 02-01-2020 
        /// Purpose: Add a Form Column Assinment
        /// </summary>
        /// <param name="FormColumnAssignmentMDL"></param>
        /// <returns></returns>
        public MessageMDL AddFormColumnAssignment(FormColumnAssignmentMDL objFormColumnMDL)
        {
            return objFormColumnDAL.AddFormColumnAssignment(objFormColumnMDL);
        }

        /// <summary>
        /// Purpose: To Get column data by Id
        /// </summary>
        /// <returns></returns>
        public bool GetFormColumAssignment(out List<FormColumnAssignmentMDL> _FormColumnListList, out BasicPagingMDL objBasicPagingMDL, int id, Int64 FK_AccountId, Int64 UserId, string searchBy, string searchValue, int RowPerpage, int CurrentPage, Int64 FK_CustomerId, string LoginType)
        {
            _FormColumnListList = new List<FormColumnAssignmentMDL>();
            objBasicPagingMDL = new BasicPagingMDL();
            return objFormColumnDAL.GetFormColumAssignment(out _FormColumnListList, out objBasicPagingMDL, id,FK_AccountId,UserId, searchBy, searchValue, RowPerpage, CurrentPage,FK_CustomerId,LoginType);
        }
        /// <summary>
        /// Purpose: To Delete Form Column by Id
        /// </summary>
        /// <returns></returns>
        public MessageMDL DeleteFormColumnAssignment(int id, int UserId)
        {
          return  objFormColumnDAL.DeleteFormColumnAssignment(id, UserId);
        }
    }
}
