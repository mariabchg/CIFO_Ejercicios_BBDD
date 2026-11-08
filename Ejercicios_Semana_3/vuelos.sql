DROP DATABASE IF EXISTS vuelos;
CREATE DATABASE vuelos
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE vuelos;

-- 1. Tablas que no dependen de ninguna otra

CREATE TABLE paises (
  pk_pais int AUTO_INCREMENT,
  nombre_pais varchar(60) not null,
  CONSTRAINT pk_paises PRIMARY KEY (pk_pais),
  CONSTRAINT uq_nombre_pais UNIQUE (nombre_pais)
);

CREATE TABLE lineas_aereas (
  pk_linea_aerea int AUTO_INCREMENT,
  nombre_linea varchar(60) not null,
  CONSTRAINT pk_lineas_aereas PRIMARY KEY (pk_linea_aerea),
  CONSTRAINT uq_nombre_linea UNIQUE (nombre_linea)
);

CREATE TABLE dias_semana (
  pk_dia int AUTO_INCREMENT,
  dia varchar(10) not null,
  CONSTRAINT pk_dias_semana PRIMARY KEY (pk_dia),
  CONSTRAINT uq_dia UNIQUE (dia)
);

-- el modelo determina la capacidad, es decir, el número de plazas
CREATE TABLE modelos_avion (
  pk_modelo int AUTO_INCREMENT,
  nombre_modelo varchar(50) not null,
  capacidad smallint UNSIGNED not null,
  CONSTRAINT pk_modelos_avion PRIMARY KEY (pk_modelo),
  CONSTRAINT uq_nombre_modelo UNIQUE (nombre_modelo),
  CONSTRAINT capacidad_positiva CHECK (capacidad > 0)
);

-- 2. Ciudades y aeropuertos

CREATE TABLE ciudades (
  pk_ciudad int AUTO_INCREMENT,
  nombre_ciudad varchar(60) not null,
  fk_pais int not null,
  CONSTRAINT pk_ciudades PRIMARY KEY (pk_ciudad),
  CONSTRAINT uq_ciudad_pais UNIQUE (nombre_ciudad, fk_pais),
  CONSTRAINT paises_ciudades
    FOREIGN KEY (fk_pais) REFERENCES paises(pk_pais)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE aeropuertos (
  pk_aeropuerto int AUTO_INCREMENT,
  codigo_aeropuerto varchar(10) not null,
  nombre_aeropuerto varchar(80) not null,
  fk_ciudad int not null,
  CONSTRAINT pk_aeropuertos PRIMARY KEY (pk_aeropuerto),
  CONSTRAINT uq_codigo_aeropuerto UNIQUE (codigo_aeropuerto),
  CONSTRAINT ciudades_aeropuertos
    FOREIGN KEY (fk_ciudad) REFERENCES ciudades(pk_ciudad)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- modelos de avión que pueden aterrizar en cada aeropuerto (n:m)
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

-- 3. Programas de vuelo
-- el número de vuelo es único en todo el mundo

CREATE TABLE programas_vuelo (
  pk_programa int AUTO_INCREMENT,
  numero_vuelo varchar(10) not null,
  fk_linea_aerea int not null,
  fk_aeropuerto_salida int not null,
  fk_aeropuerto_llegada int not null,
  CONSTRAINT pk_programas_vuelo PRIMARY KEY (pk_programa),
  CONSTRAINT uq_numero_vuelo UNIQUE (numero_vuelo),
  CONSTRAINT lineas_programas
    FOREIGN KEY (fk_linea_aerea) REFERENCES lineas_aereas(pk_linea_aerea)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT aeropuertos_salidas
    FOREIGN KEY (fk_aeropuerto_salida) REFERENCES aeropuertos(pk_aeropuerto)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT aeropuertos_llegadas
    FOREIGN KEY (fk_aeropuerto_llegada) REFERENCES aeropuertos(pk_aeropuerto)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- días de la semana en que existe cada programa (n:m)
CREATE TABLE programas_dias (
  fk_programa int not null,
  fk_dia int not null,
  CONSTRAINT pk_programas_dias PRIMARY KEY (fk_programa, fk_dia),
  CONSTRAINT programas_dias_programa
    FOREIGN KEY (fk_programa) REFERENCES programas_vuelo(pk_programa)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT programas_dias_dia
    FOREIGN KEY (fk_dia) REFERENCES dias_semana(pk_dia)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- escalas técnicas ordenadas de cada programa (n:m con número de orden)
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

-- 4. Vuelos realizados

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

-- 5. Valores permitidos

INSERT INTO dias_semana (dia) VALUES
('Lunes'), ('Martes'), ('Miércoles'), ('Jueves'), ('Viernes'), ('Sábado'), ('Domingo');
