using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using IECHClinic.Clases;
using IECHClinic.Models;


namespace IECHClinic.DataAccess.daAdministrarMenu
{
    public class daAdministrarMenu
    {
        public static List<GridAdministrarMenu> getGridAdministrarMenu(int InternalID, int intPerfil)
        {
            //Instanciamos "gridAdministrarMenu"
            List<GridAdministrarMenu> gridAdministrarMenu = new List<GridAdministrarMenu>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Declaramos los parámetros
                lParams.Add(new Parametros { Nombre = "internalID", Tipo = SqlDbType.Int, Valor = InternalID });
                lParams.Add(new Parametros { Nombre = "@intPerfil", Tipo = SqlDbType.Int, Valor = intPerfil }); 

                //Usamos la conexión ejecutando el siguiente SP
                Conexion cn = new Conexion("cnnIECHClinic");
                DataTable Results = cn.ExecSP("qry_V2_AdministrarMenu_SEL", lParams);

                gridAdministrarMenu = (
                    from DataRow dr in Results.Rows
                    select new GridAdministrarMenu
                    {
                        intMenuReal = int.Parse(dr["intMenuReal"].ToString()),
                        intMenu1 = int.Parse(dr["intMenu1"].ToString()),
                        intMenu2 = int.Parse(dr["intMenu2"].ToString()),
                        intMenu3 = int.Parse(dr["intMenu3"].ToString()),
                        intMenu4 = int.Parse(dr["intMenu4"].ToString()),
                        strDescripcion1 = dr["strDescripcion1"].ToString(),
                        strDesgloseMenu = dr["strDesgloseMenu"].ToString(),
                        strDescripcion2 = dr["strDescripcion2"].ToString(),
                        strDescripcion3 = dr["strDescripcion3"].ToString(),
                        strDescripcion4 = dr["strDescripcion4"].ToString(),
                        strDescripcion5 = dr["strDescripcion5"].ToString(),
                        Estado = bool.Parse(dr["isActivo"].ToString()),
                        intPerfil = int.Parse(dr["intPerfil"].ToString()),
                        Acciones = int.Parse(dr["intMenuReal"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridAdministrarMenu;
            }

            //Devolvemos la lista
            return gridAdministrarMenu;
        }

        //Este método hará la inserción del Usuario
        public static Resultado agregaPermisosPerfil(int intMenuReal, string strDesgloseMenu, int Perfil, string Usuario)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            //Siempre usaremos este ambiente, trataré de ya no redundar en este punto
            Conexion cn = new Conexion("cnnIECHClinic");
            try
            {
                //Asignamos las variables y alimentamos la lista de parámetros
                lParams.Add(new Parametros { Nombre = "intMenu", Tipo = SqlDbType.Int, Valor = intMenuReal });
                lParams.Add(new Parametros { Nombre = "DesgloseMenus", Tipo = SqlDbType.NVarChar, Valor = strDesgloseMenu });
                lParams.Add(new Parametros { Nombre = "intPerfil", Tipo = SqlDbType.Int, Valor = Perfil });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                //Se los mandamos al SP
                DataTable Results = cn.ExecSP("qry_V2_agregaPermisoPerfil_APP", lParams);
                //Si todo sale bien, el SP nos devuelve el ID generado más un mensaje muy sencillo
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();

                if (res.Id != null)
                {
                    //Como retorno un ID, entonces vamos a asignar OK en VERDADERO
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                //En caso de error, regresamos FALSO y asignamos el error a la variable de Mensaje
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            //Regresamos el resultado
            return res;
        }
        public static Resultado eliminarMenuUnico(int intMenuElimina, int intPerfil, string user)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnIECHClinic");
            try
            {
                //Asignamos los parámentros
                lParams.Add(new Parametros { Nombre = "intMenuElimina", Tipo = SqlDbType.Int, Valor = intMenuElimina });
                lParams.Add(new Parametros { Nombre = "intPerfil", Tipo = SqlDbType.Int, Valor = intPerfil });
                lParams.Add(new Parametros { Nombre = "DesgloseMenu", Tipo = SqlDbType.NVarChar, Valor = "XXX" });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });

                //Usamos el siguiente SP
                DataTable Results = cn.ExecSP("qry_V2_AdministrarMenu_DEL", lParams);
                //Si todo está bien, devolvemos el ID
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                if (res.Id != null)
                {
                    //y Asignamos VERDADERO al resultado
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                //en caso de error asignamos el OK con FALSO y el mensaje con el error que nos devuelve la BD
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            //Por último devolvemos el resultado
            return res;
        }



        //Este método sirve para traer la lista de Roles, es para llenar los modelos
        //No recibe parámetros
        public static List<PerfilAdmin> GetListaRoles()
        {
            List<PerfilAdmin> perfilAdmin = new List<PerfilAdmin>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Usaremos la cadena de conexion
                Conexion cn = new Conexion("cnnIECHClinic");
                //Mandamos llamar a este SP
                DataTable Results = cn.ExecSP("qry_V2_ListarRolesActivos_SEL", lParams);

                //Llenamos la lista
                perfilAdmin = (
                    from DataRow dr in Results.Rows
                    select new PerfilAdmin
                    {
                        PerfilID = dr["intRol"].ToString(),
                        NombrePerfil = dr["strNombre"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                //En caso de error, lo devolvemos 
                string error = ex.ToString();
                return perfilAdmin;
            }
            //y regresamos la lista de Roles(esta se usa para llenar un combo)
            return perfilAdmin;
        }


    }
}