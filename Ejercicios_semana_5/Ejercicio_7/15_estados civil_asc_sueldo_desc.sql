-- 15. Primero por estado civil (ascendente) y luego por sueldo (descendente)

USE nomina;
SELECT
  *
FROM
  empleado
ORDER BY
  estado_civil ASC,
  sueldo DESC;
