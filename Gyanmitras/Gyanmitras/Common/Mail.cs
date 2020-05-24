using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Runtime.InteropServices;
using System.Web;

/// <summary>
/// Summary description for Mail
/// </summary>
namespace Gyanmitras.Common
{
    public class Mail
    {
        public Mail()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        public static Boolean SendEmail(string subject, string mailbody, [Optional] Dictionary<int, string> to_mail, [Optional] Dictionary<int, string> cc_mail, string htmlAttachment = "", string htmlAttachmentName = "", string fileAttachmentMapPath = "",bool IsAdminMail = false)
        {
            Boolean flag = false;
            try
            {
                MailMessage message;
                SmtpClient client;
                message = new MailMessage();
                message.From = new MailAddress(ConfigurationManager.AppSettings["From"], ConfigurationManager.AppSettings["sender_name"]);

                if (IsAdminMail)
                {
                    message.To.Add(new MailAddress(ConfigurationManager.AppSettings["AdminTo"]));
                }

                if (to_mail != null)
                {
                    foreach (KeyValuePair<int, string> entry in to_mail)
                    {
                        message.To.Add(new MailAddress(entry.Value));
                    }
                }
              
                if (cc_mail != null)
                {
                    foreach (KeyValuePair<int, string> entry in cc_mail)
                    {
                        message.CC.Add(new MailAddress(entry.Value));
                    }
                }
                

                if (!string.IsNullOrEmpty(fileAttachmentMapPath))
                {
                    message.Attachments.Add(new Attachment(fileAttachmentMapPath));
                }
                if (!string.IsNullOrEmpty(htmlAttachment))
                {
                    System.IO.MemoryStream ms = new System.IO.MemoryStream();
                    System.IO.StreamWriter writer = new System.IO.StreamWriter(ms);
                    //htmlAttachment = "<html><head></head><body>Invoice 1></body></html>";
                    writer.Write(htmlAttachment);
                    writer.Flush();
                    writer.Dispose();

                    System.Net.Mime.ContentType ct
                                = new System.Net.Mime.ContentType(System.Net.Mime.MediaTypeNames.Text.Html);
                    Attachment attach = new Attachment(ms, ct);
                    attach.ContentDisposition.FileName = htmlAttachment;
                    ms.Close();
                    message.Attachments.Add(attach);
                }
                message.Subject = subject;
                message.IsBodyHtml = true;
                message.Body = mailbody;
                message.Priority = MailPriority.High;
                client = new SmtpClient(ConfigurationManager.AppSettings["smtpUserName"], Convert.ToInt32(ConfigurationManager.AppSettings["port"]));
                client.EnableSsl = true;
                client.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["From"], ConfigurationManager.AppSettings["smtpPassword"]);
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                //client.UseDefaultCredentials = false;
                client.Send(message);
                flag = true;


            }
            catch (Exception exx)
            {
                flag = false;
            }
            return flag;
        }
    }
}