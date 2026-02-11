-- cte execersie
--For this exercise, assume the CEO of our fictional company decided that the top 10 orders per month
--are actually outliers that need to be clipped out of our data before doing meaningful analysis.
--Further, she would like the sum of sales AND purchases (minus these "outliers") listed side by side, by month.
--We've got a query that already does this (see the file "CTEs - Exercise Starter Code.sql" in the resources for this section), 
--but it's messy and hard to read. Re-write it using a CTE so other analysts can read and understand the code.
--Hint: You are comparing data from two different sources (sales vs purchases), so you may not be able to re-use a CTE like we did in the video.

-- top 10 orders per month

with totalSaleWithoutOutliner as(
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
group by orderMonth
)
,
totalPurchaseWithoutOutliner as (
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
group by purchaseOrderMonth)

select
TotalDue,
orderMonth
from totalSaleWithoutOutliner s
	join totalPurchaseWithoutOutliner p
	on s.orderMonth=p.purchaseOrderMonth;




