USE AllCeramic2024
go



go
--qry_Doctor_Sel 0
alter PROCEDURE qry_Doctor_Sel
	 @intDoctor INT
	,@intActivo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET @intActivo = ISNULL(@intActivo, 0)

	IF @intActivo = 1
	BEGIN
		SELECT
			DR.intDoctor, DR.strNombre, DR.strApPaterno, DR.strApMaterno, strNombreCompleto = DR.strNombre+' '+DR.strApPaterno+' '+DR.strApMaterno, 
			DR.strDireccion, DR.strEMail, DR.strColonia,
			DR.strRFC, DR.strNombreFiscal, DR.intCP, DR.strTelefono, DR.strCelular, DR.strDireccionFiscal, 	
			DR.isActivo, DR.IsBorrado, 
			DR.strUsuarioAlta, DR.strMaquinaAlta, DR.datFechaAlta, DR.strUsuarioMod, DR.strMaquinaMod, DR.datFechaMod
		FROM  tbDoctor AS DR WITH(NOLOCK)
		WHERE DR.IsBorrado <> 1
			AND (DR.intDoctor = @intDoctor OR @intDoctor = 0)
			AND (DR.isActivo = @intActivo OR @intActivo = 0)
		ORDER BY DR.strNombre+' '+DR.strApPaterno+' '+DR.strApMaterno
	END
	ELSE
	BEGIN
		SELECT
			DR.intDoctor, DR.strNombre, DR.strApPaterno, DR.strApMaterno, strNombreCompleto = DR.strNombre+' '+DR.strApPaterno+' '+DR.strApMaterno, 
			DR.strDireccion, DR.strEMail, DR.strColonia,
			DR.strRFC, DR.strNombreFiscal, DR.intCP, DR.strTelefono, DR.strCelular, DR.strDireccionFiscal, 	
			DR.isActivo, DR.IsBorrado, 
			DR.strUsuarioAlta, DR.strMaquinaAlta, DR.datFechaAlta, DR.strUsuarioMod, DR.strMaquinaMod, DR.datFechaMod
		FROM  tbDoctor AS DR WITH(NOLOCK)
		WHERE DR.IsBorrado <> 1
			AND (DR.intDoctor = @intDoctor OR @intDoctor = 0)
			AND (DR.isActivo = @intActivo OR @intActivo = 0)
		ORDER BY DR.intDoctor
	END
END
go


qry_Doctor_Sel @intDoctor = 0, @intActivo = 1
go



