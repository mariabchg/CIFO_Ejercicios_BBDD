-- 9. Nombre + apellido e iniciales (M.R.)

USE  nomina; 
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  CONCAT(LEFT(nombre, 1), '.', LEFT(apellido, 1), '.') AS iniciales
FROM
  empleado;
