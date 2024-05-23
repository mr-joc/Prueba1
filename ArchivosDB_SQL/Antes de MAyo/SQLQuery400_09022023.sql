USE [PruebaDev]
GO

/****** Object:  StoredProcedure [dbo].[CalculoSueldoMensualEmpleado]    Script Date: 08/02/2023 11:45:13 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CalculoSueldoMensualEmpleado]
AS
BEGIN
	CREATE TABLE #Datos
	(
		Id_Num_Empleado		INT,
		Nombre              VARCHAR(100),
		NumeroEmpleado      VARCHAR(50),
		Id_Num_Rol          INT,
		NombreRol			VARCHAR(20),
		Id_Num_Mes			INT,
		NombreMes			VARCHAR(20),
		Horas_Trabajadas	INT,
		Cant_Entrega		INT,
		PagoPorEntrega		DECIMAL(10,2),
		PagoBonos			DECIMAL(10,2),
		Retenciones			DECIMAL(10,2),
		Vales				DECIMAL(10,2),
		SueldoBase			DECIMAL(10,2),
		ISR					DECIMAL(4,2)
	)

    DECLARE
            @TranCount                 INT,
            @ErrorNum                  INT,
            @ErrorMensaje       VARCHAR(100),
            @id_Num_Empleado    INT

    SELECT @TranCount = @@TRANCOUNT
    IF @TranCount = 0
            BEGIN TRAN

	INSERT INTO #Datos
	(
		Id_Num_Empleado,
		Nombre,
		NumeroEmpleado,
		Id_Num_Rol,
		NombreRol,
		Id_Num_Mes,
		NombreMes,
		Horas_Trabajadas,
		Cant_Entrega,
		SueldoBase,
		PagoPorEntrega,
		PagoBonos,
		Retenciones,
		Vales,
		ISR
	)
    SELECT
            a.Id_Num_Empleado,
            a.Nombre AS NombreEmpleado,
            NumeroEmpleado,
			b.Id_Num_Rol,
            b.Nombre AS NombreRol,
			d.Id_Num_Mes,
            d.Nombre AS   Mes,
            Horas_Trabajadas,
			Cant_Entrega,
			Horas_Trabajadas * SueldoBase AS SueldoBase,
            Cant_Entrega * PagoPorEntrega AS PagoPorEntrega,
            Horas_Trabajadas * BonoHora AS PagoBonos,
            0 AS Retenciones,
            0 AS Vales,
			0
    FROM
            Movimiento c
            JOIN Empleado a
                ON     a.Id_Num_Empleado = c.Id_Num_Empleado
            JOIN Rol b
                ON     a.Id_Num_Rol =      b.Id_Num_Rol
            JOIN Mes d
                ON     d.Id_Num_Mes =      c.Id_Num_Mes
            JOIN Rol_Pago e
                ON     e.Id_Num_Rol =      b.Id_Num_Rol
 
	IF @@ERROR <>0
    BEGIN
            SELECT @ErrorMensaje = 'Error al insertar los #Datos'
            GOTO ERROR
    END

	UPDATE #Datos
		SET	Retenciones = 
				CASE 
					WHEN SueldoBase + PagoPorEntrega + PagoBonos < 10000.00 -- SI LA SUMA DEL SUELDO ES MENOR A DIEZ MIL 
					THEN (SueldoBase + PagoPorEntrega + PagoBonos) * 0.09	-- SE LES DESCUENTA EL 9% de ISR, SI ES MAYOR EL 12%
					ELSE (SueldoBase + PagoPorEntrega + PagoBonos) * 0.12
					END,
			ISR			=
				CASE 
					WHEN SueldoBase + PagoPorEntrega + PagoBonos < 10000.00 -- SI LA SUMA DEL SUELDO ES MENOR A DIEZ MIL 
					THEN 9													-- SE LES DESCUENTA EL 9% de ISR, SI ES MAYOR EL 12%
					ELSE 12
					END

	IF @@ERROR <>0
    BEGIN
            SELECT @ErrorMensaje = 'Error al calcular las retenciones'
            GOTO ERROR
    END

	UPDATE #Datos
		SET	Vales = 
					((SueldoBase + PagoPorEntrega + PagoBonos) - Retenciones) * 0.04

	IF @@ERROR <>0
    BEGIN
			SELECT @ErrorMensaje = 'Error al calcular los vales'
			GOTO ERROR
    END

	SELECT
		*,
		(SueldoBase + PagoPorEntrega + PagoBonos) - Retenciones AS SueldoTotal
	FROM
		#Datos

    GOTO FIN

    ERROR:
            IF @TranCount = 0 AND @@TRANCOUNT <> 0
            BEGIN
                ROLLBACK TRAN
            END
            RAISERROR(@ErrorMensaje,1,10)
            RETURN 1
    FIN:
            IF @TranCount = 0 AND @@TRANCOUNT <> 0
            BEGIN
                COMMIT TRAN
            END
            RETURN 0
END
GO

