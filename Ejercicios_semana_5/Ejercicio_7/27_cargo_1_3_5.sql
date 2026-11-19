-- 27. Cargo 1, 3 o 5, sin IN
SELECT
  *
FROM
  empleado
WHERE
  fk_cargo = 1
  OR fk_cargo = 3
  OR fk_cargo = 5;
