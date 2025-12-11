USE Veterinaria
GO

--- verificacion de funcionamiento trigger Estado actual salud Mascota 

SELECT *FROM MASCOTAS WHERE IDMascota =1; 

INSERT INTO ATENCIONES (IDMascota, IDVeterinario,FechaAtencion,MotivoConsulta, Diagnostico , Observaciones)
VALUES 
(1,1, GETDATE(), 'Consulta', 'fractura en pata trasera', 'Se deja internado'); 
GO

INSERT INTO ATENCIONES (IDMascota, IDVeterinario,FechaAtencion,MotivoConsulta,Diagnostico,Observaciones)
VALUES
(2, 1, GETDATE(), 'Consulta', 'Control', 'Se continua con medicacion');
GO

---VISTA MASCOTAS POR ESPECIE 

SELECT *FROM MascotasPorEspecie; 
GO

--- Procedimiento almacenado RegistrarAtencionSinSuperposicion 

---mismo veterinario mismo horario 

EXEC RegistrarAtencionSinSuperposicion
    @IDMascota = 2,
    @IDVeterinario = 1,
    @Fecha = '2025-02-20',
    @Hora = '10:00',
    @MotivoConsulta = 'Emergencia',
    @Diagnostico = 'Dolor abdominal',
    @Observaciones = 'Urgente';
GO

EXEC RegistrarAtencionSinSuperposicion
    @IDMascota = 1,
    @IDVeterinario = 1,
    @Fecha = '2025-02-20',
    @Hora = '10:00',
    @MotivoConsulta = 'Control general',
    @Diagnostico = 'Control anual',
    @Observaciones = 'Todo OK';
GO


EXEC RegistrarAtencionSinSuperposicion
    @IDMascota =2,
    @IDVeterinario = 1,
    @Fecha = '2025-02-20',
    @Hora = '10:00',
    @MotivoConsulta = 'Control general',
    @Diagnostico = 'Control anual',
    @Observaciones = 'Todo OK';
GO


