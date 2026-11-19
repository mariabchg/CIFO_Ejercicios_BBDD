-- 28. Cargo 1, 3 o 5, con IN
SELECT
  *
FROM
  empleado
WHERE
  fk_cargo IN (1, 3, 5);
