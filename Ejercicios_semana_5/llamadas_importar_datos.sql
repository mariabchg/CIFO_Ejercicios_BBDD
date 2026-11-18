-- llamadas.sql

DROP DATABASE IF EXISTS llamadas;
CREATE DATABASE llamadas
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE llamadas;

-- tabla llamadas
CREATE TABLE llamadas (
  pk_llamada int AUTO_INCREMENT,
  tipo_llamada varchar(10) not null,
  destino varchar(30) not null,
  numero_telefono char(9) not null,
  fecha date not null,
  numero_destino char(9) not null,
  importe_llamada decimal(6,4) not null,
  minutos tinyint UNSIGNED not null,
  segundos tinyint UNSIGNED not null,
  CONSTRAINT pk_llamadas PRIMARY KEY (pk_llamada),
  CONSTRAINT importe_positivo CHECK (importe_llamada > 0),
  CONSTRAINT segundos_validos CHECK (segundos BETWEEN 0 AND 59)
);

-- importar el csv 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/llamadas_normalizado.csv'
INTO TABLE llamadas
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(tipo_llamada, destino, numero_telefono, fecha, numero_destino, importe_llamada, minutos, segundos);
