using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasMDL.User
{
    public class SiteUserEducationDetailsMDL
    {
        public int ID { get; set; }
        public Int64 FK_UserID { get; set; }
        public string Education_Type { get; set; }
        public string Class { get; set; }
        public int FK_BoardID { get; set; }
        public int FK_StreamID { get; set; }
        public string Currentsemester { get; set; }
        public string UniversityName { get; set; }
        public string NatureOFCompletion { get; set; }
        public decimal Percentage { get; set; }
        public string Previous_Class { get; set; }
        public int FK_Previous_Class_Board { get; set; }
        public decimal Previous_Class_Percentage { get; set; }
        public string Year_of_Passing { get; set; }
        public string Fk_UserName { get; set; }
        public string CourseName { get; set; }
        public string Specification { get; set; }
        public string OtherWork { get; set; }
        public string StreamName { get; set; }
        public string PreviousClassBoardName { get; set; }
        public string BoardName{ get; set; }
        
    }
}
