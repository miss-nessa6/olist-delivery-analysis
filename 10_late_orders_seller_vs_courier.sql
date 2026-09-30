-- 10: Late orders only: did the seller miss its shipping deadline, or did the delay happen in delivery?
WITH seller_deadline AS (
  SELECT
    order_id,
    MAX(shipping_limit_date) AS shipping_limit
  FROM olist.order_items
  GROUP BY order_id
)

SELECT
  CASE
    WHEN o.order_delivered_carrier_date > s.shipping_limit THEN 'Seller shipped late'
    ELSE 'Seller shipped on time'
  END AS seller_stage,
  COUNT(*) AS late_orders,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS percent_of_late_orders
FROM olist.orders AS o
JOIN seller_deadline AS s
  ON o.order_id = s.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date > o.order_estimated_delivery_date
  AND o.order_delivered_carrier_date IS NOT NULL
GROUP BY seller_stage;
