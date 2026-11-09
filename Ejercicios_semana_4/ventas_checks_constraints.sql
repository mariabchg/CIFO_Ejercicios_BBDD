-- Ejercicio 2: Sistema de ventas

DROP DATABASE IF EXISTS ventas;
CREATE DATABASE ventas
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE ventas;

-- tabla proveedores
CREATE TABLE proveedores (
  pk_proveedor int AUTO_INCREMENT,
  cif_nif varchar(9) not null,
  nombre varchar(50) not null,
  telefono varchar(15),
  pagina_web varchar(100),
  calle varchar(60) not null,
  numero smallint not null,
  ciudad varchar(40) not null,
  codigo_postal char(5) not null,
  CONSTRAINT pk_proveedores PRIMARY KEY (pk_proveedor),
  CONSTRAINT cif_nif_proveedor UNIQUE (cif_nif),
  CONSTRAINT numero_direccion_positivo_proveedor CHECK (numero > 0)
);

--datos "buenos"
INSERT INTO proveedores (pk_proveedor, cif_nif, nombre, telefono, pagina_web, calle, numero, ciudad, codigo_postal)
VALUES (1, 'B12345678', 'Distribuciones Norte', '912345678', 'www.dnorte.example', 'Calle Mayor', 12, 'Madrid', '28001');
INSERT INTO proveedores (pk_proveedor, cif_nif, nombre, telefono, pagina_web, calle, numero, ciudad, codigo_postal)
VALUES (2, 'A87654321', 'Tecnologia Iberica', '934567890', 'www.tiberica.example', 'Avenida Diagonal', 450, 'Barcelona', '08006');
INSERT INTO proveedores (pk_proveedor, cif_nif, nombre, telefono, pagina_web, calle, numero, ciudad, codigo_postal)
VALUES (3, 'B11223344', 'Suministros del Sur', '955667788', NULL, 'Calle Sierpes', 8, 'Sevilla', '41004');

-- tabla clientes
CREATE TABLE clientes (
  pk_cliente int AUTO_INCREMENT,
  cif_nif varchar(9) not null,
  nombre varchar(50) not null,
  calle varchar(60) not null,
  numero smallint not null,
  ciudad varchar(40) not null,
  codigo_postal char(5) not null,
  CONSTRAINT pk_clientes PRIMARY KEY (pk_cliente),
  CONSTRAINT cif_nif_cliente UNIQUE (cif_nif),
  CONSTRAINT numero_direccion_positivo_cliente CHECK (numero > 0)
);

--datos "buenos"
INSERT INTO clientes (pk_cliente, cif_nif, nombre, calle, numero, ciudad, codigo_postal)
VALUES (1, '12345678Z', 'Ana Lopez', 'Calle Alcala', 25, 'Madrid', '28009');
INSERT INTO clientes (pk_cliente, cif_nif, nombre, calle, numero, ciudad, codigo_postal)
VALUES (2, '23456789D', 'Carlos Ruiz', 'Calle Larga', 3, 'Valencia', '46001');
INSERT INTO clientes (pk_cliente, cif_nif, nombre, calle, numero, ciudad, codigo_postal)
VALUES (3, 'X1234567L', 'Marta Gil', 'Paseo de Gracia', 100, 'Barcelona', '08008');
INSERT INTO clientes (pk_cliente, cif_nif, nombre, calle, numero, ciudad, codigo_postal)
VALUES (4, 'B99887766', 'Papeleria El Lapiz SL', 'Calle Real', 7, 'Sevilla', '41001');

-- tabla categorias
CREATE TABLE categorias (
  pk_categoria int AUTO_INCREMENT,
  nombre varchar(40) not null,
  descripcion varchar(255),
  CONSTRAINT pk_categorias PRIMARY KEY (pk_categoria),
  CONSTRAINT nombre_categoria UNIQUE (nombre)
);

--datos "buenos"--
INSERT INTO categorias (pk_categoria, nombre, descripcion) VALUES (1, 'Informatica', 'Ordenadores y accesorios');
INSERT INTO categorias (pk_categoria, nombre, descripcion) VALUES (2, 'Papeleria', 'Material de oficina');
INSERT INTO categorias (pk_categoria, nombre, descripcion) VALUES (3, 'Mobiliario', 'Mesas y sillas');

-- tabla productos
CREATE TABLE productos (
  pk_producto int AUTO_INCREMENT,
  nombre varchar(60) not null,
  precio_actual decimal(10,2) not null,
  stock int UNSIGNED not null default 0,
  fk_proveedor int not null,
  fk_categoria int not null,
  CONSTRAINT pk_productos PRIMARY KEY (pk_producto),
  CONSTRAINT precio_positivo CHECK (precio_actual >= 0),
  CONSTRAINT proveedores_productos
    FOREIGN KEY (fk_proveedor) REFERENCES proveedores(pk_proveedor)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT categorias_productos
    FOREIGN KEY (fk_categoria) REFERENCES categorias(pk_categoria)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

--datos "buenos"
INSERT INTO productos (pk_producto, nombre, precio_actual, stock, fk_proveedor, fk_categoria) VALUES (1, 'Teclado mecanico', 45.90, 50, 2, 1);
INSERT INTO productos (pk_producto, nombre, precio_actual, stock, fk_proveedor, fk_categoria) VALUES (2, 'Raton inalambrico', 19.95, 80, 2, 1);
INSERT INTO productos (pk_producto, nombre, precio_actual, stock, fk_proveedor, fk_categoria) VALUES (3, 'Cuaderno A4', 2.50, 200, 1, 2);
INSERT INTO productos (pk_producto, nombre, precio_actual, stock, fk_proveedor, fk_categoria) VALUES (4, 'Boligrafo azul', 0.80, 500, 1, 2);
INSERT INTO productos (pk_producto, nombre, precio_actual, stock, fk_proveedor, fk_categoria) VALUES (5, 'Silla de oficina', 129.00, 15, 3, 3);
INSERT INTO productos (pk_producto, nombre, precio_actual, stock, fk_proveedor, fk_categoria) VALUES (6, 'Mesa de escritorio', 210.00, 10, 3, 3);

-- tabla telefonos_clientes (un cliente puede tener varios teléfonos)
CREATE TABLE telefonos_clientes (
  telefono varchar(15),
  fk_cliente int not null,
  CONSTRAINT pk_telefonos_clientes PRIMARY KEY (telefono),
  CONSTRAINT clientes_telefonos
    FOREIGN KEY (fk_cliente) REFERENCES clientes(pk_cliente)
    ON UPDATE CASCADE ON DELETE CASCADE
);

--datos "buenos"
INSERT INTO telefonos_clientes (telefono, fk_cliente) VALUES ('600111222', 1);
INSERT INTO telefonos_clientes (telefono, fk_cliente) VALUES ('911222333', 1);
INSERT INTO telefonos_clientes (telefono, fk_cliente) VALUES ('622333444', 2);
INSERT INTO telefonos_clientes (telefono, fk_cliente) VALUES ('633444555', 3);
INSERT INTO telefonos_clientes (telefono, fk_cliente) VALUES ('955666777', 4);

-- tabla facturas
CREATE TABLE facturas (
  pk_factura int AUTO_INCREMENT,
  fecha date not null,
  descuento decimal(5,2) not null default 0,
  importe_final decimal(10,2) not null,
  fk_cliente int not null,
  CONSTRAINT pk_facturas PRIMARY KEY (pk_factura),
  CONSTRAINT descuento_valido CHECK (descuento BETWEEN 0 AND 100),
  CONSTRAINT clientes_facturas
    FOREIGN KEY (fk_cliente) REFERENCES clientes(pk_cliente)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO facturas (pk_factura, fecha, descuento, importe_final, fk_cliente) VALUES (1, '2026-10-05', 0, 103.82, 1);
INSERT INTO facturas (pk_factura, fecha, descuento, importe_final, fk_cliente) VALUES (2, '2026-10-12', 10, 44.65, 2);
INSERT INTO facturas (pk_factura, fecha, descuento, importe_final, fk_cliente) VALUES (3, '2026-10-20', 0, 156.09, 3);
INSERT INTO facturas (pk_factura, fecha, descuento, importe_final, fk_cliente) VALUES (4, '2026-11-02', 5, 497.16, 4);

-- tabla facturas_productos (relación n:m entre facturas y productos)
CREATE TABLE facturas_productos (
  fk_factura int not null,
  fk_producto int not null,
  cantidad int UNSIGNED not null,
  precio_venta decimal(10,2) not null,
  iva decimal(4,2) not null default 21.00,
  CONSTRAINT pk_facturas_productos PRIMARY KEY (fk_factura, fk_producto),
  CONSTRAINT cantidad_positiva CHECK (cantidad > 0),
  CONSTRAINT facturas_lineas
    FOREIGN KEY (fk_factura) REFERENCES facturas(pk_factura)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT productos_lineas
    FOREIGN KEY (fk_producto) REFERENCES productos(pk_producto)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

--datos "buenos"--
INSERT INTO facturas_productos (fk_factura, fk_producto, cantidad, precio_venta) VALUES (1, 1, 1, 45.90);
INSERT INTO facturas_productos (fk_factura, fk_producto, cantidad, precio_venta) VALUES (1, 2, 2, 19.95);
INSERT INTO facturas_productos (fk_factura, fk_producto, cantidad, precio_venta) VALUES (2, 3, 10, 2.50);
INSERT INTO facturas_productos (fk_factura, fk_producto, cantidad, precio_venta) VALUES (2, 4, 20, 0.80);
INSERT INTO facturas_productos (fk_factura, fk_producto, cantidad, precio_venta) VALUES (3, 5, 1, 129.00);
INSERT INTO facturas_productos (fk_factura, fk_producto, cantidad, precio_venta) VALUES (4, 6, 2, 210.00);
INSERT INTO facturas_productos (fk_factura, fk_producto, cantidad, precio_venta) VALUES (4, 3, 5, 2.50);


-- ============ INSERT MALOS ============
-- Para provar, quitar los guiones de comentario. 

-- 1. cantidad 0 (CHECK). Error esperado: 3819, cantidad_positiva
-- INSERT INTO facturas_productos (fk_factura, fk_producto, cantidad, precio_venta) VALUES (1, 3, 0, 2.50);

-- 2. precio negativo (CHECK). Error esperado: 3819, precio_positivo
-- INSERT INTO productos (pk_producto, nombre, precio_actual, stock, fk_proveedor, fk_categoria) VALUES (7, 'Producto raro', -5, 1, 1, 1);

-- 3. descuento de 150 (CHECK). Error esperado: 3819, descuento_valido
-- INSERT INTO facturas (pk_factura, fecha, descuento, importe_final, fk_cliente) VALUES (5, '2026-11-05', 150, 10, 1);

-- 4. numero de casa negativo en cliente (CHECK). Error esperado: 3819, numero_direccion_positivo_cliente
-- INSERT INTO clientes (pk_cliente, cif_nif, nombre, calle, numero, ciudad, codigo_postal) VALUES (5, '34567890V', 'Prueba', 'Calle Sol', -5, 'Madrid', '28001');

-- 5. numero de casa negativo en proveedor (CHECK). Error esperado: 3819, numero_direccion_positivo_proveedor
-- INSERT INTO proveedores (pk_proveedor, cif_nif, nombre, calle, numero, ciudad, codigo_postal) VALUES (4, 'B55667788', 'Prueba', 'Calle Sol', -1, 'Madrid', '28001');

-- 6. sin numero de casa (NOT NULL). Error esperado: 1364
-- INSERT INTO clientes (pk_cliente, cif_nif, nombre, calle, ciudad, codigo_postal) VALUES (5, '34567890V', 'Prueba', 'Calle Sol', 'Madrid', '28001');

-- 7. cif_nif repetido (UNIQUE). Error esperado: 1062
-- INSERT INTO proveedores (pk_proveedor, cif_nif, nombre, calle, numero, ciudad, codigo_postal) VALUES (4, 'B12345678', 'Otro proveedor', 'Calle Sol', 5, 'Madrid', '28002');

-- 8. proveedor que no existe (FOREIGN KEY). Error esperado: 1452
-- INSERT INTO productos (pk_producto, nombre, precio_actual, stock, fk_proveedor, fk_categoria) VALUES (7, 'Webcam', 35.00, 10, 999, 1);

-- 9. borrar proveedor que tiene productos (ON DELETE RESTRICT). Error esperado: 1451
-- DELETE FROM proveedores WHERE pk_proveedor = 1;
