using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using appWebPrueba.Clases;

namespace appWebPrueba.DataAccess
{
    public class Conexion
    {
        private string gEnviroment;

        public Conexion(string Ambiente)
        {
            gEnviroment = Ambiente;
        }
        private string GetConnectionString()
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings[gEnviroment].ConnectionString;
        }

        public DataTable ExecSP(string Sp, List<Parametros> lParams, string TableName = null, int Indice = 0)
        {
            DataTable myTable = new DataTable();
            DataTable table = new DataTable();

            if (TableName != null)
            {
                table = new DataTable(TableName);
            }
            using (var con = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand(Sp, con))
            {
                cmd.CommandTimeout = 0;
                foreach (var item in lParams)
                {
                    //Aqui se hace un mapeo de los campos y se hacen las conversiones necesarias
                    switch (item.Tipo)
                    {
                        case SqlDbType.Bit:
                            cmd.Parameters.Add(item.Nombre, item.Tipo).Value = ((NullToString(item.Valor) == "1" || NullToString(item.Valor).ToUpper() == "TRUE") ? true : false);
                            break;
                        case SqlDbType.TinyInt:
                        case SqlDbType.SmallInt:
                            cmd.Parameters.Add(item.Nombre, item.Tipo).Value = Int16.Parse(NullToString(item.Valor));
                            break;
                        case SqlDbType.BigInt:
                            cmd.Parameters.Add(item.Nombre, item.Tipo).Value = long.Parse(NullToString(item.Valor));
                            break;
                        case SqlDbType.Int:
                            cmd.Parameters.Add(item.Nombre, item.Tipo).Value = int.Parse(NullToString(item.Valor));
                            break;
                        case SqlDbType.Decimal:
                        case SqlDbType.Real:
                        case SqlDbType.Float:
                            cmd.Parameters.Add(item.Nombre, item.Tipo).Value = decimal.Parse(NullToString(item.Valor));
                            break;
                        case SqlDbType.Date:
                        case SqlDbType.Time:
                        case SqlDbType.DateTime:
                        case SqlDbType.DateTime2:
                            cmd.Parameters.Add(item.Nombre, item.Tipo).Value = dtToString(item.Valor, "yyyy-MM-dd");
                            break;
                        case SqlDbType.Char:
                        case SqlDbType.NChar:
                            cmd.Parameters.Add(item.Nombre, item.Tipo).Value = char.Parse(NullToString(item.Valor));
                            break;
                        default:
                            cmd.Parameters.Add(item.Nombre, item.Tipo).Value = (NullToString(item.Valor) == null ? "" : NullToString(item.Valor));
                            break;
                    }
                }
                using (var da = new SqlDataAdapter(cmd))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    /* Se Agrego un codigo para seleccionar que Indice quieres seleccionar*/
                    if (Indice > 0)
                    {
                        da.TableMappings.Add("Table", "Table");
                        da.TableMappings.Add("Table1", "Table1");
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        table = ds.Tables[Indice];
                    }
                    else
                    {
                        da.Fill(table);
                    }
                }
            }
            //Retorna un DataTable
            return table;
        }

        string NullToString(object Value)
        {
            return Value == null ? "" : Value.ToString();
        }

        public string dtToString(object dt, string format)
        {
            return dt == null ? "01-01-0001" : ((DateTime)dt).ToString(format);
        }
    }
}