USE Universidad;

-- 1. Encuentra el profesor que ha impartido más asignaturas en el último año académico.

select p.id, p.nombre, p.apellido1, count(a.id_profesor) as cantidad from profesor p 
inner join asignatura a on p.id = a.id_profesor 
group by 1 order by cantidad desc limit 1;

-- 2. Lista los cinco departamentos con mayor cantidad de asignaturas asignadas.

select d.nombre as nombre_departamento, count(p.id_departamento) as cantidad_asignaturas from departamento d
inner join profesor p on d.id = p.id_departamento
inner join asignatura a on p.id = a.id_profesor
group by 1;

-- 3. Obtenga el total de alumnos y docentes por departamento.

select d.nombre as nombre_departamento, count(a.id) as cantidad_alumnos, count(p.id) as cantidad_profesores from departamento d
inner join profesor p on d.id = p.id_departamento
left join alumno a on p.id = a.id group by 1;

-- 4. Calcula el número total de alumnos matriculados en asignaturas de un género específico en un semestre determinado.

select * from alumno;
select * from asignatura;
select a.nombre, count(am.id_alumno) as total from alumno al 
inner join alumno_se_matricula_asignatura am on al.id = am.id_alumno 
inner join asignatura a on am.id_alumno = a.id where a.tipo = 'basica' group by 1;

-- 5. Encuentra los alumnos que han cursado todas las asignaturas de un grado específico.

select al.nombre from alumno al 
inner join asignatura ag on al.id = ag.id 
inner join grado g on ag.id = g.id where g.nombre = 'Grado en Ingeniería Agrícola (Plan 2015)';

-- 6. Lista los tres grados con mayor número de asignaturas cursadas en el último semestre.

select g.nombre, count(a.id_grado) as num_asignaturas from grado g 
inner join asignatura a on g.id = a.id_grado group by 1;

-- 7. Muestra los profesores con menos asignaturas impartidas en el último año académico.

select p.id, p.nombre, p.apellido1, count(a.id_profesor) as cantidad from profesor p 
inner join asignatura a on p.id = a.id_profesor 
group by 1 order by cantidad asc;

-- 8. Calcula el promedio de edad de los alumnos al momento de su primera matrícula. ------------------------------------------------------------------------
select avg(timestampdiff(year, a.fecha_nacimiento, ce.anyo_inicio)) as promedio_edad from alumno a
inner join alumno_se_matricula_asignatura asm on a.id = asm.id_alumno
inner join curso_escolar ce on asm.id_curso_escolar = ce.id
group by a.id; 

-- 9. Encuentra los cinco profesores que han impartido más clases de un mismo grado.

select distinct p.nombre, p.apellido1, g.nombre, count(p.id) as cantidad from profesor p 
inner join asignatura a on p.id = a.id_profesor 
inner join grado g on a.id_grado = g.id group by 1, 2, 3;

-- 10. Genera un informe con los alumnos que han cursado más de 10 asignaturas en el último año.

select al.nombre, al.apellido1, a.nombre, count(a.id) as alumnos from alumno al 
inner join alumno_se_matricula_asignatura am on al.id = am.id_alumno 
inner join asignatura a on am.id_alumno = a.id
inner join curso_escolar c on am.id_curso_escolar = c.id where c.anyo_fin = 2018 group by 1, 2, 3;

-- 11. Calcula el promedio de créditos de las asignaturas por grado.

select avg(a.creditos) as promedio from asignatura a 
inner join grado g on a.id_grado = g.id
group by g.id;

-- 12. Lista las cinco asignaturas más largas (en horas) impartidas en el último semestre.
select s.nombre, s.horas from asignatura s where s.cuatrimestre = 2 order by s.horas desc limit 5;

-- 13. Muestra los alumnos que han cursado más asignaturas de un género específico.
select a.id, a.nombre, count(asm.id_asignatura) as num_asignaturas from alumno a
inner join alumno_se_matricula_asignatura asm on a.id = asm.id_alumno
inner join asignatura s on asm.id_asignatura = s.id
where a.sexo = 'H' group by a.id order by num_asignaturas desc;

-- 14. Calcula la cantidad total de horas cursadas por cada alumno en el último semestre.
select a.id, a.nombre, sum(s.horas) as total_horas from alumno a
inner join alumno_se_matricula_asignatura asm on a.id = asm.id_alumno
inner join asignatura s on asm.id_asignatura = s.id
where s.cuatrimestre = 2 group by a.id;

-- 15. Muestra el número de asignaturas impartidas diariamente en cada mes del último trimestre. --------------------------------------------------------------------
select month(ce.anyo_inicio) as mes, count(s.id) as num_asignaturas from curso_escolar ce
inner join asignatura s on ce.id = s.id_grado
where ce.anyo_inicio between year(curdate()) - 1 and year(curdate()) group by mes;

-- 16. Calcula el total de asignaturas impartidas por cada profesor en el último semestre.
select p.id, p.nombre, count(s.id) as total_asignaturas from profesor p
inner join asignatura s on p.id = s.id_profesor
where s.cuatrimestre = 2 group by p.id;

-- 17. Encuentra al alumno con la matrícula más reciente.
select a.id, a.nombre from alumno a
inner join alumno_se_matricula_asignatura asm on a.id = asm.id_alumno
order by asm.id_curso_escolar desc limit 1;

-- 18. Lista los cinco grados con mayor número de alumnos matriculados durante los últimos tres meses. ---------------------------------------------
select g.nombre, count(distinct a.id) as num_alumnos from grado g
inner join asignatura s on g.id = s.id_grado
inner join alumno_se_matricula_asignatura asm on s.id = asm.id_asignatura
inner join alumno a on asm.id_alumno = a.id
where asm.id_curso_escolar in (select id from curso_escolar where anyo_inicio = year(curdate()))
group by g.id order by num_alumnos desc limit 5;

-- 19. Obtenga la cantidad de asignaturas cursadas por cada alumno en el último semestre.
select a.id, a.nombre, count(asm.id_asignatura) as num_asignaturas from alumno a
inner join alumno_se_matricula_asignatura asm on a.id = asm.id_alumno
inner join asignatura s on asm.id_asignatura = s.id
where s.cuatrimestre = 2 group by a.id;

-- 20. Lista los profesores que no han impartido clases en el último año académico. ---------------------------------
select p.id, p.nombre from profesor p
inner join asignatura a on p.id = a.id_profesor
inner join curso_escolar ce on ce.id = a.id_grado
where ce.anyo_inicio = year(curdate()) - 1 and a.id is null;