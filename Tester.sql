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
(2, 1, GETDATE(), 'Consulta', 'Fractura', 'Se copera');
GO


SELECT *FROM MASCOTAS WHERE IDMascota =1; 

INSERT INTO ATENCIONES (IDMascota, IDVeterinario,FechaAtencion,MotivoConsulta, Diagnostico , Observaciones)
VALUES 
(4,2, GETDATE(), 'Consulta', 'Vacuna', 'Se da de alta'); 
GO

INSERT INTO ATENCIONES (IDMascota, IDVeterinario,FechaAtencion,MotivoConsulta,Diagnostico,Observaciones)
VALUES
(3, 1, GETDATE(), 'Consulta', 'Fractura', 'Se opera');
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
    @Fecha = '2025-02-21',
    @Hora = '10:00',
    @MotivoConsulta = 'Control general',
    @Diagnostico = 'Control anual',
    @Observaciones = 'Todo OK';
GO

EXEC RegistrarAtencionSinSuperposicion
    @IDMascota =2,
    @IDVeterinario = 1,
    @Fecha = '2025-02-23',
    @Hora = '10:00',
    @MotivoConsulta = 'Control general',
    @Diagnostico = 'Control anual',
    @Observaciones = 'Todo OK';
GO
EXEC RegistrarAtencionSinSuperposicion
    @IDMascota =3,
    @IDVeterinario = 1,
    @Fecha = '2025-02-25',
    @Hora = '11:00',
    @MotivoConsulta = 'Control general',
    @Diagnostico = 'Control anual',
    @Observaciones = 'Todo OK';
GO

EXEC RegistrarAtencionSinSuperposicion
    @IDMascota =4,
    @IDVeterinario = 1,
    @Fecha = '2025-02-28',
    @Hora = '11:30',
    @MotivoConsulta = 'Control general',
    @Diagnostico = 'Control anual',
    @Observaciones = 'Todo OK';
GO

---PROBAR VISTA HISTORIAL MASCOTAS 
SELECT * FROM MASCOTAS; 
SELECT * FROM ATENCIONES; 
SELECT * FROM TRATAMIENTOS; 

SELECT * FROM HistorialMascotas; 

SELECT *
from HistorialMascotas
WHERE MASCOTAS = 'Toby'; 


---- test recordtorios 
SELECT * FROM Recordatorios; 
SELECT * FROM ATENCIONES; 

EXEC GenerarRecordatoriosControles @IDAtencion =1; 