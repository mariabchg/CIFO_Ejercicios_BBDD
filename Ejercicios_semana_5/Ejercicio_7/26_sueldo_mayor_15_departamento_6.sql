-- 26. Sueldo mayor que 15000 y departamento 6
SELECT
  *
FROM
  empleado
WHERE
  sueldo > 15000
  AND fk_departamento = 6;
