using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;


namespace appWebPrueba.DataAccess.daTipoTrabajo
{
    public class daTipoTrabajo
    {
        public static List<GridTipoTrabajo> getGridTipoTrabajo(int TipoTrabajoID)
        {
            List<GridTipoTrabajo> gridTipoTrabajo = new List<GridTipoTrabajo>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajoID", Tipo = SqlDbType.Int, Valor = TipoTrabajoID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_TipoTrabajo_Sel", lParams);

                gridTipoTrabajo = (
                    from DataRow dr in Results.Rows
                    select new GridTipoTrabajo
                    {
                        intTipoTrabajo = int.Parse(dr["intTipoTrabajoID"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        strNombreCorto = dr["strNombreCorto"].ToString(),
                        strMaterial = dr["strMaterial"].ToString(),
                        dblPrecio = decimal.Parse(dr["dblPrecio"].ToString()),
                        dblPrecioUrgente = decimal.Parse(dr["dblPrecioUrgencia"].ToString()),
                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intTipoTrabajo"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridTipoTrabajo;
            }
            return gridTipoTrabajo;
        }

        public static Resultado EliminarTipoTrabajo(int intTipoTrabajo, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajo", Tipo = SqlDbType.Int, Valor = intTipoTrabajo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_TipoTrabajo_Del", lParams);
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

        public static Resultado GuardarTipoTrabajo(string Nombre, string NombreCorto, int intMaterial, decimal dblPrecio, decimal dblPrecioUrgencia,bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@strNombreCorto", Tipo = SqlDbType.NVarChar, Valor = NombreCorto });
                lParams.Add(new Parametros { Nombre = "@intMaterial", Tipo = SqlDbType.Int, Valor = intMaterial });
                lParams.Add(new Parametros { Nombre = "@dblPrecio", Tipo = SqlDbType.Decimal, Valor = dblPrecio });
                lParams.Add(new Parametros { Nombre = "@dblPrecioUrgencia", Tipo = SqlDbType.Decimal, Valor = dblPrecioUrgencia });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuarioGuarda", Tipo = SqlDbType.NVarChar, Valor = strUsuario });

                DataTable Results = cn.ExecSP("qry_V2_TipoTrabajo_APP", lParams);
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

        public static TipoTrabajoVM EditarTipoTrabajo(int intTipoTrabajo)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            TipoTrabajoVM tipoTrabajo = new TipoTrabajoVM();
            Material material = new Material();
            try
            {
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajoID", Tipo = SqlDbType.Int, Valor = intTipoTrabajo });

                DataTable Results = cn.ExecSP("qry_V2_getTipoTrabajo_Sel", lParams);
                tipoTrabajo = (
                     from DataRow dr in Results.Rows
                     select new TipoTrabajoVM
                     {
                         intTipoTrabajoID = int.Parse(dr["intTipoTrabajoID"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         strNombreCorto = dr["strNombreCorto"].ToString(),
                         intMaterial = int.Parse(dr["intMaterial"].ToString()),
                         dblPrecio = decimal.Parse(dr["dblPrecio"].ToString()),
                         dblPrecioUrgente = decimal.Parse(dr["dblPrecioUrgencia"].ToString()),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();


                //Agregamos la lista de Roles al modelo del Usuario
                material = (
                    from DataRow dr in Results.Rows
                    select new Material
                    {
                        MaterialID = dr["intMaterial"].ToString(),
                        NombreMaterial = dr["strMaterial"].ToString(),
                    }).FirstOrDefault();

                tipoTrabajo.Material = material;




            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return tipoTrabajo;
            }
            return tipoTrabajo;
        }

        public static Resultado GuardaEditTipoTrabajo(int intTipoTrabajo, string Nombre, string NombreCorto, int intMaterial, decimal dblPrecio, decimal dblPrecioUrgencia, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajoID", Tipo = SqlDbType.Int, Valor = intTipoTrabajo });
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@strNombreCorto", Tipo = SqlDbType.NVarChar, Valor = NombreCorto });
                lParams.Add(new Parametros { Nombre = "@intMaterial", Tipo = SqlDbType.Int, Valor = intMaterial });
                lParams.Add(new Parametros { Nombre = "@dblPrecio", Tipo = SqlDbType.Decimal, Valor = dblPrecio });
                lParams.Add(new Parametros { Nombre = "@dblPrecioUrgencia", Tipo = SqlDbType.Decimal, Valor = dblPrecioUrgencia });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuarioGuarda", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_TipoTrabajo_Upd", lParams);

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

        public static List<Material> GetListaMateriales()
        {
            List<Material> material = new List<Material>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_ListarMaterialesActivos_SEL", lParams);

                material = (
                    from DataRow dr in Results.Rows
                    select new Material
                    {
                        MaterialID = dr["intMaterial"].ToString(),
                        NombreMaterial = dr["strNombreMaterial"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return material;
            }
            return material;
        }

    }
}