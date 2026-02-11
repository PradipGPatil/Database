 -- > all 
 --show name , department and price of the products that are more expensive than all product from 'industrial department'
 select * from products;
 select name, department, price from products where price > all (select price from products where department='Industrial' );

  --show name , department and price of the products that are atleast one product  from 'industrial department'
   select name, department, price from products where price > some (select price from products where department='Industrial' );

   -- co related subquery
   -- show name, department , price of the most expensive product in each department
   select max(price) from products where department='Industrial';
   select name, department , price from products as p1 where price=(select max(price) from products as p2 where p1.department=p2.department);

   -- without using a join or a group by , print the number of orders for 
  -- each product;
  select * from orders;
 -- select  department, count(*)  from products join orders on products.id=orders.product_id  group by department ;
 select  name,(select count (*)from orders as o1 where p1.id=o1.product_id)from products as p1;

 -- column name and data type of both union should be same
select price from products
union
select name from products;

-- this will work 
select price from products 
union all
select weight from products;
 







 