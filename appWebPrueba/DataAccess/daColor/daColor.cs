using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;


namespace appWebPrueba.DataAccess.daColor
{
    public class daColor
    {
        public static List<GridColor> getGridColor(int ColorID)
        {
            List<GridColor> gridColor = new List<GridColor>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intColorID", Tipo = SqlDbType.Int, Valor = ColorID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_Color_Sel", lParams);

                gridColor = (
                    from DataRow dr in Results.Rows
                    select new GridColor
                    {
                        intColor = int.Parse(dr["intColorID"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        strColorimetro = dr["strColorimetro"].ToString(),
                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intColorID"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridColor;
            }
            return gridColor;
        }

        public static Resultado EliminarColor(int intColor, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intColor", Tipo = SqlDbType.Int, Valor = intColor });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_Color_Del", lParams);
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

        public static Resultado GuardarColor(string Nombre, int intColorimetro, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@intColorimetro", Tipo = SqlDbType.Int, Valor = intColorimetro });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuarioGuarda", Tipo = SqlDbType.NVarChar, Valor = strUsuario });

                DataTable Results = cn.ExecSP("qry_V2_Color_APP", lParams);
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

        public static ColorVM EditarColor(int intColor)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            ColorVM color = new ColorVM();
            Colorimetro colorimetro = new Colorimetro();
            try
            {
                lParams.Add(new Parametros { Nombre = "@intColorID", Tipo = SqlDbType.Int, Valor = intColor });

                DataTable Results = cn.ExecSP("qry_V2_getColor_Sel", lParams);
                color = (
                     from DataRow dr in Results.Rows
                     select new ColorVM
                     {
                         intColorID = int.Parse(dr["intColorID"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         intColorimetro = int.Parse(dr["intColorimetro"].ToString()),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();


                //Agregamos la lista de Roles al modelo del Usuario
                colorimetro = (
                    from DataRow dr in Results.Rows
                    select new Colorimetro
                    {
                        ColorimetroID = dr["intColorimetro"].ToString(),
                        NombreColorimetro = dr["strColorimetro"].ToString(),
                    }).FirstOrDefault();

                color.Colorimetro = colorimetro;




            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return color;
            }
            return color;
        }

        public static Resultado GuardaEditColor(int intColor, string Nombre, int intColorimetro, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intColorID", Tipo = SqlDbType.Int, Valor = intColor });
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre }); 
                lParams.Add(new Parametros { Nombre = "@intColorimetro", Tipo = SqlDbType.Int, Valor = intColorimetro });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuarioGuarda", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_Color_Upd", lParams);

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

        public static List<Colorimetro> GetListaColorimetro()
        {
            List<Colorimetro> colorimetro = new List<Colorimetro>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_ListarColorimetrosActivos_SEL", lParams);

                colorimetro = (
                    from DataRow dr in Results.Rows
                    select new Colorimetro
                    {
                        ColorimetroID = dr["intColorimetro"].ToString(),
                        NombreColorimetro = dr["strNombreColorimetro"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return colorimetro;
            }
            return colorimetro;
        }

    }
}