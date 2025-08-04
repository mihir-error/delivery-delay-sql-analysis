USE ecom_analysis;
#Group cust by prior pruchases into loyaly levels
SELECT 
    CASE
        WHEN Prior_purchases <= 2 THEN 'New'
        WHEN Prior_purchases <= 5 THEN 'Returning'
        ELSE 'Loyal'
    END AS cust_type,
    COUNT(*) AS total_orders,
    ROUND(AVG(Customer_rating), 2) AS avg_rating,
    ROUND(AVG(Discount_offered), 2) AS avg_distcount
FROM
    ecom_dataset
GROUP BY cust_type;

#Loyalty group vs delay %
SELECT 
  CASE 
    WHEN Prior_purchases <= 2 THEN 'New'
    WHEN Prior_purchases <= 5 THEN 'Returning'
    ELSE 'Loyal'
  END AS customer_type,
  COUNT(*) AS total_orders,
  SUM(Reached_on_Time_Y_N) AS delayed_orders,
  ROUND(SUM(Reached_on_Time_Y_N)*100.0/COUNT(*), 2) AS delay_percentage
FROM ecom_dataset
GROUP BY customer_type;

#Which loyalty group spends the most
SELECT 
  CASE 
    WHEN Prior_purchases <= 2 THEN 'New'
    WHEN Prior_purchases <= 5 THEN 'Returning'
    ELSE 'Loyal'
  END AS customer_type,
  ROUND(AVG(Cost_of_the_Product), 2) AS avg_spending
FROM ecom_dataset
GROUP BY customer_type;



