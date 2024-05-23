use AllCeramic2024
GO

--ALTER TABLE segUsuarios ADD strNombre NVARCHAR(150)
--ALTER TABLE segUsuarios ADD strApPaterno NVARCHAR(150)
--ALTER TABLE segUsuarios ADD strApMaterno NVARCHAR(150)
--ALTER TABLE segUsuarios DROP COLUMN IsBorrado  
--ALTER TABLE segUsuarios ADD IsBorrado INT DEFAULT(0)
--UPDATE segUsuarios SET IsBorrado = 0

--UPDATE segUsuarios SET strNombre = 'JORGE ALBERTO', strApPaterno = 'OVIEDO',	strApMAterno = 'CERDA'	WHERE intUsuario = 1
--UPDATE segUsuarios SET strNombre = 'JANETH',		strApPaterno = 'CASIANO',	strApMAterno = '.'		WHERE intUsuario = 2

SELECT * FROM segUsuarios

SELECT * FROM tbEmpleados

select * from tbRoles

 sp_help 'tbEmpleados'