# Subscription -- Subscription Item -- Subscription Itemmeta
SELECT subscription_items.ID AS 'Subscription_ID',
       subscription_items.post_date AS 'Subscription_Date',
       itemmeta.order_item_id AS 'Item_ID',
       itemmeta.meta_key AS 'Meta_Key',
       itemmeta.meta_value AS 'Meta_Value'
FROM
  (SELECT *
   FROM
     (SELECT *
      FROM wp_posts
      WHERE post_type = 'shop_subscription'
        AND post_date > '2020-04-28 00:00:00') subscriptions
   LEFT JOIN wp_woocommerce_order_items items ON subscriptions.ID = items.order_id) subscription_items
LEFT JOIN wp_woocommerce_order_itemmeta itemmeta ON subscription_items.order_item_id = itemmeta.order_item_id
WHERE meta_key = '_wcsatt_scheme'
ORDER BY subscription_items.post_date ASC;



# Customer and the number of active subscriptions they have
SELECT subscription_meta.meta_value AS 'Customer ID',
       customer.user_email AS 'User email',
       count(*) AS 'Active subscriptions'
FROM
  (SELECT *
   FROM wp_posts
   WHERE post_type = 'shop_subscription'
     AND post_status = 'wc-active') active_subscriptions
LEFT JOIN wp_postmeta subscription_meta ON active_subscriptions.ID = subscription_meta.post_id
LEFT JOIN wp_users customer ON subscription_meta.meta_value = customer.ID
WHERE meta_key = '_customer_user'
GROUP BY subscription_meta.meta_value
ORDER BY count(*) DESC;
