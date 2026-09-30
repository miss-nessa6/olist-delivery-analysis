-- 08: On-time orders only: do orders with several items get more bad reviews?
-- Items are counted per order first to avoid double-counting orders.
WITH items_per_order AS (
  SELECT
    order_id,
    COUNT(*) AS num_items
  FROM olist.order_items
  GROUP BY order_id
)

SELECT
  CASE
    WHEN i.num_items = 1 THEN '1 item'
    ELSE '2+ items'
  END AS order_size,
  COUNT(*) AS number_of_orders,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  ROUND(100 * COUNTIF(r.review_score <= 2) / COUNT(*), 1) AS bad_review_percent
FROM olist.orders AS o
JOIN items_per_order AS i
  ON o.order_id = i.order_id
JOIN olist.reviews AS r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_customer_date <= o.order_estimated_delivery_date
GROUP BY order_size
ORDER BY order_size;
