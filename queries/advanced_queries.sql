--top 3 products in each category
select category_name, product_name, price
from (
select c.name as category_name, p.name as product_name, pp.price, row_number() over (
partition by c.id
order by pp.price desc) as rn
from product p
inner join category c
on c.id = p.category_id
inner join product_price pp
on pp.product_id = p.id
) ranked_products
where rn <= 3
order by category_name, price desc;


--ranking products by price
select c.name, p.name, pp.price,
rank() over (
partition by c.id
order by pp.price desc) as rank
from product p
join category c
on c.id = p.category_id
join product_price pp
on p.id = pp.product_id;


--laptop suppliers
select s.name
from supplier s
where exists (
select 1
from supplier_product sp
join product p
on p.id = sp.product_id
join category c
on c.id = p.category_id
where sp.supplier_id = s.id and c.name = 'Ноутбуки');