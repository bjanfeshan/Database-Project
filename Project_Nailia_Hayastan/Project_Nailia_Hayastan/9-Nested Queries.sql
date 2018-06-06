/* Create Nested queries for HayastanJan Database
Script Date: February 23, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/
use HayastanJan
;
go

/* Find all customers who bought Qyufta. Return
 their CustomerID, Name, Phone numbers and Emails. */									
 select C.CustomerID, 
	Sales.getCustomersFullName(C.CustomerFirst,C.CustomerLast) as 'Full Name',
	C.Phone, C.Email
from Sales.Customers as C
	inner join Sales.Orders as O
		on C.CustomerID = O.CustomerID
		inner join Sales.[Order Details] as OD
			on O.OrderID = OD.OrderID
where OD.ProductID in (
	select Pr.ProductID
	from Products.Products as Pr
	where Pr.ProductName = 'Deli meat-Armenian Qyufta'
	)
;
go

/*  Return orders information with the last order date for each Employee.*/			
select Sales.getCustomersFullName( E.EmpFirst, E.EmpLast) as 'Employee Name',
	O1.OrderDate as 'Order Date', O1.DeliveryDate as 'DeliveryDate',
	Sales.getCustomersFullName(C.CustomerFirst, C.CustomerLast) as 'Customer Name',
	O1.ToAddress as 'Customer Address', O1.ToCity as 'City'
from Sales.Orders as O1
	inner join HumanResourses.Employees as E
		on O1.EmpID = E.EmpID
		inner join Sales.Customers as C
			on C.CustomerID = O1.CustomerID
where O1.OrderDate = (
	select max(O2.OrderDate)
	from Sales.Orders as O2
	where O1.EmpID = O2.EmpID
	)
;
go

/* Return all home made products list, which has nuts on it’s ingredients.*/			
select Pr.ProductID as 'Product ID', Pr.ProductName  as 'Product Name' 
from Products.Products as Pr
where Pr.CategoryID = (
	select Ct.CategoryID
	from Products.Category as Ct
	where Ct.CategoryID = 5
	)
;
go

/* Return all home made meat products' list with their unit price*/					
select Pr.ProductID as 'Product ID', 
		Pr.ProductName as 'Product Name', 
		Pr.QuantityPerUnit as 'Quantity Per Unit' ,
		Pr.UnitMesure as 'Unit Measure',
		Pr.UnitPrice as 'Unit Price'
from Products.Products as Pr
where Pr.ProductName != 'Deli meat-Armenian Khorovac'
		and Pr.CategoryID = (
				select Ct.CategoryID
				from Products.Category as Ct
				where Ct.CategoryID = 3 
				)
;
go
 
 /* The price for all products which have flour in their ingredients,
 increase the unit price by 2$ */															
 select Pr.ProductName as 'Product Name', 
		Pr.UnitPrice as 'Unit Price',
		Pr.UnitPrice + 2 as 'New Unit Price' 
from Products.Products as Pr
where Pr.CategoryID in (
		select Ct.CategoryID
		from Products.Category as Ct
		where Ct.CategoryID = 4    --Category 4 is Cakes
		)
;
go

/* Return all Home made products list with their unit price*/ 			
select ProductName as 'Home Made Product Name', UnitPrice as 'Cost' 
from Products.Products 
where CategoryID in (3, 4, 5)
;
go
 

/******************** Bita ********************/
/* What percentage of products were sold at least once during last year? */
select count(OD.ProductID) as 'Total number of Products sold', 
	(	select count(P.ProductID) 
		from [Products].[Products] as P 
	) as 'Total Number of products availabl',
	round((cast(count(OD.ProductID) as float) / (	select cast(count(P.ProductID) as float) from [Products].[Products] as P )) * 100, 2)
	as 'Percentage of Products sold at least once' 
from [Sales].[Order Details] as OD
	inner join 	[Sales].[Orders] as O
		on OD.OrderID = O.OrderID
where year(O.OrderDate) = 2017

;
go