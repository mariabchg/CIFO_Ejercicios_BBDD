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
WHERE ciudad = @ciudad
  AND fecha_pago IS NOT NULL;


-- 5. Cambiar la variable a Miami y repetir
SET @ciudad = 'Miami';

SELECT *
FROM listado_pagos_clientes
WHERE ciudad = @ciudad AND fecha_pago IS NOT NULL;
