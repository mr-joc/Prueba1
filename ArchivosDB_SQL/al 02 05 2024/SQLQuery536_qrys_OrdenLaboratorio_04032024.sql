USE LabAllCeramic
go

--ALTER TABLE tbOrdenLaboratorioDet ALTER COLUMN intPieza	VARCHAR(1000)

go
--qry_V2_tbOrdenLaboratorioDet_App 1,1,0,1,3.2,1,1,'A1.5','material varchar','tipotrabajo varchar','JORGE','10.0.0.65'
alter PROCEDURE qry_V2_tbOrdenLaboratorioDet_App
@intEmpresa INT,  
@intSucursal INT,  
@intOrdenLaboratorioDet INT,  
@intOrdenLaboratorioEnc INT,  
@intPieza VARCHAR (1000),
@intMaterial INT,  
@intTipoTrabajo INT,  
--@intCantidad INT,
@strColor INT,
--@strColor VARCHAR(7), --CAMBIAMOS POR CANTIDAD
@material varchar (1000),
@trabajo varchar (1000),
@strUsuario VARCHAR(50),  
@strMaquina VARCHAR(50)  

AS  
BEGIN


	DECLARE @ID INT, @Posicion2 INT, @idPieza VARCHAR(150), @ListadoPiezas VARCHAR(1000)	 
	DECLARE @tbPiezas TABLE (idPieza INT IDENTITY(1, 1), strPiezaIndividual NVARCHAR(20))
	
	SET @ListadoPiezas = REPLACE(@intPieza, '~1', ',1')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, '~2', ',2')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, '~3', ',3')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, '~4', ',4')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, '~', '')
	SET @ListadoPiezas = REPLACE(@ListadoPiezas, ' ', '')

	IF @intPieza is null
	BEGIN  
		RAISERROR('Se debe indicar la pieza. No se insertaron datos.', 16, 1)  
		RETURN  
	END

	IF @intMaterial is null
	BEGIN  
		RAISERROR('Se debe indicar el material. No se insertaron datos.', 16, 1)  
		RETURN  
	END  

	IF @intTipoTrabajo is null
	BEGIN  
		RAISERROR('Se debe indicar el tipo de trabajo. No se insertaron datos.', 16, 1)  
		RETURN  
	END  


	DECLARE @strError VARCHAR (500),@intPiezaNoExiste VARCHAR (30)


	DECLARE @intPiezaCapturada NUMERIC(18,1)
	IF EXISTS (SELECT * FROM tbOrdenLaboratorioDet WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal 
			AND intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc AND @intOrdenLaboratorioDet = 0 AND intPieza = @intPieza)
	BEGIN
	SET @intPiezaCapturada=@intPieza
		SET @strError=('LA PIEZA "'+convert(varchar(8),@intPiezaCapturada)+'" YA FUE REGISTRADA EN ESTA ORDEN. INGRESE OTRA PIEZA.')      
		RAISERROR (@strError, 16, 1)      
		RETURN      
	END

	
	SET @intPieza = REPLACE(@intPieza, ' ', '')

	SET @intPieza = @intPieza + '~'
	WHILE patindex('%~%' , @intPieza) <> 0
	BEGIN
		SELECT @Posicion2 =  patindex('%~%' , @intPieza)
		SELECT @idPieza = left(@intPieza, @Posicion2 - 1)
		IF NOT EXISTS (SELECT strPiezaIndividual FROM @tbPiezas WHERE strPiezaIndividual = @idPieza)
		BEGIN 
			INSERT @tbPiezas (strPiezaIndividual)
			SELECT
				strPiezaIndividual = @idPieza
				WHERE @idPieza <> '' 
		END

		SELECT @intPieza = stuff(@intPieza, 1, @Posicion2, '')
	END

	SELECT @strColor = COUNT(idPieza) FROM @tbPiezas


	IF NOT EXISTS(SELECT * FROM tbOrdenLaboratorioDet WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal AND intOrdenLaboratorioDet=@intOrdenLaboratorioDet) OR @intOrdenLaboratorioDet=0
	BEGIN
		INSERT tbOrdenLaboratorioDet(intEmpresa,intSucursal,intOrdenLaboratorioEnc,intPieza,intMaterial,intTipoTrabajo,
			strColor,intCantidad,strUsuarioAlta,strMaquinaAlta,datFechaAlta)  
		SELECT intEmpresa = @intEmpresa,intSucursal=@intSucursal,intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc,intPieza=UPPER(@ListadoPiezas),intMaterial=@intMaterial,
			intTipoTrabajo=@intTipoTrabajo,
			strColor=@strColor,intCantidad=@strColor,strUsuarioAlta=@strUsuario,strMaquinaAlta=@strMaquina,datFechaAlta=GETDATE()

		SET @ID = IDENT_CURRENT('tbOrdenLaboratorioDet')
	END
	ELSE  
	BEGIN  
		UPDATE tbOrdenLaboratorioDet  
		SET
			intEmpresa=@intEmpresa,
			intSucursal=@intSucursal,
			intOrdenLaboratorioEnc=@intOrdenLaboratorioEnc,
			intPieza=UPPER(@ListadoPiezas),
			intMaterial=@intMaterial,
			intTipoTrabajo=@intTipoTrabajo,
			strColor=@strColor,
			intCantidad=@strColor,
			strUsuarioMod=@strUsuario,
			strMaquinaMod=@strMaquina,
			datFechaMod=GETDATE()
		WHERE intEmpresa=@intEmpresa AND intSucursal=@intSucursal AND intOrdenLaboratorioDet=@intOrdenLaboratorioDet

		SET @ID = @intOrdenLaboratorioDet
	END

	SELECT result = @ID, Mensaje = 'Se agregó detalle a la orden '+CONVERT(VARCHAR(10), @intOrdenLaboratorioEnc)
END
go

/*

qry_V2_tbOrdenLaboratorioDet_App
@intEmpresa				= 1,  
@intSucursal			= 1,  
@intOrdenLaboratorioDet	= 0,  
@intOrdenLaboratorioEnc	= 6743,  
@intPieza				= '1.5~1.4~1.3~1.2~1.1~',
@intMaterial			= 2,  
@intTipoTrabajo			= 51,  
@strColor				= 1000,
@material				= 'X',
@trabajo				= 'X',
@strUsuario				= 'MR-JOC',  
@strMaquina				= 'MR-JOC'  
go


*/

--SELECT TOP 1000 * FROM tbOrdenLaboratorioDet WITH(NOLOCK) ORDER BY intOrdenLaboratorioEnc DESC, intOrdenLaboratorioDet 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*


SELECT intOrdenLaboratorioEnc,intOrdenLaboratorioDet,intPieza,intMaterial,intTipoTrabajo,strUsuarioElimina='x',strMaquinaElimina='x',datFechaElimina=GETDATE(),intCantidad
INTO tbOrdenesDetEliminadas
FROM tbOrdenLaboratorioDet WHERE intOrdenLaboratorioDet = 6762

ALTER TABLE tbOrdenesDetEliminadas DROP COLUMN intOrdenLaboratorioDet

ALTER TABLE tbOrdenesDetEliminadas ADD intOrdenLaboratorioDet INT-- NOT NULL

ALTER TABLE tbOrdenesDetEliminadas ALTER COLUMN intOrdenLaboratorioDet INT NOT NULL

ALTER TABLE tbOrdenesDetEliminadas ALTER COLUMN strUsuarioElimina NVARCHAR(250)
ALTER TABLE tbOrdenesDetEliminadas ALTER COLUMN strMaquinaElimina NVARCHAR(250)

*/


go
--qry_TipoGasto_Del 5, 'MR-JOC'
alter PROCEDURE qry_V2_OrdenLaboratorioDet_Del
	@intOrdenLaboratorioDet	INT,
	@strUsuario				NVARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ID INT 

	INSERT tbOrdenesDetEliminadas(intOrdenLaboratorioEnc,intOrdenLaboratorioDet,intPieza,intMaterial,intTipoTrabajo,strUsuarioElimina,strMaquinaElimina,datFechaElimina,intCantidad)
	SELECT intOrdenLaboratorioEnc,intOrdenLaboratorioDet,intPieza,intMaterial,intTipoTrabajo,strUsuarioElimina=@strUsuario,strMaquinaElimina=@strUsuario,datFechaElimina=GETDATE(),intCantidad
	FROM tbOrdenLaboratorioDet WHERE intOrdenLaboratorioDet = @intOrdenLaboratorioDet

	DELETE FROM tbOrdenLaboratorioDet 
	WHERE intOrdenLaboratorioDet = @intOrdenLaboratorioDet;

	select @intOrdenLaboratorioDet as Id;
END
go

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
