-- 19. Empleado de mayor edad (el que nació antes)

SELECT
  CONCAT(nombre, ' ', apellido) AS nombre_completo,
  fecha_nacimiento
FROM
  empleado
ORDER BY
  fecha_nacimiento ASC
LIMIT
  1;
