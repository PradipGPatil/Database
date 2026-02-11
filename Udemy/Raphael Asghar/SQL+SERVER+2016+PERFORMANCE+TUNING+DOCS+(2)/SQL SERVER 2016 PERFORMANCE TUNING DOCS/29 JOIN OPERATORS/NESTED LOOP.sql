


--Example of a NESTED loop join
--Where the smaller table does not have an index BASED on the column being used in an index, but the larger does have an index

SELECT * FROM  Sales.SalesOrderHeader AS OH
WHERE OH.OrderDate BETWEEN '2011-07-01' AND '2011-07-14'  --<< SMALLER TABLE (144 ROWS) (OUTER TABLE) DOES NOT HAVE AN INDEX ON COLUMN ORDERDATE

SELECT * FROM  Sales.SalesOrderDetail  AS OD              --<< LARGER TABLE (121317 ROWS) (INNER TABLE)


SELECT 
OH.OrderDate, OD.OrderQty
FROM  Sales.SalesOrderHeader AS OH 
INNER JOIN
Sales.SalesOrderDetail AS OD 
ON OH.SalesOrderID = OD.SalesOrderID
WHERE (OH.OrderDate BETWEEN '2011-07-01' AND '2011-07-14')  --<< SMALLER TABLE (144 ROWS) (OUTER TABLE) DOES NOT HAVE AN INDEX ON COLUMN ORDERDATE

--Example of a HASH join
--This happens when the tables are not properly sorted, and/or there are no indexes. 
--When SQL Server Optimizer chooses the Hash join type, it’s usually means an index is missing
  
--CREATE 2 LARGE TABLE WITHOUT INDEXES. AS THERE ARE NO INDEX ON OR SORTS ON THE TABLES 
--THIS WILL CAUSE A HASH JOIN TO BE SELECTED BY THE OPTIMIZER

--USE AdventureWorks2016CTP3
--GO

--DROP TABLE TABLE1
--DROP TABLE TABLE2

CREATE TABLE  TABLE1 
(id INT identity ,EVENTS varchar(60))

--INSERT SOME DATA 

declare @i int
set @i=0
while (@i<100)
begin
insert into TABLE1 (EVENTS)
select EVENT from AdventureWorks2016CTP3.dbo.DatabaseLog
set @i=@i+1
end

--VIEW LARGE TABLE

SELECT * FROM TABLE1  --<<17900 ROWS

--CREATE A SECOND TABLE

CREATE TABLE  TABLE2 
(id INT identity ,EVENTS varchar(60))

--INSERT SOME DATA

declare @i int
set @i=0
while (@i<100)
begin
insert into TABLE2 (EVENTS)
select EVENT from AdventureWorks2016CTP3.dbo.DatabaseLog
set @i=@i+1
end

--VIEW LARGE TABLE

SELECT * FROM TABLE2  --<<17900 ROWS


--EXECUTE AND VIEW HASH JOIN AS THERE IS NO INDEX

SELECT TABLE1.id, TABLE1.EVENTS, 
TABLE2.id AS Expr1, 
TABLE2.EVENTS AS Expr2
FROM 
TABLE1 
INNER JOIN
TABLE2 
ON TABLE1.id = TABLE2.id

--WHAT IF WE CREATE AN INDEX BOTH TABLES

USE [AdventureWorks2016CTP3]
GO
CREATE NONCLUSTERED INDEX [TEST]
ON [dbo].[TABLE2] ([id])
INCLUDE ([EVENTS])

USE [AdventureWorks2016CTP3]
GO
CREATE NONCLUSTERED INDEX [TEST]
ON [dbo].[TABLE1] ([id])
INCLUDE ([EVENTS])
GO


--EXECUTE AND VIEW AFTER CREATION OF INDEX.  IT SHOULD BE NESTED JOIN

SELECT TABLE1.id, TABLE1.EVENTS, 
TABLE2.id AS Expr1, 
TABLE2.EVENTS AS Expr2
FROM 
TABLE1 
INNER JOIN
TABLE2 
ON TABLE1.id = TABLE2.id
WHERE TABLE1.ID = 165804

--EXAMPLE OF A MERGE JOIN

--The merge join requires both inputs to be sorted on the merge columns
--The merge join is fast because it requires that both inputs are already sorted
--Because the rows are pre-sorted, a Merge join immediately begins the matching process. 
--If the rows match, that matched row is considered in the result-set
--A Merge join performs better when joining large input tables


SELECT H.CustomerID, H.SalesOrderID, D.ProductID, D.LineTotal 
FROM Sales.SalesOrderHeader H 
INNER JOIN Sales.SalesOrderDetail D ON H.SalesOrderID = D.SalesOrderID 
WHERE H.CustomerID > 100 



--EXAMPLE OF COMPUTER SCALAR OPERATOR  -- CREATED WHEN YOU HAVE A NEW COMPUTER VALUE FROM EXISTING VALUES


SELECT        
OrderQty
FROM            Sales.SalesOrderDetail
WHERE SalesOrderID = '43659'
GROUP  BY SalesOrderID, OrderQty
