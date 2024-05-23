use LabAllCeramic
go



SELECT intPerfil FROM segUsuarios  WHERE strUsuario='jorge'
SELECT intPerfil FROM segUsuarios  WHERE strUsuario='mr-joc'

--



go
--qryTipoDocumento_CambiarEstatus 1,1,8,8,'ODE',1,2,'JORGE','127.0.0.1','VAMOS A PONER LA 3450 COMO CAJA Y LA FECHA LA MOVEMOS AL DIA 30 DE JULIO',0  
alter PROCEDURE dbo.qryTipoDocumento_CambiarEstatus 
@intEmpresa INT,   
@intSucursal INT,   
@intTipoDocumento INT,   
@intTipoEstatus INT,   
@strSerie VARCHAR(20),   
@intFolio INT,   
@intNuevoEstatus INT,   
@strUsuario VARCHAR(50),  
@strMaquina VARCHAR(50),  
@strComentario VARCHAR(500),    
@intResult INT=NULL OUT
AS     
BEGIN

	SET @strUsuario = (CASE @strUsuario WHEN 'mr-joc' THEN 'jorge' ELSE @strUsuario END)
  
	--Obtenemos el perfil  
	DECLARE @intPerfil INT, @intEstatusActual INT, @strEstatus VARCHAR(100), @intActivo INT, @strCorreos VARCHAR(1000), @strTexto VARCHAR(2000)  
	SET @intPerfil=(SELECT intPerfil FROM segUsuarios  WHERE strUsuario=@strUsuario)  
	--select*from tbestatus
	SELECT @intActivo=ISNULL(intActivo,0), @strCorreos=ISNULL(strCorreos,'')  
	FROM tbEstatus  
	WHERE intEmpresa=@intEmpresa  
	AND intSucursal=@intSucursal  
	AND intTipo=@intTipoEstatus  
	AND intEstatus=@intNuevoEstatus  
	  
	/*Verificar condiciones en cambio de estatus*/
--SELECT strEstatus=strNombre FROM tbEstatus WHERE intEmpresa=1 AND intTipo=8 AND intEstatus=3  
	SELECT @strEstatus=strNombre FROM tbEstatus WHERE intEmpresa=@intEmpresa AND intTipo=@intTipoEstatus AND intEstatus=@intNuevoEstatus  
	  
	--Permiso para el estatus 
--SELECT * FROM tbPermisosDocumentos WHERE intEmpresa=1 AND intTipoDocumento=8 AND intTipoEstatus=8 AND intPerfil=(SELECT intPerfil FROM segUsuarios  WHERE strUsuario='JORGE') AND intEstatus=3 
	IF NOT EXISTS(SELECT * FROM tbPermisosDocumentos WHERE intEmpresa=@intEmpresa AND intTipoDocumento=@intTipoDocumento AND intTipoEstatus=@intTipoEstatus AND intEstatus=@intNuevoEstatus  AND intPerfil=@intPerfil)  
	BEGIN  
		RAISERROR('©El usuario %s no tiene permiso para realizar ''%s'' en este documento. Favor de revisar los permisos.©', 16, 1, @strUsuario, @strEstatus)  
		SET @intResult=0  
		RETURN 0  
	END
/*
	IF @intTipoEstatus=6 AND @intTipoDocumento=6 
	BEGIN
		SET @intEstatusActual=ISNULL((select intEstatus from tbRequisicionTraspasoEnc WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal AND intRequisicionTraspasoEnc=@intFolio),0) 
	
		IF (((ISNULL(@intEstatusActual,0)+1)<> @intNuevoEstatus) AND @intNuevoEstatus<>9)  
		BEGIN 
			RAISERROR('©No es posible pasar a este estatus. XXX22222222. Los estatus deben ser consecutivos.©', 16, 1, @strUsuario)  
			RETURN 0   
		END     
		ELSE  
		BEGIN    
			--Actualizamos el estatus  
			UPDATE tbRequisicionTraspasoEnc   
			SET intEstatus=@intNuevoEstatus  
			WHERE intEmpresa=@intEmpresa  
			AND intSucursal=@intSucursal  
			AND intRequisicionTraspasoEnc=@intFolio
		END 
	END
*/
	IF @intTipoEstatus=8 AND @intTipoDocumento=8
	BEGIN
		DECLARE @intProceso INT

		SET @intProceso=(SELECT OE.intProceso FROM tbOrdenLaboratorioEnc OE WHERE OE.intEmpresa=@intEmpresa AND OE.intSucursal=@intSucursal AND OE.intOrdenLaboratorioEnc=@intFolio)
		SET @intEstatusActual=ISNULL((SELECT intEstatus FROM tbOrdenLaboratorioEnc WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal AND intOrdenLaboratorioEnc=@intFolio),0) 
	
		IF (((ISNULL(@intEstatusActual,0)+1)<> @intNuevoEstatus) AND @intNuevoEstatus<>9)  
		BEGIN 
			RAISERROR('©No es posible pasar a este estatus. Los estatus deben ser consecutivos.©', 16, 1, @strUsuario)  
			RETURN 0   
		END     
		ELSE  
		BEGIN    
			--Actualizamos el estatus  
			UPDATE tbOrdenLaboratorioEnc   
			SET intEstatus=@intNuevoEstatus  
			WHERE intEmpresa=@intEmpresa  
			AND intSucursal=@intSucursal  
			AND intOrdenLaboratorioEnc=@intFolio

			INSERT tbCambioEstatusOrdenDental (intEmpresa,intSucursal,intOrdenLaboratorioEnc,intProceso,intEstatus,strUsuario,strComentario,
							strMaquina,datFecha)
			SELECT @intEmpresa,@intSucursal,@intFolio,@intProceso,@intNuevoEstatus,@strUsuario,@strComentario,
							@strMaquina, GETDATE()
							
		END 
	END
	    
	SET @intResult=1  
END
go


