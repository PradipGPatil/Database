
--DROP TABLE

USE AdventureWorks2016CTP3
GO

DROP TABLE [AdventureWorks2016CTP3].[HumanResources].[EmployeeA] 


--FIND ALL INDEXES IN DATABASE

USE AdventureWorks2016CTP3
GO

SELECT t.name AS TableName, col.name AS ColumnName, ind.name AS IndexName, ind.index_id AS IndexId, ind.type_desc
FROM  sys.indexes AS ind INNER JOIN
sys.index_columns AS ic ON ind.object_id = ic.object_id AND ind.index_id = ic.index_id INNER JOIN
sys.columns AS col ON ic.object_id = col.object_id AND ic.column_id = col.column_id INNER JOIN
sys.tables AS t ON ind.object_id = t.object_id
WHERE        (ind.is_primary_key = 0) AND (ind.is_unique = 0) AND (ind.is_unique_constraint = 0) AND (t.is_ms_shipped = 0)
ORDER BY TableName, IndexName, IndexId, ic.index_column_id

--INSERT DATA FROM EMPLOYEE TO EMPLOYEEA TABLE. NO INDEXES OR PK


SELECT
[BusinessEntityID]
,[JobTitle]
,[BirthDate]
,[MaritalStatus]
,[Gender]
,[HireDate]
,[VacationHours]
INTO [HumanResources].[EmployeeA] 
FROM [HumanResources].[Employee]

-- IF WE RUN THE EXECUTION PLAN WE SEE A TABLE SCAN

SELECT * FROM [HumanResources].[EmployeeA] 

--LETS CREATE A CLUSTERED INDEX ON ID

USE [AdventureWorks2016CTP3]
GO

CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-ID] 
ON [HumanResources].[EmployeeA]
([BusinessEntityID] ASC)



--IN PREVIOUS EXAMPLE OF CLUSTERED INDEX, WE GOT A CLUSETERED INDEX SEEK WHEN WE DID A WHERE PREDICATE, BUT NOT HERE!  WHY?
--IT'S BECAUSE IT USING THE CLUSTERED INDEX SCAN AND SCANNING THE ENTIRE TABLE AND BECAUSE THE WHERE PREDICATE (JOBTITLE IS NOT)
--DEFINED BY THE CLUSTERED INDEX.  WE CAN RESOLVE THIS BY USING A NON CLUSTERED INDEX ON THE JOBTITLE COLUMN

SELECT * FROM [HumanResources].[EmployeeA] 
WHERE [JobTitle] = 'Engineering Manager'

--ADD A NON CLUSTERED INDEX ON JOBTILE COLUMN

USE [AdventureWorks2016CTP3]
GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-JOBTITLE] 
ON [HumanResources].[EmployeeA]
([JobTitle] ASC)

--AFTER THE CREATION OF A NON CLUSTERED INDEX ON JOB TITLE, THE FOLLOWING SAME QUERY WILL USE THE INDEX TO RETURN THE VALUES AS A SEEK
--BECAUSE WE ARE USING THE SINGLE COLUMN INSTEAD OF THE ENTIRE (*) TABLE DATA.

SELECT [JobTitle] 
FROM [HumanResources].[EmployeeA] 
WHERE [JobTitle] = 'Engineering Manager'

--WHAT IF YOU HAD MULTIPLE COLUMNS WITH THE WHERE CLAUSE.  WHAT WOULD THE EXECUTION PLAN LOOK LIKE?


--SET STATS ON TO VIEW PAGES

SET STATISTICS IO ON

--DROP TABLE

USE [AdventureWorks2016CTP3]
GO

DROP TABLE [AdventureWorks2016CTP3].[Person].[AddressA] 

--IMPORT DATA WITHOUT INDEXES

SELECT *
INTO [AdventureWorks2016CTP3].[Person].[AddressA] 
FROM [AdventureWorks2016CTP3].[Person].[Address]

--VIEW DATA

SELECT * FROM [AdventureWorks2016CTP3].[Person].[AddressA] 

--CREATE A CLUSTERED INDEX ON ADDRESSID

USE [AdventureWorks2016CTP3]
GO

CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-AddressID] 
ON [Person].[AddressA]
([AddressID] ASC)

--AFTER CREATING CLUSTERED INDEX, USING SPECIFIC COLUMNS, WE GET 341 LOGICAL READS AND USES THE CLUSTERED INDEX

select [City],[AddressLine1],[StateProvinceID],[PostalCode]
FROM [AdventureWorks2016CTP3].[Person].[AddressA] 
--logical reads 341

--NOW USING THE WHERE CLAUSE FOR CITY, READS 341 AND STILL USING CLUSTERED INDEX

select [City],[AddressLine1],[StateProvinceID],[PostalCode]
FROM [AdventureWorks2016CTP3].[Person].[AddressA] 
where city = 'Oakland'
--logical reads 341

--CREATING A NON CLUSTERED INDEX ON CITY

USE [AdventureWorks2016CTP3]
GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-CITY] 
ON [Person].[AddressA]
([City] ASC)

--AFTER CREATING A NON CLUSTERED INDEX ON COLUMN CITY AND USING THE SAME QUERY WITH A SINGLE COLUMN CITY, READS = 3, AND USING THE NON CLUSTERED INDEX

select [City]
FROM [AdventureWorks2016CTP3].[Person].[AddressA] 
where city = 'Oakland'
--logical reads 3


--HOWEVER, WHEN USING MORE THAN ONE COLUMN IN THE SELECT STATEMENT, WE GET 193 READS AND A KEY LOOKUP AGAINST THE CLUSTERED INDEX
--AND COST IS 99% AND A NESTED LOOP OPERATOR.  WHY?  BECAUSE THE WE ADDED COLUMN ([AddressLine1]) WHICH IS NOT PART OF THE NON CLUSTERED INDEX
--AND THUS IT REACHES OUR TO THE CLUSTEDED INDEX TO RETRIVE THAT DATA AND IT DOES A TABLE SCAN.  EXPENSIVE!
--HOW CAN WE GET RID OF THAT?  CREATE A COVERED INDEX. 
--A covering index is an index that contains all of the columns you need for your query

select [City],[AddressLine1]
FROM [AdventureWorks2016CTP3].[Person].[AddressA] 
where city = 'Oakland'
--logical reads 193

--CREATING A COVERED INDEX ON BOTH COLUMN IN THE SELECT STATEMENT

USE [AdventureWorks2016CTP3]
GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-COVER] 
ON [Person].[AddressA]
([AddressLine1] ASC,[City] ASC)  --<< NOTE THAT THE NEW NON CLUSTERED INDEX HAS BOTH COLUMNS

--AFTER COVERED INDEX - EXECUTING THE SAME QUERY - THE KEY LOOKUP IS GONE BECUASE THE DATA IS DIRICTLY GOING TO THE NON CLUSTERED INDEX

select [City],[AddressLine1]
FROM [AdventureWorks2016CTP3].[Person].[AddressA] 
where city = 'Oakland'
--logical reads 171

--Displays information for the data and indexes (OLD METHOD)

USE [AdventureWorks2016CTP3]
GO

DBCC SHOWCONTIG ('PERSON.AddressA');  
GO  


--Filtered Index Design Guidelines (NEXT)

--IF YOU SAW IN THE PREVIOUS VIDEO, THAT AFTER CREATING A COVERED INDEX, WE STILL GOT A NON CLUSTERED INDEX SCAN AND NOT A SEEK.  
--WHY?  THAT IS BECAUSE THE ORDER OF THE COLUMNS WAS NOT IN THE RIGHT ORDER, AS THE INDEX HAD THE ADDRESSLINE1 FIRST AND THEN THE CITY.
--IF WE REVERSE THE COLUMN NAME WE WILL GET A SEEK!!

select [City],[AddressLine1]
FROM [AdventureWorks2016CTP3].[Person].[AddressA] 
where city = 'Oakland'
--logical reads 171

--DROP THE INDEX AND RECREATE THE INDEX WITH PROPER COLUMN ORDER


USE [AdventureWorks2016CTP3]
GO

DROP INDEX [NonClusteredIndex-COVER] ON [Person].[AddressA]
GO


USE [AdventureWorks2016CTP3]
GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-COVER] 
ON [Person].[AddressA]
([City] ASC,[AddressLine1] ASC)  --<< NOTE THAT THE NEW NON CLUSTERED INDEX HAS BOTH COLUMNS BUT I HAVE SWITCHED THE ORDER OF THE COLUMNS

--SAME QUERY BUT THIS TIME WE HAVE A SEEK!!

select [City],[AddressLine1]
FROM [AdventureWorks2016CTP3].[Person].[AddressA] 
where city = 'Oakland'
--logical reads 171