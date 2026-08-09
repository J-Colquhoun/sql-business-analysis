-- Window-function analyses (MySQL 8+)

-- 1. Rank products within each category by completed-order revenue.
WITH product_sales AS (
    SELECT
        p.category,
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)) AS revenue
    FROM products AS p
    JOIN order_items AS oi ON p.product_id = oi.product_id
    JOIN orders AS o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.category, p.product_id, p.product_name
)
SELECT
    category,
    product_name,
    ROUND(revenue, 2) AS revenue,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY revenue DESC
    ) AS category_revenue_rank
FROM product_sales
ORDER BY category, category_revenue_rank, product_name;

-- 2. Monthly revenue, running total, moving average, and growth.
WITH monthly_sales AS (
    SELECT
        CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE) AS sales_month,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)) AS revenue
    FROM orders AS o
    JOIN order_items AS oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY CAST(DATE_FORMAT(o.order_date, '%Y-%m-01') AS DATE)
),
monthly_comparison AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS prior_month_revenue,
        SUM(revenue) OVER (ORDER BY sales_month) AS running_revenue,
        AVG(revenue) OVER (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS three_month_moving_average
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(running_revenue, 2) AS running_revenue,
    ROUND(three_month_moving_average, 2) AS three_month_moving_average,
    ROUND(
        100.0 * (revenue - prior_month_revenue)
        / NULLIF(prior_month_revenue, 0),
        1
    ) AS month_over_month_growth_pct
FROM monthly_comparison
ORDER BY sales_month;
