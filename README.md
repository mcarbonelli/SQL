# Proyecto Base de Datos para un Gimnasio
Curso SQL - Pre Entrega 1 y 2

Reglas de Negocio
-----------------
•	Un alumno puede tener varios planes, pero vigente solo uno.

Convenciones
------------
•	Los nombres de los índices comienzan por idx_ y luego una palabra descriptiva del campo indexado
•	Para las claves foráneas, los nombres son: fk_ segido de las 2 tablas involucradas, separadas por _ Por ejemplo: fk_rutina_alumno_ejercicio hace referencia a una FK entre la tabla rutina_alumno y ejercicio
• Todas las vistas comienzan con v_
• Todas las funciones comienzan con fn_
• Todas los procedimientos almacenados comienzan con sp_
• Todas los triggers comienzan con trg_


Detalle de Tablas
------------------
En el detalle de tablas, hay campos que sus nombres son autodescriptivos, por lo que no veo necesario agregar información adicional en la columna Descripción. Por ejemplo: nombre_alumno

Archvios de Entrea 2
--------------------
El PDF tiene todo el contenido de la entrega 1 más los temas de la consigna para la entrega 2.
Los scripts están separados en 2 (uno que tiene solamente las inserciones, y otro que tiene solamente la creación de las vistas, funciones y procedimientos almacenados, y triggers) más un script complet el cual incluye todo lo de la entrga 1 más el contenido de estos 2 scripts nuevos.
