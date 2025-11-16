---Datos PERSONAS---
USE Veterinaria 

INSERT INTO PERSONAS (DNI, Nombre, Apellido, Email,Direccion)
VALUES
('30111222','Juan', 'Gomez', 'juan.gomez@gmail.com', 'Av Libertad 123'),
('32222333','Ana', 'Martinez', 'ana.mtz@gmail.com', 'Calle San Juan 450'),
('29888999','Roberto', 'Fernandez', 'roberti.f@gmail.com', 'Dorrego 890'),
('35555111','Lucia', 'Alvarez', 'lucia.alvarez@gmail.com', 'Alsina 100'),
('31222444','Martin', 'Ruiz', 'martin.ruiz@gmail.com', 'Belgrano 500');

---Datos ROLES---
INSERT INTO ROLES (Rol)
VALUES
('Administrador'),
('Veterinario'),
('Recepcionista');

---Dats USUARIOS---
INSERT INTO USUARIOS(NombreUsuario, Contraseña,IDRol,Email)
VALUES 
('jgomez', '1234', 1 , 'juan.gomez@gmail.com'),
('rmfernandez', '4567', 2, 'roberto.f@gmail.com'), 
('lalvarez', '9876', 2, 'lucia.alvaerz@gmail.com'); 

---Datos CLIENTES---
INSERT INTO CLIENTES (IDPersona)
VALUES
(1),
(2),
(5); 

---Datos Telefonos ---
INSERT INTO TELEFONO (IDCLiente, Contacto)
VALUES
(1, '1133445566'),
(1, '1122334455'),
(2, '1144556677'),
(3, '1166778899'); 

---Datos Veterinarios---
INSERT INTO VETERINARIOS (IDPersona, IDUsuario,Matricula,EspecialidadPincipal)
VALUES
(3, 2, 'Mat-001', 'Clinica General'),
(4, 3, 'Mat-002', 'Cirugia');

---Datos Especialidades---
INSERT INTO ESPECIALIDADES (IDVeterinario, Especialidad)
VALUES
(1, 'Clinica General'),
(1, 'Dermatologia'),
(2, 'Cirugia'),
(2, 'Traumatologia');

---Datos Horarios---
INSERT INTO HORARIOS (IDVeterinario, Dias, FranjaHoraria)
VALUES
(1, 'Lunes a Viernes', '09:00'),
(2, 'Martes y Jueves', '14:00');

---Datos Sexo---
INSERT INTO SEXO (Sexo)
VALUES
('Macho'),
('Hembra');

---Datos Especie---
INSERT INTO ESPECIE (Descripcion)
VALUES
('Perro'),
('Gato'),
('Conejo'),
('Ave');

---Datos Mascotas---
INSERT INTO MASCOTAS (IDCLiente, IDEspecie, NombreMascota, Raza, FechaNacimiento,IDSexo)
VALUES
(1 ,1, 'Toby', 'Labrador', '2018-05-10', 1),
(1 ,2, 'Mishi', 'Siamez', '2020-03-18', 2),
(2 ,1, 'Rocky', 'Pitbull', '2017-02-22', 1),
(3 ,4, 'Pipo', 'Canario Amarillo', '2022-01-01', 1);

--- Datos Atenciones---
INSERT INTO ATENCIONES (IDMascota, IDVeterinario,FechaAtencion, MotivoConsulta, Diagnostico, Observaciones)
VALUES
(1, 1, '2024-01-10', 'Vomitos', 'Gastritis', 'Se indica dieta blanda'),
(1, 1, '2024-02-15', 'Control', 'Mejoria', 'Continua dieta'), 
(2, 2, '2024-03-05', 'Herida', 'Corte Leve','Curacion y Reposo'),
(3, 1, '2024-02-20', 'Cojea', 'Lesion leve', 'Reposo 5 dias');

---Datos tratamientos---
INSERT INTO TRATAMIENTOS (IDAtencion, DescripcionTratamiento,Medicamento, Dosis, DuracionTrataiento)
VALUES 
(1, 'Tratamiento Gastritis', 'Omeprazol', '10 mg', '7 dias'),
(2, 'Seguimiento Gastritis', 'Prokinetico', '5 ,l', '3 dias'), 
(3, 'Curacion Herida', 'Cicatrizante', 'Aplicacion  externa', '5 dias'),
(4, 'Antiinflamatorio', 'Meloxicam', '5 mg', '3 dias');

