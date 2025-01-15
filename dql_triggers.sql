USE Universidad;

-- 1. Al asignar una nueva asignatura a un profesor, 
-- actualiza el total de asignaturas impartidas por dicho profesor.
delimiter //
create trigger ActualizarTotalAsignaturasProfesor
after insert on asignatura
for each row
begin
    declare total_asignaturas int;

    select count(*) 
    into total_asignaturas
    from asignatura 
    where id_profesor = new.id_profesor;

    update profesor
    set total_asignaturas = total_asignaturas
    where id = new.id_profesor;
end //
delimiter ;

-- 2. Cada vez que se modifica un registro de un alumno, guarda el cambio en una tabla de auditoría.
-- 3. Al modificar los créditos de una asignatura, guarda un historial de los cambios.
-- 4. Registra una notificación cuando se elimina una matrícula de un alumno.
-- 5. Evita que un profesor tenga más de 10 asignaturas asignadas en un semestre.