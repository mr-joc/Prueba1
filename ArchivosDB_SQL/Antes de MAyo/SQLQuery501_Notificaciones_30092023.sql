USE AllCeramic2024
go

 

CREATE TABLE [dbo].[tbNotificaciones](
	[intNotificacion] [int] IDENTITY(1,1) NOT NULL,
	[InternalID] [int] NOT NULL,
	[RolID] [int] NOT NULL,
	[strTitulo] [nvarchar](100) NULL,
	[strsubTitulo] [nvarchar](1000) NULL,
	[strEnlace] [nvarchar](100) NULL,
	[strIcono] [nvarchar](100) NULL,
	[intOrden] [int] NULL,
	[datFechaAlta] [datetime] NULL,
	[datFechaInicia] [date] NULL,
	[datFechaVigencia] [date] NULL,
 CONSTRAINT [Unique_tbNotificaciones] UNIQUE NONCLUSTERED 
(
	[InternalID] ASC,
	[RolID] ASC,
	[strTitulo] ASC,
	[strsubTitulo] ASC,
	[datFechaInicia] ASC,
	[datFechaVigencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



go
--[qry_Notificaciones_SEL] 1
CREATE PROCEDURE [dbo].[qry_Notificaciones_SEL]
@InternalID NVARCHAR(100)
AS
BEGIN
	DECLARE @RolID INT, @DCDUserID NVARCHAR(50)

	SELECT TOP 1 @RolID = IDRol,
			@DCDUserID = DCDUserID
	FROM ERPWeb.dbo.TbUsuario 
	WHERE IDUsuario = @InternalID

	
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

INSERT tbNotificaciones([InternalID], [RolID], [strTitulo], [strsubTitulo], [strEnlace], [strIcono], [intOrden], [datFechaAlta], [datFechaInicia], [datFechaVigencia] )
select [InternalID]=1, [RolID]=0, [strTitulo], [strsubTitulo], [strEnlace], [strIcono], [intOrden], [datFechaAlta], [datFechaInicia], [datFechaVigencia]  from EpicorProdWeb.dbo.tbNotificaciones WHERE InternalID = 28   
