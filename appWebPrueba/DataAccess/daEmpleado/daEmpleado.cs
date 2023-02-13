using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;
//<<<<<< HEAD
//13022023
///=======
///>>>> 4ae8ac72b29d62b0ef945c8339197a06d53752b1

namespace appWebPrueba.DataAccess.daEmpleado
{
    public class daEmpleado
    {
        //Esta lista es para mostrar los datos del empleado
        public static List<GridEmpleado> getGridEmpleado(int EmpleadoID)
        {
            List<GridEmpleado> gridEmpleado = new List<GridEmpleado>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "intEmpleadoID", Tipo = SqlDbType.Int, Valor = EmpleadoID });

                Conexion cn = new Conexion("cnnAppWebPrueba");
                DataTable Results = cn.ExecSP("qry_Empleado_Sel", lParams);

                gridEmpleado = (
                    from DataRow dr in Results.Rows
                    select new GridEmpleado
                    {
                        intEmpleadoID = int.Parse(dr["intEmpleadoID"].ToString()),
                        strNombres = dr["strNombres"].ToString(),
                        strApPaterno = dr["strApPaterno"].ToString(),
                        strApMaterno = dr["strApMaterno"].ToString(),
                        intNumEmpleado = int.Parse(dr["intNumEmpleado"].ToString()),
                        intRol = int.Parse(dr["intRol"].ToString()),
                        strRol = dr["strRol"].ToString(),
                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intEmpleadoID"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridEmpleado;
            }

            return gridEmpleado;
        }

        public static Resultado EliminarEmpleado(int EmpleadoID, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                lParams.Add(new Parametros { Nombre = "intEmpleadoID", Tipo = SqlDbType.Int, Valor = EmpleadoID });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });

                DataTable Results = cn.ExecSP("qry_Empleado_Del", lParams);
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


        public static Resultado GuardarEmpleado(string Nombres, string ApPaterno, string ApMaterno, int NumEmpleado, int Rol, bool Activo, string Usuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                lParams.Add(new Parametros { Nombre = "strNombres", Tipo = SqlDbType.NVarChar, Valor = Nombres });
                lParams.Add(new Parametros { Nombre = "strApPaterno", Tipo = SqlDbType.NVarChar, Valor = ApPaterno });
                lParams.Add(new Parametros { Nombre = "strApMaterno", Tipo = SqlDbType.NVarChar, Valor = ApMaterno });
                lParams.Add(new Parametros { Nombre = "intNumEmpleado", Tipo = SqlDbType.Int, Valor = NumEmpleado });
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = Rol });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });

                DataTable Results = cn.ExecSP("qry_Empleado_APP", lParams);
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


        public static EmpleadoVM EditarEmpleado(int EmpleadoID)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            EmpleadoVM empleado = new EmpleadoVM();
            Rol rol = new Rol();
            try
            {
                lParams.Add(new Parametros { Nombre = "intEmpleadoID", Tipo = SqlDbType.Int, Valor = EmpleadoID });

                DataTable Results = cn.ExecSP("qry_getEmpleado_Sel", lParams);
                empleado = (
                     from DataRow dr in Results.Rows
                     select new EmpleadoVM
                     {
                         intEmpleadoID = int.Parse(dr["intEmpleadoID"].ToString()),
                         strNombres = dr["strNombres"].ToString(),
                         strApPaterno = dr["strApPaterno"].ToString(),
                         strApMaterno = dr["strApMaterno"].ToString(),
                         intNumEmpleado = int.Parse(dr["intNumEmpleado"].ToString()),
                         intRol = int.Parse(dr["intRol"].ToString()),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();

                rol = (
                    from DataRow dr in Results.Rows
                    select new Rol
                    {
                        RolID = dr["intRol"].ToString(),
                        Nombre = dr["strNombreRol"].ToString(),
                    }).FirstOrDefault();

                empleado.Rol = rol;
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return empleado;
            }
            return empleado;
        }

        public static Resultado GuardaEditEmpleado(int EmpleadoID, string Nombres, string ApPaterno, string ApMaterno, int NumEmpleado, int Rol, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                lParams.Add(new Parametros { Nombre = "intEmpleadoID", Tipo = SqlDbType.NVarChar, Valor = EmpleadoID });
                lParams.Add(new Parametros { Nombre = "strNombres", Tipo = SqlDbType.NVarChar, Valor = Nombres });
                lParams.Add(new Parametros { Nombre = "strApPaterno", Tipo = SqlDbType.NVarChar, Valor = ApPaterno });
                lParams.Add(new Parametros { Nombre = "strApMaterno", Tipo = SqlDbType.NVarChar, Valor = ApMaterno });
                lParams.Add(new Parametros { Nombre = "intNumEmpleado", Tipo = SqlDbType.Int, Valor = NumEmpleado });
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = Rol });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });

                DataTable Results = cn.ExecSP("qry_Empleado_Upd", lParams);
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

        public static List<Rol> GetListaRoles()
        {
            List<Rol> rol = new List<Rol>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnAppWebPrueba");
                DataTable Results = cn.ExecSP("qry_ListarRolesActivos_SEL", lParams);

                rol = (
                    from DataRow dr in Results.Rows
                    select new Rol
                    {
                        RolID = dr["intRol"].ToString(),
                        Nombre = dr["strNombre"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return rol;
            }
            return rol;
        }
    }
}