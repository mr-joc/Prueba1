USE [PruebaDev]
GO

/****** Object:  StoredProcedure [dbo].[Empleados]    Script Date: 08/02/2023 11:44:29 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Empleados]
       @pOperacion                CHAR(1),
       @pId_Num_Empleado   INT = NULL,
       @pNombre                   VARCHAR(100) = NULL,
       @pNumeroEmpleado    VARCHAR(50) = NULL,
       @pId_Num_Rol        INT = NULL
AS
BEGIN
       DECLARE
             @TranCount                 INT,
             @ErrorNum                  INT,
             @ErrorMensaje       VARCHAR(100),
             @id_Num_Empleado    INT

       SELECT @TranCount = @@TRANCOUNT
       IF @TranCount = 0
             BEGIN TRAN

       -- OPERACION PARA INSERTAR EN LA TABLA EMPLEADO
       IF @pOperacion      =      'I'
       BEGIN
             IF EXISTS (SELECT 1 FROM Empleado WHERE NumeroEmpleado = @pNumeroEmpleado)
             BEGIN
                    SELECT @ErrorMensaje = 'El numero de empleado ya existe'
                    GOTO ERROR
             END

             SELECT @id_Num_Empleado = MAX(Id_Num_Empleado) + 1 FROM Empleado
             IF @id_Num_Empleado IS NULL
                    SELECT @id_Num_Empleado = 1

             INSERT INTO Empleado
             (
                    Id_Num_Empleado,
                    Nombre,
                    NumeroEmpleado,
                    Id_Num_Rol
             )
             SELECT
                    @id_Num_Empleado,
                    @pNombre,
                    @pNumeroEmpleado,
                    @pId_Num_Rol

             IF @@ERROR <>0
             BEGIN
                    SELECT @ErrorMensaje = 'Error al insertar en empleado'
                    GOTO ERROR
             END

             GOTO FIN
       END

       -- OPERACION PARA BUSCAR EN LA TABLA EMPLEADO, DE ACUERDO A LOS FILTROS
       IF @pOperacion      =      'S'
       BEGIN
             SELECT
                    a.Id_Num_Empleado,
                    a.Nombre AS NombreEmpleado,
                    NumeroEmpleado,
					a.Id_Num_Rol,
                    b.Nombre AS NombreRol
             FROM
                    Empleado a
                    JOIN Rol b
                           ON     a.Id_Num_Rol =      b.Id_Num_Rol
             WHERE
                    NumeroEmpleado	like ISNULL('%' + @pNumeroEmpleado + '%', NumeroEmpleado)
                    AND
                    a.Nombre		like ISNULL('%' + @pNombre + '%', a.Nombre)
                    AND
                    a.Id_Num_Rol	= ISNULL(@pId_Num_Rol, a.Id_Num_Rol)
					AND
					a.Id_Num_Empleado =	ISNULL(@pId_Num_Empleado,a.Id_Num_Empleado)
             ORDER BY
                    a.Nombre

             IF @@ERROR <>0
             BEGIN
                    SELECT @ErrorMensaje = 'Error al consultar los empleados'
                    GOTO ERROR
             END

             GOTO FIN
       END

       -- OPERACION PARA ACTUALIZAR DATOS EN LA TABLA EMPLEADO
       IF @pOperacion      =      'U'
       BEGIN
             IF EXISTS (SELECT 1 FROM Empleado WHERE NumeroEmpleado = @pNumeroEmpleado AND Id_Num_Empleado <> @pId_Num_Empleado)
             BEGIN
                    SELECT @ErrorMensaje = 'El numero de empleado ya existe'
                    GOTO ERROR
             END
 
             UPDATE Empleado
                    SET   
                           Nombre              =      @pNombre,
                           NumeroEmpleado      =      @pNumeroEmpleado,
                           Id_Num_Rol          =      @pId_Num_Rol
             WHERE
                    Id_Num_Empleado = @pId_Num_Empleado
 
             IF @@ERROR <>0
             BEGIN
                    SELECT @ErrorMensaje = 'Error al actualizar en empleado'
                    GOTO ERROR
             END
 
             GOTO FIN
       END

       -- OPERACION PARA ELIMINAR REGISTROS EN LA TABLA EMPLEADO
       IF @pOperacion      =      'D'
       BEGIN
			DELETE
             FROM
                    Movimiento
             WHERE
                    Id_Num_Empleado = @pId_Num_Empleado

             IF @@ERROR <>0
             BEGIN
                    SELECT @ErrorMensaje = 'Error al eliminar Movimiento'
                    GOTO ERROR
             END
			
             DELETE
             FROM
                    Empleado
             WHERE
                    Id_Num_Empleado = @pId_Num_Empleado

             IF @@ERROR <>0
             BEGIN
                    SELECT @ErrorMensaje = 'Error al eliminar empleado'
                    GOTO ERROR
             END

             GOTO FIN
       END

       ERROR:
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

