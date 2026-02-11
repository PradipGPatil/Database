
-- for one to one relation their si not no much adventage of exit function
--Example 1

SELECT * FROM AdventureWorks2022.Sales.SalesOrderHeader WHERE SalesOrderID = 43683

SELECT * FROM AdventureWorks2022.Sales.SalesOrderDetail WHERE SalesOrderID = 43683





--Example 2: One to many join with criteria

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2022.Sales.SalesOrderHeader A
	INNER JOIN AdventureWorks2022.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID
where b.LineTotal >10000;

-- WHERE EXISTS(
-- 	SELECT
-- 		1

-- 	FROM AdventureWorks2022.Sales.SalesOrderDetail B
	
-- 	WHERE B.LineTotal > 10000
-- 		AND A.SalesOrderID = B.SalesOrderID
-- 	)

-- ORDER BY 1





--Example 3: Using EXISTS to pick only the records we need

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2022.Sales.SalesOrderHeader A

WHERE EXISTS (
	SELECT
	1
	FROM AdventureWorks2022.Sales.SalesOrderDetail B
	WHERE A.SalesOrderID = B.SalesOrderID
		AND B.LineTotal > 10000
)

ORDER BY 1



--Example 4: exclusionary one to many join

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue
	  ,B.SalesOrderDetailID
	  ,B.LineTotal

FROM AdventureWorks2022.Sales.SalesOrderHeader A
	INNER JOIN AdventureWorks2022.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

WHERE B.LineTotal < 10000
	AND A.SalesOrderID = 43683

ORDER BY 1



--Example 5: but this doesn't even do what we want!

SELECT
*
FROM AdventureWorks2022.Sales.SalesOrderDetail

WHERE SalesOrderID = 43683

ORDER BY LineTotal DESC




--Example 6: NOT EXISTS

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2022.Sales.SalesOrderHeader A

WHERE NOT EXISTS (
	SELECT
	1
	FROM AdventureWorks2022.Sales.SalesOrderDetail B
	WHERE A.SalesOrderID = B.SalesOrderID
		AND B.LineTotal > 10000
)
	--AND A.SalesOrderID = 43683

ORDER BY 1