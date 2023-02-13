using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;

namespace appWebPrueba.DataAccess.daReportePagos
{
    public class daReportePagos
    {
        public static List<GridPagos> getGridReportePagos(int intMes, int intEmpleado)
        {
            List<GridPagos> gridPagos = new List<GridPagos>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "intMes", Tipo = SqlDbType.Int, Valor = intMes });
                lParams.Add(new Parametros { Nombre = "intEmpleado", Tipo = SqlDbType.Int, Valor = intEmpleado });

                Conexion cn = new Conexion("cnnAppWebPrueba");
                DataTable Results = cn.ExecSP("qry_CalcularSueldoTotal_SEL", lParams);

                gridPagos = (
                    from DataRow dr in Results.Rows
                    select new GridPagos
                    {
                        intNumEmpleado = int.Parse(dr["intNumEmpleado"].ToString()),
                        strNombreCompleto = dr["strNombreCompleto"].ToString(),
                        intHorasLaboradas = int.Parse(dr["intHorasLaboradas"].ToString()),
                        dblSueldoXEntregas = float.Parse(dr["dblSueldoXEntregas"].ToString()),
                        dblBonoXHoras = float.Parse(dr["dblBonoXHoras"].ToString()),
                        dblSueldoMenosISRAdicional = float.Parse(dr["dblSueldoMenosISRAdicional"].ToString()),
                        dblVales = float.Parse(dr["dblVales"].ToString()),
                        dblTotal = float.Parse(dr["dblTotal"].ToString()),

                        //ESTOS DATOS NO SE COLOCARON EN EL REPORTE PERO VAMOS A CARGARLOS POR SI CAMBIAN DE OPINIÓN
                        intEmpleadoID = int.Parse(dr["intEmpleadoID"].ToString()),
                        intRol = int.Parse(dr["intRol"].ToString()),
                        strRol = dr["strRol"].ToString(),
                        dblSueldoBase = float.Parse(dr["dblSueldoBase"].ToString()),
                        intDiasLaborados = int.Parse(dr["intDiasLaborados"].ToString()),
                        dblSueldoXHras = float.Parse(dr["dblSueldoXHras"].ToString()),
                        intCantidadEntregas = int.Parse(dr["intCantidadEntregas"].ToString()),
                        dblSueldoIntegrado = float.Parse(dr["dblSueldoIntegrado"].ToString()),
                        dblSueldoMenosISR = float.Parse(dr["dblSueldoMenosISR"].ToString()),
                        Acciones = int.Parse(dr["intEmpleadoID"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridPagos;
            }

            return gridPagos;
        }

        public static List<MesP> GetListaMeses()
        {
            List<MesP> mesP = new List<MesP>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnAppWebPrueba");
                DataTable Results = cn.ExecSP("qry_ListarMeses_SEL", lParams);

                mesP = (
                    from DataRow dr in Results.Rows
                    select new MesP
                    {
                        MesID = dr["intMes"].ToString(),
                        Nombre = dr["strNombreMes"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return mesP;
            }
            return mesP;
        }

    }
}