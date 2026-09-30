-- 11: On-time orders only: bad reviews for single-item, multi-item/one-seller and multi-seller orders.
WITH order_summary AS (
  SELECT
    order_id,
    COUNT(*) AS num_items,
    COUNT(DISTINCT seller_id) AS num_sellers
  FROM olist.order_items
  GROUP BY order_id
)

SELECT
  CASE
    WHEN s.num_items = 1 THEN '1 item'
    WHEN s.num_sellers = 1 THEN '2+ items, 1 seller'
    ELSE '2+ items, 2+ sellers'
  END AS order_type,
  COUNT(*) AS number_of_orders,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  ROUND(100 * COUNTIF(r.review_score <= 2) / COUNT(*), 1) AS bad_review_percent
FROM olist.orders AS o
JOIN order_summary AS s
  ON o.order_id = s.order_id
JOIN olist.reviews AS r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_customer_date <= o.order_estimated_delivery_date
GROUP BY order_type
ORDER BY order_type;
