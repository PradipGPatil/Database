-- list name and price of all the products which are more expensive than all products in toy
-- department
select * from products;

-- we need to find most expensive product from toy department
select max(price) from products where department='Toys';

-- no second query
select
*
from products p
where p.price> (select max(price) from products where department='Toys')