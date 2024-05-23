using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;

namespace appWebPrueba.DataAccess.daUnidadMedida
{
    public class daUnidadMedida
    {
        public static List<GridUnidadMedida> getGridUnidadMedida(int UnidadMedidaID)
        {
            List<GridUnidadMedida> gridUnidadMedida = new List<GridUnidadMedida>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intUnidadMedida", Tipo = SqlDbType.Int, Valor = UnidadMedidaID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_UnidadMedida_Sel", lParams);

                gridUnidadMedida = (
                    from DataRow dr in Results.Rows
                    select new GridUnidadMedida
                    {
                        intUnidadMedida = int.Parse(dr["intUnidadMedida"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        strNombreCorto = dr["strNombreCorto"].ToString(),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intUnidadMedida"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridUnidadMedida;
            }
            return gridUnidadMedida;
        }

        public static Resultado EliminarUnidadMedida(int intUnidadMedida, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intUnidadMedida", Tipo = SqlDbType.Int, Valor = intUnidadMedida });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_UnidadMedida_Del", lParams);
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

        public static Resultado GuardarUnidadMedida(string Nombre, string NombreCorto, bool Activo, string strUsuario)
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
                DataTable Results = cn.ExecSP("qry_V2_UnidadMedida_APP", lParams);
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

        public static UnidadMedidaVM EditarUnidadMedida(int intUnidadMedida)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            UnidadMedidaVM unidadMedida = new UnidadMedidaVM();
            try
            {
                lParams.Add(new Parametros { Nombre = "@intUnidadMedida", Tipo = SqlDbType.Int, Valor = intUnidadMedida });

                DataTable Results = cn.ExecSP("qry_V2_UnidadMedida_Sel", lParams);
                unidadMedida = (
                     from DataRow dr in Results.Rows
                     select new UnidadMedidaVM
                     {
                         intUnidadMedidaID = int.Parse(dr["intUnidadMedida"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         strNombreCorto = dr["strNombreCorto"].ToString(),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return unidadMedida;
            }
            return unidadMedida;
        }

        public static Resultado GuardaEditUnidadMedida(int intUnidadMedida, string Nombre, string NombreCorto, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intUnidadMedida", Tipo = SqlDbType.Int, Valor = intUnidadMedida });
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@strNombreCorto", Tipo = SqlDbType.NVarChar, Valor = NombreCorto });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_UnidadMedida_Upd", lParams);
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