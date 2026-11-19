-- 21. Sueldo menor o igual a 15000
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo
FROM
  empleado
WHERE
  sueldo <= 15000;
