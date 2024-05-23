USE LabAllCeramic
go

--DROP TABLE segUsuarios2024

--
CREATE TABLE [dbo].[segUsuarios2024](
	[intUsuario] [int] IDENTITY(1,1) NOT NULL,
	[strUsuario] [nvarchar](100) NOT NULL,
	[strNombreUsuario] [nvarchar](100) NOT NULL,
	[strPassword] [nvarchar](512) NOT NULL,
	[intRol] [int] NOT NULL,
	[isActivo] [bit] NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL,
	[strNombre] [nvarchar](150) NULL,
	[strApPaterno] [nvarchar](150) NULL,
	[strApMaterno] [nvarchar](150) NULL,
	[IsBorrado] [int] NULL,
 CONSTRAINT [Unique_segUsuarios2024] UNIQUE NONCLUSTERED 
(
	[strUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[segUsuarios2024] ADD  DEFAULT ((0)) FOR [isActivo]
GO

ALTER TABLE [dbo].[segUsuarios2024] ADD  DEFAULT ((0)) FOR [IsBorrado]
GO

 
 --drop table [tbMenu2024]

CREATE TABLE [dbo].[tbMenu2024](
	[intMenu] [int] IDENTITY(1,1) NOT NULL,
	[strDescripcion] [varchar](80) NULL,
	[Vista] [varchar](50) NULL,
	[Controlador] [varchar](50) NULL,
	[Parametro] [varchar](150) NULL,
	[Nivel] [int] NULL,
	[IsNodo] [bit] NULL,
	[strIcono] [varchar](50) NULL,
	[IsActivo] [bit] NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL 
) ON [PRIMARY]
GO

 

--DROP TABLE [tbMenuDtl2024]

CREATE TABLE [dbo].[tbMenuDtl2024](
	[intMenuDtl] [int] IDENTITY(1,1) NOT NULL,
	[intMenu] [int] NULL,
	[intRol] [int] NULL,
	[subMenu] [int] NULL,
	[intOrden] [int] NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbMenuDtl2024] UNIQUE NONCLUSTERED 
(
	[intMenu] ASC
	,[intRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


 
CREATE TABLE [dbo].[tbMenuXUsuario2024](
	[IDMenuXUsuario] [int] IDENTITY(1,1) NOT NULL,
	[InternalIDUser] [int] NOT NULL,
	[IDMenu] [int] NOT NULL,
	[IsActivo] [bit] NULL,
	[btAgregar] [bit] NOT NULL,
	[btRestringir]  AS (case when [btAgregar]=(1) then (0) else (1) end),
	[strUsuarioAlta] [nvarchar](150) NULL,
	[strMaquinaAlta] [nvarchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](150) NULL,
	[strMaquinaMod] [nvarchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [PK_tbMenuXUsuario] PRIMARY KEY CLUSTERED 
(
	[IDMenuXUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Unique_tbMenuXUsuario2024] UNIQUE NONCLUSTERED 
(
	[InternalIDUser] ASC,
	[IDMenu] ASC,
	[IsActivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

 

CREATE TABLE [dbo].[tbNotificaciones2024](
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
 CONSTRAINT [Unique_tbNotificaciones2024] UNIQUE NONCLUSTERED 
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


--drop table [tbRoles2024]

go
CREATE TABLE [dbo].[tbRoles2024](
	[intRol] [int] IDENTITY(1,1) NOT NULL,
	[strNombre] [nvarchar](100) NOT NULL,
	[isAdministrativo] [bit] NOT NULL,
	[isOperativo] [bit] NOT NULL,
	[isActivo] [bit] NULL,
	[IsBorrado] [bit] NOT NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbRoles2024] UNIQUE NONCLUSTERED 
(
	[intRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Unique2_tbRoles2024] UNIQUE NONCLUSTERED 
(
	[strNombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


