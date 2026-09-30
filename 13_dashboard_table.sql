-- 13: One row per delivered order with everything the Tableau dashboard needs.
-- Orders with several reviews get their average score, so each order counts once.
WITH items AS (
  SELECT
    order_id,
    COUNT(*) AS num_items,
    COUNT(DISTINCT seller_id) AS num_sellers,
    MAX(shipping_limit_date) AS shipping_limit,
    SUM(price) AS order_value
  FROM olist.order_items
  GROUP BY order_id
),
review_per_order AS (
  SELECT
    order_id,
    AVG(review_score) AS review_score
  FROM olist.reviews
  GROUP BY order_id
)

SELECT
  o.order_id,
  DATE(o.order_purchase_timestamp) AS purchase_date,
  c.customer_state,
  o.order_delivered_customer_date > o.order_estimated_delivery_date AS is_late,
  DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_purchase_timestamp), DAY) AS delivery_days,
  i.num_items,
  i.num_sellers,
  CASE
    WHEN i.num_items = 1 THEN '1 item'
    WHEN i.num_sellers = 1 THEN '2+ items, 1 seller'
    ELSE '2+ items, 2+ sellers'
  END AS order_type,
  o.order_delivered_carrier_date > i.shipping_limit AS seller_shipped_late,
  i.order_value,
  r.review_score
FROM olist.orders AS o
JOIN olist.customers AS c
  ON o.customer_id = c.customer_id
JOIN items AS i
  ON o.order_id = i.order_id
LEFT JOIN review_per_order AS r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;
