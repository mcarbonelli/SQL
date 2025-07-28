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
