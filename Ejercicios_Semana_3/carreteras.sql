DROP DATABASE IF EXISTS carreteras;
CREATE DATABASE carreteras
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE carreteras;

-- 1. Tablas de referencia (no dependen de ninguna otra)

CREATE TABLE comunidades_autonomas (
  pk_comunidad int AUTO_INCREMENT,
  comunidad_autonoma varchar(50) not null,
  CONSTRAINT pk_comunidades_autonomas PRIMARY KEY (pk_comunidad),
  CONSTRAINT uq_comunidad_autonoma UNIQUE (comunidad_autonoma)
);

CREATE TABLE titularidades (
  pk_titularidad int AUTO_INCREMENT,
  titularidad varchar(20) not null,
  CONSTRAINT pk_titularidades PRIMARY KEY (pk_titularidad),
  CONSTRAINT uq_titularidad UNIQUE (titularidad)
);

CREATE TABLE tipos_via (
  pk_tipo_via int AUTO_INCREMENT,
  tipo_via varchar(30) not null,
  CONSTRAINT pk_tipos_via PRIMARY KEY (pk_tipo_via),
  CONSTRAINT uq_tipo_via UNIQUE (tipo_via)
);

CREATE TABLE niveles (
  pk_nivel int AUTO_INCREMENT,
  nivel tinyint UNSIGNED not null,
  color varchar(20) not null,
  CONSTRAINT pk_niveles PRIMARY KEY (pk_nivel),
  CONSTRAINT uq_nivel UNIQUE (nivel),
  CONSTRAINT uq_color UNIQUE (color)
);

CREATE TABLE tipos_tramo (
  pk_tipo_tramo int AUTO_INCREMENT,
  tipo_tramo varchar(30) not null,
  CONSTRAINT pk_tipos_tramo PRIMARY KEY (pk_tipo_tramo),
  CONSTRAINT uq_tipo_tramo UNIQUE (tipo_tramo)
);

CREATE TABLE tipos_terreno (
  pk_tipo_terreno int AUTO_INCREMENT,
  tipo_terreno varchar(30) not null,
  CONSTRAINT pk_tipos_terreno PRIMARY KEY (pk_tipo_terreno),
  CONSTRAINT uq_tipo_terreno UNIQUE (tipo_terreno)
);

CREATE TABLE entornos (
  pk_entorno int AUTO_INCREMENT,
  entorno varchar(30) not null,
  CONSTRAINT pk_entornos PRIMARY KEY (pk_entorno),
  CONSTRAINT uq_entorno UNIQUE (entorno)
);

-- 2. Provincias

CREATE TABLE provincias (
  pk_provincia int AUTO_INCREMENT,
  nombre_provincia varchar(50) not null,
  fk_comunidad int not null,
  CONSTRAINT pk_provincias PRIMARY KEY (pk_provincia),
  CONSTRAINT uq_nombre_provincia UNIQUE (nombre_provincia),
  CONSTRAINT comunidades_provincias
    FOREIGN KEY (fk_comunidad) REFERENCES comunidades_autonomas(pk_comunidad)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 3. Carreteras
-- fk_nivel admite NULL: las carreteras estatales no tienen nivel

CREATE TABLE carreteras (
  pk_carretera int AUTO_INCREMENT,
  codigo_carretera varchar(15) not null,
  nombre_carretera varchar(80),
  acceso_controlado boolean not null default 0,
  doble_calzada boolean not null default 0,
  prefijo varchar(10),
  senal varchar(30),
  fk_titularidad int not null,
  fk_tipo_via int not null,
  fk_nivel int,
  CONSTRAINT pk_carreteras PRIMARY KEY (pk_carretera),
  CONSTRAINT uq_codigo_carretera UNIQUE (codigo_carretera),
  CONSTRAINT titularidades_carreteras
    FOREIGN KEY (fk_titularidad) REFERENCES titularidades(pk_titularidad)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT tipos_via_carreteras
    FOREIGN KEY (fk_tipo_via) REFERENCES tipos_via(pk_tipo_via)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT niveles_carreteras
    FOREIGN KEY (fk_nivel) REFERENCES niveles(pk_nivel)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- una carretera puede tener varias observaciones
CREATE TABLE observaciones_carreteras (
  pk_observacion int AUTO_INCREMENT,
  observacion varchar(255) not null,
  fk_carretera int not null,
  CONSTRAINT pk_observaciones_carreteras PRIMARY KEY (pk_observacion),
  CONSTRAINT carreteras_observaciones
    FOREIGN KEY (fk_carretera) REFERENCES carreteras(pk_carretera)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- 4. Tramos
-- la longitud no se guarda: se calcula con km_final - km_inicial

CREATE TABLE tramos (
  pk_tramo int AUTO_INCREMENT,
  km_inicial decimal(7,3) not null,
  km_final decimal(7,3) not null,
  velocidad_limite smallint UNSIGNED not null,
  sentidos tinyint UNSIGNED not null default 2,
  carriles_ida tinyint UNSIGNED not null,
  carriles_vuelta tinyint UNSIGNED not null,
  observaciones varchar(255),
  fk_carretera int not null,
  fk_tipo_tramo int not null,
  fk_tipo_terreno int not null,
  fk_entorno int not null,
  fk_provincia_inicial int not null,
  fk_provincia_final int not null,
  CONSTRAINT pk_tramos PRIMARY KEY (pk_tramo),
  CONSTRAINT km_final_mayor CHECK (km_final > km_inicial),
  CONSTRAINT velocidad_positiva CHECK (velocidad_limite > 0),
  CONSTRAINT sentidos_validos CHECK (sentidos IN (1, 2)),
  CONSTRAINT carreteras_tramos
    FOREIGN KEY (fk_carretera) REFERENCES carreteras(pk_carretera)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT tipos_tramo_tramos
    FOREIGN KEY (fk_tipo_tramo) REFERENCES tipos_tramo(pk_tipo_tramo)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT tipos_terreno_tramos
    FOREIGN KEY (fk_tipo_terreno) REFERENCES tipos_terreno(pk_tipo_terreno)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT entornos_tramos
    FOREIGN KEY (fk_entorno) REFERENCES entornos(pk_entorno)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT provincias_tramos_inicial
    FOREIGN KEY (fk_provincia_inicial) REFERENCES provincias(pk_provincia)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT provincias_tramos_final
    FOREIGN KEY (fk_provincia_final) REFERENCES provincias(pk_provincia)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 5. Confluencias: unión de dos tramos en una provincia
-- km_tramo1 y km_tramo2 son los kilómetros de cada carretera en el punto de unión

CREATE TABLE confluencias (
  pk_confluencia int AUTO_INCREMENT,
  km_tramo1 decimal(7,3) not null,
  km_tramo2 decimal(7,3) not null,
  fk_tramo1 int not null,
  fk_tramo2 int not null,
  fk_provincia int not null,
  CONSTRAINT pk_confluencias PRIMARY KEY (pk_confluencia),
  CONSTRAINT tramos_confluencias_1
    FOREIGN KEY (fk_tramo1) REFERENCES tramos(pk_tramo)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT tramos_confluencias_2
    FOREIGN KEY (fk_tramo2) REFERENCES tramos(pk_tramo)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT provincias_confluencias
    FOREIGN KEY (fk_provincia) REFERENCES provincias(pk_provincia)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 6. Valores permitidos (restricciones de dominio)

INSERT INTO titularidades (titularidad) VALUES
('Estatal'), ('Autonómica'), ('Provincial'), ('Municipal');

INSERT INTO tipos_via (tipo_via) VALUES
('Autopista'), ('Autovía'), ('Multicarril'), ('Convencional');

INSERT INTO niveles (nivel, color) VALUES
(1, 'Naranja'), (2, 'Verde'), (3, 'Amarillo');

INSERT INTO tipos_terreno (tipo_terreno) VALUES
('Plano'), ('Cuesta subida'), ('Cuesta bajada');

INSERT INTO entornos (entorno) VALUES
('Urbano'), ('Travesía'), ('Extraurbano');

INSERT INTO tipos_tramo (tipo_tramo) VALUES
('Inicio'), ('Intermedio'), ('Final');
