using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace appWebPrueba.Models
{
    public class ArticuloVM
    {
        //Este sirve para instanciar las columnas de la BD, tanto para guardar como para actualizar
        public List<GridArticulo> lGridArticulo { get; set; }
        [Display(Name = "Artículo")]
        public int intArticuloID { get; set; }
        [Display(Name = "Descripción")]
        public string strNombre { get; set; }
        [Display(Name = "Número de Parte")]
        public string strNombreCorto { get; set; }


        [Display(Name = "Número de Parte")]
        public string PartNum { get; set; }
        [Display(Name = "Descripción")]
        public string PartDesc { get; set; }
        [Display(Name = "UM Entrada")]
        public int intUnidadMedidaCompra { get; set; }
        [Display(Name = "UM Entrada")]
        public string strUMCompra { get; set; }
        [Display(Name = "Conversión E - A")]
        public decimal dblConversionCompraAlmacen { get; set; }
        [Display(Name = "UM Almacén")]
        public int intUnidadMedidaAlmacen { get; set; }
        [Display(Name = "UM Almacén")]
        public string strUMAlmacen { get; set; }
        [Display(Name = "Conversión A - S")]
        public decimal dblConversionAlmacenVenta { get; set; }
        [Display(Name = "UM Salida")]
        public int intUnidadMedidaVenta { get; set; }
        [Display(Name = "UM Salida")]
        public string strUMVenta { get; set; }
        [Display(Name = "Proveedor")]
        public int intProveedorBase { get; set; }

        public List<Proveedor> lProveedor { get; set; }
        public Proveedor Proveedor { get; set; }

        public List<UnidadMedida> lUnidadMedida { get; set; }
        public UnidadMedida UnidadMedida { get; set; }
        public List<UnidadMedidaCompra> lUnidadMedidaCompra { get; set; }
        public UnidadMedidaCompra UnidadMedidaCompra { get; set; }
        public List<UnidadMedidaAlmacen> lUnidadMedidaAlmacen { get; set; }
        public UnidadMedidaAlmacen UnidadMedidaAlmacen { get; set; }
        public List<UnidadMedidaVenta> lUnidadMedidaVenta { get; set; }
        public UnidadMedidaVenta UnidadMedidaVenta { get; set; }

        public int IsBorrado { get; set; }
        public bool Estado { get; set; }
        public string strUsuarioAlta { get; set; }
    }

    //Listado de los Articuloes
    public class GridArticulo
    {

        public int intArticulo { get; set; }
        public string strNombre { get; set; }
        public string strNombreCorto { get; set; }
        public string PartNum { get; set; }
        public string PartDesc { get; set; }
        public int intUnidadMedidaCompra { get; set; }
        public string strUMCompra { get; set; }
        public decimal dblConversionCompraAlmacen { get; set; }
        public int intUnidadMedidaAlmacen { get; set; }
        public string strUMAlmacen { get; set; }
        public decimal dblConversionAlmacenVenta { get; set; }
        public int intUnidadMedidaVenta { get; set; }
        public string strUMVenta { get; set; }
        public int intProveedorBase { get; set; }
        public bool Estado { get; set; }
        public int Acciones { get; set; }
    }

    public class Proveedor
    {
        public string ProveedorID { get; set; }
        public string NombreProveedor { get; set; }
    }


    public class UnidadMedida
    {
        public string UnidadMedidaID { get; set; }
        public string NombreUnidadMedida { get; set; }
    }
    public class UnidadMedidaCompra
    {
        public string UnidadMedidaID { get; set; }
        public string NombreUnidadMedida { get; set; }
    }

    public class UnidadMedidaAlmacen
    {
        public string UnidadMedidaID { get; set; }
        public string NombreUnidadMedida { get; set; }
    }

    public class UnidadMedidaVenta
    {
        public string UnidadMedidaID { get; set; }
        public string NombreUnidadMedida { get; set; }
    }
}