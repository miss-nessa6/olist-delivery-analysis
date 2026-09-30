-- 07: Read real examples: bad reviews of on-time orders that mention "apenas" (only).
-- Note: keyword-based sample, so it shows the problem exists, not how big it is.
SELECT
  r.review_score,
  r.review_comment_message
FROM olist.orders AS o
JOIN olist.reviews AS r
  ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date <= o.order_estimated_delivery_date
  AND r.review_score <= 2
  AND LOWER(r.review_comment_message) LIKE '%apenas%'
LIMIT 20;
