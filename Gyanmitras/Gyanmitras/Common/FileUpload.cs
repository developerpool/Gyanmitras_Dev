using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.Data.SqlClient;
using System.Runtime.InteropServices;
using System.Security;

namespace Gyanmitras.Common
{
    public static class FileUpload
    {
        /// <summary>
        /// this method used for upload file on server
        /// </summary>
        /// <param name="file"></param>
        /// <param name="fileName"></param>
        /// <param name="folderName"></param>
        /// <returns></returns>
        #region UploadFileToServer
        public static string UploadFileToServer(HttpPostedFileBase file, string fileName,string folderName)
        {
              string folderFullPath = string.Empty;          
                string fileNameForUpload = string.Empty;
                if (fileName != null)
                {
                    fileNameForUpload = fileName;
                    if (!Directory.Exists(System.Web.HttpContext.Current.Server.MapPath("/App_Data/" + folderName + "/")))
                    {
                        Directory.CreateDirectory(System.Web.HttpContext.Current.Server.MapPath("/App_Data/" + folderName + "/"));
                    }
                    string LocalFileName = System.Web.HttpContext.Current.Server.MapPath("/App_Data/" + folderName + "/") + fileNameForUpload;
                file.SaveAs(LocalFileName);
                    return folderFullPath = LocalFileName;
                }           
            else
            {
                return "";
            }

        }
        #endregion
    }
}