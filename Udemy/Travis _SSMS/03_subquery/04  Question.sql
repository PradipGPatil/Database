--Exercise 1

--Create a query that displays all rows from the Production.ProductSubcategory table, and includes the following fields:

--The "Name" field from Production.ProductSubcategory, which should be aliased as "SubcategoryName"

--A derived field called "Products" which displays, for each Subcategory in Production.ProductSubcategory,
 --a semicolon-separated list of all products from Production.Product contained within the given subcategory

--Hint: Production.ProductSubcategory and Production.Product are related by the "ProductSubcategoryID" field.

--Exercise 2


--Modify the query from Exercise 1 such that only products with a ListPrice value greater than $50 are listed in the "Products" field.

--Hint: Assuming you used a correlated subquery in Exercise 1, keep in mind that you can apply additional criteria to it, just as with any other correlated subquery.
--
--NOTE: Your query should still include ALL product subcategories, but only list associated products greater than $50. 
--But since there are certain product subcategories that don't have any associated products greater than $50,
--some rows in your query output may
--have a NULL value in the product field.