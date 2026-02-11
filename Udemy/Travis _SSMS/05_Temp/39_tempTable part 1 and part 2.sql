
-- convert started code into the temp table

-- first way to create temp table select into
--- for insert into statment we do not have the control over the table , if we want then we can create temp table

	SELECT OrderDate
		,OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
		,TotalDue
		,OrderRank = ROW_NUMBER() OVER (
			PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC
			)
			into #sales
	FROM AdventureWorks2022.Sales.SalesOrderHeader


	SELECT OrderMonth
		,Top10Total = SUM(TotalDue)
		into #Top10Sales
	FROM #sales
	
	WHERE OrderRank <= 10
	GROUP BY OrderMonth
	
SELECT A.OrderMonth
	,A.Top10Total
	,PrevTop10Total = B.Top10Total
FROM #Top10Sales A
LEFT JOIN #Top10Sales B ON A.OrderMonth = DATEADD(MONTH, 1, B.OrderMonth)
ORDER BY 1;


-- if we try to run we will get the error 
select * from #Sales where OrderRank<7;

-- to avoid this add drop statemtn at the end of the query
-- so if we have sequence of step the drop the table
drop table #sales;
drop table #Top10Sales;