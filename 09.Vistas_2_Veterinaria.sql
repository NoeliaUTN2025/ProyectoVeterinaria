USE Veterinaria
GO

---Vista: Mascotas con su cliente 


CREATE VIEW MascotasPorEspecie
AS
SELECT 
     E.Descripcion AS Especie,
     COUNT (M.IDMascota) AS CantidadMacotas
FROM MASCOTAS M 
INNER JOIN ESPECIE E ON M.IDEspecie = E.IDEspecie
GROUP BY E.Descripcion;
GO

---Vista Historial Mascotas 

CREATE VIEW HistorialMascotas 
AS
SELECT 
     m.IDMascota,
     m.NombreMascota AS MASCOTAS, 
     pC.Nombre + '' AS CLIENTES,
     pV.Nombre + ''  AS VETERINARIO, 
     a.FechaAtencion,
     a.Diagnostico,
     t.DescripcionTratamiento AS Tratamiento
FROM MASCOTAS m 
JOIN CLIENTES c ON m.IDCLiente = c.IDCliente
JOIN Personas pC ON c.IDPersona =pC.IDpersona
JOIN ATENCIONES a ON m.IDMascota = a.IDMascota
JOIN VETERINARIOS v ON a.IDVeterinario = v.IDVeterinario
JOIN Personas pV ON v.IDPersona =pV.IDpersona
LEFT JOIN TRATAMIENTOS t ON a.IDAtencion = t.IDAtencion; 
GO