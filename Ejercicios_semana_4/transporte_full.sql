-- Ejercicio 5 (UF2): Empresa de transporte de mercancías

DROP DATABASE IF EXISTS transporte;
CREATE DATABASE transporte
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE transporte;

-- ============ 1. TABLAS DE REFERENCIA ============

-- tabla marcas
CREATE TABLE marcas (
  pk_marca int AUTO_INCREMENT,
  marca varchar(40) not null,
  CONSTRAINT pk_marcas PRIMARY KEY (pk_marca),
  CONSTRAINT uq_marca UNIQUE (marca)
);

INSERT INTO marcas (pk_marca, marca) VALUES (1, 'Volvo');
INSERT INTO marcas (pk_marca, marca) VALUES (2, 'Scania');
INSERT INTO marcas (pk_marca, marca) VALUES (3, 'Mercedes-Benz');
INSERT INTO marcas (pk_marca, marca) VALUES (4, 'Renault');
INSERT INTO marcas (pk_marca, marca) VALUES (5, 'Ford');

-- tabla categorias_conductores (categorias del carnet de conducir)
CREATE TABLE categorias_conductores (
  pk_categoria int AUTO_INCREMENT,
  categoria varchar(10) not null,
  CONSTRAINT pk_categorias_conductores PRIMARY KEY (pk_categoria),
  CONSTRAINT uq_categoria UNIQUE (categoria)
);

INSERT INTO categorias_conductores (pk_categoria, categoria) VALUES (1, 'B');
INSERT INTO categorias_conductores (pk_categoria, categoria) VALUES (2, 'C');
INSERT INTO categorias_conductores (pk_categoria, categoria) VALUES (3, 'C+E');

-- tabla departamentos (de los administrativos)
CREATE TABLE departamentos (
  pk_departamento int AUTO_INCREMENT,
  departamento varchar(50) not null,
  CONSTRAINT pk_departamentos PRIMARY KEY (pk_departamento),
  CONSTRAINT uq_departamento UNIQUE (departamento)
);

INSERT INTO departamentos (pk_departamento, departamento) VALUES (1, 'Administración');
INSERT INTO departamentos (pk_departamento, departamento) VALUES (2, 'Logística');
INSERT INTO departamentos (pk_departamento, departamento) VALUES (3, 'Facturación');

-- tabla ciudades (origen y destino de los viajes)
CREATE TABLE ciudades (
  pk_ciudad int AUTO_INCREMENT,
  ciudad varchar(60) not null,
  CONSTRAINT pk_ciudades PRIMARY KEY (pk_ciudad),
  CONSTRAINT uq_ciudad UNIQUE (ciudad)
);

INSERT INTO ciudades (pk_ciudad, ciudad) VALUES (1, 'Madrid');
INSERT INTO ciudades (pk_ciudad, ciudad) VALUES (2, 'Barcelona');
INSERT INTO ciudades (pk_ciudad, ciudad) VALUES (3, 'Valencia');
INSERT INTO ciudades (pk_ciudad, ciudad) VALUES (4, 'Sevilla');
INSERT INTO ciudades (pk_ciudad, ciudad) VALUES (5, 'Zaragoza');
INSERT INTO ciudades (pk_ciudad, ciudad) VALUES (6, 'Bilbao');

-- ============ 2. MODELOS Y VEHICULOS ============

-- tabla modelos (cada modelo pertenece a una marca)
CREATE TABLE modelos (
  pk_modelo int AUTO_INCREMENT,
  modelo varchar(40) not null,
  fk_marca int not null,
  CONSTRAINT pk_modelos PRIMARY KEY (pk_modelo),
  CONSTRAINT uq_modelo_marca UNIQUE (modelo, fk_marca),
  CONSTRAINT marcas_modelos
    FOREIGN KEY (fk_marca) REFERENCES marcas(pk_marca)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO modelos (pk_modelo, modelo, fk_marca) VALUES (1, 'FH16', 1);
INSERT INTO modelos (pk_modelo, modelo, fk_marca) VALUES (2, 'R450', 2);
INSERT INTO modelos (pk_modelo, modelo, fk_marca) VALUES (3, 'Actros', 3);
INSERT INTO modelos (pk_modelo, modelo, fk_marca) VALUES (4, 'Master', 4);
INSERT INTO modelos (pk_modelo, modelo, fk_marca) VALUES (5, 'Transit', 5);
INSERT INTO modelos (pk_modelo, modelo, fk_marca) VALUES (6, 'Sprinter', 3);

-- tabla vehiculos (la matricula es la clave; la marca se sabe por el modelo)
CREATE TABLE vehiculos (
  pk_matricula varchar(10),
  anio smallint UNSIGNED not null,
  fk_modelo int not null,
  CONSTRAINT pk_vehiculos PRIMARY KEY (pk_matricula),
  CONSTRAINT anio_valido CHECK (anio BETWEEN 1950 AND 2100),
  CONSTRAINT modelos_vehiculos
    FOREIGN KEY (fk_modelo) REFERENCES modelos(pk_modelo)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO vehiculos (pk_matricula, anio, fk_modelo) VALUES ('1234BCD', 2020, 1);
INSERT INTO vehiculos (pk_matricula, anio, fk_modelo) VALUES ('5678FGH', 2019, 2);
INSERT INTO vehiculos (pk_matricula, anio, fk_modelo) VALUES ('9012JKL', 2022, 3);
INSERT INTO vehiculos (pk_matricula, anio, fk_modelo) VALUES ('3456MNP', 2021, 5);
INSERT INTO vehiculos (pk_matricula, anio, fk_modelo) VALUES ('7890RST', 2023, 6);
INSERT INTO vehiculos (pk_matricula, anio, fk_modelo) VALUES ('2468VWX', 2018, 4);

-- tabla camiones (jerarquia ISA: un vehiculo es camion o furgoneta, nunca los dos)
CREATE TABLE camiones (
  pk_matricula varchar(10),
  tonelaje_max decimal(5,2) not null,
  CONSTRAINT pk_camiones PRIMARY KEY (pk_matricula),
  CONSTRAINT tonelaje_positivo CHECK (tonelaje_max > 0),
  CONSTRAINT vehiculos_camiones
    FOREIGN KEY (pk_matricula) REFERENCES vehiculos(pk_matricula)
    ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO camiones (pk_matricula, tonelaje_max) VALUES ('1234BCD', 40.00);
INSERT INTO camiones (pk_matricula, tonelaje_max) VALUES ('5678FGH', 40.00);
INSERT INTO camiones (pk_matricula, tonelaje_max) VALUES ('9012JKL', 18.00);

-- tabla furgonetas
CREATE TABLE furgonetas (
  pk_matricula varchar(10),
  capacidad_m3 decimal(5,2) not null,
  CONSTRAINT pk_furgonetas PRIMARY KEY (pk_matricula),
  CONSTRAINT capacidad_positiva CHECK (capacidad_m3 > 0),
  CONSTRAINT vehiculos_furgonetas
    FOREIGN KEY (pk_matricula) REFERENCES vehiculos(pk_matricula)
    ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO furgonetas (pk_matricula, capacidad_m3) VALUES ('3456MNP', 11.00);
INSERT INTO furgonetas (pk_matricula, capacidad_m3) VALUES ('7890RST', 14.00);
INSERT INTO furgonetas (pk_matricula, capacidad_m3) VALUES ('2468VWX', 8.00);

-- ============ 3. EMPLEADOS, CONDUCTORES Y ADMINISTRATIVOS ============

-- tabla empleados
CREATE TABLE empleados (
  pk_dni varchar(9),
  nombre varchar(40) not null,
  apellido1 varchar(40) not null,
  apellido2 varchar(40),
  telefono varchar(15),
  CONSTRAINT pk_empleados PRIMARY KEY (pk_dni)
);

INSERT INTO empleados (pk_dni, nombre, apellido1, apellido2, telefono) VALUES ('12345678Z', 'Ana', 'Pérez', 'López', '600111222');
INSERT INTO empleados (pk_dni, nombre, apellido1, apellido2, telefono) VALUES ('23456789D', 'Luis', 'García', 'Ruiz', '600222333');
INSERT INTO empleados (pk_dni, nombre, apellido1, apellido2, telefono) VALUES ('34567890V', 'María', 'Torres', 'Gil', '600333444');
INSERT INTO empleados (pk_dni, nombre, apellido1, apellido2, telefono) VALUES ('45678901G', 'Carlos', 'Ramos', NULL, '600444555');
INSERT INTO empleados (pk_dni, nombre, apellido1, apellido2, telefono) VALUES ('56789012B', 'Elena', 'Díaz', 'Soto', '600555666');
INSERT INTO empleados (pk_dni, nombre, apellido1, apellido2, telefono) VALUES ('67890123N', 'Jorge', 'Vega', 'Mora', '600666777');

-- tabla conductores (jerarquia ISA: un empleado es conductor o administrativo, nunca los dos)
CREATE TABLE conductores (
  pk_dni varchar(9),
  numero_carnet varchar(20) not null,
  fk_categoria int not null,
  CONSTRAINT pk_conductores PRIMARY KEY (pk_dni),
  CONSTRAINT uq_numero_carnet UNIQUE (numero_carnet),
  CONSTRAINT empleados_conductores
    FOREIGN KEY (pk_dni) REFERENCES empleados(pk_dni)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT categorias_conductores_conductores
    FOREIGN KEY (fk_categoria) REFERENCES categorias_conductores(pk_categoria)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO conductores (pk_dni, numero_carnet, fk_categoria) VALUES ('12345678Z', 'C-100001', 3);
INSERT INTO conductores (pk_dni, numero_carnet, fk_categoria) VALUES ('23456789D', 'C-100002', 2);
INSERT INTO conductores (pk_dni, numero_carnet, fk_categoria) VALUES ('34567890V', 'C-100003', 1);

-- tabla administrativos
CREATE TABLE administrativos (
  pk_dni varchar(9),
  fk_departamento int not null,
  CONSTRAINT pk_administrativos PRIMARY KEY (pk_dni),
  CONSTRAINT empleados_administrativos
    FOREIGN KEY (pk_dni) REFERENCES empleados(pk_dni)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT departamentos_administrativos
    FOREIGN KEY (fk_departamento) REFERENCES departamentos(pk_departamento)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO administrativos (pk_dni, fk_departamento) VALUES ('45678901G', 1);
INSERT INTO administrativos (pk_dni, fk_departamento) VALUES ('56789012B', 2);
INSERT INTO administrativos (pk_dni, fk_departamento) VALUES ('67890123N', 3);

-- ============ 4. VIAJES, TRAMOS Y GESTION ============

-- tabla viajes
CREATE TABLE viajes (
  pk_num_viaje int AUTO_INCREMENT,
  fecha_salida date not null,
  fk_ciudad_origen int not null,
  fk_ciudad_destino int not null,
  fk_dni_conductor varchar(9) not null,
  fk_matricula varchar(10) not null,
  CONSTRAINT pk_viajes PRIMARY KEY (pk_num_viaje),
  CONSTRAINT ciudades_viajes_origen
    FOREIGN KEY (fk_ciudad_origen) REFERENCES ciudades(pk_ciudad)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ciudades_viajes_destino
    FOREIGN KEY (fk_ciudad_destino) REFERENCES ciudades(pk_ciudad)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT conductores_viajes
    FOREIGN KEY (fk_dni_conductor) REFERENCES conductores(pk_dni)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT vehiculos_viajes
    FOREIGN KEY (fk_matricula) REFERENCES vehiculos(pk_matricula)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- TRIGGER: el origen y el destino de un viaje no pueden ser la misma ciudad.
-- (No se hace con CHECK porque esas dos columnas son claves foraneas con ON UPDATE CASCADE
-- y MySQL no permite usarlas dentro de un CHECK.)

DELIMITER $$

CREATE TRIGGER antes_insertar_viaje
BEFORE INSERT ON viajes
FOR EACH ROW
BEGIN
  IF NEW.fk_ciudad_origen = NEW.fk_ciudad_destino THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El origen y el destino de un viaje no pueden ser la misma ciudad';
  END IF;
END$$

DELIMITER ;

INSERT INTO viajes (pk_num_viaje, fecha_salida, fk_ciudad_origen, fk_ciudad_destino, fk_dni_conductor, fk_matricula)
VALUES (1, '2026-10-05', 1, 2, '12345678Z', '1234BCD');
INSERT INTO viajes (pk_num_viaje, fecha_salida, fk_ciudad_origen, fk_ciudad_destino, fk_dni_conductor, fk_matricula)
VALUES (2, '2026-10-07', 3, 4, '23456789D', '9012JKL');
INSERT INTO viajes (pk_num_viaje, fecha_salida, fk_ciudad_origen, fk_ciudad_destino, fk_dni_conductor, fk_matricula)
VALUES (3, '2026-10-12', 5, 1, '34567890V', '3456MNP');
INSERT INTO viajes (pk_num_viaje, fecha_salida, fk_ciudad_origen, fk_ciudad_destino, fk_dni_conductor, fk_matricula)
VALUES (4, '2026-10-15', 2, 6, '12345678Z', '5678FGH');

-- tabla tramos (entidad debil: depende del viaje; si se borra un viaje, se borran sus tramos)
CREATE TABLE tramos (
  fk_num_viaje int not null,
  numero_tramo tinyint UNSIGNED not null,
  distancia_km decimal(7,2) not null,
  fecha_inicio date not null,
  fecha_fin date not null,
  CONSTRAINT pk_tramos PRIMARY KEY (fk_num_viaje, numero_tramo),
  CONSTRAINT numero_tramo_positivo CHECK (numero_tramo > 0),
  CONSTRAINT distancia_positiva CHECK (distancia_km > 0),
  CONSTRAINT fechas_tramo_validas CHECK (fecha_fin >= fecha_inicio),
  CONSTRAINT viajes_tramos
    FOREIGN KEY (fk_num_viaje) REFERENCES viajes(pk_num_viaje)
    ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO tramos (fk_num_viaje, numero_tramo, distancia_km, fecha_inicio, fecha_fin) VALUES (1, 1, 315.00, '2026-10-05', '2026-10-05');
INSERT INTO tramos (fk_num_viaje, numero_tramo, distancia_km, fecha_inicio, fecha_fin) VALUES (1, 2, 305.00, '2026-10-05', '2026-10-06');
INSERT INTO tramos (fk_num_viaje, numero_tramo, distancia_km, fecha_inicio, fecha_fin) VALUES (2, 1, 650.00, '2026-10-07', '2026-10-08');
INSERT INTO tramos (fk_num_viaje, numero_tramo, distancia_km, fecha_inicio, fecha_fin) VALUES (3, 1, 315.00, '2026-10-12', '2026-10-12');
INSERT INTO tramos (fk_num_viaje, numero_tramo, distancia_km, fecha_inicio, fecha_fin) VALUES (4, 1, 305.00, '2026-10-15', '2026-10-15');
INSERT INTO tramos (fk_num_viaje, numero_tramo, distancia_km, fecha_inicio, fecha_fin) VALUES (4, 2, 320.00, '2026-10-15', '2026-10-16');

-- tabla viajes_administrativos (relacion n:m Gestiona: administrativos que gestionan cada viaje)
CREATE TABLE viajes_administrativos (
  fk_num_viaje int not null,
  fk_dni_administrativo varchar(9) not null,
  CONSTRAINT pk_viajes_administrativos PRIMARY KEY (fk_num_viaje, fk_dni_administrativo),
  CONSTRAINT viajes_gestionados
    FOREIGN KEY (fk_num_viaje) REFERENCES viajes(pk_num_viaje)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT administrativos_gestionan
    FOREIGN KEY (fk_dni_administrativo) REFERENCES administrativos(pk_dni)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO viajes_administrativos (fk_num_viaje, fk_dni_administrativo) VALUES (1, '45678901G');
INSERT INTO viajes_administrativos (fk_num_viaje, fk_dni_administrativo) VALUES (1, '56789012B');
INSERT INTO viajes_administrativos (fk_num_viaje, fk_dni_administrativo) VALUES (2, '56789012B');
INSERT INTO viajes_administrativos (fk_num_viaje, fk_dni_administrativo) VALUES (3, '67890123N');
INSERT INTO viajes_administrativos (fk_num_viaje, fk_dni_administrativo) VALUES (4, '45678901G');


-- ============ INSERT MALOS: cada uno debe fallar ============
-- Quita el "-- " del principio de UNA linea, ejecutala sola y mira el error.
-- Despues vuelve a comentarla.

-- 1. tonelaje 0 (CHECK). Error esperado: 3819, tonelaje_positivo
-- INSERT INTO camiones (pk_matricula, tonelaje_max) VALUES ('2468VWX', 0);

-- 2. capacidad 0 (CHECK). Error esperado: 3819, capacidad_positiva
-- INSERT INTO furgonetas (pk_matricula, capacidad_m3) VALUES ('1234BCD', 0);

-- 3. año del vehiculo fuera de rango (CHECK). Error esperado: 3819, anio_valido
-- INSERT INTO vehiculos (pk_matricula, anio, fk_modelo) VALUES ('9999BCD', 1900, 1);

-- 4. tramo que termina antes de empezar (CHECK). Error esperado: 3819, fechas_tramo_validas
-- INSERT INTO tramos (fk_num_viaje, numero_tramo, distancia_km, fecha_inicio, fecha_fin) VALUES (4, 3, 100.00, '2026-10-17', '2026-10-16');

-- 5. distancia 0 (CHECK). Error esperado: 3819, distancia_positiva
-- INSERT INTO tramos (fk_num_viaje, numero_tramo, distancia_km, fecha_inicio, fecha_fin) VALUES (4, 3, 0, '2026-10-16', '2026-10-16');

-- 6. numero de carnet repetido (UNIQUE). Error esperado: 1062
-- INSERT INTO conductores (pk_dni, numero_carnet, fk_categoria) VALUES ('45678901G', 'C-100001', 2);

-- 7. viaje con una matricula que no existe (FOREIGN KEY). Error esperado: 1452
-- INSERT INTO viajes (pk_num_viaje, fecha_salida, fk_ciudad_origen, fk_ciudad_destino, fk_dni_conductor, fk_matricula) VALUES (5, '2026-10-20', 1, 3, '12345678Z', '0000XXX');

-- 8. borrar una marca que tiene modelos (ON DELETE RESTRICT). Error esperado: 1451
-- DELETE FROM marcas WHERE pk_marca = 1;

-- 9. viaje con el mismo origen y destino (TRIGGER). Error esperado: 1644, mensaje del trigger
-- INSERT INTO viajes (pk_num_viaje, fecha_salida, fk_ciudad_origen, fk_ciudad_destino, fk_dni_conductor, fk_matricula) VALUES (5, '2026-10-20', 1, 1, '12345678Z', '1234BCD');
