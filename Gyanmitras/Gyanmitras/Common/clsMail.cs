using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI.WebControls;

namespace Gyanmitras.Common
{
    public class clsMail
    {
        public static bool SendMail(string reciepients, string MailSubject, string MessageFilePath, ListDictionary replacements)
        {
            try
            {
                MailDefinition mailDefinition = new MailDefinition();
                mailDefinition.Subject = MailSubject;
                mailDefinition.BodyFileName = MessageFilePath;
                mailDefinition.IsBodyHtml = true;
                mailDefinition.From = ConfigurationManager.AppSettings["LCFromMail"];

                string SSLEnable = ConfigurationManager.AppSettings["LCEnableSsl"];
                string DefaultCredentialUse = ConfigurationManager.AppSettings["LCUseDefaultCredentials"];
                bool EnableSSL = false;
                bool UseDefaultCredential = false;

                if (SSLEnable == "true")
                {
                    EnableSSL = true;
                }
                else
                {
                    EnableSSL = false;
                }

                if (DefaultCredentialUse=="true")
                {
                    UseDefaultCredential = true;
                }
                else
                {
                    UseDefaultCredential = false;
                }

                MailMessage mailMessage;
                mailMessage = mailDefinition.CreateMailMessage(reciepients, replacements, new System.Web.UI.Control());
                SmtpClient client = new SmtpClient { Host = ConfigurationManager.AppSettings["LCHost"], Port = Convert.ToInt32(ConfigurationManager.AppSettings["LCPort"]), EnableSsl = EnableSSL, DeliveryMethod = SmtpDeliveryMethod.Network, UseDefaultCredentials = UseDefaultCredential, Credentials = new NetworkCredential(ConfigurationManager.AppSettings["LCFromMail"], ConfigurationManager.AppSettings["LCPassword"]) };
                client.Send(mailMessage);

                return true;
            }
            catch(Exception ex)
            {
                return false;
            }
        }
    }
}