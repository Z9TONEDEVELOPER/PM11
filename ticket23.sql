// =====================================================
// БИЛЕТ 23 - Задание 3
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
-- БИЛЕТ 23 - Задание 3
-- Создание базы данных Computer Shop
-- Запрос: Найти ПК с 12x или 24x CD и ценой < 600$
-- =====================================================

-- =====================================================
-- ЧАСТЬ 1: MYSQL ВЕРСИЯ
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

-- Заполнение таблицы Product
INSERT INTO Product (maker, model, type) VALUES
('A', '1232', 'PC'),
('A', '1233', 'PC'),
('B', '1752', 'PC'),
('C', '1321', 'PC'),
('A', '1298', 'Laptop'),
('B', '1750', 'Laptop'),
('C', '1324', 'Laptop'),
('D', '1401', 'Laptop'),
('A', '1260', 'Printer'),
('B', '1749', 'Printer'),
('C', '1319', 'Printer'),
('D', '1402', 'Printer');

-- Заполнение таблицы PC
INSERT INTO PC (model, speed, ram, hd, cd, price) VALUES
('1232', 500, 64, 5.0, '12x', 600.00),
('1233', 450, 64, 6.0, '12x', 400.00),
('1752', 500, 32, 10.0, '12x', 600.00),
('1321', 600, 128, 10.0, '12x', 800.00);

-- Заполнение таблицы Laptop
INSERT INTO Laptop (model, speed, ram, hd, screen, price) VALUES
('1298', 350, 32, 4.0, 11, 800.00),
('1750', 550, 32, 6.0, 14, 1100.00),
('1324', 600, 64, 8.0, 14, 1200.00),
('1401', 700, 128, 10.0, 15, 1500.00);

-- Заполнение таблицы Printer
INSERT INTO Printer (model, color, type, price) VALUES
('1260', 'y', 'jet', 200.00),
('1749', 'n', 'laser', 300.00),
('1319', 'y', 'jet', 250.00),
('1402', 'y', 'laser', 400.00);


-- =====================================================
-- ЧАСТЬ 2: POSTGRESQL ВЕРСИЯ
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

-- Заполнение таблиц идентично MySQL


-- =====================================================
-- ЧАСТЬ 3: ЗАПРОС ПО ТРЕБОВАНИЮ БИЛЕТА
-- =====================================================

-- ЗАПРОС: Найти номер модели, скорость и размер 
-- жесткого диска ПК, имеющих 12х или 24х CD 
-- и цену менее 600 долларов
-- Вывести: model, speed, hd

-- MySQL и PostgreSQL (синтаксис идентичен)
SELECT 
    model,
    speed,
    hd
FROM PC
WHERE (cd = '12x' OR cd = '24x')
  AND price < 600
ORDER BY model;

-- =====================================================
-- Альтернативный вариант с использованием IN
-- =====================================================

SELECT 
    model,
    speed,
    hd
FROM PC
WHERE cd IN ('12x', '24x')
  AND price < 600
ORDER BY model;

-- =====================================================
-- Пояснение:
-- - WHERE cd = '12x' OR cd = '24x' - фильтруем ПК 
--   с приводом 12x или 24x
-- - AND price < 600 - цена должна быть меньше 600$
-- - ORDER BY model - сортируем по модели для удобства
-- - В наших тестовых данных:
--   * PC 1232: cd='12x', price=600 - НЕ подходит (цена = 600, а не < 600)
--   * PC 1233: cd='12x', price=400 - ПОДХОДИТ
--   * PC 1752: cd='12x', price=600 - НЕ подходит (цена = 600)
--   * PC 1321: cd='12x', price=800 - НЕ подходит (цена > 600)
-- Результат: только модель 1233
-- =====================================================