-- Re-write the query in the "An Improved EXISTS With UPDATE - Exercise Starter Code.sql" file (you can find the file in the Resources for this section), 
-- using temp tables and UPDATE statements instead of EXISTS.

-- In addition to the three columns in the original query, you should also include a fourth column called "RejectedQty", 
-- which has one value for rejected quantity from the Purchasing.PurchaseOrderDetail table.


SELECT
       A.PurchaseOrderID,
	   A.OrderDate,
	   A.TotalDue

FROM AdventureWorks2022.Purchasing.PurchaseOrderHeader A

WHERE EXISTS (
	SELECT
	1
	FROM AdventureWorks2022.Purchasing.PurchaseOrderDetail B
	WHERE A.PurchaseOrderID = B.PurchaseOrderID
		AND B.RejectedQty > 5
)

ORDER BY 1



