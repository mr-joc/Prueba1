using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IECHClinic.Clases
{
    public class Menu
    {
        //CLASE MENU
        //Aquí ponemos todos los parámetros que se van a ocupar para el Menú
        
        //Primero el ID
        public int IdMenu { get; set; }
        //La descripción
        public string Descripcion { get; set; }
        //En caso de que el menú requiera de un parámetro aquí se va a colocar 
        public string Parametro { get; set; }
        //La Vista a la que hace referencia
        public string View { get; set; }
        //El control que contiene la Vista
        public string Controller { get; set; }
        //El Rol (Para saber cuales roles tienen accedo a este menú
        public byte IDRol { get; set; }
        //SubMenú se utiliza para denotar de cual nodo se desprende, por ejemplo si "CATALOGOS" es el menú 5 y "Empleados el 8, entonces el Menu 8 tendrá su columna SUB-Menu = 5
        public int subMenu { get; set; }
        //El orden en que se despliega el menú, puede variar en función de cada Usuario
        public byte Orden { get; set; }
        //Nivel en que estará el menú (o es al principo y de ahí cada nivel va a umentando conforme se vaya "escarbando"
        public byte Nivel { get; set; }
        //Este se usa para saber si del elemento se desprende una lista, por ejemplo: INICIO y SALIDA no son nodos, tampoco lo son los catálogos de Empleados o Roles porque estos son el nivel más bajo del menú
        public bool IsNode { get; set; }
        //Si lleva Ícono, se coloca en esta columna
        public string Icon { get; set; }
    }

    public class Notificaciones
    {
        public int intNotificacion { get; set; }
        public int intTotal { get; set; }
        public int InternalID { get; set; }
        public int RolID { get; set; }
        public string strTitulo { get; set; }
        public string strsubTitulo { get; set; }
        public string strEnlace { get; set; }
        public byte Nivel { get; set; }
        public string strIcono { get; set; }
        public byte Orden { get; set; }
    }

}