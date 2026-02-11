-- identify top 10 sales order per month mean order which have totalDue max amount
--aggeraget this total into sum total month
--compare each total month to previous month
select 
a.ordermonth,
a.top10sum as top10total,
b.top10sum as prevtop10total

from
(select 
x.ordermonth,
top10sum=sum(TotalDue)
from 
(
select 
TotalDue,
OrderDate,
ordermonth=DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
top10record=ROW_NUMBER()over(partition by DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) order by totalDue desc)

from Sales.SalesOrderHeader) as x
where x.top10record <=10
group by x.ordermonth
) as B
left join 
(select 
ordermonth,
top10sum=sum(TotalDue)
from 
(
select 
TotalDue,
OrderDate,
ordermonth=DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
top10record=ROW_NUMBER()over(partition by DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) order by totalDue desc)

from Sales.SalesOrderHeader) as x
where x.top10record <=10
group by x.ordermonth
) as A
on A.ordermonth=DATEADD(MONTH,1,b.ordermonth)
order by a.ordermonth



with sales as (
select
TotalDue,
ordermonth=DATEFROMPARTS(year(OrderDate),MONTH(OrderDate),1),
rownumber=ROW_NUMBER()over(partition by DATEFROMPARTS(year(OrderDate),MONTH(OrderDate),1) order by totalDue desc)
from Sales.SalesOrderHeader 
),
top10Sales as (
select ordermonth,
	top10sum=sum(TotalDue)
	from sales s where s.rownumber<=10 
	group by ordermonth
)

select
	a.ordermonth,
	a.top10sum as currentTotalDue,
	b.top10sum as previoustotalDue
from top10Sales a left outer join top10Sales b on a.ordermonth=DATEADD(MONTH,1,b.ordermonth)
order by a.ordermonth;