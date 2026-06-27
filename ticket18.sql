-- =====================================================
-- БИЛЕТ 18 - Задание 3
-- Запрос: Сотрудники с зарплатой выше, чем у руководителя
-- =====================================================

-- =====================================================
-- Вариант 1 (наиболее вероятный для coderang.dev)
-- Таблица Employee с самоссылающимся внешним ключом manager_id
-- Структура: id, name, salary, manager_id
-- =====================================================

-- MySQL версия
SELECT 
    e.id,
    e.name
FROM Employee e
JOIN Employee m ON e.manager_id = m.id
WHERE e.salary > m.salary
ORDER BY e.id;

-- PostgreSQL версия (синтаксис идентичен)
SELECT 
    e.id,
    e.name
FROM Employee e
JOIN Employee m ON e.manager_id = m.id
WHERE e.salary > m.salary
ORDER BY e.id;


-- =====================================================
-- Вариант 2 (если таблица называется по-другому, 
-- например Staff или Worker)
-- =====================================================

-- MySQL & PostgreSQL
SELECT 
    e.id,
    e.name
FROM Staff e
JOIN Staff m ON e.manager_id = m.id
WHERE e.salary > m.salary
ORDER BY e.id;


-- =====================================================
-- Вариант 3 (если колонки называются по-другому:
-- employee_id, employee_name, manager_id)
-- =====================================================

-- MySQL & PostgreSQL
SELECT 
    e.employee_id,
    e.employee_name
FROM Employee e
JOIN Employee m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary
ORDER BY e.employee_id;


-- =====================================================
-- Вариант 4 (если используется подзапрос вместо JOIN)
-- =====================================================

-- MySQL & PostgreSQL
SELECT 
    id,
    name
FROM Employee
WHERE salary > (
    SELECT m.salary
    FROM Employee m
    WHERE m.id = Employee.manager_id
)
ORDER BY id;


-- =====================================================
-- Пояснение:
-- - Используем САМОСОЕДИНЕНИЕ (self join): таблица 
--   Employee соединяется сама с собой
-- - Псевдоним 'e' - это сотрудник
-- - Псевдоним 'm' - это его менеджер (руководитель)
-- - Условие JOIN: manager_id сотрудника = id менеджера
-- - WHERE e.salary > m.salary - фильтруем тех, у кого 
--   зарплата больше, чем у руководителя
-- - ORDER BY id - сортируем по ID для удобства
-- =====================================================

SELECT 
    a.id AS employee_id,
    a.name AS employee_name
FROM 
    employees a
JOIN 
    employees b ON b.id = a.manager_id
WHERE 
    a.salary > b.salary;
