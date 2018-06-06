/* Manipulate Data into HayastanJan Database
Script Date: February 23, 2018
Developed by: Shushan, Bita, Nailia, Yohannes
*/
use HayastanJan
;
go

/* Create a query that shows the products that have not been appeared in a order (OrderID = null) */
select P.ProductID, P.ProductName, OD.OrderID
from [Products].[Products] as P
	left outer join [Sales].[Order Details] as OD
	on P.ProductID = OD.ProductID
where OD.OrderID is null
;
go

/* Create a query that shows a list of employess who have not taken an order */
select E.EmpID, Concat(E.[EmpFirst], ' ', E.[EmpLast]) as 'Employee Name', O.OrderID 
from [HumanResourses].[Employees] as E 
	left outer join [Sales].[Orders] as O
	on  O.EmpID =  E.EmpID
where  OrderID is null	
;
go

/* Create a query for calculating the grand total of each order after addeing tax and delivery 
cost to total cost of each order */
select  [RequireDelivery] * Isnull([DeliveryCost], 0) as 'Sum of Delivery', Sales.ProductPriceFn(OrderID) as 'Order Total',
	[RequireDelivery] * Isnull([DeliveryCost], 0) + Sales.ProductPriceFn(OrderID) as 'Total Cost of an Order'
from [Sales].[Orders]
;
go

/*Return Cost of Purchases in January 2015 (using CostOfPurchaseView) */				
select *
from Products.CostOfPurchaseView
where year(PurchaseDate) = 2015 and month(PurchaseDate) = 01
;
go

/* How many orders were placed in 2017?  */					

select count(O.OrderID) as 'Total Quantity in 2017'
from Sales.Orders as O
where year(O.OrderDate) = 2017
;
go

/*  How many products of each product name were sold in 2017?  */
select P.ProductName as 'Product Name',
		sum(OD.Quantity) as 'Quantity'
from Products.Products as P
	inner join Sales.[Order Details] as OD
		on OD.ProductID = P.ProductID
		inner join Sales.Orders as O
			on OD.OrderID = O.OrderID
where year(O.OrderDate) = 2017
group by P.ProductName
order by 'Quantity' desc
;
go

/* Which products are required to be ordered today? */
select ProductName, Reorderlevel, UnitsInStock
from Products.Products
where UnitsInStock <= Reorderlevel and Discontinued = 0
;
go

/* What is the current quantity of each product in stock? */
select ProductID, ProductName, UnitMesure, UnitsInStock as 'Quantity In stock'								 
from Products.Products
where Discontinued = 0
;
go

/* Create a list of sold products, name and quantity by ascending order. */				
select P.ProductName as 'Sold Product name', 
		sum(OD.Quantity) as 'Quantity'
from Sales.[Order Details] as OD
	inner join Products.Products as P 
		on OD.ProductID = P.ProductID
group by P.ProductName
order by 'Quantity' asc
;
go

/* How many orders were taken by each Employee (descending order)? */						
select concat(E.EmpFirst, ' ', E.EmpLast) as 'Employee Name', count (O.OrderID) as 'Quantity of Orders' 
from HumanResourses.Employees as E
	inner join Sales.Orders as O
		on O.EmpID = E.EmpID
group by  E.EmpFirst, E.EmpLast 
;
go

/* How many products of each product name were bought in 2017? */						
select P.ProductName as 'Product Name', sum (Pr.Quantity) as 'Purchased Quantity'
from Products.Products as P
	inner join Products.Purchase as Pr
		on P.ProductID = Pr.ProductID
where year(Pr.PurchaseDate) = 2017
group by P.ProductName 
;
go