-- 22. Sueldo mayor o igual a 40000
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo
FROM
  empleado
WHERE
  sueldo >= 40000;
