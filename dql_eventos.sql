USE Universidad;

-- 1. Genera un informe mensual con el total de alumnos matriculados por grado y lo almacena automáticamente.
create table informe_mensual_matriculas(
	id int unsigned auto_increment primary key,
    grado_id int not null,
    total_alumnos int not null,
    fecha_informe datetime not null,
    foreign key(grado_id) references grado(id)
);

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
alter table departamento add column horas_impartidas int default 0;

delimiter //
create event ActualizarHorasDepartamento
on schedule every 6 month
do
begin
	update departamento d
    inner join (
    select p.id_departamento, sum(a.horas) as total_horas
    from asignatura a
    inner join profesor p on a.id_profesor = p.id
    group by p.id_departamento)
    as horas_totales
    on d.id = horas_totales.id_departamento
    set d.horas_impartidas = horas_totales.total_horas;
end //
delimiter ;

-- 3. Envía una alerta cuando una asignatura no ha sido cursada en el último año.
create table alertas (
	id int primary key auto_increment,
    id_asignatura int not null,
    mensaje varchar(255),
    fecha_alerta datetime,
    foreign key(id_asignatura) references asignatura(id)
);

delimiter //
create event AlertaAsignaturaNoCursadaAnual
on schedule every 1 year
do
begin
	insert into alertas (id_asignatura, mensaje, fecha_alerta)
    select a.id, 'La asignatura no ha sido cursada en el último año', now()
    from asignatura a
    left join alumno_se_matricula_asignatura am on a.id = am.id_asignatura
    where am.id_alumno is null and a.cuatrimestre < year(now()) -1;
end //
delimiter ;

-- 4. Borra los registros antiguos de auditoría al final de cada semestre.
delimiter //
create event LimpiarAuditoriaCadaSemestre
on schedule every 6 month
do
begin
	delete from auditoria where fecha_creacion < date_sub(now(), interval 6 month);
end  //
delimiter ;
-- 5. Actualiza la lista de profesores destacados al final de cada semestre basándose en evaluaciones y desempeño.