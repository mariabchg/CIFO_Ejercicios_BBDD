-- Ejercicio 6: tienda con trigger

DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE tienda;

CREATE TABLE fabricantes (
  pk_fabricante int AUTO_INCREMENT,
  nombre_fabricante varchar(60) not null,
  CONSTRAINT pk_fabricantes PRIMARY KEY (pk_fabricante),
  CONSTRAINT uq_nombre_fabricante UNIQUE (nombre_fabricante)
);

INSERT INTO fabricantes (pk_fabricante, nombre_fabricante) VALUES (1, 'Asus');
INSERT INTO fabricantes (pk_fabricante, nombre_fabricante) VALUES (2, 'Lenovo');
INSERT INTO fabricantes (pk_fabricante, nombre_fabricante) VALUES (3, 'Hewlett-Packard');
INSERT INTO fabricantes (pk_fabricante, nombre_fabricante) VALUES (4, 'Samsung');
INSERT INTO fabricantes (pk_fabricante, nombre_fabricante) VALUES (5, 'Seagate');
INSERT INTO fabricantes (pk_fabricante, nombre_fabricante) VALUES (6, 'Crucial');
INSERT INTO fabricantes (pk_fabricante, nombre_fabricante) VALUES (7, 'Gigabyte');
INSERT INTO fabricantes (pk_fabricante, nombre_fabricante) VALUES (8, 'Huawei');
INSERT INTO fabricantes (pk_fabricante, nombre_fabricante) VALUES (9, 'Xiaomi');

DELIMITER $$

CREATE TRIGGER antes_insertar_fabricante
BEFORE INSERT ON fabricantes
FOR EACH ROW
BEGIN
  SET NEW.nombre_fabricante = UPPER(NEW.nombre_fabricante);
END$$

DELIMITER ;


CREATE TABLE productos (
  pk_producto int AUTO_INCREMENT,
  nombre_producto varchar(60) not null,
  precio decimal(10,2) not null,
  fk_fabricante int not null,
  CONSTRAINT pk_productos PRIMARY KEY (pk_producto),
  CONSTRAINT precio_positivo CHECK (precio >= 0),
  CONSTRAINT fabricantes_productos
    FOREIGN KEY (fk_fabricante) REFERENCES fabricantes(pk_fabricante)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (2, 'Memoria RAM DDR4 8GB', 120.00, 6);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (4, 'GeForce GTX 1050Ti', 185.00, 7);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (5, 'GeForce GTX 1080 Xtreme', 755.00, 6);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (6, 'Monitor 24 LED Full HD', 202.00, 1);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (7, 'Monitor 27 LED Full HD', 245.91, 1);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (8, 'Portátil Yoga 520', 559.00, 2);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (9, 'Portátil Ideapd 320', 444.00, 2);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO productos (pk_producto, nombre_producto, precio, fk_fabricante) VALUES (11, 'Impresora HP Laserjet Pro M26nw', 180.00, 3);

UPDATE productos
SET precio = precio * 1.15
WHERE fk_fabricante IN (1, 2, 4);

UPDATE productos
SET precio = precio * 1.20
WHERE fk_fabricante NOT IN (1, 2, 4);
