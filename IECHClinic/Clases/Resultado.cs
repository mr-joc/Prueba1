using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IECHClinic.Clases
{
    //Esta clase llamada Resultado la estaremos usando en prácticamente todo el sistema, consta de 3 parámetros
    public class Resultado
    {
        //"OK" es para saber si la respuesta es Verdadera o falsa, ellos nos ayudará a saber si hubo algún error al mandar la info a la BD, usamos esto a manera de encabezado
        public bool OK { get; set; }
        //"Mensaje" nos sirve para devolver tanto mensajes de confirmación desde la BD como ERRORES que puedan ocurrir. Cualquiera que se el caso, en la parte del HTML lo podemos tomar y mostrar
        public string Mensaje { get; set; }
        //"Id" se va a usar siempre con el número o clave que la BD nos genere y nos entregue en el dataset de resultado (por ejemplo el número de empleado, pero si hay error este vendrá vacío)
        public string Id { get; set; }
    }
}