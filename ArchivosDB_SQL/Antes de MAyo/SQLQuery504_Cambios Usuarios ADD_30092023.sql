USE AllCeramic2024
go



go
alter PROCEDURE [dbo].[qry_Notificaciones_SEL]
@InternalID NVARCHAR(100)
AS
BEGIN
	DECLARE @RolID INT, @DCDUserID NVARCHAR(50)

	SELECT TOP 1 @RolID = intRol,
			@DCDUserID = strUsuario
	FROM SegUsuarios
	WHERE intUsuario = @InternalID

	
	SELECT intNotificacion,InternalID,RolID,strTitulo,strsubTitulo,
		strEnlace = ISNULL(strEnlace, '#'),
		Nivel = 1, strIcono,intOrden,
		datFechaAlta,datFechaInicia,datFechaVigencia 
	INTO #Notificaciones 
	FROM tbNotificaciones 
	WHERE CONVERT(DATETIME, (CONVERT(VARCHAR(10), GETDATE(), 103)), 103) BETWEEN datFechaInicia AND datFechaVigencia 
		AND RolID = @RolID 
	UNION	
	SELECT intNotificacion,InternalID,RolID,strTitulo,strsubTitulo,
		strEnlace = ISNULL(strEnlace, '#'),
		Nivel = 1, strIcono,intOrden,
		datFechaAlta,datFechaInicia,datFechaVigencia 
	FROM tbNotificaciones 
	WHERE CONVERT(DATETIME, (CONVERT(VARCHAR(10), GETDATE(), 103)), 103) BETWEEN datFechaInicia AND datFechaVigencia 
		AND InternalID = @InternalID

	IF (SELECT COUNT (*) FROM #Notificaciones)=0
	BEGIN
		SELECT Total = 0, intNotificacion=0, InternalID=0, RolID=0, strTitulo = '', strsubTitulo = '', strEnlace = '#', Nivel=1, strIcono = '', intOrden=1, datFechaAlta=GETDATE(), datFechaVigencia=GETDATE()

	END

	SELECT 
		Total=(SELECT COUNT (*) FROM #Notificaciones),
		intNotificacion,InternalID,RolID,strTitulo,strsubTitulo,strEnlace,Nivel, strIcono,intOrden,datFechaAlta,datFechaInicia,datFechaVigencia
	FROM #Notificaciones
	ORDER BY intOrden
END
go


--[qry_Notificaciones_SEL] 1
go





go
--qry_getUsuario_Sel 1
alter PROCEDURE qry_getUsuario_Sel
@intUsuarioID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		intUsuarioID = EMP.intUsuario, strUsuario, strNombres = EMP.strNombre, strApPaterno = EMP.strApPaterno, strApMaterno = EMP.strApMaterno, strContrasena = EMP.strPassword, strContrasena2 = EMP.strPassword,
		EMP.intRol,
		strNombreRol = ROL.strNombre,
		EMP.IsActivo,EMP.IsBorrado,EMP.strUsuarioAlta,EMP.strMaquinaAlta,EMP.datFechaAlta
	FROM segUsuarios AS EMP WITH(NOLOCK)
		JOIN tbRoles AS ROL WITH(NOLOCK) ON ROL.intRol = EMP.intRol
	WHERE EMP.IsBorrado <> 1
		AND EMP.intUsuario = @intUsuarioID
END
go



--qry_getUsuario_Sel 5
go


go
--qry_Usuario_Upd 5, 'jorgedlberto','oviedo', 'cerda', 27, 1, 1, 'MR-JOC'
alter PROCEDURE qry_Usuario_Upd	
	@intUsuarioID		INT,
	@strUsuario			NVARCHAR(200), 
	@strNombres			NVARCHAR(200), 
	@strApPaterno		NVARCHAR(200), 
	@strApMaterno		NVARCHAR(200), 
	@strPassword		NVARCHAR(200), 
	@intRol				INT,
	@IsActivo			BIT,
	@strUsuarioGuarda	NVARCHAR(200)

AS
BEGIN
	DECLARE @ID INT 

	UPDATE segUsuarios 
	SET 
		strUsuario			= UPPER(@strUsuario),
		strNombreUsuario	= UPPER(@strNombres+' '+@strApPaterno+' '+@strApMaterno),
		strPassword			= @strPassword,
		intRol				= @intRol,
		isActivo			= @IsActivo,
		strNombre			= UPPER(@strNombres),
		strApPaterno		= UPPER(@strApPaterno),
		strApMaterno		= UPPER(@strApMaterno),
		strUsuarioMod		= @strUsuarioGuarda,
		strMaquinaMod		= @strUsuarioGuarda,
		datFechaMod			= GETDATE()
	WHERE intUsuario = @intUsuarioID

	SELECT @intUsuarioID AS Id, 'Datos actualizados, Clave: '+@strUsuario+'.' AS Mensaje;

END
go



--qry_Usuario_Upd	 @intUsuarioID = 5, @strUsuario = 'ZZZ', @strNombres = 'a1', @strApPaterno = 'a2', @strApMaterno = 'a3', @strPassword = 'newpass', @intRol = 2, @IsActivo = 1, @strUsuarioGuarda = 'MR-JOC'
go



go
--qry_Usuario_Del 17, 'MR-JOC'
alter PROCEDURE qry_Usuario_Del
	@intUsuarioID	INT,
	@strUsuario		NVARCHAR(50)
AS
BEGIN
	DECLARE @ID INT 

	SET NOCOUNT ON;
	UPDATE segUsuarios 
	SET IsActivo = 0, 
		IsBorrado = 1 , 
		strUsuarioMod = @strUsuario, 
		strMaquinaMod = @strUsuario,
		datFechaMod =  GETDATE()
	WHERE intUsuario = @intUsuarioID;

	select @intUsuarioID as Id;
END
go


select * from segUsuarios
go







