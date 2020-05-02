//using GyanmitrasMDL;
//using System;
//using System.Collections.Generic;
//using System.IO;
//using System.Linq;
//using System.Net;
//using System.Text;
//using System.Web;
//using System.Web.Configuration;
//using System.Web.Script.Serialization;

//namespace Gyanmitras.Common
//{
//    public class SyncMongo
//    {
//        public MessageMDL SyncCustomer(string json)
//        {
//            MessageMDL result = new MessageMDL();

//            try
//            {

//                //string path = "http://localhost:8081/vts-service/registerCustomer";
//                string path = WebConfigurationManager.AppSettings["path"];
//                //string URL = path + "vts-service/vehicleWiseAlertEmailConfiguration";

//                path = path + "vts-service/registerCustomer";
//                var DATA = json;

//                WebRequest webRequest = WebRequest.Create(path);
//                var data = Encoding.ASCII.GetBytes(DATA);
//                HttpWebRequest httpRequest = (HttpWebRequest)webRequest;
//                httpRequest.Method = "POST";
//                httpRequest.ContentType = "application/json";
//                httpRequest.ContentLength = data.Length;
//                using (Stream webStream = httpRequest.GetRequestStream())
//                using (StreamWriter requestWriter = new StreamWriter(webStream, System.Text.Encoding.ASCII))
//                {
//                    requestWriter.Write(DATA);
//                }
//                WebResponse webResponse = httpRequest.GetResponse();
//                Stream responseStream = webResponse.GetResponseStream();
//                StreamReader streamReader = new StreamReader(responseStream);
//                var resultdata = streamReader.ReadToEnd();

//                JavaScriptSerializer jss = new JavaScriptSerializer();
//                ServiceResultMDL<string> objServiceResult = jss.Deserialize<ServiceResultMDL<string>>(resultdata);

//                if (objServiceResult.Message.ToUpper() == "SUCCESSFUL")
//                {
//                    result.Message = objServiceResult.Message.ToUpper();
//                    result.MessageId = 1;

//                }
//                else
//                {
//                    result.Message = @GyanmitrasLanguages.LocalResources.Resource.ProcessFailed;
//                    result.MessageId = 0;
//                }
//            }
//            catch (Exception ex)
//            {
//                result.Message = @GyanmitrasLanguages.LocalResources.Resource.ServiceNotResponding;
//                result.MessageId = 0;
//            }
//            return result;
//        }


//    }
//}