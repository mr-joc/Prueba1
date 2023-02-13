USE [PruebaDev]
GO

/****** Object:  StoredProcedure [dbo].[Movimientos]    Script Date: 08/02/2023 11:42:47 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Movimientos]
       @pOperacion                CHAR(1),
       @pId_Num_Empleado   INT = NULL,
       @pId_Num_Mes        INT = NULL,
       @pCant_Entrega             DECIMAL(10,2) = NULL,
       @pHoras_Trabajadas  INT = NULL
AS
BEGIN
       DECLARE
             @TranCount                 INT,
             @ErrorNum                  INT,
             @ErrorMensaje       VARCHAR(100),
             @DiasXSemana        INT,
             @HorasXDia                 INT,
             @SemanasXMes        INT

       SELECT
             -- DIAS TRABAJADOS POR SEMANA
             @DiasXSemana  =      6,
             -- HORAS LABORADAS POR DIA
             @HorasXDia          =      8,
             -- NUMERO DE SEMANAS POR MES
             @SemanasXMes  =      4

       SELECT @TranCount = @@TRANCOUNT
       IF @TranCount = 0
             BEGIN TRAN

       -- OPERACION PARA INSERTAR EN LA TABLA MOVIMIENTO
       IF @pOperacion      =      'I'
       BEGIN
			IF @pHoras_Trabajadas > @HorasXDia * @DiasXSemana * @SemanasXMes
             BEGIN
                    SELECT @ErrorMensaje = 'La cantidad de horas laboradas al mes sobrepasan, el maximo de horas es 192'
                    GOTO ERROR
             END

             IF EXISTS (SELECT 1 FROM Movimiento WHERE Id_Num_Empleado = @pId_Num_Empleado AND Id_Num_Mes = @pId_Num_Mes)
             BEGIN
                    UPDATE Movimiento
							SET   
								   Cant_Entrega        =      @pCant_Entrega,
								   Horas_Trabajadas    =      @pHoras_Trabajadas
					 WHERE
							Id_Num_Empleado =   @pId_Num_Empleado
							AND
							Id_Num_Mes          =      @pId_Num_Mes

					 IF @@ERROR <>0
					 BEGIN
							SELECT @ErrorMensaje = 'Error al actualizar en Movimiento'
							GOTO ERROR
					 END

					 GOTO FIN
             END             

             INSERT INTO Movimiento
             (
                    Id_Num_Empleado,                 
                    Id_Num_Mes,
                    Cant_Entrega,
                    Horas_Trabajadas
             )
             SELECT
                    @pId_Num_Empleado,
                    @pId_Num_Mes,
                    @pCant_Entrega,
                    @pHoras_Trabajadas

             IF @@ERROR <>0
             BEGIN
                    SELECT @ErrorMensaje = 'Error al insertar en Movimiento'
                    GOTO ERROR
             END

             GOTO FIN
       END

       -- OPERACION PARA BUSCAR EN LA TABLA Movimiento, DE ACUERDO A LOS FILTROS
       IF @pOperacion      =      'S'
       BEGIN
             SELECT
                    a.Id_Num_Empleado,
                    a.Nombre AS NombreEmpleado,
                    NumeroEmpleado,
                    b.Nombre AS NombreRol,
                    d.Nombre AS  Mes,
                    Cant_Entrega,
                    Horas_Trabajadas
             FROM
                    Movimiento c
                    JOIN Empleado a
                           ON     a.Id_Num_Empleado = c.Id_Num_Empleado
                    JOIN Rol b
                           ON     a.Id_Num_Rol =      b.Id_Num_Rol
                    JOIN Mes d
                           ON     d.Id_Num_Mes =      c.Id_Num_Mes
             WHERE
                    a.Id_Num_Empleado = ISNULL(@pId_Num_Empleado, NumeroEmpleado)                   
             ORDER BY
                    a.Nombre

             IF @@ERROR <>0
             BEGIN
                    SELECT @ErrorMensaje = 'Error al consultar los Movimiento'
                    GOTO ERROR
             END
             GOTO FIN
       END

       -- OPERACION PARA ACTUALIZAR DATOS EN LA TABLA Movimiento
       IF @pOperacion      =      'U'
       BEGIN 
             UPDATE Movimiento
                    SET   
                           Cant_Entrega        =      @pCant_Entrega,
                           Horas_Trabajadas    =      @pHoras_Trabajadas
             WHERE
                    Id_Num_Empleado =   @pId_Num_Empleado
                    AND
                    Id_Num_Mes          =      @pId_Num_Mes

             IF @@ERROR <>0
             BEGIN
                    SELECT @ErrorMensaje = 'Error al actualizar en Movimiento'
                    GOTO ERROR
             END

             GOTO FIN
       END

       -- OPERACION PARA ELIMINAR REGISTROS EN LA TABLA Movimiento
       IF @pOperacion      =      'D'
       BEGIN
             DELETE
             FROM
                    Movimiento
             WHERE
                    Id_Num_Empleado = @pId_Num_Empleado
                    AND
                    Id_Num_Mes          = @pId_Num_Mes
 

             IF @@ERROR <>0
             BEGIN
                    SELECT @ErrorMensaje = 'Error al eliminar Movimiento'
                    GOTO ERROR
             END

             GOTO FIN
       END

       ERROR:
             -- SI NO EXISTE UNA TRANSACCION FUERA DEL PROCEDIMIENTO, Y SE INICIO EN ESTE PROCEDIMIENTO
             -- AL HABER ERROR SE APLICA UN ROLLBACK
             IF @TranCount = 0 AND @@TRANCOUNT <> 0
             BEGIN
                    ROLLBACK TRAN
             END
             RAISERROR(@ErrorMensaje,12,1)
             RETURN 1

       FIN:
             -- SI NO EXISTE UNA TRANSACCION FUERA DEL PROCEDIMIENTO, Y SE INICIO EN ESTE PROCEDIMIENTO
             -- SE HACE UN COMMIT
             IF @TranCount = 0 AND @@TRANCOUNT <> 0
              BEGIN
                    COMMIT TRAN
             END
             RETURN 0
END
GO

