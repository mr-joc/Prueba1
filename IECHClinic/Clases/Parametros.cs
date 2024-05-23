using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace IECHClinic.Clases
{
    /// <summary>
    /// Clase generica para enlistarlos parametros para consumir un Stored Procedure
    /// </summary>
    /// 
    //Esta es una de las clases más usadas, de echo se usa para TODAS las conexiones 
    public class Parametros
    {
        //Colocamos el nombre del parámetro de SQL, se puede usar digamos "@strNombre" o solamente "Nombre" pero este debe ser exáctamente igual que el que se declara como input en el SP de la BD
        public string Nombre { get; set; }
        //El tipo, si es INT, VARCHAR, DECIMAL, etc
        public SqlDbType Tipo { get; set; }
        //El valor como tal
        public object Valor { get; set; }
        //La fecha se usa cuando queremos evaluar fechas como tal, ahora no se usó, pero lo dejamos por si acaso (puede servir en algún reporte)
        public string Fecha { get; set; }

    }
}