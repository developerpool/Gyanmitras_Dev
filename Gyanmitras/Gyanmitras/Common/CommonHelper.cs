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
                var filenamewithextension = NewName;
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

        public static string RandomString(string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", int stringCount = 5)
        {
            var stringChars = new char[stringCount];
            var random = new Random();

            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }
            String mystr = new string(stringChars);
            return mystr;
        }

    }
}