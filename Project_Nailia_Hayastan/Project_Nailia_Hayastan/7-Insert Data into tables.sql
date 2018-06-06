/* Insert data into HayastanJan Database
Script Date: February 21, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/
use HayastanJan
;
go
/************Table No.1 - Employees **********/
bulk insert HumanResourses.Employees
from 'E:\Nailia_John Abbott\Data Base II\Project Hayastan\DATA - Hyastan Jan\Employees.csv'
with (
	firstrow = 2,
	rowterminator = '\n',
	fieldterminator = '|'
	)
;
go
/************Table No.2 - Position **********/
bulk insert HumanResourses.Position
from 'E:\Nailia_John Abbott\Data Base II\Project Hayastan\DATA - Hyastan Jan\Position.csv'
with (
	firstrow = 2,
	rowterminator = '\n',
	fieldterminator = '|'
	)
;
go
/************Table No.3 - Purchases **********/
bulk insert Products.Purchase
from 'E:\Nailia_John Abbott\Data Base II\Project Hayastan\DATA - Hyastan Jan\Purchases.csv'
with (
	firstrow = 2,
	rowterminator = '\n',
	fieldterminator = '|'
	)
;
go

/**** Table No. 4 - Sales.Customers ******/
bulk insert Sales.Customers
from 'E:\Nailia_John Abbott\Data Base II\Project Hayastan\Data - Hyastan Jan\Customers.csv'             
with (
	firstrow = 2,
	rowterminator = '\n',
	fieldterminator = '|'
	)
;
go
/**** Table No. 5 - Sales.Orders ******/
bulk insert Sales.Orders
from 'E:\Nailia_John Abbott\Data Base II\Project Hayastan\Data - Hyastan Jan\Oreders.csv'             
with (
	firstrow = 2,
	rowterminator = '\n',
	fieldterminator = '|'
	)
;
go
/**** Table No. 6 - Sales.[Order Details] ******/
bulk insert Sales.[Order Details]
from 'E:\Nailia_John Abbott\Data Base II\Project Hayastan\Data - Hyastan Jan\Order Details.csv'                
with (
	firstrow = 2,
	rowterminator = '\n',
	fieldterminator = '|'
	)
;
go

/**** Table No. 7 - Products.Products ******/
bulk insert Products.Products
from 'E:\Nailia_John Abbott\Data Base II\Project Hayastan\Data - Hyastan Jan\Products_Data.csv'             
with (
	firstrow = 2,
	rowterminator = '\n',
	fieldterminator = '|'
	)
;
go

/**** Table No. 8 - Products.Suppliers ******/
bulk insert Products.Suppliers
from 'E:\Nailia_John Abbott\Data Base II\Project Hayastan\Data - Hyastan Jan\Suppliers.csv'             
with (
	firstrow = 2,
	rowterminator = '\n',
	fieldterminator = '|'
	)
;
go

/******** Table No. 9 - Table Category ********/
/* Data are inserted with Importing images in User-Defined Store-Procedures (Script 12) */

/******** Table No. 10 - Table DeliverVia ********/
bulk insert Sales.DeliverVia
from 'E:\Nailia_John Abbott\Data Base II\Project Hayastan\Data - Hyastan Jan\DeliverVia.csv'            
with (
	firstrow = 2,
	rowterminator = '\n',
	fieldterminator = '|'
	)
;
go

