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
        //Esta clase la usaremos siempre para conectarnos a la BD, todas las conexiones pasan por aquí  lo único que necesitamos es saber a que "Ambiente" requerimos conectarnos, el nombre del SP y los parámetros que necesita para funcionar

        //Primero declaramos la variable "gEnviroment"
        private string gEnviroment;

        //Para conectarnos, al mandar el ambiente este se llamará "cnnLabAllCeramic" (puedes usar diferentes ambientes para conectarte a diferentes BD desde el mismo programa)
        public Conexion(string Ambiente)
        {
            //Igualamos la variable previamente declarada al ambiente
            gEnviroment = Ambiente;
        }
        //Y resulta que el nombre del ambiente debe ser el nombre de un "connectionStrings" de nuestro web.config, por ejemplo si te conectas a varias BD entonces las colocas en el .config y luego vas cambiando de ambiente para trabajar)
        private string GetConnectionString()
        {
            //Aqui tomamos los valores de la cadena de conexión que ya mencionamos que está en el web.config
            return System.Configuration.ConfigurationManager.ConnectionStrings[gEnviroment].ConnectionString;
        }


        //La siguiente función es la que se conecta a la BD, esta recibe la lista de parámetros
        public DataTable ExecSP(string Sp, List<Parametros> lParams, string TableName = null, int Indice = 0)
        {
            DataTable myTable = new DataTable();
            DataTable table = new DataTable();

            if (TableName != null)
            {
                table = new DataTable(TableName);
            }
            //Usamos la cadena de conexión 
            using (var con = new SqlConnection(GetConnectionString()))
            using (var cmd = new SqlCommand(Sp, con))
            {
                //Vamos separando la lista que trae los parámetros  y los vamos asignando como cmd.Parameters
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
                //Nos conectamos ahora sí a la BD
                using (var da = new SqlDataAdapter(cmd))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    /* Se Agrego un codigo para seleccionar que Indice quieres seleccionar*/
                    if (Indice > 0)
                    {
                        da.TableMappings.Add("Table", "Table");
                        da.TableMappings.Add("Table1", "Table1");
                        //Llenamos un Dataset
                        DataSet ds = new DataSet();
                        da.Fill(ds);
                        //y se lo asignamos a una datatable
                        table = ds.Tables[Indice];
                    }
                    else
                    {
                        da.Fill(table);
                    }
                }
            }
            //Retornamos ese DataTable
            return table;
        }

        //Con esta función podemos convertir el Nulo en "", en caso de NO ser nulo pues devolvemos el parámetro
        string NullToString(object Value)
        {
            return Value == null ? "" : Value.ToString();
        }

        //Esta función es para convertir la fecha a STRING
        public string dtToString(object dt, string format)
        {
            return dt == null ? "01-01-0001" : ((DateTime)dt).ToString(format);
        }
    }
}