-- =====================================================
-- БИЛЕТ 12 - Задание 3
-- Запрос: Выезды из Парижа
-- https://sql.coderang.dev/trainer/tasks/sa-8
-- =====================================================
SELECT 
    town_to AS town_to,
    (time_in - time_out) AS travel_time
FROM Tour
WHERE town_from = 'Paris'
ORDER BY time_out; --verifed 
-- =====================================================
-- MySQL версия
-- =====================================================

-- Для каждого выезда из Парижа вывести город прибытия 
-- и длительность переезда (разницу между временем 
-- прибытия и временем отправления)

SELECT 
    town_to AS город_прибытия,
    TIMESTAMPDIFF(MINUTE, time_out, time_in) AS длительность_минуты
FROM Tour
WHERE town_from = 'Paris'
ORDER BY time_out;

-- =====================================================
-- Альтернативный вариант (в часах)
-- =====================================================

SELECT 
    town_to AS город_прибытия,
    TIMESTAMPDIFF(HOUR, time_out, time_in) AS длительность_часы
FROM Tour
WHERE town_from = 'Paris'
ORDER BY time_out;

-- =====================================================
-- Альтернативный вариант (в формате TIME)
-- =====================================================

SELECT 
    town_to AS город_прибытия,
    TIMEDIFF(time_in, time_out) AS длительность
FROM Tour
WHERE town_from = 'Paris'
ORDER BY time_out;

-- =====================================================
-- PostgreSQL версия
-- =====================================================

-- В PostgreSQL разница между timestamp возвращает interval
SELECT 
    town_to AS город_прибытия,
    (time_in - time_out) AS длительность
FROM Tour
WHERE town_from = 'Paris'
ORDER BY time_out;

-- =====================================================
-- PostgreSQL (в минутах)
-- =====================================================

SELECT 
    town_to AS город_прибытия,
    EXTRACT(EPOCH FROM (time_in - time_out)) / 60 AS длительность_минуты
FROM Tour
WHERE town_from = 'Paris'
ORDER BY time_out;

-- =====================================================
-- PostgreSQL (в часах)
-- =====================================================

SELECT 
    town_to AS город_прибытия,
    EXTRACT(EPOCH FROM (time_in - time_out)) / 3600 AS длительность_часы
FROM Tour
WHERE town_from = 'Paris'
ORDER BY time_out;

