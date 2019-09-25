-- RELACIÓN 1
-- select * from sol_R_E;

-- 1. OK
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
where email like '%lcc.uma.es'; -- hay que usar LIKE, = no vale...

-- 4.
select nombre, apellido1, apellido2,  email
from alumnos
where email is null; 
-- no puedo poner email = null, no aparece nadie que cumpla eso. Ninguna fila hace true ese predicado.

-- 5.
select nombre, curso, teoricos, practicos, teoricos+practicos, (teoricos*100)/(teoricos+practicos) "% TEORICO", (practicos*100)/(teoricos+practicos) "% PRACTICOS"
from asignaturas
where curso = 3;
-- hay un fallo al meter los datos en la fila 2; deberían ser 8 créditos en total.

-- otra forma:
select nombre, creditos, round ((teoricos*100)/(teoricos+practicos), 2) as teor, round((practicos*100)/(teoricos+practicos), 2) as pract
from asignaturas
where curso = 3;
-- redondeo a 2 decimales
-- uso as en vez de ""

-- 6.
select alumno, calificacion
from matricular
where asignatura = 112
order by alumno;

-- 7.
select nombre, hombres, mujeres, hombres+mujeres
from municipio;
-- ¿Cómo se haría para sumar la población de cada uno de los municipios para saber la población total de todos los municipios de España?

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


-- otra manera de hacerlo: usando concat de forma anidada (para concatenar más de dos strings)

select concat(concat(concat(concat(concat(concat('El alumno ', nombre), ' ' ), apellido1), ' '), apellido2), ' no dispone de correo') "Correos"
from alumnos
where email is null
      and genero = 'MASC'
      
union


select concat(concat(concat(concat(concat(concat('La alumna ', nombre), ' ' ), apellido1), ' '), apellido2), ' no dispone de correo')
from alumnos
where email is null
      and genero like 'FEM'; 

-- otra forma de hacerlo es con la función decode

select decode('MASC',genero, 'El alumno ', 'La alumna ')||nombre||' '||apellido1||' '||apellido2|| ' no dispone de correo'
from alumnos
where email is null;
      
-- 9.
select nombre, apellido1, apellido2, antiguedad, antiguedad-to_date('01/01/1990', 'dd/mm/yyyy')
from profesores
where antiguedad-to_date('01/01/1990', 'dd/mm/yyyy') < 0;
-- paso a tipo fecha la fecha que me indican y calculo la diferencia en días entre esa fecha y las demás fechas de ingreso.
-- si la fecha2 es más reciente que fecha1, el resultado estará en negativo.
-- eso quiere decir que me interesan los resultados negativos ya que significa que el ingreso se produjo antes de 01/01/1990

-- otra forma de hacerlo: usando la función EXTRACT
select nombre, apellido1, apellido2, antiguedad, extract (year from antiguedad)
from profesores
where extract (year from antiguedad) < 1990;
-- esta solución es menos precisa ya que sólo indica el año

-- 10.
select nombre, apellido1, apellido2, fecha_nacimiento, trunc((months_between(sysdate, fecha_nacimiento))/12) as EDAD
from profesores
where trunc((months_between(sysdate, fecha_nacimiento))/12) < 30;
-- Consigo el número de años y lo trunco. Luego filtro para que salgan los que tienen menos de 30 años.

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

-- RECORDATORIO
select nombre from profesores where nombre like 'Ma%'; -- que empiece por Ma
select nombre from profesores where nombre like '%io'; -- que acabe en io
select nombre from profesores where nombre like '%ar%'; -- que contenga una ar

-- otra forma

select nombre, nvl(to_char(creditos), 'No asignado'), caracter
from asignaturas
where caracter like 'O%';

-- 14.
select dni, nombre, apellido1, apellido2, fecha_prim_matricula,  trunc(months_between(sysdate, fecha_prim_matricula)) as meses_matriculado
from alumnos
where (months_between(sysdate, fecha_prim_matricula)) < 2;

-- RECORDATORIO
select nombre, departamento from profesores where departamento between 1 and 3;
-- El operador between saca los valores comprendidos entre los valores indicados, no que sólo saque esos dos valores indicados.

-- 15.
select nombre, fecha_nacimiento, fecha_prim_matricula, trunc(months_between(fecha_prim_matricula, fecha_nacimiento)/12) as años_prim_matricula
from alumnos
where (months_between(fecha_prim_matricula, fecha_nacimiento)/12) < 18;

-- 16.
select nombre, fecha_prim_matricula, to_char(fecha_prim_matricula, 'Day') as día_matriculación
from alumnos
where to_char(fecha_prim_matricula, 'Day') like 'Lunes%';
-- mucho cuidado con esto, to_char(fecha_prim_matricula, 'Day') saca el día con un espacio después.
-- por tanto, hay que poner like 'Lunes%'



