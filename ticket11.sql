// =====================================================
// БИЛЕТ 11 - Задание 3
// Концептуальная модель данных для dbdiagram.io
// Банковские счета и служащие
// =====================================================

// Таблица ОБЛАДАТЕЛИ СЧЕТОВ (супертип)
Table AccountHolder {
  holder_id int [pk, increment]
  full_name varchar(200) [not null]
  holder_type varchar(50) [not null] // 'client', 'cashier', 'manager'
}

// Таблица СЧЕТА
Table Account {
  account_id int [pk, increment]
  account_number varchar(50) [not null]
  account_type varchar(50) [not null] // 'current' (текущий), 'savings' (сберегательный)
  balance decimal(15,2) [not null]
}

// Таблица СВЯЗИ ОБЛАДАТЕЛЬ-СЧЕТ (M:N)
Table HolderAccount {
  holder_id int [pk]
  account_id int [pk]
}

// =====================================================
// СВЯЗИ МЕЖДУ ТАБЛИЦАМИ
// =====================================================

Ref: HolderAccount.holder_id > AccountHolder.holder_id
Ref: HolderAccount.account_id > Account.account_id

// =====================================================
// ПРИМЕЧАНИЕ ПО СПЕЦИАЛИЗАЦИИ (НАСЛЕДОВАНИЮ)
// =====================================================
// В концептуальной модели (ER-диаграмме) это отображается так:
// 
// ОБЛАДАТЕЛЬ_СЧЕТА (супертип)
//   ├── КЛИЕНТ (подтип)
//   └── СЛУЖАЩИЙ (подтип)
//         ├── КАССИР (подтип)
//         └── МЕНЕДЖЕР (подтип)
//
// СЧЕТ (супертип)
//   ├── ТЕКУЩИЙ_СЧЕТ (подтип)
//   └── СБЕРЕГАТЕЛЬНЫЙ_СЧЕТ (подтип)
//
// Связь M:N между ОБЛАДАТЕЛЬ_СЧЕТА и СЧЕТ

-- =====================================================
-- БИЛЕТ 11 - Задание 3
-- Полный SQL код: создание БД, заполнение, запросы
-- =====================================================

-- =====================================================
-- ЧАСТЬ 1: MYSQL ВЕРСИЯ
-- =====================================================

CREATE DATABASE IF NOT EXISTS BankDB;
USE BankDB;

-- Таблица ОБЛАДАТЕЛИ СЧЕТОВ
CREATE TABLE AccountHolder (
    holder_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(200) NOT NULL,
    holder_type VARCHAR(50) NOT NULL -- 'client', 'cashier', 'manager'
);

-- Таблица СЧЕТА
CREATE TABLE Account (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(50) NOT NULL,
    account_type VARCHAR(50) NOT NULL, -- 'current' (текущий), 'savings' (сберегательный)
    balance DECIMAL(15,2) NOT NULL
);

-- Таблица СВЯЗИ ОБЛАДАТЕЛЬ-СЧЕТ (M:N)
CREATE TABLE HolderAccount (
    holder_id INT NOT NULL,
    account_id INT NOT NULL,
    PRIMARY KEY (holder_id, account_id),
    FOREIGN KEY (holder_id) REFERENCES AccountHolder(holder_id),
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

-- Заполнение таблицы AccountHolder
INSERT INTO AccountHolder (full_name, holder_type) VALUES
('Иванов Иван', 'client'),
('Петров Петр', 'client'),
('Сидоров Сидор', 'cashier'),
('Кузнецов Кузьма', 'cashier'),
('Смирнова Анна', 'manager'),
('Волков Виктор', 'manager'),
('Зайцев Захар', 'cashier'),
('Морозова Мария', 'client');

-- Заполнение таблицы Account
INSERT INTO Account (account_number, account_type, balance) VALUES
('1001', 'current', 50000.00),
('1002', 'current', 75000.00),
('1003', 'savings', 100000.00),
('1004', 'current', 30000.00),
('1005', 'savings', 200000.00),
('1006', 'current', 45000.00),
('1007', 'savings', 150000.00),
('1008', 'current', 60000.00);

-- Заполнение таблицы HolderAccount (связи)
INSERT INTO HolderAccount (holder_id, account_id) VALUES
(1, 1), -- Клиент Иванов имеет текущий счет
(2, 2), -- Клиент Петров имеет текущий счет
(3, 3), -- Кассир Сидоров имеет сберегательный счет
(4, 4), -- Кассир Кузнецов имеет текущий счет
(5, 5), -- Менеджер Смирнова имеет сберегательный счет
(6, 6), -- Менеджер Волков имеет текущий счет
(7, 7), -- Кассир Зайцев имеет сберегательный счет
(8, 8); -- Клиент Морозова имеет текущий счет


-- =====================================================
-- ЧАСТЬ 2: POSTGRESQL ВЕРСИЯ
-- =====================================================

-- CREATE DATABASE BankDB;
-- \c BankDB;

CREATE TABLE AccountHolder (
    holder_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    holder_type VARCHAR(50) NOT NULL
);

CREATE TABLE Account (
    account_id SERIAL PRIMARY KEY,
    account_number VARCHAR(50) NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    balance DECIMAL(15,2) NOT NULL
);

CREATE TABLE HolderAccount (
    holder_id INT NOT NULL,
    account_id INT NOT NULL,
    PRIMARY KEY (holder_id, account_id),
    FOREIGN KEY (holder_id) REFERENCES AccountHolder(holder_id),
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

-- Заполнение таблиц идентично MySQL


-- =====================================================
-- ЧАСТЬ 3: ЗАПРОСЫ ПО ТРЕБОВАНИЯМ БИЛЕТА
-- =====================================================

-- ЗАПРОС 1: Какой процент обладателей текущих счетов банка составляют его служащие?
SELECT 
    COUNT(CASE WHEN ah.holder_type IN ('cashier', 'manager') THEN 1 END) * 100.0 / 
    COUNT(*) AS процент_служащих
FROM AccountHolder ah
JOIN HolderAccount ha ON ah.holder_id = ha.holder_id
JOIN Account a ON ha.account_id = a.account_id
WHERE a.account_type = 'current';

-- ЗАПРОС 2: Сколько кассиров и менеджеров имеют в банке сберегательные счета?
SELECT 
    ah.holder_type AS тип_служащего,
    COUNT(DISTINCT ah.holder_id) AS количество
FROM AccountHolder ah
JOIN HolderAccount ha ON ah.holder_id = ha.holder_id
JOIN Account a ON ha.account_id = a.account_id
WHERE ah.holder_type IN ('cashier', 'manager')
  AND a.account_type = 'savings'
GROUP BY ah.holder_type;

-- ЗАПРОС 3: Сколько кассиров не имеют сберегательных счетов?
SELECT 
    COUNT(*) AS количество_кассиров_без_счетов
FROM AccountHolder ah
WHERE ah.holder_type = 'cashier'
  AND ah.holder_id NOT IN (
      SELECT DISTINCT ha.holder_id
      FROM HolderAccount ha
      JOIN Account a ON ha.account_id = a.account_id
      WHERE a.account_type = 'savings'
  );