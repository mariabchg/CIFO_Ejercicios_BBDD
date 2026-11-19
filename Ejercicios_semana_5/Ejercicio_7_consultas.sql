-- 1. Nombres de todos los empleados
SELECT
  nombre
FROM
  empleado;

-- 2. Nombres y sueldos
SELECT
  nombre,
  sueldo
FROM
  empleado;

-- 3. Todas las columnas
SELECT
  *
FROM
  empleado;

-- 4. Nombre + apellido, fecha de nacimiento y fecha de contrato
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  fecha_nacimiento,
  fecha_contrato
FROM
  empleado;

-- 5. Nombre, apellido, sexo e hijos
SELECT
  nombre,
  apellido,
  sexo,
  hijos
FROM
  empleado;

-- 6. Lo mismo con alias
SELECT
  nombre AS `nombre del empleado`,
  apellido AS `apellido del empleado`,
  sexo AS sexo,
  hijos AS `número de hijos`
FROM
  empleado;

-- 7. Nombre + apellido (apellido en mayúsculas) y sueldo
SELECT
  CONCAT(nombre, ' ', UPPER(apellido)) AS nombre_completo,
  sueldo
FROM
  empleado;

-- 8. Nombre + apellido y estado civil en minúscula
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  LOWER(estado_civil) AS estado_civil
FROM
  empleado;

-- 9. Nombre + apellido e iniciales (M.R.)
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  CONCAT(LEFT(nombre, 1), '.', LEFT(apellido, 1), '.') AS iniciales
FROM
  empleado;

-- 10. Nombre + apellido y edad
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM
  empleado;

-- 11. Nombre + apellido y antigüedad (años desde la fecha de contrato)
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  TIMESTAMPDIFF(YEAR, fecha_contrato, CURDATE()) AS antiguedad
FROM
  empleado;

-- 12. Códigos de cargo sin repetir
SELECT DISTINCT
  fk_cargo
FROM
  empleado;

-- 13. Empleados ordenados por apellido y nombre (ascendente)
SELECT
  *
FROM
  empleado
ORDER BY
  apellido ASC,
  nombre ASC;

-- 14. Empleados ordenados por sueldo (descendente)
SELECT
  *
FROM
  empleado
ORDER BY
  sueldo DESC;

-- 15. Primero por estado civil (ascendente) y luego por sueldo (descendente)
SELECT
  *
FROM
  empleado
ORDER BY
  estado_civil ASC,
  sueldo DESC;

-- 16. Las 3 primeras filas de cargo
SELECT
  *
FROM
  cargo
ORDER BY
  pk_cargo
LIMIT
  3;

-- 17. 2 filas a partir de la cuarta fila de departamento (la cuarta incluida)
SELECT
  *
FROM
  departamento
ORDER BY
  pk_departamento
LIMIT
  2
OFFSET
  3;

-- 18. Empleado que gana menos
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  sueldo
FROM
  empleado
ORDER BY
  sueldo ASC
LIMIT
  1;

-- 19. Empleado de mayor edad (el que nació antes)
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  fecha_nacimiento
FROM
  empleado
ORDER BY
  fecha_nacimiento ASC
LIMIT
  1;

-- 20. Nombres de los empleados del departamento 2
SELECT
  nombre
FROM
  empleado
WHERE
  fk_departamento = 2;

-- 21. Sueldo menor o igual a 15000
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo
FROM
  empleado
WHERE
  sueldo <= 15000;

-- 22. Sueldo mayor o igual a 40000
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo
FROM
  empleado
WHERE
  sueldo >= 40000;

-- 23. Los que NO tienen un sueldo mayor o igual a 14000
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo
FROM
  empleado
WHERE
  NOT (sueldo >= 14000);

-- 24. Sueldo entre 18000 y 25000, sin BETWEEN
SELECT
  *
FROM
  empleado
WHERE
  sueldo >= 18000
  AND sueldo <= 25000;

-- 25. Sueldo entre 16000 y 20000, con BETWEEN
SELECT
  *
FROM
  empleado
WHERE
  sueldo BETWEEN 16000 AND 20000;

-- 26. Sueldo mayor que 15000 y departamento 6
SELECT
  *
FROM
  empleado
WHERE
  sueldo > 15000
  AND fk_departamento = 6;

-- 27. Cargo 1, 3 o 5, sin IN
SELECT
  *
FROM
  empleado
WHERE
  fk_cargo = 1
  OR fk_cargo = 3
  OR fk_cargo = 5;

-- 28. Cargo 1, 3 o 5, con IN
SELECT
  *
FROM
  empleado
WHERE
  fk_cargo IN (1, 3, 5);

-- 29. Nombre + apellido y mes de nacimiento
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  MONTH(fecha_nacimiento) AS mes_nacimiento
FROM
  empleado;

-- 30. Empleados cuyo nombre empieza por S
SELECT
  *
FROM
  empleado
WHERE
  nombre LIKE 'S%';

-- 31. Empleados cuyo nombre termina en la vocal e
SELECT
  *
FROM
  empleado
WHERE
  nombre LIKE '%e';

-- 32. Cargos que contienen la letra r
SELECT
  *
FROM
  cargo
WHERE
  cargo LIKE '%r%';

-- 33. Empleados con la cadena ana en el nombre
SELECT
  *
FROM
  empleado
WHERE
  nombre LIKE '%ana%';

-- 34. Apellido con la cadena ez y sueldo inferior a 21500
SELECT
  *
FROM
  empleado
WHERE
  apellido LIKE '%ez%'
  AND sueldo < 21500;

-- 35. Apellidos de 4 caracteres
SELECT
  apellido
FROM
  empleado
WHERE
  CHAR_LENGTH(apellido) = 4;

-- 36. Sueldo >= 18000, ordenado por sueldo (desc) y apellido (asc)
SELECT
  nombre,
  sueldo
FROM
  empleado
WHERE
  sueldo >= 18000
ORDER BY
  sueldo DESC,
  apellido ASC;

