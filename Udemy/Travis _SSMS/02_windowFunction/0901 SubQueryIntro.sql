--Selecting the most expensive item per order in a single query

SELECT
*
FROM
(
SELECT
SalesOrderID,
SalesOrderDetailID,
LineTotal,
LineTotalRanking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)

FROM AdventureWorks2022.Sales.SalesOrderDetail
-- in this example we have give row number 1,2,3 like that base on line Total 
-- but we can not able to use window function in where clause

) A

WHERE LineTotalRanking = 1
