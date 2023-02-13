using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;
namespace appWebPrueba.DataAccess.daMovimiento
{
    public class daMovimiento
    {
        //////public static List<GridMovimiento> getGridMovimiento(int MovimientoID)
        //////{
        //////    List<GridMovimiento> gridMovimiento = new List<GridMovimiento>();
        //////    try
        //////    {
        //////        List<Parametros> lParams = new List<Parametros>();
        //////        lParams.Add(new Parametros { Nombre = "intMovimientoID", Tipo = SqlDbType.Int, Valor = MovimientoID });

        //////        Conexion cn = new Conexion("cnnAppWebPrueba");
        //////        DataTable Results = cn.ExecSP("qry_Movimiento_Sel", lParams);

        //////        gridMovimiento = (
        //////            from DataRow dr in Results.Rows
        //////            select new GridMovimiento
        //////            {
        //////                intMovimientoID = int.Parse(dr["intMovimientoID"].ToString()),
        //////                strNombres = dr["strNombres"].ToString(),
        //////                strApPaterno = dr["strApPaterno"].ToString(),
        //////                strApMaterno = dr["strApMaterno"].ToString(),
        //////                intNumMovimiento = int.Parse(dr["intNumMovimiento"].ToString()),
        //////                intRol = int.Parse(dr["intRol"].ToString()),
        //////                strRol = dr["strRol"].ToString(),
        //////                Estado = bool.Parse(dr["IsActivo"].ToString()),
        //////                Acciones = int.Parse(dr["intMovimientoID"].ToString()),

        //////            }).ToList();

        //////    }
        //////    catch (Exception ex)
        //////    {
        //////        string error = ex.ToString();
        //////        return gridMovimiento;
        //////    }

        //////    return gridMovimiento;
        //////}

        //////public static Resultado EliminarMovimiento(int MovimientoID, string user)
        //////{
        //////    Resultado res = new Resultado();
        //////    List<Parametros> lParams = new List<Parametros>();
        //////    Conexion cn = new Conexion("cnnAppWebPrueba");
        //////    try
        //////    {
        //////        lParams.Add(new Parametros { Nombre = "intMovimientoID", Tipo = SqlDbType.Int, Valor = MovimientoID });
        //////        lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });

        //////        DataTable Results = cn.ExecSP("qry_Movimiento_Del", lParams);
        //////        res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
        //////        if (res.Id != null)
        //////        {
        //////            res.OK = true;
        //////        }
        //////    }
        //////    catch (Exception ex)
        //////    {
        //////        res.OK = false;
        //////        res.Mensaje = ex.Message;
        //////    }
        //////    return res;
        //////}


        public static Resultado GuardarMovimientoXMes(int intNumEmpleado, int intMes, int intCantidadEntregas, string Usuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                lParams.Add(new Parametros { Nombre = "intNumEmpleado", Tipo = SqlDbType.Int, Valor = intNumEmpleado });
                lParams.Add(new Parametros { Nombre = "intMes", Tipo = SqlDbType.Int, Valor = intMes });
                lParams.Add(new Parametros { Nombre = "intCantidadEntregas", Tipo = SqlDbType.Int, Valor = intCantidadEntregas });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });

                DataTable Results = cn.ExecSP("qry_MovimientosXMes_APP", lParams);
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

        public static MovimientoVM BuscaEmpleado(int intNumEmpleado)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            MovimientoVM movimiento = new MovimientoVM();
            Rol_a rol_a = new Rol_a();
            Mes mes = new Mes();
            try
            {
                lParams.Add(new Parametros { Nombre = "intNumEmpleado", Tipo = SqlDbType.Int, Valor = intNumEmpleado });

                DataTable Results = cn.ExecSP("qry_getDatosEmpleado_Sel", lParams);
                movimiento = (
                     from DataRow dr in Results.Rows
                     select new MovimientoVM
                     {
                         strNombreEmpleado= dr["strNombreCompleto"].ToString(),
                         strNombreRol = dr["strNombreRol"].ToString(),
                         intRol = int.Parse(dr["intRol"].ToString()),
                         intMes = int.Parse(dr["intMes"].ToString()),

                     }).FirstOrDefault();

                rol_a = (
                    from DataRow dr in Results.Rows
                    select new Rol_a
                    {
                        RolID_a = dr["intRol"].ToString(),
                        Nombre_a = dr["strNombreRol"].ToString(),
                    }).FirstOrDefault();
                movimiento.Rol_a = rol_a;

                mes = (
                    from DataRow dr in Results.Rows
                    select new Mes
                    {
                        MesID = dr["intMes"].ToString(),
                        Nombre = dr["strNombreRol"].ToString(),
                    }).FirstOrDefault();

                movimiento.Mes = mes;
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return movimiento;
            }
            return movimiento;
        }


        //////public static MovimientoVM EditarMovimiento(int MovimientoID)
        //////{
        //////    Resultado res = new Resultado();
        //////    List<Parametros> lParams = new List<Parametros>();
        //////    Conexion cn = new Conexion("cnnAppWebPrueba");
        //////    MovimientoVM movimiento = new MovimientoVM();
        //////    Rol rol = new Rol();
        //////    try
        //////    {
        //////        lParams.Add(new Parametros { Nombre = "intMovimientoID", Tipo = SqlDbType.Int, Valor = MovimientoID });

        //////        DataTable Results = cn.ExecSP("qry_getMovimiento_Sel", lParams);
        //////        movimiento = (
        //////             from DataRow dr in Results.Rows
        //////             select new MovimientoVM
        //////             {
        //////                 intMovimientoID = int.Parse(dr["intMovimientoID"].ToString()),
        //////                 strNombres = dr["strNombres"].ToString(),
        //////                 strApPaterno = dr["strApPaterno"].ToString(),
        //////                 strApMaterno = dr["strApMaterno"].ToString(),
        //////                 intNumMovimiento = int.Parse(dr["intNumMovimiento"].ToString()),
        //////                 intRol = int.Parse(dr["intRol"].ToString()),
        //////                 Estado = bool.Parse(dr["IsActivo"].ToString()),

        //////             }).FirstOrDefault();

        //////        rol = (
        //////            from DataRow dr in Results.Rows
        //////            select new Rol
        //////            {
        //////                RolID = dr["intRol"].ToString(),
        //////                Nombre = dr["strNombreRol"].ToString(),
        //////            }).FirstOrDefault();

        //////        movimiento.Rol = rol;
        //////    }
        //////    catch (Exception ex)
        //////    {
        //////        string error = ex.ToString();
        //////        return movimiento;
        //////    }
        //////    return movimiento;
        //////}

        ////public static Resultado GuardaEditMovimiento(int MovimientoID, string Nombres, string ApPaterno, string ApMaterno, int NumMovimiento, int Rol, bool Activo, string strUsuario)
        ////{
        ////    Resultado res = new Resultado();
        ////    List<Parametros> lParams = new List<Parametros>();
        ////    Conexion cn = new Conexion("cnnAppWebPrueba");
        ////    try
        ////    {
        ////        lParams.Add(new Parametros { Nombre = "intMovimientoID", Tipo = SqlDbType.NVarChar, Valor = MovimientoID });
        ////        lParams.Add(new Parametros { Nombre = "strNombres", Tipo = SqlDbType.NVarChar, Valor = Nombres });
        ////        lParams.Add(new Parametros { Nombre = "strApPaterno", Tipo = SqlDbType.NVarChar, Valor = ApPaterno });
        ////        lParams.Add(new Parametros { Nombre = "strApMaterno", Tipo = SqlDbType.NVarChar, Valor = ApMaterno });
        ////        lParams.Add(new Parametros { Nombre = "intNumMovimiento", Tipo = SqlDbType.Int, Valor = NumMovimiento });
        ////        lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = Rol });
        ////        lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
        ////        lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });

        ////        DataTable Results = cn.ExecSP("qry_Movimiento_Upd", lParams);
        ////        res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
        ////        res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();

        ////        if (res.Id != null)
        ////        {
        ////            res.OK = true;
        ////        }
        ////    }
        ////    catch (Exception ex)
        ////    {
        ////        res.OK = false;
        ////        res.Mensaje = ex.Message;
        ////    }
        ////    return res;
        ////}

        public static List<Rol_a> GetListaRoles()
        {
            List<Rol_a> rol_a = new List<Rol_a>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnAppWebPrueba");
                DataTable Results = cn.ExecSP("qry_ListarRolesActivos_SEL", lParams);

                rol_a = (
                    from DataRow dr in Results.Rows
                    select new Rol_a
                    {
                        RolID_a = dr["intRol"].ToString(),
                        Nombre_a = dr["strNombre"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return rol_a;
            }
            return rol_a;
        }
        public static List<Mes> GetListaMeses()
        {
            List<Mes> mes = new List<Mes>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnAppWebPrueba");
                DataTable Results = cn.ExecSP("qry_ListarMeses_SEL", lParams);

                mes = (
                    from DataRow dr in Results.Rows
                    select new Mes
                    {
                        MesID = dr["intMes"].ToString(),
                        Nombre = dr["strNombreMes"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return mes;
            }
            return mes;
        }
    }
}