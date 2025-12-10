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
