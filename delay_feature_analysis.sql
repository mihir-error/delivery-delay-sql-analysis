CREATE DATABASE ecom_analysis;
USE ecom_analysis;

# Create a table to map data from csv

CREATE TABLE ecom_dataset (
    ID INT,
    Warehouse_block VARCHAR(5),
    Mode_of_Shipment VARCHAR(10),
    Customer_care_calls INT,
    Customer_rating INT,
    Cost_of_the_Product INT,
    Prior_purchases INT,
    Product_importance VARCHAR(10),
    Gender VARCHAR(10),
    Discount_offered INT,
    Weight_in_gms INT,
    Reached_on_Time_Y_N TINYINT
);

select * from ecom_dataset;

describe ecom_dataset;

#Checking size of data no. of rows
select count(*) as total_rows
from ecom_dataset;

#Checking if any Column has null values
SELECT
  SUM(CASE WHEN Warehouse_block IS NULL THEN 1 ELSE 0 END) AS null_warehouse_block,
  SUM(CASE WHEN Mode_of_Shipment IS NULL THEN 1 ELSE 0 END) AS null_mode_of_shipment,
  SUM(CASE WHEN Customer_care_calls IS NULL THEN 1 ELSE 0 END) AS null_customer_care_calls,
  SUM(CASE WHEN Customer_rating IS NULL THEN 1 ELSE 0 END) AS null_customer_rating,
  SUM(CASE WHEN Cost_of_the_Product IS NULL THEN 1 ELSE 0 END) AS null_cost_of_product,
  SUM(CASE WHEN Prior_purchases IS NULL THEN 1 ELSE 0 END) AS null_prior_purchases,
  SUM(CASE WHEN Product_importance IS NULL THEN 1 ELSE 0 END) AS null_product_importance,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
  SUM(CASE WHEN Discount_offered IS NULL THEN 1 ELSE 0 END) AS null_discount_offered,
  SUM(CASE WHEN Weight_in_gms IS NULL THEN 1 ELSE 0 END) AS null_weight,
  SUM(CASE WHEN Reached_on_Time_Y_N IS NULL THEN 1 ELSE 0 END) AS null_reached_on_time
FROM ecom_dataset;

#Checking how many orders where delayed
SELECT 
    Reached_on_Time_Y_N, COUNT(*) AS total_orders
FROM
    ecom_dataset
GROUP BY Reached_on_Time_Y_N;

#Calculating percentage of delayed order
SELECT 
    COUNT(*) AS total_orders,
    SUM(Reached_on_Time_Y_N) AS delayed_orders,
    ROUND(SUM(Reached_on_Time_Y_N) / COUNT(*) * 100,
            2) AS delayed_perc
FROM
    ecom_dataset;
    
#Which Warehouse has the highest percentage of 
# delayed deliveries?

SELECT 
Warehouse_block,
    COUNT(*) AS total_orders,
    SUM(Reached_on_Time_Y_N) AS delayed_orders,
    ROUND(SUM(Reached_on_Time_Y_N) / COUNT(*) * 100,
            2) AS delayed_perc
FROM
    ecom_dataset
GROUP BY Warehouse_block
ORDER BY delayed_perc DESC;

#Which Mode of Shipment is most associated with delays?

SELECT 
    Mode_of_Shipment,
    COUNT(*) AS total_orders,
    SUM(Reached_on_Time_Y_N) AS delayed_orders,
    ROUND(SUM(Reached_on_Time_Y_N) / COUNT(*) * 100, 2) AS delay_percentage
FROM ecom_dataset
GROUP BY Mode_of_Shipment
ORDER BY delay_percentage DESC;

#Does customer rating impact delivery?
SELECT 
    Customer_rating,
    COUNT(*) AS total_orders,
    SUM(Reached_on_Time_Y_N) AS delayed_orders,
    ROUND(SUM(Reached_on_Time_Y_N) / COUNT(*) * 100, 2) AS delay_percentage
FROM ecom_dataset
GROUP BY Customer_rating
ORDER BY Customer_rating;

#Does Product Importance affect delays?
SELECT 
    Product_importance,
    COUNT(*) AS total_orders,
    SUM(Reached_on_Time_Y_N) AS delayed_orders,
    ROUND(SUM(Reached_on_Time_Y_N) * 100.0 / COUNT(*), 2) AS delay_percentage
FROM ecom_dataset
GROUP BY Product_importance;

#Does Discount Offered influence delays?

SELECT 
  CASE 
    WHEN Discount_offered < 10 THEN 'Low (<10)'
    WHEN Discount_offered BETWEEN 10 AND 19 THEN 'Medium (10-19)'
    WHEN Discount_offered BETWEEN 20 AND 29 THEN 'High (20-29)'
    ELSE 'Very High (30+)' 
  END AS discount_range,
  COUNT(*) AS total_orders,
  SUM(Reached_on_Time_Y_N) AS delayed_orders,
  ROUND(SUM(Reached_on_Time_Y_N)*100.0/COUNT(*), 2) AS delay_percentage
FROM ecom_dataset
GROUP BY discount_range
ORDER BY delay_percentage DESC;

# Does heavy weight products cause delayed delivery ?
SELECT
  CASE 
    WHEN Weight_in_gms < 1500 THEN 'Light (<1.5kg)'
    WHEN Weight_in_gms BETWEEN 1500 AND 2500 THEN 'Medium (1.5-2.5kg)'
    ELSE 'Heavy (2.5kg+)' 
  END AS weight_category,
  COUNT(*) AS total_orders,
  SUM(Reached_on_Time_Y_N) AS delayed_orders,
  ROUND(SUM(Reached_on_Time_Y_N) * 100.0 / COUNT(*), 2) AS delay_percentage
FROM ecom_dataset
GROUP BY weight_category
ORDER BY delay_percentage DESC;

#Does prior purchases affect delayed delivery?

SELECT 
    Prior_purchases,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0 END) AS delayed_orders,
    ROUND(
        (SUM(CASE WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
    ) AS delay_percentage
FROM 
    ecom_dataset
GROUP BY 
    Prior_purchases
ORDER BY 
    Prior_purchases;
    
#does cost of product affect delay

select 
	case
    when Cost_of_the_Product between 50 and 150 then 'Cheaper product (50-150)'
    when Cost_of_the_Product between 150 and 250 then 'Medium product (150-250)'
    else  'Expensive (250+)'
    end as category_prod_cost,
    COUNT(*) AS total_orders,
  SUM(CASE WHEN Reached_on_Time_Y_N = 'Yes' THEN 1 ELSE 0 END) AS delayed_orders,
  ROUND(SUM(CASE WHEN Reached_on_Time_Y_N = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS delay_percent
FROM ecom_dataset
GROUP BY category_prod_cost
ORDER BY category_prod_cost;
    
#does customer care calls affect delays
SELECT 
    Customer_care_calls,
    COUNT(*) AS total_orders,
    SUM(Reached_on_Time_Y_N) AS delayed_orders,
    ROUND(SUM(Reached_on_Time_Y_N) * 100.0 / COUNT(*), 2) AS delay_percentage
FROM ecom_dataset
GROUP BY Customer_care_calls
ORDER BY Customer_care_calls;






