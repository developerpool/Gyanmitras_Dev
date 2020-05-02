using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for GenericConversion
/// </summary>
public class GenericConversion
{
    //Integer Conversion

    public static Int16 ConvertToInt16(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToInt16(strValue);
            }
            catch (Exception)
            {
                return 0;
            }

        }
        else
        {
            return 0;
        }

    }
    public static Int32 ConvertToInt32(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToInt32(strValue);
            }
            catch (Exception)
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
    public static Int64 ConvertToInt64(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToInt64(strValue);
            }
            catch (Exception)
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }

    public static UInt16 ConvertToUInt16(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToUInt16(strValue);
            }
            catch (Exception)
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
    public static UInt32 ConvertToUInt32(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToUInt32(strValue);
            }
            catch (Exception)
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
    public static UInt64 ConvertToUInt64(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToUInt64(strValue);
            }
            catch (Exception)
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
    public static string ConvertToString(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToString(strValue);
            }
            catch (Exception)
            {
                return null;
            }
        }
        else
        {
            return "";
        }
    }

    public static string ConvertToBase64String(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToBase64String((byte[])strValue);
            }
            catch (Exception)
            {
                return null;
            }
        }
        else
        {
            return "";
        }
    }

    public static char ConvertToChar(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToChar(strValue);
            }
            catch (Exception)
            {
                return '0';
            }
        }
        else
        {
            return '0';
        }
    }

    public static Boolean ConvertToBoolean(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToBoolean(strValue);
            }
            catch (Exception)
            {
                return false;
            }

        }
        else
        {
            return false;
        }
    }
    public static Decimal ConvertToDecimal(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToDecimal(strValue);
            }
            catch (Exception)
            {
                return 0.0m;
            }

        }
        else
        {
            return 0.0m;
        }
    }
    public static Byte ConvertToByte(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToByte(strValue);
            }
            catch (Exception)
            {
                return 0;
            }

        }
        else
        {
            return 0;
        }
    }
    public static SByte ConvertToSByte(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToSByte(strValue);
            }
            catch (Exception)
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
    public static Double ConvertToDouble(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToDouble(strValue);
            }
            catch (Exception)
            {
                return 0.0D;
            }
        }
        else
        {
            return 0.0D;
        }
    }

    public static DateTime ConvertToDateTime(object strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                return Convert.ToDateTime(strValue);
            }
            catch (Exception)
            {
                return DateTime.MinValue;
            }
        }
        else
        {
            return DateTime.MinValue;
        }
    }

    public static Guid ConvertToGUID(string strValue)
    {
        //if (strValue != null && strValue != "")
        if (strValue != null) //Code Emplemented Due To Bug Found in Code Analysis Report
        {
            try
            {
                Guid ConvertGuid = new Guid(strValue);
                return ConvertGuid;
            }
            catch (Exception)
            {
                return Guid.Empty;
            }
        }
        else
        {
            return Guid.Empty;
        }
    }

}