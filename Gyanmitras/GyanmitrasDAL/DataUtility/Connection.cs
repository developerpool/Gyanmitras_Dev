using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GyanmitrasDAL.DataUtility
{
  public  class Connection
    { 
        /// <summary>
      /// return connection string.
      /// </summary>
        public string connectionString
        {
            get
            {

                string ConString = ConfigurationManager.ConnectionStrings["connectionString"].ToString();
                if (string.IsNullOrWhiteSpace(ConString))
                {
                    throw new ApplicationException("connection string not found in web.config");
                }

                return ConString;
            }
        }
        /// <summary>
        /// return new sql connection.
        /// </summary>        
        public SqlConnection getConnection
        {
            get
            {
                try
                {
                    new SqlConnection(connectionString);
                }
                catch (Exception Ex)
                {

                }
                return new SqlConnection(connectionString);
            }
        }
    }
}
