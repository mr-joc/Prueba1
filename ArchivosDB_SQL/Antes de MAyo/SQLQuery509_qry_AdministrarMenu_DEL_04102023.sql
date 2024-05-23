USE AllCeramic2024
go



go
alter PROCEDURE qry_AdministrarMenu_DEL
@intMenuElimina	INT,
@DesgloseMenu	NVARCHAR(100),
@intPerfil		INT,
@strUsuario		NVARCHAR(150)
AS
BEGIN
	 DECLARE @ID INT, @Posicion2 INT, @idMenu VARCHAR(150), @NivelPerteneceMenu INT, @MenuSuperior4 INT, @Nodos3 INT, @MenuSuperior3 INT, @Nodos2 INT, @MenuSuperior2 INT, @Nodos1 INT--, @Nodos3 INT, @Nodos4 INT 
	DECLARE @tbMenu TABLE (idNivel INT IDENTITY(1, 1), intMenu NVARCHAR(20), intMenuSolicitado INT, btCoincide BIT, intMenuSuperior INT)

	CREATE TABLE #tbMenuBase(intMenuReal INT, intMenu1 INT, intMenu2 INT, intMenu3 INT, intMenu4 INT, 
				strDesgloseMenu NVARCHAR(200), strDescripcion1 NVARCHAR(200), strDescripcion2 NVARCHAR(200), strDescripcion3 NVARCHAR(200), strDescripcion4 NVARCHAR(200), strDescripcion5 NVARCHAR(200), 
				RowID1 INT, RowID2 INT, RowID3 INT, RowID4 INT, isActivo INT, intPerfil INT)

	INSERT #tbMenuBase(intMenuReal, intMenu1, intMenu2, intMenu3, intMenu4, 
				strDesgloseMenu, strDescripcion1, strDescripcion2, strDescripcion3, strDescripcion4 , strDescripcion5, 
				RowID1, RowID2, RowID3, RowID4, isActivo, intPerfil)
	EXEC qry_AdministrarMenu_SEL @internalID = 0, @intPerfil = 0

	--SELECT '#tbMenuBase',* FROM #tbMenuBase

	SELECT @DesgloseMenu = strDesgloseMenu FROM #tbMenuBase WHERE intMenuReal = @intMenuElimina
	--SELECT '@DesgloseMenu'=@DesgloseMenu

	SET @DesgloseMenu = @DesgloseMenu + '~'
	WHILE patindex('%~%' , @DesgloseMenu) <> 0
	BEGIN
		SELECT @Posicion2 =  patindex('%~%' , @DesgloseMenu)
		SELECT @idMenu = left(@DesgloseMenu, @Posicion2 - 1)
		IF NOT EXISTS (SELECT intMenu FROM @tbMenu WHERE intMenu = @idMenu)
		BEGIN 
			INSERT @tbMenu (intMenu, intMenuSolicitado, btCoincide, intMenuSuperior)
			SELECT
				intMenu = @idMenu, 
				intMenuSolicitado = @intMenuElimina, 
				btCoincide = (CASE WHEN @idMenu = @intMenuElimina THEN 1 ELSE 0 END),
				intMenuSuperior = 0
				WHERE @idMenu <> 0 
		END

		SELECT @DesgloseMenu = stuff(@DesgloseMenu, 1, @Posicion2, '')
	END

	SELECT @NivelPerteneceMenu = idNivel
	FROM @tbMenu
	WHERE btCoincide = 1

	UPDATE M  
	SET M.intMenuSuperior = ISNULL((SELECT A.intMEnu 
							FROM @tbMenu AS A
							WHERE A.idNivel =  (M.idNivel -1) ), 0)
	FROM @tbMenu AS M


	--SELECT *,'@NivelPerteneceMenu'=@NivelPerteneceMenu FROM @tbMenu

	DELETE FROM tbMenuDtl WHERE intRol = @intPerfil AND intMenu = @intMenuElimina
	
	--CUANDO EL NIVEL DEL MENÚ ES 4, REVISAMOS QUE NO QUEDE PENDIENTE NADA EN LOS NIVELES SUPERIORES (DE UN NÚMERO MENOR)
	IF @NivelPerteneceMenu = 4
	BEGIN
		PRINT 'ENTRAMOS A LA LÓGICA DEL NIVEL 4'
		SELECT @MenuSuperior4 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 4

		SELECT @Nodos3 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior4 AND intRol = @intPerfil

		IF @Nodos3 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior4 AND intRol = @intPerfil
		END
		
		SELECT @MenuSuperior3 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 3

		SELECT @Nodos2 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior3 AND intRol = @intPerfil

		IF @Nodos2 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior3 AND intRol = @intPerfil
		END

		
		SELECT @MenuSuperior2 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 2
		--SELECT '@MenuSuperior2' = @MenuSuperior2
		
		SELECT @Nodos1 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior2 AND intRol = @intPerfil
		--SELECT '@Nodos1' =  @Nodos1

		IF @Nodos1 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior2 AND intRol = @intPerfil
		END
	END
	
	--CUANDO EL NIVEL DEL MENÚ ES 3, REVISAMOS QUE NO QUEDE PENDIENTE NADA EN LOS NIVELES SUPERIORES (DE UN NÚMERO MENOR)
	IF @NivelPerteneceMenu = 3
	BEGIN
		PRINT 'ENTRAMOS A LA LÓGICA DEL NIVEL 3'
		SELECT @MenuSuperior3 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 3

		SELECT @Nodos2 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior3 AND intRol = @intPerfil

		IF @Nodos2 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior3 AND intRol = @intPerfil
		END

		
		SELECT @MenuSuperior2 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 2
		--SELECT '@MenuSuperior2' = @MenuSuperior2
		
		SELECT @Nodos1 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior2 AND intRol = @intPerfil
		--SELECT '@Nodos1' =  @Nodos1

		IF @Nodos1 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior2 AND intRol = @intPerfil
		END
	END
	
	--CUANDO EL NIVEL DEL MENÚ ES 2, REVISAMOS QUE NO QUEDE PENDIENTE NADA EN LOS NIVELES SUPERIORES (DE UN NÚMERO MENOR)
	IF @NivelPerteneceMenu = 2
	BEGIN
		PRINT 'ENTRAMOS A LA LÓGICA DEL NIVEL 2'

		
		SELECT @MenuSuperior2 = MM.intMenuSuperior 
		FROM @tbMenu AS MM
		WHERE MM.idNivel = 2
		--SELECT '@MenuSuperior2' = @MenuSuperior2
		
		SELECT @Nodos1 =COUNT(intMenu) FROM tbMenuDtl WHERE subMenu = @MenuSuperior2 AND intRol = @intPerfil
		--SELECT '@Nodos1' =  @Nodos1

		IF @Nodos1 = 0
		BEGIN
			PRINT 'NO HAY NADA'
			DELETE FROM tbMenuDtl WHERE intMenu = @MenuSuperior2 AND intRol = @intPerfil
		END
	END
	select @intMenuElimina as Id;
END
go


--select * from tbroles

qry_AdministrarMenu_DEL @intMenuElimina = 7, @DesgloseMenu	='XXX', @intPerfil	= 5, @strUsuario = 'MR-JOC'
go


--qry_AdministrarMenu_SEL @internalID = 0, @intPerfil = 0
go
--qry_agregaPermisoPerfil_APP


