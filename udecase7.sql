use e_commerce;
select * from products;
select * from orders;
select * from order_reviews;
select * from customers;
select * from order_items;
select * from geolocation;
select * from sellers;
select * from product_category_name;
select * from order_payments;
select review_date,total_order,score_5_count,score_5_count/total_order from 
(select date_format (review_answer_timestamp,'%Y-%m') as review_date ,sum(case when ow.review_score =5 then 1 else 0 end) as score_5_count,count(distinct o.orders_id)as total_order from orders  o
join order_reviews  ow on o.orders_id=ow.order_id 
where o.order_status ='delivered' and year(ow.review_answer_timestamp) = '2018'
group by review_date) a; 

select date_format (review_answer_timestamp,'%Y-%m') as review_date from order_reviews;

select order_status,order_purchase_timestamp from orders;
select count(orders_id), date_format(order_purchase_timestamp,'%Y') as purchase_year,date_format(order_purchase_timestamp,'%m') as purchase_month from orders
where order_status <> 'unavailable' and order_status <> 'canceled'
group by purchase_year,purchase_month;

select op.payment_type,count(op.payment_type) as payment_method from order_payments op
join orders o on op.order_id=o.orders_id
where o.order_status <> 'canceled'
group by op.payment_type;

select sum(payment_value) as revenue,product_name from 
(select op.payment_value,oi.product_id from orders o
join order_items oi on o.orders_id=oi.order_id
join order_payments op on o.orders_id=op.order_id
where o.order_status <> 'canceled' ) a
join
(select p.product_id,pcn.product_category_name_english as product_name from products p
join product_category_name pcn on p.product_category_name=pcn.product_category_name) b on a.product_id=b.product_id
group by product_name
order by revenue
limit 10;

select sum(payment_value) as revenue,seller_id from
(select s.seller_id,oi.order_id from sellers s
join order_items oi on s.seller_id=oi.seller_id) a
join
(select op.payment_value,o.orders_id from order_payments op
join orders o on op.order_id=o.orders_id
where o.order_status <> 'canceled') b
on a.order_id=b.orders_id
group by seller_id
order by revenue desc
limit 10;

select seller_state as state,count(distinct customer_id) as no_of_customer,count(distinct seller_id) as no_of_seller,
count(distinct a.order_id) as sales,product_category_name as product_name
from 
(select s.seller_state,oi.order_id,s.seller_id from sellers s
join order_items oi on s.seller_id=oi.seller_id) a
join
(select o.customer_id,oi.order_id from orders o
join order_items oi on o.orders_id=oi.order_id
where o.order_status <> 'canceled') b
on a.order_id=b.order_id
join 
(select p.product_category_name,oi.order_id from products p 
join order_items oi on p.product_id=oi.product_id) c
on a.order_id=c.order_id
group by state,product_name
order by state desc
limit 5;

select avg(datediff(order_estimated_delivery_datetimestamp,order_purchase_timestamp)),seller_state from
(select o.order_estimated_delivery_datetimestamp,o.order_purchase_timestamp,oi.order_id from  orders o
join order_items oi on o.orders_id=oi.order_id
where o.order_status <> 'canceled') a
join 
(select s.seller_state,oi.order_id from sellers s
join order_items oi on s.seller_id=oi.seller_id) b
on a.order_id=b.order_id 
group by seller_state

