--  USE 39 STARTer CODE for this

create table #sales(
orderMonth Date,
TotalDue money,
orderRank int
);

insert into #sales(
orderMonth ,
TotalDue ,
orderRank 
)
	SELECT 
		OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
		,TotalDue
		,OrderRank = ROW_NUMBER() OVER (
			PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC
			)
		
	FROM AdventureWorks2022.Sales.SalesOrderHeader;


-- crating top 10 table 

create table #Top10Sales(
orderMonth date,
Top10Total money
)

insert into #Top10Sales
	SELECT OrderMonth
		,Top10Total = SUM(TotalDue)

	FROM #sales
	
	WHERE OrderRank <= 10
	GROUP BY OrderMonth;


-- final query 
SELECT A.OrderMonth
	,A.Top10Total
	,PrevTop10Total = B.Top10Total
FROM #Top10Sales A
LEFT JOIN #Top10Sales B ON A.OrderMonth = DATEADD(MONTH, 1, B.OrderMonth)
ORDER BY 1;
