/* XML FOR in Hajastan Jan database
Script Date: February 28, 2018
Develped by: Nailia,Shushan,Bita and Yohannes
*/

use Hayastanjan
;
go

/* retrieve information from the Sales.Customer table using FOR XML clause in RAW Mode */
select C.CustomerID, concat(C.[CustomerFirst], ' ', [CustomerLast]) as 'Customer Name', O.OrderID
from Sales.Customers as C
	inner join Sales.Orders as O
		on C.CustomerID = O.CustomerID
for xml auto
;
go

/* using ELEMENTS option */
select C.CustomerID, concat(C.[CustomerFirst], ' ', [CustomerLast]) as 'Customer Name', O.OrderID
from Sales.Customers as C
	inner join Sales.Orders as O
		on C.CustomerID = O.CustomerID
for xml auto, elements
;
go

/* using ELEMENTS and root option */
select C.CustomerID, concat(C.[CustomerFirst], ' ', [CustomerLast]) as 'Customer Name', O.OrderID
from Sales.Customers as C
	inner join Sales.Orders as O
		on C.CustomerID = O.CustomerID
for xml auto, elements, root('Customers')
;
go