# EL UNIVERSITARIO

 En este repositorio se encuentra la realización del filtro asignado para la evaluación del módulo MySQL 2.

 ## Descripción del proyecto

 La realización de esta base de datos tiene como objetivo el diseño y desarrollo para el gestionamiento de manera eficiente de una Universidad.

## Metodología

Se podrán observar los distintos archivos sql que están en este repositorio, los cuales están divididos en creación de tablas, inserciones de datos, consultas, funciones y triggers para dar una mejor organización y entendimiento a la base de datos. Aparte de estos archivos sql, tenemos un archivo png que es donde se podrá ver el diseño del módelo físico.

## Beneficios del Sistema

Esta base de datos cuenta con varios beneficios como los siguientes: 

- Organización y eficiencia

- Reducción de la redundancia de datos

- Integridad de datos

 ## Requisitos del sistema

En esta base de datos se utilizó **MySQL 8.0** y **MySQL Workbench** como software necesario.

## Instalación y configuración

Para configurar e instalar el entorno y cargar la base de datos podemos seguir estos pasos:

**1. Instalación de MySQL Server**

**2. Instalar MySQL Workbench**

**3. Configurar la conexión**

**4. Verificar abriendo los archivos sql:**

- **ddl.sql** para la creación de la base de datos con sus tablas y relaciones.

- **dml.sql** para la inserción de datos.

- **dql_select.sql** para la ejecución de las consultas.

- **dql_funciones** para la ejecución de las funciones.

- **dql_triggers.sql** para la ejecución de triggers

- **dql_eventos.sql** para la ejecución de eventos

## Instalación general

La gestión de datos **Universidad** se distribuye en ocho archivos SQL y algunos archivos adicionales para facilitar su implementación y manejo.

## Archivos adicionales

- README
- Diagrama.jpg

## Estructura de la Base de Datos
|Tabla|Descripción|
|--|--|
|**Departamento**|Son los departamentos en los que los profesores están asignados.|
|**Profesor**|En esta tabla está toda la información personal de los profesores.|
|**Grado**|Grados disponibles que dicta la universidad.|
|**Asignatura**|Materias disponibles para que los estudiantes las matriculen.|
|**Alumno**|En esta tabla está toda la información personal de los alumnos.|
|**Curso_escolar**|En esta tabla está la información de cuando inicia y cuando finaliza el curso.|
**Alumno_se_matricula_asignatura**|Esta tabla se utiliza para generar informes, ya que contiene la información de cada estudiante, sus asignaturas y cursos en los que está matriculado.|

## **Ejemplo de Consultas**

- Son 20 consultas en total, pero se mostrará solo cinco ejemplos de las realizadas

**1. Encuentra el profesor que ha impartido más asignaturas en el último año académico.**
``` sql
select p.id, p.nombre, p.apellido1, count(a.id_profesor) as cantidad 
from profesor p 
inner join asignatura a on p.id = a.id_profesor 
group by 1 order by cantidad desc limit 1;
```
**2. Encuentra los alumnos que han cursado todas las asignaturas de un grado específico.**
``` sql
select al.nombre from alumno al 
inner join asignatura ag on al.id = ag.id 
inner join grado g on ag.id = g.id 
where g.nombre = 'Grado en Ingeniería Agrícola (Plan 2015)';
```
**3. Genera un informe con los alumnos que han cursado más de 10 asignaturas en el último año.**
``` sql
select al.nombre, al.apellido1, a.nombre, count(a.id) as alumnos 
from alumno al 
inner join alumno_se_matricula_asignatura am on al.id = am.id_alumno 
inner join asignatura a on am.id_alumno = a.id
inner join curso_escolar c on am.id_curso_escolar = c.id 
where c.anyo_fin = 2018 group by 1, 2, 3;
```
**4. Calcula el total de asignaturas impartidas por cada profesor en el último semestre.**
``` sql
select p.id, p.nombre, count(s.id) as total_asignaturas 
from profesor p
inner join asignatura s on p.id = s.id_profesor
where s.cuatrimestre = 2 group by p.id;
```
**5. Obtenga la cantidad de asignaturas cursadas por cada alumno en el último semestre.**
``` sql
select a.id, a.nombre, count(asm.id_asignatura) as num_asignaturas 
from alumno a
inner join alumno_se_matricula_asignatura asm on a.id = asm.id_alumno
inner join asignatura s on asm.id_asignatura = s.id
where s.cuatrimestre = 2 group by a.id;
```

## **Ejemplo de Funciones**

- Son 5 funciones en total, pero se mostrará un solo ejemplo de ellas

 **1. Retorna el promedio de horas de clases para una asignatura.**
``` sql
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
```

## **Ejemplo de Triggers**

- Son 5 triggers en total, pero se mostrará un solo ejemplo de ellos

**1. Cada vez que se modifica un registro de un alumno, guarda el cambio en una tabla de auditoría.**

- Primero creamos la tabla de auditoria necesaria para el correcto funcionamiento del trigger
``` sql
create table auditoria(
	id_auditoria int unsigned auto_increment primary key,
    fecha_creacion date not null,
    accion varchar(255) not null,
    id_alumno int not null,
    foreign key(id_alumno) references alumno(id)
);
```
- Luego, creamos el trigger y lo que este realizará
``` sql
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
```

- Por último, tenemos un ejemplo de implementación
``` sql
update alumno set telefono = '123456789' where id = 1;
SELECT * FROM auditoria;
```

## **Ejemplos de Eventos**

- Son 5 eventos en total, pero se mostrará un solo ejemplo de ellos

**1. Actualiza el total de horas impartidas por cada departamento al final de cada semestre.**

- Primero le agregamos una columna a la tabla de departamento para que el evento cumpla correctamente con su función.
``` sql
alter table departamento add column horas_impartidas int default 0;
```

- Seguido a esto, creamos el evento y específicamos lo que este realizará.
``` sql
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
```

## Desarrollado por

 El proyecto fue desarrollado por Alejandra Machuca, estudiante de CampusLands, como repaso de módulo.