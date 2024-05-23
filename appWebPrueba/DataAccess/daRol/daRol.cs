using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;


//Toda la carpeta de DataAcces contiene las clases que se van a conectar a la base de datos
namespace appWebPrueba.DataAccess.daRol
{
    //La clase de "daRol" es una de las primeras que hacemos, ya que primero necesitamos tener los roles y después los empleados serán catalogados en ellos
    public class daRol
    {
        //esta es una lista para devolver todos los roles
        public static List<GridRol> getGridRol(int RolID)
        {
            //Instanciamos en modelo 
            List<GridRol> gridRol = new List<GridRol>();
            try
            {
                //Declaramos los parámetros
                List<Parametros> lParams = new List<Parametros>();
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = RolID });

                //Establecemos el ambiente al que nos conectaremos en toda esta aplicación solo usaremos "cnnLabAllCeramicOLD"
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                //este es el SP que vamos a ejecutar
                DataTable Results = cn.ExecSP("qry_V2_Rol_Sel", lParams);

                gridRol = (
                    from DataRow dr in Results.Rows
                    select new GridRol
                    {
                        intRol = int.Parse(dr["intRol"].ToString()),
                        strNombre = dr["strNombre"].ToString(),
                        isAdministrativo = bool.Parse(dr["isAdministrativo"].ToString()),
                        isOperativo = bool.Parse(dr["isOperativo"].ToString()),

                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intRol"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                //en caso de error se lo devolvemos
                string error = ex.ToString();
                return gridRol;
            }
            //y devolvemos la lista en caso de que todo salga bien
            return gridRol;
        }

        //Para eliminar un rol solo necesitamos el Id del mismo y el usuario que lo va a hacer, el Usuario se toma de los Claims para que sea quien se registr en la BD
        //de todas formas, este borrado en realidad es solo para ocultarlo de TODO el sistema, nunca deberíamos borrar nada por si luego nos pden que "lo recuperemos"
        public static Resultado EliminarRol(int intRol, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            //Establecemos el ambiente al que nos conectaremos en toda esta aplicación solo usaremos "cnnLabAllCeramicOLD"
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                //Agregamos los parámetros a la lista
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = intRol });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                //este es el SP que vamos a ejecutar
                DataTable Results = cn.ExecSP("qry_V2_Rol_Del", lParams);
                //Tomamos la respuesta y asignamos el ID
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                if (res.Id != null)
                {
                    //En caso de que haya una respuesta positiva con un ID, asignamos OK en VERDADERO
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                //En caso de error el OK se devuelve en FALSO y el mensaje de error se asigna con el que devuelva la BD
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            //Devolvemos la respuesta
            return res;
        }

        //Para guardar un nuevo rol, no ocupamos el ID de este, ya que lo asignamos en la BD
        public static Resultado GuardarRol(string Nombre, bool Administrativo, bool Activo, string strUsuario)
        {
            //Instanciamos a la clase "Resultado"
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            //Establecemos el ambiente
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                //asignamos los parámetros que recibimos, esto se hace mediante el uso de la clase "Parametros"
                lParams.Add(new Parametros { Nombre = "strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "IsAdministrativo", Tipo = SqlDbType.Bit, Valor = Administrativo });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                //Se los pasamos al siguiente SP
                DataTable Results = cn.ExecSP("qry_V2_Rol_APP", lParams);
                //Si todo sale bien, asignamos el Id y el mensaje que nos devuelve la BD
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();
                //En caso de que haya algún error, el ID quedará Nulo y por lo tanto habrá generado un error
                if (res.Id != null)
                {
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                //En caso de error, el OK se devuelve en FALSO y asignamos en mensaje de la excepción a el parámetro Mensaje
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            //Si no hubo error, solo devolvemos la clase de Resultado con OK, Id y Mensaje ya asignados
            return res;
        }

        //Para editar un rol, se recibe el número y este nos devolverá todos sus datos, los cuales asignaremos al modelo para mostrarlo en pantalla
        public static RolVM EditarRol(int intRol)
        {
            //La clase de resultado se usa en todos lados, hay que comentarlo siempre pero daremos por sentado que ya quedó claro
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            RolVM rol = new RolVM();
            try
            {
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = intRol });

                DataTable Results = cn.ExecSP("qry_V2_getRol_Sel", lParams);
                rol = (
                     from DataRow dr in Results.Rows
                     select new RolVM
                     {
                         intRolID = int.Parse(dr["intRol"].ToString()),
                         strNombre = dr["strNombre"].ToString(),
                         IsAdministrativo = bool.Parse(dr["isAdministrativo"].ToString()),
                         IsOperativo = bool.Parse(dr["isOperativo"].ToString()),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return rol;
            }
            //Retormanos el modelo
            return rol;
        }

        //Una vez cargado el modelo, este se edita en los controles destinados para tal efecto y luego lo devolvemos
        public static Resultado GuardaEditRol(int intRol, string Nombre, bool Administrativo, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                //Asignamos los parámetros
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = intRol });
                lParams.Add(new Parametros { Nombre = "strNombre", Tipo = SqlDbType.NVarChar, Valor = Nombre });
                lParams.Add(new Parametros { Nombre = "IsAdministrativo", Tipo = SqlDbType.Bit, Valor = Administrativo });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                //Este es el SP que Actualiza
                DataTable Results = cn.ExecSP("qry_V2_Rol_Upd", lParams);
                //Usamos la respuesta para asignar el Id y el Mensaje
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();

                if (res.Id != null)
                {
                    //Si todo salió bien y existe un Id asignamos VERDADERO a el parámetro OK
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                //En caso de Error, OK será FALSO y asignamos el mensaje de error a "Mensaje"
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            //Devolvemos el resultado
            return res;
        }
    }
}