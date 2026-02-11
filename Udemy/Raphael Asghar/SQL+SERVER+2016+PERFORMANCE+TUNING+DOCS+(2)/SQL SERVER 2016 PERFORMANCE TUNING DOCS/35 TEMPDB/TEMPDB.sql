


--TABLES IN TEMPDB

USE tempdb
GO

CREATE TABLE #TEST3 (COL INT)

SELECT * FROM tempdb.sys.TABLES

SELECT * FROM tempdb.sys.database_files

--view the size and file growth of the tempdb

SELECT 
name AS FileName, 
size*1.0/128 AS FileSizeinMB,
CASE max_size 
WHEN 0 THEN 'Autogrowth is turned off.' 
WHEN -1 THEN 'Autogrowth is turned on.'
ELSE 'Log file will continue to grow'
END,
growth AS 'GrowthValue',
'GrowthIncrement' = 
CASE
WHEN growth = 0 THEN 'Size is fixed and will not grow.'
WHEN growth > 0 AND is_percent_growth = 0 
THEN 'Growth value is in 8-KB pages.'
ELSE 'Growth value is a percentage.'
END
FROM tempdb.sys.database_files;
GO


--changing the size of tempdb

USE [master]
GO

ALTER DATABASE [tempdb] 
MODIFY FILE ( NAME = N'tempdev', SIZE = 512000KB , FILEGROWTH = 102400KB )
GO

ALTER DATABASE [tempdb] 
MODIFY FILE ( NAME = N'templog', SIZE = 51200KB , FILEGROWTH = 102400KB )

--COUNT CPU
SELECT cpu_count,*
FROM sys.dm_os_sys_info
GO

--DETAILED LOOK INTO CPU COUNT

DECLARE @xp_msver TABLE (
[idx] [int] NULL
,[c_name] [varchar](100) NULL
,[int_val] [float] NULL
,[c_val] [varchar](128) NULL
)
 
INSERT INTO @xp_msver
EXEC ('[master]..[xp_msver]');;
 
WITH [ProcessorInfo]
AS (
SELECT ([cpu_count] / [hyperthread_ratio]) AS [number_of_physical_cpus]
,CASE
WHEN hyperthread_ratio = cpu_count
THEN cpu_count
ELSE (([cpu_count] - [hyperthread_ratio]) / ([cpu_count] / [hyperthread_ratio]))
END AS [number_of_cores_per_cpu]
,CASE
WHEN hyperthread_ratio = cpu_count
THEN cpu_count
ELSE ([cpu_count] / [hyperthread_ratio]) * (([cpu_count] - [hyperthread_ratio]) / ([cpu_count] / [hyperthread_ratio]))
END AS [total_number_of_cores]
,[cpu_count] AS [number_of_virtual_cpus]
,(
SELECT [c_val]
FROM @xp_msver
WHERE [c_name] = 'Platform'
) AS [cpu_category]
FROM [sys].[dm_os_sys_info]
)
SELECT [number_of_physical_cpus]
,[number_of_cores_per_cpu]
,[total_number_of_cores]
,[number_of_virtual_cpus]
,LTRIM(RIGHT([cpu_category], CHARINDEX('x', [cpu_category]) - 1)) AS [cpu_category]
FROM [ProcessorInfo]
GO


--add files to tempdb

USE [master]
GO

ALTER DATABASE [tempdb] 
ADD FILE ( NAME = N'tempdev2', FILENAME = N'Z:\sql data\tempdev2.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) --<< change to your path
GO

ALTER DATABASE [tempdb] 
ADD FILE ( NAME = N'tempdev3', FILENAME = N'Z:\sql data\tempdev3.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
