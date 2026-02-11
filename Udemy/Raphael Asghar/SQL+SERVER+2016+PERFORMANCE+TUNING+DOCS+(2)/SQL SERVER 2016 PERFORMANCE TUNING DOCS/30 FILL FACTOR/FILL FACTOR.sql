
--Fill Factor at the server level: 
--(RC) SERVER GO TO DATABASE SETTINGS

USE AdventureWorks2016CTP3
GO

SELECT *
FROM sys.configurations
WHERE name ='fill factor (%)'

--SCRIPT TO CHANGE THE FILL FACTOR AT SERVER LEVEL

EXEC sys.sp_configure N'show advanced options', N'1'  
RECONFIGURE WITH OVERRIDE
GO

EXEC sys.sp_configure N'fill factor (%)', N'80'   --<< CHANGING AT THE SERVER LEVEL FILL FACTOR FROM 100 TO 50
GO

RECONFIGURE WITH OVERRIDE
GO

EXEC sys.sp_configure N'show advanced options', N'0'  
RECONFIGURE WITH OVERRIDE
GO


--Fill Factor at the index level: 
--GO TO INDEX (RC) SEE FILL FACTOR

USE AdventureWorks2016CTP3
GO

SELECT OBJECT_NAME(OBJECT_ID) Name, type_desc, fill_factor
FROM sys.indexes
WHERE NAME = 'AK_SalesOrderDetail_rowguid'


--SCRIPT TO CHANGE THE FILL FACTOR AT INDEX LEVEL -- COULD TAKE A LONG TIME

USE [AdventureWorks2016CTP3]
GO

ALTER INDEX [AK_SalesOrderDetail_rowguid] 
ON [Sales].[SalesOrderDetail] 
REBUILD PARTITION = ALL 
WITH (PAD_INDEX = OFF, 
STATISTICS_NORECOMPUTE = OFF, 
SORT_IN_TEMPDB = OFF, 
IGNORE_DUP_KEY = OFF, 
ONLINE = OFF, 
ALLOW_ROW_LOCKS = ON, 
ALLOW_PAGE_LOCKS = ON, 
FILLFACTOR = 85)

GO


