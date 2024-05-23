using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;

namespace appWebPrueba.DataAccess.daArticulo
{
    public class daArticulo
    {
        public static List<GridArticulo> getGridArticulo(int ArticuloID)
        {
            List<GridArticulo> gridArticulo = new List<GridArticulo>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intArticulo", Tipo = SqlDbType.Int, Valor = ArticuloID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_Articulo_Sel", lParams);

                gridArticulo = (
                    from DataRow dr in Results.Rows
                    select new GridArticulo
                    {
                        intArticulo = int.Parse(dr["intArticulo"].ToString()),
                        strNombre = dr["PartNum"].ToString(),
                        strNombreCorto = dr["PartDesc"].ToString(),
                        PartNum = dr["PartNum"].ToString(),
                        PartDesc = dr["PartDesc"].ToString(),
                        strUMCompra = dr["strUMCompra"].ToString(),
                        strUMAlmacen = dr["strUMAlmacen"].ToString(),
                        strUMVenta = dr["strUMVenta"].ToString(),
                        intUnidadMedidaCompra = int.Parse(dr["intUnidadMedidaCompra"].ToString()),
                        intUnidadMedidaAlmacen = int.Parse(dr["intUnidadMedidaAlmacen"].ToString()),
                        intUnidadMedidaVenta = int.Parse(dr["intUnidadMedidaVenta"].ToString()),
                        intProveedorBase = int.Parse(dr["intProveedorBase"].ToString()),
                        dblConversionCompraAlmacen = decimal.Parse(dr["dblConversionCompraAlmacen"].ToString()),
                        dblConversionAlmacenVenta = decimal.Parse(dr["dblConversionAlmacenVenta"].ToString()),

        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intArticulo"].ToString()),


                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridArticulo;
            }
            return gridArticulo;
        }

        public static Resultado EliminarArticulo(int intArticulo, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intArticulo", Tipo = SqlDbType.Int, Valor = intArticulo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_Articulo_Del", lParams);
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

        public static Resultado GuardarArticulo(string strPartNum, string strPartDesc, int intUnidadMedidaCompra, int intUnidadMedidaAlmacen, int intUnidadMedidaVenta, decimal dblConversion_Comp_Alm, decimal dblConversion_Alm_Vta, int intProveedorBase, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@strPartNum", Tipo = SqlDbType.NVarChar, Valor = strPartNum });
                lParams.Add(new Parametros { Nombre = "@strPartDesc", Tipo = SqlDbType.NVarChar, Valor = strPartDesc });
                lParams.Add(new Parametros { Nombre = "@intUnidadMedidaCompra", Tipo = SqlDbType.Int, Valor = intUnidadMedidaCompra });
                lParams.Add(new Parametros { Nombre = "@intUnidadMedidaAlmacen", Tipo = SqlDbType.Int, Valor = intUnidadMedidaAlmacen });
                lParams.Add(new Parametros { Nombre = "@intUnidadMedidaVenta", Tipo = SqlDbType.Int, Valor = intUnidadMedidaVenta });
                lParams.Add(new Parametros { Nombre = "@dblConversion_Comp_Alm", Tipo = SqlDbType.Decimal, Valor = dblConversion_Comp_Alm });
                lParams.Add(new Parametros { Nombre = "@dblConversion_Alm_Vta", Tipo = SqlDbType.Decimal, Valor = dblConversion_Alm_Vta });
                lParams.Add(new Parametros { Nombre = "@intProveedorBase", Tipo = SqlDbType.Int, Valor = intProveedorBase });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });

                DataTable Results = cn.ExecSP("qry_V2_Articulo_APP", lParams);
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

        public static ArticuloVM EditarArticulo(int intArticulo)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            ArticuloVM articulo = new ArticuloVM();

            Proveedor proveedor = new Proveedor();
            //UnidadMedida unidadMedida = new UnidadMedida();
            UnidadMedidaCompra unidadMedidaCompra = new UnidadMedidaCompra();
            UnidadMedidaAlmacen unidadMedidaAlmacen = new UnidadMedidaAlmacen();
            UnidadMedidaVenta unidadMedidaVenta = new UnidadMedidaVenta();

            try
            {
                lParams.Add(new Parametros { Nombre = "@intArticulo", Tipo = SqlDbType.Int, Valor = intArticulo });

                DataTable Results = cn.ExecSP("qry_V2_Articulo_Sel", lParams);
                articulo = (
                     from DataRow dr in Results.Rows
                     select new ArticuloVM
                     {
                         intArticuloID = int.Parse(dr["intArticulo"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         strNombreCorto = dr["strNombreCorto"].ToString(),
                         PartNum = dr["PartNum"].ToString(),
                         PartDesc = dr["PartDesc"].ToString(),
                         strUMCompra = dr["strUMCompra"].ToString(),
                         strUMAlmacen = dr["strUMAlmacen"].ToString(),
                         strUMVenta = dr["strUMVenta"].ToString(),
                         intUnidadMedidaCompra = int.Parse(dr["intUnidadMedidaCompra"].ToString()),
                         intUnidadMedidaAlmacen = int.Parse(dr["intUnidadMedidaAlmacen"].ToString()),
                         intUnidadMedidaVenta = int.Parse(dr["intUnidadMedidaVenta"].ToString()),
                         intProveedorBase = int.Parse(dr["intProveedorBase"].ToString()),
                         dblConversionCompraAlmacen = decimal.Parse(dr["dblConversionCompraAlmacen"].ToString()),
                         dblConversionAlmacenVenta = decimal.Parse(dr["dblConversionAlmacenVenta"].ToString()),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),                         


                     }).FirstOrDefault();


                proveedor = (
                    from DataRow dr in Results.Rows
                    select new Proveedor
                    {
                        ProveedorID = dr["intProveedorBase"].ToString(),
                        NombreProveedor = dr["strProVeedor"].ToString(),
                    }).FirstOrDefault();

                unidadMedidaCompra = (
                    from DataRow dr in Results.Rows
                    select new UnidadMedidaCompra
                    {
                        UnidadMedidaID = dr["intUnidadMedidaCompra"].ToString(),
                        NombreUnidadMedida = dr["strUMCompra"].ToString(),

                    }).FirstOrDefault();

                unidadMedidaAlmacen = (
                    from DataRow dr in Results.Rows
                    select new UnidadMedidaAlmacen
                    {
                        UnidadMedidaID = dr["intUnidadMedidaAlmacen"].ToString(),
                        NombreUnidadMedida = dr["strUMAlmacen"].ToString(),

                    }).FirstOrDefault();

                unidadMedidaVenta = (
                    from DataRow dr in Results.Rows
                    select new UnidadMedidaVenta
                    {
                        UnidadMedidaID = dr["intUnidadMedidaVenta"].ToString(),
                        NombreUnidadMedida = dr["strUMVenta"].ToString(),

                    }).FirstOrDefault();

                articulo.Proveedor = proveedor;
                articulo.UnidadMedidaCompra = unidadMedidaCompra;
                articulo.UnidadMedidaAlmacen = unidadMedidaAlmacen;
                articulo.UnidadMedidaVenta= unidadMedidaVenta;

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return articulo;
            }
            return articulo;
        }

        public static Resultado GuardaEditArticulo(int intArticulo, string strPartNum, string strPartDesc, int intUnidadMedidaCompra, int intUnidadMedidaAlmacen, int intUnidadMedidaVenta, decimal dblConversion_Comp_Alm, decimal dblConversion_Alm_Vta, int intProveedorBase, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intArticulo", Tipo = SqlDbType.Int, Valor = intArticulo });
                lParams.Add(new Parametros { Nombre = "@strPartNum", Tipo = SqlDbType.NVarChar, Valor = strPartNum });
                lParams.Add(new Parametros { Nombre = "@strPartDesc", Tipo = SqlDbType.NVarChar, Valor = strPartDesc });
                lParams.Add(new Parametros { Nombre = "@intUnidadMedidaCompra", Tipo = SqlDbType.Int, Valor = intUnidadMedidaCompra });
                lParams.Add(new Parametros { Nombre = "@intUnidadMedidaAlmacen", Tipo = SqlDbType.Int, Valor = intUnidadMedidaAlmacen });
                lParams.Add(new Parametros { Nombre = "@intUnidadMedidaVenta", Tipo = SqlDbType.Int, Valor = intUnidadMedidaVenta });
                lParams.Add(new Parametros { Nombre = "@dblConversion_Comp_Alm", Tipo = SqlDbType.Decimal, Valor = dblConversion_Comp_Alm });
                lParams.Add(new Parametros { Nombre = "@dblConversion_Alm_Vta", Tipo = SqlDbType.Decimal, Valor = dblConversion_Alm_Vta });
                lParams.Add(new Parametros { Nombre = "@intProveedorBase", Tipo = SqlDbType.Int, Valor = intProveedorBase });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_Articulo_Upd", lParams);
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

        public static List<Proveedor> GetListaProveedor()
        {
            List<Proveedor> proveedor = new List<Proveedor>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "@intProveedor", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intActivo", Tipo = SqlDbType.Int, Valor = 1 });
                DataTable Results = cn.ExecSP("qry_V2_Proveedor_Sel", lParams);

                proveedor = (
                    from DataRow dr in Results.Rows
                    select new Proveedor
                    {
                        ProveedorID = dr["intProveedor"].ToString(),
                        NombreProveedor = dr["strNombre"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return proveedor;
            }
            return proveedor;
        }


        public static List<UnidadMedida> GetUnidadesMedida()
        {
            List<UnidadMedida> unidadMedida = new List<UnidadMedida>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "@intUnidadMedida", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intActivo", Tipo = SqlDbType.Int, Valor = 1 });
                DataTable Results = cn.ExecSP("qry_V2_UnidadMedida_Sel", lParams);

                unidadMedida = (
                    from DataRow dr in Results.Rows
                    select new UnidadMedida
                    {
                        UnidadMedidaID = dr["intUnidadMedida"].ToString(),
                        NombreUnidadMedida = dr["strNombre"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return unidadMedida;
            }
            return unidadMedida;
        }
    }
}