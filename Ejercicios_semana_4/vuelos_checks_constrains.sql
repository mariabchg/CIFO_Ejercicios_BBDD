-- Ejercicio 4: Sistema de vuelos

DROP DATABASE IF EXISTS vuelos;
CREATE DATABASE vuelos
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE vuelos;

-- ============ 1. TABLAS QUE NO DEPENDEN DE NINGUNA OTRA - REFERENCIA ============

-- tabla paises
CREATE TABLE paises (
  pk_pais int AUTO_INCREMENT,
  nombre_pais varchar(60) not null,
  CONSTRAINT pk_paises PRIMARY KEY (pk_pais),
  CONSTRAINT uq_nombre_pais UNIQUE (nombre_pais)
);

-- datos "buenos de paises
INSERT INTO paises (pk_pais, nombre_pais) VALUES (1, 'España');
INSERT INTO paises (pk_pais, nombre_pais) VALUES (2, 'Australia');
INSERT INTO paises (pk_pais, nombre_pais) VALUES (3, 'Brasil');
INSERT INTO paises (pk_pais, nombre_pais) VALUES (4, 'Chile');
INSERT INTO paises (pk_pais, nombre_pais) VALUES (5, 'Nueva Zelanda');
INSERT INTO paises (pk_pais, nombre_pais) VALUES (6, 'Reino Unido');

-- tabla lineas_aereas
CREATE TABLE lineas_aereas (
  pk_linea_aerea int AUTO_INCREMENT,
  nombre_linea varchar(60) not null,
  CONSTRAINT pk_lineas_aereas PRIMARY KEY (pk_linea_aerea),
  CONSTRAINT uq_nombre_linea UNIQUE (nombre_linea)
);

-- datos "buenos de lineas_aereas
INSERT INTO lineas_aereas (pk_linea_aerea, nombre_linea) VALUES (1, 'Iberia');
INSERT INTO lineas_aereas (pk_linea_aerea, nombre_linea) VALUES (2, 'Vueling');
INSERT INTO lineas_aereas (pk_linea_aerea, nombre_linea) VALUES (3, 'British Airways');
INSERT INTO lineas_aereas (pk_linea_aerea, nombre_linea) VALUES (4, 'Qantas');

-- tabla dias_semana (lista cerrada: los siete dias)
CREATE TABLE dias_semana (
  pk_dia int AUTO_INCREMENT,
  dia varchar(10) not null,
  CONSTRAINT pk_dias_semana PRIMARY KEY (pk_dia),
  CONSTRAINT uq_dia UNIQUE (dia)
);

-- -- datos "buenos de dias_semana
INSERT INTO dias_semana (pk_dia, dia) VALUES (1, 'Lunes');
INSERT INTO dias_semana (pk_dia, dia) VALUES (2, 'Martes');
INSERT INTO dias_semana (pk_dia, dia) VALUES (3, 'Miércoles');
INSERT INTO dias_semana (pk_dia, dia) VALUES (4, 'Jueves');
INSERT INTO dias_semana (pk_dia, dia) VALUES (5, 'Viernes');
INSERT INTO dias_semana (pk_dia, dia) VALUES (6, 'Sábado');
INSERT INTO dias_semana (pk_dia, dia) VALUES (7, 'Domingo');

-- tabla modelos_avion (el modelo determina la capacidad, es decir, las plazas)
CREATE TABLE modelos_avion (
  pk_modelo int AUTO_INCREMENT,
  nombre_modelo varchar(50) not null,
  capacidad smallint UNSIGNED not null,
  CONSTRAINT pk_modelos_avion PRIMARY KEY (pk_modelo),
  CONSTRAINT uq_nombre_modelo UNIQUE (nombre_modelo),
  CONSTRAINT capacidad_positiva CHECK (capacidad > 0)
);

-- -- datos "buenos de modelos_avion
INSERT INTO modelos_avion (pk_modelo, nombre_modelo, capacidad) VALUES (1, 'Airbus A380', 525);
INSERT INTO modelos_avion (pk_modelo, nombre_modelo, capacidad) VALUES (2, 'Boeing 737-800', 189);
INSERT INTO modelos_avion (pk_modelo, nombre_modelo, capacidad) VALUES (3, 'Airbus A320', 180);
INSERT INTO modelos_avion (pk_modelo, nombre_modelo, capacidad) VALUES (4, 'Boeing 787-9', 290);
INSERT INTO modelos_avion (pk_modelo, nombre_modelo, capacidad) VALUES (5, 'Airbus A350-900', 325);

-- ============ 2. TABLAS QUE DEPENDEN DE LAS ANTERIORES ============

-- tabla ciudades (dependen de paises)
CREATE TABLE ciudades (
  pk_ciudad int AUTO_INCREMENT,
  nombre_ciudad varchar(80) not null,
  fk_pais int not null,
  CONSTRAINT pk_ciudades PRIMARY KEY (pk_ciudad),
  CONSTRAINT uq_ciudad_pais UNIQUE (nombre_ciudad, fk_pais),
  CONSTRAINT paises_ciudades
    FOREIGN KEY (fk_pais) REFERENCES paises(pk_pais)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- datos "buenos de ciudades
INSERT INTO ciudades (pk_ciudad, nombre_ciudad, fk_pais) VALUES (1, 'Madrid', 1);
INSERT INTO ciudades (pk_ciudad, nombre_ciudad, fk_pais) VALUES (2, 'Barcelona', 1);
INSERT INTO ciudades (pk_ciudad, nombre_ciudad, fk_pais) VALUES (3, 'Sídney', 2);
INSERT INTO ciudades (pk_ciudad, nombre_ciudad, fk_pais) VALUES (4, 'São Paulo', 3);
INSERT INTO ciudades (pk_ciudad, nombre_ciudad, fk_pais) VALUES (5, 'Santiago', 4);
INSERT INTO ciudades (pk_ciudad, nombre_ciudad, fk_pais) VALUES (6, 'Auckland', 5);
INSERT INTO ciudades (pk_ciudad, nombre_ciudad, fk_pais) VALUES (7, 'Londres', 6);

-- tabla aeropuertos (dependen de ciudades). codigo_aeropuerto es el codigo IATA de 3 letras
CREATE TABLE aeropuertos (
  pk_aeropuerto int AUTO_INCREMENT,
  codigo_aeropuerto char(3) not null,
  nombre_aeropuerto varchar(100) not null,
  fk_ciudad int not null,
  CONSTRAINT pk_aeropuertos PRIMARY KEY (pk_aeropuerto),
  CONSTRAINT uq_codigo_aeropuerto UNIQUE (codigo_aeropuerto),
  CONSTRAINT ciudades_aeropuertos
    FOREIGN KEY (fk_ciudad) REFERENCES ciudades(pk_ciudad)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- datos "buenos de aeropuertos

INSERT INTO aeropuertos (pk_aeropuerto, codigo_aeropuerto, nombre_aeropuerto, fk_ciudad) VALUES (1, 'MAD', 'Madrid-Barajas Airport', 1);
INSERT INTO aeropuertos (pk_aeropuerto, codigo_aeropuerto, nombre_aeropuerto, fk_ciudad) VALUES (2, 'BCN', 'Josep Tarradellas Barcelona-El Prat Airport', 2);
INSERT INTO aeropuertos (pk_aeropuerto, codigo_aeropuerto, nombre_aeropuerto, fk_ciudad) VALUES (3, 'SYD', 'Sydney Airport', 3);
INSERT INTO aeropuertos (pk_aeropuerto, codigo_aeropuerto, nombre_aeropuerto, fk_ciudad) VALUES (4, 'GRU', 'Sao Paulo-Guarulhos International Airport', 4);
INSERT INTO aeropuertos (pk_aeropuerto, codigo_aeropuerto, nombre_aeropuerto, fk_ciudad) VALUES (5, 'SCL', 'Santiago International Airport', 5);
INSERT INTO aeropuertos (pk_aeropuerto, codigo_aeropuerto, nombre_aeropuerto, fk_ciudad) VALUES (6, 'AKL', 'Auckland Airport', 6);
INSERT INTO aeropuertos (pk_aeropuerto, codigo_aeropuerto, nombre_aeropuerto, fk_ciudad) VALUES (7, 'LHR', 'London Heathrow Airport', 7);

-- tabla aeropuertos_modelos (relacion n:m: modelos que pueden aterrizar en cada aeropuerto)
CREATE TABLE aeropuertos_modelos (
  fk_aeropuerto int not null,
  fk_modelo int not null,
  CONSTRAINT pk_aeropuertos_modelos PRIMARY KEY (fk_aeropuerto, fk_modelo),
  CONSTRAINT aeropuertos_admiten
    FOREIGN KEY (fk_aeropuerto) REFERENCES aeropuertos(pk_aeropuerto)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT modelos_admitidos
    FOREIGN KEY (fk_modelo) REFERENCES modelos_avion(pk_modelo)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- datos "buenos de aeropuertos_modelos

INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (1, 1);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (1, 2);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (1, 3);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (1, 5);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (2, 2);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (2, 3);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (2, 5);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (3, 1);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (3, 4);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (3, 5);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (4, 4);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (4, 5);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (5, 4);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (5, 5);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (6, 4);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (6, 5);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (7, 1);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (7, 2);
INSERT INTO aeropuertos_modelos (fk_aeropuerto, fk_modelo) VALUES (7, 4);

-- tabla programas_vuelo (el numero de vuelo es unico en todo el mundo)
CREATE TABLE programas_vuelo (
  pk_programa int AUTO_INCREMENT,
  numero_vuelo varchar(10) not null,
  fk_linea_aerea int not null,
  fk_aeropuerto_salida int not null,
  fk_aeropuerto_llegada int not null,
  CONSTRAINT pk_programas_vuelo PRIMARY KEY (pk_programa),
  CONSTRAINT uq_numero_vuelo UNIQUE (numero_vuelo),
  CONSTRAINT lineas_aereas_programas
    FOREIGN KEY (fk_linea_aerea) REFERENCES lineas_aereas(pk_linea_aerea)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT aeropuertos_programas_salida
    FOREIGN KEY (fk_aeropuerto_salida) REFERENCES aeropuertos(pk_aeropuerto)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT aeropuertos_programas_llegada
    FOREIGN KEY (fk_aeropuerto_llegada) REFERENCES aeropuertos(pk_aeropuerto)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- datos "buenos de programas_vuelo

INSERT INTO programas_vuelo (pk_programa, numero_vuelo, fk_linea_aerea, fk_aeropuerto_salida, fk_aeropuerto_llegada) VALUES (1, 'IB555', 1, 1, 3);
INSERT INTO programas_vuelo (pk_programa, numero_vuelo, fk_linea_aerea, fk_aeropuerto_salida, fk_aeropuerto_llegada) VALUES (2, 'VY1001', 2, 2, 1);
INSERT INTO programas_vuelo (pk_programa, numero_vuelo, fk_linea_aerea, fk_aeropuerto_salida, fk_aeropuerto_llegada) VALUES (3, 'BA422', 3, 7, 1);
INSERT INTO programas_vuelo (pk_programa, numero_vuelo, fk_linea_aerea, fk_aeropuerto_salida, fk_aeropuerto_llegada) VALUES (4, 'QF1', 4, 3, 7);

-- tabla programas_dias (relacion n:m: dias de la semana en que existe cada programa)
CREATE TABLE programas_dias (
  fk_programa int not null,
  fk_dia int not null,
  CONSTRAINT pk_programas_dias PRIMARY KEY (fk_programa, fk_dia),
  CONSTRAINT programas_programados
    FOREIGN KEY (fk_programa) REFERENCES programas_vuelo(pk_programa)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT dias_programados
    FOREIGN KEY (fk_dia) REFERENCES dias_semana(pk_dia)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- datos "buenos de programas_dias

-- IB555: lunes y jueves
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (1, 1);
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (1, 4);
-- VY1001: de lunes a viernes
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (2, 1);
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (2, 2);
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (2, 3);
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (2, 4);
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (2, 5);
-- BA422: martes, viernes y domingo
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (3, 2);
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (3, 5);
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (3, 7);
-- QF1: sabado
INSERT INTO programas_dias (fk_programa, fk_dia) VALUES (4, 6);

-- tabla escalas (escalas tecnicas de un programa, ordenadas con num_orden)
CREATE TABLE escalas (
  fk_programa int not null,
  fk_aeropuerto int not null,
  num_orden tinyint UNSIGNED not null,
  CONSTRAINT pk_escalas PRIMARY KEY (fk_programa, fk_aeropuerto),
  CONSTRAINT uq_orden_escala UNIQUE (fk_programa, num_orden),
  CONSTRAINT orden_positivo CHECK (num_orden > 0),
  CONSTRAINT programas_escalas
    FOREIGN KEY (fk_programa) REFERENCES programas_vuelo(pk_programa)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT aeropuertos_escalas
    FOREIGN KEY (fk_aeropuerto) REFERENCES aeropuertos(pk_aeropuerto)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- IB555 Madrid-Sydney, con tres escalas: Sao Paulo, Santiago y Auckland
INSERT INTO escalas (fk_programa, fk_aeropuerto, num_orden) VALUES (1, 4, 1);
INSERT INTO escalas (fk_programa, fk_aeropuerto, num_orden) VALUES (1, 5, 2);
INSERT INTO escalas (fk_programa, fk_aeropuerto, num_orden) VALUES (1, 6, 3);

-- tabla vuelos (vuelos realizados: cada uno pertenece a un programa)
CREATE TABLE vuelos (
  pk_vuelo int AUTO_INCREMENT,
  fecha date not null,
  plazas_vacias smallint UNSIGNED not null,
  fk_programa int not null,
  fk_modelo int not null,
  CONSTRAINT pk_vuelos PRIMARY KEY (pk_vuelo),
  CONSTRAINT programas_vuelos
    FOREIGN KEY (fk_programa) REFERENCES programas_vuelo(pk_programa)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT modelos_vuelos
    FOREIGN KEY (fk_modelo) REFERENCES modelos_avion(pk_modelo)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- IB555 los lunes y jueves, VY1001 de lunes a viernes, BA422 martes y viernes
INSERT INTO vuelos (pk_vuelo, fecha, plazas_vacias, fk_programa, fk_modelo) VALUES (1, '2026-10-05', 40, 1, 5);
INSERT INTO vuelos (pk_vuelo, fecha, plazas_vacias, fk_programa, fk_modelo) VALUES (2, '2026-10-08', 12, 1, 5);
INSERT INTO vuelos (pk_vuelo, fecha, plazas_vacias, fk_programa, fk_modelo) VALUES (3, '2026-10-05', 25, 2, 3);
INSERT INTO vuelos (pk_vuelo, fecha, plazas_vacias, fk_programa, fk_modelo) VALUES (4, '2026-10-06', 0, 2, 3);
INSERT INTO vuelos (pk_vuelo, fecha, plazas_vacias, fk_programa, fk_modelo) VALUES (5, '2026-10-06', 31, 3, 2);
INSERT INTO vuelos (pk_vuelo, fecha, plazas_vacias, fk_programa, fk_modelo) VALUES (6, '2026-10-09', 8, 3, 2);


-- ============ INSERT MALOS ============
-- Quitar el comentario.

-- 1. capacidad 0 (CHECK). Error esperado: 3819, capacidad_positiva
-- INSERT INTO modelos_avion (pk_modelo, nombre_modelo, capacidad) VALUES (6, 'Avion de prueba', 0);

-- 2. orden de escala 0 (CHECK). Error esperado: 3819, orden_positivo
-- INSERT INTO escalas (fk_programa, fk_aeropuerto, num_orden) VALUES (2, 7, 0);

-- 3. plazas vacias negativas (UNSIGNED). Error esperado: 1264, valor fuera de rango
-- INSERT INTO vuelos (pk_vuelo, fecha, plazas_vacias, fk_programa, fk_modelo) VALUES (7, '2026-10-12', -5, 2, 3);

-- 4. numero de vuelo repetido (UNIQUE). Error esperado: 1062
-- INSERT INTO programas_vuelo (pk_programa, numero_vuelo, fk_linea_aerea, fk_aeropuerto_salida, fk_aeropuerto_llegada) VALUES (5, 'IB555', 1, 1, 2);

-- 5. dos escalas con el mismo orden en un programa (UNIQUE). Error esperado: 1062
-- INSERT INTO escalas (fk_programa, fk_aeropuerto, num_orden) VALUES (1, 7, 1);

-- 6. aeropuerto de salida que no existe (FOREIGN KEY). Error esperado: 1452
-- INSERT INTO programas_vuelo (pk_programa, numero_vuelo, fk_linea_aerea, fk_aeropuerto_salida, fk_aeropuerto_llegada) VALUES (5, 'IB999', 1, 99, 2);

-- 7. borrar un pais que tiene ciudades (ON DELETE RESTRICT). Error esperado: 1451
-- DELETE FROM paises WHERE pk_pais = 1;
