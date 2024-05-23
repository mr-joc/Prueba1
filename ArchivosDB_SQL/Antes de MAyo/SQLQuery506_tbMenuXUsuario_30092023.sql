USE AllCeramic2024
GO

CREATE TABLE [dbo].[tbMenuXUsuario](
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
 CONSTRAINT [Unique_tbMenuXUsuario] UNIQUE NONCLUSTERED 
(
	[InternalIDUser] ASC,
	[IDMenu] ASC,
	[IsActivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


