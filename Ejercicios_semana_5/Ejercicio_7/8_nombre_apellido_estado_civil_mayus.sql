-- 8. Nombre + apellido y estado civil en minúscula

USE nomina; 
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  LOWER(estado_civil) AS estado_civil
FROM
  empleado;
