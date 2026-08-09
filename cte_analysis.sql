-- Common table expression analyses (MySQL 8+)

-- 1. Segment customers using completed-order frequency and value.
WITH customer_value AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(DISTINCT o.order_id) AS completed_orders,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)) AS revenue
    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    JOIN order_items AS oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
),
segmented AS (
    SELECT
        *,
        CASE
            WHEN revenue >= 1000 AND completed_orders >= 5 THEN 'High Value'
            WHEN revenue >= 500 OR completed_orders >= 3 THEN 'Growth'
            ELSE 'Occasional'
        END AS customer_segment
    FROM customer_value
)
SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(AVG(revenue), 2) AS average_customer_revenue,
    ROUND(SUM(revenue), 2) AS segment_revenue
FROM segmented
GROUP BY customer_segment
ORDER BY segment_revenue DESC;

-- 2. Compare monthly revenue with the overall monthly average.
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)) AS revenue
    FROM orders AS o
    JOIN order_items AS oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
),
average_month AS (
    SELECT AVG(revenue) AS average_monthly_revenue
    FROM monthly_sales
)
SELECT
    m.sales_month,
    ROUND(m.revenue, 2) AS revenue,
    ROUND(a.average_monthly_revenue, 2) AS average_monthly_revenue,
    CASE
        WHEN m.revenue >= a.average_monthly_revenue THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance
FROM monthly_sales AS m
CROSS JOIN average_month AS a
ORDER BY m.sales_month;
