// =====================================================
// БИЛЕТ 21 - Задание 3
// Концептуальная и даталогическая модели БД
// 5 предметных областей
// =====================================================

// =====================================================
// а) Студенты изучают предметы и получают оценки
// =====================================================

Table Student {
  student_id int [pk, increment]
  full_name varchar(200) [not null]
  group_name varchar(50)
}

Table Subject {
  subject_id int [pk, increment]
  name varchar(200) [not null]
}

// Ассоциативная сущность (связь M:N с атрибутом "оценка")
Table Grade {
  student_id int [ref: > Student.student_id]
  subject_id int [ref: > Subject.subject_id]
  grade int [not null] // Оценка (атрибут связи)
  date date
}

// =====================================================
// б) Лекции по предмету начинаются в определенное время 
//    в определенной аудитории
// =====================================================

Table SubjectLecture {
  subject_id int [pk, increment]
  name varchar(200) [not null]
}

Table Classroom {
  classroom_id int [pk, increment]
  number varchar(20) [not null]
  building varchar(100)
  capacity int
}

// Ассоциативная сущность "Лекция"
Table Lecture {
  lecture_id int [pk, increment]
  subject_id int [ref: > SubjectLecture.subject_id]
  classroom_id int [ref: > Classroom.classroom_id]
  start_time datetime [not null] // Время начала (атрибут связи)
  duration int // Длительность в минутах
}

// =====================================================
// в) Каждый день служащие работают определенное 
//    количество часов
// =====================================================

Table Employee {
  employee_id int [pk, increment]
  full_name varchar(200) [not null]
  position varchar(100)
}

// Ассоциативная сущность "Учет рабочего времени"
Table Timesheet {
  timesheet_id int [pk, increment]
  employee_id int [ref: > Employee.employee_id]
  work_date date [not null]
  hours_worked decimal(4,2) [not null] // Количество часов (атрибут связи)
}

// =====================================================
// г) Люди подписываются на журналы
// =====================================================

Table Person {
  person_id int [pk, increment]
  full_name varchar(200) [not null]
  email varchar(100)
}

Table Magazine {
  magazine_id int [pk, increment]
  title varchar(200) [not null]
  publisher varchar(100)
}

// Ассоциативная сущность "Подписка"
Table Subscription {
  subscription_id int [pk, increment]
  person_id int [ref: > Person.person_id]
  magazine_id int [ref: > Magazine.magazine_id]
  start_date date [not null] // Дата начала (атрибут связи)
  end_date date [not null] // Дата окончания (атрибут связи)
}

// =====================================================
// д) Летчики имеют число налетов на каждом типе самолета
// =====================================================

Table Pilot {
  pilot_id int [pk, increment]
  full_name varchar(200) [not null]
  license_number varchar(50)
}

Table AircraftType {
  aircraft_type_id int [pk, increment]
  model_name varchar(100) [not null]
  manufacturer varchar(100)
}

// Ассоциативная сущность "Налет"
Table FlightHours {
  pilot_id int [ref: > Pilot.pilot_id]
  aircraft_type_id int [ref: > AircraftType.aircraft_type_id]
  total_hours decimal(6,2) [not null] // Число налетов (атрибут связи)
}


-- =====================================================
-- БИЛЕТ 21 - Задание 3
-- Полный SQL код: создание БД для 5 предметных областей
-- =====================================================

-- =====================================================
-- ЧАСТЬ А: Студенты, предметы, оценки
-- =====================================================

CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;

-- MySQL версия
CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(200) NOT NULL,
    group_name VARCHAR(50)
);

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE Grade (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    grade INT NOT NULL CHECK (grade BETWEEN 2 AND 5),
    date DATE,
    PRIMARY KEY (student_id, subject_id, date),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

-- Тестовые данные
INSERT INTO Student (full_name, group_name) VALUES
('Иванов Иван', 'ИП-33'),
('Петров Петр', 'ИП-33');

INSERT INTO Subject (name) VALUES
('Базы данных'),
('Программирование');

INSERT INTO Grade (student_id, subject_id, grade, date) VALUES
(1, 1, 5, '2026-06-15'),
(1, 2, 4, '2026-06-16'),
(2, 1, 4, '2026-06-15');

-- PostgreSQL версия
/*
CREATE TABLE Student (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    group_name VARCHAR(50)
);

CREATE TABLE Subject (
    subject_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE Grade (
    student_id INT NOT NULL REFERENCES Student(student_id),
    subject_id INT NOT NULL REFERENCES Subject(subject_id),
    grade INT NOT NULL CHECK (grade BETWEEN 2 AND 5),
    date DATE,
    PRIMARY KEY (student_id, subject_id, date)
);
*/


-- =====================================================
-- ЧАСТЬ Б: Лекции, предметы, аудитории
-- =====================================================

CREATE DATABASE IF NOT EXISTS ScheduleDB;
USE ScheduleDB;

-- MySQL версия
CREATE TABLE SubjectLecture (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE Classroom (
    classroom_id INT PRIMARY KEY AUTO_INCREMENT,
    number VARCHAR(20) NOT NULL,
    building VARCHAR(100),
    capacity INT
);

CREATE TABLE Lecture (
    lecture_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id INT NOT NULL,
    classroom_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    duration INT,
    FOREIGN KEY (subject_id) REFERENCES SubjectLecture(subject_id),
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);

-- Тестовые данные
INSERT INTO SubjectLecture (name) VALUES
('Математика'),
('Физика');

INSERT INTO Classroom (number, building, capacity) VALUES
('101', 'Главный корпус', 30),
('205', 'Главный корпус', 50);

INSERT INTO Lecture (subject_id, classroom_id, start_time, duration) VALUES
(1, 1, '2026-06-27 09:00:00', 90),
(2, 2, '2026-06-27 10:45:00', 90);

-- PostgreSQL версия
/*
CREATE TABLE SubjectLecture (
    subject_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE Classroom (
    classroom_id SERIAL PRIMARY KEY,
    number VARCHAR(20) NOT NULL,
    building VARCHAR(100),
    capacity INT
);

CREATE TABLE Lecture (
    lecture_id SERIAL PRIMARY KEY,
    subject_id INT NOT NULL REFERENCES SubjectLecture(subject_id),
    classroom_id INT NOT NULL REFERENCES Classroom(classroom_id),
    start_time TIMESTAMP NOT NULL,
    duration INT
);
*/


-- =====================================================
-- ЧАСТЬ В: Служащие и учет рабочего времени
-- =====================================================

CREATE DATABASE IF NOT EXISTS TimesheetDB;
USE TimesheetDB;

-- MySQL версия
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(200) NOT NULL,
    position VARCHAR(100)
);

CREATE TABLE Timesheet (
    timesheet_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    work_date DATE NOT NULL,
    hours_worked DECIMAL(4,2) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- Тестовые данные
INSERT INTO Employee (full_name, position) VALUES
('Сидоров Сидор', 'Бухгалтер'),
('Кузнецова Анна', 'Менеджер');

INSERT INTO Timesheet (employee_id, work_date, hours_worked) VALUES
(1, '2026-06-25', 8.00),
(1, '2026-06-26', 7.50),
(2, '2026-06-25', 8.00);

-- PostgreSQL версия
/*
CREATE TABLE Employee (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    position VARCHAR(100)
);

CREATE TABLE Timesheet (
    timesheet_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL REFERENCES Employee(employee_id),
    work_date DATE NOT NULL,
    hours_worked DECIMAL(4,2) NOT NULL
);
*/


-- =====================================================
-- ЧАСТЬ Г: Люди и подписка на журналы
-- =====================================================

CREATE DATABASE IF NOT EXISTS SubscriptionDB;
USE SubscriptionDB;

-- MySQL версия
CREATE TABLE Person (
    person_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE Magazine (
    magazine_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    publisher VARCHAR(100)
);

CREATE TABLE Subscription (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    magazine_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (person_id) REFERENCES Person(person_id),
    FOREIGN KEY (magazine_id) REFERENCES Magazine(magazine_id)
);

-- Тестовые данные
INSERT INTO Person (full_name, email) VALUES
('Смирнов Алексей', 'smirnov@mail.ru'),
('Волкова Мария', 'volkova@mail.ru');

INSERT INTO Magazine (title, publisher) VALUES
('Мир ПК', 'Издательство 1'),
('Хакер', 'Издательство 2');

INSERT INTO Subscription (person_id, magazine_id, start_date, end_date) VALUES
(1, 1, '2026-01-01', '2026-12-31'),
(1, 2, '2026-06-01', '2026-11-30'),
(2, 1, '2026-03-01', '2026-09-30');

-- PostgreSQL версия
/*
CREATE TABLE Person (
    person_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE Magazine (
    magazine_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    publisher VARCHAR(100)
);

CREATE TABLE Subscription (
    subscription_id SERIAL PRIMARY KEY,
    person_id INT NOT NULL REFERENCES Person(person_id),
    magazine_id INT NOT NULL REFERENCES Magazine(magazine_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);
*/


-- =====================================================
-- ЧАСТЬ Д: Летчики и налеты часов
-- =====================================================

CREATE DATABASE IF NOT EXISTS AviationDB;
USE AviationDB;

-- MySQL версия
CREATE TABLE Pilot (
    pilot_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(200) NOT NULL,
    license_number VARCHAR(50)
);

CREATE TABLE AircraftType (
    aircraft_type_id INT PRIMARY KEY AUTO_INCREMENT,
    model_name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100)
);

CREATE TABLE FlightHours (
    pilot_id INT NOT NULL,
    aircraft_type_id INT NOT NULL,
    total_hours DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (pilot_id, aircraft_type_id),
    FOREIGN KEY (pilot_id) REFERENCES Pilot(pilot_id),
    FOREIGN KEY (aircraft_type_id) REFERENCES AircraftType(aircraft_type_id)
);

-- Тестовые данные
INSERT INTO Pilot (full_name, license_number) VALUES
('Гагарин Юрий', 'ПЛ-001'),
('Леонов Алексей', 'ПЛ-002');

INSERT INTO AircraftType (model_name, manufacturer) VALUES
('Boeing 737', 'Boeing'),
('Airbus A320', 'Airbus');

INSERT INTO FlightHours (pilot_id, aircraft_type_id, total_hours) VALUES
(1, 1, 5000.50),
(1, 2, 3200.00),
(2, 1, 1500.75);

-- PostgreSQL версия
/*
CREATE TABLE Pilot (
    pilot_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    license_number VARCHAR(50)
);

CREATE TABLE AircraftType (
    aircraft_type_id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100)
);

CREATE TABLE FlightHours (
    pilot_id INT NOT NULL REFERENCES Pilot(pilot_id),
    aircraft_type_id INT NOT NULL REFERENCES AircraftType(aircraft_type_id),
    total_hours DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (pilot_id, aircraft_type_id)
);
*/