USE jardineria;

-- 1. Pedidos no entregados, ordenados por estado
CREATE OR REPLACE VIEW pedidos_no_entregados AS
SELECT
  p.pk_pedido AS codigo_pedido,
  p.fecha_pedido,
  CONCAT(c.nombre_contacto, ' ', c.apellido_contacto) AS nombre_cliente,
  p.estado
FROM pedido AS p
JOIN cliente AS c ON p.fk_cliente = c.pk_cliente
WHERE p.estado <> 'Entregado'
ORDER BY p.estado;

SELECT * FROM pedidos_no_entregados;


-- 2. Todos los clientes con sus pagos
CREATE OR REPLACE VIEW listado_pagos_clientes AS
SELECT
  CONCAT(c.nombre_contacto, ' ', c.apellido_contacto) AS nombre_completo,
  c.telefono,
  c.ciudad,
  c.pais,
  pa.fecha_pago,
  pa.total AS total_pago,
  pa.id_transaccion
FROM cliente AS c
LEFT JOIN pago AS pa ON c.pk_cliente = pa.fk_cliente;

SELECT * FROM listado_pagos_clientes;


-- 3. Todos los clientes con sus pedidos
CREATE OR REPLACE VIEW listado_pedidos_clientes AS
SELECT
  c.pk_cliente AS codigo_cliente,
  CONCAT(c.nombre_contacto, ' ', c.apellido_contacto) AS nombre_completo,
  c.telefono,
  c.ciudad,
  c.pais,
  p.pk_pedido AS codigo_pedido,
  p.fecha_pedido,
  p.fecha_esperada,
  p.fecha_entrega
FROM cliente AS c
LEFT JOIN pedido AS p ON c.pk_cliente = p.fk_cliente;

SELECT * FROM listado_pedidos_clientes;


-- 4. Variable de sesión @ciudad y clientes de Madrid que han pagado
SET @ciudad = 'Madrid';

SELECT *
FROM listado_pagos_clientes
WHERE ciudad = @ciudad AND fecha_pago IS NOT NULL;


-- 5. Cambiar la variable a Miami y repetir
SET @ciudad = 'Miami';

SELECT *
FROM listado_pagos_clientes
WHERE ciudad = @ciudad AND fecha_pago IS NOT NULL;

------------------- 6 -------------------------

USE nomina;

-- Ejercicio 11: más de 20 años en la empresa
CREATE OR REPLACE VIEW empleados_veteranos AS
SELECT
  e.nombre,
  e.apellido,
  c.cargo,
  d.departamento,
  TIMESTAMPDIFF(YEAR, e.fecha_contrato, CURDATE()) AS antiguedad
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE TIMESTAMPDIFF(YEAR, e.fecha_contrato, CURDATE()) > 20
ORDER BY d.departamento ASC, antiguedad DESC;

-- Ejercicio 12: solteros, divorciados o viudos con más de un hijo
CREATE OR REPLACE VIEW empleados_sin_pareja_con_hijos AS
SELECT
  e.nombre,
  e.apellido,
  TIMESTAMPDIFF(YEAR, e.fecha_nacimiento, CURDATE()) AS edad,
  c.cargo,
  d.departamento
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE e.estado_civil IN ('Soltero', 'Divorciado', 'Viudo')
  AND e.hijos > 1;

-- Ejercicio 14: todos los cargos con sus empleados
CREATE OR REPLACE VIEW listado_cargos_empleados AS
SELECT
  c.cargo,
  e.nombre,
  e.apellido,
  TIMESTAMPDIFF(YEAR, e.fecha_nacimiento, CURDATE()) AS edad,
  e.estado_civil
FROM cargo AS c
LEFT JOIN empleado AS e ON c.pk_cargo = e.fk_cargo;

-- Ejercicio 15: departamentos sin empleados
CREATE OR REPLACE VIEW departamentos_sin_empleados AS
SELECT d.pk_departamento, d.departamento
FROM departamento AS d
LEFT JOIN empleado AS e ON d.pk_departamento = e.fk_departamento
WHERE e.pk_empleado IS NULL;

-----------------------------------------------------------------------

-- 7. Eliminar la vista listado_pedidos_clientes
USE jardineria;
DROP VIEW listado_pedidos_clientes;


-- 8. Tabla con el resultado de la vista más sencilla (departamentos_sin_empleados)
USE nomina;
DROP TABLE IF EXISTS copia_departamentos_sin_empleados;
CREATE TABLE copia_departamentos_sin_empleados AS
SELECT * FROM departamentos_sin_empleados;

SELECT * FROM copia_departamentos_sin_empleados;


