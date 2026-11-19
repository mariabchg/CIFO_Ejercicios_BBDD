-- 18. Empleado que gana menos

SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  sueldo
FROM
  empleado
ORDER BY
  sueldo ASC
LIMIT
  1;
