-- Creo la base de datos
DROP DATABASE IF EXISTS dbGimnasio;
CREATE DATABASE dbGimnasio;
USE dbGimnasio;

-- Por cuestión de orden/claridad, voy a crear 
-- primero las tablas y luego las restricciones

-- -------
-- TABLAS 
-- -------

DROP TABLE IF EXISTS provincia;
CREATE TABLE Provincia (
    id_provincia INT PRIMARY KEY AUTO_INCREMENT,
    nombre_provincia VARCHAR(150) NOT NULL
);

DROP TABLE IF EXISTS localidad;
CREATE TABLE localidad (
    id_localidad INT PRIMARY KEY AUTO_INCREMENT,
    nombre_localidad VARCHAR(200) NOT NULL,
    codigo_postal varchar(8) NOT NULL,
    id_provincia INT NOT NULL
);

DROP TABLE IF EXISTS profesor;
CREATE TABLE profesor (
    id_profesor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_profesor VARCHAR(100) NOT NULL,
    apellido_profesor VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL    
);

DROP TABLE IF EXISTS maquinaoelemento;
CREATE TABLE maquinaoelemento (
    id_elemento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS alumno;
CREATE TABLE alumno (
    id_alumno INT PRIMARY KEY AUTO_INCREMENT,
    nombre_alumno VARCHAR(100) NOT NULL,
    apellido_alumno VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100),
    fecha_nac DATE NOT NULL,
    telefono VARCHAR(20),
    domicilio VARCHAR(150) NOT NULL,
    id_localidad INT NOT NULL
);

DROP TABLE IF EXISTS plan;
CREATE TABLE plan (
    id_plan INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    cantidad_dias_semana TINYINT NOT NULL
);

DROP TABLE IF EXISTS pago;
CREATE TABLE pago (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,    
    fecha_pago DATE NOT NULL,
    id_forma_pago INT NOT NULL,
    id_plan_alumno INT NOT NULL,       
    monto DECIMAL(10,2) NOT NULL
);

DROP TABLE IF EXISTS forma_de_pago;
CREATE TABLE forma_de_pago (
    id_forma_pago INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(100) NOT NULL,
    tipo enum('Efectivo', 'Tarjeta Credito', 'Tarjeta Débito', 'Transferencia','Otros') NOT NULL
);

DROP TABLE IF EXISTS plan_alumno;
CREATE TABLE plan_alumno (
    id_plan_alumno INT PRIMARY KEY AUTO_INCREMENT,
    id_plan INT NOT NULL,
    id_alumno INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    dia_mes_vto_pago DATE NOT NULL
);

DROP TABLE IF EXISTS ejercicio;
CREATE TABLE ejercicio (
    id_ejercicio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    id_elemento INT
);

DROP TABLE IF EXISTS rutina_alumno;
CREATE TABLE rutina_alumno (
    id_rutina_alumno INT PRIMARY KEY AUTO_INCREMENT,
    id_alumno INT NOT NULL,
    id_ejercicio INT NOT NULL,
    dia_semana enum ('Lunes','Martes','Miercoles','Jueves','Viernes','Sabado') NOT NULL,
    id_profesor INT NOT NULL,
    orden TINYINT NOT NULL,
    repeticiones TINYINT NOT NULL,
    series TINYINT NOT NULL,
    peso DECIMAL(5,2) NOT NULL,
    fecha_baja DATE    
);


-- --------------
-- Restricciones
-- --------------

-- Claves foráneas (FK)
ALTER TABLE localidad
    ADD CONSTRAINT fk_localidad_provincia
    FOREIGN KEY (id_provincia) REFERENCES provincia(id_provincia)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE alumno    
    ADD CONSTRAINT fk_alumno_localidad
    FOREIGN KEY (id_localidad) REFERENCES localidad(id_localidad);

ALTER TABLE pago
    ADD CONSTRAINT fk_pago_forma_de_pago
    FOREIGN KEY (id_forma_pago) REFERENCES forma_de_pago(id_forma_pago),
    
    ADD CONSTRAINT fk_pago_plan_alumno
    FOREIGN KEY (id_plan_alumno) REFERENCES plan_alumno(id_plan_alumno);

ALTER TABLE plan_alumno
    ADD CONSTRAINT fk_plan_alumno_plan
    FOREIGN KEY (id_plan) REFERENCES plan(id_plan),
    
    ADD CONSTRAINT fk_plan_alumno_alumno
    FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno);


ALTER TABLE ejercicio
    ADD CONSTRAINT fk_ejercicio_elemento
    FOREIGN KEY (id_elemento) REFERENCES maquinaoelemento(id_elemento)
    ON DELETE SET NULL ON UPDATE CASCADE;
    

ALTER TABLE rutina_alumno
    ADD CONSTRAINT fk_rutina_alumno_ejercicio
    FOREIGN KEY (id_ejercicio) REFERENCES ejercicio(id_ejercicio)
    ON DELETE CASCADE ON UPDATE CASCADE,
    
    ADD CONSTRAINT fk_rutina_alumno_alumno
    FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno)
    ON DELETE CASCADE ON UPDATE CASCADE,

	ADD CONSTRAINT fk_rutina_alumno_profesor
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor)
    ON DELETE CASCADE ON UPDATE CASCADE;

    
-- ------------
-- Índices ---
-- ------------
ALTER TABLE alumno ADD INDEX idx_Apellido (apellido_alumno);
ALTER TABLE alumno ADD INDEX idx_Nombre (nombre_alumno);
ALTER TABLE alumno ADD INDEX idx_DNI (dni);
ALTER TABLE ejercicio ADD INDEX idx_Nombre (nombre);
ALTER TABLE localidad ADD INDEX idx_Nombre (nombre_localidad);
ALTER TABLE localidad ADD INDEX idx_CodPostal (codigo_postal);


-- -------------------------------PRE ENTREGA 2 ------------------------------

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

-- ----------------------
-- Creación de 5 Vistas
-- ----------------------

/*
v_alumnos_planes_mes_actual
Descripción: Listado de alumnos junto a su plan que comenzaron en el mes en curso
Objetivo: Conocer en detalle las altas que se dieron en el mes/año actual
Tablas: alumno, plan, plan_alumno
*/
DROP VIEW IF EXISTS v_alumnos_planes_mes_actual;
CREATE VIEW v_alumnos_planes_mes_actual AS
SELECT p.nombre 'Inscripto en Plan', pa.fecha_inicio 'Fecha inscripción', CONCAT(a.apellido_alumno,', ', a.nombre_alumno) Alumno, a.dni, a.fecha_nac 
FROM alumno a
JOIN plan_alumno pa ON 
	a.id_alumno = pa.id_alumno
JOIN plan p ON 
	p.id_plan = pa.id_plan_alumno
WHERE DATE_FORMAT(CURDATE(),'%m/%Y')= DATE_FORMAT(pa.fecha_inicio ,'%m/%Y')
ORDER BY pa.fecha_inicio;

/*
v_alumnos_por_planes
Descripción: Cantidad de alumnos por planes activos
Objetivo: --
Tablas: alumno, plan, plan:alumno
*/
DROP VIEW IF EXISTS v_alumnos_por_planes;
CREATE VIEW v_alumnos_por_planes AS
SELECT p.nombre 'Plan' , count(*) 'Cant. Alumnos' 
FROM plan_alumno pa
JOIN plan p ON
	pa.id_plan = p.id_plan
GROUP BY p.id_plan, p.nombre, pa.fecha_fin
HAVING ISNULL(pa.fecha_fin)
ORDER BY p.nombre;

/*v_profesores_rutinas
Descripción: Relación de profesores con las rutinas que diseñaron.
Objetivo: Verificar carga de trabajo de cada profesor.
Tablas: profesor, rutina_alumno, ejercicio.
*/
DROP VIEW IF EXISTS v_profesores_rutinas;
CREATE VIEW v_profesores_rutinas AS
SELECT DISTINCT p.id_profesor, p.nombre_profesor AS profesor,  e.nombre AS rutina
FROM profesor p
JOIN rutina_alumno r ON 
	p.id_profesor = r.id_profesor
JOIN ejercicio e ON
	r.id_ejercicio = e.id_ejercicio;

/*
v_alumnos_pagos_pendientes
Descripción: Alumnos con abonos vencidos o sin pago registrado.
Objetivo: Seguimiento de cobranzas.
Tablas: alumno, plan, alumno_plan, pago.
*/

DROP VIEW IF EXISTS v_alumnos_pagos_pendientes;
CREATE VIEW v_alumnos_pagos_pendientes AS
SELECT a.dni 'DNI', CONCAT(a.apellido_alumno,', ', a.nombre_alumno) 'Alumno', pl.nombre 'Plan'
FROM alumno a
JOIN plan_alumno pa ON a.id_alumno = pa.id_alumno
JOIN plan pl ON pa.id_plan = pl.id_plan
LEFT JOIN pago p ON pa.id_plan_alumno = p.id_plan_alumno
JOIN forma_de_pago fp ON p.id_forma_pago=fp.id_forma_pago
WHERE DATE_FORMAT(pa.dia_mes_vto_pago,'d%/%m') < DATE_FORMAT(CURDATE(),'d%/%m');

/*
v_utilizacion_maquinas
Descripción: Resumen del uso de máquinas por rutina.
Objetivo: Saber qué máquinas/equipos tienen más demanda.
Tablas: rutina, ejercicio, maquinaelemento.
*/

CREATE VIEW v_utilizacion_maquinas AS
SELECT m.nombre AS maquina, COUNT(e.id_ejercicio) AS veces_usada
FROM maquinaoelemento m
JOIN ejercicio e ON m.id_elemento = e.id_elemento
JOIN rutina_alumno r ON r.id_ejercicio = e.id_ejercicio
GROUP BY m.nombre;


-- ------------------------------------
-- Creación de 2 Funciones Almacenadas
-- ------------------------------------
/*
fn_CalcularEdadAlumno
Objetivo: calcular la edad de un alumno a partir de su fecha de nacimiento.
Tablas: -
*/

DELIMITER $$
CREATE FUNCTION fn_CalcularEdadAlumno(fecha_nacimiento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE edad INT;
  SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
  RETURN edad;
END$$
DELIMITER ;

/*
fn_DescuentoPorAntiguedad
Objetivo: calcular un descuento según la antigüedad del alumno.
Tablas: -
*/

DELIMITER $$
CREATE FUNCTION fn_DescuentoPorAntiguedad(fecha_alta DATE)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE años INT;
  SET años = TIMESTAMPDIFF(YEAR, fecha_alta, CURDATE());
  RETURN CASE
    WHEN años >= 5 THEN 0.20
    WHEN años >= 3 THEN 0.10
    ELSE 0.00
  END;
END$$
DELIMITER ;


-- -----------------------------------------
-- Creación de 2 Procedimientos Almacenados
-- -----------------------------------------
/*
sp_RegistrarPago
Objetivo: registrar un nuevo pago de un alumno.
Tablas: Pago.
*/

DELIMITER $$
CREATE PROCEDURE sp_RegistrarPago (
    IN p_fecha_pago DATE,
    IN p_id_forma_pago INT,
    IN p_id_plan_alumno INT,
    IN p_monto DECIMAL(10,2)    
)
BEGIN
  INSERT INTO pago (fecha_pago, id_forma_pago, id_plan_alumno, monto)
  VALUES (p_fecha_pago, p_id_forma_pago, p_id_plan_alumno, p_monto);
END$$
DELIMITER ;

/*
sp_BajaAlumno
Objetivo: dar de baja un alumno de un plan.
Tablas: Plan_Alumno
*/

DELIMITER $$
CREATE PROCEDURE sp_BajaAlumno (
    IN p_id_plan_alumno INT,
	IN p_fecha_baja DATE
)
BEGIN
  UPDATE plan_alumno
  SET fecha_fin = p_fecha_baja
  WHERE id_plan_alumno = p_id_plan_alumno;
END$$
DELIMITER ;


-- -----------------------------------------
-- Creación de 2 Triggers
-- -----------------------------------------
/*
trg_AutoFechaAltaAlumnoPlan
Objetivo: asignar automáticamente la fecha de alta al insertar un nuevo plan de un alumno.
Tablas: plan_alumno.
*/

DELIMITER $$
CREATE TRIGGER trg_AutoFechaAltaAlumnoPlan
BEFORE INSERT ON plan_alumno
FOR EACH ROW
BEGIN
  IF NEW.fecha_inicio IS NULL THEN
    SET NEW.fecha_inicio = CURDATE();
  END IF;
END$$
DELIMITER ;


/*
trg_LogPagos
Objetivo: registrar en una tabla de logs cada nuevo pago realizado.
Tablas: Pago, LogPagos (tabla a crear).
*/

CREATE TABLE IF NOT EXISTS LogPagos (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_pago INT,
    fecha_log DATETIME,
    usuario VARCHAR(50)
);

DELIMITER $$
CREATE TRIGGER trg_LogPagos
AFTER INSERT ON pago
FOR EACH ROW
BEGIN
  INSERT INTO LogPagos (id_pago, fecha_log, usuario)
  VALUES (NEW.id_pago, NOW(), USER());
END$$
DELIMITER ;