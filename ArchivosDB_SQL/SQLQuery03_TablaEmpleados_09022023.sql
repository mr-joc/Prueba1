USE Dev1
go


IF EXISTS(SELECT * FROM sysobjects WHERE type = 'U' AND name ='tbEmpleados')
BEGIN
   DROP TABLE tbEmpleados;
END

CREATE TABLE [dbo].[tbEmpleados](
	[intEmpleadoID] [int] IDENTITY(1,1) NOT NULL,
	[strNombres] [varchar](200) NULL,
	[strApPaterno] [varchar](200) NULL,
	[strApMaterno] [varchar](200) NULL,
	[intNumEmpleado] [int] NULL,
	[intRol] [int] NULL,
	[IsActivo] [bit] NULL,
	[IsBorrado] [int] NULL,
	[strUsuarioAlta] [varchar](200) NULL,
	[strMaquinaAlta] [varchar](200) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](200) NULL,
	[strMaquinaMod] [varchar](200) NULL,
	[datFechaMod] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[intEmpleadoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbEmpleados] ADD  DEFAULT ((1)) FOR [IsActivo]
GO

ALTER TABLE [dbo].[tbEmpleados] ADD  DEFAULT ((0)) FOR [IsBorrado]
GO


--Crear una restriccion UNIQUE
alter table [tbEmpleados] add CONSTRAINT Unique_tbEmpleados UNIQUE ([intNumEmpleado])


SELECT * FROM tbEmpleados

