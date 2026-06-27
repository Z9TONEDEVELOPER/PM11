-- =====================================================
-- БИЛЕТ 19 - Задание 3
-- Запрос: Вторая по величине зарплата
-- =====================================================

-- =====================================================
-- MySQL версия
-- =====================================================

-- Вариант 1: Использование DISTINCT + ORDER BY + LIMIT/OFFSET
-- (рекомендуемый способ)
SELECT 
    (SELECT DISTINCT salary
     FROM Employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;

-- =====================================================
-- Вариант 2: Использование подзапроса с MAX()
-- (альтернативный способ)
-- =====================================================

SELECT 
    MAX(salary) AS second_highest_salary
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);

-- =====================================================
-- Вариант 3: Использование оконной функции DENSE_RANK()
-- (для MySQL 8.0+ и PostgreSQL)
-- =====================================================

SELECT 
    MAX(salary) AS second_highest_salary
FROM (
    SELECT 
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) as rank_num
    FROM Employee
) ranked
WHERE rank_num = 2;

-- =====================================================
-- PostgreSQL версия
-- =====================================================

-- Синтаксис идентичен MySQL для всех трех вариантов
SELECT 
    (SELECT DISTINCT salary
     FROM Employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;

-- =====================================================
-- Пояснение:
-- - DISTINCT - убирает дубликаты зарплат (одинаковые 
--   зарплаты считаем одним значением)
-- - ORDER BY salary DESC - сортируем по убыванию
-- - LIMIT 1 OFFSET 1 - пропускаем первую зарплату 
--   и берем вторую
-- - Если второй зарплаты нет, подзапрос вернет NULL
-- - Внешний SELECT оборачивает результат, чтобы 
--   гарантированно вернуть одну строку (даже если 
--   подзапрос пустой)
-- =====================================================
SELECT MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);
