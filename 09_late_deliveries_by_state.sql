-- 09: Late delivery rate and volume by customer state.
SELECT
  c.customer_state,
  COUNT(*) AS delivered_orders,
  COUNTIF(o.order_delivered_customer_date > o.order_estimated_delivery_date) AS late_orders,
  ROUND(100 * COUNTIF(o.order_delivered_customer_date > o.order_estimated_delivery_date) / COUNT(*), 1) AS late_percent
FROM olist.orders AS o
JOIN olist.customers AS c
  ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY late_percent DESC;
