-- =====================================================
-- БИЛЕТ 7 - Задание 3
-- Полный SQL код: создание БД, заполнение, запросы
-- =====================================================

-- =====================================================
-- ЧАСТЬ 1: MYSQL ВЕРСИЯ
-- =====================================================

-- Создание базы данных
CREATE DATABASE IF NOT EXISTS GoodsDB;
USE GoodsDB;

-- Таблица РЕГИОНЫ
CREATE TABLE Region (
    region_id INT PRIMARY KEY AUTO_INCREMENT,
    region_name VARCHAR(100) NOT NULL,
    region_type VARCHAR(50) NOT NULL
);

-- Таблица ФИРМЫ (ПРОИЗВОДИТЕЛИ)
CREATE TABLE Manufacturer (
    manufacturer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    address VARCHAR(300),
    phone VARCHAR(20)
);

-- Таблица ТОВАРЫ
CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL,
    purchase_price DECIMAL(10,2) NOT NULL,
    manufacturer_id INT NOT NULL,
    region_id INT NOT NULL,
    FOREIGN KEY (manufacturer_id) REFERENCES Manufacturer(manufacturer_id),
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

-- Заполнение таблицы Region
INSERT INTO Region (region_name, region_type) VALUES
('Владивосток', 'восточный'),
('Хабаровск', 'восточный'),
('Иркутск', 'восточный'),
('Москва', 'центральный'),
('Санкт-Петербург', 'западный');

-- Заполнение таблицы Manufacturer
INSERT INTO Manufacturer (name, address, phone) VALUES
('ООО "Восток"', 'г. Владивосток, ул. Примерная, 1', '+7-423-123-4567'),
('ЗАО "Сибирь"', 'г. Иркутск, ул. Ленина, 10', '+7-395-234-5678'),
('ООО "Столица"', 'г. Москва, ул. Тверская, 5', '+7-495-345-6789');

-- Заполнение таблицы Product
INSERT INTO Product (name, sale_price, purchase_price, manufacturer_id, region_id) VALUES
('Товар А', 250.00, 120.00, 1, 1),
('Товар Б', 180.00, 100.00, 1, 1),
('Товар В', 300.00, 140.00, 2, 2),
('Товар Г', 220.00, 180.00, 3, 4),
('Товар Д', 150.00, 80.00, 2, 3);


-- =====================================================
-- ЧАСТЬ 2: POSTGRESQL ВЕРСИЯ
-- =====================================================

-- Создание базы данных (выполняется отдельно, вне транзакции)
-- CREATE DATABASE GoodsDB;
-- \c GoodsDB; -- Команда подключения к БД в консоли psql

-- Таблица РЕГИОНЫ (SERIAL используется для автоинкремента)
CREATE TABLE Region (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL,
    region_type VARCHAR(50) NOT NULL
);

-- Таблица ФИРМЫ (ПРОИЗВОДИТЕЛИ)
CREATE TABLE Manufacturer (
    manufacturer_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    address VARCHAR(300),
    phone VARCHAR(20)
);

-- Таблица ТОВАРЫ
CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL,
    purchase_price DECIMAL(10,2) NOT NULL,
    manufacturer_id INT NOT NULL,
    region_id INT NOT NULL,
    FOREIGN KEY (manufacturer_id) REFERENCES Manufacturer(manufacturer_id),
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

-- Заполнение таблиц (синтаксис идентичен MySQL)
INSERT INTO Region (region_name, region_type) VALUES
('Владивосток', 'восточный'),
('Хабаровск', 'восточный'),
('Иркутск', 'восточный'),
('Москва', 'центральный'),
('Санкт-Петербург', 'западный');

INSERT INTO Manufacturer (name, address, phone) VALUES
('ООО "Восток"', 'г. Владивосток, ул. Примерная, 1', '+7-423-123-4567'),
('ЗАО "Сибирь"', 'г. Иркутск, ул. Ленина, 10', '+7-395-234-5678'),
('ООО "Столица"', 'г. Москва, ул. Тверская, 5', '+7-495-345-6789');

INSERT INTO Product (name, sale_price, purchase_price, manufacturer_id, region_id) VALUES
('Товар А', 250.00, 120.00, 1, 1),
('Товар Б', 180.00, 100.00, 1, 1),
('Товар В', 300.00, 140.00, 2, 2),
('Товар Г', 220.00, 180.00, 3, 4),
('Товар Д', 150.00, 80.00, 2, 3);


-- =====================================================
-- ЧАСТЬ 3: ЗАПРОСЫ ПО ТРЕБОВАНИЯМ БИЛЕТА
-- (Синтаксис полностью идентичен для MySQL и PostgreSQL)
-- =====================================================

-- ЗАПРОС 1: Какие товары имеют продажную цену более 200 рублей?
SELECT 
    name AS товар,
    sale_price AS продажная_цена
FROM Product
WHERE sale_price > 200;

-- ЗАПРОС 2: Какие из них имеют закупочную цену менее 150 рублей?
SELECT 
    name AS товар,
    sale_price AS продажная_цена,
    purchase_price AS закупочная_цена
FROM Product
WHERE sale_price > 200 
  AND purchase_price < 150;

-- ЗАПРОС 3: Какие товары произведены в восточных регионах России?
SELECT 
    p.name AS товар,
    r.region_name AS регион
FROM Product p
JOIN Region r ON p.region_id = r.region_id
WHERE r.region_type = 'восточный';

-- ЗАПРОС 4: Какие фирмы производят эти товары (в восточных регионах)?
SELECT DISTINCT
    m.name AS фирма
FROM Manufacturer m
JOIN Product p ON m.manufacturer_id = p.manufacturer_id
JOIN Region r ON p.region_id = r.region_id
WHERE r.region_type = 'восточный';