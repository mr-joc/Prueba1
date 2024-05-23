using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;
namespace appWebPrueba.DataAccess.daMovimiento
{
    public class daMovimiento
    {
        //Para guardar el movimeinto se usa este método, solo requiere el empleado, el mes y la cantidad de entregas, agregamos el USUARIO para colocarlo en los campos de auditoría
        public static Resultado GuardarMovimientoXMes(int intNumEmpleado, int intMes, int intCantidadEntregas, string Usuario)
        {
            //Instanciamos la clase de resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            //Nos conectamos haciendo uso de este ambiente
            Conexion cn = new Conexion("cnnLabAllCeramic");
            try
            {
                //Asignamos los parámetros a la lista
                lParams.Add(new Parametros { Nombre = "intNumEmpleado", Tipo = SqlDbType.Int, Valor = intNumEmpleado });
                lParams.Add(new Parametros { Nombre = "intMes", Tipo = SqlDbType.Int, Valor = intMes });
                lParams.Add(new Parametros { Nombre = "intCantidadEntregas", Tipo = SqlDbType.Int, Valor = intCantidadEntregas });
                lParams.Add(new Parametros { Nombre = "strUsuario", Tipo = SqlDbType.NVarChar, Valor = Usuario });
                //Enviamos la lista al siguiente SP, el mismo responde un ID y mesaje o un ERROR
                DataTable Results = cn.ExecSP("qry_MovimientosXMes_APP", lParams);
                //En caso de que todo salga bien, asignamos el ID que genera y el mensaje
                res.Id = (from DataRow dr in Results.Rows select dr["Id"].ToString()).FirstOrDefault();
                res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();
                //Y como el ID no es nulo, marcamos TRUE como verdadero
                if (res.Id != null)
                {
                    res.OK = true;
                }
            }
            catch (Exception ex)
            {
                //En caso de error, mandamos este en el mensaje y colocamos el OK en FALSO
                res.OK = false;
                res.Mensaje = ex.Message;
            }
            //Regresamos el resultado al controlador
            return res;
        }

        //Este método nos trae los datos del empleado, buscando por número
        public static MovimientoVM BuscaEmpleado(int intNumEmpleado)
        {
            //Instanciamos el resultado
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            //Vamos a usar este ambiente
            Conexion cn = new Conexion("cnnLabAllCeramic");
            //Instanciamos el modelo de Movimiento
            MovimientoVM movimiento = new MovimientoVM();
            //Instanciamos el modelo de Rol, tenemos que identificar el código repetido y optimizarlo.
            //Por lo pronto hacemos otra lista de roles
            Rol_a rol_a = new Rol_a();
            //Instanciamos el modelo de
            Mes mes = new Mes();
            try
            {
                //Cargamos la lista de parámetros
                lParams.Add(new Parametros { Nombre = "intNumEmpleado", Tipo = SqlDbType.Int, Valor = intNumEmpleado });
                //y la mandamos al siguiente SP
                DataTable Results = cn.ExecSP("qry_getDatosEmpleado_Sel", lParams);
                //Obtenemos los datos del empleado
                movimiento = (
                     from DataRow dr in Results.Rows
                     select new MovimientoVM
                     {
                         strNombreEmpleado= dr["strNombreCompleto"].ToString(),
                         strNombreRol = dr["strNombreRol"].ToString(),
                         intRol = int.Parse(dr["intRol"].ToString()),
                         intMes = int.Parse(dr["intMes"].ToString()),

                     }).FirstOrDefault();
                //Obtenemos la lista de Roles y se lo agregamos al modelo
                rol_a = (
                    from DataRow dr in Results.Rows
                    select new Rol_a
                    {
                        RolID_a = dr["intRol"].ToString(),
                        Nombre_a = dr["strNombreRol"].ToString(),
                    }).FirstOrDefault();
                movimiento.Rol_a = rol_a;
                //Obtenemos la lista de Meses y se lo agregamos al modelo
                mes = (
                    from DataRow dr in Results.Rows
                    select new Mes
                    {
                        MesID = dr["intMes"].ToString(),
                        Nombre = dr["strNombreRol"].ToString(),
                    }).FirstOrDefault();

                movimiento.Mes = mes;
            }
            catch (Exception ex)
            {
                //En caso de error lo asignamos
                string error = ex.ToString();
                return movimiento;
            }
            //y regresamos el modelo completo
            return movimiento;
        }

        //Este método devuelve la lista de Roles, debemos unificarlo pero lo podremos hacer en una versión 2
        public static List<Rol_a> GetListaRoles()
        {
            List<Rol_a> rol_a = new List<Rol_a>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Usamos el mismo ambiente de siempre
                Conexion cn = new Conexion("cnnLabAllCeramic");
                //Mandamos llamar al SP
                DataTable Results = cn.ExecSP("qry_ListarRolesActivos_SEL", lParams);
                //Cargamos la lista de rol con el resultado
                rol_a = (
                    from DataRow dr in Results.Rows
                    select new Rol_a
                    {
                        RolID_a = dr["intRol"].ToString(),
                        Nombre_a = dr["strNombre"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                //En caso de error lo devolvemos
                string error = ex.ToString();
                return rol_a;
            }
            //y si todo sale bien, regresamos el resultado con la lista de roles ya cargada
            return rol_a;
        }

        //Este método nos devuelve la lista de los meses, recordemos unificarlo en la segunda versión
        public static List<Mes> GetListaMeses()
        {
            List<Mes> mes = new List<Mes>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramic");
                //Mandamos llamar el siguiente SP
                DataTable Results = cn.ExecSP("qry_ListarMeses_SEL", lParams);
                //y el resultado lo usamos para llenar la lista de meses
                mes = (
                    from DataRow dr in Results.Rows
                    select new Mes
                    {
                        MesID = dr["intMes"].ToString(),
                        Nombre = dr["strNombreMes"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                //En caso de error lo mandamos de regreso
                string error = ex.ToString();
                return mes;
            }
            //y regresamos la respuesta con el resultado traído de la BD para llenar el combo
            return mes;
        }
    }
}