using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Linq;
using System.Web;

namespace Gyanmitras.Common
{
    public class CommonHelper
    {
        public static bool Upload(HttpPostedFileBase file, string path, string NewName)
        {
            try
            {
                var fileName = Path.GetFileName(file.FileName);
                var fileExtension = Path.GetExtension(fileName);
                var filenamewithoutextension = "";
                filenamewithoutextension = !String.IsNullOrEmpty(fileExtension) ? fileName.Replace(fileExtension, "") : fileName;
                var filenamewithextension = NewName + fileExtension;//ResetFileNames(file, NewName);                  
                bool folderExists = Directory.Exists(path);
                if (folderExists)
                    Directory.CreateDirectory(path);
                file.SaveAs(System.Web.HttpContext.Current.Server.MapPath(path + filenamewithextension));
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool ValidateModel<T>(T Obj)
        {
            var context = new ValidationContext(Obj, serviceProvider: null, items: null);
            var results = new List<ValidationResult>();
            return Validator.TryValidateObject(Obj, context, results);
        }

    }
}