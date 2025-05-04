-- PROCUREMENT KPIs ANALYSIS
-- Total spend 
SELECT 
	SUM(negotiated_price * quantity) AS total_spend 
FROM purchase;

/* Caculate cost saving */ 
SELECT 
	SUM(unit_price * quantity - negotiated_price * quantity) AS total_cost_savings,
	ROUND(AVG( (unit_price - negotiated_price)/ unit_price *100), 2) AS avg_cost_savings_perc
FROM purchase;
-- Caculate cost savings percentage trend 
SELECT 
	year, 
	month,
	ROUND(AVG((unit_price - negotiated_price)/ unit_price *100),2) AS avg_cost_saving_perc_trend
FROM purchase
GROUP BY year, month 
ORDER BY year, month; 

/* Caculate defect rate */
SELECT 
	ROUND(AVG((defective_units/quantity)*100),2) AS avg_defect_rate,
FROM purchase;
-- Caculate defect rate trend
SELECT 
	year, 
	month,
	ROUND(AVG((defective_units/quantity)*100),2) AS avg_defect_rate_trend
FROM purchase
GROUP BY year, month 
ORDER BY year, month;

/* Caculate lead time 
Differce between delivery and order date in days */
SELECT 	
	ROUND(AVG(delivery_date - order_date), 2) AS avg_lead_time_days, 
	PERCENTILE_CONT(.5)
	WITHIN GROUP (ORDER BY delivery_date - order_date) AS median_lead_time_days
FROM purchase
WHERE delivery_date > order_date; -- there is one row which show delivery date that is earlier than order date
-- Caculate lead time days trend
SELECT 
	year, 
	month,
	ROUND(AVG(delivery_date - order_date), 2) AS avg_lead_time_days, 
	PERCENTILE_CONT(.5)
	WITHIN GROUP (ORDER BY delivery_date - order_date) AS median_lead_time_days_trend
FROM purchase
GROUP BY year, month 
ORDER BY year, month;

/* Caculate compliance rate */
SELECT
    ROUND(CAST(SUM(CASE WHEN compliance = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL) / COUNT(*), 2) AS compliance_rate
FROM purchase;

/* Caculate average cost savings percentage by item category */
SELECT 
	item_category,
	ROUND(AVG( (unit_price - negotiated_price)/ unit_price *100), 2) AS avg_cost_savings_perc
FROM purchase
GROUP BY item_category
ORDER BY avg_cost_savings_perc DESC;

/* Caculate average defect rate by item category */
SELECT
	item_category,
	ROUND(AVG((defective_units/quantity)*100),2) AS avg_defect_rate
FROM purchase 
GROUP BY item_category
ORDER BY avg_defect_rate DESC;

/* Caculate average lead time days by item category */
SELECT 
	item_category,
	ROUND(AVG(delivery_date - order_date), 2) AS avg_lead_time_days
FROM purchase 
GROUP BY item_category
ORDER BY avg_lead_time_days DESC;
	
-- SUPPLIER PERFORMANCE
/* total purchase order value */
SELECT 
	supplier, 
	SUM(negotiated_price * quantity) AS total_PO_value
FROM purchase
GROUP BY supplier
ORDER BY total_PO_value DESC; 

/* Average cost savings % by supplier */
SELECT 
	supplier,
	ROUND(AVG( ((unit_price - negotiated_price)/ unit_price)*100), 2) AS avg_cost_savings_perc
FROM purchase
GROUP BY supplier
ORDER BY avg_cost_savings_perc DESC;

/* Meadian lead time days by supplier. Median is more robust to outliers */
SELECT 
	supplier, 
	PERCENTILE_CONT(.5)
	WITHIN GROUP (ORDER BY delivery_date - order_date) AS median_lead_time_days
FROM purchase 
GROUP BY supplier 
ORDER BY median_lead_time_days DESC; 

/* Average defect rate by supplier */
SELECT 
	supplier, 
	ROUND( AVG( (defective_units/quantity)*100), 2) AS avg_defect_rate
FROM purchase
GROUP BY supplier 
ORDER BY avg_defect_rate DESC;

/* Cancellation rate */ 
SELECT 
	supplier,
	ROUND((CAST(SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS DECIMAL) / COUNT(*))*100 , 2) AS cancellation_rate
FROM purchase 
GROUP BY supplier
ORDER BY cancellation_rate DESC;  

/*Compliance rate % by supplier */ 
SELECT 
	supplier, 
	ROUND((CAST(SUM(CASE WHEN compliance = 'Yes' THEN 1 ELSE 0 END) AS DECIMAL) / COUNT(*))*100, 2) AS compliance_rate
FROM purchase 
GROUP BY supplier 
ORDER BY compliance_rate DESC;

