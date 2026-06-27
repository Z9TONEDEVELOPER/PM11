// =====================================================
// БИЛЕТ 9 - Задание 3
// Концептуальная и логическая модель данных для dbdiagram.io
// Шахматные турниры
// =====================================================

// Таблица ШАХМАТИСТЫ
Table ChessPlayer {
  player_id int [pk, increment]
  full_name varchar(200) [not null]
  gender varchar(10)
  age int
}

// Таблица ТУРНИРЫ
Table Tournament {
  tournament_id int [pk, increment]
  name varchar(200) [not null]
  dates varchar(100) // Сроки проведения
}

// Таблица ОРГАНИЗАТОРЫ
Table Organizer {
  organizer_id int [pk, increment]
  name varchar(200) [not null]
  address varchar(300)
}

// Таблица ПАРТИИ 
// (Ассоциативная сущность для связи Шахматиста и Турнира)
Table Game {
  game_id int [pk, increment]
  tournament_id int [not null]
  white_player_id int [not null] // Игравший белыми
  black_player_id int [not null] // Игравший черными
  result varchar(50) // Результат игры (например, '1-0', '0-1', '1/2-1/2')
}

// Таблица СВЯЗИ ТУРНИРА И ОРГАНИЗАТОРА
// (Ассоциативная сущность для связи M:N)
Table TournamentOrganizer {
  tournament_id int [pk]
  organizer_id int [pk]
}

// =====================================================
// СВЯЗИ МЕЖДУ ТАБЛИЦАМИ
// =====================================================

// Один турнир содержит много партий
Ref: Game.tournament_id > Tournament.tournament_id

// В партии за белых играет один шахматист
Ref: Game.white_player_id > ChessPlayer.player_id

// В партии за черных играет один шахматист
Ref: Game.black_player_id > ChessPlayer.player_id

// Связь M:N между Турниром и Организатором
Ref: TournamentOrganizer.tournament_id > Tournament.tournament_id
Ref: TournamentOrganizer.organizer_id > Organizer.organizer_id



-- =====================================================
-- БИЛЕТ 9 - Задание 3
-- Полный SQL код: создание БД, заполнение, запросы
-- =====================================================

-- =====================================================
-- ЧАСТЬ 1: MYSQL ВЕРСИЯ
-- =====================================================

CREATE DATABASE IF NOT EXISTS ChessTournamentDB;
USE ChessTournamentDB;

-- Таблица ШАХМАТИСТЫ
CREATE TABLE ChessPlayer (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(200) NOT NULL,
    gender VARCHAR(10),
    age INT
);

-- Таблица ТУРНИРЫ
CREATE TABLE Tournament (
    tournament_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    dates VARCHAR(100)
);

-- Таблица ОРГАНИЗАТОРЫ
CREATE TABLE Organizer (
    organizer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    address VARCHAR(300)
);

-- Таблица ПАРТИИ
CREATE TABLE Game (
    game_id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_id INT NOT NULL,
    white_player_id INT NOT NULL,
    black_player_id INT NOT NULL,
    result VARCHAR(50),
    FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id),
    FOREIGN KEY (white_player_id) REFERENCES ChessPlayer(player_id),
    FOREIGN KEY (black_player_id) REFERENCES ChessPlayer(player_id)
);

-- Таблица СВЯЗИ ТУРНИРА И ОРГАНИЗАТОРА (M:N)
CREATE TABLE TournamentOrganizer (
    tournament_id INT NOT NULL,
    organizer_id INT NOT NULL,
    PRIMARY KEY (tournament_id, organizer_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id),
    FOREIGN KEY (organizer_id) REFERENCES Organizer(organizer_id)
);

-- Заполнение таблиц
INSERT INTO ChessPlayer (full_name, gender, age) VALUES
('Магнус Карлсен', 'М', 32),
('Ян Непомнящий', 'М', 33),
('Дин Лижэнь', 'М', 31);

INSERT INTO Tournament (name, dates) VALUES
('Турнир претендентов', 'Апрель 2024'),
('Кубок мира', 'Август 2023');

INSERT INTO Organizer (name, address) VALUES
('ФИДЕ', 'Швейцария, Лозанна'),
('Шахматная федерация РФ', 'Россия, Москва');

INSERT INTO Game (tournament_id, white_player_id, black_player_id, result) VALUES
(1, 1, 2, '1-0'), -- Карлсен (белые) против Непомнящего (черные)
(1, 2, 3, '1/2-1/2'), -- Непомнящий против Дин Лижэня
(2, 3, 1, '0-1'); -- Дин Лижэнь против Карлсена

INSERT INTO TournamentOrganizer (tournament_id, organizer_id) VALUES
(1, 1), (1, 2), -- Первый турнир проводят оба организатора
(2, 1);         -- Второй турнир проводит только ФИДЕ


-- =====================================================
-- ЧАСТЬ 2: POSTGRESQL ВЕРСИЯ
-- =====================================================

-- CREATE DATABASE ChessTournamentDB;
-- \c ChessTournamentDB;

CREATE TABLE ChessPlayer (
    player_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    gender VARCHAR(10),
    age INT
);

CREATE TABLE Tournament (
    tournament_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    dates VARCHAR(100)
);

CREATE TABLE Organizer (
    organizer_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    address VARCHAR(300)
);

CREATE TABLE Game (
    game_id SERIAL PRIMARY KEY,
    tournament_id INT NOT NULL,
    white_player_id INT NOT NULL,
    black_player_id INT NOT NULL,
    result VARCHAR(50),
    FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id),
    FOREIGN KEY (white_player_id) REFERENCES ChessPlayer(player_id),
    FOREIGN KEY (black_player_id) REFERENCES ChessPlayer(player_id)
);

CREATE TABLE TournamentOrganizer (
    tournament_id INT NOT NULL,
    organizer_id INT NOT NULL,
    PRIMARY KEY (tournament_id, organizer_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id),
    FOREIGN KEY (organizer_id) REFERENCES Organizer(organizer_id)
);

-- Заполнение таблиц идентично MySQL (INSERT INTO ...)


-- =====================================================
-- ЧАСТЬ 3: ПРОВЕРОЧНЫЕ ЗАПРОСЫ
-- =====================================================

-- ЗАПРОС 1: Вывести все партии конкретного турнира с именами игроков
SELECT 
    t.name AS турнир,
    p1.full_name AS белые,
    p2.full_name AS черные,
    g.result AS результат
FROM Game g
JOIN Tournament t ON g.tournament_id = t.tournament_id
JOIN ChessPlayer p1 ON g.white_player_id = p1.player_id
JOIN ChessPlayer p2 ON g.black_player_id = p2.player_id
WHERE t.name = 'Турнир претендентов';

-- ЗАПРОС 2: Найти всех организаторов конкретного турнира
SELECT 
    t.name AS турнир,
    o.name AS организатор,
    o.address AS адрес
FROM Tournament t
JOIN TournamentOrganizer to_link ON t.tournament_id = to_link.tournament_id
JOIN Organizer o ON to_link.organizer_id = o.organizer_id
WHERE t.name = 'Турнир претендентов';

-- ЗАПРОС 3: В каких турнирах участвовал конкретный шахматист (например, Карлсен)
SELECT DISTINCT
    p.full_name AS шахматист,
    t.name AS турнир,
    t.dates AS сроки
FROM ChessPlayer p
JOIN Game g ON p.player_id = g.white_player_id OR p.player_id = g.black_player_id
JOIN Tournament t ON g.tournament_id = t.tournament_id
WHERE p.full_name = 'Магнус Карлсен';