/* Create Tables for HayastanJan Database
Script Date: February 19, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/
use HayastanJan
;
go

/************Table No.1 - Employees **********/
 create table HumanResourses.Employees
 (
	EmpID int identity(1,1) not null,
	EmpFirst nvarchar(15) not null,
	EmpLast nvarchar(25) not null,
	PositionID nvarchar(4) not null, -- foreign key (HumanResourses.Position)
	SIN nchar(9) not null,
	DOB date null,        
	StartDate date not null,
	EndDate date null,
	Address myAddress,
	City nvarchar(24) not null,
	Province nchar(2) not null,
	PostalCode nvarchar(7) not null,
	Country nvarchar(25) null,
	Phone nvarchar(24)null,	
	Cell nvarchar(24) null,
	HourlyRate smallint not null,
	Notes nvarchar(250) null,
	constraint pk_Employees primary key clustered (EmpID asc)
 )
 ;
 go

 /************Table No.2 - Position **********/
 create table HumanResourses.Position
 (
	PositionID nvarchar(4) not null,
	Title nvarchar(15) not null,
	constraint pk_Position primary key clustered (PositionID asc)
 )
 ; 
 go

 /************Table No.3 - Purchases **********/
 create table Products.Purchase
 (
	PurchaseID int identity(1,1) not null,
	SupplierID int not null,                     -- foreign key (Products.Suppliers)
	EmpID int not null,							 -- foreign key (HumanResourses.Employees)
	ProductID int not null,						 -- foreign key (Products.Products)
	PurchaseDate datetime not null,
	Quantity int not null,
	constraint pk_Purchase primary key clustered (PurchaseID asc)
 )
 ;
 go
 
 /************Shushan***********/
 /**** Table No. 4 - Sales.Customers ******/
create table Sales.Customers
(
	CustomerID int identity(1,1) not null ,
	CustomerFirst nvarchar(40) not null,
	CustomerLast nvarchar(40) not null,	
	Address myAddress,
	City nvarchar(24) not null,
	Province nchar(2) not null,
	PostalCode nvarchar(7) not null,
	Country nvarchar(25) null,
	Phone nvarchar(24)null,	
	Email nvarchar(30) null,
	constraint pk_Customers primary key clustered (CustomerID asc)
)
;
go

/**** Table No. 5 - Sales.Orders ******/
create table Sales.Orders
(
	OrderID int identity(1,1) not null,
	CustomerID int not null, 			-- foreign key (Sales.Customers)
	EmpID int not null, 			-- foreign key (HumanResourses.Employees)
	RequireDelivery bit not null,
	DelivererID int null,
	DeliveryCost money null,
	OrderDate datetime  not null,
	RequiredDate  datetime  null,
	DeliveryDate datetime  null,	
	ToAddress myAddress,
	ToCity nvarchar(24) not null,
	ToProvince nchar(2) not null,	
	PostalCode nvarchar(7) null,
	ToCountry nvarchar(25) null,
	constraint pk_Orders primary key clustered (OrderID asc)
)
;
go

/**** Table No. 6 - Sales.[Order Details] ******/
create table Sales.[Order Details]
(
	OrderID int not null,			-- foreign key (Sales.Orders)               
	ProductID int not null,			-- foreign key (Products.Product)
	SellingPrice money not null,
	Quantity smallint not null,
	Discount real null,
	constraint pk_Order_Details primary key clustered 
		(
		OrderID asc,
		ProductID asc
		)
)
;
go

  /********Yohannes*******/
/**** Table No. 7 - Products.Products ******/

  create table Products.Products
  (
	  ProductID int IDENTITY (1,1) not null,
	  SupplierID int not null, --primary  key
	  ProductName nvarchar(40) not null, --foreign key
	  CategoryID int not null , --foreign key
	  UnitMesure nvarchar(6) null,
	  QuantityPerUnit smallint not null,
	  UnitPrice money not null, 
	  UnitsInStock decimal(7,2) null,
	  Reorderlevel smallint null,	
	  Discontinued  bit  not null,
	  Description nvarchar(100) null, 
	  constraint pk_Products primary key clustered (ProductID asc)
	)
  ;
  go

  /**** Table No. 8 - Products.Suppliers ******/
  create table Products.Suppliers
   (
	SupplierID int IDENTITY (1,1) not null, --primary  key
	CompanyName nvarchar (30) not null,
	ContactName nvarchar(40) null,
	ContactTitle  nvarchar(30) null,
	Address myAddress,
	City nvarchar(24) not null,
	Province nchar(2) not null,
	PostalCode nvarchar(7) not null,
	Country nvarchar(25) null,
	Phone nvarchar(24)null,	 
	Fax nvarchar(24) null,
	Email nvarchar(50) null,
	Note nvarchar(250) null,
	constraint pk_Suppliers primary key clustered (SupplierID asc)
	)
  ;
 go
 
 /*************Bita***************/
 /******** Table No. 9 - Table Category ********/
create table Products.Category
(
	CategoryID int identity(1, 1) not null,
	CategoryName nvarchar(40) not null,
	Description nvarchar(250) null,
	Picture varbinary(max) null,	
	constraint pk_Category primary key clustered (CategoryID asc)	
)
;
go

/******** Table No. 10 - Table DeliverVia ********/

create table Sales.DeliverVia
(
	DelivererID int identity(1, 1) not null,
	CompanyName nvarchar(60) not null,
	Phone nvarchar(24)null,	
	constraint pk_DeliverVia primary key clustered (DelivererID asc)	
)
;
go
