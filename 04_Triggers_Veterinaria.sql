USE Veterinaria
GO

---Trigger ActualizarEstadoMascotaPorDiagnostico
---El trigger sirve para actualizar el estado de salud de la mascota
---se ejecuta cuando se inserta una nueva atencion 

CREATE TRIGGER ActualizarEstadoMascotaPorDiagnostico
ON ATENCIONES
AFTER INSERT 
AS 
BEGIN 
    UPDATE MASCOTAS
    SET EstadoSalud =
        CASE 
            WHEN i.Diagnostico LIKE '%fractura%' OR
                 i.Diagnostico LIKE '%oper%' OR
                 i.Diagnostico LIKE '%grave%' THEN 'Delicada'
            WHEN i.Diagnostico LIKE '%control%' OR 
                 i.Diagnostico LIKE '%vacuna%' THEN 'Estable'
            ELSE 'Sin especificar'
        END
    FROM inserted i 
    WHERE MASCOTAS.IDMascota = i.IDMascota; 
END;
GO
