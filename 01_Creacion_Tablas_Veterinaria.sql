-- Verificar si la base de datos existe, si no, crearla
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Veterinaria')
BEGIN
    CREATE DATABASE Veterinaria;
    PRINT 'Base de datos Veterinaria creada';
END
ELSE
BEGIN
    PRINT 'Base de datos Veterinaria ya existe';
END
GO

USE Veterinaria
GO

-- Crear tablas solo si no existen
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PERSONAS')
BEGIN
    CREATE TABLE PERSONAS(
        IDpersona INT IDENTITY (1,1) PRIMARY KEY,
        DNI CHAR (10) NOT NULL, 
        Nombre VARCHAR (50) NOT NULL, 
        Apellido VARCHAR (50) NOT NULL, 
        Email VARCHAR (100),
        Direccion VARCHAR (100)
    );
    PRINT 'Tabla PERSONAS creada';
END
GO

-- Repetir el mismo patrón para todas las tablas...
