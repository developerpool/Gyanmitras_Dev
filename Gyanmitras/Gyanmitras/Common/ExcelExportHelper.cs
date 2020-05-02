//using OfficeOpenXml;
//using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
//using iTextSharp.tool.xml;
//using Org.BouncyCastle.Utilities.IO;

namespace Gyanmitras.Common
{
    /// <summary>
    /// Created By:Vinish
    /// Created Date:18-08-2020
    /// purpose:Import Data in Excel & Convert List To Table & Convert List To table with specific Coloumn
    /// </summary>
    public class ExcelExportHelper : Controller
    {
        public static string ExcelContentType
        {
            get
            { return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"; }
        }
        public static DataTable ListToDataTable<T>(List<T> data)
        {
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(typeof(T));
            DataTable dataTable = new DataTable();

            for (int i = 0; i < properties.Count; i++)
            {
                PropertyDescriptor property = properties[i];
                dataTable.Columns.Add(property.Name, Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType);
            }

            object[] values = new object[properties.Count];
            foreach (T item in data)
            {
                for (int i = 0; i < values.Length; i++)
                {
                    values[i] = properties[i].GetValue(item);
                }

                dataTable.Rows.Add(values);
            }
            return dataTable;
        }
        // public static byte[] ExportExcel(DataTable dataTable, string heading = "", bool showSrNo = false, params string[] columnsToTake)  
        //{  

        //    byte[] result = null;  
        //    using (ExcelPackage package = new ExcelPackage())  
        //    {  
        //        ExcelWorksheet workSheet = package.Workbook.Worksheets.Add(String.Format("{0} Data",heading));  
        //        int startRowFrom = String.IsNullOrEmpty(heading) ? 1 : 3;  

        //        if (showSrNo)  
        //        {  
        //            DataColumn dataColumn = dataTable.Columns.Add("#", typeof(int));  
        //            dataColumn.SetOrdinal(0);  
        //            int index = 1;  
        //            foreach (DataRow item in dataTable.Rows)  
        //            {  
        //                item[0] = index;  
        //                index++;  
        //            }  
        //        }  


        //        // add the content into the Excel file  
        //        workSheet.Cells["A" + startRowFrom].LoadFromDataTable(dataTable, true);  

        //        // autofit width of cells with small content  
        //        int columnIndex = 1;  
        //        //foreach (DataColumn column in dataTable.Columns)  
        //        //{  
        //        //    ExcelRange columnCells = workSheet.Cells[workSheet.Dimension.Start.Row, columnIndex, workSheet.Dimension.End.Row, columnIndex];  
        //        //    int maxLength = columnCells.Max(cell => cell.Value.ToString().Count());  
        //        //    if (maxLength < 150)  
        //        //    {  
        //        //        workSheet.Column(columnIndex).AutoFit();  
        //        //    }  


        //        //    columnIndex++;  
        //        //}  

        //        // format header - bold, yellow on black  
        //        using (ExcelRange r = workSheet.Cells[startRowFrom, 1, startRowFrom, dataTable.Columns.Count])  
        //        {  
        //            r.Style.Font.Color.SetColor(System.Drawing.Color.White);  
        //            r.Style.Font.Bold = true;  
        //            r.Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;  
        //            r.Style.Fill.BackgroundColor.SetColor(System.Drawing.ColorTranslator.FromHtml("#1fb5ad"));  
        //        }  

        //        // format cells - add borders  
        //        using (ExcelRange r = workSheet.Cells[startRowFrom + 1, 1, startRowFrom + dataTable.Rows.Count, dataTable.Columns.Count])  
        //        {  
        //            r.Style.Border.Top.Style = ExcelBorderStyle.Thin;  
        //            r.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;  
        //            r.Style.Border.Left.Style = ExcelBorderStyle.Thin;  
        //            r.Style.Border.Right.Style = ExcelBorderStyle.Thin;  

        //            r.Style.Border.Top.Color.SetColor(System.Drawing.Color.Black);  
        //            r.Style.Border.Bottom.Color.SetColor(System.Drawing.Color.Black);  
        //            r.Style.Border.Left.Color.SetColor(System.Drawing.Color.Black);  
        //            r.Style.Border.Right.Color.SetColor(System.Drawing.Color.Black);  
        //        }  

        //        // removed ignored columns  
        //        for (int i = dataTable.Columns.Count - 1; i >= 0; i--)  
        //        {  
        //            if (i == 0 && showSrNo)  
        //            {  
        //                continue;  
        //            }  
        //            if (!columnsToTake.Contains(dataTable.Columns[i].ColumnName))  
        //            {  
        //                workSheet.DeleteColumn(i + 1);  
        //            }  
        //        }  

        //        if (!String.IsNullOrEmpty(heading))  
        //        {  
        //            workSheet.Cells["A1"].Value = heading;  
        //            workSheet.Cells["A1"].Style.Font.Size = 20;  

        //            workSheet.InsertColumn(1, 1);  
        //            workSheet.InsertRow(1, 1);  
        //            workSheet.Column(1).Width = 5;  
        //        }  

        //        result = package.GetAsByteArray();  
        //    }  

        //    return result;  
        //}

        public FileResult ExportExcel<T>(List<T> data, string FileName = "", string ExportFormat = ".xls", string MDLAttrName = "", params string[] ColumnsToTake)
        {
            // return ExportExcel(ListToDataTable<T>(data), Heading, showSlno, ColumnsToTake);
            DataTable dt = ConvertListToDataTable(ListToDataTable<T>(data), MDLAttrName, ColumnsToTake);
            return ExportToFormats(dt, FileName, ExportFormat);

        }



        /// 
        /// <summary>
        /// Auther : Vinish
        /// Created Date : 2020-02-19 11:23:36.887
        ///Purpose:- Export To PDF File
        /// </summary>
        /// <returns></returns>
        public FileResult ExportPDF(string SummaryHtml = "", string DetailsHtml = "", string strhtml_header_left = "", string strhtml_header_right = "", string pdfFileName = "", string reportName = "")
        {

            byte[] bytes = null;
            // DataTable tableToExport = new DataTable();
            // tableToExport = ConvertListToDataTable(ListToDataTable<T>(data), MDLAttrName, ColumnsToTake);
            // string url = "";
            //*my code start-----------------*//




            StringBuilder strhtml = new StringBuilder();




            strhtml.Append("<!doctype html> <html> <head>  </head> ");
            strhtml.Append("<body >");
            strhtml.Append(" <table width='100%' border='0' cellpadding='3' cellspacing='0' style='font-family:Helvetica,Arial, sans-serif;font-size:5pt;line-height:10pt;color: #000;'>");
            strhtml.Append(" <tbody> ");
            strhtml.Append("<tr > ");
            strhtml.Append("<td width='50%' align='left'>");
            strhtml.Append("<table  border='0' cellspacing='0' cellpadding='3' style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:5pt;' >");
            strhtml.Append(" <tbody> ");
            strhtml.Append("<tr> <td colspan='3'><img alt='Gyanmitras Logo' src='http://Gyanmitras.vseen.my/assets/img/logo.png' height='30' /></td> </tr>");
            //Header Columns Start
            strhtml.Append(strhtml_header_left);
            //Header Columns End
            strhtml.Append("</tbody>");
            strhtml.Append("</table>");
            strhtml.Append("</td> ");
            strhtml.Append("<td width='50%' align='right' valign='top'><table  border='0' cellspacing='0' cellpadding='3' style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:5pt;'> <tbody> <tr> <td colspan='3' style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:20pt;font-weight:bold;margin-right: 14px;' align='right' ><br/><br/> </td> </tr> ");
            strhtml.Append("<tr> <td colspan='3' style='font-family:Helvetica,Arial, sans-serif;font-size:10pt;line-height:30pt;font-weight:bold;' align='right' > " + reportName + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td> </tr> ");
            //Header Columns Start
            strhtml.Append(strhtml_header_right);
            //Header Columns End
            strhtml.Append(" </tbody> ");
            strhtml.Append("</table></td> </tr>");
            strhtml.Append(" <tr> <td colspan='2' style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:5pt;'><hr style='border-bottom: 1px solid #999;' width='100%' /></td> </tr> ");

            strhtml.Append("<tr>");
            strhtml.Append("<td colspan='2' style='padding:5pt 15pt;'>");
            strhtml.Append("<table width='100%' border='0' cellspacing='0' cellpadding='0'>");
            strhtml.Append("<tbody>");

            if (!string.IsNullOrEmpty(SummaryHtml))
            {
                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:10pt;line-height:20pt;font-weight:bold;' align='left' >"+ @GyanmitrasLanguages.LocalResources.Resource.Summary+ "</td> </tr> ");
                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:20pt;font-weight:bold;' align='left' >&nbsp;</td> </tr> ");
                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:10pt;line-height:20pt;font-weight:bold;' align='left' ><br/></td> </tr> ");
                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:5pt;' align='left' >");
                strhtml.Append(SummaryHtml);
                strhtml.Append("</td>");
                strhtml.Append("</tr>");

                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:20pt;font-weight:bold;' align='left' >&nbsp;</td> </tr>");
                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:10pt;line-height:20pt;font-weight:bold;' align='left' ><br/></td> </tr>");
                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:20pt;font-weight:bold;' align='left' >&nbsp;</td> </tr>");
            }
            if (!string.IsNullOrEmpty(DetailsHtml))
            {


                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:10pt;line-height:20pt;font-weight:bold;' align='left' >"+@GyanmitrasLanguages.LocalResources.Resource.Details+"</td> </tr>");
                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:20pt;font-weight:bold;' align='left' >&nbsp;</td> </tr>");
                strhtml.Append("<tr> <td style='font-family:Helvetica,Arial, sans-serif;font-size:10pt;line-height:20pt;font-weight:bold;' align='left' ><br/></td> </tr>");
                strhtml.Append("<tr > <td style='font-family:Helvetica,Arial, sans-serif;font-size:7pt;line-height:5pt;' align='left' >");

                strhtml.Append(DetailsHtml);


                strhtml.Append("</td> </tr>");

            }


            strhtml.Append("</tbody>");
            strhtml.Append("</table>");
            strhtml.Append("</td>");
            strhtml.Append("</tr>");

            strhtml.Append("<tr>  </tr>");
            strhtml.Append(" <tr> <td colspan='2' style='font-family:Helvetica,Arial, sans-serif;font-size:7pt;line-height:7pt;color: #999;' align='center'>" + @GyanmitrasLanguages.LocalResources.Resource.Copyright + "" + DateTime.Now.Year.ToString() + "</td> </tr> <tr> <td colspan='2' style='font-family:Helvetica,Arial, sans-serif;font-size:1pt;line-height:2pt;'><hr style='border-bottom: 1px solid #999;' width='100%' /></td> </tr> <tr> <td colspan='2' style='font-family:Helvetica,Arial, sans-serif;font-size:7pt;line-height:7pt;color: #999;' align='center'>" + @GyanmitrasLanguages.LocalResources.Resource.VseenMalaysiaMsg + "Vseen Malaysia Sdn Bhd All Right Reserved</td> </tr>");
            strhtml.Append(" </tbody>");
            strhtml.Append(" </table>");
            strhtml.Append(" </body> </html>");




            string HTMLContent = strhtml.ToString();
            StringReader sr = new StringReader(strhtml.ToString());

            // comment code start//
            //Boilerplate iTextSharp setup here
            //  Create a stream that we can write to, in this case a MemoryStream
            using (var ms = new MemoryStream())
            {

                //Create an iTextSharp Document which is an abstraction of a PDF but **NOT** a PDF
                using (var doc = new Document(PageSize.A4, 40f, 40f, 10f, 10f))
                {

                    //Create a writer that's bound to our PDF abstraction and our stream
                    using (var writer = PdfWriter.GetInstance(doc, ms))
                    {

                        //Open the document for writing
                        doc.Open();
                        // doc.Add(new Chunk("")); // << this will do the trick. 

                        //Our sample HTML and CSS
                        string example_html = strhtml.ToString();
                        string example_css = @".borLeft { border-left: 1px solid #000; } .borRight { border-right: 1px solid #000; } .borTop { border-top: 1px solid #000; } .borBottom { border-bottom: 1px solid #999; } .borBottomB { border-bottom: 1px solid #000; } .top_aligned_image { vertical-align: top; } .dotted { font-family: Helvetica, Arial, sans-serif; line-height: 10pt; font-weight: bold; margin: 0; text-align: center; border: 1px dashed #000; padding: 10pt 15pt; float: right; }";//@"td

                        //  string example_css = @"";
                        //In order to read CSS as a string we need to switch to a different constructor
                        //that takes Streams instead of TextReaders.
                        //Below we convert the strings into UTF8 byte array and wrap those in MemoryStreams
                        using (var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(example_css)))
                        {
                            using (var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(example_html)))
                            {

                                //Parse the HTML
                                iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                            }
                        }
                        doc.Close();
                    }
                }

                //After all of the PDF "stuff" above is done and closed but **before** we
                //close the MemoryStream, grab all of the active bytes from the stream
                bytes = ms.ToArray();
            }
            // comment code end

            return File(bytes, "application/octet-stream", pdfFileName);
        }

        public FileResult ExportToFormats(DataTable tableToExport, string ReportType, string ExportFormat)
        {
            GridView DataGrid = new GridView();
            DataGrid.AllowPaging = false;
            DataGrid.DataSource = tableToExport;
            DataGrid.DataBind();


            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);
            DataGrid.RenderControl(hw);
            byte[] content = Encoding.UTF8.GetBytes(sw.ToString());

            string FileName = ReportType + "_" + DateTime.Now.ToString("dd.MM.yyyy_HH.mm") + ExportFormat;

            if (ExportFormat == ".xls")
            {
                return File(content, "application/vnd.ms-excel", FileName); //"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            }

            else if (ExportFormat == ".xlsx")
            {
                return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", FileName);
            }

            else if (ExportFormat == ".doc")
            {
                return File(content, "application/msword", FileName); // "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            }

            else if (ExportFormat == ".docx")
            {
                return File(content, "application/vnd.openxmlformats-officedocument.wordprocessingml.document", FileName);
            }
            //else if (ExportFormat == ".pdf")
            //{
            //    return File(content, "application/PDF", FileName);
            //}
            else if (ExportFormat == ".csv")
            {
                StringBuilder sb = ExportToCSV(tableToExport);
                sw = new StringWriter(sb);
                hw = new HtmlTextWriter(sw);
                content = Encoding.UTF8.GetBytes(sw.ToString());
                return File(content, "application/CSV", FileName);
            }
            else if (ExportFormat == ".pdf")
            {
                content = ExportPDF(tableToExport, ReportType);
                return File(content, "application/octet-stream", FileName);

            }
            else
            {
                //StringReader sr = new StringReader(sw.ToString());
                //Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
                //HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                ////PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
                //pdfDoc.Open();
                //htmlparser.Parse(sr);
                //pdfDoc.Close();
                //Response.Write(pdfDoc);
                //Response.End();
                //ExportToPDF(tableToExport, FileName);

                return null;
            }
        }
        public DataTable ConvertListToDataTable(DataTable datadt, string MDLAttrName = "", params string[] ColumnsToTake)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(@GyanmitrasLanguages.LocalResources.Resource.No + ".", typeof(string));
            foreach (string s in ColumnsToTake)
            {
                dt.Columns.Add(s, typeof(string));
            }
            int index = 1;
            foreach (DataRow lstdr in datadt.Rows)
            {
                DataRow dr = dt.NewRow();
                dr[@GyanmitrasLanguages.LocalResources.Resource.No + "."] = index.ToString();
                var stringArray = MDLAttrName.Split(',');
                int i = 0;
                foreach (string s in ColumnsToTake)
                {
                    dr[s] = lstdr[stringArray[i] != null ? stringArray[i].Trim() : ""].ToString();
                    i = i + 1;
                }
                index = index + 1;
                dt.Rows.Add(dr);
            }
            return dt;
        }


        #region region for export excel common methods for area

        public FileResult ExportExcelArea<T>(List<T> data, string FileName = "", string ExportFormat = ".xls", string MDLAttrName = "", params string[] ColumnsToTake)
        {
            // return ExportExcel(ListToDataTable<T>(data), Heading, showSlno, ColumnsToTake);
            DataTable dt = ConvertListToDataTableArea(ListToDataTable<T>(data), MDLAttrName, ColumnsToTake);
            return ExportToFormatsArea(dt, FileName, ExportFormat);

        }

        public FileResult ExportToFormatsArea(DataTable tableToExport, string ReportType, string ExportFormat)
        {
            GridView DataGrid = new GridView();
            DataGrid.AllowPaging = false;
            DataGrid.DataSource = tableToExport;
            DataGrid.DataBind();


            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);
            DataGrid.RenderControl(hw);
            byte[] content = Encoding.UTF8.GetBytes(sw.ToString());

            string FileName = ReportType + "_" + DateTime.Now.ToString("dd.MM.yyyy_HH.mm") + ExportFormat;

            if (ExportFormat == ".xls")
            {
                return File(content, "application/vnd.ms-excel", FileName); //"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            }

            else if (ExportFormat == ".xlsx")
            {
                return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", FileName);
            }

            else if (ExportFormat == ".doc")
            {
                return File(content, "application/msword", FileName); // "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            }

            else if (ExportFormat == ".docx")
            {
                return File(content, "application/vnd.openxmlformats-officedocument.wordprocessingml.document", FileName);
            }
            else if (ExportFormat == ".csv")
            {
                StringBuilder sb = ExportToCSV(tableToExport);
                sw = new StringWriter(sb);
                hw = new HtmlTextWriter(sw);
                content = Encoding.UTF8.GetBytes(sw.ToString());
                return File(content, "application/CSV", FileName);
            }

            else
            {
                //Response.Clear();
                //Response.ContentType = "application/pdf";                
                //Response.AddHeader("content-disposition", "attachment;filename=" +FileName+ "");
                //Response.Cache.SetCacheability(HttpCacheability.NoCache);
                //DataGrid.RenderControl(hw);
                //StringReader sr = new StringReader(sw.ToString());
                //Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
                //HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                //PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
                //pdfDoc.Open();
                //htmlparser.Parse(sr);
                //pdfDoc.Close();
                //Response.Write(pdfDoc);
                //Response.End();
                ////ExportToPDF(tableToExport, FileName);
                return null;
            }
        }


        public DataTable ConvertListToDataTableArea(DataTable datadt, string MDLAttrName = "", params string[] ColumnsToTake)
        {
            DataTable dt = new DataTable();
            // dt.Columns.Add("Sr. No.", typeof(string));
            foreach (string s in ColumnsToTake)
            {
                dt.Columns.Add(s, typeof(string));
            }
            // int index = 1;
            foreach (DataRow lstdr in datadt.Rows)
            {
                DataRow dr = dt.NewRow();
                // dr["Sr. No."] = index.ToString();
                var stringArray = MDLAttrName.Split(',');
                int i = 0;
                foreach (string s in ColumnsToTake)
                {
                    dr[s] = lstdr[stringArray[i]].ToString();
                    i = i + 1;
                }
                // index = index + 1;
                dt.Rows.Add(dr);
            }
            return dt;
        }
        #endregion

        /// <summary>
        /// Purpose:-Method to convert data table to CSV File
        /// </summary>
        /// <param name="tableToExport"></param>
        /// <returns>Object Of String Bulder Class</returns>
        public StringBuilder ExportToCSV(DataTable tableToExport)
        {
            StringBuilder sb = new StringBuilder();
            IEnumerable<string> columnNames = tableToExport.Columns.Cast<DataColumn>().
                                            Select(column => column.ColumnName);

            sb.AppendLine(string.Join(",", columnNames));
            foreach (DataRow row in tableToExport.Rows)
            {
                string[] fields = row.ItemArray.Select(field => field.ToString()).
                                                ToArray();
                sb.AppendLine(string.Join(",", fields));
            }
            return sb;
        }


        /// <summary>
        /// /// created by: Vinish
        /// created date:11-01-2020
        /// Export PDF From Data Table
        /// </summary>
        /// <param name="tableToExport"></param>
        /// <param name="HeaderText"></param>
        /// <param name="FileName"></param>
        /// <returns></returns>
        public byte[] ExportPDF(DataTable tableToExport, string HeaderText, string FileName = "")
        {
            byte[] bytes = null;
            // DataTable tableToExport = new DataTable();
            // tableToExport = ConvertListToDataTable(ListToDataTable<T>(data), MDLAttrName, ColumnsToTake);
            // string url = "";
            //*my code start-----------------*//
            StringBuilder strhtml = new StringBuilder();
            strhtml.Append("<html>");
            strhtml.Append("<head>");
            strhtml.Append("</head>");
            strhtml.Append("<body style='font-family:Helvetica,Arial,sans-serif;font-size:8pt;'>");
            // strhtml.Append("<table width='100%' border='1px' cellspacing='0' cellpadding='3' style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;line-height:10pt;'>");

            strhtml.Append("<div>");
            //correct code start//

            strhtml.Append("<div style='width:100%'>");
            strhtml.Append("<div style='width:40%;'><img src='D:/Multilingual/Gyanmitras/Gyanmitras/app-assets/images/logo/logo-dark.png' alt='logo' height='40px' weight='124px'/></div>");
            strhtml.Append("<div style='width:98%;font-weight:bold;text-align:right'>" + HeaderText.ToString() + "</div>");
            strhtml.Append("</div>");
            strhtml.Append("<hr/>");
            //correct code End//


            //code start text
            //strhtml.Append("<table>");
            //strhtml.Append("<tr><td><img src='D:/Multilingual/Gyanmitras/Gyanmitras/app-assets/images/logo/logo-dark.png' alt='logo' height='40px' weight='124px'/>"+"<p align='center'>"+ HeaderText.ToString()+ "</p></td></tr></table>");
            //// strhtml.Append("<td>" + HeaderText.ToString() + "</td></tr></table>");
            ////code End text


            strhtml.Append("<table width='100%' border='1' cellspacing='0' cellpadding='3' style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;'>");

            // strhtml.Append("<table class='table table-striped table-bordered dataTable mb-0' width='100%' style='font-family:Helvetica,Arial, sans-serif;font-size:8pt;border:'1px;''>");

            strhtml.Append("<tbody>");

            strhtml.Append("<tr>");
            for (int i = 0; i < tableToExport.Columns.Count; i++)
            {
                strhtml.Append("<th  class='thback' style='bgcolor:'#FF0000';font-color:'#fff';border:'1';font-family:Helvetica,Arial,sans-serif;font-size:8pt;margin:0;background-color:'black'; color:'white';' align='center'>" + tableToExport.Columns[i].ToString() + "</th>");
            }
            strhtml.Append("</tr>");

            for (int i = 0; i < tableToExport.Rows.Count; i++)
            {
                strhtml.Append("<tr>");
                for (int j = 0; j < tableToExport.Columns.Count; j++)
                {
                    strhtml.Append("<td  style='font-family:Helvetica,Arial,sans-serif;font-size:8pt;' align='center'>" + tableToExport.Rows[i][j].ToString() + "</td>");
                    // table.AddCell(tableToExport.Rows[i][j].ToString());
                }
                strhtml.Append("</tr>");
            }

            strhtml.Append("</tbody>");
            strhtml.Append("</table>");
            strhtml.Append("</div>");
            strhtml.Append("</body>");
            strhtml.Append("</html>");

            string HTMLContent = strhtml.ToString();
            StringReader sr = new StringReader(strhtml.ToString());

            // comment code start//
            //Boilerplate iTextSharp setup here
            //  Create a stream that we can write to, in this case a MemoryStream
            using (var ms = new MemoryStream())
            {

                //Create an iTextSharp Document which is an abstraction of a PDF but **NOT** a PDF
                using (var doc = new Document(PageSize.A4, 10f, 10f, 10f, 10f))
                {

                    //Create a writer that's bound to our PDF abstraction and our stream
                    using (var writer = PdfWriter.GetInstance(doc, ms))
                    {

                        //Open the document for writing
                        doc.Open();
                        // doc.Add(new Chunk("")); // << this will do the trick. 

                        //Our sample HTML and CSS
                        string example_html = strhtml.ToString();
                        string example_css = @"td{border='1px'}.borLeft{border-left:1px;}.borRight{border-right:1px;}.borTop{border-top:1px;}.borBottom{border-bottom:1px;}
                                                .dotted{font-family: Helvetica, Arial, sans-serif;line-height: 10pt;font-weight: bold;margin: 0;text-align:center;border:1px dashed #000;padding: 10pt 15pt;float:right;}
                                        .thback{background-color: #bde9ba;} 
                                                ";

                        //  string example_css = @"";
                        //In order to read CSS as a string we need to switch to a different constructor
                        //that takes Streams instead of TextReaders.
                        //Below we convert the strings into UTF8 byte array and wrap those in MemoryStreams
                        using (var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(example_css)))
                        {
                            using (var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(example_html)))
                            {

                                //Parse the HTML
                                iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                            }
                        }
                        doc.Close();
                    }
                }

                //After all of the PDF "stuff" above is done and closed but **before** we
                //close the MemoryStream, grab all of the active bytes from the stream
                bytes = ms.ToArray();
            }
            // comment code end
            return bytes;
        }


    }
}