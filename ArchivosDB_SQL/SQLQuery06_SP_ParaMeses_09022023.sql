USE Dev1 
go

go
--qry_ListarMeses_SEL
alter  PROCEDURE [dbo].[qry_ListarMeses_SEL]  
AS   
BEGIN
	SET NOCOUNT ON;

	DECLARE @tbMes AS TABLE(intMes INT, strNombreMes NVARCHAR(25))

	INSERT INTO @tbMes(intMes, strNombreMes)
	VALUES	( 1, 'ENERO'),
			( 2, 'FEBRERO'),
			( 3, 'MARZO'),
			( 4, 'ABRIL'),
			( 5, 'MAYO'),
			( 6, 'JUNIO'),
			( 7, 'JULIO'),
			( 8, 'AGOSTO'),
			( 9, 'SEPTIEMBRE'),
			(10, 'OCTUBRE'),
			(11, 'NOVIEMBRE'),
			(12, 'DICIEMBRE')

	SELECT intMes, strNombreMes FROM @tbMes
END
go

qry_ListarMeses_SEL
go
