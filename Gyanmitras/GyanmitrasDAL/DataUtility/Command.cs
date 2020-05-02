using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasDAL.DataUtility
{ 
    /// <summary>
  /// use to create sql command
  /// </summary>
    public class Command
    { 
        /// <summary>
      /// return sql command.
      /// </summary>C:\Sachin\CurrentProject\VintyImpex\DataUtility\Command.cs
        public SqlCommand getCommand
        {
            get
            {
                Connection con = new Connection();
                return con.getConnection.CreateCommand();
            }
        }

    }
}
