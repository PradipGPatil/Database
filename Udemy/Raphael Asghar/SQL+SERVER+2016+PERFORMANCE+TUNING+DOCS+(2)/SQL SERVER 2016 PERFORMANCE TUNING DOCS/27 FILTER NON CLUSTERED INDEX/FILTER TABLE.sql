
--DROP TABLE [AdventureWorks2016CTP3].[Person].[AddressB] 


--IMPORT DATA WITHOUT INDEXES TO VIEW SPACE USED

USE [AdventureWorks2016CTP3]
GO

SELECT *
INTO [AdventureWorks2016CTP3].[Person].[AddressB] 
FROM [AdventureWorks2016CTP3].[Person].[Address]


--PROVIDES INFO ON SPACE USED PER DB

SP_SPACEUSED


--PROVIDES INFO ON SPACE USED PER TABLE AND INDEX

SELECT s.name AS SchemaName, t.name AS TableName, p.rows AS RowCounts, 
SUM(a.total_pages) * 8 AS TotalSpaceKB, 
SUM(a.used_pages) * 8 AS UsedSpaceKB, 
(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,i.type_desc AS IndexType
FROM            sys.tables AS t INNER JOIN
sys.schemas AS s ON s.schema_id = t.schema_id INNER JOIN
sys.indexes AS i ON t.object_id = i.object_id INNER JOIN
sys.partitions AS p ON i.object_id = p.object_id AND i.index_id = p.index_id INNER JOIN
sys.allocation_units AS a ON p.partition_id = a.container_id
WHERE        (t.name NOT LIKE 'dt%') AND (t.is_ms_shipped = 0) AND (i.object_id > 255)
AND t.name = 'ADDRESSB'  --<< ADD TABLE NAME TO FILTER
GROUP BY t.name, s.name, p.rows,i.type_desc
ORDER BY SchemaName, TableName

--NOTICE THAT THIS TABLE IS A HEAP

--SchemaName	TableName	RowCounts	TotalSpaceKB	UsedSpaceKB	UnusedSpaceKB  IndexType  
--Person	    AddressB	 19614	       2904	           2752	        152           HEAP

--CREATE A CLUSTERED INDEX ON ADDRESSID AND VIEW THE CHANGE IN SPACE USED

USE [AdventureWorks2016CTP3]
GO

CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex-addressid] 
ON [Person].[AddressB]
([AddressID] ASC)

--NOTICE THAT INDEX TYPE CHANGED FROM HEAP TO CLUSTERED AND NOT EXTRA SAPCE WAS NEEDED

SELECT s.name AS SchemaName, t.name AS TableName, p.rows AS RowCounts, 
SUM(a.total_pages) * 8 AS TotalSpaceKB, 
SUM(a.used_pages) * 8 AS UsedSpaceKB, 
(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,i.type_desc AS IndexType
FROM            sys.tables AS t INNER JOIN
sys.schemas AS s ON s.schema_id = t.schema_id INNER JOIN
sys.indexes AS i ON t.object_id = i.object_id INNER JOIN
sys.partitions AS p ON i.object_id = p.object_id AND i.index_id = p.index_id INNER JOIN
sys.allocation_units AS a ON p.partition_id = a.container_id
WHERE        (t.name NOT LIKE 'dt%') AND (t.is_ms_shipped = 0) AND (i.object_id > 255)
AND t.name = 'ADDRESSB'  --<< ADD TABLE NAME TO FILTER
GROUP BY t.name, s.name, p.rows,i.type_desc
ORDER BY SchemaName, TableName

--SchemaName	TableName	RowCounts	TotalSpaceKB	UsedSpaceKB	UnusedSpaceKB  IndexType  
--Person	    AddressB	 19614	       2904	           2752	        152           HEAP    --<< CHANGED FROM HEAP TO CLUSTERED

--CREATE A FULL NON CLUSTERED INDEX ON CITY

USE [AdventureWorks2016CTP3]
GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-without_filter] 
ON [Person].[AddressB]
([City] ASC)


--REVIEW SPACE FOR BOTH CLUSTER AND NON CLUSTERED INDEX

SELECT s.name AS SchemaName, t.name AS TableName, p.rows AS RowCounts, 
SUM(a.total_pages) * 8 AS TotalSpaceKB, 
SUM(a.used_pages) * 8 AS UsedSpaceKB, 
(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,i.type_desc AS IndexType
FROM            sys.tables AS t INNER JOIN
sys.schemas AS s ON s.schema_id = t.schema_id INNER JOIN
sys.indexes AS i ON t.object_id = i.object_id INNER JOIN
sys.partitions AS p ON i.object_id = p.object_id AND i.index_id = p.index_id INNER JOIN
sys.allocation_units AS a ON p.partition_id = a.container_id
WHERE        (t.name NOT LIKE 'dt%') AND (t.is_ms_shipped = 0) AND (i.object_id > 255)
AND t.name = 'ADDRESSB'  --<< ADD TABLE NAME TO FILTER
GROUP BY t.name, s.name, p.rows,i.type_desc
ORDER BY SchemaName, TableName

--NOTICE THE EXTRA SPACE CREATED FOR THE NON CLUSTER INDEX!!!!

--SchemaName	TableName	RowCounts	TotalSpaceKB	UsedSpaceKB	UnusedSpaceKB	 IndexType
-- Person	    AddressB	  19614	       2896	           2744	       152	         CLUSTERED
-- Person	    AddressB	  19614	       712	            632     	80	         NONCLUSTERED


--CREATE A FILTER INDEX ON CITY

USE [AdventureWorks2016CTP3]
GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-FILTER_CITY] 
ON [Person].[AddressB]
([City] ASC) WHERE CITY = 'Seattle'   --<< THE WAY TO CREATE A FILTER NON CLUSTERDE INDEX IS TO ADD THE WHERE CLAUSE


--AFTER CREATING OF A FILTER

SELECT s.name AS SchemaName, t.name AS TableName, p.rows AS RowCounts, 
SUM(a.total_pages) * 8 AS TotalSpaceKB, 
SUM(a.used_pages) * 8 AS UsedSpaceKB, 
(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,i.type_desc AS IndexType
FROM            sys.tables AS t INNER JOIN
sys.schemas AS s ON s.schema_id = t.schema_id INNER JOIN
sys.indexes AS i ON t.object_id = i.object_id INNER JOIN
sys.partitions AS p ON i.object_id = p.object_id AND i.index_id = p.index_id INNER JOIN
sys.allocation_units AS a ON p.partition_id = a.container_id
WHERE        (t.name NOT LIKE 'dt%') AND (t.is_ms_shipped = 0) AND (i.object_id > 255)
AND t.name = 'ADDRESSB'  --<< ADD TABLE NAME TO FILTER
GROUP BY t.name, s.name, p.rows,i.type_desc
ORDER BY SchemaName, TableName

--SchemaName	TableName	RowCounts	TotalSpaceKB	UsedSpaceKB	UnusedSpaceKB	IndexType
--  Person	AddressB	 141	       72	            16	        56	       NONCLUSTERED     --<< FILTER
--  Person	AddressB	 19614	      2896	           2744	        152	       CLUSTERED
--  Person	AddressB	 19614	       712	            632	        80	       NONCLUSTERED


SELECT CITY
FROM [AdventureWorks2016CTP3].[Person].[AddressB] 
WHERE CITY = 'SEATTLE'

