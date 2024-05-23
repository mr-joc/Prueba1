using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;
using Newtonsoft.Json;
using System.Text;
using appWebPrueba.Helpers;

namespace appWebPrueba.DataAccess.daProduction
{
    public class daProduction
    {

        public static List<JobDetail> getJobsPendientesYesos(string Usuario)
        {
            List<JobDetail> lres = new List<JobDetail>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "Usuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                DataTable Results = cn.ExecSP("sp_ConsultaJobPendientesYesos_Sel", lParams);

                lres.AddRange(from DataRow dr in Results.Rows
                              select new JobDetail
                              {
                                  JobNum = dr["JobNum"].ToString(),
                                  JobPartNum = dr["JobPartNum"].ToString(),
                                  OrderNum = int.Parse(dr["OrderNum"].ToString()),
                                  intAntiguedadDias = int.Parse(dr["intAntiguedadDias"].ToString()),
                                  OrderLine = int.Parse(dr["OrderLine"].ToString()),
                                  OrderRel = int.Parse(dr["OrderRel"].ToString()),
                                  OrderDate = DateTime.Parse(dr["OrderDate"].ToString()),
                                  Status_Entrega = int.Parse(dr["Status_Entrega"].ToString()),
                                  JobPartDesc = dr["JobPartDesc"].ToString(),
                              }); ;
            }
            catch (Exception e)
            {
                throw e;
            }
            return lres;
        }


        public static List<GridResumenProduccion> getResumenUsuarioXTurno(DateTime Fecha, string Usuario, string strDepartamento)
        {
            List<GridResumenProduccion> lres = new List<GridResumenProduccion>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "datFecha", Tipo = SqlDbType.Date, Valor = Fecha });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                lParams.Add(new Parametros { Nombre = "strDepartamento", Tipo = SqlDbType.NVarChar, Valor = strDepartamento });

                DataTable Results = cn.ExecSP("spResumenTurnoXUsuario", lParams);

                lres.AddRange(from DataRow dr in Results.Rows
                              select new GridResumenProduccion
                              {
                                  strDepartamentoActual = dr["strMesaActual"].ToString(),
                                  intAcumuladoSemanal = int.Parse(dr["intAcumuladoSemanal"].ToString()),
                                  intPromedio = int.Parse(dr["intPromedio"].ToString()),
                                  intAcumuladoHoy = int.Parse(dr["intAcumuladoHoy"].ToString()),
                                  intPendientes = int.Parse(dr["intPendientes"].ToString()),
                              });
            }
            catch (Exception e)
            {
                throw e;
            }

            return lres;
        }

        public static Resultado RegistraOperacionJOB(string JobNum, int Operacion, string Usuario)
        {
            string jobCorto = JobNum.Replace("httpsÑ--chart.googleapis.com-chart_chl¿", "");
            string jobCorregido = jobCorto.Replace("'", "-");

            Resultado res = new Resultado();
            res.OK = true;
            List<Parametros> lParams = new List<Parametros>();

            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@JobNum", Tipo = SqlDbType.NVarChar, Valor = jobCorregido });
                lParams.Add(new Parametros { Nombre = "@intOperacion", Tipo = SqlDbType.NVarChar, Valor = Operacion });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });

                DataTable Results = cn.ExecSP("spJobsOperaciones_UPD", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                res.Mensaje = (from DataRow dr in Results.Rows select dr["Resultado"].ToString()).FirstOrDefault();
            }
            catch (Exception ex)
            {
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            return res;
        }

        public static List<GraficaXHora> getReporteProductividadXHora_Grafico(string Usuario, DateTime FechaIni, DateTime FechaFin, int TipoRegistro, int TipoDato, string UsuarioConsulta, string strLinea)
        {

            List<GraficaXHora> lres = new List<GraficaXHora>();
            try
            {
                int algo1 = 0;
                string JSONresult1;
                string JSONresult2;

                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "Usuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                lParams.Add(new Parametros { Nombre = "FechaIni", Tipo = SqlDbType.DateTime, Valor = FechaIni });
                lParams.Add(new Parametros { Nombre = "FechaFin", Tipo = SqlDbType.DateTime, Valor = FechaFin });
                lParams.Add(new Parametros { Nombre = "TipoRegistro", Tipo = SqlDbType.Int, Valor = TipoRegistro });
                lParams.Add(new Parametros { Nombre = "TipoDato", Tipo = SqlDbType.Int, Valor = TipoDato });
                lParams.Add(new Parametros { Nombre = "UsuarioConsulta", Tipo = SqlDbType.NVarChar, Valor = UsuarioConsulta });
                lParams.Add(new Parametros { Nombre = "strLinea", Tipo = SqlDbType.NVarChar, Valor = strLinea });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results1 = cn.ExecSP("qry_ReporteProductividadXHora_SEL", lParams);
                DataTable Results = GetDataTablePivot(Results1, "intLinea");

                JSONresult1 = JsonConvert.SerializeObject(Results);
                JSONresult2 = DataTableToJsonObj(Results).Replace("{},", "").Replace("[", "").Replace("]", "").Replace("},{", "@").Replace("}", "").Replace("{", "");

                string[] arr = JSONresult2.Split('@');

                string Lineas = arr[0];
                string Perfiles = arr[1];
                string Telas = arr[2];
                string Embobinado = arr[3];
                string Alturas = arr[4];
                string Empaque = arr[5];

                lres.AddRange(from DataRow dr in Results.Rows
                              select new GraficaXHora
                              {

                                  jSonReport = Code.ExtraeDataRow<string>(JSONresult2),
                                  gLineas = Code.ExtraeDataRow<string>(Lineas),
                                  gPerfiles = Code.ExtraeDataRow<string>(Perfiles),
                                  gTelas = Code.ExtraeDataRow<string>(Telas),
                                  gEmbobinado = Code.ExtraeDataRow<string>(Embobinado),
                                  gAlturas = Code.ExtraeDataRow<string>(Alturas),
                                  gEmpaque = Code.ExtraeDataRow<string>(Empaque),
                              });
                int algo = 0;
            }
            catch (Exception e)
            {
                throw e;
            }
            return lres;
        }

        public static string DataTableToJsonObj(DataTable dt)
        {
            DataSet ds = new DataSet();
            ds.Merge(dt);
            StringBuilder JsonString = new StringBuilder();
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                JsonString.Append("[");
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    JsonString.Append("{");
                    for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                    {
                        if (j < ds.Tables[0].Columns.Count - 1)
                        {
                            if ((i != 0) && (j != 0))
                            {
                                if (i == 1)
                                {
                                    JsonString.Append("" + ds.Tables[0].Rows[i][j].ToString() + "|");
                                }
                                else
                                {
                                    JsonString.Append(ds.Tables[0].Rows[i][j].ToString() + ",");
                                }
                            }
                        }
                        else if (j == ds.Tables[0].Columns.Count - 1)
                        {
                            if ((i != 0) && (j != 0))
                            {
                                if (i == 1)
                                {
                                    JsonString.Append("" + ds.Tables[0].Rows[i][j].ToString() + "");

                                }
                                else
                                {
                                    JsonString.Append(ds.Tables[0].Rows[i][j].ToString() + "");
                                }
                            }
                        }
                    }
                    if (i == ds.Tables[0].Rows.Count - 1)
                    {
                        JsonString.Append("}");
                    }
                    else
                    {
                        JsonString.Append("},");
                    }
                }
                JsonString.Append("]");
                return JsonString.ToString();
            }
            else
            {
                return null;
            }
        }

        public static DataTable GetDataTablePivot(DataTable table, string columnX)
        {
            //Create a DataTable to Return
            DataTable returnTable = new DataTable();

            if (columnX == "")
                columnX = table.Columns[0].ColumnName;


            returnTable.Columns.Add(columnX);
            List<string> columnXValues = new List<string>();


            foreach (DataRow dr in table.Rows)
            {
                string columnXTemp = dr[columnX].ToString();
                if (!columnXValues.Contains(columnXTemp))
                {
                    columnXValues.Add(columnXTemp);
                    returnTable.Columns.Add(columnXTemp);
                }
                else
                {
                    throw new Exception("The inversion used must have " +
                                        "unique values for column " + columnX);
                }
            }

            foreach (DataColumn dc in table.Columns)
            {
                if (!columnXValues.Contains(dc.ColumnName))
                {
                    DataRow dr = returnTable.NewRow();
                    dr[0] = dc.ColumnName;
                    returnTable.Rows.Add(dr);
                }
            }
            for (int i = 0; i < returnTable.Rows.Count; i++)
            {
                for (int j = 1; j < returnTable.Columns.Count; j++)
                {
                    returnTable.Rows[i][j] =
                      table.Rows[j - 1][returnTable.Rows[i][0].ToString()].ToString();
                }
            }
            return returnTable;
        }

    }
}