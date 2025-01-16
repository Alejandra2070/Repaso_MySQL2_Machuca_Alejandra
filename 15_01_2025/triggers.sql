USE universidad_t2;

-- O_O Este trigger será accionado con una modificación en
-- profesor, teniendo una nueva columna para el total de 
-- asignaturas llamada "total_asignaturas".

-- 1. Al asignar una nueva asignatura a un profesor, 
-- actualiza el total de asignaturas impartidas por dicho profesor.

alter table profesor add column total_asignaturas int default 0;

delimiter //
create trigger ActualizarTotalAsignaturasProfesor
after insert on asignatura
for each row
begin
	declare total_asignaturas_interna int;
    -- Obtener el total de asignaturas actuales del docente
    select count(*) into total_asignaturas_interna
    from asignatura
    where id_profesor = new.id_profesor;
    
    -- Actualizar el total de asignaturas
    -- impartidas por el docente
    update profesor 
    set total_asignaturas = total_asignaturas_interna
    where id = new.id_profesor;
    
end //
delimiter ;

create table auditoria(
	id_auditoria int unsigned auto_increment primary key,
    fecha_creacion date not null,
    accion varchar(255) not null,
    id_alumno int unsigned not null,
    foreign key(id_alumno) references Alumno(id_alumno)
);

delimiter //
create trigger AuditarActualizacionAlumno
after update on alumno
for each row
begin
	declare modificacion varchar(255);
end 
// delimiter ;

-- 2. Cada vez que se modifica un registro de un alumno, guarda el cambio en una tabla de auditoría.
-- 3. Al modificar los créditos de una asignatura, guarda un historial de los cambios.
-- 4. Registra una notificación cuando se elimina una matrícula de un alumno.
-- 5. Evita que un profesor tenga más de 10 asignaturas asignadas en un semestre.