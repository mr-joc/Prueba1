USE Dev1
go



IF EXISTS(SELECT * FROM sysobjects WHERE type = 'U' AND name ='tbMovimientos')
BEGIN
   DROP TABLE tbMovimientos;
END


CREATE TABLE [dbo].[tbMovimientos](
	[intMovimiento] [int] IDENTITY(1,1) NOT NULL,
	[intEmpleadoID] [int] NOT NULL,
	[intNumEmpleado] [int] NOT NULL,
	[intMes] [int] NOT NULL,
	[intCantidadEntregas] [int] NOT NULL,
	[IsBorrado] BIT NOT NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbMovimientos] UNIQUE NONCLUSTERED 
(
	[intMovimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



--Crear una restriccion UNIQUE
alter table tbMovimientos add CONSTRAINT Unique_Empleado_mes UNIQUE ([intEmpleadoID], [intNumEmpleado], [intMes])

SELECT * FROM tbMovimientos
go
