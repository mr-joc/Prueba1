using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace appWebPrueba.Helpers
{
    public class Code
    {
        public static bool EvaluaBool(object obj)
        {

            bool bolValido = false;
            bolValido = (obj.ToString() == "1" || obj.ToString().ToUpper() == "TRUE" ? true : false);

            return bolValido;
        }


        public static T ExtraeDataRow<T>(object dr)
        {
            return (T)Convert.ChangeType(dr, typeof(T));
        }
    }
}