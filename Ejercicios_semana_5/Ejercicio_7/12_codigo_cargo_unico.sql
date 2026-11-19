-- 12. Códigos de cargo sin repetir

USE nomina;
SELECT DISTINCT
  fk_cargo
FROM
  empleado;
