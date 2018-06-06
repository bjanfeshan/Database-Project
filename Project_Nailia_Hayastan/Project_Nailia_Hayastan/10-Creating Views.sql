/* Create Views for HayastanJan Database
Script Date: February 23, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/
use HayastanJan
;
go

/* Create view Products.CostOfPurchaseView which returns Cost of Purchase(using Products.getPurchaseTotalFn function) and all
necessary fields to see supplliers, product name, quantity of purchasing products, its price and purchase date*/
create view Products.CostOfPurchaseView
as 
	select Pr.PurchaseID,
		S.CompanyName,
		P.ProductName,
		Pr.Quantity,
		P.UnitPrice,
		Products.getPurchaseTotalFn
		(
			Pr.Quantity,
			P.[UnitPrice]
		) as 'Cost of Purchase',
		Pr.PurchaseDate
 from [Products].[Suppliers] as S
		inner join Products.Products as P
			on S.SupplierID = P.SupplierID
		inner join Products.Purchase as Pr
			on P.SupplierID = Pr.SupplierID
;
go
		--Testing CostOfPurchaseView
/* returns Cost of Purchase in 2017 */
select *
from Products.CostOfPurchaseView
where year(PurchaseDate) = '2017'
;
go  

/*Return Cost of Purchases in January 2015 (using CostOfPurchaseView) */				
select *
from Products.CostOfPurchaseView
where year(PurchaseDate) = 2015 and month(PurchaseDate) = 01
;
go

 /* Create a view which calculate Total Sales of each month (with using Sales.ProductPriceFn function) */
create view Sales.TotalSalesPerMonthView
as
select year(O.OrderDate) as 'SalesYear',
	month(O.OrderDate) as 'SalesMonth',
	round(sum( Sales.ProductPriceFn(O.OrderID)),0) as 'Total Sale'
from [Sales].[Order Details] as OD
	inner join Sales.Orders as O
		on O.OrderID = OD.OrderID
group by YEAR(O.OrderDate), MONTH(O.OrderDate)
;
go

		--Testing TotalSalesPerMonthView
select *
from Sales.TotalSalesPerMonthView
where SalesYear = '2017'
;
go

/*  Find 3 months with highest Sales in 2017 (Peak sales months)  */								
select top(3) [Total Sale], SalesMonth, SalesYear 
from Sales.TotalSalesPerMonthView
where SalesYear = '2017'
order by [Total Sale] desc
;
go

/* Find the average of sales for 2017 */
select round((sum([Total Sale])/count(SalesMonth)),0) as 'Average sale in 2017'
from Sales.TotalSalesPerMonthView
where SalesYear = '2017'
;
go

/* Find the sale per each month in 2017 by Product names */
select year(O.[OrderDate]) as 'Year',
	month(O.[OrderDate]) as 'Month',
	OD.[ProductID], 
	P.[ProductName], 
	(OD.Quantity * OD.SellingPrice *(1-IsNull(OD.Discount, 0))) as 'Sale $'
from [Sales].[Order Details] as OD
	inner join [Products].[Products] as P
	on OD.ProductID = P.ProductID
	inner join Sales.Orders as O
	on OD.OrderID = O.OrderID
where year(O.[OrderDate]) = '2017'
;
go

/* Create a view which calculate the Profit of Company in 2017. 
(Use Sales.TotalSalesPerMonthView and Products.getPurchaseTotalFn)  */
create view Sales.Profit2017View
as
select sum([Total Sale])-(select sum([Cost of Purchase])
	from Products.CostOfPurchaseView
	where year(PurchaseDate) = '2017') as 'Profit 2017'
from Sales.TotalSalesPerMonthView
where SalesYear = '2017'
;
go
--Testing Profit2017View
select *
from Sales.Profit2017View
;
go

/* Create a view which return the percentage of the Customers who placed an order at least once.*/
create view Sales.getCustomersOrderedView
as
	select O.CustomerID, count(O.CustomerID) as 'Orders Quantity '		 
	from Sales.Orders as O	
	group by O.CustomerID	
;
go
		--Testing getCustomersOrderedView
select count(V.CustomerID)*100/count(C.CustomerID) as 'Percentage of customers ordered'
from Sales.Customers as C
	left outer join Sales.getCustomersOrderedView as V
		on C.CustomerID = V.CustomerID	
;
go

/*  Create an employee view that returns list of employees with their full name, employee number and title */
create view HumanResourses.EmployeeView
as
	select E.EmpID, concat(E.EmpFirst, ' ', E.EmpLast) as 'Employee Name', P.Title 
	from [HumanResourses].[Employees] as E
		inner join HumanResourses.Position as P
		on P.PositionID = E.PositionID
 ;
 go
select *
from HumanResourses.EmployeeView
;
go

/*  Return the list of suppliers who supplys more products? */				
create view Products.SupplyView
as
	select S.SupplierID,
		S.CompanyName as 'Company Name', 
		count(P.Quantity) as 'Quantity'
		from Products.Suppliers as S
			inner join Products.Purchase as P			 
				on P.SupplierID = S.SupplierID
	group by S.SupplierID, S.CompanyName 	
;
go
		--Testing SupplyView
select *
from Products.SupplyView
order by 'Quantity' desc
;
go

/* Create a view for Total cost of each order before taxes and delivery */
create view Sales.OrderTotalView
as 
select OrderID, Sales.ProductPriceFn(OrderID) as 'Total Price of Each Order'
from [Sales].[Order Details] as OD
group by OrderID
;
go

-- Test Sales.OrderTotalView
select *
 from Sales.OrderTotalView
 --where OrderID = 3
 ;
 go

/* Create a view that shows a customer address based on her/his Order ID */
create view Sales.CustomerOrderAddressView
as 
select O.CustomerID as 'Customer ID', Concat(C.[CustomerFirst], ' ', C.[CustomerLast]) as 'Customer Name', 
	O.OrderID as 'Oreder ID', Sales.DeliveryAddressFn(O.OrderID) as 'Delivery Address'
from [Sales].[Orders] as O
	inner join [Sales].[Customers] as C
		on O.CustomerID = C.CustomerID																									--????
;
go

-- test the CustomerOrderAddressView
select *
from Sales.CustomerOrderAddressView
where [Oreder ID] = 2
;
go








