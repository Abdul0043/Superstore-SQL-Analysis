## Q1. Customer Lifetime Value (CLV)
##Identify the top 5 customers who have spent the most overall. Along with their total spending,
##calculate Number of orders,
##Average order value,
##Their ranking within all customers 

with cst_spending as
 ( select
 c.customer_id,
 c.customer_name,
 round(sum(oi.quantity*oi.total_price)) as amount,
 round(avg(oi.quantity*oi.total_price)) as AOV,
 count(oi.order_id) as no_of_orders
from customers c 

join orders o  on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_id,c.customer_name ),

ranking as ( select *,
rank() over ( order by amount desc ) as rnk from cst_spending 

group by customer_id,customer_name)

select * from ranking 
limit 5;








##❓ Q2. Monthly Sales Trend + YOY Growth
##For the past 2 years, calculate:
##Monthly total sales
##Running total of sales per year using window function
##Compare sales with the same month in the previous year (YOY growth %).

with monthly_sales as ( select  date_format(o.order_date,'%Y-%M') as order_month , year(o.order_date) as order_year,round(sum(oi.quantity*oi.total_price)) as sales 
from orders o 
join order_items oi on o.order_id = oi.order_id
where o.order_date >= date_sub(current_date(),interval 12 month )
group by date_format(o.order_date,'%Y-%M'),year(o.order_date)
),

running_total as ( select order_month,sales,order_year,
sum(sales) over ( partition by order_year order by order_month ) as running_total,
lag(sales,12) over ( order by order_month ) as prev_year_sales
from monthly_sales 
)

select order_month,order_year,sales,running_total,prev_year_sales,
round(((( sales - prev_year_sales ) / prev_year_sales ) * 100),2) as yoy_growth_percent
from 
running_total
order by order_month;








##❓ Q3. Churn Analysis by Customer
##Using orders from the past 12 months:
##Find customers who placed an order in a given month but did not return in the next month (churn).
##Show customer name, churn month, and their last purchase date in that month.
##Use a CTE + LAG() or self-join

with customer_data as ( select c.customer_id,c.customer_name,date_format(o.order_date,'%Y-%M') as order_month,max(o.order_date) as last_order_date
from customers c 
join orders o on c.customer_id = o.customer_id
where o.order_date >= date_sub(curdate(), interval 12 month )
group by c.customer_id,c.customer_name,date_format(o.order_date,'%Y-%M')
),

next_month as ( select * , lead(order_month) over ( partition by customer_id order by order_month ) as  next_month from customer_data 
)

select customer_id,customer_name,order_month as churn_month,last_order_date,next_month
from 
next_month
where next_month is null or  PERIOD_DIFF(DATE_FORMAT(next_month, '%Y%m'), DATE_FORMAT(order_month, '%Y%m')) > 1
ORDER BY customer_id,churn_month;







##❓ Modified Q4. Category Sales Share + Ranking
##For each product category:
##Calculate total sales.
##Calculate its contribution % towards overall revenue. , ##Rank categories by contribution %., ##Return only the top 3 categories.

with category as ( select p.category_id,round(sum(oi.quantity*oi.total_price)) as sales
from products p 
join order_items oi on p.product_id = oi .product_id
group by p.category_id 
),
overall_revenue as ( select sum(quantity*total_price) as revenue from order_items ),

contribution as ( select c.category_id,c.sales,
round((c.sales/r.revenue)*100,2) as contribution
from category c 
cross join overall_revenue r
),
ranked as ( select category_id,sales,contribution,rank() over ( order by contribution desc ) as rnk from contribution )

select category_id,sales,contribution
from ranked
where rnk <=3;







##❓ Q5 (NEW). Customer Lifetime Value (CLV) Segmentation
##Calculate each customer’s total spending.
##Compute the overall average spending.
##Divide customers into three segments:
##High Value → spending > 150% of average spending
##Medium Value → spending between 50% and 150% of average spending
##Low Value → spending < 50% of average spending
##For each segment, show the customer count and their total sales.
##Rank the segments in descending order of total sales.

with cst_data as ( select c.customer_id,c.customer_name,round(sum(oi.quantity*oi.total_price)) as spending 
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items oi on oi.order_id = o.order_id
group by c.customer_id,c.customer_name
),
avg_spending as ( select avg(spending) as avg_spending from cst_data 
),
segment as ( select cd.customer_id,cd.customer_name,cd.spending,
case 
when cd.spending > a.avg_spending*1.5 then 'High Value'
when cd.spending >= a.avg_spending*0.5 then 'medium Value'
else 'low value'
end as segment
from cst_data cd
cross join avg_spending a 
),
segment_summary AS (
SELECT 
        segment,
        COUNT(DISTINCT customer_id) AS customer_count,SUM(spending) AS total_sales
        FROM segment
        GROUP BY segment)
    
    SELECT segment,customer_count,total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS segment_rank
FROM segment_summary;


















