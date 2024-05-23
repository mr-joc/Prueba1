using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;

namespace appWebPrueba.DataAccess.daProveedor
{
    public class daProveedor
    {
        public static List<GridProveedor> getGridProveedor(int ProveedorID)
        {
            List<GridProveedor> gridProveedor = new List<GridProveedor>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intProveedor", Tipo = SqlDbType.Int, Valor = ProveedorID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_Proveedor_Sel", lParams);

                gridProveedor = (
                    from DataRow dr in Results.Rows
                    select new GridProveedor
                    {
                        intProveedor = int.Parse(dr["intProveedor"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        strNombreCorto = dr["strNombreCorto"].ToString(),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intProveedor"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridProveedor;
            }
            return gridProveedor;
        }

        public static Resultado EliminarProveedor(int intProveedor, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intProveedor", Tipo = SqlDbType.Int, Valor = intProveedor });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_Proveedor_Del", lParams);
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

        public static Resultado GuardarProveedor(string Nombre, string NombreCorto, bool Activo, string strUsuario)
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
                DataTable Results = cn.ExecSP("qry_V2_Proveedor_APP", lParams);
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

        public static ProveedorVM EditarProveedor(int intProveedor)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            ProveedorVM proveedor = new ProveedorVM();
            try
            {
                lParams.Add(new Parametros { Nombre = "@intProveedor", Tipo = SqlDbType.Int, Valor = intProveedor });

                DataTable Results = cn.ExecSP("qry_V2_Proveedor_Sel", lParams);
                proveedor = (
                     from DataRow dr in Results.Rows
                     select new ProveedorVM
                     {
                         intProveedorID = int.Parse(dr["intProveedor"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         strNombreCorto = dr["strNombreCorto"].ToString(),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return proveedor;
            }
            return proveedor;
        }

        public static Resultado GuardaEditProveedor(int intProveedor, string Nombre, string NombreCorto, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intProveedor", Tipo = SqlDbType.Int, Valor = intProveedor });
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@strNombreCorto", Tipo = SqlDbType.NVarChar, Valor = NombreCorto });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_Proveedor_Upd", lParams);
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