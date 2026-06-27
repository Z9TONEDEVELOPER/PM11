Кардинальность связей для понимания:
Директор (1) — (M) Автосалон: Один директор может управлять несколькими салонами, но у каждого салона только один директор.
Автосалон (1) — (M) Автомобиль: В одном салоне продается много машин, но конкретная машина продается только в одном салоне.
// =====================================================
// БИЛЕТ 8 - Задание 3
// Концептуальная модель данных для dbdiagram.io
// =====================================================

// Таблица ДИРЕКТОРА
Table Director {
  director_id int [pk, increment] // Первичный ключ
  full_name varchar(200) [not null] // ФИО директора
}

// Таблица АВТОСАЛОНЫ
Table Dealership {
  dealership_id int [pk, increment] // Первичный ключ
  address varchar(300) [not null] // Адрес салона
  phone varchar(20) // Телефон салона
  director_id int [not null] // Внешний ключ на директора
}

// Таблица АВТОМОБИЛИ
Table Car {
  car_id int [pk, increment] // Первичный ключ
  brand varchar(100) [not null] // Марка автомобиля
  year int // Год выпуска
  color varchar(50) // Цвет
  dealership_id int [not null] // Внешний ключ на автосалон
}

// =====================================================
// СВЯЗИ МЕЖДУ ТАБЛИЦАМИ
// =====================================================

// Связь 1: Один директор управляет многими автосалонами (1:M)
Ref: Dealership.director_id > Director.director_id

// Связь 2: Один автосалон продает много автомобилей (1:M)
Ref: Car.dealership_id > Dealership.dealership_id


-- =====================================================
-- БИЛЕТ 8 - Задание 3
-- Полный SQL код: создание БД, заполнение, запросы
-- =====================================================

-- =====================================================
-- ЧАСТЬ 1: MYSQL ВЕРСИЯ
-- =====================================================

-- Создание базы данных
CREATE DATABASE IF NOT EXISTS CarSalesDB;
USE CarSalesDB;

-- Таблица ДИРЕКТОРА
CREATE TABLE Director (
    director_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(200) NOT NULL
);

-- Таблица АВТОСАЛОНЫ
CREATE TABLE Dealership (
    dealership_id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(300) NOT NULL,
    phone VARCHAR(20),
    director_id INT NOT NULL,
    FOREIGN KEY (director_id) REFERENCES Director(director_id)
);

-- Таблица АВТОМОБИЛИ
CREATE TABLE Car (
    car_id INT PRIMARY KEY AUTO_INCREMENT,
    brand VARCHAR(100) NOT NULL,
    year INT,
    color VARCHAR(50),
    dealership_id INT NOT NULL,
    FOREIGN KEY (dealership_id) REFERENCES Dealership(dealership_id)
);

-- Заполнение таблицы Director
INSERT INTO Director (full_name) VALUES
('Иванов Иван Иванович'),
('Петров Петр Петрович');

-- Заполнение таблицы Dealership
INSERT INTO Dealership (address, phone, director_id) VALUES
('г. Москва, ул. Ленина, 1', '+7-495-111-1111', 1), -- Директор Иванов
('г. Москва, ул. Пушкина, 10', '+7-495-222-2222', 1), -- Тот же директор Иванов
('г. СПб, Невский проспект, 50', '+7-812-333-3333', 2); -- Директор Петров

-- Заполнение таблицы Car
INSERT INTO Car (brand, year, color, dealership_id) VALUES
('Toyota Camry', 2022, 'Черный', 1),
('Honda Civic', 2021, 'Белый', 1),
('BMW X5', 2023, 'Синий', 2),
('Audi A4', 2020, 'Серый', 3);


-- =====================================================
-- ЧАСТЬ 2: POSTGRESQL ВЕРСИЯ
-- =====================================================

-- Создание базы данных (выполняется отдельно)
-- CREATE DATABASE CarSalesDB;
-- \c CarSalesDB;

-- Таблица ДИРЕКТОРА
CREATE TABLE Director (
    director_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL
);

-- Таблица АВТОСАЛОНЫ
CREATE TABLE Dealership (
    dealership_id SERIAL PRIMARY KEY,
    address VARCHAR(300) NOT NULL,
    phone VARCHAR(20),
    director_id INT NOT NULL,
    FOREIGN KEY (director_id) REFERENCES Director(director_id)
);

-- Таблица АВТОМОБИЛИ
CREATE TABLE Car (
    car_id SERIAL PRIMARY KEY,
    brand VARCHAR(100) NOT NULL,
    year INT,
    color VARCHAR(50),
    dealership_id INT NOT NULL,
    FOREIGN KEY (dealership_id) REFERENCES Dealership(dealership_id)
);

-- Заполнение таблиц (синтаксис идентичен MySQL)
INSERT INTO Director (full_name) VALUES
('Иванов Иван Иванович'),
('Петров Петр Петрович');

INSERT INTO Dealership (address, phone, director_id) VALUES
('г. Москва, ул. Ленина, 1', '+7-495-111-1111', 1),
('г. Москва, ул. Пушкина, 10', '+7-495-222-2222', 1),
('г. СПб, Невский проспект, 50', '+7-812-333-3333', 2);

INSERT INTO Car (brand, year, color, dealership_id) VALUES
('Toyota Camry', 2022, 'Черный', 1),
('Honda Civic', 2021, 'Белый', 1),
('BMW X5', 2023, 'Синий', 2),
('Audi A4', 2020, 'Серый', 3);


-- =====================================================
-- ЧАСТЬ 3: ПРОВЕРОЧНЫЕ ЗАПРОСЫ
-- =====================================================

-- ЗАПРОС 1: Вывести все автомобили и автосалоны, где они продаются
SELECT 
    c.brand AS марка,
    c.year AS год,
    c.color AS цвет,
    d.address AS адрес_салона
FROM Car c
JOIN Dealership d ON c.dealership_id = d.dealership_id;

-- ЗАПРОС 2: Найти ФИО директора конкретного автосалона (например, по адресу)
SELECT 
    d.address AS салон,
    dir.full_name AS директор
FROM Dealership d
JOIN Director dir ON d.director_id = dir.director_id
WHERE d.address = 'г. Москва, ул. Ленина, 1';

-- ЗАПРОС 3: Найти все автосалоны, которыми управляет конкретный директор
SELECT 
    dir.full_name AS директор,
    d.address AS салон,
    d.phone AS телефон
FROM Director dir
JOIN Dealership d ON dir.director_id = d.director_id
WHERE dir.full_name = 'Иванов Иван Иванович';