using CrystalDecisions.CrystalReports.Engine;
using System.Configuration;
using System;
using System.Web;

namespace appWebPrueba.Clases
{
    public class VetecReport
    {
    }

    public class VetecReporte
    {
        private string _reportSource = string.Empty;
        private string _viewerLocation = string.Empty;
        private string _parametrosReporte = string.Empty;

        public string viewerLocation
        {
            get { return _viewerLocation; }
            set { _viewerLocation = value; }
        }

        public string reportSource
        {
            get { return _reportSource; }
            set { _reportSource = value; }
        }

        public string parametrosReporte
        {
            get { return _parametrosReporte; }
            set { _parametrosReporte = value; }
        }

        public void show(System.Web.UI.Page p_Form)
        {

            if (_reportSource == string.Empty)
                throw new Exception("No se ha definido el nombre del Reporte.");
            string strBD = "server=.\\SQLEXPRESS;user id=sa; pwd=515t3m45;database=LabAllCeramic; Pooling=false; Max Pool Size=100; ";

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + "/VetecReportes/Reportes/";
            //ConfigurationSettings.AppSettings["PathReporteador"].ToString()
            string strPost = "?reportSource="
                + _reportSource + "&parametrosReporte="
                + _parametrosReporte + "&bd=" + strBD;
            string strScript = ("<SCRIPT language=\'javascript\'>window.open(\'" + strServerName + "VisorReportes.aspx" + strPost + "\',\'\',\'" + "scrollbars=1, resizable=1" + "\');</SCRIPT>");

            if (!p_Form.ClientScript.IsStartupScriptRegistered("showPopup"))
                p_Form.ClientScript.RegisterStartupScript(typeof(System.Web.UI.Page), "showPopup", strScript);
        }


        public void showPopup(System.Web.UI.Page p_Form, string p_strPagina, int p_intWidth, int p_intHeight, bool p_blPopup)
        {
            string strConfig;
            string strScript;
            if (p_blPopup)
            {
                strConfig = ("dialogHeight: " + (p_intHeight.ToString() + ("px; dialogWidth: " + (p_intWidth.ToString() +
                        "px; edge: Sunken; center: Yes; help: No; resizable: yes; scroll:no;  status: No;"))));
                strScript = ("<SCRIPT language=\'javascript\'>window.showModalDialog(\'" + (p_strPagina + ("\',self,\'" + (strConfig + "\');</SCRIPT>"))));
            }
            else
            {
                if (p_intWidth == 0)
                    strConfig = String.Empty;
                else
                    strConfig = ("height=" + (p_intHeight.ToString() + (", width=" + (p_intWidth.ToString() + ", resizable= yes"))));
                strScript = ("<SCRIPT language=\'javascript\'>window.open(\'" + (p_strPagina + ("\',\'\',\'" + (strConfig + "\');</SCRIPT>"))));
            }
            if (!p_Form.IsStartupScriptRegistered("showPopup"))
                p_Form.RegisterStartupScript("showPopup", strScript);

        }

        //public void print()
        //{
        //    try
        //    {
        //        ReportDocument objReporte;
        //        string strReportSource = _reportSource;
        //        string[] arrParametrosReporte = _parametrosReporte.Replace("[--]", "�").Split('�');
        //        string strBD = VetecUtils.obtenerBDActual();

        //        objReporte = new ReportDocument();
        //        objReporte.Load(strReportSource);
        //        objReporte.DataSourceConnections[0].SetConnection(ConfigurationSettings.AppSettings["server"],
        //            strBD, ConfigurationSettings.AppSettings["user"], ConfigurationSettings.AppSettings["password"]);
        //        int intCount;
        //        for (intCount = 0; (intCount <= (arrParametrosReporte.Length - 1)); intCount++)
        //            objReporte.SetParameterValue(intCount, arrParametrosReporte[intCount].Replace("[ENTER]", System.Environment.NewLine));
        //        objReporte.PrintToPrinter(1, false, 0, 0);
        //    }
        //    catch (Exception) { }
        //}

    }

}