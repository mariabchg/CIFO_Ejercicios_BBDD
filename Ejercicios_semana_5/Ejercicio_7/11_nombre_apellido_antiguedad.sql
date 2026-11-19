-- 11. Nombre + apellido y antigüedad (años desde la fecha de contrato)

USE nomina; 
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  TIMESTAMPDIFF(YEAR, fecha_contrato, CURDATE()) AS antiguedad
FROM
  empleado;
