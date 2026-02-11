--Step 1

		  SELECT
		  COUNT(*)
		  FROM adventureWorks.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659



--Step 2:

		  SELECT
		  *
		  FROM adventureWorks.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659

--Step 3:

		  SELECT
		  LineTotal
		  FROM adventureWorks.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659


--Step 4:

		  SELECT
		  LineTotal
		  FROM adventureWorks.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659
		  FOR XML PATH('')

--Step 5:

		  SELECT
		  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
		  FROM adventureWorks.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659
		  FOR XML PATH('')

--Step 6:

SELECT
	STUFF(
		  (
			  SELECT
			  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
			  FROM adventureWorks.Sales.SalesOrderDetail A
			  WHERE A.SalesOrderID = 43659
			  FOR XML PATH('')
		  ),
		  1,1,'I''m stuffed!')



--Step 7:

SELECT 
       SalesOrderID
      ,OrderDate
      ,SubTotal
      ,TaxAmt
      ,Freight
      ,TotalDue
	  ,LineTotals = 
		STUFF(
			  (
				  SELECT
				  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
				  FROM adventureWorks.Sales.SalesOrderDetail B
				  WHERE A.SalesOrderID = B.SalesOrderID 
				  FOR XML PATH('')
			  ),
			  1,1,''
		  )

FROM adventureWorks.Sales.SalesOrderHeader A

