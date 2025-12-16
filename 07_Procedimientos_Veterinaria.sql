USE Veterinaria
GO

-- Eliminar procedimientos existentes primero
IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'NuevaAtencion')
    DROP PROCEDURE NuevaAtencion;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'RegistroTratamiento')
    DROP PROCEDURE RegistroTratamiento;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'ActualizarEstadoMascota')
    DROP PROCEDURE ActualizarEstadoMascota;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'GenerarRecordatoriosControles')
    DROP PROCEDURE GenerarRecordatoriosControles;
GO


 
-- 1. RegistroTratamiento: Registrar tratamiento asociado a atenci�n
CREATE PROCEDURE RegistroTratamiento
    @IDAtencion INT,
    @DescripcionTratamiento VARCHAR(255),
    @Medicamento VARCHAR(100),
    @Dosis VARCHAR(50),
    @DuracionTratamiento VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar que la atenci�n existe
        IF NOT EXISTS (SELECT 1 FROM ATENCIONES WHERE IDAtencion = @IDAtencion)
        BEGIN
            RAISERROR('Error: La atenci�n con ID %d no existe.', 16, 1, @IDAtencion);
            RETURN -1;
        END
        
        -- Insertar el tratamiento
        INSERT INTO TRATAMIENTOS (IDAtencion, DescripcionTratamiento, Medicamento, Dosis, DuracionTrataiento)
        VALUES (@IDAtencion, @DescripcionTratamiento, @Medicamento, @Dosis, @DuracionTratamiento);
        
        PRINT 'Tratamiento registrado exitosamente. ID: ' + CAST(SCOPE_IDENTITY() AS VARCHAR);
        RETURN SCOPE_IDENTITY();
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al registrar tratamiento: %s', 16, 1, @ErrorMsg);
        RETURN -1;
    END CATCH
END;
GO

-- 2. ActualizarEstadoMascota: Mantener actualizado el estado de salud
CREATE PROCEDURE ActualizarEstadoMascota
    @IDMascota INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar que la mascota existe
        IF NOT EXISTS (SELECT 1 FROM MASCOTAS WHERE IDMascota = @IDMascota)
        BEGIN
            RAISERROR('Error: La mascota con ID %d no existe.', 16, 1, @IDMascota);
            RETURN -1;
        END
        
        PRINT 'Estado de mascota verificado';
        RETURN 1;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al actualizar estado de mascota: %s', 16, 1, @ErrorMessage);
        RETURN -1;
    END CATCH
END;
GO

-- 3. GenerarRecordatoriosControles: Programar controles futuros
CREATE PROCEDURE GenerarRecordatoriosControles
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        m.IDMascota,
        m.NombreMascota,
        p.Nombre + ' ' + p.Apellido as Due�o,
        tel.Contacto as Telefono,
        a.FechaAtencion as UltimaAtencion,
        t.DescripcionTratamiento,
        t.DuracionTrataiento,
        DATEADD(DAY, 
            CASE 
                WHEN t.DuracionTrataiento LIKE '%dias%' THEN TRY_CAST(REPLACE(t.DuracionTrataiento, ' dias', '') AS INT)
                WHEN t.DuracionTrataiento LIKE '%d�as%' THEN TRY_CAST(REPLACE(t.DuracionTrataiento, ' d�as', '') AS INT)
                ELSE 7
            END, 
            a.FechaAtencion
        ) as ProximoControl
    FROM MASCOTAS m
    INNER JOIN CLIENTES cl ON m.IDCLiente = cl.IDCliente
    INNER JOIN PERSONAS p ON cl.IDPersona = p.IDPersona
    INNER JOIN ATENCIONES a ON m.IDMascota = a.IDMascota
    INNER JOIN TRATAMIENTOS t ON a.IDAtencion = t.IDAtencion
    LEFT JOIN TELEFONO tel ON cl.IDCliente = tel.IDCliente
    WHERE cl.Estado = 1
    AND DATEADD(DAY, 
        CASE 
            WHEN t.DuracionTrataiento LIKE '%dias%' THEN TRY_CAST(REPLACE(t.DuracionTrataiento, ' dias', '') AS INT)
            WHEN t.DuracionTrataiento LIKE '%d�as%' THEN TRY_CAST(REPLACE(t.DuracionTrataiento, ' d�as', '') AS INT)
            ELSE 7
        END, 
        a.FechaAtencion
    ) >= GETDATE();
    
    PRINT 'Recordatorios generados exitosamente';
END;
GO

PRINT 'Todos los procedimientos almacenados recreados exitosamente';