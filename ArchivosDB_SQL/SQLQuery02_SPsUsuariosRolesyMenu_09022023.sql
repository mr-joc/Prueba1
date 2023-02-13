USE Dev1
go


 


go
--qry_ValidarPasword 'mr-joc', 'c4l4b4z4'
alter PROCEDURE qry_ValidarPasword
@strUsuario NVARCHAR(100),
@strPassword NVARCHAR(100)
AS
BEGIN
	PRINT 'Revisamos que exista y que esté ACTIVO'
	IF EXISTS(SELECT * FROM segUsuarios WHERE strUsuario = @strUsuario AND strPassword = @strPassword AND isActivo = 1)
	BEGIN
		PRINT 'EL CÓDIGO SI EXISTE, por lo tanto devolvemos sus credenciales'

		SELECT intUsuario, Usuario = strUsuario, Pass = strPassword, isActivo
		FROM segUsuarios WITH(NOLOCK)
		WHERE strUsuario = @strUsuario AND strPassword = @strPassword
			 AND isActivo = 1
	END

END
go


qry_ValidarPasword 'mr-joc', 'c4l4b4z4'
go


go
alter PROCEDURE [dbo].[qry_infoUsuario_SEL]
	(@strUsuario nVarchar(50))
AS
BEGIN
	SELECT  
			S.intUsuario			AS intUsuario,
			S.strUsuario			AS strUsuario,
			S.strNombreUsuario		AS strNomUsuario, 
			S.intRol				AS intRol,
			R.strNombre				AS strNombreRol
	FROM segUsuarios AS S WITH(NOLOCK)
		JOIN tbRoles AS R WITH(NOLOCK) ON S.introl = R.intRol
	WHERE S.strUsuario = @strUsuario

END
go



qry_infoUsuario_SEL 'mr-joc' 
go


go
--sp_GetMenuByRol 1
CREATE PROCEDURE [dbo].[sp_GetMenuByRol]
	@IDRol int
AS
BEGIN
	SELECT M.intMenu		AS [IDMenu]
		,M.strDescripcion	AS [Descripcion]
		,M.Parametro		AS [Parametro]
		,M.Vista			AS [ViewVista]
		,M.Controlador		AS [Controller]
		,D.intRol			AS [IDRol]
		,D.subMenu			AS [subMenu]
		,M.Nivel			AS [Nivel]
		,M.IsNodo			AS [IsNode]
		,D.intOrden			AS [orden]
		,M.strIcono			AS [Icon]
	FROM tbMenu					As M WITH(NOLOCK)
		JOIN tbMenuDtl			As D WITH(NOLOCK) ON D.intMenu = M.intMenu
	WHERE D.intRol = @IDRol
		AND IsActivo = 1

	ORDER BY subMenu, orden ASC
END
go

sp_GetMenuByRol 1
go

