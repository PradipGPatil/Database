--Exercise 1
--Create a query that returns all records - and the following columns - from the HumanResources.Employee table:
--a. BusinessEntityID (alias this as “EmployeeID”)
--b. JobTitle
--c. HireDate
--d. VacationHours
--To make the effect of subsequent steps clearer, also sort the query output by "JobTitle" and HireDate, both in ascending order.

select 
	e.BusinessEntityID as EmployeeID,
	e.JobTitle,
	e.HireDate,
	e.VacationHours
from HumanResources.Employee e 
	order by e.JobTitle, e.HireDate;

--Now add a derived column called “FirstHireVacationHours” that displays – for a given job title – 
--the amount of vacation hours possessed by the first employee hired who has that same job title. 
--For example, if 5 employees have the title “Data Guru”, and the one of those 5 with the oldest hire date has 99 vacation hours,
-- “FirstHireVacationHours” should display “99” for all 5 of those employees’ corresponding records in the query.

select 
	e.BusinessEntityID as EmployeeID,
	e.JobTitle,
	e.HireDate,
	e.VacationHours,
	FirstHireCacationHours=FIRST_VALUE(e.VacationHours)over(partition by e.jobtitle order by hireDate)
from HumanResources.Employee e 
	order by e.JobTitle, e.HireDate;


--Exercise 2
--Create a query with the following columns:
--a. “ProductID” from the Production.Product table
--b. “Name” from the Production.Product table (alias this as “ProductName”)
--c. “ListPrice” from the Production.ProductListPriceHistory table
--d. “ModifiedDate” from the Production.ProductListPriceHistory
--You can join the Production.Product and Production.ProductListPriceHistory tables on "ProductID".
--Note that the Production.ProductListPriceHistory table contains a distinct record for every different price a product has been listed at.
-- This means that a single product ID may have several records in this table – one for every list price it has had.
--Also note that the “ModifiedDate” field in this table displays the effective date of each of these prices. 
--So if there are 3 rows in the table for product ID 12345,
-- the row with the oldest modified date also contains the first price in the associated product’s history. Conversely, 
--the row with the most recent modified date also contains the current price of the product.

select * from Production.Product;
select * from Production.ProductListPriceHistory;

select
	p.ProductID,
	p.name,
	ph.ListPrice,
	ph.ModifiedDate
from
	Production.Product as p 
		join Production.ProductListPriceHistory as ph
		on p.ProductID=ph.ProductID;

		--To make the effect of subsequent steps clearer, also sort the query output by ProductID and ModifiedDate, 
		--both in ascending order.
select
	p.ProductID,
	p.name,
	ph.ListPrice,
	ph.ModifiedDate
from
	Production.Product as p 
		join Production.ProductListPriceHistory as ph
		on p.ProductID=ph.ProductID
order by p.ProductID,ph.ModifiedDate;

--Now add a derived column called “HighestPrice” that displays – for a given product – 
--the highest price that product has been listed at. So even if there are 4 records for a given product, 
--this column should only display the all-time highest list price for that product in each of those 4 rows.
select
	p.ProductID,
	p.name,
	ph.ListPrice,
	ph.ModifiedDate,
	highestPrice=FIRST_VALUE(ph.ListPrice)over(partition by p.productId order by ph.listPrice)
from
	Production.Product as p 
		join Production.ProductListPriceHistory as ph
		on p.ProductID=ph.ProductID
order by p.ProductID,ph.ModifiedDate;

--Similarly, create another derived column called “LowestCost” that displays the all-time lowest price for a given product.
select
	p.ProductID,
	p.name,
	ph.ListPrice,
	ph.ModifiedDate,
	highestPrice=FIRST_VALUE(ph.ListPrice)over(partition by p.productId order by ph.listPrice desc),
	lowestPrice=FIRST_VALUE(ph.ListPrice)over(partition by p.productId order by ph.listPrice )
from
	Production.Product as p 
		join Production.ProductListPriceHistory as ph
		on p.ProductID=ph.ProductID
order by p.ProductID,ph.ModifiedDate;

--Finally, create a third derived column called “PriceRange” that reflects,
--for a given product, the difference between its highest and lowest ever list prices
select
	p.ProductID,
	p.name,
	ph.ListPrice,
	ph.ModifiedDate,
	highestPrice=FIRST_VALUE(ph.ListPrice)over(partition by p.productId order by ph.listPrice desc),
	lowestPrice=FIRST_VALUE(ph.ListPrice)over(partition by p.productId order by ph.listPrice ),
	priceRange=FIRST_VALUE(ph.ListPrice)over(partition by p.productId order by ph.listPrice desc) -FIRST_VALUE(ph.ListPrice)over(partition by p.productId order by ph.listPrice )
from
	Production.Product as p 
		join Production.ProductListPriceHistory as ph
		on p.ProductID=ph.ProductID
order by p.ProductID,ph.ModifiedDate;















