-- find avg number of orders for all users
select * from orders;

select
avg(i.order_qty)
from(
select o.user_id,count(*) as order_qty from orders o group by o.user_id
) as i