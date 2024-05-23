using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using appWebPrueba.Clases;
using appWebPrueba.Models;

namespace appWebPrueba.DataAccess.daOrdenLaboratorio
{
    public class daOrdenLaboratorio
    {

        public static Resultado GuardarOrdenLab(int intDoctor, string strNombrePaciente, int intExpediente, int intFolioPago, decimal dblPrecio, int intTipoProtesis, decimal intPieza, int intProceso, int intTipoTrabajo, string strColor,
            string strComentario, string strObservaciones, int intEdad, int intSexo, bool btGarantia, int intColor, bool btFactura, DateTime datFechaEntrega, DateTime datFechaColocacion,
            int intColorimetro, bool btUrgente, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intFolio", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = intDoctor });
                lParams.Add(new Parametros { Nombre = "@strNombrePaciente", Tipo = SqlDbType.NVarChar, Valor = strNombrePaciente });
                lParams.Add(new Parametros { Nombre = "@intExpediente", Tipo = SqlDbType.Int, Valor = intExpediente });
                lParams.Add(new Parametros { Nombre = "@intFolioPago", Tipo = SqlDbType.Int, Valor = intFolioPago });
                lParams.Add(new Parametros { Nombre = "@dblPrecio", Tipo = SqlDbType.Decimal, Valor = dblPrecio });
                lParams.Add(new Parametros { Nombre = "@intTipoProtesis", Tipo = SqlDbType.Int, Valor = intTipoProtesis });
                lParams.Add(new Parametros { Nombre = "@intPieza", Tipo = SqlDbType.Decimal, Valor = intPieza });
                lParams.Add(new Parametros { Nombre = "@intProceso", Tipo = SqlDbType.Int, Valor = intProceso });
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajo", Tipo = SqlDbType.Int, Valor = intTipoTrabajo });
                lParams.Add(new Parametros { Nombre = "@strColor", Tipo = SqlDbType.NVarChar, Valor = strColor });
                lParams.Add(new Parametros { Nombre = "@strComentario", Tipo = SqlDbType.NVarChar, Valor = strComentario });
                lParams.Add(new Parametros { Nombre = "@strObservaciones", Tipo = SqlDbType.NVarChar, Valor = strObservaciones });
                lParams.Add(new Parametros { Nombre = "@intEdad", Tipo = SqlDbType.Int, Valor = intEdad });
                lParams.Add(new Parametros { Nombre = "@intSexo", Tipo = SqlDbType.Int, Valor = intSexo });
                lParams.Add(new Parametros { Nombre = "@intConGarantia", Tipo = SqlDbType.Bit, Valor = btGarantia });
                lParams.Add(new Parametros { Nombre = "@intColor", Tipo = SqlDbType.Int, Valor = intColor });
                lParams.Add(new Parametros { Nombre = "@intFactura", Tipo = SqlDbType.Bit, Valor = btFactura });
                lParams.Add(new Parametros { Nombre = "@intEstatus", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@datFechaEntrega", Tipo = SqlDbType.DateTime, Valor = datFechaEntrega });
                lParams.Add(new Parametros { Nombre = "@datFechaColocacion", Tipo = SqlDbType.DateTime, Valor = datFechaColocacion });
                lParams.Add(new Parametros { Nombre = "@intColorimetro", Tipo = SqlDbType.Int, Valor = intColorimetro });
                lParams.Add(new Parametros { Nombre = "@intUrgente", Tipo = SqlDbType.Bit, Valor = btUrgente });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                lParams.Add(new Parametros { Nombre = "@strMaquina", Tipo = SqlDbType.NVarChar, Valor = strUsuario });


                DataTable Results = cn.ExecSP("qry_OrdenLaboratorioEnc_App", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["result"].ToString()).FirstOrDefault();
                //res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();
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

        public static Resultado Guarda_EDIT_OrdenLab(int intOrdenLaboratorioEnc, int intDoctor, string strNombrePaciente, int intExpediente, int intFolioPago, decimal dblPrecio, int intTipoProtesis, decimal intPieza, int intProceso, int intTipoTrabajo, string strColor,
            string strComentario, string strObservaciones, int intEdad, int intSexo, bool btGarantia, int intColor, bool btFactura, DateTime datFechaEntrega, DateTime datFechaColocacion,
            int intColorimetro, bool btUrgente, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLaboratorioEnc });
                lParams.Add(new Parametros { Nombre = "@intFolio", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = intDoctor });
                lParams.Add(new Parametros { Nombre = "@strNombrePaciente", Tipo = SqlDbType.NVarChar, Valor = strNombrePaciente });
                lParams.Add(new Parametros { Nombre = "@intExpediente", Tipo = SqlDbType.Int, Valor = intExpediente });
                lParams.Add(new Parametros { Nombre = "@intFolioPago", Tipo = SqlDbType.Int, Valor = intFolioPago });
                lParams.Add(new Parametros { Nombre = "@dblPrecio", Tipo = SqlDbType.Decimal, Valor = dblPrecio });
                lParams.Add(new Parametros { Nombre = "@intTipoProtesis", Tipo = SqlDbType.Int, Valor = intTipoProtesis });
                lParams.Add(new Parametros { Nombre = "@intPieza", Tipo = SqlDbType.Decimal, Valor = intPieza });
                lParams.Add(new Parametros { Nombre = "@intProceso", Tipo = SqlDbType.Int, Valor = intProceso });
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajo", Tipo = SqlDbType.Int, Valor = intTipoTrabajo });
                lParams.Add(new Parametros { Nombre = "@strColor", Tipo = SqlDbType.NVarChar, Valor = strColor });
                lParams.Add(new Parametros { Nombre = "@strComentario", Tipo = SqlDbType.NVarChar, Valor = strComentario });
                lParams.Add(new Parametros { Nombre = "@strObservaciones", Tipo = SqlDbType.NVarChar, Valor = strObservaciones });
                lParams.Add(new Parametros { Nombre = "@intEdad", Tipo = SqlDbType.Int, Valor = intEdad });
                lParams.Add(new Parametros { Nombre = "@intSexo", Tipo = SqlDbType.Int, Valor = intSexo });
                lParams.Add(new Parametros { Nombre = "@intConGarantia", Tipo = SqlDbType.Bit, Valor = btGarantia });
                lParams.Add(new Parametros { Nombre = "@intColor", Tipo = SqlDbType.Int, Valor = intColor });
                lParams.Add(new Parametros { Nombre = "@intFactura", Tipo = SqlDbType.Bit, Valor = btFactura });
                lParams.Add(new Parametros { Nombre = "@intEstatus", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@datFechaEntrega", Tipo = SqlDbType.DateTime, Valor = datFechaEntrega });
                lParams.Add(new Parametros { Nombre = "@datFechaColocacion", Tipo = SqlDbType.DateTime, Valor = datFechaColocacion });
                lParams.Add(new Parametros { Nombre = "@intColorimetro", Tipo = SqlDbType.Int, Valor = intColorimetro });
                lParams.Add(new Parametros { Nombre = "@intUrgente", Tipo = SqlDbType.Bit, Valor = btUrgente });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                lParams.Add(new Parametros { Nombre = "@strMaquina", Tipo = SqlDbType.NVarChar, Valor = strUsuario });


                DataTable Results = cn.ExecSP("qry_OrdenLaboratorioEnc_App", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["result"].ToString()).FirstOrDefault();
                //res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();
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


        public static Resultado GenerarOrdenTrabajoXOrdenEnc_APP(int intOrdenLaboratorioEnc, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLaboratorioEnc });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });


                DataTable Results = cn.ExecSP("qry_V2_GenerarOrdeneTrabajo_APP", lParams);
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

        public static Resultado AutorizarFabricacionOrden(int intOrdenLaboratorioEnc, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLaboratorioEnc });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });


                DataTable Results = cn.ExecSP("qry_V2_AutorizarFabricacionOrden_APP", lParams);
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

        public static Resultado AbonoTrabajo_App(int intOrdenLaboratorioEnc, decimal dblMontoPago, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "intAbonoTrabajo", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLaboratorioEnc });
                lParams.Add(new Parametros { Nombre = "@dblMonto", Tipo = SqlDbType.Int, Valor = dblMontoPago });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                lParams.Add(new Parametros { Nombre = "@strMaquina", Tipo = SqlDbType.NVarChar, Valor = strUsuario });


                DataTable Results = cn.ExecSP("qry_V2_AbonoTrabajo_App", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["result"].ToString()).FirstOrDefault();
                //res.Mensaje = (from DataRow dr in Results.Rows select dr["Mensaje"].ToString()).FirstOrDefault();
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

        public static OrdenLaboratorioVM getInfoGeneral_Enc(int intOrdenLab, int intTipoInfo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            OrdenLaboratorioVM ordenEnc = new OrdenLaboratorioVM();

            //Colorimetros colorimetro = new Colorimetros();
            //ColoresXCol color = new ColoresXCol();
            //Doctores doctor = new Doctores();
            //Protesis protesis = new Protesis();
            //ProcesoXProtesis proceso = new ProcesoXProtesis();

            //MaterialesORD materialesORD = new MaterialesORD();
            //TrabXMatORD trabajoXMaterial = new TrabXMatORD();

            try
            {


                switch (intTipoInfo)
                {
                    case 1:
                        lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                        lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLab });

                        DataTable Results_1 = cn.ExecSP("qry_V2_EstatusOrdenLaboratorioEnc", lParams);
                        ordenEnc = (
                             from DataRow dr in Results_1.Rows
                             select new OrdenLaboratorioVM
                             {
                                 intOrdenLaboratorioEnc = int.Parse(dr["intOrdenLaboratorioEnc"].ToString()),
                                 intEstatus = int.Parse(dr["intEstatus"].ToString()),
                                 intCaja = int.Parse(dr["intCaja"].ToString()),
                                 strFechaEntrega = dr["datFechaEntrega"].ToString(),
                                 strDoctor = dr["strDoctor"].ToString(),

                                 strFechaColocacion = dr["datFechaColocacion"].ToString(),
                                 strImagenEstatus = dr["strImagenEstatus"].ToString(),
                                 strEncabezado = dr["strEncabezado"].ToString(),
                                 strEncabezadoImg = dr["strEncabezadoImg"].ToString(),
                                 strEncaRechazo = dr["strEncaRechazo"].ToString(),
                                 strEncaHistorial = dr["strEncaHistorial"].ToString(),
                                 strTipoProtesis = dr["strTipoProtesis"].ToString(),
                                 strProceso = dr["strProceso"].ToString(),
                                 strImagenes = dr["strImagenes"].ToString(),
                                 strEncabezadoEstatusProceso = dr["strEncabezadoEstatusProceso"].ToString(),
                                 strImagenProceso = dr["strImagenProceso"].ToString(),

                             }).FirstOrDefault();
                        break;
                    case 2:
                        lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                        lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                        lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLab });

                        DataTable Results_2 = cn.ExecSP("qry_V2_OrdenLaboratorioEnc_Sel", lParams);
                        ordenEnc = (
                             from DataRow dr in Results_2.Rows
                             select new OrdenLaboratorioVM
                             { 
                                 intEmpresa = int.Parse(dr["intEmpresa"].ToString()),
                                 intSucursal = int.Parse(dr["intSucursal"].ToString()),
                                 intOrdenLaboratorioEnc = int.Parse(dr["intOrdenLaboratorioEnc"].ToString()),
                                 strEncabezado = dr["strEncabezado"].ToString(),
                                 dblCosto = decimal.Parse(dr["dblCosto"].ToString()),
                                 dblPagado = decimal.Parse(dr["dblPagado"].ToString()),
                                 dblSaldo = decimal.Parse(dr["dblSaldo"].ToString()),
                                 intFolio = int.Parse(dr["intFolio"].ToString()),
                                 intDoctor = int.Parse(dr["intDoctor"].ToString()),
                                 strDoctor = dr["strDoctor"].ToString(),
                                 strNombrePaciente = dr["strNombrePaciente"].ToString(),
                                 intExpediente = int.Parse(dr["intExpediente"].ToString()),
                                 intFolioPago = int.Parse(dr["intFolioPago"].ToString()),
                                 intTipoProtesis = int.Parse(dr["intTipoProtesis"].ToString()),
                                 strTipoProtesis = dr["strTipoProtesis"].ToString(),
                                 decPieza = decimal.Parse(dr["intPieza"].ToString()),
                                 intProceso = int.Parse(dr["intProceso"].ToString()),
                                 strProceso = dr["strProceso"].ToString(),
                                 intTipoTrabajo = int.Parse(dr["intTipoTrabajo"].ToString()),
                                 strColor = dr["strColor"].ToString(),
                                 strComentario = dr["strComentario"].ToString(),
                                 strObservaciones = dr["strObservaciones"].ToString(),
                                 intEdad = int.Parse(dr["intEdad"].ToString()),
                                 intSexo = int.Parse(dr["intSexo"].ToString()),
                                 intConGarantia = int.Parse(dr["intGarantia"].ToString()),
                                 intEstatus = int.Parse(dr["intEstatus"].ToString()),
                                 intColorimetro = int.Parse(dr["intColorimetro"].ToString()),
                                 strColorimetro = dr["strColorimetro"].ToString(),
                                 intColor = int.Parse(dr["intColor"].ToString()),
                                 intFactura = int.Parse(dr["intFactura"].ToString()),
                                 dblPrecio = decimal.Parse(dr["dblPrecio"].ToString()),
                                 dblPrecioReal = decimal.Parse(dr["dblPrecioReal"].ToString()),
                                 strFechaAlta = dr["strFechaAlta"].ToString(),
                                 strFechaEntrega = dr["strFechaEntrega"].ToString(),
                                 strFechaColocacion = dr["strFechaColocacion"].ToString(),
                                 intUrgente = int.Parse(dr["intUrgente"].ToString()),
                                 intLabExterno = int.Parse(dr["intLabExterno"].ToString()),



                             }).FirstOrDefault();
                        break;

                    default:
                        lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                        lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                        lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLab });

                        DataTable Results0 = cn.ExecSP("qry_V2_OrdenLaboratorioEnc_SelHistorial", lParams);
                        ordenEnc = (
                             from DataRow dr in Results0.Rows
                             select new OrdenLaboratorioVM
                             {
                                 intEmpresa = int.Parse(dr["intEmpresa"].ToString()),
                                 intSucursal = int.Parse(dr["intSucursal"].ToString()),
                                 intOrdenLaboratorioEnc = int.Parse(dr["intOrdenLaboratorioEnc"].ToString()),
                                 strEncabezado = dr["strEncabezado"].ToString(),
                                 dblCosto = decimal.Parse(dr["dblCosto"].ToString()),
                                 dblPagado = decimal.Parse(dr["dblPagado"].ToString()),
                                 dblSaldo = decimal.Parse(dr["dblSaldo"].ToString()),
                                 intFolio = int.Parse(dr["intFolio"].ToString()),
                                 intDoctor = int.Parse(dr["intDoctor"].ToString()),
                                 strNombrePaciente = dr["strNombrePaciente"].ToString(),
                                 intExpediente = int.Parse(dr["intExpediente"].ToString()),
                                 intFolioPago = int.Parse(dr["intFolioPago"].ToString()),
                                 intTipoProtesis = int.Parse(dr["intTipoProtesis"].ToString()),
                                 strTipoProtesis = dr["strTipoProtesis"].ToString(),
                                 decPieza = decimal.Parse(dr["intPieza"].ToString()),
                                 intProceso = int.Parse(dr["intProceso"].ToString()),
                                 strProceso = dr["strProceso"].ToString(),
                                 intTipoTrabajo = int.Parse(dr["intTipoTrabajo"].ToString()),
                                 strColor = dr["strColor"].ToString(),
                                 strComentario = dr["strComentario"].ToString(),
                                 strObservaciones = dr["strObservaciones"].ToString(),
                                 intEdad = int.Parse(dr["intEdad"].ToString()),
                                 intSexo = int.Parse(dr["intSexo"].ToString()),
                                 intConGarantia = int.Parse(dr["intGarantia"].ToString()),
                                 intEstatus = int.Parse(dr["intEstatus"].ToString()),
                                 intColorimetro = int.Parse(dr["intColorimetro"].ToString()),
                                 intColor = int.Parse(dr["intColor"].ToString()),
                                 intFactura = int.Parse(dr["intFactura"].ToString()),
                                 dblPrecio = decimal.Parse(dr["dblPrecio"].ToString()),
                                 dblPrecioReal = decimal.Parse(dr["dblPrecioReal"].ToString()),
                                 datFechaAlta = DateTime.Parse(dr["datFechaAlta"].ToString()),
                                 strFechaAlta = dr["strFechaAlta"].ToString(),
                                 datFechaEntrega = DateTime.Parse(dr["datFechaEntrega"].ToString()),
                                 datFechaColocacion = DateTime.Parse(dr["datFechaColocacion"].ToString()),
                                 intUrgente = int.Parse(dr["intUrgente"].ToString()),
                                 intLabExterno = int.Parse(dr["intLabExterno"].ToString()),
                             }).FirstOrDefault();
                        break;
                }

                //colorimetro = (
                //    from DataRow dr in Results.Rows
                //    select new Colorimetros
                //    {
                //        ColorimetroID = dr["intColorimetro"].ToString(),
                //        Nombre = dr["strColorimetro"].ToString(),
                //    }).FirstOrDefault();
                //ordenEnc.Colorimetros = colorimetro;

                //color = (
                //    from DataRow dr in Results.Rows
                //    select new ColoresXCol
                //    {
                //        intColor = dr["intColor"].ToString(),
                //        strNombre = dr["strColor"].ToString(),
                //    }).FirstOrDefault();
                //ordenEnc.ColoresXCol = color;

                //doctor = (
                //    from DataRow dr in Results.Rows
                //    select new Doctores
                //    {
                //        DoctorID = dr["intDoctor"].ToString(),
                //        Nombre = dr["strDoctor"].ToString(),
                //    }).FirstOrDefault();
                //ordenEnc.Doctores = doctor;

                //protesis = (
                //    from DataRow dr in Results.Rows
                //    select new Protesis
                //    {
                //        TipoProtesisID = dr["intTipoProtesis"].ToString(),
                //        Nombre = dr["strTipoProtesis"].ToString(),
                //    }).FirstOrDefault();
                //ordenEnc.Protesis = protesis;

                //proceso = (
                //    from DataRow dr in Results.Rows
                //    select new ProcesoXProtesis
                //    {
                //        ProcesoID = dr["intProceso"].ToString(),
                //        strNombre = dr["strProceso"].ToString(),
                //    }).FirstOrDefault();
                //ordenEnc.ProcesoXProtesis = proceso;

                //materialesORD = (
                //    from DataRow dr in Results.Rows
                //    select new MaterialesORD
                //    {
                //        MaterialID = dr["intColorimetro"].ToString(),
                //        Nombre = dr["strColorimetro"].ToString(),
                //    }).FirstOrDefault();
                //ordenEnc.MaterialesORD = materialesORD;

                //trabajoXMaterial = (
                //    from DataRow dr in Results.Rows
                //    select new TrabXMatORD
                //    {
                //        intTrabajo = dr["intProceso"].ToString(),
                //        strNombre = dr["strProceso"].ToString(),
                //    }).FirstOrDefault();
                //ordenEnc.TrabXMatORD = trabajoXMaterial;


            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return ordenEnc;
            }
            return ordenEnc;
        }

        public static List<GridOrdenLaboratorio> getInfoGeneralDet(int intOrdenLaboratorioEnc, int intTipoInfo, string strUsuario)
        {
            //Instanciamos "gridAdministrarMenu"
            List<GridOrdenLaboratorio> gridOrdenesLab = new List<GridOrdenLaboratorio>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                DataTable results = new DataTable();

                switch (intTipoInfo)
                {
                    case 1:
                        lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLaboratorioEnc });
                        lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });

                        //Usamos la conexión ejecutando el siguiente SP
                        Conexion cn1 = new Conexion("cnnLabAllCeramicOLD");
                        results = cn1.ExecSP("qry_V2_OrdenLaboratorioEnc_SelHistorial", lParams);

                        gridOrdenesLab = (
                            from DataRow dr in results.Rows
                            select new GridOrdenLaboratorio
                            {
                                intOrden = dr["intOrden"].ToString(),
                                intOrdenLaboratorioEnc = dr["intOrdenLaboratorioEnc"].ToString(),
                                intProceso = dr["intProceso"].ToString(),
                                strProceso = dr["strProceso"].ToString(),
                                intEstatus = dr["intEstatus"].ToString(),
                                strEstatus = dr["strEstatus"].ToString(),
                                strUsuario = dr["strUsuario"].ToString(),
                                strUsuarioCompuesto = dr["strUsuarioCompuesto"].ToString(),
                                strComentario = dr["strComentario"].ToString(),
                                strMaquina = dr["strMaquina"].ToString(),
                                strFecha = dr["strFecha"].ToString(),
                                strFechaHora = dr["strFechaHora"].ToString(),
                                intMotivo = dr["intMotivo"].ToString(),
                                strMotivo = dr["strMotivo"].ToString(),
                                strImagenes = dr["strImagenes"].ToString(),
                            }).ToList();
                        break;

                    case 2:
                        lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                        lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                        lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLaboratorioEnc });

                        //Usamos la conexión ejecutando el siguiente SP
                        Conexion cn2 = new Conexion("cnnLabAllCeramicOLD");
                        results = cn2.ExecSP("qry_V2_AbonoTrabajo_SEL", lParams);

                        gridOrdenesLab = (
                            from DataRow dr in results.Rows
                            select new GridOrdenLaboratorio
                            {
                                intAbonoTrabajo = dr["intAbonoTrabajo"].ToString(),
                                intOrdenLaboratorioEnc = dr["intOrdenLaboratorioEnc"].ToString(),
                                dblCosto = dr["dblMonto"].ToString(),
                                strFecha01 = dr["datFechaAlta"].ToString(),
                                strUsuario = dr["strUsuarioAlta"].ToString(),
                                strMaquina = dr["strMaquinaAlta"].ToString(),
                            }).ToList();
                        break;

                    default: 
                        lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                        lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                        lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLaboratorioEnc });

                        //Usamos la conexión ejecutando el siguiente SP
                        Conexion cnd = new Conexion("cnnLabAllCeramicOLD");
                        results = cnd.ExecSP("qryOrdenLaboratorioDet_SelXOrdenLaboratorio", lParams);

                        gridOrdenesLab = (
                            from DataRow dr in results.Rows
                            select new GridOrdenLaboratorio
                            {
                                intOrdenLaboratorioEnc = dr["intOrdenLaboratorioEnc"].ToString(),
                                intOrdenLaboratorioDet = dr["intOrdenLaboratorioDet"].ToString(),
                                intPieza = dr["intPieza"].ToString(),
                                intMaterial = dr["intMaterial"].ToString(),
                                intTipoTrabajo = dr["intTipoTrabajo"].ToString(),
                                strColor = dr["strColor"].ToString(),
                                intCantidad = dr["intCantidad"].ToString(),
                                strMaterial = dr["material"].ToString(),
                                strTipoTrabajo = dr["trabajo"].ToString(),
                            }).ToList();
                        break;
                } 
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridOrdenesLab;
            }

            //Devolvemos la lista
            return gridOrdenesLab;
        }
        public static OrdenLaboratorioVM EditarOrdenLab(int intOrdenLab)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            OrdenLaboratorioVM ordenEnc = new OrdenLaboratorioVM();

            Colorimetros colorimetro = new Colorimetros();
            ColoresXCol color = new ColoresXCol();
            Doctores doctor = new Doctores();
            Protesis protesis = new Protesis();
            ProcesoXProtesis proceso = new ProcesoXProtesis();

            MaterialesORD materialesORD = new MaterialesORD();
            TrabXMatORD trabajoXMaterial = new TrabXMatORD();

            try
            {
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLab });

                DataTable Results = cn.ExecSP("qry_V2_OrdenLaboratorioEnc_Sel", lParams);
                ordenEnc = (
                     from DataRow dr in Results.Rows
                     select new OrdenLaboratorioVM
                     {
                         intEmpresa = int.Parse(dr["intEmpresa"].ToString()),
                         intSucursal = int.Parse(dr["intSucursal"].ToString()),
                         intOrdenLaboratorioEnc = int.Parse(dr["intOrdenLaboratorioEnc"].ToString()),
                         strEncabezado = dr["strEncabezado"].ToString(),
                         dblCosto = decimal.Parse(dr["dblCosto"].ToString()),
                         dblPagado = decimal.Parse(dr["dblPagado"].ToString()),
                         dblSaldo = decimal.Parse(dr["dblSaldo"].ToString()),
                         intFolio = int.Parse(dr["intFolio"].ToString()),
                         intDoctor = int.Parse(dr["intDoctor"].ToString()),
                         strNombrePaciente = dr["strNombrePaciente"].ToString(),
                         intExpediente = int.Parse(dr["intExpediente"].ToString()),
                         intFolioPago = int.Parse(dr["intFolioPago"].ToString()),
                         intTipoProtesis = int.Parse(dr["intTipoProtesis"].ToString()),
                         strTipoProtesis = dr["strTipoProtesis"].ToString(),
                         decPieza = decimal.Parse(dr["intPieza"].ToString()),
                         intProceso = int.Parse(dr["intProceso"].ToString()),
                         strProceso = dr["strProceso"].ToString(),
                         intTipoTrabajo = int.Parse(dr["intTipoTrabajo"].ToString()),
                         strColor = dr["strColor"].ToString(),
                         strComentario = dr["strComentario"].ToString(),
                         strObservaciones = dr["strObservaciones"].ToString(),
                         intEdad = int.Parse(dr["intEdad"].ToString()),
                         intSexo = int.Parse(dr["intSexo"].ToString()),
                         intConGarantia = int.Parse(dr["intGarantia"].ToString()),
                         intEstatus = int.Parse(dr["intEstatus"].ToString()),
                         intColorimetro = int.Parse(dr["intColorimetro"].ToString()),
                         //Colorimetros = int.Parse(dr["intColorimetro"].ToString()),
                         intColor = int.Parse(dr["intColor"].ToString()),
                         intFactura = int.Parse(dr["intFactura"].ToString()),
                         dblPrecio = decimal.Parse(dr["dblPrecio"].ToString()),
                         dblPrecioReal = decimal.Parse(dr["dblPrecioReal"].ToString()),
                         datFechaAlta = DateTime.Parse(dr["datFechaAlta"].ToString()),
                         strFechaAlta = dr["strFechaAlta"].ToString(),
                         datFechaEntrega = DateTime.Parse(dr["datFechaEntrega"].ToString()),
                         datFechaColocacion = DateTime.Parse(dr["datFechaColocacion"].ToString()),
                         intUrgente = int.Parse(dr["intUrgente"].ToString()),
                         intLabExterno = int.Parse(dr["intLabExterno"].ToString()),
                         //Estado = bool.Parse(dr["intGarantia"].ToString()),

                     }).FirstOrDefault();

                colorimetro = (
                    from DataRow dr in Results.Rows
                    select new Colorimetros
                    {
                        ColorimetroID = dr["intColorimetro"].ToString(),
                        Nombre = dr["strColorimetro"].ToString(),
                    }).FirstOrDefault();
                ordenEnc.Colorimetros = colorimetro;

                color = (
                    from DataRow dr in Results.Rows
                    select new ColoresXCol
                    {
                        intColor = dr["intColor"].ToString(),
                        strNombre = dr["strColor"].ToString(),
                    }).FirstOrDefault();
                ordenEnc.ColoresXCol = color;

                doctor = (
                    from DataRow dr in Results.Rows
                    select new Doctores
                    {
                        DoctorID = dr["intDoctor"].ToString(),
                        Nombre = dr["strDoctor"].ToString(),
                    }).FirstOrDefault();
                ordenEnc.Doctores = doctor;

                protesis = (
                    from DataRow dr in Results.Rows
                    select new Protesis
                    {
                        TipoProtesisID = dr["intTipoProtesis"].ToString(),
                        Nombre = dr["strTipoProtesis"].ToString(),
                    }).FirstOrDefault();
                ordenEnc.Protesis = protesis;

                proceso = (
                    from DataRow dr in Results.Rows
                    select new ProcesoXProtesis
                    {
                        ProcesoID = dr["intProceso"].ToString(),
                        strNombre = dr["strProceso"].ToString(),
                    }).FirstOrDefault();
                ordenEnc.ProcesoXProtesis = proceso;

                materialesORD = (
                    from DataRow dr in Results.Rows
                    select new MaterialesORD
                    {
                        MaterialID = dr["intColorimetro"].ToString(),
                        Nombre = dr["strColorimetro"].ToString(),
                    }).FirstOrDefault();
                ordenEnc.MaterialesORD = materialesORD;

                trabajoXMaterial = (
                    from DataRow dr in Results.Rows
                    select new TrabXMatORD
                    {
                        intTrabajo = dr["intProceso"].ToString(),
                        strNombre = dr["strProceso"].ToString(),
                    }).FirstOrDefault();
                ordenEnc.TrabXMatORD = trabajoXMaterial;


            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return ordenEnc;
            }
            return ordenEnc;
        }

        public static Resultado EliminarOrdenLaboratorioDet(int OrdenLaboratorioDet, string user)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioDet", Tipo = SqlDbType.Int, Valor = OrdenLaboratorioDet });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = user });
                DataTable Results = cn.ExecSP("qry_V2_OrdenLaboratorioDet_Del", lParams);
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

        public static List<GridOrdenLaboratorio> getGridOrdenLab(string User, int intDoctor, int intProtesis, int intProceso, int intOrden, string strPaciente)
        {
            //Instanciamos "gridAdministrarMenu"
            List<GridOrdenLaboratorio> gridOrdenesLab = new List<GridOrdenLaboratorio>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Declaramos los parámetros
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = User });
                lParams.Add(new Parametros { Nombre = "@intEsVersion2024", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = intDoctor });
                lParams.Add(new Parametros { Nombre = "@intProtesis", Tipo = SqlDbType.Int, Valor = intProtesis });
                lParams.Add(new Parametros { Nombre = "@intProceso", Tipo = SqlDbType.Int, Valor = intProceso });
                lParams.Add(new Parametros { Nombre = "@intOrden", Tipo = SqlDbType.Int, Valor = intOrden });
                lParams.Add(new Parametros { Nombre = "@strPaciente", Tipo = SqlDbType.NVarChar, Valor = strPaciente });

                //Usamos la conexión ejecutando el siguiente SP
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qryOrdenLaboratorioEnc_SelDetalle_PorUsuario", lParams);

                gridOrdenesLab = (
                    from DataRow dr in Results.Rows
                    select new GridOrdenLaboratorio
                    {
                        intFolio = dr["intOrdenLaboratorioEnc"].ToString(),
                        strDoctor = dr["strDoctor"].ToString(),
                        strNombrePaciente = dr["strNombrePaciente"].ToString(),
                        strProceso = dr["strProceso"].ToString(),
                        datEntrega = dr["datEntrega"].ToString(),
                        intDiasRetraso = dr["intDiasRetraso"].ToString(),
                        strComentario = dr["strComentario"].ToString(),
                        strAccionEstatus = dr["strAccionEstatus"].ToString(),
                        strEstatusProceso = dr["strEstatusProceso"].ToString(),
                        strAccionImagenes = dr["strAccionImagenes"].ToString(),
                        strAbonarTrabajo = dr["strAbonarTrabajo"].ToString(),
                        strAccionHistorial = dr["strAccionHistorial"].ToString(),
                        strAccionVerDetalle = dr["strAccionVerDetalle"].ToString(),
                        intProcesado = dr["intProcesado"].ToString(),
                        intAutorizado = dr["intAutorizado"].ToString(),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridOrdenesLab;
            }

            //Devolvemos la lista
            return gridOrdenesLab;
        }


        public static List<GridOrdenLaboratorio> getDetalleOrdenLab(int intOrdenLaboratorioEnc)
        {
            //Instanciamos "gridAdministrarMenu"
            List<GridOrdenLaboratorio> gridOrdenesLab = new List<GridOrdenLaboratorio>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Declaramos los parámetros
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLaboratorioEnc });

                //Usamos la conexión ejecutando el siguiente SP
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_OrdenLaboratorioDet_SelXOrdenLaboratorio", lParams);

                gridOrdenesLab = (
                    from DataRow dr in Results.Rows
                    select new GridOrdenLaboratorio
                    {
                        intOrdenLaboratorioEnc = dr["intOrdenLaboratorioEnc"].ToString(),
                        intOrdenLaboratorioDet = dr["intOrdenLaboratorioDet"].ToString(),
                        intPieza = dr["intPieza"].ToString(),
                        intMaterial = dr["intMaterial"].ToString(),
                        intTipoTrabajo = dr["intTipoTrabajo"].ToString(),
                        strColor = dr["strColor"].ToString(),
                        intCantidad = dr["intCantidad"].ToString(),
                        strMaterial = dr["material"].ToString(),
                        strTipoTrabajo = dr["trabajo"].ToString(),
                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return gridOrdenesLab;
            }

            //Devolvemos la lista
            return gridOrdenesLab;
        }

        public static List<Colorimetros> GetColorimetros()
        {
            List<Colorimetros> colorimetros = new List<Colorimetros>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_ListarColorimetrosActivos_SEL", lParams);

                colorimetros = (
                    from DataRow dr in Results.Rows
                    select new Colorimetros
                    {
                        ColorimetroID = dr["intColorimetro"].ToString(),
                        Nombre = dr["strNombreColorimetro"].ToString(),
                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return colorimetros;
            }
            return colorimetros;
        }

        public static List<ColoresXCol> GetcoloresXColorimetro(int colorimetro)
        {
            List<ColoresXCol> coloresxColorimetro = new List<ColoresXCol>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intColorimetro", Tipo = SqlDbType.Int, Valor = colorimetro });
                lParams.Add(new Parametros { Nombre = "@intColor", Tipo = SqlDbType.Int, Valor = 0 });
                DataTable Results = cn.ExecSP("qry_V2_ColorPorColorimetro_Sel", lParams);

                coloresxColorimetro = (
                        from DataRow dr in Results.Rows
                        select new ColoresXCol
                        {
                            ColorimetroID = dr["intColorimetro"].ToString(),
                            intColor = dr["intColor"].ToString(),
                            strNombre = dr["strNombre"].ToString(),
                        }
                    ).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return coloresxColorimetro;
            }
            return coloresxColorimetro;
        }


        public static List<Protesis> GetProtesis()
        {
            List<Protesis> protesis = new List<Protesis>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intTipoProtesis", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intActivas", Tipo = SqlDbType.Int, Valor = 1 });
                DataTable Results = cn.ExecSP("qry_V2_TipoProtesis_Sel", lParams);

                protesis = (
                    from DataRow dr in Results.Rows
                    select new Protesis
                    {
                        TipoProtesisID = dr["intTipoProtesis"].ToString(),
                        Nombre = dr["strNombreTipoProtesis"].ToString(),
                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return protesis;
            }
            return protesis;
        }

        public static List<Doctores> GetDoctoresActivos()
        {
            List<Doctores> doctores = new List<Doctores>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intActivo", Tipo = SqlDbType.Int, Valor = 1 });
                DataTable Results = cn.ExecSP("qry_V2_Doctor_Sel", lParams);

                doctores = (
                    from DataRow dr in Results.Rows
                    select new Doctores
                    {
                        DoctorID = dr["intDoctor"].ToString(),
                        Nombre = dr["strNombreCompleto"].ToString(),
                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return doctores;
            }
            return doctores;
        }

        public static List<ProcesoXProtesis> GetProcInicialesXProtesis(int protesis)
        {
            List<ProcesoXProtesis> procesoXProtesis = new List<ProcesoXProtesis>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intProtesis", Tipo = SqlDbType.Int, Valor = protesis });
                lParams.Add(new Parametros { Nombre = "@intProceso", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intActivos", Tipo = SqlDbType.Int, Valor = 1 });
                DataTable Results = cn.ExecSP("qry_V2_ProcesosIniciales_Sel", lParams);

                procesoXProtesis = (
                        from DataRow dr in Results.Rows
                        select new ProcesoXProtesis
                        {
                            ProcesoID = dr["intProceso"].ToString(),
                            TipoProtesisID = dr["intLaboratorio"].ToString(),
                            intFolioProceso = dr["intFolioProceso"].ToString(),
                            strNombre = dr["strNombreProceso"].ToString(),
                        }
                    ).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return procesoXProtesis;
            }
            return procesoXProtesis;
        }


        public static List<GridOrdenLaboratorio> getAyudaOrdenLab(int FolioBusca, int intDoctor, int intTipoProtesis)
        {
            //Instanciamos "gridAdministrarMenu"
            List<GridOrdenLaboratorio> ayudaOrdeneLab = new List<GridOrdenLaboratorio>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                //Declaramos los parámetros
                lParams.Add(new Parametros { Nombre = "@Empresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@Folio", Tipo = SqlDbType.Int, Valor = FolioBusca });
                lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = intDoctor });
                lParams.Add(new Parametros { Nombre = "@intTipoProtesis", Tipo = SqlDbType.Int, Valor = intTipoProtesis });

                //Usamos la conexión ejecutando el siguiente SP
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_BuscarOrdenLaboratorio_SEL", lParams);

                ayudaOrdeneLab = (
                    from DataRow dr in Results.Rows
                    select new GridOrdenLaboratorio
                    {
                        intFolio = dr["Folio"].ToString(),
                        strFecha = dr["Fecha"].ToString(),
                        intOrdenLaboratorioEnc = dr["Folio_OrdenLab"].ToString(),
                        strDoctor = dr["Doctor"].ToString(),
                        strTipoProtesis = dr["Protesis"].ToString(),

                    }).ToList();

            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return ayudaOrdeneLab;
            }

            //Devolvemos la lista
            return ayudaOrdeneLab;
        }



        public static List<MaterialesORD> GetListaMateriales()
        {
            List<MaterialesORD> material = new List<MaterialesORD>();

            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                DataTable Results = cn.ExecSP("qry_V2_ListarMaterialesActivos_SEL", lParams);

                material = (
                    from DataRow dr in Results.Rows
                    select new MaterialesORD
                    {
                        MaterialID = dr["intMaterial"].ToString(),
                        Nombre = dr["strNombreMaterial"].ToString(),

                    }).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return material;
            }
            return material;
        }

        public static List<TrabXMatORD> GetTipoTrabajoActivosXMaterial(int intMaterial)
        {
            List<TrabXMatORD> tipoTrabajoXMaterial = new List<TrabXMatORD>();
            try
            {
                List<Parametros> lParams = new List<Parametros>();
                Conexion cn = new Conexion("cnnLabAllCeramicOLD");
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intMaterial", Tipo = SqlDbType.Int, Valor = intMaterial });
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajo", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intActivos", Tipo = SqlDbType.Int, Valor = 1 });
                DataTable Results = cn.ExecSP("qry_V2_TipoTrabajoXMaterial_Sel", lParams);

                tipoTrabajoXMaterial = (
                        from DataRow dr in Results.Rows
                        select new TrabXMatORD
                        {
                            MaterialID = dr["intMaterial"].ToString(),
                            intTrabajo = dr["intTipoTrabajo"].ToString(),
                            strNombre = dr["strNombre"].ToString(),
                        }
                    ).ToList();
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
                return tipoTrabajoXMaterial;
            }
            return tipoTrabajoXMaterial;
        }


        public static Resultado OrdenLaboratorioDet_V2_App(int intOrdenLaboratorioEnc, string intPieza, int intMaterial, int intTipoTrabajo, string strUsuario)
        {
            Resultado res = new Resultado();
            List<Parametros> lParams = new List<Parametros>();
            Conexion cn = new Conexion("cnnLabAllCeramicOLD");
            try
            {
                lParams.Add(new Parametros { Nombre = "@intEmpresa", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioDet", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@intOrdenLaboratorioEnc", Tipo = SqlDbType.Int, Valor = intOrdenLaboratorioEnc });
                lParams.Add(new Parametros { Nombre = "@intPieza", Tipo = SqlDbType.NVarChar, Valor = intPieza });

                lParams.Add(new Parametros { Nombre = "@intMaterial", Tipo = SqlDbType.Int, Valor = intMaterial });
                lParams.Add(new Parametros { Nombre = "@intTipoTrabajo", Tipo = SqlDbType.Int, Valor = intTipoTrabajo });
                lParams.Add(new Parametros { Nombre = "@strColor", Tipo = SqlDbType.Int, Valor = 0 });
                lParams.Add(new Parametros { Nombre = "@material", Tipo = SqlDbType.NVarChar, Valor = "XXX" });
                lParams.Add(new Parametros { Nombre = "@trabajo", Tipo = SqlDbType.NVarChar, Valor = "XXX" });
                lParams.Add(new Parametros { Nombre = "@strUsuario", Tipo = SqlDbType.NVarChar, Valor = strUsuario });
                lParams.Add(new Parametros { Nombre = "@strMaquina", Tipo = SqlDbType.NVarChar, Valor = strUsuario });


                DataTable Results = cn.ExecSP("qry_V2_tbOrdenLaboratorioDet_App", lParams);
                res.Id = (from DataRow dr in Results.Rows select dr["result"].ToString()).FirstOrDefault();
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

        //public static List<GridOrdenLaboratorio> getOrdenLabDet(int FolioBusca, int intDoctor, int intTipoProtesis)
        //{
        //    //Instanciamos "gridAdministrarMenu"
        //    List<GridOrdenLaboratorio> ayudaOrdeneLab = new List<GridOrdenLaboratorio>();
        //    try
        //    {
        //        List<Parametros> lParams = new List<Parametros>();
        //        //Declaramos los parámetros
        //        lParams.Add(new Parametros { Nombre = "@Empresa", Tipo = SqlDbType.Int, Valor = 1 });
        //        lParams.Add(new Parametros { Nombre = "@intSucursal", Tipo = SqlDbType.Int, Valor = 1 });
        //        lParams.Add(new Parametros { Nombre = "@Folio", Tipo = SqlDbType.Int, Valor = FolioBusca });
        //        lParams.Add(new Parametros { Nombre = "@intDoctor", Tipo = SqlDbType.Int, Valor = intDoctor });
        //        lParams.Add(new Parametros { Nombre = "@intTipoProtesis", Tipo = SqlDbType.Int, Valor = intTipoProtesis });

        //        //Usamos la conexión ejecutando el siguiente SP
        //        Conexion cn = new Conexion("cnnLabAllCeramicOLD");
        //        DataTable Results = cn.ExecSP("qry_V2_BuscarOrdenLaboratorio_SEL", lParams);

        //        ayudaOrdeneLab = (
        //            from DataRow dr in Results.Rows
        //            select new GridOrdenLaboratorio
        //            {
        //                intFolio = dr["Folio"].ToString(),
        //                strFecha = dr["Fecha"].ToString(),
        //                intOrdenLaboratorioEnc = dr["Folio_OrdenLab"].ToString(),
        //                strDoctor = dr["Doctor"].ToString(),
        //                strTipoProtesis = dr["Protesis"].ToString(),

        //            }).ToList();

        //    }
        //    catch (Exception ex)
        //    {
        //        string error = ex.ToString();
        //        return ayudaOrdeneLab;
        //    }

        //    //Devolvemos la lista
        //    return ayudaOrdeneLab;
        //}

    }
}