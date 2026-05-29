-- STEP A: Bad query using IN
EXPLAIN FORMAT=TRADITIONAL SELECT * FROM employees
WHERE emp_id IN (
    SELECT manager_id FROM employees
    WHERE department = 'Engineering'
);
-- Note: IN loads full subquery result into memory first
-- Screenshot saved as case4_bad.png

-- STEP B: Good query using EXISTS
EXPLAIN FORMAT=TRADITIONAL SELECT * FROM employees e
WHERE EXISTS (
    SELECT 1 FROM employees sub
    WHERE sub.manager_id = e.emp_id
    AND sub.department = 'Engineering'
);
-- Note: EXISTS stops at first match, no full list built
-- Screenshot saved as case4_good.png

-- LESSON:
-- IN  → evaluates entire subquery, stores all results, then checks
-- EXISTS → stops as soon as first match found
-- EXISTS is faster when subquery returns many rows