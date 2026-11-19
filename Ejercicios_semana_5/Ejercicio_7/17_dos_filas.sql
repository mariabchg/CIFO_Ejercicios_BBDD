-- 17. 2 filas a partir de la cuarta fila de departamento (la cuarta incluida)

USE nomina; 
SELECT
  *
FROM
  departamento
ORDER BY
  pk_departamento
LIMIT
  2
OFFSET
  3;
