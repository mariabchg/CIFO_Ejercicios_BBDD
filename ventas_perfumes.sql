-- ventas_perfumes.sql

CREATE DATABASE IF NOT EXISTS open_data
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE open_data;

-- tabla ventas
CREATE TABLE IF NOT EXISTS ventas (
  anio year not null,
  mes tinyint UNSIGNED not null CHECK (mes BETWEEN 1 AND 12),
  id_producto int not null,
  producto varchar(100) not null,
  provincia varchar(20) not null,
  ventas int UNSIGNED not null,
  CONSTRAINT pk_ventas PRIMARY KEY (anio, mes, id_producto, provincia)
);

-- importar el csv
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/documentos_excel_normalizado.csv'
INTO TABLE ventas
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

