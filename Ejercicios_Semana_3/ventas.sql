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
  CONSTRAINT cif_nif_proveedor UNIQUE (cif_nif)
);

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
  CONSTRAINT cif_nif_cliente UNIQUE (cif_nif)
);

-- tabla categorias
CREATE TABLE categorias (
  pk_categoria int AUTO_INCREMENT,
  nombre varchar(40) not null,
  descripcion varchar(255),
  CONSTRAINT pk_categorias PRIMARY KEY (pk_categoria),
  CONSTRAINT nombre_categoria UNIQUE (nombre)
);

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

-- tabla telefonos_clientes (un cliente puede tener varios teléfonos)
CREATE TABLE telefonos_clientes (
  telefono varchar(15),
  fk_cliente int not null,
  CONSTRAINT pk_telefonos_clientes PRIMARY KEY (telefono),
  CONSTRAINT clientes_telefonos
    FOREIGN KEY (fk_cliente) REFERENCES clientes(pk_cliente)
    ON UPDATE CASCADE ON DELETE CASCADE
);

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
