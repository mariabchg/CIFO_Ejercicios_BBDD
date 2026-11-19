-- 29. Nombre + apellido y mes de nacimiento
SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  MONTH(fecha_nacimiento) AS mes_nacimiento
FROM
  empleado;
