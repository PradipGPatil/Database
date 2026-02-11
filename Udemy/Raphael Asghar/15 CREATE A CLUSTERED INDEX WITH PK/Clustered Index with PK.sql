
--Creating a table without a clustered index is called a heap. As such, insertion of data will be inserted
--at the next available slot (row)

USE IndexDB
GO

Create table Orders
(
--Orderid int primary key,  --<< when you use a primary key constraint, you automatically creaet a clustered index!
Orderid int, 
Orders varchar (20),
Cost varchar (20))


--Insert data into table without a clustered index. Note that i am inserting data orderid in a non sequential order: 5,2,4,1,3

USE IndexDB
GO

Insert into Orders
values (5,'book','5.00'),(2,'watch','24.00'),(4,'glasses','10.00'),(1,'laptop','100.00'),(3,'monitor','55.00')

--Notice the data is NOT sequential 

select * from Orders

--If i insert another row, the data will be placed at the next available row - as its not indexed

USE IndexDB
GO

Insert into Orders
values (6,'pen','2.00')

select * from Orders

--now i will drop the table and recreate the same table, but this time adding the primary key constraint. Notice that when adding the PK, the data is sorted automatically

drop table Orders


USE IndexDB
GO

Create table Orders
(
Orderid int primary key,  --<< when you use a primary key constraint, you automatically create a clustered index!
Orders varchar (20),
Cost varchar (20))

select * from Orders


USE IndexDB
GO

Insert into Orders
values (5,'book','5.00'),(2,'watch','24.00'),(4,'glasses','10.00'),(1,'laptop','100.00'),(3,'monitor','55.00')

select * from Orders

USE IndexDB
GO

Insert into Orders
values (6,'pen','2.00')
