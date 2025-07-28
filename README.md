# Proyecto Base de Datos para un Gimnasio
Curso SQL - Pre Entrega 1


Reglas de Negocio
-----------------


Los nombres de los índices comienzan por idx_ y luego una palabra descriptiva del campo indexado
Para las claves foráneas, los nombres son: fk_ segido de las 2 tablas involucradas, separadas por _
Por ejemplo: fk_rutina_alumno_ejercicio hace referencias a la
fk de la
    FOREIGN KEY (id_ejercicio) REFERENCES ejercicio(id_ejercicio)
