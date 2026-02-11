select * from products;
-- sort the product from higest to lowest price

select * from products order by price desc

-- find 2nd and 3rd higest product

select * from products order by price desc offset 1 limit 2;

-- sort product by price and weight
select * from products order by price, weight;