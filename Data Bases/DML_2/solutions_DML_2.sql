 -- RELACIÓN 2 Funciones, Reuniones y Operaciones de Conjuntos
-- select * from sol_R_E;

-------------------- Reunión de tablas------------------------------------------------------------------------------------
-- Ejercicio 1
select p.nombre, p.apellido1, p.apellido2, d.nombre
from profesores p, departamentos d
where p.departamento = d.codigo             -- Asignación de cada profesor con su departamento
      and d.nombre like 'Lenguaje%';        -- Además, que el nombre del departamento empiece por Lenguaje
      
-- Ejercicio 2
select a.nombre, a.apellido1, a.apellido2, m.asignatura, asig.nombre, m.curso, nvl(to_char(asig.practicos), 'No tiene')
from alumnos a, matricular m, asignaturas asig
where a.dni = m.alumno 
      and upper(a.nombre) = 'NICOLAS'
      and upper(a.apellido1) = 'BERSABE'
      and upper(a.apellido2) = 'ALBA'
      and asig.codigo = m.asignatura;
 
-- Otra manera de hacerlo (la veré más adelante)
select asig.codigo, asig.nombre, nvl(to_char(practicos), 'No tiene') PRACTICOS, mat.curso -- tengo que pasarlo a char porque son números...
from asignaturas asig join matricular mat on(asig.codigo = mat.asignatura)
                      join alumnos alum on(mat.alumno = alum.dni)
where alum.nombre = 'Nicolas' 
      and alum.apellido1 = 'Bersabe'
      and alum.apellido2 = 'Alba';  
      
-- Ejercicio 3
select p.nombre, p.apellido1, p.apellido2, d.nombre, trunc((sysdate - p.antiguedad)/7) as SEMANAS_DOCENCIA, next_day(sysdate, to_char(antiguedad, 'day')) "Se cumple semana"
from profesores p, departamentos d
where p.departamento = d.codigo
      and d.nombre = 'Ingenieria de Comunicaciones';

-- Ejercicio 4
select a.dni, a.nombre, a.apellido1, a.apellido2 
from alumnos a, matricular m, asignaturas asig
where a.dni = m.alumno
      and m.asignatura = asig.codigo
      and asig.nombre = 'Bases de Datos'
      and m.calificacion != 'SP';

-- Ejercicio 5
select p.id, p.nombre, p.apellido1, p.apellido2, a.codigo, a.nombre
from profesores p, impartir i, asignaturas a
where p.id = i.profesor
      and i.asignatura = a.codigo;
      
-------------------- Consultas reflexivas ------------------------------------------------------------------------------------ 
-- Ejercicio 6 (debo hacer que ROMERO y Romero se cuente en la solución!)
select a1.nombre, trunc(months_between(sysdate, a1.fecha_nacimiento)/12) "EDAD 1", a2.nombre, trunc(months_between(sysdate, a2.fecha_nacimiento)/12, 0) "EDAD 2"
from alumnos a1, alumnos a2
where upper(a1.apellido1) = upper(a2.apellido1)
      and a1.dni < a2.dni;
      
-- Ejercicio 7 
select alu1.apellido1 "Primer apellido", alu2.apellido1
from alumnos alu1, alumnos alu2
where to_char(alu1.fecha_nacimiento, 'yyyy') between 1995 and 1996
      and to_char(alu2.fecha_nacimiento, 'yyyy') between 1995 and 1996
      and alu1.dni < alu2.dni;

select alu1.apellido1 "Primer apellido", alu2.apellido1
from alumnos alu1, alumnos alu2
where and extract(year from alu1.fecha_nacimiento) between 1995 and 1996
      and extract(year from alu2.fecha_nacimiento) between 1995 and 1996
      and alu1.dni < alu2.dni;

-- Ejercicio 8
select p1.nombre, p1.apellido1, p2.nombre, p2.apellido1, trunc(months_between(sysdate, p1.antiguedad)/12) "Años 1", trunc(months_between(sysdate, p2.antiguedad)/12) "Años 2"
from profesores p1, profesores p2
where p1.departamento = p2.departamento
      and p1.id < p2.id
      and trunc(abs(months_between(p1.antiguedad, p2.antiguedad))/12) < 2;
      
-- Ejercicio 9 (la solución debe estar mal, preguntar al profesor)
select a1.nombre, m1.calificacion, a2.nombre, m2.calificacion
from alumnos a1, alumnos a2, matricular m1, matricular m2
where a1.genero = 'MASC'
      and a2.genero = 'FEM'
      and a1.dni = m1.alumno
      and a2.dni = m2.alumno
      and m1.asignatura = 112
      and m2.asignatura = 112
      and to_char(a1.fecha_prim_matricula, 'ww') = to_char(a2.fecha_prim_matricula, 'ww');
      
-- Ejercicio 9 (preguntar al profesor)-----------------------------------------
select a1.nombre as EL, m1.calificacion, a2.nombre as ELLA, m2.calificacion
from alumnos a1, alumnos a2, matricular m1, matricular m2
where a1.genero = 'MASC'
      and a2.genero = 'FEM'
      and a1.dni = m1.alumno
      and a2.dni = m2.alumno
      and m1.asignatura = 112
      and m2.asignatura = 112
      and m1.curso = m2.curso 
      and to_char(a1.fecha_prim_matricula, 'ww') = to_char(a2.fecha_prim_matricula, 'ww')
      and decode(NVL(m1.calificacion, 'SP'), 'SP', 0, 'AP', 5, 'NT', 8, 'SB', 9, 10) <= decode(NVL(m2.calificacion, 'SP'), 'SP', 0, 'AP', 5, 'NT', 8, 'SB', 9, 10);
  

select alumno, calificacion, decode(NVL(calificacion, 'SP'), 'SP', 0, 'AP', 5, 'NT', 8, 'SB', 9, 10)
from matricular;

-- Ejercicio 9 FINAL
select a1.nombre||' '||a1.apellido1 as EL, decode(m1.calificacion,'MH',10,'SB',9,'NT',7,'AP',5,'SP',2,0) "Nota él", a2.nombre||' '||a2.apellido1 as ELLA, decode(m2.calificacion,'MH',10,'SB',9,'NT',7,'AP',5,'SP',2,0) "Nota ella"
from alumnos a1, alumnos a2, matricular m1, matricular m2
where a1.genero = 'MASC'
      and a2.genero = 'FEM'
      and a1.dni = m1.alumno
      and a2.dni = m2.alumno
      and m1.asignatura = 112
      and m2.asignatura = 112
      and to_char(a1.fecha_prim_matricula, 'ww') = to_char(a2.fecha_prim_matricula, 'ww')
      and decode(m1.calificacion,'MH',10,'SB',9,'NT',7,'AP',5,'SP',2,0) < decode(m2.calificacion,'MH',10,'SB',9,'NT',7,'AP',5,'SP',2,0);
      
select * from sol_2_9;
-- Ejercicio 10
select a1.nombre, a2.nombre, a3.nombre, a1.cod_materia, a2.cod_materia, a3.cod_materia
from asignaturas a1, asignaturas a2, asignaturas a3
where a1.cod_materia = a2.cod_materia
      and a2.cod_materia = a3.cod_materia
      and a1.codigo < a2.codigo
      and a2.codigo < a3.codigo;

-------------------------------------Reunión de tablas + orden-----------------------------------------------------
      
-- Ejercicio 11 (No trunca la edad !)
select alu.nombre, alu.apellido1, alu.apellido2, asig.nombre, decode(mat.calificacion, 'MH', 'Matrícula de honor',
                                                                                       'SB', 'Sobresaliente',
                                                                                       'NT', 'Notable',
                                                                                       'AP', 'Aprobado',
                                                                                       'SP', 'Suspenso',
                                                                                       'No presentado') -- no presentado by default
from alumnos alu, matricular mat, asignaturas asig
where alu.dni = mat.alumno
      and  mat.asignatura = asig.codigo
      and (months_between(sysdate, fecha_nacimiento)/12) > 22
      order by alu.apellido1, alu.nombre;

-- Ejercicio 12
select alu.nombre, alu.apellido1, alu.apellido2
from impartir imp, profesores pro, asignaturas asig, alumnos alu, matricular mat
where imp.profesor=pro.id
      and UPPER(pro.nombre) = 'ENRIQUE'
      and UPPER(pro.apellido1) = 'SOLER'
      and imp.asignatura = asig.codigo
      and alu.dni = mat.alumno
      and mat.asignatura = imp.asignatura
      and mat.curso = imp.curso
      and mat.grupo = imp.grupo
order by alu.apellido1, alu.nombre;

-- otra forma
select alu.nombre, alu.apellido1, alu.apellido2
from alumnos alu, matricular mat natural join impartir imp, profesores pro
where alu.dni = mat.alumno
      and imp.profesor = pro.id
      and pro.nombre = 'Enrique'
      and pro.apellido1 = 'Soler'
order by alu.apellido1, apellido2, nombre;

-- con el natural join reúno las dos tablas con los atributos que se llamen igual (asignatura, grupo, curso)

-- Ejercicio 13-------------------------------------------------------------------
select alu.nombre, alu.apellido1, alu.apellido2
from profesores pro, departamentos dep, impartir imp, alumnos alu, matricular mat
where pro.departamento = dep.codigo
      and dep.nombre = 'Lenguajes y Ciencias de la Computacion'        -- sin acento en computación
      and imp.profesor = pro.id
      and alu.dni = mat.alumno
      and mat.asignatura = imp.asignatura
      and mat.grupo = imp.grupo
      and mat.curso = imp.curso
order by alu.apellido1;

-- otra manera
select distinct alu.nombre, alu.apellido1, alu.apellido2
from profesores pro, departamentos dep, alumnos alu, matricular mat natural join impartir imp
where pro.departamento = dep.codigo
      and imp.profesor = pro.id
      and lower(dep.nombre) = 'lenguajes y ciencias de la computacion'
      and alu.dni = mat.alumno
order by alu.apellido1;

-- Ejercicio 14 ------------------------------------------------------------------
-- La tabla materias no aparece en el modelo pero sí en las diapos. Se llama "materias"
-- El solucionario está mal proque no aparece Ana Jiménez

select asig.nombre as Asignatura, mat.nombre as Materia, pro.nombre||' '||pro.apellido1||' '||pro.apellido2 as Profesor, imp.carga_creditos "CARGA CRÉDITOS"
from profesores pro, impartir imp, asignaturas asig, materias mat
where pro.id = imp.profesor
      and asig.codigo = imp.asignatura
      and mat.codigo = asig.cod_materia
      and imp.carga_creditos is not null
order by mat.codigo, asig.nombre desc   
;

select * from impartir;

-- Ejercicio 15 ---------------------------------------------------------------------
select asig.nombre "Asignatura", dep.nombre "Departamento", asig.creditos "Créditos", round((asig.practicos*100)/asig.creditos, 2) "% Prácticos" 
from asignaturas asig, departamentos dep
where asig.departamento = dep.codigo
      and asig.creditos is not null
      and asig.practicos is not null
      and asig.teoricos is not null
order by round((asig.practicos*100)/asig.creditos, 4) desc
;

-- Ejercicio 16 --------------------------------------------------------------------
(select codigo
from asignaturas)
minus
(select codigo
from asignaturas asig, impartir imp
where asig.codigo = imp.asignatura);


-- Ejercicio 17 -------------------------------------------------------------------
(select email
from profesores
where email is not null)
union all 
(select email
from alumnos
where email is  not null);

-- Ejercicio 18 ------------------------------------------------------------------
--initcap!!
((select initcap(apellido1) from profesores where apellido1 is not null)
intersect
(select initcap(apellido1) from alumnos where apellido1 is not null))
union
((select initcap(apellido1) from profesores where apellido1 is not null)
intersect
(select initcap(apellido2) from alumnos where apellido2 is not null))
union
((select initcap(apellido2) from profesores where apellido2 is not null)
intersect
(select initcap(apellido1) from alumnos where apellido1 is not null))
union
((select initcap(apellido2) from profesores where apellido2 is not null)
intersect
(select initcap(apellido2) from alumnos where apellido2 is not null));

--  mejor opción
select distinct initcap(alu.apellido1)
from alumnos alu, profesores pro
where lower(alu.apellido1) = lower(pro.apellido1) or lower(alu.apellido1) = lower(pro.apellido2)
UNION
select distinct initcap(alu.apellido2)
from alumnos alu, profesores pro
where lower(alu.apellido2) = lower(pro.apellido1) or lower(alu.apellido2) = lower(pro.apellido2);
      
-- Ejercicio 19 ----------------------------------------------------------------
(select apellido1
from profesores where upper(apellido1) like '%LL%')
UNION
(select apellido2
from profesores where upper(apellido2) like '%LL%')
UNION
(select apellido1
from alumnos where upper(apellido1) like '%LL%')
UNION
(select apellido2
from alumnos where upper(apellido2) like '%LL%');


-- Ejercicio 20 ---------------------------------------------------------------------
-- Solución del solucionario:
(select replace(apellido1, 'll', 'y')
from profesores where upper(apellido1) like '%LL%')
UNION
(select replace(apellido2, 'll', 'y')
from profesores where upper(apellido2) like '%LL%')
UNION
(select replace(apellido1, 'll', 'y')
from alumnos where upper(apellido1) like '%LL%')
UNION
(select replace(apellido2, 'll', 'y')
from alumnos where upper(apellido2) like '%LL%');


-- Solución  real
(select replace(apellido1, 'll', 'y')
from profesores where upper(apellido1) like '%LL%')
UNION
(select replace(apellido2, 'll', 'y')
from profesores where upper(apellido2) like '%LL%')
UNION
(select replace(apellido1, 'll', 'y')
from alumnos where upper(apellido1) like '%LL%')
UNION
(select replace(apellido2, 'll', 'y')
from alumnos where upper(apellido2) like '%LL%')

UNION

(select replace(apellido1, 'LL', 'Y')
from profesores where upper(apellido1) like '%LL%')
UNION
(select replace(apellido2, 'LL', 'Y')
from profesores where upper(apellido2) like '%LL%')
UNION
(select replace(apellido1, 'LL', 'Y')
from alumnos where upper(apellido1) like '%LL%')
UNION
(select replace(apellido2, 'LL', 'Y')
from alumnos where upper(apellido2) like '%LL%')

MINUS(
(select apellido1
from profesores where upper(apellido1) like '%LL%')
UNION
(select apellido2
from profesores where upper(apellido2) like '%LL%')
UNION
(select apellido1
from alumnos where upper(apellido1) like '%LL%')
UNION
(select apellido2
from alumnos where upper(apellido2) like '%LL%'));

-- Reuniones externas: select ... from ... a (left/right) outer join b on () where ...
-- Ejercicio 21-----------------------------------------------------------------------
-- Las asignaturas que tienen algún campo de credito como null no aparecen con la expresión asig.teoricos + asig.practicos != asig.creditos
-- algo + null = null
-- null + null = null (eso no sería una incongruencia) por eso Administración de bases de datos no debe aparecer el listado
-- la incongruencia llega cuando tengo algo + null = algo (Programación Orientada a Objetos)
-- Por tanto, si uno de los dos operandos es null y el resultado no es null, debo meter la asginatura en el listado de incongruencias
-- Uso left porque tengo que mostrar todas las asignaturas a las que le pase eso, aunque no tengan profesor asociado (Estadística)

select asig.nombre, imp.profesor
from asignaturas asig left outer join impartir imp on(asig.codigo = imp.asignatura)
where asig.teoricos + asig.practicos != asig.creditos
      or ((teoricos is null or practicos is null) and creditos is not null); 

-- Ejercicio 22 ------------------------------------------------------------------
select p1.nombre||' '||p1.apellido1||' '||p1.apellido2 "Profesor", p2.nombre||' '||p2.apellido1||' '||p2.apellido2 "Director de tesis"
from profesores p1 left outer join profesores p2 on (p1.director_tesis = p2.id)
order by p1.apellido1;

-- Ejercicio 23 ------------------------------------------------------------------
select 'El director de '||p1.nombre||' '||p1.apellido1||' '||p1.apellido2||' es '||p2.nombre||' '||p2.apellido1||' '||p2.apellido2 as tesis, nvl(inv.tramos,0)
from profesores p1, profesores p2 left outer join investigadores inv on(p2.id = inv.id_profesor)
where p1.director_tesis = p2.id;

-- Ejercicio 24 -----------------------------------------------------------------
select alu1.nombre, alu1.apellido1, alu1.apellido2, alu2.nombre, alu2.apellido1, alu2.apellido2, alu1.fecha_prim_matricula, alu2.fecha_prim_matricula
from alumnos alu1 left outer join alumnos alu2 on(alu1.fecha_prim_matricula = alu2.fecha_prim_matricula
                                                    and alu1.dni != alu2.dni)
order by alu1.apellido1;

-- Resultado correcto a mi juicio
select alu1.nombre, alu1.apellido1, alu1.apellido2, alu2.nombre, alu2.apellido1, alu2.apellido2, alu1.fecha_prim_matricula, alu2.fecha_prim_matricula
from alumnos alu1 left outer join alumnos alu2 on(alu1.fecha_prim_matricula like alu2.fecha_prim_matricula
                                                    and alu1.dni != alu2.dni)
order by alu1.apellido1;

-- Ejercicio 25
select asig.nombre as asignatura, imp.curso, imp.grupo, pro.nombre, pro.apellido1
from asignaturas asig left outer join impartir imp on (asig.codigo = imp.asignatura) 
		      left outer join profesores pro on (imp.profesor = pro.id)
order by asig.nombre;
      
-- Subconsultas------------------------------------------------------------------

-- Ejercicio 26 -------------------------------------------------------------------
-- Es una consulta negativa (la pista la da el enunciado)
-- La expresión es cierta si el elemento  NO pertenece al conjunto
-- Se mostrarán los atributos del select siempre que el id del profesor no esté en el conjunto especificado por la subconsulta

select nombre, apellido1, id
from profesores pro
where id not in (select profesor
                  from impartir imp); -- los profesores que imparten
                  
select nombre, apellido1, id
from profesores pro
where not exists (select profesor
                  from impartir imp
                  where pro.id = imp.profesor); -- profesores que no imparten hacen la tupla vacía y lo selecciono para mostrarlo

-- Ejercicio 27 --------------------------------------------------------------------
select nombre, apellido1, apellido2
from alumnos
where dni in (select alumno from matricular
              where asignatura = 115
              and genero = 'FEM') -- dni de las alumnas matriculadas en la asignatura 115 (atributo género es de alumnos, no hay confusión)
      and rownum < 3;
      
select nombre, apellido1, apellido2
from alumnos al
where exists (select * from matricular mat
              where asignatura = 115
              and genero = 'FEM'
              and al.dni = mat.alumno) -- 
      and rownum < 3;
      
-- Ejercicio 28 ------------------------------------------------------------------
select *
from profesores
where id not in (select director_tesis
                  from profesores
                  where director_tesis is not null); -- id de directores de tesis. 
                                                -- Tengo que poner que no sea null porque todos los profesores pertenecen aunque sea con valor null
                  
select *
from profesores p1
where not exists (select *
                  from profesores p2
                  where p1.id = p2.director_tesis); -- si p1 no es director de tesis de p2, tupla vacía y p1 se añade al resultado
                  
-- Ejercicio 29 -----------------------------------------------------------------
select nombre, codigo 
from asignaturas a1
where a1.creditos < any(select creditos
                      from asignaturas a2
                      where a1.curso = a2.curso);
                      
-- Ejercicio 30 -------------------------------------------------------------------
select nombre, codigo
from asignaturas
where curso is not null
MINUS
(select nombre, codigo 
from asignaturas a1
where a1.creditos < any(select creditos
                      from asignaturas a2
                      where a1.curso = a2.curso));
                      
                      select * from sol_2_30;
                      
select nombre, creditos, curso from asignaturas order by curso;










