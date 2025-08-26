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