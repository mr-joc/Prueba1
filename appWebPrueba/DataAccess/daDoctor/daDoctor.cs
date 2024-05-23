using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;


namespace appWebPrueba.DataAccess.daDoctor
{
    public class daDoctor
    {
        public static List<GridDoctor> getGridDoctor(int DoctorID)
        {
            List<GridDoctor> gridDoctor = new List<GridDoctor>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = DoctorID });

                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_Doctor_Sel", lParams);

                gridDoctor = (
                    from DataRow dr in Results.Rows
                    select new GridDoctor
                    {
                        intDoctor = int.Parse(dr["intDoctor"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        strApPaterno = dr["strApPaterno"].ToString(),
                        strApMaterno = dr["strApMaterno"].ToString(),
                       strNombreCompleto = dr["strNombreCompleto"].ToString(),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intDoctor"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridDoctor;
            }
            return gridDoctor;
        }

        public static Resultado EliminarDoctor(int intDoctor, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = intDoctor });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_Doctor_Del", lParams);
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

        public static Resultado GuardarDoctor(string strNombre, string strApPaterno, string strApMaterno, string strDireccion, string strEMail, string strColonia, string strRFC, string strNombreFiscal, int intCP, string strTelefono, string strCelular, string strDireccionFiscal, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = strNombre });
                lParams.Add(new Parametros { Nombre = "@strApPaterno", Tipo = SqlDbType.NVarChar, Valor = strApPaterno });
                lParams.Add(new Parametros { Nombre = "@strApMaterno", Tipo = SqlDbType.NVarChar, Valor = strApMaterno });
                lParams.Add(new Parametros { Nombre = "@strDireccion", Tipo = SqlDbType.NVarChar, Valor = strDireccion });
                lParams.Add(new Parametros { Nombre = "@strEMail", Tipo = SqlDbType.NVarChar, Valor = strEMail });
                lParams.Add(new Parametros { Nombre = "@strColonia", Tipo = SqlDbType.NVarChar, Valor = strColonia });
                lParams.Add(new Parametros { Nombre = "@strRFC", Tipo = SqlDbType.NVarChar, Valor = strRFC });
                lParams.Add(new Parametros { Nombre = "@strNombreFiscal", Tipo = SqlDbType.NVarChar, Valor = strNombreFiscal });
                lParams.Add(new Parametros { Nombre = "@intCP", Tipo = SqlDbType.Int, Valor = intCP });
                lParams.Add(new Parametros { Nombre = "@strTelefono", Tipo = SqlDbType.NVarChar, Valor = strTelefono });
                lParams.Add(new Parametros { Nombre = "@strCelular", Tipo = SqlDbType.NVarChar, Valor = strCelular });
                lParams.Add(new Parametros { Nombre = "@strDireccionFiscal", Tipo = SqlDbType.NVarChar, Valor = strDireccionFiscal });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_Doctor_APP", lParams);
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

        public static DoctorVM EditarDoctor(int intDoctor)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            DoctorVM doctor = new DoctorVM();
            try
            {
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = intDoctor });

                DataTable Results = cn.ExecSP("qry_V2_getDoctor_Sel", lParams);
                doctor = (
                     from DataRow dr in Results.Rows
                     select new DoctorVM
                     {
                         intDoctorID = int.Parse(dr["intDoctor"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         strApPaterno = dr["strApPaterno"].ToString(),
                         strApMaterno = dr["strApMaterno"].ToString(),
                         strDireccion = dr["strDireccion"].ToString(),
                         strEMail = dr["strEMail"].ToString(),
                         strColonia = dr["strColonia"].ToString(),
                         strRFC = dr["strRFC"].ToString(),
                         strNombreFiscal = dr["strNombreFiscal"].ToString(),
                         intCP = int.Parse(dr["intCP"].ToString()),
                         strTelefono = dr["strTelefono"].ToString(),
                         strCelular = dr["strCelular"].ToString(),
                         strDireccionFiscal = dr["strDireccionFiscal"].ToString(),

                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return doctor;
            }
            return doctor;
        }

        public static Resultado GuardaEditDoctor(int intDoctor, string strNombre, string strApPaterno, string strApMaterno, string strDireccion, string strEMail, string strColonia, string strRFC, string strNombreFiscal, int intCP, string strTelefono, string strCelular, string strDireccionFiscal, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = intDoctor });
                lParams.Add(new Parametros { Nombre = "@strNombre", Tipo = SqlDbType.NVarChar, Valor = strNombre });
                lParams.Add(new Parametros { Nombre = "@strApPaterno", Tipo = SqlDbType.NVarChar, Valor = strApPaterno });
                lParams.Add(new Parametros { Nombre = "@strApMaterno", Tipo = SqlDbType.NVarChar, Valor = strApMaterno });
                lParams.Add(new Parametros { Nombre = "@strDireccion", Tipo = SqlDbType.NVarChar, Valor = strDireccion });
                lParams.Add(new Parametros { Nombre = "@strEMail", Tipo = SqlDbType.NVarChar, Valor = strEMail });
                lParams.Add(new Parametros { Nombre = "@strColonia", Tipo = SqlDbType.NVarChar, Valor = strColonia });
                lParams.Add(new Parametros { Nombre = "@strRFC", Tipo = SqlDbType.NVarChar, Valor = strRFC });
                lParams.Add(new Parametros { Nombre = "@strNombreFiscal", Tipo = SqlDbType.NVarChar, Valor = strNombreFiscal });
                lParams.Add(new Parametros { Nombre = "@intCP", Tipo = SqlDbType.Int, Valor = intCP });
                lParams.Add(new Parametros { Nombre = "@strTelefono", Tipo = SqlDbType.NVarChar, Valor = strTelefono });
                lParams.Add(new Parametros { Nombre = "@strCelular", Tipo = SqlDbType.NVarChar, Valor = strCelular });
                lParams.Add(new Parametros { Nombre = "@strDireccionFiscal", Tipo = SqlDbType.NVarChar, Valor = strDireccionFiscal });
                lParams.Add(new Parametros { Nombre = "@IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                DataTable Results = cn.ExecSP("qry_V2_Doctor_Upd", lParams);
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