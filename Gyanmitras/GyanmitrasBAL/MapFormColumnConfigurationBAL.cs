using GyanmitrasDAL;
using GyanmitrasMDL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL
{
   public class MapFormColumnConfigurationBAL
    {
        MapFormColumnConfigurationDAL objMapFormColumnConfigurationDAL = null;
        public MapFormColumnConfigurationBAL()
        {
            objMapFormColumnConfigurationDAL = new MapFormColumnConfigurationDAL();
        }
        /// <summary>
        /// To Update the form Column Configuration
        /// </summary>
        /// <param name="jsonData"></param>
        /// <param name="UserId"></param>
        /// <param name="FK_AccountID"></param>
        /// <param name="FK_CategoryID"></param>
        /// <param name="FK_CustomerID"></param>
        /// <returns></returns>
        public MessageMDL UpdateFormColumnConfig(string jsonData,Int64 UserId, Int64 FK_AccountID, Int64 FK_CategoryID, Int64 FK_CustomerID) {
            return objMapFormColumnConfigurationDAL.UpdateFormColumnConfig(jsonData, UserId, FK_AccountID,FK_CategoryID,FK_CustomerID);
        }

        public bool getFormColumnConfigList(out List<FormColumnAssignmentMDL> _FormColumnConfigList, string ControllerName, string ActionName, int CustomerId)
        {
            return objMapFormColumnConfigurationDAL.getFormColumnConfigList(out _FormColumnConfigList, ControllerName, ActionName, CustomerId);
        }
    }
}
