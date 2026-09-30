-- 01: How many orders are in each status?
-- Only delivered orders have a real delivery date, so this defines the base for the analysis.
SELECT
  order_status,
  COUNT(*) AS number_of_orders
FROM olist.orders
GROUP BY order_status
ORDER BY number_of_orders DESC;
