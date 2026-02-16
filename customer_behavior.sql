
select*from customer limit 20;
---#total revenue genrated by male vs femal customer?
 select gender, sum(purchase_amount) as revenue
 from customer
 group by gender;
 ---#q2 which customers used the discount but still send more then the average purchase amount?
  select customer_id ,purchase_amount
  from customer
  where discount_applied = "yes" and purchase_amount >= (select AVG (purchase_amount) from customer);
-------##q3 which are the top 5 product with the heighest average review rating?
SELECT item_purchased,
       ROUND(AVG(review_rating), 2) AS Average_Product_Rating
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;
----- ##compare the average purchase amount between standerd and express shiping ?
select shipping_type,
round(avg(purchase_amount),2)
from customer
where shipping_type in ('standered' and 'express')
group by shipping_type;
---## do subcribed customer spend more? commpare average send and total reveneue between subscriber and non subscriber?
 SELECT subscription_status,
       COUNT(customer_id) AS Total_Customers,
       ROUND(AVG(purchase_amount), 2) AS Avg_Spend,
       ROUND(SUM(purchase_amount), 2) AS Total_Revenue
FROM customer
GROUP BY subscription_status
ORDER BY Total_Revenue DESC, Avg_Spend DESC;

----## q4 which 5 prodect have the heightest percentage of purchase with discount appied?
  SELECT item_purchased,
       ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*) * 100 , 2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;
---## q7segment customer in to new, returning and loyal based on their total no of their
----## previous purchase,and show the count of each segment?
   WITH customer_type AS (
    SELECT 
        customer_id, 
        previous_purchases,
        CASE 
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer
)
-- Count customers per segment
SELECT 
    customer_segment, 
    COUNT(*) AS no_of_customers
FROM customer_type
GROUP BY customer_segment;
---#08 what are the top 3 most purchase products with in each category?
 WITH item_count AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT 
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_count
WHERE item_rank <= 3;
----### q9 are customer who are repeate buyer (more than 5 repeate purchase)alsos likely to subscribe?
 SELECT 
    subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;
----##q10 what is the revenue created by each group?
select age_group, 
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;



 