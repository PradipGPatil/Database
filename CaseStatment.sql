-- simple expression

select  
ProductNumber,
case productline
when 'm' then 'mountain'
when  'r' then 'road'
end 
from Production.Product order by ProductNumber;

-- search case
select
ProductNumber,
listprice,
case 
when ListPrice=0 then 'product not for sale'
when ListPrice<50 then 'product price less than 50'
when ListPrice >50 and ListPrice<100 then 'product price between 50 and 100'
else 'product price more than 100'
end as productPriceDescription
from Production.Product order by ProductNumber;

-- case in order by 

select 
BusinessEntityID,
SalariedFlag
from HumanResources.Employee
order by 
case SalariedFlag
when 1 then BusinessEntityID
end desc,
case when SalariedFlag=0 then BusinessEntityID
end;


select 
BusinessEntityID,
LastName,
TerritoryName,
CountryRegionName
from Sales.vSalesPerson
where TerritoryName  is not null
order by 
case
CountryRegionName
when 'united States' then TerritoryName
else CountryRegionName
end;

-- case statement in having cause
select 
JobTitle,
max(Rate) as maximumRate
FROM HumanResources.Employee e
join HumanResources.EmployeePayHistory p on e.BusinessEntityID=p.BusinessEntityID
group by JobTitle
having (
max(
case 
when SalariedFlag=1 then p.Rate
else null
end
) >40.00
or
max(
case 
when SalariedFlag=0 then p.rate
else null
end
)>15

)

order by maximumRate desc
;
