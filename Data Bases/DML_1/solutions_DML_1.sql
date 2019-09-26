-- Author: Salvi CF

-- DML 1 solutions

-- 1.
SELECT NOMBRE, APELLIDO1, APELLIDO2, DEPARTAMENTO
FROM PROFESORES
WHERE DEPARTAMENTO = 1;

-- 2.
SELECT NOMBRE, APELLIDO1, APELLIDO2, DEPARTAMENTO
FROM PROFESORES
WHERE DEPARTAMENTO != 3;

-- 3.
SELECT NOMBRE, APELLIDO1, APELLIDO2, EMAIL
FROM PROFESORES
WHERE EMAIL LIKE '%LCC.UMA.ES';

-- 4.
SELECT NOMBRE, APELLIDO1, APELLIDO2,  EMAIL
FROM ALUMNOS
WHERE EMAIL IS NULL;

-- 5.
SELECT NOMBRE, CURSO, TEORICOS, PRACTICOS, TEORICOS+PRACTICOS, (TEORICOS*100)/(TEORICOS+PRACTICOS) "% TEORICO", (PRACTICOS*100)/(TEORICOS+PRACTICOS) "% PRACTICOS"
FROM ASIGNATURAS
WHERE CURSO = 3;

-- otra forma:
SELECT NOMBRE, CREDITOS, ROUND((TEORICOS*100)/(TEORICOS+PRACTICOS), 2) AS TEOR, ROUND((PRACTICOS*100)/(TEORICOS+PRACTICOS), 2) AS PRACT
FROM ASIGNATURAS
WHERE CURSO = 3;

-- 6.
SELECT ALUMNO, CALIFICACION
FROM MATRICULAR
WHERE ASIGNATURA = 112
ORDER BY ALUMNO;

-- 7.
SELECT NOMBRE, HOMBRES, MUJERES, HOMBRES+MUJERES
FROM MUNICIPIO;

-- USO DE FUNCIONES

-- 8.
SELECT 'EL ALUMNO ' || NOMBRE || ' ' || APELLIDO1 || ' ' || APELLIDO2 || ' NO DISPONE DE CORREO' AS CORREOS
FROM ALUMNOS
WHERE EMAIL IS NULL
      AND GENERO = 'MASC'

UNION

SELECT 'LA ALUMNA ' || NOMBRE || ' ' || APELLIDO1 || ' ' || APELLIDO2 || ' NO DISPONE DE CORREO'
FROM ALUMNOS
WHERE EMAIL IS NULL
      AND GENERO LIKE 'FEM';


-- otra manera:
SELECT CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT('EL ALUMNO ', NOMBRE), ' ' ), APELLIDO1), ' '), APELLIDO2), ' NO DISPONE DE CORREO') "CORREOS"
FROM ALUMNOS
WHERE EMAIL IS NULL
      AND GENERO = 'MASC'

UNION

SELECT CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT('LA ALUMNA ', NOMBRE), ' ' ), APELLIDO1), ' '), APELLIDO2), ' NO DISPONE DE CORREO')
FROM ALUMNOS
WHERE EMAIL IS NULL
      AND GENERO LIKE 'FEM';

-- otra forma:
SELECT DECODE('MASC',GENERO, 'EL ALUMNO ', 'LA ALUMNA ')||NOMBRE||' '||APELLIDO1||' '||APELLIDO2|| ' NO DISPONE DE CORREO'
FROM ALUMNOS
WHERE EMAIL IS NULL;

-- 9.
SELECT NOMBRE, APELLIDO1, APELLIDO2, ANTIGUEDAD, ANTIGUEDAD-TO_DATE('01/01/1990', 'DD/MM/YYYY')
FROM PROFESORES
WHERE ANTIGUEDAD-TO_DATE('01/01/1990', 'DD/MM/YYYY') < 0;

-- otra forma:
SELECT NOMBRE, APELLIDO1, APELLIDO2, ANTIGUEDAD, EXTRACT(YEAR FROM ANTIGUEDAD)
FROM PROFESORES
WHERE EXTRACT(YEAR FROM ANTIGUEDAD) < 1990;

-- 10.
SELECT NOMBRE, APELLIDO1, APELLIDO2, FECHA_NACIMIENTO, TRUNC((MONTHS_BETWEEN(SYSDATE, FECHA_NACIMIENTO))/12) AS EDAD
FROM PROFESORES
WHERE TRUNC((MONTHS_BETWEEN(SYSDATE, FECHA_NACIMIENTO))/12) < 30;
