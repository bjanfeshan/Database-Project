/* Create User-Defined Store-Procedures for HayastanJan Database
Script Date: February 26, 2018
Developed by: Shushan, Bita, Nailia, Yohannes
*/
use HayastanJan
;
go

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

