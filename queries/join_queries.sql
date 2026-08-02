--top high-priced items
select product.id , name, price
from product
inner join product_price
on product.id = product_price.product_id
order by price desc 
limit 5;


--orders by employee
select full_name, position, count(employee_id) as count
from employee e 
inner join orders o 
on e.id = o.employee_id 
group by e.full_name, e. position
order by count desc;


--incomplete orders 
select full_name, phone_number, email, order_status
from customer c 
inner join orders o 
on c.id = o.customer_id 
where o.order_status not in ('выдан', 'оплачен');