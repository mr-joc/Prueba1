USE Dev1
go

--select * from tbmovimientos

IF EXISTS(SELECT * FROM sysobjects WHERE type = 'U' AND name ='tbJornadasLaborales')
BEGIN
   DROP TABLE tbJornadasLaborales;
END
--select * from tbEmpleados

CREATE TABLE [dbo].[tbJornadasLaborales](
	[intJornadaLaboral] [int] IDENTITY(1,1) NOT NULL,
	[intEmpleadoID] [int]  NOT NULL,
	[intMes] [int]  NOT NULL,
	[intSemana] [int]  NOT NULL,
	[intDiasLaborados] [int]  NOT NULL,
	[IsBorrado] [bit] NULL,
	[strUsuarioAlta] [nvarchar](512) NULL,
	[strMaquinaAlta] [nvarchar](512) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [nvarchar](512) NULL,
	[strMaquinaMod] [nvarchar](512) NULL,
	[datFechaMod] [datetime] NULL
) ON [PRIMARY]
GO

--Agregar una llave primaria
alter TABLE tbJornadasLaborales add CONSTRAINT [PK_tbJornadasLaborales] PRIMARY KEY CLUSTERED 
(
	[intJornadaLaboral] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]

--Agregar un DEFFAULT
ALTER TABLE [dbo].[tbJornadasLaborales] ADD  DEFAULT ((0)) FOR [IsBorrado]
GO

--Crear una restriccion UNIQUE
alter table tbJornadasLaborales add CONSTRAINT Unique_tbJornadasLaborales UNIQUE ([intEmpleadoID], [intMes], [intSemana])


INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 1, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 1, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 1, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 1, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 2, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 2, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 2, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 2, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 3, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 3, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 3, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 3, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 4, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 4, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 4, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 4, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()


INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 1, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 1, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 1, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 1, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 2, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 2, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 2, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 2, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 3, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 3, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 3, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 3, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 4, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 4, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 4, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 4, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()


INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 1, 1, 5, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 1, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 1, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 1, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 2, 1, 5, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 2, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 2, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 2, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 3, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 3, 2, 5, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 3, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 3, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 4, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 4, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 4, 3, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 4, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()


INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 1, 1, 5, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 1, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 1, 3, 5, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 1, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 2, 1, 4, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 2, 2, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 2, 3, 5, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 2, 4, 4, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 3, 1, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 3, 2, 5, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 3, 3, 4, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 3, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 4, 1, 5, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 4, 2, 4, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 4, 3, 4, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbJornadasLaborales(intEmpleadoID,intMes,intSemana,intDiasLaborados,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 4, 4, 6, 0, 'MR-JOC', 'MR-JOC', GETDATE()


SELECT * FROM tbJornadasLaborales