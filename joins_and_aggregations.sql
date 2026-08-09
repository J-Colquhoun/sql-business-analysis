-- Joins and aggregations for retail business analysis (MySQL 8+)

-- 1. Realized revenue by product category.
SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS revenue
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;

-- 2. Top ten customers by lifetime completed-order revenue.
SELECT
    c.customer_id,
    c.customer_name,
    c.state,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS lifetime_value
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
JOIN order_items AS oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.state
ORDER BY lifetime_value DESC
LIMIT 10;

-- 3. Channel performance and completion rate.
SELECT
    sales_channel,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Completed' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        1
    ) AS completion_rate_pct
FROM orders
GROUP BY sales_channel
ORDER BY completion_rate_pct DESC;
