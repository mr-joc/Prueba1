using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class DoctorVM
    {
        public List<GridDoctor> lGridDoctor { get; set; }
        [Display(Name = "Doctor")]
        public int intDoctorID { get; set; }
        [Display(Name = "Nombre")]
        public string strNombre { get; set; }
        [Display(Name = "Apellido Paterno")]
        public string strApPaterno { get; set; }
        [Display(Name = "Apellido Materno")]
        public string strApMaterno { get; set; }
        [Display(Name = "Dirección")]
        public string strDireccion { get; set; }
        [Display(Name = "E-Mail")]
        public string strEMail { get; set; }
        [Display(Name = "Colonia")]
        public string strColonia { get; set; }
        [Display(Name = "RFC")]
        public string strRFC { get; set; }






        [Display(Name = "Nombre Fiscal")]
        public string strNombreFiscal { get; set; }
        [Display(Name = "Código Postal")]
        public int intCP { get; set; }
        [Display(Name = "Teléfono")]
        public string strTelefono { get; set; }
        [Display(Name = "Celular")]
        public string strCelular { get; set; }
        [Display(Name = "Dirección Fiscal")]
        public string strDireccionFiscal { get; set; }
        public bool Estado { get; set; }
        public int IsBorrado { get; set; }
    }

    //Listado de los Doctores
    public class GridDoctor
    {
        public int intDoctor { get; set; }
        public string strNombreCompleto { get; set; }
        public string strNombre { get; set; }
        public string strApPaterno { get; set; }
        public string strApMaterno { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }
}