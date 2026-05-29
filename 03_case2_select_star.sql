-- STEP A: Bad query
EXPLAIN FORMAT=TRADITIONAL SELECT * FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
-- Note: rows scanned, all columns fetched
-- Screenshot saved as case2_bad.png

-- STEP B: First add index on order_status
CREATE INDEX idx_order_status ON orders(order_status);

-- STEP C: Good query — specific columns + index
EXPLAIN FORMAT=TRADITIONAL SELECT 
    o.order_id,
    o.order_date,
    o.city,
    o.total_amount,
    COUNT(oi.item_id) AS item_count
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.order_id, o.order_date, o.city, o.total_amount;
-- Note: type=ref, key=idx_order_status
-- Screenshot tsaved as case2_good.png

-- LESSON:
-- SELECT * fetches every column even ones you don't need
-- Costs extra memory, network transfer, and processing
-- Always name only the columns your query actually needs