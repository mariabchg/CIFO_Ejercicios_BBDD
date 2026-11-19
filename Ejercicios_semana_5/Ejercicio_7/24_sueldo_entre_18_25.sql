-- 24. Sueldo entre 18000 y 25000, sin BETWEEN
SELECT
  *
FROM
  empleado
WHERE
  sueldo >= 18000
  AND sueldo <= 25000;
