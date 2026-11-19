-- 13. Empleados ordenados por apellido y nombre (ascendente)

USE nomina; 
SELECT
  *
FROM
  empleado
ORDER BY
  apellido ASC,
  nombre ASC;
