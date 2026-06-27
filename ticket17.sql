-- =====================================================
-- БИЛЕТ 17 - Задание 3
-- Запрос: Пассажиры поездов из Вены
-- =====================================================

-- =====================================================
-- MySQL / PostgreSQL версия (Вариант 1: Если БД нормализована)
-- Предполагается, что есть таблицы Passenger, Trip и Pass_in_trip
-- =====================================================

SELECT DISTINCT p.name
FROM Passenger p
JOIN Pass_in_trip pt ON p.id = pt.passenger_id
JOIN Trip t ON pt.trip_id = t.id
WHERE t.station_from = 'Vienna'
ORDER BY p.name;

-- =====================================================
-- MySQL / PostgreSQL версия (Вариант 2: Если все в одной таблице)
-- Например, таблица Pass_in_trip с полями passenger_name, station_from
-- =====================================================

SELECT DISTINCT passenger_name
FROM Pass_in_trip
WHERE station_from = 'Vienna'
ORDER BY passenger_name;

-- =====================================================
-- MySQL / PostgreSQL версия (Вариант 3: Если таблица Tour как в билетах 10 и 12)
-- =====================================================

SELECT DISTINCT passenger_name
FROM Tour
WHERE town_from = 'Vienna'
ORDER BY passenger_name;

-- =====================================================
-- Пояснение:
-- - DISTINCT - убирает дубликаты имен (если пассажир 
--   ездил из Вены несколько раз, он выведется только один раз)
-- - WHERE station_from = 'Vienna' - фильтруем только 
--   маршруты, начинающиеся в Вене
-- - ORDER BY name - сортируем результат по алфавиту
-- =====================================================


SELECT DISTINCT passenger_name
FROM routes
WHERE departure = 'Vienna';
