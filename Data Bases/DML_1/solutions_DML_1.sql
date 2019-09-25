-- Author: Salvi CF

-- DML 1 solutions

-- 1. 
select nombre, apellido1, apellido2, departamento
from profesores
where departamento = 1;

-- 2.
select nombre, apellido1, apellido2, departamento
from profesores
where departamento != 3;

-- 3.
select nombre, apellido1, apellido2, email
from profesores
where email like '%lcc.uma.es';

-- 4.
select nombre, apellido1, apellido2,  email
from alumnos
where email is null;

-- 5.
select nombre, curso, teoricos, practicos, teoricos+practicos, (teoricos*100)/(teoricos+practicos) "% TEORICO", (practicos*100)/(teoricos+practicos) "% PRACTICOS"
from asignaturas
where curso = 3;

-- otra forma:
select nombre, creditos, round ((teoricos*100)/(teoricos+practicos), 2) as teor, round((practicos*100)/(teoricos+practicos), 2) as pract
from asignaturas
where curso = 3;

-- 6.
select alumno, calificacion
from matricular
where asignatura = 112
order by alumno;

-- 7.
select nombre, hombres, mujeres, hombres+mujeres
from municipio;

-- USO DE FUNCIONES

-- 8.
select 'El alumno ' || nombre || ' ' || apellido1 || ' ' || apellido2 || ' no dispone de correo' as Correos
from alumnos
where email is null
      and genero = 'MASC'
      
union


select 'La alumna ' || nombre || ' ' || apellido1 || ' ' || apellido2 || ' no dispone de correo'
from alumnos
where email is null
      and genero like 'FEM'; 


-- otra manera:

select concat(concat(concat(concat(concat(concat('El alumno ', nombre), ' ' ), apellido1), ' '), apellido2), ' no dispone de correo') "Correos"
from alumnos
where email is null
      and genero = 'MASC'
      
union


select concat(concat(concat(concat(concat(concat('La alumna ', nombre), ' ' ), apellido1), ' '), apellido2), ' no dispone de correo')
from alumnos
where email is null
      and genero like 'FEM'; 

-- otra forma:

select decode('MASC',genero, 'El alumno ', 'La alumna ')||nombre||' '||apellido1||' '||apellido2|| ' no dispone de correo'
from alumnos
where email is null;
      
-- 9.
select nombre, apellido1, apellido2, antiguedad, antiguedad-to_date('01/01/1990', 'dd/mm/yyyy')
from profesores
where antiguedad-to_date('01/01/1990', 'dd/mm/yyyy') < 0;

-- otra forma de hacerlo:
select nombre, apellido1, apellido2, antiguedad, extract (year from antiguedad)
from profesores
where extract (year from antiguedad) < 1990;

-- 10.
select nombre, apellido1, apellido2, fecha_nacimiento, trunc((months_between(sysdate, fecha_nacimiento))/12) as EDAD
from profesores
where trunc((months_between(sysdate, fecha_nacimiento))/12) < 30;

-- 11.
select upper(nombre), upper(apellido1), upper(apellido2), trunc(months_between(sysdate, antiguedad)/12/3) as trienios_docencia
from profesores
where trunc(months_between(sysdate, antiguedad)/12/3) > 3;

-- 12.
select nombre, upper(replace(nombre, 'Bases', 'Almacenes'))
from asignaturas
where nombre like '%Bases de Datos%'; -- el % debe ir delante, no detrás.

-- Otra forma

select replace(upper(nombre), 'BASES DE DATOS', 'ALMACENES DE DATOS')
from asignaturas
where lower (nombre) like '%bases de datos%';

-- 13.
select nombre, nvl(to_char(creditos), 'NO ASIGNADO'), caracter
from asignaturas
where caracter = 'OP' or caracter = 'OB'; 

-- puedo simplificar la consulta ya que OP y OB son las únicas que empiezan por O:

select nombre, nvl(to_char(creditos), 'NO ASIGNADO'), caracter
from asignaturas
where caracter like 'O%'; --(también puedo usar 0% o O_)

-- otra forma

select nombre, nvl(to_char(creditos), 'No asignado'), caracter
from asignaturas
where caracter like 'O%';

-- 14.
select dni, nombre, apellido1, apellido2, fecha_prim_matricula,  trunc(months_between(sysdate, fecha_prim_matricula)) as meses_matriculado
from alumnos
where (months_between(sysdate, fecha_prim_matricula)) < 2;

-- 15.
select nombre, fecha_nacimiento, fecha_prim_matricula, trunc(months_between(fecha_prim_matricula, fecha_nacimiento)/12) as años_prim_matricula
from alumnos
where (months_between(fecha_prim_matricula, fecha_nacimiento)/12) < 18;

-- 16.
select nombre, fecha_prim_matricula, to_char(fecha_prim_matricula, 'Day') as día_matriculación
from alumnos
where to_char(fecha_prim_matricula, 'Day') like 'Lunes%';