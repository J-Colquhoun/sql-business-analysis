# SQL Business Analysis

## Project overview

This repository demonstrates how SQL can answer practical business questions using a sample retail database. The examples progress from filtering and grouping to joins, common table expressions, and window functions.

The queries are written for **MySQL 8+** and use readable aliases, comments, and business-focused outputs.

## Database

The sample database uses four core tables:

- `customers`: customer identity and location
- `products`: product, category, and unit price
- `orders`: order date, customer, status, and sales channel
- `order_items`: products, quantities, discounts, and line-level sales

## Business questions

- Which products and categories generate the most revenue?
- Who are the highest-value customers?
- How do monthly sales change over time?
- Which customers purchase repeatedly?
- How does each product perform relative to others in its category?
- What is the running revenue total and month-over-month growth?

## Files

| File | Skills demonstrated |
|---|---|
| [basic_queries.sql](basic_queries.sql) | Filtering, sorting, calculated fields, grouping |
| [joins_and_aggregations.sql](joins_and_aggregations.sql) | Multi-table joins, revenue calculations, conditional aggregation |
| [cte_analysis.sql](cte_analysis.sql) | CTEs, customer segmentation, monthly trend analysis |
| [window_functions.sql](window_functions.sql) | Ranking, running totals, moving averages, lag comparisons |

## Assumptions

- Completed orders represent realized sales.
- Line revenue is calculated as `quantity * unit_price * (1 - discount_pct)`.
- `discount_pct` is stored as a decimal, such as `0.10` for 10%.
- Cancelled and returned orders are excluded from realized-revenue analysis unless stated otherwise.

## Result screenshots

> Query-result screenshots will be added here after the scripts are run against the database used for the portfolio demonstration.

Suggested screenshots:

1. Revenue by product category
2. Customer value segment summary
3. Monthly revenue with month-over-month change

## Tools

- MySQL 8+
- SQL
- Relational data analysis
- Business intelligence
