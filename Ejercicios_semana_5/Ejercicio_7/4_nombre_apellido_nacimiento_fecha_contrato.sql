-- 4. Nombre + apellido, fecha de nacimiento y fecha de contrato

USE nomina; 
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  fecha_nacimiento,
  fecha_contrato
FROM
  empleado;
