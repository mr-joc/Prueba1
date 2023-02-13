using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;
//<<<<<< HEAD
//13022023
///=======
///>>>> 4ae8ac72b29d62b0ef945c8339197a06d53752b1

namespace appWebPrueba.DataAccess.daEmpleado
{
    public class daEmpleado
    {
        //Esta lista es para mostrar los datos del empleado
        public static List<GridEmpleado> getGridEmpleado(int EmpleadoID)
        {
            //Instanciamos "gridEmpleado"
            List<GridEmpleado> gridEmpleado = new List<GridEmpleado>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Declaramos los parámetros
                lParams.Add(new Parametros { Nombre = "intEmpleadoID", Tipo = SqlDbType.Int, Valor = EmpleadoID });

                //Usamos la conexión ejecutando el siguiente SP
                Conexion cn = new Conexion("cnnAppWebPrueba");
                DataTable Results = cn.ExecSP("qry_Empleado_Sel", lParams);

                gridEmpleado = (
                    from DataRow dr in Results.Rows
                    select new GridEmpleado
                    {
                        intEmpleadoID = int.Parse(dr["intEmpleadoID"].ToString()),
                        strNombres = dr["strNombres"].ToString(),
                        strApPaterno = dr["strApPaterno"].ToString(),
                        strApMaterno = dr["strApMaterno"].ToString(),
                        intNumEmpleado = int.Parse(dr["intNumEmpleado"].ToString()),
                        intRol = int.Parse(dr["intRol"].ToString()),
                        strRol = dr["strRol"].ToString(),
                        Estado = bool.Parse(dr["IsActivo"].ToString()),
                        Acciones = int.Parse(dr["intEmpleadoID"].ToString()),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridEmpleado;
            }

            //Devolvemos la lista
            return gridEmpleado;
        }

        //Este método nos sirve para eliminar de forma lógica a un empleado, solo marcaremos una columna que usamos para identificarlo
        //Suponiendo que un usuario borra a un empleado, este es nuestro seguro de vida para decir que "lo pudimos recuperar"
        //Recibimos ID de empleado y el usuario que lo quiere eliminar
        public static Resultado EliminarEmpleado(int EmpleadoID, string user)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                //Asignamos los parámentros
                lParams.Add(new Parametros { Nombre = "intEmpleadoID", Tipo = SqlDbType.Int, Valor = EmpleadoID });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });

                //Usamos el siguiente SP
                DataTable Results = cn.ExecSP("qry_Empleado_Del", lParams);
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

        //Este método hará la inserción del empleado
        public static Resultado GuardarEmpleado(string Nombres, string ApPaterno, string ApMaterno, int NumEmpleado, int Rol, bool Activo, string Usuario)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            //Siempre usaremos este ambiente, trataré de ya no redundar en este punto
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                //Asignamos las variables y alimentamos la lista de parámetros
                lParams.Add(new Parametros { Nombre = "strNombres", Tipo = SqlDbType.NVarChar, Valor = Nombres });
                lParams.Add(new Parametros { Nombre = "strApPaterno", Tipo = SqlDbType.NVarChar, Valor = ApPaterno });
                lParams.Add(new Parametros { Nombre = "strApMaterno", Tipo = SqlDbType.NVarChar, Valor = ApMaterno });
                lParams.Add(new Parametros { Nombre = "intNumEmpleado", Tipo = SqlDbType.Int, Valor = NumEmpleado });
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = Rol });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                //Se los mandamos al SP
                DataTable Results = cn.ExecSP("qry_Empleado_APP", lParams);
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

        //Este método sirve para traer los datos del empleado y mostrarlos en la vista parcial
        //Necesitamos el ID del empleado
        public static EmpleadoVM EditarEmpleado(int EmpleadoID)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            EmpleadoVM empleado = new EmpleadoVM();
            Rol rol = new Rol();
            try
            {
                //Asignamos las variables
                lParams.Add(new Parametros { Nombre = "intEmpleadoID", Tipo = SqlDbType.Int, Valor = EmpleadoID });
                //Llamamos al siguiente SP
                DataTable Results = cn.ExecSP("qry_getEmpleado_Sel", lParams);
                empleado = (
                     from DataRow dr in Results.Rows
                     select new EmpleadoVM
                     {
                         intEmpleadoID = int.Parse(dr["intEmpleadoID"].ToString()),
                         strNombres = dr["strNombres"].ToString(),
                         strApPaterno = dr["strApPaterno"].ToString(),
                         strApMaterno = dr["strApMaterno"].ToString(),
                         intNumEmpleado = int.Parse(dr["intNumEmpleado"].ToString()),
                         intRol = int.Parse(dr["intRol"].ToString()),
                         Estado = bool.Parse(dr["IsActivo"].ToString()),

                     }).FirstOrDefault();
                //Agregamos la lista de Roles al modelo del empleado
                rol = (
                    from DataRow dr in Results.Rows
                    select new Rol
                    {
                        RolID = dr["intRol"].ToString(),
                        Nombre = dr["strNombreRol"].ToString(),
                    }).FirstOrDefault();

                empleado.Rol = rol;
            }
            catch (Exception ex)
            {
                //En caso de error, lo asignamos al mensaje
                string error = ex.ToString();
                return empleado;
            }
            //Y devolvemos el resultado al controlador
            return empleado;
        }

        //Este método recibo los valores cargados en la vista para actualizarlos en la BD
        public static Resultado GuardaEditEmpleado(int EmpleadoID, string Nombres, string ApPaterno, string ApMaterno, int NumEmpleado, int Rol, bool Activo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnAppWebPrueba");
            try
            {
                //Llenamos la lista de parámetros
                lParams.Add(new Parametros { Nombre = "intEmpleadoID", Tipo = SqlDbType.NVarChar, Valor = EmpleadoID });
                lParams.Add(new Parametros { Nombre = "strNombres", Tipo = SqlDbType.NVarChar, Valor = Nombres });
                lParams.Add(new Parametros { Nombre = "strApPaterno", Tipo = SqlDbType.NVarChar, Valor = ApPaterno });
                lParams.Add(new Parametros { Nombre = "strApMaterno", Tipo = SqlDbType.NVarChar, Valor = ApMaterno });
                lParams.Add(new Parametros { Nombre = "intNumEmpleado", Tipo = SqlDbType.Int, Valor = NumEmpleado });
                lParams.Add(new Parametros { Nombre = "intRol", Tipo = SqlDbType.Int, Valor = Rol });
                lParams.Add(new Parametros { Nombre = "IsActivo", Tipo = SqlDbType.Bit, Valor = Activo });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                //Se los mandamos al SP que hará el UPDATE
                DataTable Results = cn.ExecSP("qry_Empleado_Upd", lParams);
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

        //Este método sirve para traer la lista de Roles, es para llenar los modelos
        //No recibe parámetros
        public static List<Rol> GetListaRoles()
        {
            List<Rol> rol = new List<Rol>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Usaremos la cadena de conexion
                Conexion cn = new Conexion("cnnAppWebPrueba");
                //Mandamos llamar a este SP
                DataTable Results = cn.ExecSP("qry_ListarRolesActivos_SEL", lParams);

                //Llenamos la lista
                rol = (
                    from DataRow dr in Results.Rows
                    select new Rol
                    {
                        RolID = dr["intRol"].ToString(),
                        Nombre = dr["strNombre"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                //En caso de error, lo devolvemos 
                string error = ex.ToString();
                return rol;
            }
            //y regresamos la lista de Roles(esta se usa para llenar un combo)
            return rol;
        }
    }
}