--Exercise 1
--Create a query with the following columns:
--�Name� from the Production.Product table, which can be alised as �ProductName�
--�ListPrice� from the Production.Product table
--�Name� from the Production. ProductSubcategory table, which can be alised as �ProductSubcategory�*
--�Name� from the Production.ProductCategory table, which can be alised as �ProductCategory�**

--*Join Production.ProductSubcategory to Production.Product on �ProductSubcategoryID�
--**Join Production.ProductCategory to ProductSubcategory on �ProductCategoryID�
--All the tables can be inner joined, and you do not need to apply any criteria.
select 
	p.Name as productName,
	p.ListPrice ,
	sc.Name as productSubcategory,
	c.Name as productCategory
from Production.Product p
	join Production.ProductSubcategory sc on p.ProductSubcategoryID=sc.ProductSubcategoryID
	join Production.ProductCategory c on c.ProductCategoryID=sc.ProductCategoryID


--Exercise 2

--Enhance your query from Exercise 1 by adding a derived column called
--"AvgPriceByCategory " that returns the average ListPrice for the product category in each given row.
select 
	p.Name as productName,
	p.ListPrice ,
	sc.Name as productSubcategory,
	c.Name as productCategory,
	[avgPriceByCategory]=avg(p.ListPrice)over(partition by c.name)
from Production.Product p
	join Production.ProductSubcategory sc on p.ProductSubcategoryID=sc.ProductSubcategoryID
	join Production.ProductCategory c on c.ProductCategoryID=sc.ProductCategoryID;

--Exercise 3

--Enhance your query from Exercise 2 by adding a derived column called
--"AvgPriceByCategoryAndSubcategory" that returns the average ListPrice for the product 
--category AND subcategory in each given row.

select 
	p.Name as productName,
	p.ListPrice ,
	sc.Name as productSubcategory,
	c.Name as productCategory,
	[avgPriceByCategory]=avg(p.ListPrice)over(partition by c.name),
	[AvgPriceByCategoryAndSubcategory]=avg(p.ListPrice)over(partition by c.name,sc.name)
from Production.Product p
	join Production.ProductSubcategory sc on p.ProductSubcategoryID=sc.ProductSubcategoryID
	join Production.ProductCategory c on c.ProductCategoryID=sc.ProductCategoryID
	order by 4

--	Exercise 4:

--Enhance your query from Exercise 3 by adding a derived column called
--"ProductVsCategoryDelta" that returns the result of the following calculation:
--A product's list price, MINUS the average ListPrice for that product�s category.
 
select 
	p.Name as productName,
	p.ListPrice ,
	sc.Name as productSubcategory,
	c.Name as productCategory,
	[avgPriceByCategory]=avg(p.ListPrice)over(partition by c.name),
	[AvgPriceByCategoryAndSubcategory]=avg(p.ListPrice)over(partition by c.name,sc.name),
	[ProductVsCategoryDelta]=p.ListPrice -avg(p.ListPrice)over(partition by c.name)
from Production.Product p
	join Production.ProductSubcategory sc on p.ProductSubcategoryID=sc.ProductSubcategoryID
	join Production.ProductCategory c on c.ProductCategoryID=sc.ProductCategoryID
	order by 4

