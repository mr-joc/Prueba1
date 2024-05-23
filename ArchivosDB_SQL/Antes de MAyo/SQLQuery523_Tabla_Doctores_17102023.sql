USE AllCeramic2024
go

--DROP TABLE tbDoctor

--CREATE TABLE [dbo].[tbDoctor](
--	[intDoctor] [int] NOT NULL IDENTITY(1, 1),
--	[strNombre] [varchar](500) NULL,
--	[strApPaterno] [varchar](500) NULL,
--	[strApMaterno] [varchar](500) NULL,
--	[strDireccion] [varchar](500) NULL,
--	[strEMail] [varchar](50) NULL,
--	[strColonia] [varchar](500) NULL,
--	[strRFC] [varchar](500) NULL,
--	[strNombreFiscal] [varchar](500) NULL,
--	[intCP] [int] NULL,
--	[strTelefono] [varchar](500) NULL,
--	[strCelular] [varchar](500) NULL,
--	[strDireccionFiscal] [varchar](500) NULL,
--	[isActivo] [bit] NULL,
--	[isBorrado] [bit] NULL,
--	[strUsuarioAlta] [varchar](150) NULL,
--	[strMaquinaAlta] [varchar](150) NULL,
--	[datFechaAlta] [datetime] NULL,
--	[strUsuarioMod] [varchar](150) NULL,
--	[strMaquinaMod] [varchar](150) NULL,
--	[datFechaMod] [datetime] NULL,
-- CONSTRAINT [Unique_tbDoctor] UNIQUE NONCLUSTERED 
--(
--	[intDoctor] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO


----INSERT tbDoctor(strNombre,strApPaterno,strApMaterno,strDireccion,strEMail,strColonia,strRFC,strNombreFiscal,intCP,strTelefono,strCelular,strDireccionFiscal,isActivo,isBorrado,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod)
--SELECT --intDoctor,
--	strNombre,strApPaterno,strApMaterno,strDireccion,strEMail,strColonia,strRFC,strNombreFiscal,intCP,strTelefono,strCelular,strDireccionFiscal,isActivo=intActivo,isBorrado=0,strUsuarioAlta,strMaquinaAlta,datFechaAlta,strUsuarioMod,strMaquinaMod,datFechaMod
--FROM LabAllCeramic.dbo.tbDoctor
--ORDER BY intDoctor


SELECT * FROM tbDoctor



