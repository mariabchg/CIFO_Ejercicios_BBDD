-- 23. Los que NO tienen un sueldo mayor o igual a 14000
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo
FROM
  empleado
WHERE
  NOT (sueldo >= 14000);
