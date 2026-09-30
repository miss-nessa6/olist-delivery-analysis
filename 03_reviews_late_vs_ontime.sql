-- 03: Do late orders get worse reviews? Average score and share of 1-2 star reviews.
SELECT
  CASE
    WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
    ELSE 'On time'
  END AS delivery_status,
  COUNT(*) AS number_of_orders,
  ROUND(AVG(r.review_score), 2) AS avg_review_score,
  ROUND(100 * COUNTIF(r.review_score <= 2) / COUNT(*), 1) AS bad_review_percent
FROM olist.orders AS o
JOIN olist.reviews AS r
  ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;
