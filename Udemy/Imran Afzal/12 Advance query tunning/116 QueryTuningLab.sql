-- Understand the database schema and design: 
SELECT LastName, FirstName,[CreditCardID]
FROM [Person].[Person]
INNER JOIN [Sales].[PersonCreditCard]
ON [Person].[Person].[BusinessEntityID] = [Sales].[PersonCreditCard].[BusinessEntityID];

-- Indexing: 
select * from [Sales].[SalesOrderDetail] where [CarrierTrackingNumber] = '4911-403C-98'


-- Avoid using SELECT *:
SELECT *
FROM [Person].[Person]

SELECT LastName, FirstName
FROM [Person].[Person]

-- Use Joins instead of Subqueries:
SELECT LastName
FROM [Person].[Person] 
WHERE [BusinessEntityID] IN (select BusinessEntityID from [Sales].[SalesPerson] where [SalesQuota] = 300000.00)

SELECT LastName
FROM [Person].[Person] p
join [Sales].[SalesPerson] s
on p.BusinessEntityID = s.BusinessEntityID
and s.[SalesQuota] = 300000.00

-- Use stored procedures: 
Create Table NewEmployees 
(FirstName nvarchar(50) ,
LastName nvarchar(50))

CREATE PROCEDURE AddNewEmployee
@FirstName nvarchar(50), 
@LastName nvarchar(50)
AS
BEGIN
    INSERT INTO NewEmployees (FirstName, LastName)
    VALUES (@FirstName, @LastName);
END;

exec AddNewEmployee 'Imran','Afzal'


select * from NewEmployees 
-- Avoid functions in the WHERE clause:

SELECT * FROM [Sales].[SalesOrderDetail] WHERE YEAR([ModifiedDate]) = 2011; 


SELECT * FROM [Sales].[SalesOrderDetail] WHERE [ModifiedDate] BETWEEN '2011-01-01' AND '2011-12-31'; 


-- Use Pagination
SELECT * FROM [Sales].[SalesOrderDetail] 
ORDER BY SalesOrderID
OFFSET 50 ROWS 
FETCH NEXT 10 ROWS ONLY;


-- Declare variables to hold parameter values
DECLARE @LastName nvarchar(50), @FirstName nvarchar(50);

-- Set values for parameters
SET @LastName = 'Abbas';
SET @FirstName = 'Syed';

-- Write the parameterized query
SELECT LastName, FirstName FROM [Person].[Person] where LastName = @LastName and FirstName = @FirstName


SELECT LastName, FirstName FROM [Person].[Person] where LastName = 'abbas' and FirstName = 'syed'