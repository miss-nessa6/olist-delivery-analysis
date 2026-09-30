-- 12: Do customers whose FIRST order was late come back less often?
-- Uses customer_unique_id (the real person), since customer_id changes with every order.
WITH customer_orders AS (
  SELECT
    c.customer_unique_id,
    o.order_delivered_customer_date > o.order_estimated_delivery_date AS was_late,
    ROW_NUMBER() OVER (
      PARTITION BY c.customer_unique_id
      ORDER BY o.order_purchase_timestamp
    ) AS order_number,
    COUNT(*) OVER (PARTITION BY c.customer_unique_id) AS total_orders
  FROM olist.orders AS o
  JOIN olist.customers AS c
    ON o.customer_id = c.customer_id
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
)

SELECT
  CASE
    WHEN was_late THEN 'First order late'
    ELSE 'First order on time'
  END AS first_order_experience,
  COUNT(*) AS customers,
  ROUND(100 * COUNTIF(total_orders > 1) / COUNT(*), 2) AS repeat_customer_percent
FROM customer_orders
WHERE order_number = 1
GROUP BY first_order_experience;
