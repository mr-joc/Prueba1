using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using appWebPrueba.Clases;
using System.Data;
using appWebPrueba.Models;

namespace appWebPrueba.DataAccess
{
    public class daMenu
    {
        public static List<Menu> GetMenuByRol(int IDRol)
        {
            List<Menu> lMenu = new List<Menu>();

            try
            {
                //Conexion cn = new Conexion("erpWeb");
                Conexion cn = new Conexion("cnnAppWebPrueba");
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "IDRol", Tipo = SqlDbType.Int, Valor = IDRol });
                DataTable Results = cn.ExecSP("sp_GetMenuByRol", lParams);

                lMenu.AddRange(from DataRow dr in Results.Rows
                               select new Menu
                               {
                                   IdMenu = int.Parse(dr["IDMenu"].ToString()),
                                   Descripcion = (dr["Descripcion"].ToString()),
                                   Parametro = dr["Parametro"].ToString(),
                                   View = dr["ViewVista"].ToString(),
                                   Controller = dr["Controller"].ToString(),
                                   IDRol = byte.Parse(dr["IDRol"].ToString()),
                                   subMenu = byte.Parse(dr["subMenu"].ToString()),
                                   Orden = byte.Parse(dr["orden"].ToString()),
                                   Nivel = byte.Parse(dr["Nivel"].ToString()),
                                   IsNode = bool.Parse(dr["IsNode"].ToString()),
                                   Icon = dr["Icon"].ToString()
                               });
            }
            catch (Exception ex)
            {
                throw new ArgumentException("Index is out of range", ex);
            }
            return lMenu;
        }
    }
}