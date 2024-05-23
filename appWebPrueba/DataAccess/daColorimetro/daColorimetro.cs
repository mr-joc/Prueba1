using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;


namespace appWebPrueba.DataAccess.daColorimetro
{
    public class daColorimetro
    {
        public static List<GridColorimetro> getGridColorimetro(int ColorimetroID)
        {
            List<GridColorimetro> gridColorimetro = new List<GridColorimetro>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intColorimetro", Tipo = SqlDbType.Int, Valor = ColorimetroID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_Colorimetro_Sel", lParams);

                gridColorimetro = (
                    from DataRow dr in Results.Rows
                    select new GridColorimetro
                    {
                        intColorimetro = int.Parse(dr["intColorimetro"].ToString()),
                        strNombre = dr["strNombre"].ToString(),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intColorimetro"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridColorimetro;
            }
            return gridColorimetro;
        }

        public static Resultado EliminarColorimetro(int intColorimetro, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intColorimetro", Tipo = SqlDbType.Int, Valor = intColorimetro });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_Colorimetro_Del", lParams);
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

        public static Resultado GuardarColorimetro(string Nombre, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_Colorimetro_APP", lParams);
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

        public static ColorimetroVM EditarColorimetro(int intColorimetro)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            ColorimetroVM colorimetro = new ColorimetroVM();
            try
            {
                lParams.Add(new Parametros { Nombre = "@intColorimetro", Tipo = SqlDbType.Int, Valor = intColorimetro });

                DataTable Results = cn.ExecSP("qry_V2_getColorimetro_Sel", lParams);
                colorimetro = (
                     from DataRow dr in Results.Rows
                     select new ColorimetroVM
                     {
                         intColorimetroID = int.Parse(dr["intColorimetro"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return colorimetro;
            }
            return colorimetro;
        }

        public static Resultado GuardaEditColorimetro(int intColorimetro, string Nombre, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intColorimetro", Tipo = SqlDbType.Int, Valor = intColorimetro });
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_Colorimetro_Upd", lParams);
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