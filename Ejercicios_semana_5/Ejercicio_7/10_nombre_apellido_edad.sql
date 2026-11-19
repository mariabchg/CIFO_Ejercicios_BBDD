-- 10. Nombre + apellido y edad

USE nomina;

SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM
  empleado;
