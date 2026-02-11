--Exercise 1

--Using your solution query to Exercise 4 from the ROW_NUMBER exercises as a staring point, add a derived column 
--called “Category Price Rank With Rank” that uses the RANK function to rank all products by ListPrice – within each 
--category - in descending order. Observe the differences between the “Category Price Rank” and “Category Price Rank With Rank” fields.

select
	p.name as productName,
	ps.name as productSubcategory,
	pc.name as productcategory,
	p.listprice,
	row_number() over(order by p.listprice desc) as priceRank,
	ROW_NUMBER() over(partition by pc.name order by p.listPrice desc) as CategoryPriceRank,
	RANK() over(partition by pc.name order by p.listPrice desc) as [Category price rank with rank],

	CASE
		when ROW_NUMBER() over(partition by pc.name order by p.listprice desc) <=5 THEN 'yes'
	else 'no'
	end as [top 5 in category]
from Production.ProductSubcategory ps 
	join Production.Product p 
		on ps.ProductSubcategoryID=p.ProductSubcategoryID
	join Production.ProductCategory pc 
		on pc.ProductCategoryID=ps.ProductCategoryID;


--Exercise 2
--Modify your query from Exercise 2 by adding a derived column called "Category Price Rank With Dense Rank"
--that that uses the DENSE_RANK function to rank all products by ListPrice – within 
--each category - in descending order. Observe the differences among the “Category Price Rank”, 
--“Category Price Rank With Rank”, and “Category Price Rank With Dense Rank” fields.
select
	p.name as productName,
	ps.name as productSubcategory,
	pc.name as productcategory,
	p.listprice,
	row_number() over(order by p.listprice desc) as priceRank,
	ROW_NUMBER() over(partition by pc.name order by p.listPrice desc) as CategoryPriceRank,
	RANK() over(partition by pc.name order by p.listPrice desc) as [Category price rank with rank],
	DENSE_RANK() over(partition by pc.name order by p.listPrice desc) as [Category price rank with dense rank],
	CASE
	 when ROW_NUMBER() over(partition by pc.name order by p.listprice desc) <=5 THEN 'yes'
	else 'no'
	end as [top 5 in category]
from Production.ProductSubcategory ps 
	join Production.Product p 
		on ps.ProductSubcategoryID=p.ProductSubcategoryID
	join Production.ProductCategory pc 
		on pc.ProductCategoryID=ps.ProductCategoryID;

--Exercise 3
--Examine the code you wrote to define the “Top 5 Price In Category” field back in the ROW_NUMBER exercises.
--Now that you understand the differences among ROW_NUMBER, RANK, and DENSE_RANK, consider which of these 
--functions would be most appropriate to return a true top 5 products by price, assuming we want to see the 
--top 5 distinct prices AND we want “ties” (by price) to all share the same rank.
select
	p.name as productName,
	ps.name as productSubcategory,
	pc.name as productcategory,
	p.listprice,
	row_number() over(order by p.listprice desc) as priceRank,
	ROW_NUMBER() over(partition by pc.name order by p.listPrice desc) as CategoryPriceRank,
	RANK() over(partition by pc.name order by p.listPrice desc) as [Category price rank with rank],
	DENSE_RANK() over(partition by pc.name order by p.listPrice desc) as [Category price rank with dense rank],
	CASE
	 when dense_rank() over(partition by pc.name order by p.listprice desc) <=5 THEN 'yes'
	else 'no'
	end as [top 5 in category]
from
Production.ProductSubcategory ps 
	join Production.Product p
		on ps.ProductSubcategoryID=p.ProductSubcategoryID
	join Production.ProductCategory pc 
		on pc.ProductCategoryID=ps.ProductCategoryID;