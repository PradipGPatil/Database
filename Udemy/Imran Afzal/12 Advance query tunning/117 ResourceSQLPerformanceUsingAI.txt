-- Missing Index Example
SET STATISTICS IO,TIME ON 
-- Displays information about logical and physical reads and writes performed by the query.
-- Displays the time taken to parse, compile, and execute the query.
-- Logical reads refer to the number of data pages read from the SQL Server buffer cache (memory) 
-- to satisfy a query request.

--Analyze the execution plan 
--Create the missing Index 
-- SQL query retrieves the total sales for each product from the AdventureWorks2022 database for the year 2014

USE AdventureWorks2022;
GO

SELECT 
    p.Name AS ProductName, 
    SUM(sod.LineTotal) AS TotalSales
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p 
    ON sod.ProductID = p.ProductID
JOIN 
    Sales.SalesOrderHeader soh 
    ON sod.SalesOrderID = soh.SalesOrderID
WHERE 
    soh.OrderDate BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY 
    p.Name
ORDER BY 
    TotalSales DESC;
GO

----------------------------------------------------

CREATE NONCLUSTERED INDEX IX_SalesOrderHeader_OrderDate
ON Sales.SalesOrderHeader (OrderDate);


CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_Product
ON Sales.SalesOrderDetail (ProductID)
INCLUDE (SalesOrderID, LineTotal, OrderQty);


drop index IX_SalesOrderHeader_OrderDate on Sales.SalesOrderHeader;

----------------------------------------------------

-- cursor based SP
CREATE OR ALTER PROCEDURE UpdateProductPricesUsingCursor 
AS 
BEGIN 
    DECLARE @ProductID INT;
    DECLARE @IncreaseAmount DECIMAL(10,2) = 20.00; -- Fixed amount to increase

    -- Cursor to iterate through all products
    DECLARE product_cursor CURSOR FOR 
    SELECT ProductID  
    FROM Production.Product 
    WHERE StandardCost > 0;

    -- Open cursor
    OPEN product_cursor; 
    FETCH NEXT FROM product_cursor INTO @ProductID; 

    WHILE @@FETCH_STATUS = 0 
    BEGIN 
        -- Update each product's ListPrice by reducing it
        UPDATE Production.Product 
        SET ListPrice = ListPrice - @IncreaseAmount 
        WHERE ProductID = @ProductID; 

        -- Fetch next record
        FETCH NEXT FROM product_cursor INTO @ProductID; 
    END 

    -- Close and deallocate cursor
    CLOSE product_cursor; 
    DEALLOCATE product_cursor; 
END; 
GO


DECLARE @StartTime datetime2 =SYSDATETIME(); 
 
--Place your stored procedure call here 

EXEC  UpdateProductPricesUsingCursor

SELECT DATEDIFF(millisecond, @StartTime, SYSDATETIME()) AS DurationInMilliseconds; 

 

Go 


-----------------------------
SELECT * 

from sys.configurations 

GO 
 
-----------------
--query with hint

USE AdventureWorks2022 

GO  

--CTRL + M 

SET STATISTICS IO, TIME ON 
--which of the following query perform best in terms of performance? 
--Query without any hint 

-- Retrieves a list of products that have been sold, along with the order quantity and unit price for each sale.

SELECT p.Name AS ProductName, sod.OrderQty, sod.UnitPrice
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID;


--Query with fast 100 hint 

SELECT p.Name AS ProductName, sod.OrderQty, sod.UnitPrice
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
OPTION (FAST 100); 

 --Query with fast 1 hint 

SELECT p.Name AS ProductName, sod.OrderQty, sod.UnitPrice
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
OPTION (FAST 1); 

