SELECT *
FROM sys.dm_tran_locks


SELECT resource_type, request_mode, resource_description
FROM sys.dm_tran_locks






--resource_type = Displays a resource where the locks are being acquired.  
--ALLOCATION_UNIT, 
--APPLICATION, 
--DATABASE, 
--EXTENT, 
--FILE, 
--HOBT, 
--METADATA, 
--OBJECT, 
--PAGE, 
--KEY, 
--RID 

--request_mode = displays the lock mode

--resource_description – displays a short resource description of the column contains the id of the row, page, object, file, etc 
