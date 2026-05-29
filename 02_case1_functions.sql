-- STEP A: Check EXPLAIN without index
EXPLAIN FORMAT=TRADITIONAL SELECT * FROM orders 
WHERE YEAR(order_date) = 2024;
-- Note: type=ALL, key=NULL, rows=~10000
-- Screenshot saved as case1_bad_before_indexing

-- STEP B: Create index
CREATE INDEX idx_order_date ON orders(order_date);

-- STEP C: Bad query — index EXISTS but YEAR() breaks it
EXPLAIN FORMAT=TRADITIONAL SELECT * FROM orders 
WHERE YEAR(order_date) = 2024;
-- Note: Still type=ALL — index NOT used
-- Screenshot saved as case1_bad_after_indexing

-- STEP D: Good query — index works properly
EXPLAIN FORMAT=TRADITIONAL SELECT * FROM orders 
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31';
-- Note: type=range, key=idx_order_date
-- Screenshot saved as case1_good

-- LESSON:
-- Wrapping a column in ANY function (YEAR, MONTH, UPPER, LOWER etc)
-- prevents MySQL from using the index on that column
-- Always rewrite to compare the raw column value
