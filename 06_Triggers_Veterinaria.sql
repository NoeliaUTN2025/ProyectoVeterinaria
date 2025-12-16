USE Veterinaria
GO

-- Eliminar triggers existentes primero
IF EXISTS (SELECT 1 FROM sys.triggers WHERE name = 'TR_EliminacionCliente')
    DROP TRIGGER TR_EliminacionCliente;
GO

IF EXISTS (SELECT 1 FROM sys.triggers WHERE name = 'TR_RegistrarAtencion')
    DROP TRIGGER TR_RegistrarAtencion;
GO

IF EXISTS (SELECT 1 FROM sys.triggers WHERE name = 'TR_AuditoriaModificacionesAtenciones')
    DROP TRIGGER TR_AuditoriaModificacionesAtenciones;
GO

-- 1. Trigger: EliminacionCliente - Baja l�gica en lugar de eliminaci�n f�sica
CREATE TRIGGER TR_EliminacionCliente
ON CLIENTES
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE cl
    SET cl.Estado = 0, 
        cl.FechaBaja = GETDATE()
    FROM CLIENTES cl
    INNER JOIN deleted d ON cl.IDCliente = d.IDCliente
    WHERE EXISTS (SELECT 1 FROM MASCOTAS WHERE IDCLiente = cl.IDCliente);
    
    PRINT 'Clientes con mascotas marcados como inactivos (baja l�gica)';
END;
GO


-- 2. Trigger: AuditoriaModificacionesAtenciones - Traza cambios en atenciones
CREATE TRIGGER TR_AuditoriaModificacionesAtenciones
ON ATENCIONES
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Actualizar informaci�n de auditor�a
    UPDATE ATENCIONES 
    SET FechaModificacion = GETDATE(),
        UsuarioModificacion = SYSTEM_USER
    WHERE IDAtencion IN (SELECT IDAtencion FROM inserted);
    
    -- Registrar en tabla de auditor�a
    IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AUDITORIA_ATENCIONES')
    BEGIN
        CREATE TABLE AUDITORIA_ATENCIONES (
            IDAuditoria INT IDENTITY(1,1) PRIMARY KEY,
            IDAtencion INT,
            CampoModificado VARCHAR(50),
            ValorAnterior VARCHAR(255),
            ValorNuevo VARCHAR(255),
            FechaModificacion DATETIME DEFAULT GETDATE(),
            UsuarioModificacion VARCHAR(50)
        );
    END
    
    -- Insertar registros de auditor�a
    INSERT INTO AUDITORIA_ATENCIONES (IDAtencion, CampoModificado, ValorAnterior, ValorNuevo, UsuarioModificacion)
    SELECT 
        i.IDAtencion,
        'MotivoConsulta' as CampoModificado,
        d.MotivoConsulta as ValorAnterior,
        i.MotivoConsulta as ValorNuevo,
        SYSTEM_USER as UsuarioModificacion
    FROM inserted i
    INNER JOIN deleted d ON i.IDAtencion = d.IDAtencion
    WHERE i.MotivoConsulta <> d.MotivoConsulta
    
    UNION ALL
    
    SELECT 
        i.IDAtencion,
        'Diagnostico' as CampoModificado,
        d.Diagnostico as ValorAnterior,
        i.Diagnostico as ValorNuevo,
        SYSTEM_USER as UsuarioModificacion
    FROM inserted i
    INNER JOIN deleted d ON i.IDAtencion = d.IDAtencion
    WHERE i.Diagnostico <> d.Diagnostico;
    
    PRINT 'Auditor�a de modificaciones registrada';
END;
GO

PRINT 'Todos los triggers recreados exitosamente';