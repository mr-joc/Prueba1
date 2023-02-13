--CREATE DATABASE Dev1
go


USE Dev1
GO


CREATE TABLE [dbo].[tbRol](
	[intRol] [int] NOT NULL,
	[strNombre] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[intRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




CREATE TABLE [dbo].[tbRolPago](
	[Id_Num_RolPago] [int] NOT NULL,
	[Id_Num_Rol] [int] NULL,
	[SueldoBase] [decimal](10, 2) NULL,
	[PagoPorEntrega] [decimal](10, 2) NULL,
	[BonoHora] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Num_RolPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Rol_Pago]  WITH CHECK ADD  CONSTRAINT [FK_Rol_Pago_Rol] FOREIGN KEY([Id_Num_Rol])
REFERENCES [dbo].[Rol] ([Id_Num_Rol])
GO

ALTER TABLE [dbo].[Rol_Pago] CHECK CONSTRAINT [FK_Rol_Pago_Rol]
GO







CREATE TABLE [dbo].[tbMovimiento](
	[intEmpleado] [int] NOT NULL,
	[intMes] [int] NOT NULL,
	[intHorasTrabajadas] [int] NULL,
	[intEntregasRealizadas] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[intEmpleado] ASC,
	[intMes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_Empleado] FOREIGN KEY([Id_Num_Empleado])
REFERENCES [dbo].[Empleado] ([Id_Num_Empleado])
GO

ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_Empleado]
GO

ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_Mes] FOREIGN KEY([Id_Num_Mes])
REFERENCES [dbo].[Mes] ([Id_Num_Mes])
GO

ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_Mes]
GO





CREATE TABLE [dbo].[tbMes](
	[intMes] [int] NOT NULL,
	[strNombre] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[intMes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO





CREATE TABLE [dbo].[tbEmpleado](
	[intEmpleado] [int] NOT NULL,
	[strNombre] [varchar](100) NULL,
	[strNumeroEmpleado] [varchar](50) NULL,
	[intRol] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[intEmpleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Rol] FOREIGN KEY([Id_Num_Rol])
REFERENCES [dbo].[Rol] ([Id_Num_Rol])
GO

ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_Rol]
GO

