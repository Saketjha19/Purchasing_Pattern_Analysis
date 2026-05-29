-- #Basic Aggregations & Filtering
--1. Total Revenue by Category: What is the total revenue (Purchase Amount (USD)) and total number of items sold for each product Category?
select category,count(category),sum(purchase_amount) as total_amount from customer group by category;

-- 2.Gender-based Spending: What is the average Purchase Amount (USD) for Male vs. Female customers?
select gender,round(avg(purchase_amount),2) as average_spent from customer group by gender;

-- 3.Top Locations: What are the top 5 states (Location) generating the highest total revenue?
select location,sum(purchase_amount) as spent from customer group by location order by spent desc limit 5;

-- 4.Subscription Penetration: How many unique customers have an active subscription (Subscription Status = 'Yes') vs. those who do not?
select subscription_status,count(subscription_status) from customer group by subscription_status ;

-- 5.Intermediate Grouping & Conditional Logic (CASE WHEN) Age Demographics: Group customers into age brackets 
-- (e.g., Under 25, 25–40, 41–60, 60+) using a CASE statement. Which age bracket spends the most on average?


    SELECT round(avg(purchase_amount),2) as average_spent ,
           CASE
               WHEN age < 25 THEN 'young'
               WHEN age BETWEEN 25 AND 40 THEN 'middle_aged'
               WHEN age BETWEEN 41 AND 60 THEN 'aged'
               WHEN age > 60 THEN 'old'
               ELSE 'unknown'
           END AS age_groups
    FROM customer
GROUP BY age_groups;

-- 6.Discount Impact on Ratings: Does offering a discount negatively or positively affect product reviews? 
-- Compare the average Review Rating for orders with a Discount Applied vs. those without.
select discount_applied,avg(review_rating) from customer group by discount_applied;

-- 7.Popular Payment Methods by Region: What is the distribution count of each Payment Method across different Location states?
select location,payment_method,count(*) as payment_count from customer group by location,payment_method; 

-- 8.Shipping Choice vs. Purchase Size: Do customers who select premium shipping options (like 'Express' or 'Next Day Air')
-- have a higher average Purchase Amount (USD) than those who select 'Standard' or 'Free Shipping'?
select shipping_type,sum(purchase_amount) as total_spent,sum(purchase_amount)-lag(sum(purchase_amount)) over (order by shipping_type) as difference from customer group by shipping_type;


-- 9.Seasonal Product Demand:  the single most popular Item Purchased (by transaction count) for each Season.
select season,item_purchased,sum(previous_purchases) as total_item_purchased from customer group by season,item_purchased order by total_item_purchased desc limit 1;

-- 10.Product Performance Ranking: Within each product Category, rank the individual items (Item Purchased) by the total revenue they generated
select category,item_purchased,total_revenue,dense_rank() over(partition by category order by total_revenue desc)
from
(select category,item_purchased,sum(purchase_amount) as total_revenue from customer group by category,item_purchased);

-- 10.High-Value Loyalty Identification: Find all "VIP" customers who meet two criteria: they are subscribers (Subscription Status = 'Yes') and
-- have a higher number of Previous Purchases than the overall average of the entire customer base.
select customer_id,age,gender from customer where subscription_status='Yes' and previous_purchases>(select avg(previous_purchases) from customer);

-- 11.Color & Size Preferences: For each product Category, identify the most frequently purchased Color and Size combination.
-- select * from customer;
select * from(select category,color,size,purchase_frequency_days,row_number() over(partition by category order by purchase_frequency_days) as rn from customer group by category,color,size,purchase_frequency_days order by category,purchase_frequency_days desc)
where rn<4;

-- 12. top 5 products with highestaverage revenue rating
select item_purchased,review_rating from customer order by review_rating desc limit 5;

-- 13.Do subscribed cusotmers spend more
select subscription_status,avg(purchase_amount) from customer group by subscription_status;

-- 14.what are the top 5 most purchased products among three categories?
select * from(select category,item_purchased,count(customer_id) as total_orders,row_number() over(partition by category order by count(customer_id) desc) as rn from customer group by category,item_purchased) where rn<4;


