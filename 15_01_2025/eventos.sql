USE universidad_t2;

-- OJO: Hay que tner una tabla que almacene el informe 
-- mensual del total de alumnos. Se propone la siguiente
-- tabla:
create table informe_mensual_matriculas(
	id int unsigned auto_increment primary key,
    grado_id int unsigned not null,
    total_alumnos int not null,
    fecha_informe datetime not null,
    foreign key(grado_id) references grado(id)
);

-- 1. Genera un informe mensual con el total de alumnos matriculados por grado y lo almacena automáticamente.
delimiter //
create event ReporteMensualDeAlumnos
on schedule every 1 month
do
begin
	insert into informe_mensual_matriculas
    (grado_id, total_alumnos, fecha_informe)
    select id_grado, count(id_alumno), NOW()
    from alumno_se_matricula_asignatura
    group by id_grado;
end // 
delimiter ;



-- 2. Actualiza el total de horas impartidas por cada departamento al final de cada semestre.
-- 3. Envía una alerta cuando una asignatura no ha sido cursada en el último año.
-- 4. Borra los registros antiguos de auditoría al final de cada semestre.
-- 5. Actualiza la lista de profesores destacados al final de cada semestre basándose en evaluaciones y desempeño.