using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;



namespace appWebPrueba.DataAccess
{
    //
    public class Seguridad
    {
        //Recibimos la clave del usuario (el que teclea para ingresar) y buscamos todos sus datos
        public static User InfoUsuario(string UserID)
        {
            //Instanciamos la clase de Usuario
            User res = new User();
            List<Parametros> lParams = new List<Parametros>();
            //Vamos a conectar al ambiente de "cnnLabAllCeramicOLD"
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = UserID });
                res = (from DataRow dr
                       in cn.ExecSP("qry_V2_infoUsuario_SEL", lParams).Rows
                       select new User
                       {
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
            //Devolvemos el objeto ya con los valores asignados
            return res;
        }         

        //Esté método recibe usuario y contraseña, los comprueba en la BD mediante un SP que solo revisa que exista
        public static bool ValidaLogin(string Usuario, string Pwd)
        {
            //Usamos la clase "Resultado"
            Resultado res = new Resultado();

            //Valido empieza como FALSO
            bool valido = false;

            //Usamos la cadena deconexión única en el sistema
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                //Asignamos los parámetros a la clase
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                lParams.Add(new Parametros { Nombre = "strPassword", Tipo = SqlDbType.NVarChar, Valor = Pwd });

                //Tomamos estos parámetros y se los mandamos al SP
                DataTable Results = cn.ExecSP("qry_V2_ValidarPasword", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["intUsuario"].ToString()).FirstOrDefault();

                if (res.Id != null)
                {
                    //E caso de que el dataset no esté vacío (porque existe el registro de usuario y contraseña que coinciden) OK será verdadero y cambiamos VALIDO a VERDADERO
                    res.OK = true;
                    valido = true;
                }
            }
            catch (Exception ex)
            {
                //EN CASO DE ERROR, el OK se va en FALSO, el mensaje se asigna con el error y la variable VALIDO también se va en FALSO
                res.OK = false;
                res.Mensaje = ex.Message;
                valido = false;
            }
            //Regresamos este 
            return valido;
        }

        //Este método recibe el ROL del usuario, con ello manda llamar a "GetMenuByRol" el cual nos devuelve un dataset armado con los menús que puede ver cada uno de los usuarios
        //Este se utiliza en la vista de "_Layout.cshtml", línea 50
        //List<Menu> lMenu = appWebPrueba.DataAccess.Seguridad.GetMenuByRol(int.Parse(IDRol));
        public static List<Menu> GetMenuByRol(int IDRol, int InternalID)
        {
            //Instanciamos la lista de MENU
            List<Menu> listaMenu = new List<Menu>();
            //La llenamos con lo que nos devuelve "GetMenuByRol"
            listaMenu = daMenu.GetMenuByRol(IDRol, InternalID);
            //Y la devolvemos al front
            return listaMenu;
        }


        public static List<Notificaciones> GetNoticiasUser(string User)
        {
            List<Notificaciones> notificaciones = new List<Notificaciones>();

            try
            {
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "InternalID", Tipo = SqlDbType.Int, Valor = User });
                DataTable Results = cn.ExecSP("qry_V2_Notificaciones_SEL", lParams);

                notificaciones.AddRange(from DataRow dr in Results.Rows
                                        select new Notificaciones
                                        {
                                            intNotificacion = int.Parse(dr["intNotificacion"].ToString()),
                                            intTotal = int.Parse(dr["Total"].ToString()),
                                            InternalID = int.Parse(dr["InternalID"].ToString()),
                                            RolID = int.Parse(dr["RolID"].ToString()),
                                            strTitulo = (dr["strTitulo"].ToString()),
                                            strsubTitulo = (dr["strsubTitulo"].ToString()),
                                            strEnlace = (dr["strEnlace"].ToString()),
                                            Nivel = byte.Parse(dr["Nivel"].ToString()),
                                            strIcono = dr["strIcono"].ToString(),
                                            Orden = byte.Parse(dr["intOrden"].ToString())
                                        });
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Index is out of range", ex);
            }
            return notificaciones;
        }


    }
}
//