/* Apply Data Integrity to HayastanJan Database
Script Date: February 19, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/
use HayastanJan
;
go

/******** Table No.1 - HumanResourses.Employees **********/
			 -- Foreign keys
/* Between HumanResourses.Employees and HumanResourses.Position */
alter table  HumanResourses.Employees
	add constraint fk_Employees_Position foreign key (PositionID)                 
	references HumanResourses.Position (PositionID)
;
go
			-- Default constraints
/* Set default value 'QC' for Province and 'Canada' for Country columns*/
alter table HumanResourses.Employees
	add constraint df_Province_Employees default 'QC' for [Province]
;
go
alter table HumanResourses.Employees
	add constraint df_Country_Employees default 'Canada' for [Country]
;
go
			-- Check constraint
/* check that HourlyRate column values must be >=0 */
alter table HumanResourses.Employees
	add constraint ck_HourlyRate_Employees check (HourlyRate >=0)
;
go
/* check that date in EndDate column is later then StartDate */
alter table HumanResourses.Employees
	add constraint check_dates check (StartDate < EndDate)
;
go
			-- Unique Constraints
alter table HumanResourses.Employees
	add constraint u_SIN_Employees unique (SIN)
;
go
/************Table No.2 - HumanResourses.Position **********/
-- No extra constraints (only one primary key)

/************Table No.3 - Products.Purchase **********/
				-- Foreign keys
/* 1) Between Products.Purchase and Products.Suppliers */
alter table Products.Purchase
	add constraint fk_Purchase_Suppliers foreign key (SupplierID)
	references Products.Suppliers(SupplierID)
;
go

/* 2) Between Products.Purchase and HumanResourses.Employees */
alter table Products.Purchase
	add constraint fk_Purchase_Employees foreign key (EmpID)
	references HumanResourses.Employees(EmpID)
;
go
/* 3) Between Products.Purchase and Products.Products */
alter table Products.Purchase
	add constraint fk_Purchase_Products foreign key (ProductID)
	references Products.Products(ProductID)
;
go

/**** Table No. 4 - Sales.Customers ******/
-- No foreign key (only one primary key)
				-- Default Constraints
/* Set default value 'QC' for Province and 'Canada' for Country columns*/
alter table Sales.Customers
	add constraint df_Province_Customers default 'QC' for [Province]
;
go

alter table Sales.Customers
	add constraint df_Country_Customers default 'Canada' for [Country]
;
go

/**** Table No. 5 - Sales.Orders ******/
			-- Foreign keys
/* 1.) Between Sales.Orders and HumanResourses.Employees*/
alter table Sales.Orders
add constraint fk_Orders_Employees foreign key (EmpID)
	references HumanResourses.Employees (EmpID)
;
go
/* 2.) Between Sales.Orders and Sales.Customers */
alter table Sales.Orders
add constraint fk_Orders_Customers foreign key (CustomerID)
	references Sales.Customers (CustomerID)
;
go
/* 3.) Between Sales.Orders and Sales.DeliverVia */
alter table Sales.Orders
add constraint fk_Orders_DeliverVia foreign key (DelivererID)
	references Sales.DeliverVia (DelivererID)
;
go

					-- Default Constraints
/* Set default value 'QC' for ToProvince and 'Canada' for ToCountry columns*/
alter table Sales.Orders
	add constraint df_ToProvince_OrderDetails default 'QC' for [ToProvince]
;
go

alter table Sales.Orders
	add constraint df_ToCountry_OrderDetails default 'Canada' for [ToCountry]
;
go
					-- Check constraints
/* check that OrderDate <= RequiredDate*/
alter table Sales.Orders
	add constraint check_RequiredDates check (OrderDate <= RequiredDate)
;
go

/* check that RequiredDate <= DeliveryDate*/
alter table Sales.Orders
	add constraint check_DeliveryDates check (RequiredDate <= DeliveryDate)
;
go

/**** Table No. 6 - Sales.[Order Details] ******/
				-- Foreign keys
/* 1.) Between Sales.Order Details and Sales.Orders */
alter table Sales.[Order Details]
add constraint fk_Order_Details_Orders foreign key (OrderID)
	references Sales.Orders (OrderID)
;
go

/* 2.) Between Sales.Order Details and Products.Products */
alter table Sales.[Order Details]
add constraint fk_Order_Details_Products foreign key (ProductID)
	references Products.Products (ProductID)
;
go

/**** Table No. 7 - Products.Products ******/
				-- Foreign keys
/* 1) Between Products.Products and Products.Suppliers */
alter table Products.Products
	add constraint fk_Products_Suppliers foreign key (SupplierID)
	references Products.Suppliers(SupplierID)
;
go
/* 2) Between Products.Products and Products.Category */
alter table Products.Products
	add constraint fk_Products_Category foreign key (CategoryID)
	references Products.Category(CategoryID)
;
go

/**** Table No. 8 - Products.Suppliers ******/
			-- Unique Constraints
alter table Products.Suppliers
	add constraint u_CompanyName_Suppliers unique (CompanyName) 
;
go

 /******** Table No. 9 - Table Category ********/
				-- Foreign keys
-- No extra constraints (only one primary key)

/******** Table No. 10 - Table DeliverVia ********/
			-- Unique Constraints
alter table Sales.DeliverVia
	add constraint u_CompanyName_DeliverVia unique (CompanyName) 
;
go




