using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;
namespace appWebPrueba.DataAccess.daOperacion
{
    public class daOperacion
    {
        public static List<GridOperacion> getGridOperacion(int OperacionID)
        {
            List<GridOperacion> gridOperacion = new List<GridOperacion>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intOperacion", Tipo = SqlDbType.Int, Valor = OperacionID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_Operacion_Sel", lParams);

                gridOperacion = (
                    from DataRow dr in Results.Rows
                    select new GridOperacion
                    {
                        intOperacion = int.Parse(dr["intOperacion"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        strNombreCorto = dr["strNombreCorto"].ToString(),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intOperacion"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridOperacion;
            }
            return gridOperacion;
        }

        public static List<GridOperacion> getGridOperacionesActivasCompleta(int OperacionID)
        {
            List<GridOperacion> gridOperacion = new List<GridOperacion>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intOperacion", Tipo = SqlDbType.Int, Valor = OperacionID });
                lParams.Add(new Parametros { Nombre = "@intActivo", Tipo = SqlDbType.Int, Valor = 1 });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_Operacion_Sel", lParams);

                gridOperacion = (
                    from DataRow dr in Results.Rows
                    select new GridOperacion
                    {
                        intOperacion = int.Parse(dr["intOperacion"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        strNombreCorto = dr["strNombreCorto"].ToString(),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intOperacion"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridOperacion;
            }
            return gridOperacion;
        }

        public static List<GridOperacion> getGridArticulosActivosCompleto(int MaterialID)
        {
            List<GridOperacion> gridOperacion = new List<GridOperacion>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intArticulo", Tipo = SqlDbType.Int, Valor = MaterialID });
                lParams.Add(new Parametros { Nombre = "@intActivo", Tipo = SqlDbType.Int, Valor = 1 });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_Articulo_Sel", lParams);

                gridOperacion = (
                    from DataRow dr in Results.Rows
                    select new GridOperacion
                    {
                        intArticulo = int.Parse(dr["intArticulo"].ToString()),
                        PartNum = dr["PartNum"].ToString(),
                        PartDesc = dr["PartDesc"].ToString(),
                        UMVenta = dr["strUMVenta"].ToString(),
                        dblCantidad= decimal.Parse("1.00"),
                        Estado = bool.Parse(dr["IsActivo"].ToString()),

                        Acciones = int.Parse(dr["intArticulo"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridOperacion;
            }
            return gridOperacion;
        }

        public static List<GridOperacion> getGridOperacionesXTipoTrabajo(int TipoTrabajo)
        {
            List<GridOperacion> gridOperacion = new List<GridOperacion>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajo", Tipo = SqlDbType.Int, Valor = TipoTrabajo });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_OperacionXTipoTranajo_Sel", lParams);

                gridOperacion = (
                    from DataRow dr in Results.Rows
                    select new GridOperacion
                    {
                        intOperacionXTipoTrabajo = int.Parse(dr["intOperacionXTipoTrabajo"].ToString()),
                        intOperacion = int.Parse(dr["intOperacion"].ToString()),
                        intTipoTrabajo = int.Parse(dr["intTipoTrabajo"].ToString()),
                        Seq = dr["Seq"].ToString(),
                        TypeOper = dr["TypeOpr"].ToString(),
                        Desc = dr["strDescripcion"].ToString(),
                        DescTrabajo = dr["strDescripcionTrabajo"].ToString(),
                        intUltimaOperacion = dr["intUltimaOperacion"].ToString(),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intOperacion"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridOperacion;
            }
            return gridOperacion;
        }

        public static List<GridOperacion> getGridMaterialXOperacionTipoTrabajo(int intOperacionTipoTrabajo)
        {
            List<GridOperacion> gridOperacion = new List<GridOperacion>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intOperacionTipoTrabajo", Tipo = SqlDbType.Int, Valor = intOperacionTipoTrabajo });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_MaterialXOperacionTipoTrabajo_Sel", lParams);

                gridOperacion = (
                    from DataRow dr in Results.Rows
                    select new GridOperacion
                    {
                        intOperacionXTipoTrabajoMaterial = int.Parse(dr["intOperacionTipoTrabajoMaterial"].ToString()),
                        intOperacionXTipoTrabajo = int.Parse(dr["intOperacionXTipoTrabajo"].ToString()),
                        PartDesc = dr["strArticulo"].ToString(),
                        UnidadMedidaArt = dr["strUMArt"].ToString(),
                        dblCantidad = decimal.Parse(dr["dblCantidad"].ToString()),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intOperacionTipoTrabajoMaterial"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridOperacion;
            }
            return gridOperacion;
        }

        public static Resultado EliminarOperacion(int intOperacion, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOperacion", Tipo = SqlDbType.Int, Valor = intOperacion });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_Operacion_Del", lParams);
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


        public static Resultado EliminarOperacionXTipoTrabajo(int intOperacion, int intTipoTrabajoID, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOperacion", Tipo = SqlDbType.Int, Valor = intOperacion });
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajoID", Tipo = SqlDbType.Int, Valor = intTipoTrabajoID });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_OperacionXTipoTrabajo_Del", lParams);
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


        public static Resultado EliminaMaterialnXTipoTrabajo(int intOperacionXTipoTrabajoID, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOperacionXTipoTrabajoID", Tipo = SqlDbType.Int, Valor = intOperacionXTipoTrabajoID });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_MaterialXTipoTrabajo_Del", lParams);
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


        public static Resultado GuardarOperacion(string Nombre, string NombreCorto, bool Activo, string strUsuario)
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
                DataTable Results = cn.ExecSP("qry_V2_Operacion_APP", lParams);
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

        public static Resultado AgregaOperacionXTipoTrabajo(int intOperacion, int intTipoTrabajo, string TypeOer, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOperacion", Tipo = SqlDbType.Int, Valor = intOperacion });
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajo", Tipo = SqlDbType.Int, Valor = intTipoTrabajo });
                lParams.Add(new Parametros { Nombre = "@TypeOer", Tipo = SqlDbType.NVarChar, Valor = TypeOer });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_OperacionXTipoTrabajo_APP", lParams);
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


        public static Resultado AgregaMaterialXOperacionTipoTrabajo(int intOperacionXTipoTrabajo, int intArticulo, decimal dblCantidad, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOperacionXTipoTrabajo", Tipo = SqlDbType.Int, Valor = intOperacionXTipoTrabajo });
                lParams.Add(new Parametros { Nombre = "@intArticulo", Tipo = SqlDbType.Int, Valor = intArticulo });
                lParams.Add(new Parametros { Nombre = "@dblCantidad", Tipo = SqlDbType.Decimal, Valor = dblCantidad });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_MaterialXOperacionTipoTrabajo_APP", lParams);
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

        public static Resultado MoverOperacionXTipoTrabajo(int intOperacion, int intTipoTrabajo, bool bitSubirOperacion, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOperacion", Tipo = SqlDbType.Int, Valor = intOperacion });
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajo", Tipo = SqlDbType.Int, Valor = intTipoTrabajo });
                lParams.Add(new Parametros { Nombre = "@bitSubirOperacion", Tipo = SqlDbType.Bit, Valor = bitSubirOperacion });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_MoverOperacionXTipoTrabajo_UPD", lParams);
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

        public static OperacionVM EditarOperacion(int intOperacion)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            OperacionVM operacion = new OperacionVM();
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOperacion", Tipo = SqlDbType.Int, Valor = intOperacion });

                DataTable Results = cn.ExecSP("qry_V2_Operacion_Sel", lParams);
                operacion = (
                     from DataRow dr in Results.Rows
                     select new OperacionVM
                     {
                         intOperacionID = int.Parse(dr["intOperacion"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         strNombreCorto = dr["strNombreCorto"].ToString(),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return operacion;
            }
            return operacion;
        }

        public static Resultado GuardaEditOperacion(int intOperacion, string Nombre, string NombreCorto, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOperacion", Tipo = SqlDbType.Int, Valor = intOperacion });
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@strNombreCorto", Tipo = SqlDbType.NVarChar, Valor = NombreCorto });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_Operacion_Upd", lParams);
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