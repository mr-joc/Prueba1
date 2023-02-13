USE Dev1
go



IF EXISTS(SELECT * FROM sysobjects WHERE type = 'U' AND name ='tbSueldoBase')
BEGIN
   DROP TABLE tbSueldoBase;
END
--select * from tbEmpleados

CREATE TABLE [dbo].[tbSueldoBase](
	[intSueldoBase] [int] IDENTITY(1,1) NOT NULL,
	[intEmpleadoID] [int]  NOT NULL,
	[dblSueldoBase] [decimal] (10, 4)  NOT NULL,
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
alter TABLE tbSueldoBase add CONSTRAINT [PK_tbSueldoBase] PRIMARY KEY CLUSTERED 
(
	[intSueldoBase] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]

--Agregar un DEFFAULT
ALTER TABLE [dbo].[tbSueldoBase] ADD  DEFAULT ((0)) FOR [IsBorrado]
GO

--Crear una restriccion UNIQUE
alter table tbSueldoBase add CONSTRAINT Unique_tbSueldoBase UNIQUE ([intEmpleadoID], [intSueldoBase])


INSERT tbSueldoBase(intEmpleadoID,dblSueldoBase,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 1, 30, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbSueldoBase(intEmpleadoID,dblSueldoBase,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 2, 30, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbSueldoBase(intEmpleadoID,dblSueldoBase,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 3, 30, 0, 'MR-JOC', 'MR-JOC', GETDATE()
INSERT tbSueldoBase(intEmpleadoID,dblSueldoBase,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) SELECT 4, 30, 0, 'MR-JOC', 'MR-JOC', GETDATE()
 
SELECT * FROM tbSueldoBase