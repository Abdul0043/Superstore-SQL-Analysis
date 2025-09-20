# Superstore-SQL-Analysis
SQL project analyzing Superstore dataset using CTEs, window functions, subqueries, and aggregations.

🛒 Superstore SQL Analysis (SQL Project)
📌 Project Overview

This project analyzes sales, customers, and products using a Superstore dataset.
The focus is on solving real-world business problems with SQL concepts like:
CTEs (Common Table Expressions)
Window Functions (RANK, DENSE_RANK, ROW_NUMBER, LAG, LEAD, Running Totals)
Subqueries
Aggregations & Joins

The dataset contains:
customers (customer details)
orders (order info)
order_items (product sales data)
products (product categories & pricing)

📊 Questions & Solutions
❓ Q1. Top 3 Cities by Revenue
Problem: Find the top 3 cities generating the highest revenue.
Skills Used: Joins, Aggregations, Ordering, LIMIT.

❓ Q2. Monthly Sales Trend + YOY Growth
Problem: Analyze monthly sales over the last 2 years, calculate running totals, and compare YOY growth.
Skills Used: Window Functions (LAG), Running Totals, Date Functions.

❓ Q3. Customer Churn Analysis
Problem: Identify customers who placed orders in a given month but didn’t return the next month.
Skills Used: CTE, LAG(), Date Functions.

❓ Q4. Category Contribution Analysis
Problem: Calculate category-wise revenue, contribution %, and rank categories by contribution.
Skills Used: Window Functions (RANK), CTE, Aggregations.

❓ Q5. Customer Lifetime Value (CLV) Segmentation
Problem: Segment customers into High, Medium, and Low Value groups based on total spending.
Skills Used: CTE, Subqueries, CASE, Aggregations, Ranking.

🛠️ Skills Applied
SQL Joins & Aggregations
CTEs & Subqueries
Window Functions (RANK, DENSE_RANK, ROW_NUMBER, LAG, LEAD)
Running Totals
Business Problem Solving with SQL
