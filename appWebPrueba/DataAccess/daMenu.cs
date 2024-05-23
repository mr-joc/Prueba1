using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using appWebPrueba.Clases;
using System.Data;
using appWebPrueba.Models;

namespace appWebPrueba.DataAccess
{
    //Esta clase contiene lo necesario para armar el menú, también se puede usar para devolver las notificaciones pero por lo pronto no las usaremos
    public class daMenu
    {
        //Recibimos el ID del rol al que pertenece el usuario que esté logueado
        //Instanciamos una lista, que es lo que devolveremos
        public static List<Menu> GetMenuByRol(int IDRol, int InternalID)
        {
            List<Menu> lMenu = new List<Menu>();

            try
            {
                //Usaremos el ambiente de "cnnLabAllCeramicOLD"
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                //Instanciamos los parámetros
                List<Parametros> lParams = new List<Parametros>();
                //Y los asignamos
                lParams.Add(new Parametros { Nombre = "IDRol", Tipo = SqlDbType.Int, Valor = IDRol });
                lParams.Add(new Parametros { Nombre = "InternalIDUser", Tipo = SqlDbType.Int, Valor = InternalID });
                //Asignamos a un DataTable lo que te devuelva el siguiente SP
                DataTable Results = cn.ExecSP("sp_V2_GetMenuByRol", lParams);
                //y vamos pasando cada nodo a una lista
                lMenu.AddRange(from DataRow dr in Results.Rows
                               select new Menu
                               {
                                   IdMenu = int.Parse(dr["IDMenu"].ToString()),
                                   Descripcion = (dr["Descripcion"].ToString()),
                                   Parametro = dr["Parametro"].ToString(),
                                   View = dr["ViewVista"].ToString(),
                                   Controller = dr["Controller"].ToString(),
                                   IDRol = byte.Parse(dr["IDRol"].ToString()),
                                   subMenu = int.Parse(dr["subMenu"].ToString()),
                                   Orden = byte.Parse(dr["orden"].ToString()),
                                   Nivel = byte.Parse(dr["Nivel"].ToString()),
                                   IsNode = bool.Parse(dr["IsNode"].ToString()),
                                   Icon = dr["Icon"].ToString()
                               });
            }
            catch (Exception ex)
            {
                //en caso de error lo lanzamos
                throw new ArgumentException("Index is out of range", ex);
            }
            //Retornamos la lista, esta misma se usará en el archivo principal para armar el menú
            return lMenu;
        }
    }
}