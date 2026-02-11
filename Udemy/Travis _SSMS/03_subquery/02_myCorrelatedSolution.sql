--Exercise 1
--Write a query that outputs all records from the Purchasing.PurchaseOrderHeader table. Include the following columns from the table:
--PurchaseOrderID
--VendorID
--OrderDate
--TotalDue
--Add a derived column called NonRejectedItems which returns, for each purchase order ID in the query output, 
--the number of line items from the Purchasing.PurchaseOrderDetail table which did not have any rejections 
--(i.e., RejectedQty = 0). Use a correlated subquery to do this.

select 
poh.PurchaseOrderID,
poh.VendorID,
poh.OrderDate,
poh.TotalDue,
nonRejectedItems=
(
select  count(*)
from Purchasing.PurchaseOrderDetail as pod
where pod.PurchaseOrderID=poh.PurchaseOrderID and pod.RejectedQty=0
)

from Purchasing.PurchaseOrderHeader as poh;
select * from Purchasing.PurchaseOrderHeader;
select * from Purchasing.PurchaseOrderDetail order by PurchaseOrderID;


--Exercise 2
--Modify your query to include a second derived field called MostExpensiveItem.
--This field should return, for each purchase order ID, the UnitPrice of the most expensive item for that order 
--in the Purchasing.PurchaseOrderDetail table.
--Use a correlated subquery to do this as well.
--Hint: Think of the most appropriate aggregate function to use in the correlated subquery for this scenario.

select 
poh.PurchaseOrderID,
poh.VendorID,
poh.OrderDate,
poh.TotalDue,
nonRejectedItems=
(
select  count(*)
from Purchasing.PurchaseOrderDetail as pod
where pod.PurchaseOrderID=poh.PurchaseOrderID and pod.RejectedQty=0
),
mostExpensiveItem=(
select 
max(pod.UnitPrice)
from Purchasing.PurchaseOrderDetail as pod
where pod.PurchaseOrderID=poh.PurchaseOrderID
)

from Purchasing.PurchaseOrderHeader as poh;