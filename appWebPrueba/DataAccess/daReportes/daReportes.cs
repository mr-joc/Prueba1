using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;

namespace appWebPrueba.DataAccess.daReportes
{
    public class daReportes
    {


        public static List<GridAdeudosXDr> getGridAdeudosDR(int intDoctor, int intPagado, string User)
        {
            //Instanciamos "gridAdministrarMenu"
            List<GridAdeudosXDr> gridAdeudosXDr = new List<GridAdeudosXDr>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Declaramos los parámetros
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = intDoctor });
                lParams.Add(new Parametros { Nombre = "@intPagado", Tipo = SqlDbType.Int, Valor = intPagado });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = User });

                //Usamos la conexión ejecutando el siguiente SP
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_AdeudosDoctor_PorUsuario", lParams);

                gridAdeudosXDr = (
                    from DataRow dr in Results.Rows
                    select new GridAdeudosXDr
                    {
                        intOrdenLaboratorioEnc = dr["intOrdenLaboratorioEnc"].ToString(),
                        strNombrePaciente = dr["strNombrePaciente"].ToString(),
                        strDoctor = dr["strDoctor"].ToString(),
                        strTipoProtesis = dr["strTipoProtesis"].ToString(),
                        strProceso = dr["strProceso"].ToString(),
                        strDetalle = dr["strDetalle"].ToString(),
                        datEntrega = dr["datEntrega"].ToString(),
                        datEntregaReal = dr["datEntregaReal"].ToString(),
                        intDiasRetraso = dr["intDiasRetraso"].ToString(),
                        dblCosto = decimal.Parse(dr["dblCosto"].ToString()),
                        dblPagado = decimal.Parse(dr["dblPagado"].ToString()),
                        dblSaldo = decimal.Parse(dr["dblSaldo"].ToString()),
                        strComentario = dr["strComentario"].ToString(),
                        strObservaciones = dr["strObservaciones"].ToString(),
                        intEstatus = dr["intEstatus"].ToString(),
                        strEstatus = dr["strEstatus"].ToString(),
                        strEstatus2 = dr["strEstatus2"].ToString(),


                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridAdeudosXDr;
            }

            //Devolvemos la lista
            return gridAdeudosXDr;
        }



        public static List<DoctoresR> GetDoctoresActivos()
        {
            List<DoctoresR> doctores = new List<DoctoresR>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intActivo", Tipo = SqlDbType.Int, Valor = 1 });
                DataTable Results = cn.ExecSP("qry_V2_Doctor_Sel", lParams);

                doctores = (
                    from DataRow dr in Results.Rows
                    select new DoctoresR
                    {
                        DoctorID = dr["intDoctor"].ToString(),
                        Nombre = dr["strNombreCompleto"].ToString(),
                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return doctores;
            }
            return doctores;
        }

        public static List<Pagado> getDataTrabajoPagado()
        {
            List<Pagado> pago = new List<Pagado>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intPagado", Tipo = SqlDbType.Int, Valor = 2 });
                DataTable Results = cn.ExecSP("qryTipoTrabajoPagado_Sel", lParams);

                pago = (
                    from DataRow dr in Results.Rows
                    select new Pagado
                    {
                        intTipo = dr["intTipo"].ToString(),
                        strNombre = dr["strNombre"].ToString(),
                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return pago;
            }
            return pago;
        }

    }
}