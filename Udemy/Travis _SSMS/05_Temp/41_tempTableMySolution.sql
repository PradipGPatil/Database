	
--Refactor your solution to the exercise from the section on CTEs (average sales/purchases minus top 10) using temp tables in place of CTEs.



SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	  into #Sales
FROM AdventureWorks2022.Sales.SalesOrderHeader



SELECT
OrderMonth,
TotalSales = SUM(TotalDue)
into #SalesMinusTop10
FROM #Sales
WHERE OrderRank > 10
GROUP BY OrderMonth



SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	  into #Purchases
FROM AdventureWorks2022.Purchasing.PurchaseOrderHeader



SELECT
OrderMonth,
TotalPurchases = SUM(TotalDue)
into #PurchasesMinusTop10
FROM #Purchases

WHERE OrderRank > 10
GROUP BY OrderMonth



SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM #SalesMinusTop10 A
	JOIN #PurchasesMinusTop10 B
		ON A.OrderMonth = B.OrderMonth

ORDER BY 1

drop table #Sales;
drop table #SalesMinusTop10;
drop table #Purchases;
drop table #PurchasesMinusTop10;
