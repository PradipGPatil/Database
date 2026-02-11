
set statistics io on 

-- simple outer join 
SELECT 
	a.BusinessEntityID,
	a.FirstName,
	a.MiddleName,
	b.PhoneNumber
FROM Person.Person A
left join Person.PersonPhone b on b.BusinessEntityID=a.BusinessEntityID
where a.BusinessEntityID between 1 and 10



-- anoterh way to use subquery
SELECT 
	a.BusinessEntityID,
	a.FirstName,
	a.MiddleName,
	b.PhoneNumber
FROM Person.Person A
left join (
			select BusinessEntityID,PhoneNumber from Person.PersonPhone 
			) b on b.BusinessEntityID=a.BusinessEntityID
where a.BusinessEntityID between 1 and 10 

-- outer apply 
-- if we see we did see same performance
SELECT 
	a.BusinessEntityID,
	a.FirstName,
	a.MiddleName,
	b.PhoneNumber
FROM Person.Person A
outer apply (
			select BusinessEntityID,PhoneNumber  from Person.PersonPhone  b
			where b.BusinessEntityID=a.BusinessEntityID
			) b 
where a.BusinessEntityID between 1 and 10 ;


-- create the function 

create function fn_get_phoneNumber(@bussinessEntityId int)

returns table
as

return (
			select BusinessEntityID,PhoneNumber  from Person.PersonPhone  b
			where b.BusinessEntityID=@bussinessEntityId
)

-- replace inner query with function 
-- we were able to use function which is getting executed for each row and we are passing
-- bussinerss entity id and we are getting phone number
SELECT 
	a.BusinessEntityID,
	a.FirstName,
	a.MiddleName,
	b.PhoneNumber
FROM Person.Person A
outer apply  fn_get_phoneNumber (a.BusinessEntityID) b 
where a.BusinessEntityID between 1 and 10 ;

-- example 2 

select SalesOrderID,productid,LineTotal from Sales.SalesOrderDetail

select * from Sales.SalesOrderHeader;

-- now we want top 2 record for each salesorder


-- it will give only 2 record because we are selecting only 2 recond from sales order details table 
select 
* from Sales.SalesOrderHeader a
	inner join (
		select top 2 * from Sales.SalesOrderDetail b 
		) b on b.SalesOrderID=a.SalesOrderID;

-- that not we want we want to return 2 record for each sales order header 
-- so replace inner join with cross apply  , we can say inner join and cross apply are same 

select 
* from Sales.SalesOrderHeader a
	cross apply  (
		select top 2 * from Sales.SalesOrderDetail b 
		where b.SalesOrderID=a.SalesOrderID and SalesOrderID in (43659,43660)
		) b 
	order by a.SalesOrderID
-- so what happing for each saesorderHeader it join salesorderDetials top 2 
-- but in inner join we are taking top2 record and then joining this table 


-- for outer apply we take everthing from outer query (sale order header table ) .Outer apply is life left ourter join
select 
* from Sales.SalesOrderHeader a
	outer apply  (
		select top 2 * from Sales.SalesOrderDetail b 
		where b.SalesOrderID=a.SalesOrderID and SalesOrderID in (43659,43660)
		) b 
	order by a.SalesOrderID


