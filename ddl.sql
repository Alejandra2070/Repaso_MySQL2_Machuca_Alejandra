CREATE DATABASE Universidad;

USE Universidad;

-- DROP DATABASE Universidad;
CREATE TABLE departamento(
	id INT(10) PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE profesor(
	id INT(10) PRIMARY KEY,
    nif VARCHAR(9),
    nombre VARCHAR(25),
    apellido1 VARCHAR(25),
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25),
    direccion VARCHAR(50),
    telefono VARCHAR(9) NULL,
    fecha_nacimiento DATE,
    sexo ENUM('H', 'M'),
    id_departamento INT(10),
    FOREIGN KEY(id_departamento) REFERENCES departamento(id)
);

CREATE TABLE grado(
	id INT(10) PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE asignatura(
	id INT(10) PRIMARY KEY,
    nombre VARCHAR(100),
    creditos FLOAT,
    tipo ENUM('basica', 'optativa', 'obligatoria'),
    curso TINYINT(3),
    cuatrimestre TINYINT(3),
    horas INT(10),
    id_profesor INT(10) NULL,
    id_grado INT(10),
    FOREIGN KEY(id_profesor) REFERENCES profesor(id),
    FOREIGN KEY(id_grado) REFERENCES grado(id)
);

CREATE TABLE alumno(
	id INT(10) PRIMARY KEY,
    nif VARCHAR(9),
	nombre VARCHAR(25),
    apellido1 VARCHAR(25),
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25),
    direccion VARCHAR(50),
    telefono VARCHAR(9) NULL,
    fecha_nacimiento DATE,
    sexo ENUM('H', 'M')
);

CREATE TABLE curso_escolar(
	id INT(10) PRIMARY KEY,
    anyo_inicio YEAR(4),
    anyo_fin YEAR(4)
);

CREATE TABLE alumno_se_matricula_asignatura(
	id_alumno INT(10),
    id_asignatura INT(10),
    id_curso_escolar INT(10),
    FOREIGN KEY(id_alumno) REFERENCES alumno(id),
    FOREIGN KEY(id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY(id_curso_escolar) REFERENCES curso_escolar(id)
);