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

select year (review_answer_timestamp)  from order_reviews
order by review_answer_timestamp desc
where year(order_approved_at) = '2018';


select date_format (review_answer_timestamp,'%Y-%m') as review_date from order_reviews;



