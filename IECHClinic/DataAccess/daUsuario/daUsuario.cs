using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using IECHClinic.Clases;
using IECHClinic.Models;

namespace IECHClinic.DataAccess.daUsuario
{
    public class daUsuario
    {
        //Esta lista es para mostrar los datos del Usuario
        public static List<GridUsuario> getGridUsuario(int UsuarioID)
        {
            //Instanciamos "gridUsuario"
            List<GridUsuario> gridUsuario = new List<GridUsuario>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Declaramos los parámetros
                lParams.Add(new Parametros { Nombre = "intUsuarioID", Tipo = SqlDbType.Int, Valor = UsuarioID });

                //Usamos la conexión ejecutando el siguiente SP
                Conexion cn = new Conexion("cnnIECHClinic");
                DataTable Results = cn.ExecSP("qry_V2_Usuario_Sel", lParams);

                gridUsuario = (
                    from DataRow dr in Results.Rows
                    select new GridUsuario
                    {
                        intUsuarioID = int.Parse(dr["intUsuarioID"].ToString()),
                        strUsuario = dr["strUsuario"].ToString(),
                        strNombreUsuario = dr["strNombreUsuario"].ToString(),
                        strNombres = dr["strNombres"].ToString(),                        
                        strApPaterno = dr["strApPaterno"].ToString(),
                        strApMaterno = dr["strApMaterno"].ToString(),
                        intNumUsuario = int.Parse(dr["intNumUsuario"].ToString()),
                        intRol = int.Parse(dr["intRol"].ToString()),
                        strRol = dr["strRol"].ToString(),
                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intUsuarioID"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridUsuario;
            }

            //Devolvemos la lista
            return gridUsuario;
        }

        //Este método nos sirve para eliminar de forma lógica a un Usuario, solo marcaremos una columna que usamos para identificarlo
        //Suponiendo que un usuario borra a un Usuario, este es nuestro seguro de vida para decir que "lo pudimos recuperar"
        //Recibimos ID de Usuario y el usuario que lo quiere eliminar
        public static Resultado EliminarUsuario(int UsuarioID, string user)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnIECHClinic");
            try
            {
                //Asignamos los parámentros
                lParams.Add(new Parametros { Nombre = "intUsuarioID", Tipo = SqlDbType.Int, Valor = UsuarioID });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });

                //Usamos el siguiente SP
                DataTable Results = cn.ExecSP("qry_V2_Usuario_Del", lParams);
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

        //Este método hará la inserción del Usuario
        public static Resultado GuardarUsuario(string strUsuario, string Nombres, string ApPaterno, string ApMaterno, string Password, int Rol, bool Activo, string Usuario)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            //Siempre usaremos este ambiente, trataré de ya no redundar en este punto
            Conexion cn = new Conexion("cnnIECHClinic");
            try
            {
                //Asignamos las variables y alimentamos la lista de parámetros
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                lParams.Add(new Parametros { Nombre = "strNombres", Tipo = SqlDbType.NVarChar, Valor = Nombres });
                lParams.Add(new Parametros { Nombre = "strApPaterno", Tipo = SqlDbType.NVarChar, Valor = ApPaterno });
                lParams.Add(new Parametros { Nombre = "strApMaterno", Tipo = SqlDbType.NVarChar, Valor = ApMaterno });
                lParams.Add(new Parametros { Nombre = "strPassword", Tipo = SqlDbType.NVarChar, Valor = Password });
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = Rol });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuarioGuarda", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                //Se los mandamos al SP
                DataTable Results = cn.ExecSP("qry_V2_Usuario_APP", lParams);
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

        //Este método sirve para traer los datos del Usuario y mostrarlos en la vista parcial
        //Necesitamos el ID del Usuario
        public static UsuarioVM EditarUsuario(int UsuarioID)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnIECHClinic");
            UsuarioVM usuario = new UsuarioVM();
            Perfil rol = new Perfil();
            try
            {
                //Asignamos las variables
                lParams.Add(new Parametros { Nombre = "intUsuarioID", Tipo = SqlDbType.Int, Valor = UsuarioID });
                //Llamamos al siguiente SP
                DataTable Results = cn.ExecSP("qry_V2_getUsuario_Sel", lParams);
                usuario = (
                     from DataRow dr in Results.Rows
                     select new UsuarioVM
                     {
                         intUsuario = int.Parse(dr["intUsuarioID"].ToString()),
                         strUsuario = dr["strUsuario"].ToString(),
                         strNombre_Usuario = dr["strNombres"].ToString(),
                         strApPaterno_Usuario = dr["strApPaterno"].ToString(),
                         strApMaterno_Usuario = dr["strApMaterno"].ToString(),
                         strContrasena = dr["strContrasena"].ToString(),
                         strContrasena2 = dr["strContrasena2"].ToString(),
                         intRol = int.Parse(dr["intRol"].ToString()),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
                //Agregamos la lista de Roles al modelo del Usuario
                rol = (
                    from DataRow dr in Results.Rows
                    select new Perfil
                    {
                        PerfilID = dr["intRol"].ToString(),
                        NombrePerfil = dr["strNombreRol"].ToString(),
                    }).FirstOrDefault();

                usuario.Perfil = rol;
            }
            catch (Exception ex)
            {
                //En caso de error, lo asignamos al mensaje
                string error = ex.ToString();
                return usuario;
            }
            //Y devolvemos el resultado al controlador
            return usuario;
        }

        //Este método recibo los valores cargados en la vista para actualizarlos en la BD
        public static Resultado GuardaEditUsuario(int UsuarioID, string strUsuario, string Nombres, string ApPaterno, string ApMaterno, string Password, int Rol, bool Activo, string Usuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnIECHClinic");
            try
            {
                //Llenamos la lista de parámetros
                lParams.Add(new Parametros { Nombre = "intUsuarioID", Tipo = SqlDbType.NVarChar, Valor = UsuarioID });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                lParams.Add(new Parametros { Nombre = "strNombres", Tipo = SqlDbType.NVarChar, Valor = Nombres });
                lParams.Add(new Parametros { Nombre = "strApPaterno", Tipo = SqlDbType.NVarChar, Valor = ApPaterno });
                lParams.Add(new Parametros { Nombre = "strApMaterno", Tipo = SqlDbType.NVarChar, Valor = ApMaterno });
                lParams.Add(new Parametros { Nombre = "strPassword", Tipo = SqlDbType.NVarChar, Valor = Password });
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = Rol });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuarioGuarda", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                //Se los mandamos al SP que hará el UPDATE
                DataTable Results = cn.ExecSP("qry_V2_Usuario_Upd", lParams);
                //Si todo sale bien, el SP actualizará el registro y nos mandará dos cosas: el ID que actualizó y un mensaje de confirmación
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();
                //Como el ID no está vacío, entonces ponemos OK en VERDADERO
                if (res.Id != null)
                {
                    //Y lo asignamos
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                //En caso de rror, no tendremos el ID, asignamos OK en FALSO y asignamos el error de la BD a MENSAJE
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            //y devolvemos la respuesta
            return res;
        }

        public static Resultado actualizaPass(string strPassActual, string strNewPass1, string strNewPass2, string Usuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnIECHClinic");
            try
            {
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                lParams.Add(new Parametros { Nombre = "@strPassword", Tipo = SqlDbType.NVarChar, Valor = strPassActual });
                lParams.Add(new Parametros { Nombre = "@strNewPass1", Tipo = SqlDbType.NVarChar, Valor = strNewPass1 });
                lParams.Add(new Parametros { Nombre = "@strNewPass2", Tipo = SqlDbType.NVarChar, Valor = strNewPass2 });
                lParams.Add(new Parametros { Nombre = "@strUsuarioGuarda", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                DataTable Results = cn.ExecSP("qry_V2_PassWordUsuario_Upd", lParams);

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

        //Este método hará la inserción del Usuario
        public static Resultado agregaMenu_X_Usuario(int intMenuReal, string strDesgloseMenu, int intUsuarioAccede, string Usuario)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            //Siempre usaremos este ambiente, trataré de ya no redundar en este punto
            Conexion cn = new Conexion("cnnIECHClinic");
            try
            {
                //Asignamos las variables y alimentamos la lista de parámetros
                lParams.Add(new Parametros { Nombre = "@intMenu", Tipo = SqlDbType.Int, Valor = intMenuReal });
                lParams.Add(new Parametros { Nombre = "@DesgloseMenus", Tipo = SqlDbType.NVarChar, Valor = strDesgloseMenu });
                lParams.Add(new Parametros { Nombre = "@intUsuarioAccede", Tipo = SqlDbType.Int, Valor = intUsuarioAccede });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                //Se los mandamos al SP
                DataTable Results = cn.ExecSP("qry_V2_AgregarMenu_ExtraXUsuario_APP", lParams);
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
        public static Resultado restringeMenu_X_Usuario(int intMenuRestringe, int intUsuarioID, string user)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnIECHClinic");
            try
            {
                //Asignamos los parámentros
                lParams.Add(new Parametros { Nombre = "@intMenuRestringe", Tipo = SqlDbType.Int, Valor = intMenuRestringe });
                lParams.Add(new Parametros { Nombre = "@DesgloseMenu", Tipo = SqlDbType.NVarChar, Valor = "XXX" });
                lParams.Add(new Parametros { Nombre = "@intUsuario", Tipo = SqlDbType.Int, Valor = intUsuarioID });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });

                //Usamos el siguiente SP
                DataTable Results = cn.ExecSP("qry_V2_Restriccion_MenuXUsuario_APP", lParams);
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
        public static List<Perfil> GetListaRoles()
        {
            List<Perfil> perfil = new List<Perfil>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Usaremos la cadena de conexion
                Conexion cn = new Conexion("cnnIECHClinic");
                //Mandamos llamar a este SP
                DataTable Results = cn.ExecSP("qry_V2_ListarRolesActivos_SEL", lParams);

                //Llenamos la lista
                perfil = (
                    from DataRow dr in Results.Rows
                    select new Perfil
                    {
                        PerfilID = dr["intRol"].ToString(),
                        NombrePerfil = dr["strNombre"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                //En caso de error, lo devolvemos 
                string error = ex.ToString();
                return perfil;
            }
            //y regresamos la lista de Roles(esta se usa para llenar un combo)
            return perfil;
        }

        public static Resultado limpiarPermisosEspeciales_XUsuario(int intUsuarioID, string user)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnIECHClinic");
            try
            {
                //Asignamos los parámentros
                lParams.Add(new Parametros { Nombre = "@intUsuario", Tipo = SqlDbType.Int, Valor = intUsuarioID });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });

                //Usamos el siguiente SP
                DataTable Results = cn.ExecSP("qry_V2_limpiarPermisosEspeciales_XUsuario_DEL", lParams);
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

    }
}