USE Veterinaria 
GO

--- Procedimiento Almacenado para evitar atenciones superpuestas

ALTER TABLE ATENCIONES 
ADD HoraAtencion TIME; 
GO

CREATE PROCEDURE RegistrarAtencionSinSuperposicion 
@IDMascota INT,
@IDVeterinario INT,
@Fecha DATE, 
@Hora TIME,
@MotivoConsulta VARCHAR (200),
@Diagnostico VARCHAR (255),
@Observaciones VARCHAR (255)

AS
BEGIN
---VALIDAR SI YA EXISTE UNA ATENCION ESE DIA Y HORARIO PARA EL VETERINARIO 
IF EXISTS (
    SELECT 1 FROM ATENCIONES 
    WHERE IDVeterinario = @IDVeterinario
    AND FechaAtencion = @Fecha
    AND HoraAtencion =@Hora
    )
    BEGIN
    RAISERROR ('El veterinario ya tiene una atencion programada en ese horario.', 16, 1);
    RETURN; 

    END

    --VALIDAR SI LA MASCOTA YA TIENE ATENCION EN ESE HORARIO 

    IF EXISTS (
        SELECT 1 FROM ATENCIONES
        WHERE IDMascota =@IDMascota
        AND FechaAtencion =@Fecha
        AND HoraAtencion =@Hora
    )

    BEGIN 
    RAISERROR ('La mascota ya tiene una atencion programada en ese horario.',16 , 1);
    RETURN;

    END
    ---INSERTAR UNA NUEVA ATENCION 

    INSERT INTO ATENCIONES (IDMascota, IDVeterinario, FechaAtencion,HoraAtencion,MotivoConsulta,
    Diagnostico, Observaciones)

    VALUES 
    (@IDMascota, @IDVeterinario, @Fecha,@Hora,@MotivoConsulta,@Diagnostico,@Observaciones);
    END;

    GO
