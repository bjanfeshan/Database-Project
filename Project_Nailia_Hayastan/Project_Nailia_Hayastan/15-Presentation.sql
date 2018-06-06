/* HayastanJan Database
Script Date: February 26, 2018
Developed by: Shushan, Bita, Nailia, Yohannes
*/
use HayastanJan
;
go
					/************Nailia*****************/

/*Create User-deifened data type for Address*/
 create type myAddress
 from nvarchar(60) not null
 ;
 go

					/*******Queries***********/

 /* What is the current quantity of each product in stock? */
select ProductID, ProductName, UnitMesure, UnitsInStock as 'Quantity In stock'								 
from Products.Products
where Discontinued = 0
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
			/*****Nested Queries********/
/* Return orders information with the last order date for each Employee.*/			
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
			/***********Views************/
/* 1. Create an employee view that returns list of employees with their full name, employee number and title */
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

/* 2. Return the list of suppliers who supplys more products? */				
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

select *
from Products.SupplyView
order by 'Quantity' desc
;
go
			/***********Function*************/

/* Create a function which returns Total cost of Purchase*/
if OBJECT_ID('Products.getPurchaseTotalFn', 'Fn') is not null
  drop function Products.getPurchaseTotalFn
  ;
  go

  create function Products.getPurchaseTotalFn
  (
	--declare a parameter
	@Quantity as int,
	@UnitPrice as money
  )
  returns money
  as 
	begin
		--declare the return variable
		declare @Purchase as money
		--compute the return value
		select @Purchase = @Quantity*@UnitPrice
		-- return the result to the function caller
		return @Purchase
	end
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
			P.UnitPrice
		) as 'Cost of Purchase',
		Pr.PurchaseDate
 from [Products].[Suppliers] as S
		inner join Products.Products as P
			on S.SupplierID = P.SupplierID
		inner join Products.Purchase as Pr
			on P.SupplierID = Pr.SupplierID
;
go

select *
from Products.CostOfPurchaseView
;
go  

/*Return Cost of Purchases in January 2015 (using CostOfPurchaseView) */				
select *
from Products.CostOfPurchaseView
where year(PurchaseDate) = 2015 and month(PurchaseDate) = 01
;
go
			/******12-Import images Store-Orocedure**************/
					/************Triggers*************/
/* Create a trigger notifyEmployeeTR, that prints a message when anyone modifies or inserts data in the HumanResourses.Employees */

/*check if the trigger exists */
If OBJECT_ID('HumanResourses.Employees', 'Tr') is not null
	drop trigger HumanResourses.notifyEmployeeTR
;
go

create trigger HumanResourses.notifyEmployeeTR
 on HumanResourses.Employees
 after update, insert
 as
	raiserror('Table HumanResourses.Employees was modified', 16, 10)
;
go
		/* testing the trigger HumanResourses.notifyEmployeeTR */
/* modify the employee name from Lea Steinhaus to Epraxiya Martirosyan, for the Employee Id 9 */
select *
from HumanResourses.EmployeeView
where EmpID = 9
;
go

update HumanResourses.Employees
set EmpFirst = 'Epraxiya', EmpLast = 'Martirosyan'
where EmpID = 9
;
go
/*********************************************************************************************************************************/
			/******************Shushan*****************/
			  /************* Manipulate Data ********/
/* Task 2:  How many products of each product name were sold in 2017?  */
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

/*Task 3: Which products are required to be ordered today? */
select ProductName, Reorderlevel, UnitsInStock
from Products.Products
where UnitsInStock <= Reorderlevel and Discontinued = 0
;
go

/*Task 8: How many products of each product name were bought in 2017? */						
select P.ProductName as 'Product Name', sum (Pr.Quantity) as 'Purchased Quantity'
from Products.Products as P
	inner join Products.Purchase as Pr
		on P.ProductID = Pr.ProductID
where year(Pr.PurchaseDate) = 2017
group by P.ProductName 
;
go

/*****************Sub Queries **********/
/*Task 1: Find all customers who bought Qyufta. Return
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

 /*Task 5: The price for all products which have flour in their ingredients,
 increase the unit price by 2$ */															
 select Pr.ProductName as 'Product Name', 
		Pr.UnitPrice as 'Unit Price',
		Pr.UnitPrice + 2 as 'New Unit Price' 
from Products.Products as Pr
where Pr.CategoryID in (
		select Ct.CategoryID
		from Products.Category as Ct
		where Ct.CategoryID = 4  
		)
;
go

/*Task 6: Return all Home made products list with their unit price*/ 			
select ProductName as 'Home Made Product Name', UnitPrice as 'Cost' 
from Products.Products 
where CategoryID in (3, 4, 5)
;
go
 
/********************User Defined Store Procedures *******/

/*Task 1: Create a procedure, Products.getAllAvailableProductsSP.  
 Include ProductName, Quantity Per Unit, Unit Measure, Unit Price and Quantity in stock */
 create procedure Products.getAllAvailableProductsSP
 as
	begin
		select P.ProductName as 'Product Name', P.QuantityPerUnit as 'Quantity Per Unit',
				P.UnitMesure as 'Unit Measure', P.UnitPrice, P.UnitsInStock as 'Available Quantity' 
		from Products.Products as P
			inner join Products.Category C
				on P.CategoryID = C.CategoryID
		where Discontinued = 0 and C.CategoryID != 1
	end
;
go

/* Call the procedure Products.getAllAvailableProductsSP */
exec Products.getAllAvailableProductsSP
;
go

/* Task 2: Create a procedure HumanResourses.getAllEmployeesStageSP to find Employee,
	who is working more then one year.Include Employee Full name, Title and Seniority (Number of years) */ 
create procedure HumanResourses.getAllEmployeesStageSP
as 
	begin 
		select Sales.getCustomersFullName(E.EmpFirst, E.EmpLast) as 'Employee Name',
			P.Title, E.StartDate, E.EndDate, datediff(year,E.StartDate, GETDATE()) as 'Stage'
		from HumanResourses.Employees as E
			inner join HumanResourses.Position as P
				on E.PositionID = P.PositionID
		where E.EndDate is Null or year(E.EndDate)> year(getdate())  
	end
;
go

/* Call the procedure HumanResourses.getAllEmployeesStageSP */
exec HumanResourses.getAllEmployeesStageSP
;
go

/* Task 3: Create a procedure Products.getProductsBySuppliersSP to get a list 
	of products by SupplierName. Include Supplier Name, Product Name, Cost and Category*/        
create procedure Products.getProductsBySuppliersSP
	(
		@SupplierName as nvarchar(30)
	)
as
	begin
		select S.CompanyName as 'Supplier Name', P.ProductName as 'Product Name',
			P.UnitPrice, C.CategoryName as 'Category'
		from Products.Products as P
			inner join Products.Suppliers as S
				on S.SupplierID = P.SupplierID
				inner join Products.Category as C
					on P.CategoryID = C.CategoryID
				where S.CompanyName = @SupplierName
	end
;
go

/* Call the procedure Products.getProductsBySuppliersSP */
exec Products.getProductsBySuppliersSP 'AFD.Co'
;
go

/*Task 4: Create a procedure Products.ListProductsSP which will find all   
products, which Unit Price exceeding a specified amount */
create procedure Products.ListProductsSP
(
	@MaxPrice as money	
)
as
	begin 
		select ProductName as 'Product Name', UnitPrice as 'Unit Price'	
		from Products.Products
		where UnitPrice > @MaxPrice 
	end
;
go

/* Call the procedure Products.ListProductsSP */
exec Products.ListProductsSP '5'
;
go

/* Task 5: Create Procedure Products.getOrderProductsList that finds 
all products, which we sold more than a specified quantity */
create procedure Products.getOrderProductsList
(
	@SalesQuantity as int
)
as
	begin 
		select Pr.ProductName as 'Product Name', Pr.UnitPrice as 'Unit Price', sum(OD.Quantity) as
		'Total Quantity Sold'
		from Products.Products as Pr
			 inner join Sales.[Order Details] as OD
				on Pr.ProductID = OD.ProductID
		group by Pr.ProductName, Pr.UnitPrice
		having sum(OD.Quantity) > @SalesQuantity 
	end
;
go

/* Call the procedure Products.getOrderProductsList */
exec Products.getOrderProductsList '3'
;
go

/***************************triggers***************************/
/*Create the trigger CheckModifiedDateTr, that checks the modified date and if phone
	number is missing it will write the comment, that Company has not number */
if OBJECT_ID('dbo.CheckModifiedDataTr', 'Tr') is not null
	drop trigger dbo.CheckModifiedDataTr
;
go

create trigger Sales.CheckModifiedDataTr
on Sales.DeliverVia
for insert, update
as
	begin
		-- declare variable
		declare @CompanyName as nvarchar(60),
		@Phone as nvarchar(24)
		-- compute return value
		select @CompanyName = CompanyName,
				@Phone = Phone
		from inserted
		-- making decision
		if (@Phone is null)
			begin
				-- set modified date to the current date
				update Sales.DeliverVia
				set Phone = 'Has not Phone Number'
				where CompanyName = @CompanyName
				print '***No Phone Number is provided ***'
			end

	end
;
go

/*testing the trigger checkModifiedDateTr*/
insert into Sales.DeliverVia(CompanyName, Phone)
values ('Marselo', '514-228-4523')
;
go

insert into Sales.DeliverVia(CompanyName)
values ('Express')
;
go
/**********************************************************************************************************************************/
		/**************Yohannese*****************/
		/************* Manipulate Data ********/
 /* Task 1: How many orders were placed in 2017?  */					

select count(O.OrderID) as 'Total Quantity in 2017'
from Sales.Orders as O
where year(O.OrderDate) = 2017
;
go

/*Task 6: Create a list of sold products, name and quantity by ascending order. */				
select P.ProductName as 'Sold Product name', 
		sum(OD.Quantity) as 'Quantity'
from Sales.[Order Details] as OD
	inner join Products.Products as P 
		on OD.ProductID = P.ProductID
group by P.ProductName
order by 'Quantity' asc
;
go

/*****************Sub Queries **********/
/*Task 3: Return all home made products list, which has nuts on it’s ingredients.*/			
select Pr.ProductID as 'Product ID', Pr.ProductName  as 'Product Name' 
from Products.Products as Pr
where Pr.CategoryID = (
	select Ct.CategoryID
	from Products.Category as Ct
	where Ct.CategoryID = 5
	)
;
go
/**********************************************************************************************************************************/		
				/******************Bita******************/
			/******************* Functions *******************/
/* Create a function that calculates the cost of each product in an 
	order (total of each row in Order Details) */

IF OBJECT_ID ('Sales.ProductPriceFn', 'Fn') IS NOT NULL  
    DROP FUNCTION Sales.ProductPriceFn;  
GO  

create function Sales.ProductPriceFn
	(
	 @OrderID int
	 )	 
Returns real 
as 
	begin
		declare @Price money			
			select @Price = sum( Quantity * SellingPrice *(1-IsNull(Discount, 0)))
			from [Sales].[Order Details]
			where OrderID = @OrderID			
		return @Price
	end
;
go

-- Test Sales.ProductPriceFn Function
select OrderID, Sales.ProductPriceFn(OrderID) as 'Total Price of Each Order'
from [Sales].[Order Details]
group by OrderID
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

select *
from [Sales].[Order Details]
;
go

/* Create a query for calculating the grand total of each order after addeing tax and delivery 
cost to total cost of each order */
select  [RequireDelivery] * Isnull([DeliveryCost], 0) as 'Sum of Delivery', Sales.ProductPriceFn(OrderID) as 'Order Total',
	[RequireDelivery] * Isnull([DeliveryCost], 0) + Sales.ProductPriceFn(OrderID) as 'Total Cost of an Order'
from [Sales].[Orders]
;
go

select *
from [Sales].[Orders]
;
go

/* Create a function that creates the full delivery address for each orderID */
create function Sales.DeliveryAddressFn
	(
	 @OrderID int
	 )	 
Returns nvarchar(250) 
as 
	begin
		declare @FullDeliveryAddress nvarchar(250)		
			select @FullDeliveryAddress = concat([ToAddress], ' ', [ToCity], ' ', [ToProvince], 
												' ', [PostalCode], ' ', [ToCountry])
			from [Sales].[Orders]
			where OrderID = @OrderID			
		return @FullDeliveryAddress
	end
;
go

-- test function Sales.DeliveryAddressFn
select O.CustomerID as 'Customer ID', Concat(C.[CustomerFirst], ' ', C.[CustomerLast]) as 'Customer Name', 
	O.OrderID as 'Oreder ID', Sales.DeliveryAddressFn(O.OrderID) as 'Deliver Address'
from [Sales].[Orders] as O
	inner join [Sales].[Customers] as C
		on O.CustomerID = C.CustomerID
where OrderID = 2
;
go

/* Create a view that shows a customer address based on her/his Order ID */
create view Sales.CustomerOrderAddressView
as 
select O.CustomerID as 'Customer ID', Concat(C.[CustomerFirst], ' ', C.[CustomerLast]) as 'Customer Name', 
	O.OrderID as 'Oreder ID', Sales.DeliveryAddressFn(O.OrderID) as 'Delivery Address'
from [Sales].[Orders] as O
	inner join [Sales].[Customers] as C
		on O.CustomerID = C.CustomerID
where OrderID = 2
;
go

-- test the CustomerOrderAddressView
select *
from Sales.CustomerOrderAddressView
;
go

/* Create a table valued function that returns all Products that has unit price more than a 
certain amount */
create function Sales.ProductPriceMoreThanFn(@UnitPrice money)
returns table
as 
return
	select ProductID, SellingPrice
	from [Sales].[Order Details]
	where SellingPrice > @UnitPrice
;
go

-- Test function Sales.ProductPriceMoreThanFn(@UnitPrice money)
select PP.ProductID, PP.SellingPrice
from Sales.ProductPriceMoreThanFn(11.00) as PP
	inner join [Sales].[Order Details] as OD
		on PP.ProductID = OD.ProductID
;
go

/******************* Triggers *******************/
create trigger Products.ReordeLevelReachedTr
on [Products].[Products]
for update
as 
	begin
		-- declare variables
		declare @ProductID as int,
				@UnitsInStock as decimal,
				@ReorderLevel as smallint
		-- compute return value
		select @UnitsInStock = UnitsInStock,
			   @ReorderLevel = Reorderlevel
		from inserted
		-- making decision

		if @UnitsInStock <= @ReorderLevel
		begin
			-- set modified date to the current date
			
			print '***** Reorder Level is reached for @ProductID*****'
		end
		
	end
;
go

/* Testing the trigger Products.ReordeLevelReachedTr */
update [Products].[Products]
set [UnitsInStock] = 7
where [ProductID] = 1
;
go

update [Products].[Products]
set [UnitsInStock] = 10
where [ProductID] = 3
;
go


select *
from [Products].[Products]
;
go

/******************* Queries with outer join *******************/

/* Create a query that shows the products that have not been appiered in a order (OrderID = null0 */
select P.ProductID, P.ProductName, OD.OrderID
from [Products].[Products] as P
	left outer join [Sales].[Order Details] as OD
	on P.ProductID = OD.ProductID
where OD.OrderID is null
;
go

/* Create a query that shows a list of employess who have not taken an order */
select E.EmpID, Concat(E.[EmpFirst], ' ', E.[EmpLast]) as 'Employee Name', O.OrderID --P.Title
from [HumanResourses].[Employees] as E 
	left outer join [Sales].[Orders] as O
	on  O.EmpID =  E.EmpID
	--inner join [HumanResourses].[Position] as P 
	--	on E.PositionID = P.PositionID
where  OrderID is null	
;
go

select *
from [Sales].[Orders]
;
go

