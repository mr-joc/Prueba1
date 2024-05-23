using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;


namespace appWebPrueba.DataAccess.daMaterial
{
    public class daMaterial
    {
        public static List<GridMaterial> getGridMaterial(int MaterialID)
        {
            List<GridMaterial> gridMaterial = new List<GridMaterial>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intMaterial", Tipo = SqlDbType.Int, Valor = MaterialID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_Material_Sel", lParams);

                gridMaterial = (
                    from DataRow dr in Results.Rows
                    select new GridMaterial
                    {
                        intMaterial = int.Parse(dr["intMaterial"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        strNombreCorto = dr["strNombreCorto"].ToString(),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intMaterial"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridMaterial;
            }
            return gridMaterial;
        }

        public static Resultado EliminarMaterial(int intMaterial, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intMaterial", Tipo = SqlDbType.Int, Valor = intMaterial });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_Material_Del", lParams);
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

        public static Resultado GuardarMaterial(string Nombre, string NombreCorto, bool Activo, string strUsuario)
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
                DataTable Results = cn.ExecSP("qry_V2_Material_APP", lParams);
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

        public static MaterialVM EditarMaterial(int intMaterial)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            MaterialVM material = new MaterialVM();
            try
            {
                lParams.Add(new Parametros { Nombre = "@intMaterial", Tipo = SqlDbType.Int, Valor = intMaterial });

                DataTable Results = cn.ExecSP("qry_V2_getMaterial_Sel", lParams);
                material = (
                     from DataRow dr in Results.Rows
                     select new MaterialVM
                     {
                         intMaterialID = int.Parse(dr["intMaterial"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         strNombreCorto = dr["strNombreCorto"].ToString(),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return material;
            }
            return material;
        }

        public static Resultado GuardaEditMaterial(int intMaterial, string Nombre, string NombreCorto, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intMaterial", Tipo = SqlDbType.Int, Valor = intMaterial });
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "@strNombreCorto", Tipo = SqlDbType.NVarChar, Valor = NombreCorto });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_Material_Upd", lParams);
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