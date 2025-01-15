use Universidad;

-- 1. Calcula el total de créditos cursados por un alumno en un año específico.
delimiter //
create function TotalCreditosAlumno(AlumnoID int, Anio int)
returns float
deterministic
begin
    declare total_creditos float;

    select sum(a.creditos)
    into total_creditos
    from asignatura a
    inner join alumno_se_matricula_asignatura am on a.id = am.id_asignatura
    inner join curso_escolar ce on am.id_curso_escolar = ce.id
    where am.id_alumno = AlumnoID
    and ce.anyo_inicio <= Anio
    and ce.anyo_fin >= Anio;

    return total_creditos;
end //
delimiter ;

-- 2. Retorna el promedio de horas de clases para una asignatura.
delimiter //
create function PromedioHorasPorAsignatura(AsignaturaID int)
returns float
deterministic
begin
    declare promedio_horas float;

    select avg(a.horas)
    into promedio_horas
    from asignatura a
    where a.id = AsignaturaID;

    return promedio_horas;
end //
delimiter ;

-- 3. Calcula la cantidad total de horas impartidas por un departamento específico.
delimiter //
create function TotalHorasPorDepartamento(DepartamentoID int)
returns int
deterministic
begin
    declare total_horas int;

    select sum(a.horas)
    into total_horas
    from asignatura a
    inner join profesor p on a.id_profesor = p.id
    where p.id_departamento = DepartamentoID;

    return total_horas;
end //
delimiter ;

-- 4. Verifica si un alumno está activo en el semestre actual basándose en su matrícula.
delimiter //
create function VerificarAlumnoActivo(AlumnoID int)
returns boolean
deterministic
begin
    declare activo boolean;

    select count(*)
    into activo
    from alumno_se_matricula_asignatura am
    inner join curso_escolar ce on am.id_curso_escolar = ce.id
    where am.id_alumno = AlumnoID
    and ce.anyo_inicio <= year(current_date)
    and ce.anyo_fin >= year(current_date);

    return activo > 0;
end //
delimiter ;

-- 5. Verifica si un profesor es "VIP" basándose en el número de asignaturas impartidas y evaluaciones de desempeño.
delimiter //
create function EsProfesorVIP(ProfesorID int)
returns boolean
deterministic
begin
    declare asignaturas_impartidas int;

    select count(*)
    into asignaturas_impartidas
    from asignatura a
    where a.id_profesor = ProfesorID;

    return asignaturas_impartidas >= 5; 
end //
delimiter ;