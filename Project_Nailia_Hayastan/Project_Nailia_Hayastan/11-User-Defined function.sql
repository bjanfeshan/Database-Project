/* Create User-Defined Function for HayastanJan Database
Script Date: February 23, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/
use HayastanJan
;
go

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

/* Create a function that calculates the cost of each order (total of each row in Order Details) */

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

/*Function Sales.getCustomersFullName */ 
create function Sales.getCustomersFullName
(
	@FirstName as nvarchar(60),
	@LastName as nvarchar(60)
)
returns nvarchar(120)
as
	begin
		declare @FullName as nvarchar(120)
		-- compute the return value
		select @FullName = CONCAT (@FirstName,' ', @LastName)
		-- return the result to the function caller
		return @FullName
	end
;
go











