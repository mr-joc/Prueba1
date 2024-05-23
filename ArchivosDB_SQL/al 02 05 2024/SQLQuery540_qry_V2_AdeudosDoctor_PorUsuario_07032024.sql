USE labAllCeramic
go

/*

UPDATE tbMenu2024 SET Controlador ='Reportes', Vista = 'AdeudosXDoctor' WHERE intMenu = 29
UPDATE tbMenu2024 SET Controlador ='Reportes', Vista = 'AdeudosXDoctor' WHERE intMenu = 32
UPDATE tbMenu2024 SET Controlador ='Reportes', Vista = 'AdeudosXDoctor' WHERE intMenu = 64

SELECT * FROM tbMenu2024 WHERE intMenu IN (29, 32, 64)

*/
--qryTipoTrabajoPagado_Sel 1, 1, 2
go


go
--qryAdeudosDoctor_PorUsuario 5, 0, 'JORGE'
alter PROCEDURE qry_V2_AdeudosDoctor_PorUsuario
@intDoctor INT,
@intPagado INT, --1 SI, 0 NO, 2 = TODOS
@strUsuario VARCHAR (100)

AS	
BEGIN
	DECLARE @strError VARCHAR (100)

	IF @strUsuario IN ('JORGE','JANETH','mr-joc')
	BEGIN
		SELECT
			R.intOrdenLaboratorioEnc,R.strNombrePaciente,
			strDoctor =(SELECT D.strNombre+' '+D.strApPaterno+' '+D.strApMaterno FROM tbDoctor2024 AS D WHERE D.intDoctor = R.intDoctor),
			strTipoProtesis=(SELECT P.strNombreTipoProtesis FROM tbTipoProtesis2024 AS P WHERE P.intTipoProtesis=R.intTipoProtesis),
			strProceso=(SELECT PRO.strNombreProceso FROM tbProceso2024 PRO WHERE PRO.intProceso=R.intProceso),
			datEntrega=(CONVERT(VARCHAR(10),R.datFechaEntrega,103)),
			datEntregaReal=(CONVERT(VARCHAR(10),(SELECT TOP 1 CO.datFecha FROM tbCambioEstatusOrdenDental AS CO WHERE CO.intEstatus = 5 AND CO.intOrdenLaboratorioEnc=R.intOrdenLaboratorioEnc ),103)),
			datEntrega1= R.datFechaEntrega,
			datEntregaReal1=(SELECT TOP 1 CO.datFecha FROM tbCambioEstatusOrdenDental AS CO WHERE CO.intEstatus = 5 AND CO.intOrdenLaboratorioEnc=R.intOrdenLaboratorioEnc ),
			dblCosto=ISNULL(R.dblPrecio,0),
			dblPagado=ISNULL((SELECT SUM(dblMonto) FROM tbAbonoTrabajo AS A WHERE A.intOrdenLaboratorioEnc = R.intOrdenLaboratorioEnc),0),
			R.strComentario, R.strObservaciones, R.intEstatus,
			intPagado=ISNULL(R.intPagado, 0),
			strEstatus=(ES.strNombre+'&nbsp;<img ALT='+ES.strNombre+''' border=''0''  src=''../../Imagenes/'+ES.strImagen+''' />')
		INTO #tmpResultado
 		FROM tbOrdenLaboratorioEnc R, tbEstatus AS ES
		WHERE (intDoctor=@intDoctor OR @intDoctor = 0)
			AND ((ISNULL(R.intPagado, 0)) = @intPagado OR @intPagado = 2)
			AND ES.intEstatus=R.intEstatus AND ES.intEmpresa=R.intEmpresa AND ES.intSucursal=R.intSucursal
			AND R.intEstatus = 5

			
		SELECT
			intOrdenLaboratorioEnc,strNombrePaciente,strDoctor,strTipoProtesis,strProceso,
			strDetalle=dbo.fn_ObtenerDetalleOrdenLab(intOrdenLaboratorioEnc),
			datEntrega, datEntregaReal,--datEntrega1, datEntregaReal1,DATEDIFF(DD, datEntrega1, datEntregaReal1),
			intDiasRetraso=(CASE WHEN(DATEDIFF(DD, datEntrega1, datEntregaReal1))<= 0 THEN 0 ELSE (DATEDIFF(DD, datEntrega1, datEntregaReal1)) END),
			dblCosto,dblPagado,dblSaldo=dblCosto - dblPagado,
			strComentario,strObservaciones,intEstatus,
			strEstatus=(CASE intPagado WHEN 1 THEN 'PAGADO' WHEN 0 THEN 'PENDIENTE' ELSE '.' END),
			strEstatus2=strEstatus
		FROM #tmpResultado/**/
	END
	ELSE
	BEGIN
		SET @strError=('Solo los usuarios con permiso pueden ver esta información.')      
		RAISERROR (@strError, 16, 1)      
		RETURN 
	END
	
END
go



qry_V2_AdeudosDoctor_PorUsuario
@intDoctor =1,
@intPagado =2, --1 SI, 0 NO, 2 = TODOS
@strUsuario ='mr-JOC'























