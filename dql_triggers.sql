USE Universidad;

alter table profesor add column total_asignaturas int default 0;

-- 1. Al asignar una nueva asignatura a un profesor, 
-- actualiza el total de asignaturas impartidas por dicho profesor.
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

-- 2. Cada vez que se modifica un registro de un alumno, guarda el cambio en una tabla de auditoría.
create table auditoria(
	id_auditoria int unsigned auto_increment primary key,
    fecha_creacion date not null,
    accion varchar(255) not null,
    id_alumno int not null,
    foreign key(id_alumno) references alumno(id)
);

delimiter //
create trigger AuditarActualizacionAlumno
after update on alumno
for each row
begin
	if old.telefono != new.telefono then
		insert into auditoria (id_alumno, fecha_creacion, accion)
		values (new.id, now(), concat('Actualizaste: ', old.telefono, ' -> ', new.telefono));
	end if;
end // 
delimiter ;
update alumno set telefono = '123456789' where id = 1;
SELECT * FROM auditoria;

-- 3. Al modificar los créditos de una asignatura, guarda un historial de los cambios.
create table historial_creditos (
	id_historial int unsigned auto_increment primary key,
    fecha_modificacion date not null,
    creditos varchar(255) not null,
    id_asignatura int not null,
    foreign key(id_asignatura) references asignatura(id)
);

delimiter //
create trigger RegistrarHistorialCreditos
after update on asignatura
for each row
begin
	if old.creditos != new.creditos then
		insert into historial_creditos (fecha_modificacion, creditos, id_asignatura)
        values (now(), concat('Actualizaste: ', old.creditos, ' -> ', new.creditos), new.id);
	end if;
end // 
delimiter ;
update asignatura set creditos = '7' where id = 1;
select * from historial_creditos;

-- 4. Registra una notificación cuando se elimina una matrícula de un alumno. id, idalumno,fechacancelacion,motivocancelacion
create table notificaciones (
	id int unsigned auto_increment primary key,
    fecha_cancelacion date not null,
    motivo varchar(255) not null,
    id_alumno int not null,
    id_asignatura int not null,
    id_curso_escolar int not null,
    foreign key(id_alumno) references alumno(id),
    foreign key(id_asignatura) references asignatura(id),
    foreign key(id_curso_escolar) references curso_escolar(id)
);

-- drop trigger NotificarCancelacionMatricula;
delimiter //
create trigger NotificarCancelacionMatricula
after delete on alumno_se_matricula_asignatura
for each row
begin
	insert into notificaciones (fecha_cancelacion, motivo, id_alumno, id_asignatura, id_curso_escolar)
    values (now(), 'Matrícula cancelada', old.id_alumno, old.id_asignatura, old.id_curso_escolar);
end // 
delimiter ; 

delete from alumno_se_matricula_asignatura where id_alumno = 1 and id_asignatura = 3 and id_curso_escolar = 1;
select * from notificaciones;

-- 5. Evita que un profesor tenga más de 10 asignaturas asignadas en un semestre.
delimiter //
create trigger RestringirAsignacionExcesiva
before insert on asignatura
for each row
begin
	declare cant_asignaturas int;
    
    select count(*) into cant_asignaturas from asignatura
    where id_profesor = new.id_profesor and cuatrimestre = new.cuatrimestre;
    
    if cant_asignaturas >= 10 then
		signal sqlstate '45000' set message_text = 'El profesor no puede tener más de 10 asignaturas asignadas en un semestre';
    end if;
end  //
delimiter ;

insert into asignatura (id, nombre, creditos, tipo, curso, cuatrimestre, horas, id_profesor, id_grado)
values (84, 'Matemáticas I', 6, 'básica', 1, 1, 30, 3, 1);

insert into asignatura (id, nombre, creditos, tipo, curso, cuatrimestre, horas, id_profesor, id_grado)
values (85, 'Matemáticas I', 6, 'básica', 1, 1, 30, 3, 1);

insert into asignatura (id, nombre, creditos, tipo, curso, cuatrimestre, horas, id_profesor, id_grado)
values (86, 'Matemáticas I', 6, 'básica', 1, 1, 30, 3, 1);

insert into asignatura (id, nombre, creditos, tipo, curso, cuatrimestre, horas, id_profesor, id_grado)
values (87, 'Matemáticas I', 6, 'básica', 1, 1, 30, 3, 1);

insert into asignatura (id, nombre, creditos, tipo, curso, cuatrimestre, horas, id_profesor, id_grado)
values (88, 'Matemáticas I', 6, 'básica', 1, 1, 30, 3, 1);

insert into asignatura (id, nombre, creditos, tipo, curso, cuatrimestre, horas, id_profesor, id_grado)
values (89, 'Matemáticas I', 6, 'básica', 1, 1, 30, 3, 1);

insert into asignatura (id, nombre, creditos, tipo, curso, cuatrimestre, horas, id_profesor, id_grado)
values (90, 'Matemáticas I', 6, 'básica', 1, 1, 30, 3, 1);

insert into asignatura (id, nombre, creditos, tipo, curso, cuatrimestre, horas, id_profesor, id_grado)
values (91, 'Matemáticas I', 6, 'básica', 1, 1, 30, 3, 1);

insert into asignatura (id, nombre, creditos, tipo, curso, cuatrimestre, horas, id_profesor, id_grado)
values (92, 'Matemáticas I', 6, 'básica', 1, 1, 30, 3, 1);