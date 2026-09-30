-- 05: Most common words in 1-2 star reviews of ON-TIME orders (reviews are in Portuguese).
SELECT
  word,
  COUNT(*) AS times_used
FROM olist.orders AS o
JOIN olist.reviews AS r
  ON o.order_id = r.order_id,
UNNEST(SPLIT(LOWER(r.review_comment_message), ' ')) AS word
WHERE o.order_delivered_customer_date <= o.order_estimated_delivery_date
  AND r.review_score <= 2
  AND LENGTH(word) > 3
GROUP BY word
ORDER BY times_used DESC
LIMIT 20;
