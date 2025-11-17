USE Veterinaria;
GO

-- Eliminar vistas existentes primero
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'HistorialMascotas')
    DROP VIEW HistorialMascotas;
GO

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'MascotasPorCliente')
    DROP VIEW MascotasPorCliente;
GO

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VistaRecordatoriosPendientes')
    DROP VIEW VistaRecordatoriosPendientes;
GO

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VistaEstadisticasVeterinarios')
    DROP VIEW VistaEstadisticasVeterinarios;
GO

-- 1. HistorialMascotas: Histórico completo de mascotas


-- 2. MascotasPorCliente: Resumen de mascotas por cliente
CREATE VIEW MascotasPorCliente AS
SELECT 
    cl.IDCliente,
    p.DNI,
    p.Nombre + ' ' + p.Apellido as Cliente,
    p.Email,
    p.Direccion,
    COUNT(m.IDMascota) as CantidadMascotas,
    STRING_AGG(m.NombreMascota + ' (' + e.Descripcion + ')', ', ') as Mascotas
FROM CLIENTES cl
INNER JOIN PERSONAS p ON cl.IDPersona = p.IDPersona
LEFT JOIN MASCOTAS m ON cl.IDCliente = m.IDCLiente
LEFT JOIN ESPECIE e ON m.IDEspecie = e.IDEspecie
WHERE cl.Estado = 1
GROUP BY cl.IDCliente, p.DNI, p.Nombre, p.Apellido, p.Email, p.Direccion;
GO

-- 3. VistaRecordatoriosPendientes: Agenda de controles pendientes
CREATE VIEW VistaRecordatoriosPendientes AS
SELECT 
    m.IDMascota,
    m.NombreMascota,
    m.Raza,
    e.Descripcion as Especie,
    p.Nombre + ' ' + p.Apellido as Dueño,
    tel.Contacto as TelefonoContacto,
    a.FechaAtencion as UltimaAtencion,
    a.Diagnostico,
    t.DescripcionTratamiento,
    t.DuracionTrataiento,
    DATEADD(DAY, 
        CASE 
            WHEN t.DuracionTrataiento LIKE '%dias%' THEN TRY_CAST(REPLACE(t.DuracionTrataiento, ' dias', '') AS INT)
            WHEN t.DuracionTrataiento LIKE '%días%' THEN TRY_CAST(REPLACE(t.DuracionTrataiento, ' días', '') AS INT)
            ELSE 7
        END, 
        a.FechaAtencion
    ) as ProximoControl,
    vet_p.Nombre + ' ' + vet_p.Apellido as VeterinarioResponsable
FROM MASCOTAS m
INNER JOIN CLIENTES cl ON m.IDCLiente = cl.IDCliente
INNER JOIN PERSONAS p ON cl.IDPersona = p.IDPersona
INNER JOIN ESPECIE e ON m.IDEspecie = e.IDEspecie
INNER JOIN ATENCIONES a ON m.IDMascota = a.IDMascota
INNER JOIN VETERINARIOS vet ON a.IDVeterinario = vet.IDVeterinario
INNER JOIN PERSONAS vet_p ON vet.IDPersona = vet_p.IDPersona
LEFT JOIN TRATAMIENTOS t ON a.IDAtencion = t.IDAtencion
LEFT JOIN TELEFONO tel ON cl.IDCliente = tel.IDCliente
WHERE cl.Estado = 1
AND DATEADD(DAY, 
    CASE 
        WHEN t.DuracionTrataiento LIKE '%dias%' THEN TRY_CAST(REPLACE(t.DuracionTrataiento, ' dias', '') AS INT)
        WHEN t.DuracionTrataiento LIKE '%días%' THEN TRY_CAST(REPLACE(t.DuracionTrataiento, ' días', '') AS INT)
        ELSE 7
    END, 
    a.FechaAtencion
) >= GETDATE();
GO

-- 4. VistaEstadisticasVeterinarios: Análisis de productividad
CREATE VIEW VistaEstadisticasVeterinarios AS
SELECT 
    vet.IDVeterinario,
    vet.Matricula,
    p.Nombre + ' ' + p.Apellido as Veterinario,
    vet.EspecialidadPincipal,
    COUNT(a.IDAtencion) as TotalAtenciones,
    COUNT(DISTINCT a.IDMascota) as MascotasUnicasAtendidas,
    MIN(a.FechaAtencion) as PrimeraAtencion,
    MAX(a.FechaAtencion) as UltimaAtencion
FROM VETERINARIOS vet
INNER JOIN PERSONAS p ON vet.IDPersona = p.IDPersona
LEFT JOIN ATENCIONES a ON vet.IDVeterinario = a.IDVeterinario
GROUP BY vet.IDVeterinario, vet.Matricula, p.Nombre, p.Apellido, vet.EspecialidadPincipal;
GO

PRINT 'Todas las vistas recreadas exitosamente';