-- 6. Lo mismo con alias

USE nomina; 
SELECT
  nombre AS `nombre del empleado`,
  apellido AS `apellido del empleado`,
  sexo AS sexo,
  hijos AS `número de hijos`
FROM
  empleado;
