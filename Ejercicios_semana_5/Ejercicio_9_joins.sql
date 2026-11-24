-- NÓMINA

USE nomina;

-- 1. Nombre, apellido, sueldo y nombre del departamento
SELECT e.nombre, e.apellido, e.sueldo, d.departamento
FROM empleado AS e
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento;

-- 2. Nombre, apellido, fecha de contrato y nombre del cargo
SELECT e.nombre, e.apellido, e.fecha_contrato, c.cargo
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo;

-- 3. Lo mismo, ordenado por fecha de contrato
SELECT e.nombre, e.apellido, e.fecha_contrato, c.cargo
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
ORDER BY e.fecha_contrato;

-- 4. Código, nombre y apellido, código y nombre del departamento, sueldo mayor que 2000
SELECT e.pk_empleado, e.nombre, e.apellido, d.pk_departamento, d.departamento
FROM empleado AS e
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE e.sueldo > 2000;

-- 5. El empleado más joven con el nombre de su cargo
SELECT e.nombre, e.apellido, c.cargo
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
ORDER BY e.fecha_nacimiento DESC
LIMIT 1;

-- 6. Empleados con hijos y su departamento
SELECT e.nombre, e.apellido, d.departamento
FROM empleado AS e
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE e.hijos > 0;

-- 7. Todos los datos de los empleados de Contabilidad
SELECT e.*
FROM empleado AS e
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE d.departamento = 'Contabilidad';

-- 8. Solteros sin hijos, con su cargo y su departamento
SELECT e.nombre, e.apellido, c.cargo, d.departamento
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE e.estado_civil = 'Soltero' AND e.hijos = 0;

-- 9. Empleados de Compras y Ventas, sin IN
SELECT e.*, d.departamento
FROM empleado AS e
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE d.departamento = 'Compras' OR d.departamento = 'Ventas';

-- 10. Empleados de Compras y Ventas, con IN
SELECT e.*, d.departamento
FROM empleado AS e
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE d.departamento IN ('Compras', 'Ventas');

-- 11. Más de 20 años en la empresa, ordenado por departamento y por tiempo trabajado
SELECT e.nombre, e.apellido, c.cargo, d.departamento,
  TIMESTAMPDIFF(YEAR, e.fecha_contrato, CURDATE()) AS antiguedad
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE TIMESTAMPDIFF(YEAR, e.fecha_contrato, CURDATE()) > 20
ORDER BY d.departamento ASC, antiguedad DESC;

-- 12. Solteros, divorciados o viudos con más de un hijo
SELECT e.nombre, e.apellido,
  TIMESTAMPDIFF(YEAR, e.fecha_nacimiento, CURDATE()) AS edad,
  c.cargo, d.departamento
FROM empleado AS e
JOIN cargo AS c ON e.fk_cargo = c.pk_cargo
JOIN departamento AS d ON e.fk_departamento = d.pk_departamento
WHERE e.estado_civil IN ('Soltero', 'Divorciado', 'Viudo') AND e.hijos > 1;

-- 13. Todos los departamentos con su empleado (también los que no tienen)
SELECT d.pk_departamento, d.departamento, e.pk_empleado, e.nombre, e.apellido
FROM departamento AS d
LEFT JOIN empleado AS e ON d.pk_departamento = e.fk_departamento;

-- 14. Todos los cargos con su empleado, edad y estado civil (también los que no tienen)
SELECT c.cargo, e.nombre, e.apellido,
  TIMESTAMPDIFF(YEAR, e.fecha_nacimiento, CURDATE()) AS edad,
  e.estado_civil
FROM cargo AS c
LEFT JOIN empleado AS e ON c.pk_cargo = e.fk_cargo;

-- 15. Departamentos sin empleados
SELECT d.pk_departamento, d.departamento
FROM departamento AS d
LEFT JOIN empleado AS e ON d.pk_departamento = e.fk_departamento
WHERE e.pk_empleado IS NULL;

-- 16. Prueba: asignar un cargo que no existe (debe fallar con el error 1452)
INSERT INTO empleado
VALUES (61, 'Prueba', 'Test', 'Hombre', '1990-01-01', 'Soltero', 0, 99, 1, '2020-01-01', 20000);


-- JARDINERÍA 

USE jardineria;

-- COMPOSICIÓN INTERNA (INNER JOIN)

-- 1. Cliente y nombre y apellido de su representante de ventas
SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
FROM cliente AS c
JOIN empleado AS e ON c.fk_representante_ventas = e.pk_empleado;

-- 2. Clientes que han hecho pagos, con su representante
SELECT DISTINCT c.nombre_cliente, e.nombre, e.apellido1
FROM cliente AS c
JOIN pago AS p ON c.pk_cliente = p.fk_cliente
JOIN empleado AS e ON c.fk_representante_ventas = e.pk_empleado;

-- 3. Clientes que no han hecho pagos, con su representante
SELECT c.nombre_cliente, e.nombre, e.apellido1
FROM cliente AS c
LEFT JOIN pago AS p ON c.pk_cliente = p.fk_cliente
JOIN empleado AS e ON c.fk_representante_ventas = e.pk_empleado
WHERE p.fk_cliente IS NULL;

-- 4. Clientes con pagos, su representante y la ciudad de la oficina
SELECT DISTINCT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
FROM cliente AS c
JOIN pago AS p ON c.pk_cliente = p.fk_cliente
JOIN empleado AS e ON c.fk_representante_ventas = e.pk_empleado
JOIN oficina AS o ON e.fk_oficina = o.pk_oficina;

-- 5. Clientes sin pagos, su representante y la ciudad de la oficina
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
FROM cliente AS c
LEFT JOIN pago AS p ON c.pk_cliente = p.fk_cliente
JOIN empleado AS e ON c.fk_representante_ventas = e.pk_empleado
JOIN oficina AS o ON e.fk_oficina = o.pk_oficina
WHERE p.fk_cliente IS NULL;

-- 6. Dirección de las oficinas que tienen clientes en Fuenlabrada
SELECT DISTINCT o.linea_direccion1, o.linea_direccion2
FROM oficina AS o
JOIN empleado AS e ON e.fk_oficina = o.pk_oficina
JOIN cliente AS c ON c.fk_representante_ventas = e.pk_empleado
WHERE c.ciudad = 'Fuenlabrada';

-- 7. Clientes, sus representantes y la ciudad de la oficina
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad
FROM cliente AS c
JOIN empleado AS e ON c.fk_representante_ventas = e.pk_empleado
JOIN oficina AS o ON e.fk_oficina = o.pk_oficina;

-- 8. Empleados con el nombre de sus jefes (la tabla empleado se une consigo misma)
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM empleado AS e
LEFT JOIN empleado AS j ON e.fk_jefe = j.pk_empleado;

-- 9. Clientes con algún pedido entregado después de la fecha esperada
SELECT DISTINCT c.nombre_cliente
FROM cliente AS c
JOIN pedido AS p ON c.pk_cliente = p.fk_cliente
WHERE p.fecha_entrega > p.fecha_esperada;

-- 10. Gamas de producto que ha comprado cada cliente
SELECT DISTINCT c.nombre_cliente, g.gama
FROM cliente AS c
JOIN pedido AS p ON c.pk_cliente = p.fk_cliente
JOIN detalle_pedido AS d ON p.pk_pedido = d.fk_pedido
JOIN producto AS pr ON d.fk_producto = pr.pk_producto
JOIN gama_producto AS g ON pr.fk_gama = g.pk_gama
ORDER BY c.nombre_cliente;

-- COMPOSICIÓN EXTERNA (LEFT JOIN, RIGHT JOIN)

-- 11. Clientes que no han realizado ningún pago
SELECT c.*
FROM cliente AS c
LEFT JOIN pago AS p ON c.pk_cliente = p.fk_cliente
WHERE p.fk_cliente IS NULL;

-- 12. Clientes que no han realizado ningún pedido
SELECT c.*
FROM cliente AS c
LEFT JOIN pedido AS p ON c.pk_cliente = p.fk_cliente
WHERE p.pk_pedido IS NULL;

-- 13. Clientes sin pagos y clientes sin pedidos
SELECT c.pk_cliente, c.nombre_cliente
FROM cliente AS c
LEFT JOIN pago AS p ON c.pk_cliente = p.fk_cliente
WHERE p.fk_cliente IS NULL
  
UNION
  
SELECT c.pk_cliente, c.nombre_cliente
FROM cliente AS c
LEFT JOIN pedido AS p ON c.pk_cliente = p.fk_cliente
WHERE p.pk_pedido IS NULL;

-- 14. Empleados sin oficina asociada
SELECT e.*
FROM empleado AS e
LEFT JOIN oficina AS o
ON e.fk_oficina = o.pk_oficina
WHERE o.pk_oficina IS NULL;

-- 15. Empleados sin cliente asociado
SELECT e.*
FROM empleado AS e
LEFT JOIN cliente AS c ON e.pk_empleado = c.fk_representante_ventas
WHERE c.pk_cliente IS NULL;

-- 16. Empleados sin cliente asociado, con los datos de su oficina
SELECT e.*, o.*
FROM empleado AS e
LEFT JOIN cliente AS c ON e.pk_empleado = c.fk_representante_ventas
JOIN oficina AS o ON e.fk_oficina = o.pk_oficina
WHERE c.pk_cliente IS NULL;

-- 17. Empleados sin oficina y empleados sin cliente
SELECT e.pk_empleado, e.nombre, e.apellido1
FROM empleado AS e
LEFT JOIN oficina AS o ON e.fk_oficina = o.pk_oficina
WHERE o.pk_oficina IS NULL
  
UNION
  
SELECT e.pk_empleado, e.nombre, e.apellido1
FROM empleado AS e
LEFT JOIN cliente AS c ON e.pk_empleado = c.fk_representante_ventas
WHERE c.pk_cliente IS NULL;

-- 18. Productos que nunca han aparecido en un pedido
SELECT p.*
FROM producto AS p
LEFT JOIN detalle_pedido AS d ON p.pk_producto = d.fk_producto
WHERE d.fk_pedido IS NULL;

-- 19. Lo mismo, mostrando nombre y descripción
SELECT p.nombre, p.descripcion
FROM producto AS p
LEFT JOIN detalle_pedido AS d ON p.pk_producto = d.fk_producto
WHERE d.fk_pedido IS NULL;

-- 20.SUB CONSULTA - oficinas donde ningún empleado haya vendido a un cliente que compró productos de la gama Frutales

SELECT o.*
FROM oficina AS o
WHERE o.pk_oficina NOT IN (
  SELECT e.fk_oficina
  FROM empleado AS e
  JOIN cliente AS c ON c.fk_representante_ventas = e.pk_empleado
  JOIN pedido AS pe ON pe.fk_cliente = c.pk_cliente
  JOIN detalle_pedido AS d ON d.fk_pedido = pe.pk_pedido
  JOIN producto AS pr ON d.fk_producto = pr.pk_producto
  JOIN gama_producto AS g ON pr.fk_gama = g.pk_gama
  WHERE g.gama = 'Frutales'
);

-- 21. Clientes con algún pedido pero sin ningún pago
SELECT DISTINCT c.*
FROM cliente AS c
JOIN pedido AS p ON c.pk_cliente = p.fk_cliente
LEFT JOIN pago AS pa ON c.pk_cliente = pa.fk_cliente
WHERE pa.fk_cliente IS NULL;

-- 22. Empleados sin clientes asociados, con el nombre de su jefe
SELECT e.*, j.nombre AS nombre_jefe, j.apellido1 AS apellido_jefe
FROM empleado AS e
LEFT JOIN cliente AS c ON e.pk_empleado = c.fk_representante_ventas
LEFT JOIN empleado AS j ON e.fk_jefe = j.pk_empleado
WHERE c.pk_cliente IS NULL;
