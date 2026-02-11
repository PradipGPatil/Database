--Rewrite your solution from last video's exercise using CREATE and INSERT instead of SELECT INTO.

create table #totalSaleWithoutOutliner(
orderMonth date,
totalSale money
)

insert into #totalSaleWithoutOutliner(
	orderMonth ,
	totalSale 
)

select 
orderMonth,
totalSale=sum(totalDueRank)

from (
select
TotalDue,
orderDate,
orderMonth=DATEFROMPARTS(YEAR(orderDate),MONTH(orderDate),1),
totalDueRank=ROW_NUMBER()over(partition by DATEFROMPARTS(YEAR(orderDate),MONTH(orderDate),1) order by totalDue desc)
from Sales.SalesOrderHeader

) as s
where s.totalDueRank >10
group by orderMonth;
select * from #totalSaleWithoutOutliner

-- creating purchase order temp table

create table #totalPurchaseWithoutOutliner(
purchaseOrderMonth date,
TotalDue Money
);

insert into #totalPurchaseWithoutOutliner(
	purchaseOrderMonth ,
	TotalDue 
)
select
purchaseOrderMonth,
TotalDue=SUM(TotalDue)

from(
select  
OrderDate,
TotalDue,
purchaseOrderMonth=DATEFROMPARTS(YEAR(orderDate),MONTH(orderDate),1),
purchaseRank=ROW_NUMBER()over(partition by DATEFROMPARTS(YEAR(orderDate),MONTH(orderDate),1) order by totalDue desc )

from Purchasing.PurchaseOrderHeader) p
where p.purchaseRank > 10
group by purchaseOrderMonth;

--final query

select
TotalDue,
orderMonth
from #totalSaleWithoutOutliner s
	join #totalPurchaseWithoutOutliner p
	on s.orderMonth=p.purchaseOrderMonth;
