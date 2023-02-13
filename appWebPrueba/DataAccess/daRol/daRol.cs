using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;

namespace appWebPrueba.DataAccess.daRol
{
    public class daRol
    {
        public static List<GridRol> getGridRol(int RolID)
        {
            List<GridRol> gridRol = new List<GridRol>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = RolID });

                Conexion cn = new Conexion("cnnAppWebPrueba");
                DataTable Results = cn.ExecSP("qry_Rol_Sel", lParams);

                gridRol = (
                    from DataRow dr in Results.Rows
                    select new GridRol
                    {
                        intRol = int.Parse(dr["intRol"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        isAdministrativo = bool.Parse(dr["isAdministrativo"].ToString()),
                        isOperativo = bool.Parse(dr["isOperativo"].ToString()),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intRol"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridRol;
            }

            return gridRol;
        }

        public static Resultado EliminarRol(int intRol, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = intRol });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });

                DataTable Results = cn.ExecSP("qry_Rol_Del", lParams);
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


        public static Resultado GuardarRol(string Nombre, bool Administrativo, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                lParams.Add(new Parametros { Nombre = "strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "IsAdministrativo", Tipo = SqlDbType.Bit, Valor = Administrativo });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });

                DataTable Results = cn.ExecSP("qry_Rol_APP", lParams);
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


        public static RolVM EditarRol(int intRol)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            RolVM rol = new RolVM();
            try
            {
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = intRol });

                DataTable Results = cn.ExecSP("qry_getRol_Sel", lParams);
                rol = (
                     from DataRow dr in Results.Rows
                     select new RolVM
                     {
                         intRolID = int.Parse(dr["intRol"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         IsAdministrativo = bool.Parse(dr["isAdministrativo"].ToString()),
                         IsOperativo = bool.Parse(dr["isOperativo"].ToString()),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return rol;
            }
            return rol;
        }

        public static Resultado GuardaEditRol(int intRol, string Nombre, bool Administrativo, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = intRol });
                lParams.Add(new Parametros { Nombre = "strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "IsAdministrativo", Tipo = SqlDbType.Bit, Valor = Administrativo });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });

                DataTable Results = cn.ExecSP("qry_Rol_Upd", lParams);
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