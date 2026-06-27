// =====================================================
// БИЛЕТ 25 - Задание 3
// Концептуальная и логическая модель данных для dbdiagram.io
// База данных Computer Shop
// =====================================================

// Таблица Product (Изделия)
Table Product {
  maker varchar(10) [not null]
  model varchar(50) [pk, not null]
  type varchar(50) [not null]
}

// Таблица PC (Настольные компьютеры)
Table PC {
  code int [pk, increment]
  model varchar(50) [not null, ref: > Product.model]
  speed smallint [not null]
  ram smallint [not null]
  hd real [not null]
  cd varchar(10) [not null]
  price money
}

// Таблица Laptop (Портативные компьютеры)
Table Laptop {
  code int [pk, increment]
  model varchar(50) [not null, ref: > Product.model]
  speed smallint [not null]
  ram smallint [not null]
  hd real [not null]
  screen tinyint [not null]
  price money
}

// Таблица Printer (Принтеры)
Table Printer {
  code int [pk, increment]
  model varchar(50) [not null, ref: > Product.model]
  color char(1) [not null]
  type varchar(10) [not null]
  price money
}


-- =====================================================
-- БИЛЕТ 25 - Задание 3
-- Создание базы данных Computer Shop
-- Запрос: Найти пары PC с одинаковыми speed и RAM
-- ИСПРАВЛЕННАЯ ВЕРСИЯ
-- =====================================================

-- =====================================================
-- MYSQL ВЕРСИЯ
-- =====================================================

CREATE DATABASE IF NOT EXISTS ComputerShop;
USE ComputerShop;

-- Создание таблицы Product
CREATE TABLE Product (
    maker VARCHAR(10) NOT NULL,
    model VARCHAR(50) PRIMARY KEY NOT NULL,
    type VARCHAR(50) NOT NULL
);

-- Создание таблицы PC
CREATE TABLE PC (
    code INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(50) NOT NULL,
    speed SMALLINT NOT NULL,
    ram SMALLINT NOT NULL,
    hd REAL NOT NULL,
    cd VARCHAR(10) NOT NULL,
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Создание таблицы Laptop
CREATE TABLE Laptop (
    code INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(50) NOT NULL,
    speed SMALLINT NOT NULL,
    ram SMALLINT NOT NULL,
    hd REAL NOT NULL,
    screen TINYINT NOT NULL,
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Создание таблицы Printer
CREATE TABLE Printer (
    code INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(50) NOT NULL,
    color CHAR(1) NOT NULL,
    type VARCHAR(10) NOT NULL,
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Заполнение таблицы Product (ВСЕ модели должны быть добавлены!)
INSERT INTO Product (maker, model, type) VALUES
('A', '1232', 'PC'),
('A', '1233', 'PC'),
('B', '1752', 'PC'),
('C', '1321', 'PC'),
('A', '1260', 'PC'),  -- Добавлена модель для PC
('D', '1280', 'PC'),  -- Добавлена модель для PC
('A', '1298', 'Laptop'),
('B', '1750', 'Laptop'),
('C', '1324', 'Laptop'),
('D', '1401', 'Laptop'),
('A', '1261', 'Printer'),  -- Изменили чтобы не конфликтовало
('B', '1749', 'Printer'),
('C', '1319', 'Printer'),
('D', '1402', 'Printer');

-- Заполнение таблицы PC
-- Специально добавим ПК с одинаковыми speed и ram для теста
INSERT INTO PC (model, speed, ram, hd, cd, price) VALUES
('1232', 500, 64, 5.0, '12x', 600.00),
('1233', 450, 64, 6.0, '12x', 400.00),
('1752', 500, 32, 10.0, '12x', 600.00),
('1321', 600, 128, 10.0, '12x', 800.00),
('1260', 500, 64, 8.0, '48x', 550.00),  -- Такая же speed и ram как у 1232
('1280', 450, 64, 12.0, '24x', 450.00);  -- Такая же speed и ram как у 1233

-- Заполнение таблицы Laptop
INSERT INTO Laptop (model, speed, ram, hd, screen, price) VALUES
('1298', 350, 32, 4.0, 11, 800.00),
('1750', 550, 32, 6.0, 14, 1100.00),
('1324', 600, 64, 8.0, 14, 1200.00),
('1401', 700, 128, 10.0, 15, 1500.00);

-- Заполнение таблицы Printer
INSERT INTO Printer (model, color, type, price) VALUES
('1261', 'y', 'jet', 200.00),
('1749', 'n', 'laser', 300.00),
('1319', 'y', 'jet', 250.00),
('1402', 'y', 'laser', 400.00);


-- =====================================================
-- POSTGRESQL ВЕРСИЯ
-- =====================================================

-- CREATE DATABASE ComputerShop;
-- \c ComputerShop;

CREATE TABLE Product (
    maker VARCHAR(10) NOT NULL,
    model VARCHAR(50) PRIMARY KEY NOT NULL,
    type VARCHAR(50) NOT NULL
);

CREATE TABLE PC (
    code SERIAL PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    speed SMALLINT NOT NULL,
    ram SMALLINT NOT NULL,
    hd REAL NOT NULL,
    cd VARCHAR(10) NOT NULL,
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

CREATE TABLE Laptop (
    code SERIAL PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    speed SMALLINT NOT NULL,
    ram SMALLINT NOT NULL,
    hd REAL NOT NULL,
    screen SMALLINT NOT NULL,
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

CREATE TABLE Printer (
    code SERIAL PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    color CHAR(1) NOT NULL,
    type VARCHAR(10) NOT NULL,
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Заполнение таблиц (аналогично MySQL)
INSERT INTO Product (maker, model, type) VALUES
('A', '1232', 'PC'),
('A', '1233', 'PC'),
('B', '1752', 'PC'),
('C', '1321', 'PC'),
('A', '1260', 'PC'),
('D', '1280', 'PC'),
('A', '1298', 'Laptop'),
('B', '1750', 'Laptop'),
('C', '1324', 'Laptop'),
('D', '1401', 'Laptop'),
('A', '1261', 'Printer'),
('B', '1749', 'Printer'),
('C', '1319', 'Printer'),
('D', '1402', 'Printer');

INSERT INTO PC (model, speed, ram, hd, cd, price) VALUES
('1232', 500, 64, 5.0, '12x', 600.00),
('1233', 450, 64, 6.0, '12x', 400.00),
('1752', 500, 32, 10.0, '12x', 600.00),
('1321', 600, 128, 10.0, '12x', 800.00),
('1260', 500, 64, 8.0, '48x', 550.00),
('1280', 450, 64, 12.0, '24x', 450.00);

INSERT INTO Laptop (model, speed, ram, hd, screen, price) VALUES
('1298', 350, 32, 4.0, 11, 800.00),
('1750', 550, 32, 6.0, 14, 1100.00),
('1324', 600, 64, 8.0, 14, 1200.00),
('1401', 700, 128, 10.0, 15, 1500.00);

INSERT INTO Printer (model, color, type, price) VALUES
('1261', 'y', 'jet', 200.00),
('1749', 'n', 'laser', 300.00),
('1319', 'y', 'jet', 250.00),
('1402', 'y', 'laser', 400.00);


-- =====================================================
-- ЗАПРОС ПО ТРЕБОВАНИЮ БИЛЕТА
-- =====================================================

-- ЗАПРОС: Найти пары моделей PC, имеющих одинаковые 
-- скорость и RAM
SELECT 
    pc1.model AS model_higher,
    pc2.model AS model_lower,
    pc1.speed,
    pc1.ram
FROM PC pc1
JOIN PC pc2 ON pc1.speed = pc2.speed 
           AND pc1.ram = pc2.ram 
           AND pc1.model > pc2.model
ORDER BY pc1.speed, pc1.ram, pc1.model, pc2.model;