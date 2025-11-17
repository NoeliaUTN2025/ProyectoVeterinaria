USE Veterinaria
GO
ALTER TABLE CLIENTES ADD FechaBaja DATETIME NULL;
GO

ALTER TABLE MASCOTAS ADD UltimaAtencion DATE NULL;
GO

ALTER TABLE ATENCIONES ADD FechaModificacion DATETIME NULL, UsuarioModificacion VARCHAR(50) NULL;
GO

PRINT 'Estructura de tablas modificada exitosamente';