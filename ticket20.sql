-- =====================================================
-- БИЛЕТ 20 - Задание 3
-- Запрос: Три самые высокие зарплаты в каждом отделе
-- =====================================================

-- =====================================================
-- MySQL 8.0+ / PostgreSQL версия (с оконными функциями)
-- =====================================================

SELECT 
    d.name AS department_name,
    e.name AS employee_name,
    e.salary
FROM Employee e
JOIN Department d ON e.department_id = d.id
JOIN (
    SELECT 
        employee_id,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) as salary_rank
    FROM Employee
) ranked ON e.id = ranked.employee_id
WHERE ranked.salary_rank <= 3
ORDER BY d.name, e.salary DESC;

-- =====================================================
-- Альтернативный вариант (более читаемый с CTE)
-- MySQL 8.0+ / PostgreSQL
-- =====================================================

WITH RankedSalaries AS (
    SELECT 
        e.id,
        e.name,
        e.salary,
        e.department_id,
        DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) as salary_rank
    FROM Employee e
)
SELECT 
    d.name AS department_name,
    rs.name AS employee_name,
    rs.salary
FROM RankedSalaries rs
JOIN Department d ON rs.department_id = d.id
WHERE rs.salary_rank <= 3
ORDER BY d.name, rs.salary DESC;

-- =====================================================
-- MySQL 5.7 и ниже (без оконных функций)
-- Более сложный вариант с подзапросами
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
-- PostgreSQL версия (с использованием LATERAL)
-- =====================================================

SELECT 
    d.name AS department_name,
    e.name AS employee_name,
    e.salary
FROM Department d
JOIN LATERAL (
    SELECT DISTINCT salary
    FROM Employee
    WHERE department_id = d.id
    ORDER BY salary DESC
    LIMIT 3
) top_salaries ON TRUE
JOIN Employee e ON e.department_id = d.id AND e.salary = top_salaries.salary
ORDER BY d.name, e.salary DESC;

-- =====================================================
-- Пояснение:
-- - DENSE_RANK() - оконная функция, которая присваивает 
--   ранги зарплатам в каждом отделе
-- - PARTITION BY department_id - разделяем данные по отделам
-- - ORDER BY salary DESC - сортируем зарплаты по убыванию
-- - DENSE_RANK не пропускает ранги (если две зарплаты 
--   одинаковые, обе получат ранг 1, следующая - ранг 2)
-- - WHERE salary_rank <= 3 - фильтруем только топ-3
-- - ORDER BY d.name, e.salary DESC - сортируем результат
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
) ranked
WHERE rnk <= 3
ORDER BY department, salary DESC;
