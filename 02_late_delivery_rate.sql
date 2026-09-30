-- 02: What share of delivered orders arrived after the promised date?
SELECT
  COUNT(*) AS delivered_orders,
  COUNTIF(order_delivered_customer_date > order_estimated_delivery_date) AS late_orders,
  ROUND(100 * COUNTIF(order_delivered_customer_date > order_estimated_delivery_date) / COUNT(*), 1) AS late_percent
FROM olist.orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
