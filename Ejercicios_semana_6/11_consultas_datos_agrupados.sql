USE nomina;

-- 1. Número total de empleados
SELECT COUNT(*) AS total_empleados
FROM empleado;

-- 2. Número total de departamentos
SELECT COUNT(*) AS total_departamentos
FROM departamento;

-- 3. Media de sueldo de todos los empleados
SELECT AVG(sueldo) AS sueldo_medio
FROM empleado;

-- 4. Empleado más joven (la fecha de nacimiento más reciente)
SELECT nombre, apellido, fecha_nacimiento
FROM empleado
ORDER BY fecha_nacimiento DESC
LIMIT 1;

-- 5. Empleado menos joven (la fecha de nacimiento más antigua)
SELECT nombre, apellido, fecha_nacimiento
FROM empleado
ORDER BY fecha_nacimiento ASC
LIMIT 1;

-- 6. Número de empleados por estado civil
SELECT estado_civil, COUNT(*) AS num_empleados
FROM empleado
GROUP BY estado_civil;

-- 7. Número de empleados que ingresaron cada año
SELECT YEAR(fecha_contrato) AS anio, COUNT(*) AS num_empleados
FROM empleado
GROUP BY YEAR(fecha_contrato)
ORDER BY anio;

-- 8. Nombre y precio del producto más caro (base de datos jardineria)
USE jardineria;
SELECT nombre, precio_venta
FROM producto
ORDER BY precio_venta DESC
LIMIT 1;

USE nomina;

-- 9. Suma de los salarios por departamento
SELECT d.departamento, SUM(e.sueldo) AS total_sueldos
FROM departamento AS d
JOIN empleado AS e ON d.pk_departamento = e.fk_departamento
GROUP BY d.pk_departamento, d.departamento;

-- 10. Suma de los salarios por sexo
SELECT sexo, SUM(sueldo) AS total_sueldos
FROM empleado
GROUP BY sexo;

-- 11. Número de empleados que son Asistentes
SELECT COUNT(*) AS num_asistentes
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
WHERE c.cargo = 'Asistente';

-- 12. Media de hijos por sexo y estado civil
SELECT sexo, estado_civil, AVG(hijos) AS media_hijos
FROM empleado
GROUP BY sexo, estado_civil;

-- 13. Sueldo más bajo de los Analistas
SELECT MIN(e.sueldo) AS sueldo_minimo
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
WHERE c.cargo = 'Analista';

-- 14. Sueldo más alto de los Analistas
SELECT MAX(e.sueldo) AS sueldo_maximo
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
WHERE c.cargo = 'Analista';

-- 15. Sueldo máximo, mínimo, promedio y número de empleados por cargo
SELECT
  c.cargo,
  MAX(e.sueldo) AS sueldo_maximo,
  MIN(e.sueldo) AS sueldo_minimo,
  AVG(e.sueldo) AS sueldo_promedio,
  COUNT(*) AS num_empleados
FROM cargo AS c
JOIN empleado AS e ON c.pk_cargo = e.fk_cargo
GROUP BY c.pk_cargo, c.cargo;

-- 16. Lo mismo por departamento, ordenado por el sueldo promedio descendente
SELECT
  d.departamento,
  MAX(e.sueldo) AS sueldo_maximo,
  MIN(e.sueldo) AS sueldo_minimo,
  AVG(e.sueldo) AS sueldo_promedio,
  COUNT(*) AS num_empleados
FROM departamento AS d
JOIN empleado AS e ON d.pk_departamento = e.fk_departamento
GROUP BY d.pk_departamento, d.departamento
ORDER BY sueldo_promedio DESC;

-- 17. Edad máxima, mínima, promedio y número de empleados de los departamentos
--     con edad promedio superior a 45 años
SELECT
  d.departamento,
  MAX(TIMESTAMPDIFF(YEAR, e.fecha_nacimiento, CURDATE())) AS edad_maxima,
  MIN(TIMESTAMPDIFF(YEAR, e.fecha_nacimiento, CURDATE())) AS edad_minima,
  AVG(TIMESTAMPDIFF(YEAR, e.fecha_nacimiento, CURDATE())) AS edad_promedio,
  COUNT(*) AS num_empleados
FROM departamento AS d
JOIN empleado AS e ON d.pk_departamento = e.fk_departamento
GROUP BY d.pk_departamento, d.departamento
HAVING edad_promedio > 45;

-- 18. Empleados con sueldo mayor o igual a 1800 €
SELECT COUNT(*) AS num_empleados
FROM empleado
WHERE suel >= 1800;
-- Si el enunciado habla de sueldo mensual:
-- SELECT COUNT(*) AS num_empleados FROM empleado WHERE sueldo / 12 >= 1800;

-- 19. Empleados con edad menor o igual a 28 años
SELECT COUNT(*) AS num_empleados
FROM 
