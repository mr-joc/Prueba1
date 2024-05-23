USE AllCeramic2024
go

go
--qry_limpiarPermisosEspeciales_XUsuario_DEL @intUsuario = 6, @strUsuario = 'mr-joc'
alter PROCEDURE qry_limpiarPermisosEspeciales_XUsuario_DEL 
@intUsuario			INT,
@strUsuario			NVARCHAR(150)
AS
BEGIN
	
	DELETE tbMenuXUsuario  WHERE InternalIDUser = @intUsuario	


	SELECT @intUsuario as Id;
END
go

--qry_limpiarPermisosEspeciales_XUsuario_DEL @intUsuario = 6, @strUsuario = 'mr-joc'
go


 	 
select * from tbMenuXUsuario  WHERE InternalIDUser = 6
go