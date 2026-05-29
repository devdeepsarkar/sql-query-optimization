-- STEP A: Bad query — subquery runs once PER ROW
EXPLAIN FORMAT=TRADITIONAL SELECT 
    order_id,
    order_date,
    (SELECT SUM(price * quantity) 
     FROM order_items oi 
     WHERE oi.order_id = o.order_id) AS total
FROM orders o;
-- Note: DEPENDENT SUBQUERY in Extra column — very bad
-- Screenshot saved as case3_bad.png

-- STEP B: Good query — single JOIN pass
EXPLAIN FORMAT=TRADITIONAL SELECT 
    o.order_id,
    o.order_date,
    ROUND(SUM(oi.price * oi.quantity), 2) AS total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date;
-- Note: Simple JOIN, no dependent subquery
-- Screenshot saved as case3_good.png

-- LESSON:
-- Correlated subquery = runs N times for N rows = O(n²)
-- JOIN = runs once across the whole table = O(n)
-- On 10,000 rows the difference is massive