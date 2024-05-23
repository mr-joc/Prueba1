using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;


namespace appWebPrueba.DataAccess.daTipoGasto
{
    public class daTipoGasto
    {
        public static List<GridTipoGasto> getGridTipoGasto(int TipoGastoID)
        {
            List<GridTipoGasto> gridTipoGasto = new List<GridTipoGasto>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intTipoGasto", Tipo = SqlDbType.Int, Valor = TipoGastoID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_TipoGasto_Sel", lParams);

                gridTipoGasto = (
                    from DataRow dr in Results.Rows
                    select new GridTipoGasto
                    {
                        intTipoGasto = int.Parse(dr["intTipoGasto"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        strNombreCorto = dr["strNombreCorto"].ToString(),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intTipoGasto"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridTipoGasto;
            }
            return gridTipoGasto;
        }

        public static Resultado EliminarTipoGasto(int intTipoGasto, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intTipoGasto", Tipo = SqlDbType.Int, Valor = intTipoGasto });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_TipoGasto_Del", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                if (res.Id != null)
                {
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            return res;
        }

        public static Resultado GuardarTipoGasto(string Nombre, string NombreCorto, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@strNombreCorto", Tipo = SqlDbType.NVarChar, Valor = NombreCorto });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_TipoGasto_APP", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();
                if (res.Id != null)
                {
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            return res;
        }

        public static TipoGastoVM EditarTipoGasto(int intTipoGasto)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            TipoGastoVM tipoGasto = new TipoGastoVM();
            try
            {
                lParams.Add(new Parametros { Nombre = "@intTipoGasto", Tipo = SqlDbType.Int, Valor = intTipoGasto });

                DataTable Results = cn.ExecSP("qry_V2_getTipoGasto_Sel", lParams);
                tipoGasto = (
                     from DataRow dr in Results.Rows
                     select new TipoGastoVM
                     {
                         intTipoGastoID = int.Parse(dr["intTipoGasto"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         strNombreCorto = dr["strNombreCorto"].ToString(),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return tipoGasto;
            }
            return tipoGasto;
        }

        public static Resultado GuardaEditTipoGasto(int intTipoGasto, string Nombre, string NombreCorto, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intTipoGasto", Tipo = SqlDbType.Int, Valor = intTipoGasto });
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@strNombreCorto", Tipo = SqlDbType.NVarChar, Valor = NombreCorto });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_TipoGasto_Upd", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();

                if (res.Id != null)
                {
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            return res;
        }
    }
}