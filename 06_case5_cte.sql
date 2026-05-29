-- STEP A: Bad query — calculates AVG salary 3 times
EXPLAIN FORMAT=TRADITIONAL SELECT department, AVG(salary) as avg_sal
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
GROUP BY department
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);
-- Note: AVG(salary) computed multiple times
-- Screenshot this ← BAD

-- STEP B: CTE — calculates AVG salary once, reuses it
EXPLAIN FORMAT=TRADITIONAL WITH overall_avg AS (
    SELECT AVG(salary) AS avg_salary 
    FROM employees
),
dept_avg AS (
    SELECT 
        department,
        ROUND(AVG(salary), 2) AS dept_salary
    FROM employees
    GROUP BY department
)
SELECT 
    d.department,
    d.dept_salary,
    ROUND(o.avg_salary, 2) AS company_avg
FROM dept_avg d
CROSS JOIN overall_avg o
WHERE d.dept_salary > o.avg_salary
ORDER BY d.dept_salary DESC;
-- Note: Cleaner execution plan, single AVG computation
-- Screenshot this ← GOOD

-- LESSON:
-- CTEs make complex queries readable AND
-- avoid redundant computations
-- Think of CTE as a named temporary result you reuse