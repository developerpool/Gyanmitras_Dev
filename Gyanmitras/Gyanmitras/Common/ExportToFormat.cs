using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//using iTextSharp;
//using DocumentFormat.OpenXml;
//using iTextSharp.text;
//using ClosedXML;
//using iTextSharp.text.html.simpleparser;
//using iTextSharp.text.pdf;
using System.Text;
using System.Web.Mvc;
using System.Collections.Generic;
//using FTSMDLClassLibrary.ATMS;
//using ClosedXML.Excel;

namespace FleetTrackingSystem.Common
{
    public class ExportToFormat:Controller
    {


        public void ExportToExcel(DataTable dtExport, String Name)
        {

            //HttpContext.Current.Response.Clear();
            //HttpContext.Current.Response.Buffer = true;
            //HttpContext.Current.Response.ClearContent();
            //HttpContext.Current.Response.ClearHeaders();
            //HttpContext.Current.Response.Charset = "";
            //DataGrid dgGrid = new DataGrid();
            //dgGrid.DataSource = dtExport;
            //dgGrid.DataBind();
            //string FileName = DateTime.Now.ToString("dd.MM.yyyy_HH.mm") + ".xls";
            //StringWriter strwritter = new StringWriter();
            //HtmlTextWriter htmltextwrtter = new HtmlTextWriter(strwritter);
            //HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            //HttpContext.Current.Response.ContentType = "application/vnd.ms-excel";
            //HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + Name + FileName);
            ////dgGrid.GridLines = GridLines.Both;
            ////dgGrid.HeaderStyle.Font.Bold = true;
            //dgGrid.RenderControl(htmltextwrtter);
            //HttpContext.Current.Response.Write(strwritter.ToString());
            //HttpContext.Current.Response.End();

        }

        public void ToPDF(DataTable dt, String Name)
        {
            //if (dt.Rows.Count > 0)
            //{
            //    HttpContext.Current.Response.ContentType = "application/pdf";
            //    //HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=+" + Name + DateTime.Now.ToShortDateString());
            //    HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + Name + DateTime.Now.ToShortDateString());
            //    HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            //    StringWriter sw = new StringWriter();
            //    HtmlTextWriter hw = new HtmlTextWriter(sw);
            //    DataGrid dgGrid = new DataGrid();
            //    dgGrid.DataSource = dt;
            //    dgGrid.DataBind();
            //    dgGrid.RenderControl(hw);
            //    StringReader sr = new StringReader(sw.ToString());
            //    Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
            //    HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
            //    PdfWriter.GetInstance(pdfDoc, HttpContext.Current.Response.OutputStream);
            //    pdfDoc.Open();
            //    htmlparser.Parse(sr);
            //    pdfDoc.Close();
            //    HttpContext.Current.Response.Write(pdfDoc);
            //    HttpContext.Current.Response.End();
            //}
        }
        public void exportGridToExcel(Control ctl)
        {
            //string attachment = "attachment; filename=etrack_excel_export.xls";
            //HttpContext.Current.Response.ClearContent();
            //HttpContext.Current.Response.AddHeader("content-disposition", attachment);
            //HttpContext.Current.Response.ContentType = "application/ms-excel";
            //StringWriter stw = new StringWriter();
            //HtmlTextWriter htextw = new HtmlTextWriter(stw);

            //ctl.RenderControl(htextw);
            //HttpContext.Current.Response.Write(stw.ToString());
            //HttpContext.Current.Response.End();

        }


        /// <summary>
        /// Created By : Vinish
        /// It is a utility function which takes Datatable and exports it to PDF and saves it as given name.
        /// </summary>
        /// <param name="dtPDF"> Data table which is to be exported</param>
        /// <param name="FileName">Save as "FileName" </param>

        //public void ExportToPDF(DataTable dtPDF, string FileName)
        //{
        //    GridView DataGrid = new GridView();
        //    DataGrid.AllowPaging = false;
        //    DataGrid.HeaderStyle.BackColor = System.Drawing.Color.Magenta;
        //    DataGrid.DataSource = dtPDF;
        //    DataGrid.DataBind();
        //    Response.ContentType = "application/pdf";
        //    Response.AddHeader("content-disposition", "attachment;filename=" + FileName + "_" + DateTime.Now.ToString("dd.MM.yyyy_HH.mm") + ".pdf" + "");
        //    Response.Cache.SetCacheability(HttpCacheability.NoCache);
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    DataGrid.RenderControl(hw);
        //    StringReader sr = new StringReader(sw.ToString());
        //    Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
        //    HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
        //    PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
        //    pdfDoc.Open();
        //    htmlparser.Parse(sr);
        //    pdfDoc.Close();
        //    Response.Write(pdfDoc);
        //    Response.End();
        //}
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
        
        public FileResult ExportToExcelCompletedTripReport(DataTable tableToExport, string ReportType, string ExportFormat, int ArrivalNGCount ,int DepartureNGCoint)
        {

            GridView DataGrid = new GridView();
            DataGrid.AllowPaging = false;
            DataGrid.ShowFooter = true;
            DataGrid.DataSource = tableToExport;
            DataGrid.DataBind();
            DataGrid.FooterRow.Cells[10].Text = "Total Arrival Delay for the selected time period:"+"  "+ Convert.ToString(ArrivalNGCount);            
            DataGrid.FooterRow.Cells[6].Text = "Total Depature Delay for the selected time period:"+"  "+ Convert.ToString(DepartureNGCoint);            

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

            else
            {
                return null;
            }
        }
        /// <summary>
        /// Created By :Vinish
        /// purpose: Download Dynamic html table
        /// </summary>
        /// <param name="tableToExport"></param>
        /// <param name="ReportType"></param>
        /// <param name="ExportFormat"></param>
        /// <param name="geo"></param>
        /// <param name="trip"></param>
        /// <returns></returns>
        public FileResult ExportToExcelSupplierOperationReport(DataTable tableToExport, string ReportType, string ExportFormat,String [] geo, String[] trip)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(" ", typeof(string));
            //dt.Columns.Add("Trip No.", typeof(string));
            //dt.Columns.Add("Travel Date", typeof(string));
            //for (int i = 0; i < geo.Length; i++)
            //{
            //    dt.Columns.Add("Plan Time (Min)", typeof(string));
            //    dt.Columns.Add("Actual Time (Min)", typeof(string));
            //    dt.Columns.Add("Status", typeof(string));
            //}
            DataRow dr = dt.NewRow();
            dr[" "] = " ";
            dt.Rows.Add(dr);

            GridView DataGrid = new GridView();
            DataGrid.AllowPaging = false;
            DataGrid.ShowFooter = true;
            DataGrid.DataSource = dt;
            DataGrid.DataBind();
          //  DataGrid.FooterRow.Cells[10].Text = "Total Arrival Delay for the selected time period:" + "  ";
          //  DataGrid.FooterRow.Cells[6].Text = "Total Depature Delay for the selected time period:" + "  ";
            GridViewRow HeaderRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);
            GridViewRow HeaderRow1 = new GridViewRow(0, 1, DataControlRowType.Header, DataControlRowState.Insert);
            GridViewRow footerrow = new GridViewRow(0, 1, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell footer = new TableCell();
            footer.Text = "Cumulative Delay :";
            footer.HorizontalAlign = HorizontalAlign.Center;
            footer.ColumnSpan = 3; 
            footer.BackColor = System.Drawing.Color.Gray;// GrayColor;
            footerrow.Cells.Add(footer);

            TableCell HeaderCell = new TableCell();
            HeaderCell.Text = "Route Name";
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell.RowSpan = 2; // For merging first, second row cells to one
                                    //  HeaderCell.CssClass = "HeaderStyle";
            HeaderCell.BackColor = System.Drawing.Color.Gray;// GrayColor;
            HeaderRow.Cells.Add(HeaderCell);
          //  DataGrid.Controls[0].Controls.AddAt(0, HeaderRow);

            TableCell HeaderCell2 = new TableCell();
            HeaderCell2.Text = "Trip No.";
            HeaderCell2.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell2.RowSpan = 2; // For merging first, second row cells to one
           // HeaderCell2.BackColor = "HeaderStyle";
            HeaderRow.Cells.Add(HeaderCell2);
            //DataGrid.Controls[0].Controls.AddAt(1, HeaderRow);
            TableCell HeaderCell3 = new TableCell();
            HeaderCell3.Text = "Travel Date";
            HeaderCell3.HorizontalAlign = HorizontalAlign.Center;
            HeaderCell3.RowSpan = 2; // For merging first, second row cells to one
            HeaderCell3.CssClass = "HeaderStyle";
            HeaderRow.Cells.Add(HeaderCell3);
           // DataGrid.Controls[0].Controls.AddAt(2, HeaderRow);
            for(int i=0;i<geo.Length;i++)
            {
                int ngcount = 0;
                for (int j = 0; j < tableToExport.Rows.Count; j++)
                {
                    if (tableToExport.Rows[j]["Geofence Name"].ToString() == geo[i])
                    {
                        if (tableToExport.Rows[j]["Status"].ToString() == "NG")
                        {
                            ngcount = ngcount + 1;
                        }    
                    }
                 }
                TableCell footer1 = new TableCell();
                footer1.Text = ngcount.ToString();
                footer1.HorizontalAlign = HorizontalAlign.Center;
                footer1.ColumnSpan = 3;
                footer1.BackColor = System.Drawing.Color.Gray;// GrayColor;
                footerrow.Cells.Add(footer1);

                TableCell HeaderCell4 = new TableCell();
                HeaderCell4.Text = geo[i];
                HeaderCell4.HorizontalAlign = HorizontalAlign.Center;
                HeaderCell4.ColumnSpan = 3; // For merging first, second row cells to one
                HeaderCell4.CssClass = "HeaderStyle";
                HeaderRow.Cells.Add(HeaderCell4);

                TableCell PlanTime = new TableCell();
                PlanTime.Text = "Plan Time (Min)";
                PlanTime.HorizontalAlign = HorizontalAlign.Center;
               // PlanTime.ColumnSpan = 3; // For merging first, second row cells to one
                PlanTime.CssClass = "HeaderStyle";
                HeaderRow1.Cells.Add(PlanTime);
                TableCell ActualTime = new TableCell();
                ActualTime.Text = "Actual Time (Min)";
                ActualTime.HorizontalAlign = HorizontalAlign.Center;
               // ActualTime.ColumnSpan = 3; // For merging first, second row cells to one
                ActualTime.CssClass = "HeaderStyle";
                HeaderRow1.Cells.Add(ActualTime);
                TableCell Status = new TableCell();
                Status.Text = "Status";
                Status.HorizontalAlign = HorizontalAlign.Center;
                //Status.ColumnSpan = 3; // For merging first, second row cells to one
                Status.CssClass = "HeaderStyle";
                HeaderRow1.Cells.Add(Status);
               
            }
            DataGrid.Controls[0].Controls.AddAt(2, HeaderRow);
            DataGrid.Controls[0].Controls.AddAt(3, HeaderRow1);

            for (int i = 0; i < trip.Length; i++)
            {
                GridViewRow HdrRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);
                int k = 0;
                for (int j = 0; j < tableToExport.Rows.Count; j++)
                {
                   
                    if(tableToExport.Rows[j]["Trip No."].ToString()== trip[i])
                    {
                        if (k == 0)
                        {
                            TableCell HedrCell1 = new TableCell();
                            HedrCell1.Text = tableToExport.Rows[j]["Route Name"].ToString();
                            HedrCell1.HorizontalAlign = HorizontalAlign.Center;
                            // HeaderCell.ColumnSpan = 3; // For merging first, second row cells to one
                           // HedrCell1.Style.Add("background-color", "#507CD1"); 
                            HdrRow.Cells.Add(HedrCell1);
                            TableCell HedrCell2 = new TableCell();
                            HedrCell2.Text = tableToExport.Rows[j]["Trip No."].ToString();
                            HedrCell2.HorizontalAlign = HorizontalAlign.Center;
                            // HeaderCell.ColumnSpan = 3; // For merging first, second row cells to one
                            HedrCell2.CssClass = "HeaderStyle";
                            HdrRow.Cells.Add(HedrCell2);
                            TableCell HedrCell3 = new TableCell();
                            HedrCell3.Text = tableToExport.Rows[j]["Travel Date"].ToString();
                            HedrCell3.HorizontalAlign = HorizontalAlign.Center;
                            // HeaderCell.ColumnSpan = 3; // For merging first, second row cells to one
                            HedrCell3.CssClass = "HeaderStyle";
                            HdrRow.Cells.Add(HedrCell3);
                        }
                        k = k + 1;
                        TableCell HedrCell4 = new TableCell();
                        HedrCell4.Text = tableToExport.Rows[j]["Plan time (Min)"].ToString();
                        HedrCell4.HorizontalAlign = HorizontalAlign.Center;
                        // HeaderCell.ColumnSpan = 3; // For merging first, second row cells to one
                        HedrCell4.CssClass = "HeaderStyle";
                        HdrRow.Cells.Add(HedrCell4);
                        TableCell HedrCell5 = new TableCell();
                        HedrCell5.Text = tableToExport.Rows[j]["Actual time (Min)"].ToString();
                        HedrCell5.HorizontalAlign = HorizontalAlign.Center;
                        // HeaderCell.ColumnSpan = 3; // For merging first, second row cells to one
                        HedrCell5.CssClass = "HeaderStyle";
                        HdrRow.Cells.Add(HedrCell5);
                        TableCell HedrCell6 = new TableCell();
                        HedrCell6.Text = tableToExport.Rows[j]["Status"].ToString();
                        HedrCell6.HorizontalAlign = HorizontalAlign.Center;
                        // HeaderCell.ColumnSpan = 3; // For merging first, second row cells to one
                        HedrCell6.CssClass = "HeaderStyle";
                        HdrRow.Cells.Add(HedrCell6);
                    }
                }
                DataGrid.Controls[0].Controls.AddAt(i+4, HdrRow);
            }
            DataGrid.Controls[0].Controls.AddAt(trip.Length + 4, footerrow);

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

            else
            {
                return null;
            }
        }

        //Added By :: Abhishek ::
        public FileResult ExportToExcelCompletedTripReportWithHeader(DataTable tableToExport, string ReportType, string ExportFormat, int ArrivalNGCount, int DepartureNGCoint, List<string> HeaderColumnNames, List<string> HeaderColumnData, List<string> DataListColumnNames)
        {
            GridView DataGrid = new GridView();
            DataGrid.AllowPaging = false;
            DataGrid.ShowFooter = true;
            DataGrid.ShowHeader = true;
            DataGrid.DataSource = tableToExport;
            DataGrid.DataBind();

            //Hiding header row & Extra rows
            if (DataListColumnNames.Count > HeaderColumnNames.Count)
            {
                for (int i = 0; i < DataListColumnNames.Count; i++)
                {
                    DataGrid.HeaderRow.Cells[i].Visible = false;
                    if (i <= HeaderColumnNames.Count)
                    {
                        for (int j = 0; j < DataListColumnNames.Count; j++)
                        {
                            DataGrid.Rows[i].Cells[j].BorderStyle = BorderStyle.None;
                        }
                    }
                }
            }
            else
            {
                for (int i = 0; i < HeaderColumnNames.Count; i++)
                {
                    if (i < DataListColumnNames.Count)
                    {
                        DataGrid.HeaderRow.Cells[i].Visible = false;
                    }
                    for (int j = 0; j < DataListColumnNames.Count; j++)
                    {
                        DataGrid.Rows[i].Cells[j].BorderStyle = BorderStyle.None;
                    }
                }
            }
            //Header Reoprt Name
            int HeaderCell = DataListColumnNames.Count / 3;
            DataGrid.Rows[0].Cells[HeaderCell].Text = ReportType;
            DataGrid.Rows[0].Cells[HeaderCell].ForeColor = System.Drawing.Color.GhostWhite;
            DataGrid.Rows[0].Cells[HeaderCell].Font.Bold = true;
            DataGrid.Rows[0].Cells[HeaderCell].Font.Name ="Arial";
            DataGrid.Rows[0].Height = 40;
            for(int i=0;i< DataListColumnNames.Count; i++)
            {
                DataGrid.Rows[0].Cells[i].BackColor = System.Drawing.Color.LightSlateGray;
            }

            //Searchable Header column name 
            for (int a = 1; a <= HeaderColumnNames.Count; a++)
            {
                if (a % 2 != 0)
                {
                    DataGrid.Rows[a].Cells[0].Text = HeaderColumnNames[a - 1];
                    DataGrid.Rows[a].Cells[0].Font.Bold = true;
                    DataGrid.Rows[a].Cells[0].BorderStyle = BorderStyle.None;
                    DataGrid.Rows[a].Cells[0].Height = 20;
                    DataGrid.Rows[a].HorizontalAlign = HorizontalAlign.Left;

                    DataGrid.Rows[a + 1].Visible = false;//to hide extra row 
                }

                else
                {
                    DataGrid.Rows[a - 1].Cells[2].Text = HeaderColumnNames[a - 1];
                    DataGrid.Rows[a - 1].Cells[2].Font.Bold = true;
                    DataGrid.Rows[a - 1].Cells[2].BorderStyle = BorderStyle.None;
                    DataGrid.Rows[a - 1].Cells[2].Height = 20;
                    DataGrid.Rows[a - 1].HorizontalAlign = HorizontalAlign.Left;
                }
            }
            //Searchable Header coulmn name data
            for (int c = 1; c <= HeaderColumnData.Count; c++)
            {
                if (c % 2 != 0)
                {
                    DataGrid.Rows[c].Cells[1].Text = HeaderColumnData[c - 1].ToString();
                    DataGrid.Rows[c].Cells[1].BorderStyle = BorderStyle.None;
                    DataGrid.Rows[c].Cells[1].HorizontalAlign = HorizontalAlign.Left;

                    DataGrid.Rows[c + 1].Visible = false;//to hide extra row 
                }
                else
                {
                    DataGrid.Rows[c - 1].Cells[3].Text = HeaderColumnData[c - 1].ToString();
                    DataGrid.Rows[c - 1].Cells[3].BorderStyle = BorderStyle.None;
                    DataGrid.Rows[c - 1].Cells[3].HorizontalAlign = HorizontalAlign.Left;
                }
            }
            //Hiding separation row
            for (int a = 0; a < DataListColumnNames.Count; a++)
            {
                DataGrid.Rows[HeaderColumnNames.Count+1].Cells[a].BorderStyle = BorderStyle.None;
            }
            //datatable column name
            for (int d = 0; d < DataListColumnNames.Count; d++)
            {
                DataGrid.Rows[HeaderColumnNames.Count + 2].Cells[d].Text = DataListColumnNames[d];
                DataGrid.Rows[HeaderColumnNames.Count + 2].HorizontalAlign = HorizontalAlign.Center;
                DataGrid.Rows[HeaderColumnNames.Count + 2].Font.Bold = true;
                DataGrid.Rows[HeaderColumnNames.Count + 2].Cells[d].BackColor = System.Drawing.Color.LightSlateGray;
                DataGrid.Rows[HeaderColumnNames.Count + 2].Cells[d].ForeColor = System.Drawing.Color.GhostWhite;
                DataGrid.Rows[HeaderColumnNames.Count + 2].Height = 30;
                DataGrid.Rows[HeaderColumnNames.Count + 2].Font.Name = "Arial";

                //::if No. of Searchable Header Columns are greater than DataTable Columns.
                if (DataGrid.Rows[HeaderColumnNames.Count + 2].Cells[d].Text==" ")
                {
                    int length = (tableToExport.Rows.Count) - (HeaderColumnNames.Count + 2 + 1) + 2;
                    for (int e=2;e<= length; e++)
                    {
                        DataGrid.Rows[HeaderColumnNames.Count + e].Cells[d].BorderStyle = BorderStyle.None;
                    }
                   
                }
            }
            //aligning data of datatable to center
            for (int len = HeaderColumnNames.Count + 2; len < tableToExport.Rows.Count; len++)
            {
                DataGrid.Rows[len].HorizontalAlign = HorizontalAlign.Center;
            }
            if (ArrivalNGCount < 0 || DepartureNGCoint < 0)
            {
                DataGrid.FooterRow.Visible = false;
            }
            else
            {
                DataGrid.FooterRow.Cells[10].Text = "Total Arrival Delay for the selected time period:" + "  " + Convert.ToString(ArrivalNGCount);
                DataGrid.FooterRow.Cells[6].Text = "Total Depature Delay for the selected time period:" + "  " + Convert.ToString(DepartureNGCoint);
            }

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

            else
            {
                return null;
            }
        }

    }
}