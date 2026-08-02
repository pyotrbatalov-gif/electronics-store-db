--order cost
select sum(quantity * price) as total_price, count(product_id) as total_items
from order_items
where order_id = 100;


--new customers
select full_name, phone_number, email, registration_date
from customer
where registration_date >= '2026-03-01';


--orders by status
select order_status, count(order_status) as count
from orders
group by order_status 
order by count asc;