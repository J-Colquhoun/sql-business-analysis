-- Basic SQL queries for a sample retail database (MySQL 8+)

-- 1. Review recently completed orders.
SELECT
    order_id,
    customer_id,
    order_date,
    sales_channel
FROM orders
WHERE order_status = 'Completed'
ORDER BY order_date DESC
LIMIT 25;

-- 2. Calculate the extended value of each order line.
SELECT
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    ROUND(quantity * unit_price * (1 - discount_pct), 2) AS line_revenue
FROM order_items
ORDER BY line_revenue DESC;

-- 3. Count products and find average price by category.
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(unit_price), 2) AS average_unit_price,
    MIN(unit_price) AS lowest_unit_price,
    MAX(unit_price) AS highest_unit_price
FROM products
GROUP BY category
ORDER BY product_count DESC, category;

-- 4. Identify orders that may require operational follow-up.
SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM orders
WHERE order_status IN ('Pending', 'Returned')
ORDER BY order_date;
