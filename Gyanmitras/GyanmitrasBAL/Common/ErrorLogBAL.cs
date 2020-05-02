using GyanmitrasDAL.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasBAL.Common
{
    public class ErrorLogBAL
    {
        /// <summary>
        /// LOG ERROR DETAILS IN DB
        /// CREATED BY Vinish
        /// CREATED DATE 06 JAN 2020
        /// </summary> 
        public static void SetError(Exception Ex, MethodBase objBase, string controller, string action, string Source, string Remarks)
        {
            ErrorLogDAL.SetError(objBase.DeclaringType.Assembly.GetName().Name, controller, action, Source, Ex.Message, Ex.GetType().ToString(), Remarks);
        }

        /// <summary>
        /// LOG SERVICE ERROR DETAILS IN DB
        /// CREATED BY Vinish
        /// CREATED DATE 14 JAN 2020
        /// </summary> 
        public static void SetErrorService(Exception Ex, MethodBase objBase, string Source, string Remarks = "")
        {
            ErrorLogDAL.SetErrorService(Source, objBase.DeclaringType.Assembly.GetName().Name, objBase.DeclaringType.FullName, objBase.Name, Ex.Message, Remarks);

        }
    }
}
