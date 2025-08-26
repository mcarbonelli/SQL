-- -------------------------------------
-- Inserts para poblar tablas de la bbdd
-- -------------------------------------

INSERT INTO provincia (nombre_provincia) VALUES
('Buenos Aires'),
('Córdoba'),
('Santa Fe'),
('Mendoza'),
('Salta'),
('Neuquén'),
('Tucumán'),
('San Luis'),
('Chaco'),
('Misiones');

INSERT INTO localidad (nombre_localidad, codigo_postal, id_provincia) VALUES
('La Plata','1900',1),
('Mar del Plata','7600',1),
('Córdoba Capital','5000',2),
('Rosario','2000',3),
('Santa Fe Capital','3000',3),
('Mendoza Capital','5500',4),
('San Rafael','5600',4),
('Salta Capital','4400',5),
('Neuquén Capital','8300',6),
('San Miguel de Tucumán','4000',7);

INSERT INTO profesor (nombre_profesor, apellido_profesor, especialidad) VALUES
('Juan','Pérez','Musculación'),
('Ana','García','Cardio'),
('Luis','Martínez','Crossfit'),
('Carla','Rodríguez','Yoga'),
('Pedro','López','Funcional');

INSERT INTO alumno (nombre_alumno, apellido_alumno, dni, fecha_nac, domicilio, id_localidad) VALUES
('Sofía','Fernández','28123456','1995-03-12','Las eras 342',4),
('Martín','Gómez','27546897','1990-06-22','Albert Einstein 4300',4),
('Lucía','Sánchez','29546894','2000-01-15','Piccaso 102',4),
('Diego','Torres','30789521','1988-09-09','Suipacha 5435',3),
('Valentina','Ruiz','28654222','1993-07-30','Concordia 342 Piso 1 Dpto B',3),
('Andrés','Moreno','31987561','1998-11-20','Paez 436',3),
('Camila','Díaz','35426555','1996-02-05','Jose C. Paz 32 Bis',4),
('Julián','Silva','26554778','1992-12-01','Atlanta 421',5),
('Florencia','Cruz','27852741','1999-04-17','Rivera 2321',5),
('Mateo','Benítez','26369258','1985-08-25','Juan C.C 234',6);

INSERT INTO maquinaoelemento (nombre,tipo) VALUES
('Bicicleta fija','Cardio'),
('Cinta de correr','Cardio'),
('Banda Elástica','Fuerza'),
('Banco de pesas','Fuerza'),
('Soga Salto','Cardio'),
('Máquina de poleas','Fuerza'),
('Mancuernas','Fuerza'),
('Elíptico','Cardio');

INSERT INTO ejercicio (nombre,descripcion,id_elemento) VALUES
('Press banca','Ejercicio de pectorales',3),
('Sentadillas','Ejercicio de piernas',4),
('Curl bíceps','Ejercicio de brazos',4),
('Abdominales','Ejercicio de core',NULL),
('Running','Ejercicio aeróbico',2),
('Bicicleta','Ejercicio aeróbico',1);

INSERT INTO rutina_alumno (id_alumno, id_ejercicio, id_profesor, dia_semana, orden, series, repeticiones, peso) VALUES
(1,1,1, 'Lunes',1,3,10,20),
(1,1,1, 'Lunes',2,3,20,15),
(1,1,1, 'Lunes',3,3,15,10),
(1,1,3, 'Miercoles',1,3,10,20),
(1,1,3, 'Miercoles',2,3,20,15),
(1,1,3, 'Miercoles',3,3,15,10),
(1,1,2, 'Viernes',1,3,10,20),
(1,1,2, 'Viernes',2,3,20,15),
(1,1,2, 'Viernes',3,3,15,10);

INSERT INTO forma_de_pago (descripcion, tipo) VALUES
('Efectivo','Efectivo'),
('Billetera Virtual','Efectivo'),
('Visa Macro','Tarjeta Credito'),
('Visa Macro','Tarjeta Debito'),
('Visa Santader','Tarjeta Credito'),
('Amex Santander','Tarjeta Credito'),
('Visa Santander','Tarjeta Debito'),
('Billetera Vrtual','Transferencia'),
('MercadoPago','Otros');

INSERT INTO plan (nombre, precio, cantidad_dias_semana) VALUES
('Mensual básico',10000,1),
('Mensual 2',15000,2),
('Mensual 3',27000,3),
('Mensual Pase Libre',42000,6),
('Anual - Pase Libre',150000,6);

INSERT INTO plan_alumno (id_plan, id_alumno, fecha_inicio, dia_mes_vto_pago) VALUES
(1,1,'2025-08-01','2025-08-15'),
(2,1,'2025-07-05','2025-08-15'),
(3,3,'2025-08-15','2025-08-05'),
(4,3,'2025-08-20','2025-08-05'),
(5,2,'2025-05-08','2025-08-05');

INSERT INTO pago (fecha_pago, id_forma_pago, id_plan_alumno, monto) VALUES
('2025-08-01',1,1,10000),
('2025-08-01',1,2,10000),
('2025-08-01',2,2,10000),
('2025-08-01',3,3,10000);
