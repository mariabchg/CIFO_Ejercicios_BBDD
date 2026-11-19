-- 7. Nombre + apellido (apellido en mayúsculas) y sueldo

USE nomina; 
SELECT
  CONCAT(nombre, ' ', UPPER(apellido)) AS nombre_completo,
  sueldo
FROM
  empleado;
