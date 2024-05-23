USE [LabAllCeramic]
GO

/*
--DROP TABLE tbUsuariosXOperacion
CREATE TABLE [dbo].[tbUsuariosXOperacion](
	[intUsuarioXOperacion] [int] IDENTITY(1,1) NOT NULL,
	[intUsuario] [int] NOT NULL,
	[strUsuario] [nvarchar](200) NULL,
	[intOperacion] [int] NOT NULL,
	[strOperacion] [nvarchar](3000) NULL,
	[strUsuarioAlta] [varchar](150) NULL,
	[strMaquinaAlta] [varchar](150) NULL,
	[datFechaAlta] [datetime] NULL,
	[strUsuarioMod] [varchar](150) NULL,
	[strMaquinaMod] [varchar](150) NULL,
	[datFechaMod] [datetime] NULL,
 CONSTRAINT [Unique_tbUsuariosXOperacion] UNIQUE NONCLUSTERED 
(
	[intUsuarioXOperacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
*/


SELECT * FROM segUsuarios2024
SELECT * FROM tbOperacion

--INSERT tbUsuariosXOperacion(intUsuario,strUsuario,intOperacion,strOperacion,strUsuarioAlta,strMaquinaAlta,datFechaAlta)
SELECT U.intUsuario, U.strUsuario, O.intOperacion, O.strNombre,  O.strUsuarioAlta, O.strMaquinaAlta, datFechaAlta = GETDATE()
FROM segUsuarios2024 AS U, tbOperacion AS O
WHERE U.strUsuario = 'MR-JOC'

SELECT * FROM tbUsuariosXOperacion

--


