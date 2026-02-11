--Sum of line totals, grouped by ProductID AND OrderQty, in an aggregate query
select * from Sales.SalesOrderDetail;

SELECT
	ProductID,
	OrderQty,
	LineTotal = SUM(LineTotal)

FROM AdventureWorks2022.Sales.SalesOrderDetail

GROUP BY
	ProductID,
	OrderQty

ORDER BY 1,2 DESC



--Sum of line totals via OVER with PARTITION BY

SELECT
	ProductID,
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	UnitPrice,
	UnitPriceDiscount,
	LineTotal,
	ProductIDLineTotal = SUM(LineTotal) OVER(PARTITION BY ProductID, OrderQty)

FROM AdventureWorks2022.Sales.SalesOrderDetail

ORDER BY 1, 4 DESC;


