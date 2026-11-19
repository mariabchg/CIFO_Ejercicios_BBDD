USE jardineria;

-- 1. Código de oficina y ciudad
SELECT pk_oficina, ciudad
FROM oficina;

-- 2. Ciudad y teléfono de las oficinas de España
SELECT ciudad, telefono
FROM oficina
WHERE pais = 'España';

-- 3. Empleados cuyo jefe es el 7
SELECT nombre, apellido1, apellido2, email
FROM empleado
WHERE fk_jefe = 7;

-- 4. El jefe de la empresa (el único que no tiene jefe)
SELECT puesto, nombre, apellido1, apellido2, email
FROM empleado
WHERE fk_jefe IS NULL;

-- 5. Empleados que no son representantes de ventas
SELECT nombre, apellido1, apellido2, puesto
FROM empleado
WHERE puesto <> 'Representante Ventas';

-- 6. Clientes españoles
SELECT nombre_cliente
FROM cliente
WHERE pais = 'España';

-- 7. Estados distintos de un pedido
SELECT DISTINCT estado
FROM pedido;

-- 8a. Clientes con algún pago en 2008, con YEAR
SELECT DISTINCT fk_cliente
FROM pago
WHERE YEAR(fecha_pago) = 2008;

-- 8b. Con DATE_FORMAT
SELECT DISTINCT fk_cliente
FROM pago
WHERE
