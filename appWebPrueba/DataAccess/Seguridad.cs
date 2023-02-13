using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;



namespace appWebPrueba.DataAccess
{
    public class Seguridad
    {
        public static User InfoUsuario(string UserID)
        {
            User res = new User();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = UserID });
                res = (from DataRow dr
                       in cn.ExecSP("qry_infoUsuario_SEL", lParams).Rows
                       select new User
                       {
                           //correo = dr["correo"].ToString(),
                           strUsuario = dr["strUsuario"].ToString(),//MR-JOC
                           NombreUsuario = dr["strNomUsuario"].ToString(),//Jorge Alberto Oviedo Cerda
                           intRol = dr["intRol"].ToString(),//1
                           nomRol = dr["strNombreRol"].ToString(),//SISTEMAS
                           InternalIDUSER = dr["intUsuario"].ToString()
                       }).FirstOrDefault();
            }
            catch (Exception ex)
            {

            }
            return res;
        }         

        public static bool ValidaLogin(string Usuario, string Pwd)
        {
            Resultado res = new Resultado();
            bool valido = false;


            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                lParams.Add(new Parametros { Nombre = "strPassword", Tipo = SqlDbType.NVarChar, Valor = Pwd });

                DataTable Results = cn.ExecSP("qry_ValidarPasword", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["intUsuario"].ToString()).FirstOrDefault();

                if (res.Id != null)
                {
                    res.OK = true;
                    valido = true;
                }
            }
            catch (Exception ex)
            {
                res.OK = false;
                res.Mensaje = ex.Message;
                valido = false;
            }
            return valido;
        }

        public static List<Menu> GetMenuByRol(int IDRol)
        {
            List<Menu> listaMenu = new List<Menu>();
            listaMenu = daMenu.GetMenuByRol(IDRol);
            return listaMenu;
        }

    }
}