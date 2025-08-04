USE ecom_analysis;

select * from ecom_dataset;

#Top 5 most ordered cost range
select 
	Cost_of_the_Product,
	count(*) as order_count
from ecom_dataset
group by Cost_of_the_Product
order by order_count desc;

#Most used shipping mode

SELECT 
  Mode_of_Shipment,
  COUNT(*) AS total_orders
FROM ecom_dataset
GROUP BY Mode_of_Shipment
ORDER BY total_orders DESC;

#AVG discount by product importance
SELECT 
	Product_importance,
    ROUND(AVG(Discount_offered), 2) AS avg_discount
FROM ecom_dataset
GROUP BY Product_importance;

#Avg weight and avg cost for delayed vs on time
SELECT
	Reached_on_Time_Y_N,
    ROUND(AVG(Weight_in_gms),2) AS avg_weight,
    ROUND(AVG(Cost_of_the_Product),2) AS avg_cost_product
from ecom_dataset
GROUP BY Reached_on_Time_Y_N;

#Avg Customer rating by shipment mode
SELECT
	Mode_of_Shipment,
    ROUND(AVG(Customer_rating),2) AS avg_rating
    from ecom_dataset
    group by Mode_of_Shipment;