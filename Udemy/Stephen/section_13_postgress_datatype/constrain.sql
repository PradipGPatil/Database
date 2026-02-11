create table products(
id serial primary key,
name varchar(40),
department varchar(40),
price integer,
weight integer
);

insert into products(name,department,price,weight)values('shirt','cloth',20,1);
select* from products;

-- here we can able to add price null which is bad data
insert into products(name,department,weight)values('tshirt','cloth',2);

-- after creating table adding constrain not null - it will give error as price contain null value already
alter table products
alter column price
set not null;

-- to avoid this error we can delete null value
-- or set value to some value and alter table  and then we try to insert null value for price it will give error
update  products set price=9999 where price is null;

-- adding unique constrain to name
alter table products
add unique(name);

-- to drop constrain - check name of the constrain
alter table products
drop constraint products_name_key;

-- adding check to ensure price should not be less than 0
alter table products
add check(price>0);
















