-- =====================================================
-- БИЛЕТ 22 - Задание 3
-- Запрос: Три самые высокие зарплаты в каждом отделе
-- =====================================================

-- =====================================================
-- MySQL 8.0+ / PostgreSQL версия (с оконными функциями)
-- Рекомендуемый способ
-- =====================================================

WITH RankedSalaries AS (
    SELECT 
        e.id,
        e.name AS employee_name,
        e.salary,
        e.department_id,
        DENSE_RANK() OVER (
            PARTITION BY e.department_id 
            ORDER BY e.salary DESC
        ) as salary_rank
    FROM Employee e
)
SELECT 
    d.name AS department_name,
    rs.employee_name,
    rs.salary
FROM RankedSalaries rs
JOIN Department d ON rs.department_id = d.id
WHERE rs.salary_rank <= 3
ORDER BY d.name, rs.salary DESC;

-- =====================================================
-- Альтернативный вариант (без CTE, с подзапросом)
-- MySQL 8.0+ / PostgreSQL
-- =====================================================

SELECT 
    d.name AS department_name,
    e.name AS employee_name,
    e.salary
FROM Employee e
JOIN Department d ON e.department_id = d.id
JOIN (
    SELECT 
        id,
        DENSE_RANK() OVER (
            PARTITION BY department_id 
            ORDER BY salary DESC
        ) as salary_rank
    FROM Employee
) ranked ON e.id = ranked.id
WHERE ranked.salary_rank <= 3
ORDER BY d.name, e.salary DESC;

-- =====================================================
-- MySQL 5.7 и ниже (без оконных функций)
-- Более сложный вариант с коррелированным подзапросом
-- =====================================================

SELECT 
    d.name AS department_name,
    e.name AS employee_name,
    e.salary
FROM Employee e
JOIN Department d ON e.department_id = d.id
WHERE (
    SELECT COUNT(DISTINCT e2.salary)
    FROM Employee e2
    WHERE e2.department_id = e.department_id
    AND e2.salary > e.salary
) < 3
ORDER BY d.name, e.salary DESC;

-- =====================================================
-- Пояснение к основному решению:
-- =====================================================
-- 1. CTE (Common Table Expression) RankedSalaries:
--    - DENSE_RANK() присваивает ранги зарплатам внутри каждого отдела
--    - PARTITION BY department_id - разделяем данные по отделам
--    - ORDER BY salary DESC - сортируем зарплаты по убыванию
--    - DENSE_RANK не пропускает ранги при одинаковых значениях
--      (если две зарплаты одинаковые, обе получат ранг 1, 
--       следующая уникальная зарплата - ранг 2)
--
-- 2. Основной запрос:
--    - JOIN Department получаем название отдела
--    - WHERE salary_rank <= 3 фильтруем только топ-3 зарплаты
--    - ORDER BY d.name, rs.salary DESC сортируем результат
--
-- 3. Пример работы:
--    Если в отделе IT зарплаты: 100000, 90000, 90000, 80000, 70000
--    DENSE_RANK присвоит: 100000→1, 90000→2, 90000→2, 80000→3, 70000→4
--    Результат: все сотрудники с зарплатами 100000, 90000, 90000, 80000
--    (4 человека, но 3 уникальных значения зарплаты)
-- =====================================================

SELECT
    department,
    employee_name,
    salary
FROM (
    SELECT
        department,
        employee_name,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk <= 3
ORDER BY department, salary DESC;
