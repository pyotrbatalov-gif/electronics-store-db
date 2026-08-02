--products with low stock levels
select p.name, sum(s.quantity) as total, pp.price
from product p
inner join stock s
on p.id = s.product_id
inner join product_price pp
on p.id = pp.product_id
group by p.name, pp.price
having sum(quantity) < 10
order by total asc;


--revenue for the six-month period -
select sum(oi.quantity * oi.price) as total
from order_items oi
inner join orders o
on o.id = oi.order_id
where o.order_status in ('оплачен', 'выдан')
and o.date > (current_date - interval '6 months');


--best-selling category
select c.name, sum(oi.quantity) as total_sold
from category c
inner join product p 
on c.id = p.category_id 
inner join order_items oi 
on p.id = oi.product_id 
inner join orders o 
on o.id = oi.order_id 
where o.order_status in ('выдан', 'оплачен')
group by c.name 
order by total_sold desc 
limit 1;


--full order report
select c.full_name as customer_name, c.phone_number as customer_phone, e.full_name as employee_name, o.date, o.order_status, o.payment_method, p.name as product, oi.quantity, oi.price, sum(oi.quantity * oi.price) as total_price
from customer c
inner join orders o 
on c.id = o.customer_id 
inner join employee e 
on e.id = o.employee_id 
inner join order_items oi 
on o.id = oi.order_id 
inner join product p 
on p.id = oi.product_id 
where oi.order_id = 100
group by c.full_name, c.phone_number, e.full_name, o.date, o.order_status, o.payment_method, p.name, oi.quantity, oi.price;


--monthly sales
select to_char(o.date, 'yyyy-mm') as month, to_char(o.date, 'Month') as month_name, extract(year from o.date) as year, count(distinct o.id) as orders_count, sum(oi.quantity * oi.price) as total_revenue
from orders o
inner join order_items oi on o.id = oi.order_id
where o.order_status in ('выдан', 'оплачен')
group by to_char(o.date, 'yyyy-mm'), 
to_char(o.date, 'Month'),
extract(year from o.date)
order by year desc,
extract(month from min(o.date)) desc;