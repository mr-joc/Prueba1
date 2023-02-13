USE Dev1
go



IF EXISTS(SELECT * FROM sysobjects WHERE type = 'U' AND name ='tbBonoXRol')
BEGIN
   DROP TABLE tbBonoXRol;
END
--select * from tbEmpleados

CREATE TABLE [dbo].[tbBonoXRol](
	[intBonoXRol] [int] IDENTITY(1,1) NOT NULL,
	[intRol] [int]  NOT NULL,
	[dblBonoXRol] [decimal] (10, 4)  NOT NULL,
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
alter TABLE tbBonoXRol add CONSTRAINT [PK_tbBonoXRol] PRIMARY KEY CLUSTERED 
(
	[intBonoXRol] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]

--Agregar un DEFFAULT
ALTER TABLE [dbo].[tbBonoXRol] ADD  DEFAULT ((0)) FOR [IsBorrado]
GO

--Crear una restriccion UNIQUE
alter table tbBonoXRol add CONSTRAINT Unique_tbBonoXRol UNIQUE ([intRol], [intBonoXRol])


INSERT tbBonoXRol(intRol,dblBonoXRol,IsBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta) 
SELECT intRol, Cantidad = (CASE intRol 
								WHEN 1 THEN 0 
								WHEN 2 THEN 10 
								WHEN 3 THEN 5 
								WHEN 4 THEN 0 
							END), 
		0, 'MR-JOC', 'MR-JOC', GETDATE()
	--	select *   
FROM tbRoles 

 
SELECT * FROM tbBonoXRol