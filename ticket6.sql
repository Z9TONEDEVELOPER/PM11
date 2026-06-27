-- =====================================================
-- БИЛЕТ 6 - Задание 3
-- Создание базы данных Product/PC/Laptop/Printer
-- Запрос: Найти ноутбуки с ценой > 1000$
-- ИСПРАВЛЕННАЯ ВЕРСИЯ
-- =====================================================

-- =====================================================
-- MySQL версия
-- =====================================================

-- Создание базы данных
CREATE DATABASE IF NOT EXISTS ComputerShop;
USE ComputerShop;

-- Создание таблицы Product
CREATE TABLE Product (
    maker VARCHAR(10),
    model VARCHAR(50) PRIMARY KEY,
    type VARCHAR(50)
);

-- Создание таблицы PC
CREATE TABLE PC (
    code INT PRIMARY KEY,
    model VARCHAR(50),
    speed SMALLINT,
    ram SMALLINT,
    hd REAL,
    cd VARCHAR(10),
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Создание таблицы Laptop
CREATE TABLE Laptop (
    code INT PRIMARY KEY,
    model VARCHAR(50),
    speed SMALLINT,
    ram SMALLINT,
    hd REAL,
    screen TINYINT,
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Создание таблицы Printer
CREATE TABLE Printer (
    code INT PRIMARY KEY,
    model VARCHAR(50),
    color CHAR(1),
    type VARCHAR(10),
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Заполнение таблицы Product
INSERT INTO Product VALUES
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
INSERT INTO PC VALUES
(1, '1232', 500, 64, 5, '12x', 600),
(2, '1233', 450, 64, 6, '12x', 400),
(3, '1752', 500, 32, 10, '12x', 600),
(4, '1321', 600, 128, 10, '12x', 800);

-- Заполнение таблицы Laptop
INSERT INTO Laptop VALUES
(1, '1298', 350, 32, 4, 11, 800),
(2, '1750', 550, 32, 6, 14, 1100),
(3, '1324', 600, 64, 8, 14, 1200),
(4, '1401', 700, 128, 10, 15, 1500);

-- Заполнение таблицы Printer
INSERT INTO Printer VALUES
(1, '1260', 'y', 'jet', 200),
(2, '1749', 'n', 'laser', 300),
(3, '1319', 'y', 'jet', 250),
(4, '1402', 'y', 'laser', 400);

-- =====================================================
-- ЗАПРОС: Найти номер модели, объем памяти и 
-- размеры экранов ноутбуков, цена которых 
-- превышает 1000 долларов
-- Вывести: model, ram, screen
-- =====================================================

SELECT model, ram, screen
FROM Laptop
WHERE price > 1000;

-- =====================================================
-- PostgreSQL версия
-- =====================================================

-- Создание базы данных
CREATE DATABASE ComputerShop;
\c ComputerShop;

-- Создание таблицы Product
CREATE TABLE Product (
    maker VARCHAR(10),
    model VARCHAR(50) PRIMARY KEY,
    type VARCHAR(50)
);

-- Создание таблицы PC
CREATE TABLE PC (
    code INT PRIMARY KEY,
    model VARCHAR(50),
    speed SMALLINT,
    ram SMALLINT,
    hd REAL,
    cd VARCHAR(10),
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Создание таблицы Laptop
CREATE TABLE Laptop (
    code INT PRIMARY KEY,
    model VARCHAR(50),
    speed SMALLINT,
    ram SMALLINT,
    hd REAL,
    screen SMALLINT,
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Создание таблицы Printer
CREATE TABLE Printer (
    code INT PRIMARY KEY,
    model VARCHAR(50),
    color CHAR(1),
    type VARCHAR(10),
    price DECIMAL(10,2),
    FOREIGN KEY (model) REFERENCES Product(model)
);

-- Заполнение таблиц (те же данные)
INSERT INTO Product VALUES
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

INSERT INTO PC VALUES
(1, '1232', 500, 64, 5, '12x', 600),
(2, '1233', 450, 64, 6, '12x', 400),
(3, '1752', 500, 32, 10, '12x', 600),
(4, '1321', 600, 128, 10, '12x', 800);

INSERT INTO Laptop VALUES
(1, '1298', 350, 32, 4, 11, 800),
(2, '1750', 550, 32, 6, 14, 1100),
(3, '1324', 600, 64, 8, 14, 1200),
(4, '1401', 700, 128, 10, 15, 1500);

INSERT INTO Printer VALUES
(1, '1260', 'y', 'jet', 200),
(2, '1749', 'n', 'laser', 300),
(3, '1319', 'y', 'jet', 250),
(4, '1402', 'y', 'laser', 400);

-- Запрос (синтаксис идентичен MySQL)
SELECT model, ram, screen
FROM Laptop
WHERE price > 1000;