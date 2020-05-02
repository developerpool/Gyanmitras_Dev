using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Gyanmitras.Common
{
    public class SharedMethod
    {
        /// <summary>
        /// convert string 'dd/MM/yyyy hh mm' to string 'MM/dd/yyyy hh:mm'
        /// </summary>
        /// <param name="MMddyyyy"></param>
        /// <returns></returns>
        public static string ConvertddMMyyyyToMMddyyyyHHMM(string ddMMyyyy)
        {
            System.Globalization.DateTimeFormatInfo dateInfo = new System.Globalization.DateTimeFormatInfo();
            dateInfo.ShortDatePattern = "dd/MM/yyyy hh:mm tt";
            DateTime validDate = Convert.ToDateTime(ddMMyyyy, dateInfo);
            return validDate.ToString("MM/dd/yyyy hh:mm tt");
        }
        /// <summary>
        /// convert string 'dd/MM/yyyy' to string 'MM/dd/yyyy'
        /// </summary>
        /// <param name="MMddyyyy"></param>
        /// <returns></returns>
        public static string ConvertddMMyyyyToMMddyyyy(string ddMMyyyy)
        {
            System.Globalization.DateTimeFormatInfo dateInfo = new System.Globalization.DateTimeFormatInfo();
            dateInfo.ShortDatePattern = "dd/MM/yyyy";
            DateTime validDate = Convert.ToDateTime(ddMMyyyy, dateInfo);
            return validDate.ToString("MM/dd/yyyy");
        }
    }
}