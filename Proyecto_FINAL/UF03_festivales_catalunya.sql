-- festivales_catalunya.sql
-- Catálogo de Música y Festivales de Catalunya
-- Diseño físico: creación de la base de datos, las 23 tablas, sus claves foráneas y un trigger.

CREATE DATABASE IF NOT EXISTS festivales_catalunya
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE festivales_catalunya;


-- =========================================================
-- GRUPO 1: tablas que no apuntan a ninguna otra
-- =========================================================

-- tabla paises (la clave es el código ISO de dos letras: ES, FR, GB...)
CREATE TABLE paises (
  pk_codigo_pais char(2) primary key,
  nombre_pais varchar(60) not null unique
);

-- tabla estilos
CREATE TABLE estilos (
  pk_estilo int AUTO_INCREMENT primary key,
  nombre_estilo varchar(50) not null unique
);

-- tabla generos
CREATE TABLE generos (
  pk_genero int AUTO_INCREMENT primary key,
  genero varchar(30) not null unique
);

-- tabla idiomas
CREATE TABLE idiomas (
  pk_idioma int AUTO_INCREMENT primary key,
  nombre_idioma varchar(40) not null unique
);

-- tabla discograficas
CREATE TABLE discograficas (
  pk_discografica int AUTO_INCREMENT primary key,
  nombre_discografica varchar(100) not null unique
);

-- tabla comarcas
CREATE TABLE comarcas (
  pk_comarca int AUTO_INCREMENT primary key,
  nombre_comarca varchar(60) not null unique
);

-- tabla provincias
CREATE TABLE provincias (
  pk_provincia int AUTO_INCREMENT primary key,
  nombre_provincia varchar(30) not null unique
);

-- tabla anios (la clave es el propio año, por eso no lleva AUTO_INCREMENT)
CREATE TABLE anios (
  pk_anio year primary key,
  indice_ipc decimal(6,3) not null comment 'IPC de Catalunya, base 100' CHECK (indice_ipc > 0)
);

-- tabla sectores
CREATE TABLE sectores (
  pk_sector int AUTO_INCREMENT primary key,
  nombre_sector varchar(50) not null unique
);

-- tabla empresas (relación reflexiva: fk_empresa_matriz apunta a esta misma tabla)
CREATE TABLE empresas (
  pk_empresa int AUTO_INCREMENT primary key,
  nombre_empresa varchar(100) not null unique,
  fk_empresa_matriz int comment 'vacío si la empresa no depende de ninguna otra'
);


-- =========================================================
-- GRUPO 2: tablas que solo apuntan al grupo 1
-- =========================================================

-- tabla artistas
CREATE TABLE artistas (
  pk_artista int AUTO_INCREMENT primary key,
  mbid char(36) unique comment 'identificador de MusicBrainz',
  nombre varchar(150) not null,
  fk_codigo_pais char(2) not null,
  fk_estilo int not null
);

-- tabla municipios
CREATE TABLE municipios (
  pk_municipio int AUTO_INCREMENT primary key,
  nombre_municipio varchar(80) not null,
  fk_comarca int not null,
  fk_provincia int not null
);

-- tabla patrocinadores
CREATE TABLE patrocinadores (
  pk_patrocinador int AUTO_INCREMENT primary key,
  nombre varchar(100) not null unique,
  fk_sector int not null
);


-- =========================================================
-- GRUPO 3: el resto, en orden de dependencia
-- =========================================================

-- tabla personas (subentidad de la ISA: usa la clave de artistas, sin AUTO_INCREMENT)
CREATE TABLE personas (
  pk_artista int primary key,
  fecha_nacimiento date,
  fk_genero int not null
);

-- tabla grupos (subentidad de la ISA)
CREATE TABLE grupos (
  pk_artista int primary key,
  fecha_formacion date
);

-- tabla albumes
CREATE TABLE albumes (
  pk_album int AUTO_INCREMENT primary key,
  mbid char(36) unique,
  titulo varchar(200) not null,
  anio year not null,
  fk_artista int not null,
  fk_discografica int not null
);

-- tabla canciones (fk_idioma vacío en las instrumentales)
CREATE TABLE canciones (
  pk_cancion int AUTO_INCREMENT primary key,
  mbid char(36) unique,
  titulo varchar(200) not null,
  duracion_seg int UNSIGNED CHECK (duracion_seg > 0),
  numero_pista tinyint UNSIGNED not null CHECK (numero_pista > 0),
  fk_album int not null,
  fk_idioma int
);

-- tabla recintos
CREATE TABLE recintos (
  pk_recinto int AUTO_INCREMENT primary key,
  nombre_recinto varchar(150) not null,
  fk_municipio int not null
);

-- tabla festivales
CREATE TABLE festivales (
  pk_festival int AUTO_INCREMENT primary key,
  nombre varchar(100) not null unique,
  web varchar(200),
  fk_municipio int not null comment 'sede del festival',
  fk_empresa int not null comment 'empresa promotora que lo organiza'
);

-- tabla ediciones (entidad débil de festivales)
CREATE TABLE ediciones (
  pk_edicion int AUTO_INCREMENT primary key,
  fecha_inicio date not null,
  fecha_fin date not null,
  aforo_maximo int UNSIGNED not null CHECK (aforo_maximo > 0),
  asistentes int UNSIGNED not null comment 'cifra total publicada por el festival' CHECK (asistentes > 0),
  precio_abono decimal(6,2) comment 'vacío si es gratuito o no se conoce' CHECK (precio_abono > 0),
  impacto_economico decimal(12,2) comment 'vacío si no se publica' CHECK (impacto_economico > 0),
  fk_festival int not null,
  fk_anio year not null,
  CONSTRAINT ck_ediciones_fechas CHECK (fecha_fin >= fecha_inicio),
  CONSTRAINT uq_ediciones_festival_anio UNIQUE (fk_festival, fk_anio)
);

-- tabla actuaciones
CREATE TABLE actuaciones (
  pk_actuacion int AUTO_INCREMENT primary key,
  fecha date not null,
  es_cabeza_cartel boolean not null default false,
  fk_edicion int not null,
  fk_artista int not null,
  fk_recinto int not null
);

-- tabla setlists (relación N:M Interpreta entre actuaciones y canciones)
CREATE TABLE setlists (
  fk_actuacion int,
  fk_cancion int,
  orden tinyint UNSIGNED not null CHECK (orden > 0),
  CONSTRAINT pk_setlists PRIMARY KEY (fk_actuacion, fk_cancion)
);

-- tabla patrocinios (relación N:M Patrocina entre patrocinadores y ediciones)
CREATE TABLE patrocinios (
  fk_patrocinador int,
  fk_edicion int,
  CONSTRAINT pk_patrocinios PRIMARY KEY (fk_patrocinador, fk_edicion)
);


-- =========================================================
-- FOREIGN KEYS
-- Criterio general: ON UPDATE CASCADE y ON DELETE RESTRICT.
-- Excepciones:
--   CASCADE en las subentidades de la ISA, en la cadena de la entidad débil
--   (festival → ediciones → actuaciones → setlists, y ediciones → patrocinios),
--   para que al borrar un festival se borre todo lo que depende de él.
--   SET NULL en la relación reflexiva de empresas.
-- =========================================================

-- empresas → empresas (reflexiva)
ALTER TABLE empresas
ADD CONSTRAINT empresas_matriz
FOREIGN KEY (fk_empresa_matriz) REFERENCES empresas(pk_empresa)
ON UPDATE CASCADE
ON DELETE SET NULL; -- si se borra la matriz, la filial queda como independiente

-- artistas
ALTER TABLE artistas
ADD CONSTRAINT paises_artistas
FOREIGN KEY (fk_codigo_pais) REFERENCES paises(pk_codigo_pais)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE artistas
ADD CONSTRAINT estilos_artistas
FOREIGN KEY (fk_estilo) REFERENCES estilos(pk_estilo)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- municipios
ALTER TABLE municipios
ADD CONSTRAINT comarcas_municipios
FOREIGN KEY (fk_comarca) REFERENCES comarcas(pk_comarca)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE municipios
ADD CONSTRAINT provincias_municipios
FOREIGN KEY (fk_provincia) REFERENCES provincias(pk_provincia)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- patrocinadores
ALTER TABLE patrocinadores
ADD CONSTRAINT sectores_patrocinadores
FOREIGN KEY (fk_sector) REFERENCES sectores(pk_sector)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- personas y grupos (ISA)
ALTER TABLE personas
ADD CONSTRAINT artistas_personas
FOREIGN KEY (pk_artista) REFERENCES artistas(pk_artista)
ON UPDATE CASCADE
ON DELETE CASCADE; -- si se borra el artista, se borra su ficha de persona

ALTER TABLE personas
ADD CONSTRAINT generos_personas
FOREIGN KEY (fk_genero) REFERENCES generos(pk_genero)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE grupos
ADD CONSTRAINT artistas_grupos
FOREIGN KEY (pk_artista) REFERENCES artistas(pk_artista)
ON UPDATE CASCADE
ON DELETE CASCADE; -- si se borra el artista, se borra su ficha de grupo

-- albumes
ALTER TABLE albumes
ADD CONSTRAINT artistas_albumes
FOREIGN KEY (fk_artista) REFERENCES artistas(pk_artista)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE albumes
ADD CONSTRAINT discograficas_albumes
FOREIGN KEY (fk_discografica) REFERENCES discograficas(pk_discografica)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- canciones
ALTER TABLE canciones
ADD CONSTRAINT albumes_canciones
FOREIGN KEY (fk_album) REFERENCES albumes(pk_album)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE canciones
ADD CONSTRAINT idiomas_canciones
FOREIGN KEY (fk_idioma) REFERENCES idiomas(pk_idioma)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- recintos
ALTER TABLE recintos
ADD CONSTRAINT municipios_recintos
FOREIGN KEY (fk_municipio) REFERENCES municipios(pk_municipio)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- festivales
ALTER TABLE festivales
ADD CONSTRAINT municipios_festivales
FOREIGN KEY (fk_municipio) REFERENCES municipios(pk_municipio)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE festivales
ADD CONSTRAINT empresas_festivales
FOREIGN KEY (fk_empresa) REFERENCES empresas(pk_empresa)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- ediciones
ALTER TABLE ediciones
ADD CONSTRAINT festivales_ediciones
FOREIGN KEY (fk_festival) REFERENCES festivales(pk_festival)
ON UPDATE CASCADE
ON DELETE CASCADE; -- entidad débil: si se borra el festival, se borran sus ediciones

ALTER TABLE ediciones
ADD CONSTRAINT anios_ediciones
FOREIGN KEY (fk_anio) REFERENCES anios(pk_anio)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- actuaciones
ALTER TABLE actuaciones
ADD CONSTRAINT ediciones_actuaciones
FOREIGN KEY (fk_edicion) REFERENCES ediciones(pk_edicion)
ON UPDATE CASCADE
ON DELETE CASCADE; -- sigue la cadena: sin edición, sus actuaciones no tienen sentido

ALTER TABLE actuaciones
ADD CONSTRAINT artistas_actuaciones
FOREIGN KEY (fk_artista) REFERENCES artistas(pk_artista)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE actuaciones
ADD CONSTRAINT recintos_actuaciones
FOREIGN KEY (fk_recinto) REFERENCES recintos(pk_recinto)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- setlists
ALTER TABLE setlists
ADD CONSTRAINT actuaciones_setlists
FOREIGN KEY (fk_actuacion) REFERENCES actuaciones(pk_actuacion)
ON UPDATE CASCADE
ON DELETE CASCADE; -- sin actuación, su setlist no tiene sentido

ALTER TABLE setlists
ADD CONSTRAINT canciones_setlists
FOREIGN KEY (fk_cancion) REFERENCES canciones(pk_cancion)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- patrocinios
ALTER TABLE patrocinios
ADD CONSTRAINT patrocinadores_patrocinios
FOREIGN KEY (fk_patrocinador) REFERENCES patrocinadores(pk_patrocinador)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE patrocinios
ADD CONSTRAINT ediciones_patrocinios
FOREIGN KEY (fk_edicion) REFERENCES ediciones(pk_edicion)
ON UPDATE CASCADE
ON DELETE CASCADE; -- sin edición, sus patrocinios no tienen sentido


-- =========================================================
-- TRIGGERS
-- Regla que un CHECK no puede comprobar porque necesita mirar otra tabla:
-- la fecha de una actuación debe estar entre las fechas de su edición.
-- =========================================================

DELIMITER $$

CREATE TRIGGER tr_actuaciones_fecha_insertar
BEFORE INSERT ON actuaciones
FOR EACH ROW
BEGIN
  IF NEW.fecha < (SELECT fecha_inicio FROM ediciones WHERE pk_edicion = NEW.fk_edicion)
     OR NEW.fecha > (SELECT fecha_fin FROM ediciones WHERE pk_edicion = NEW.fk_edicion) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La fecha de la actuación debe estar dentro de las fechas de su edición';
  END IF;
END $$

CREATE TRIGGER tr_actuaciones_fecha_actualizar
BEFORE UPDATE ON actuaciones
FOR EACH ROW
BEGIN
  IF NEW.fecha < (SELECT fecha_inicio FROM ediciones WHERE pk_edicion = NEW.fk_edicion)
     OR NEW.fecha > (SELECT fecha_fin FROM ediciones WHERE pk_edicion = NEW.fk_edicion) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La fecha de la actuación debe estar dentro de las fechas de su edición';
  END IF;
END $$

DELIMITER ;
