
--Viewing the statistics

--When executing this query, we notice it has statistics

SELECT * 
FROM Sales.SalesOrderDetail

--old way of displaying index

exec sp_helpindex 'Sales.SalesOrderDetail' 

--insert data into new table - no statistics as there are no indexes

--drop table

--drop table Sales.SalesOrderDetail103117 

SELECT * INTO Sales.SalesOrderDetail103117 
FROM Sales.SalesOrderDetail

exec sp_helpindex 'Sales.SalesOrderDetail103117'   


--create index

USE [AdventureWorks2016CTP3]
GO

CREATE CLUSTERED INDEX [ClusteredIndex-salesid] 
ON [Sales].[SalesOrderDetail103117]
([SalesOrderID] ASC)

--view index

exec sp_helpindex 'Sales.SalesOrderDetail103117'  

--view statistics based on newly created index 

SELECT s.stats_id StatsID,
s.name StatsName,
sc.stats_column_id StatsColID,
c.name ColumnName 
FROM sys.stats s 
INNER JOIN sys.stats_columns sc
ON s.object_id = sc.object_id AND s.stats_id = sc.stats_id
INNER JOIN sys.columns c
ON sc.object_id = c.object_id AND sc.column_id = c.column_id
WHERE OBJECT_NAME(s.object_id) = 'SalesOrderDetail103117'                 --<< NAME OF TABLE
ORDER BY s.stats_id, sc.column_id;

--view statistics option via GUI  auto statistics ON by default)

--deeper dive in to internals of statistics using DBCC SHOW_STATISTICS

--DBCC SHOW_STATISTICS ( table_name , STATISTIC NAME ) 

DBCC SHOW_STATISTICS ('[Person].[Person]',[IX_Person_LastName_FirstName_MiddleName]) --<< notice the date when it was last updated (NEEDS TO BE UPDATED)
GO  

--REBUILD INDEXES


DBCC SHOW_STATISTICS ('[Person].[Person]',[IX_Person_LastName_FirstName_MiddleName]) WITH HISTOGRAM;  
GO  

select count(*) from [Person].[Person]
where lastname = 'Adams'


--when execution plans are created for they are stored in the cache for faster retrieval

--to view whaat i s in the cache run this:

SELECT 
cp.plan_handle, st.text,cp.cacheobjtype
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st

--Using DBCC FREEPROCCACHE to clear ALL cache

DBCC FREEPROCCACHE

--Using DBCC FREEPROCCACHE to clear specific execution plans from the cache

--EXAMPLE: SELECT STATEMENT FOR TABLE EMPLOYEE
USE AdventureWorks2016CTP3
GO

SELECT TOP 1 * FROM HumanResources.Employee;

--RUN THE FOLLOWING QUERY TO GET SPECIFIC PLAN HANDLE

SELECT 
cp.plan_handle, st.text,cp.cacheobjtype
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
WHERE st.text LIKE N'%HumanResources.Employee%'

--THEN RUN THIS COMMAND ENTERING THE PLAN HANDLE

DBCC FREEPROCCACHE (0x06000500304A1608D05E0EFEE701000001000000000000000000000000000000000000000000000000000000);