USE AllCeramic2024
go


--qry_Usuario_Sel 0
alter PROCEDURE [dbo].[qry_Usuario_Sel]
@intUsuarioID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT
		intUsuarioID = EMP.intUsuario, 
		EMP.strNombreUsuario,
		strUsuario, strNombres = EMP.strNombre, strApPaterno = EMP.strApPaterno, strApMaterno = EMP.strApMaterno, intNumUsuario = EMP.intUsuario,
		EMP.intRol,
		strRol = ROL.strNombre,
		EMP.IsActivo,EMP.IsBorrado,
		EMP.strUsuarioAlta,EMP.strMaquinaAlta,EMP.datFechaAlta,EMP.strUsuarioMod,EMP.strMaquinaMod,EMP.datFechaMod
		FROM segUsuarios AS EMP WITH(NOLOCK)
			JOIN tbRoles AS ROL WITH(NOLOCK) ON ROL.intRol = EMP.intRol
	WHERE EMP.IsBorrado <> 1
		AND (EMP.intUsuario = @intUsuarioID OR @intUsuarioID = 0)
END
